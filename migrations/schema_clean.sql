--
-- PostgreSQL database dump
--

-- Dumped from database version 15.8
-- Dumped by pg_dump version 17.5 (Debian 17.5-1.pgdg120+1)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: public; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA public;


--
-- Name: mr_payment_status; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.mr_payment_status AS ENUM (
    'Pending',
    'Paid',
    'Partial'
);


--
-- Name: target_period_type; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.target_period_type AS ENUM (
    'Monthly',
    'Quarterly',
    'Yearly'
);


--
-- Name: user_role; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.user_role AS ENUM (
    'admin',
    'user',
    'mr'
);


--
-- Name: calculate_closing_stock(uuid, uuid, text, text, date); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.calculate_closing_stock(p_product_id uuid, p_batch_id uuid, p_location_type text, p_location_id text, p_report_date date) RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE
    v_closing_stock INTEGER;
BEGIN
    SELECT COALESCE(
        SUM(
            CASE 
                WHEN transaction_type = 'STOCK_IN_GODOWN' THEN quantity_strips
                WHEN transaction_type IN ('SALE_DIRECT_GODOWN', 'SALE_BY_MR') THEN -quantity_strips
                WHEN transaction_type LIKE 'RETURN_TO_%' THEN quantity_strips
                WHEN transaction_type LIKE 'ADJUST_%' THEN -quantity_strips
                ELSE 0
            END
        ),
        0
    ) INTO v_closing_stock
    FROM public.stock_transactions_view
    WHERE product_id = p_product_id
    AND batch_id = p_batch_id
    AND (
        (location_type_source = p_location_type AND location_id_source = p_location_id)
        OR
        (location_type_destination = p_location_type AND location_id_destination = p_location_id)
    )
    AND transaction_date <= p_report_date;

    RETURN GREATEST(0, v_closing_stock);
END;
$$;


--
-- Name: create_mr_sale(text, jsonb, numeric, text); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.create_mr_sale(p_customer_name text, p_items jsonb, p_total_amount numeric, p_notes text DEFAULT ''::text) RETURNS uuid
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
DECLARE
    v_order_id UUID;
    v_mr_user_id UUID;
    v_item JSONB;
BEGIN
    -- Get the current user's ID (must be an MR)
    SELECT user_id INTO v_mr_user_id 
    FROM public.profiles 
    WHERE user_id = auth.uid() AND role = 'mr';
    
    IF v_mr_user_id IS NULL THEN
        RAISE EXCEPTION 'User must be an MR to create sales orders';
    END IF;

    -- Create the sales order header
    INSERT INTO public.mr_sales_orders (
        mr_user_id,
        customer_name,
        total_amount,
        notes
    ) VALUES (
        v_mr_user_id,
        p_customer_name,
        p_total_amount,
        p_notes
    ) RETURNING id INTO v_order_id;

    -- Insert each item
    FOR v_item IN SELECT * FROM jsonb_array_elements(p_items)
    LOOP
        INSERT INTO public.mr_sales_order_items (
            order_id,
            product_id,
            batch_id,
            quantity_strips_sold,
            price_per_strip
        ) VALUES (
            v_order_id,
            (v_item->>'product_id')::UUID,
            (v_item->>'batch_id')::UUID,
            (v_item->>'quantity_strips_sold')::INTEGER,
            (v_item->>'price_per_strip')::DECIMAL(10,2)
        );
        
        -- Update stock by reducing the quantity sold
        -- This assumes there's a stock tracking mechanism
        -- You may need to adjust this based on your stock management system
        UPDATE public.mr_stock_summary 
        SET current_quantity_strips = current_quantity_strips - (v_item->>'quantity_strips_sold')::INTEGER
        WHERE product_id = (v_item->>'product_id')::UUID 
        AND batch_id = (v_item->>'batch_id')::UUID
        AND mr_user_id = v_mr_user_id;
    END LOOP;

    RETURN v_order_id;
END;
$$;


--
-- Name: create_product_with_auto_code(text, text, text, uuid, uuid, uuid, text, numeric, boolean, text, text, integer, integer, integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.create_product_with_auto_code(p_product_name text, p_generic_name text, p_manufacturer text, p_category_id uuid, p_formulation_id uuid, p_sub_category_id uuid DEFAULT NULL::uuid, p_unit_of_measure_smallest text DEFAULT 'Strip'::text, p_base_cost_per_strip numeric DEFAULT 0, p_is_active boolean DEFAULT true, p_storage_conditions text DEFAULT NULL::text, p_image_url text DEFAULT NULL::text, p_min_stock_level_godown integer DEFAULT 0, p_min_stock_level_mr integer DEFAULT 0, p_lead_time_days integer DEFAULT 0) RETURNS TABLE(id uuid, product_code text, product_name text, generic_name text, manufacturer text, category_id uuid, sub_category_id uuid, formulation_id uuid, unit_of_measure_smallest text, base_cost_per_strip numeric, is_active boolean, storage_conditions text, image_url text, min_stock_level_godown integer, min_stock_level_mr integer, lead_time_days integer, created_at timestamp with time zone, updated_at timestamp with time zone)
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
DECLARE
  v_last_code TEXT;
  v_next_code TEXT;
  v_last_number INTEGER;
  v_next_number INTEGER;
  v_new_product RECORD;
  v_max_retries INTEGER := 5;
  v_retry_count INTEGER := 0;
BEGIN
  -- Loop to handle potential race conditions
  LOOP
    BEGIN
      -- Get the last product code with MAP prefix in a single query
      SELECT products.product_code INTO v_last_code
      FROM public.products
      WHERE products.product_code LIKE 'MAP%'
      ORDER BY products.product_code DESC
      LIMIT 1
      FOR UPDATE; -- Lock to prevent concurrent reads
      
      -- Generate next code
      IF v_last_code IS NULL THEN
        v_next_code := 'MAP00001';
      ELSE
        -- Extract number part and increment
        v_last_number := CAST(SUBSTRING(v_last_code FROM 4) AS INTEGER);
        v_next_number := v_last_number + 1;
        v_next_code := 'MAP' || LPAD(v_next_number::TEXT, 5, '0');
      END IF;
      
      -- Insert the new product
      INSERT INTO public.products (
        product_code,
        product_name,
        generic_name,
        manufacturer,
        category_id,
        sub_category_id,
        formulation_id,
        unit_of_measure_smallest,
        base_cost_per_strip,
        is_active,
        storage_conditions,
        image_url,
        min_stock_level_godown,
        min_stock_level_mr,
        lead_time_days
      ) VALUES (
        v_next_code,
        p_product_name,
        p_generic_name,
        p_manufacturer,
        p_category_id,
        p_sub_category_id,
        p_formulation_id,
        p_unit_of_measure_smallest,
        p_base_cost_per_strip,
        p_is_active,
        p_storage_conditions,
        p_image_url,
        p_min_stock_level_godown,
        p_min_stock_level_mr,
        p_lead_time_days
      )
      RETURNING * INTO v_new_product;
      
      -- If we get here, the insert was successful, exit the loop
      EXIT;
      
    EXCEPTION
      WHEN unique_violation THEN
        -- If there's a unique constraint violation on product_code, retry
        v_retry_count := v_retry_count + 1;
        IF v_retry_count >= v_max_retries THEN
          RAISE EXCEPTION 'Failed to generate unique product code after % retries', v_max_retries;
        END IF;
        -- Continue the loop to try again
    END;
  END LOOP;
  
  -- Return the created product
  RETURN QUERY
  SELECT 
    v_new_product.id,
    v_new_product.product_code,
    v_new_product.product_name,
    v_new_product.generic_name,
    v_new_product.manufacturer,
    v_new_product.category_id,
    v_new_product.sub_category_id,
    v_new_product.formulation_id,
    v_new_product.unit_of_measure_smallest,
    v_new_product.base_cost_per_strip,
    v_new_product.is_active,
    v_new_product.storage_conditions,
    v_new_product.image_url,
    v_new_product.min_stock_level_godown,
    v_new_product.min_stock_level_mr,
    v_new_product.lead_time_days,
    v_new_product.created_at,
    v_new_product.updated_at;
END;
$$;


--
-- Name: execute_safe_query(text); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.execute_safe_query(query_text text) RETURNS TABLE(result jsonb)
    LANGUAGE plpgsql SECURITY DEFINER
    AS $_$
DECLARE
    clean_query TEXT;
    result_record RECORD;
    result_array JSONB := '[]'::JSONB;
BEGIN
    -- Clean and validate the query
    clean_query := TRIM(query_text);
    
    -- Security check: Only allow SELECT statements
    IF NOT (UPPER(clean_query) LIKE 'SELECT%') THEN
        RAISE EXCEPTION 'Only SELECT queries are allowed';
    END IF;
    
    -- Additional security: Block dangerous keywords
    IF UPPER(clean_query) ~ '(DROP|DELETE|UPDATE|INSERT|ALTER|CREATE|TRUNCATE|GRANT|REVOKE)' THEN
        RAISE EXCEPTION 'Query contains prohibited keywords';
    END IF;
    
    -- Limit query complexity (basic check)
    IF LENGTH(clean_query) > 2000 THEN
        RAISE EXCEPTION 'Query too long';
    END IF;
    
    -- Execute the query and return results as JSONB
    FOR result_record IN EXECUTE clean_query LOOP
        result_array := result_array || to_jsonb(result_record);
    END LOOP;
    
    -- Limit result size
    IF jsonb_array_length(result_array) > 100 THEN
        result_array := jsonb_path_query_array(result_array, '$[0 to 99]');
    END IF;
    
    RETURN QUERY SELECT result_array;
END;
$_$;


--
-- Name: handle_new_user(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.handle_new_user() RETURNS trigger
    LANGUAGE plpgsql SECURITY DEFINER
    SET search_path TO ''
    AS $$
BEGIN
  INSERT INTO public.profiles (user_id, name, email, role)
  VALUES (
    new.id,
    COALESCE(new.raw_user_meta_data ->> 'name', ''),
    new.email,
    'user'::public.user_role
  );
  RETURN new;
EXCEPTION
  WHEN OTHERS THEN
    -- Log the error but don't block user creation
    RAISE LOG 'Error creating profile for user %: %', new.id, SQLERRM;
    RETURN new;
END;
$$;


--
-- Name: is_admin(uuid); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.is_admin(user_uuid uuid) RETURNS boolean
    LANGUAGE sql SECURITY DEFINER
    AS $$
  SELECT EXISTS (
    SELECT 1 FROM public.profiles 
    WHERE user_id = user_uuid AND role = 'admin'
  );
$$;


--
-- Name: recalculate_closing_stock_reports(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.recalculate_closing_stock_reports() RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
    -- Clear existing reports
    TRUNCATE public.closing_stock_report;
    
    -- Recalculate for each unique combination
    WITH location_transactions AS (
        -- Godown transactions
        SELECT 
            product_id,
            batch_id,
            'GODOWN' as location_type,
            NULL as location_id,
            transaction_type,
            CASE 
                WHEN transaction_type = 'STOCK_IN_GODOWN' THEN quantity_strips
                WHEN transaction_type IN ('SALE_DIRECT_GODOWN', 'SALE_BY_MR') THEN quantity_strips
                WHEN transaction_type LIKE 'RETURN_TO_%' THEN quantity_strips
                WHEN transaction_type LIKE 'ADJUST_%' THEN quantity_strips
                ELSE 0
            END as quantity,
            cost_per_strip_at_transaction
        FROM public.stock_transactions_view
        WHERE (location_type_source = 'GODOWN' OR location_type_destination = 'GODOWN')
        
        UNION ALL
        
        -- MR transactions
        SELECT 
            product_id,
            batch_id,
            'MR' as location_type,
            CASE 
                WHEN location_type_source = 'MR' THEN location_id_source
                WHEN location_type_destination = 'MR' THEN location_id_destination
            END as location_id,
            transaction_type,
            CASE 
                WHEN transaction_type = 'DISPATCH_TO_MR' THEN quantity_strips
                WHEN transaction_type = 'SALE_BY_MR' THEN quantity_strips
                WHEN transaction_type LIKE 'RETURN_TO_%' THEN quantity_strips
                WHEN transaction_type LIKE 'ADJUST_%' THEN quantity_strips
                ELSE 0
            END as quantity,
            cost_per_strip_at_transaction
        FROM public.stock_transactions_view
        WHERE (location_type_source = 'MR' OR location_type_destination = 'MR')
        AND (location_id_source IS NOT NULL OR location_id_destination IS NOT NULL)
    ),
    stock_calculations AS (
        SELECT 
            product_id,
            batch_id,
            location_type,
            location_id,
            -- Opening stock (from previous day's closing)
            COALESCE((
                SELECT closing_quantity_strips 
                FROM public.closing_stock_report 
                WHERE product_id = lt.product_id 
                AND batch_id = lt.batch_id 
                AND location_type = lt.location_type 
                AND location_id = lt.location_id 
                AND report_date < CURRENT_DATE 
                ORDER BY report_date DESC 
                LIMIT 1
            ), 0) as opening_quantity,
            -- Purchases (positive)
            SUM(CASE WHEN transaction_type = 'STOCK_IN_GODOWN' THEN quantity ELSE 0 END) as purchase_quantity,
            -- Sales (negative)
            SUM(CASE WHEN transaction_type IN ('SALE_DIRECT_GODOWN', 'SALE_BY_MR') THEN quantity ELSE 0 END) as sale_quantity,
            -- Returns (negative)
            SUM(CASE WHEN transaction_type LIKE 'RETURN_TO_%' THEN quantity ELSE 0 END) as return_quantity,
            -- Adjustments (negative)
            SUM(CASE WHEN transaction_type LIKE 'ADJUST_%' THEN quantity ELSE 0 END) as adjustment_quantity,
            -- Calculate closing stock
            COALESCE((
                SELECT closing_quantity_strips 
                FROM public.closing_stock_report 
                WHERE product_id = lt.product_id 
                AND batch_id = lt.batch_id 
                AND location_type = lt.location_type 
                AND location_id = lt.location_id 
                AND report_date < CURRENT_DATE 
                ORDER BY report_date DESC 
                LIMIT 1
            ), 0) + 
            SUM(CASE WHEN transaction_type = 'STOCK_IN_GODOWN' THEN quantity ELSE 0 END) -
            SUM(CASE WHEN transaction_type IN ('SALE_DIRECT_GODOWN', 'SALE_BY_MR') THEN quantity ELSE 0 END) -
            SUM(CASE WHEN transaction_type LIKE 'RETURN_TO_%' THEN quantity ELSE 0 END) -
            SUM(CASE WHEN transaction_type LIKE 'ADJUST_%' THEN quantity ELSE 0 END) as closing_quantity,
            AVG(cost_per_strip_at_transaction) as avg_cost,
            SUM(cost_per_strip_at_transaction * quantity) as total_value
        FROM location_transactions lt
        GROUP BY product_id, batch_id, location_type, location_id
        HAVING (
            COALESCE((
                SELECT closing_quantity_strips 
                FROM public.closing_stock_report 
                WHERE product_id = lt.product_id 
                AND batch_id = lt.batch_id 
                AND location_type = lt.location_type 
                AND location_id = lt.location_id 
                AND report_date < CURRENT_DATE 
                ORDER BY report_date DESC 
                LIMIT 1
            ), 0) + 
            SUM(CASE WHEN transaction_type = 'STOCK_IN_GODOWN' THEN quantity ELSE 0 END) -
            SUM(CASE WHEN transaction_type IN ('SALE_DIRECT_GODOWN', 'SALE_BY_MR') THEN quantity ELSE 0 END) -
            SUM(CASE WHEN transaction_type LIKE 'RETURN_TO_%' THEN quantity ELSE 0 END) -
            SUM(CASE WHEN transaction_type LIKE 'ADJUST_%' THEN quantity ELSE 0 END)
        ) >= 0
    )
    INSERT INTO public.closing_stock_report (
        product_id,
        batch_id,
        location_type,
        location_id,
        report_date,
        opening_quantity_strips,
        purchase_quantity_strips,
        sale_quantity_strips,
        return_quantity_strips,
        adjustment_quantity_strips,
        closing_quantity_strips,
        cost_per_strip,
        total_value
    )
    SELECT 
        product_id,
        batch_id,
        location_type,
        location_id,
        CURRENT_DATE,
        opening_quantity,
        purchase_quantity,
        sale_quantity,
        return_quantity,
        adjustment_quantity,
        closing_quantity,
        avg_cost,
        total_value
    FROM stock_calculations;
END;
$$;


--
-- Name: recalculate_mr_stock_summary_with_prices(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.recalculate_mr_stock_summary_with_prices() RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
  -- Clear existing data
  TRUNCATE public.mr_stock_summary;
  
  -- Recalculate from all transactions with prices
  INSERT INTO public.mr_stock_summary (
    mr_user_id,
    product_id,
    batch_id,
    current_quantity_strips,
    price_per_strip,
    last_updated_at
  )
  WITH mr_transactions AS (
    SELECT 
      CASE 
        WHEN location_type_destination = 'MR' THEN location_id_destination::UUID
        WHEN location_type_source = 'MR' THEN location_id_source::UUID
      END as mr_user_id,
      product_id,
      batch_id,
      CASE 
        WHEN location_type_destination = 'MR' THEN quantity_strips
        WHEN location_type_source = 'MR' THEN -quantity_strips
        ELSE 0
      END as quantity_change,
      cost_per_strip_at_transaction,
      transaction_date,
      created_at
    FROM public.stock_transactions_view
    WHERE (location_type_destination = 'MR' OR location_type_source = 'MR')
    AND (location_id_destination IS NOT NULL OR location_id_source IS NOT NULL)
  ),
  stock_calculations AS (
    SELECT 
      mr_user_id,
      product_id,
      batch_id,
      SUM(quantity_change) as total_quantity,
      -- Get the latest cost per strip for this combination
      (ARRAY_AGG(cost_per_strip_at_transaction ORDER BY transaction_date DESC, created_at DESC))[1] as latest_cost
    FROM mr_transactions
    WHERE mr_user_id IS NOT NULL
    GROUP BY mr_user_id, product_id, batch_id
    HAVING SUM(quantity_change) > 0
  )
  SELECT 
    mr_user_id,
    product_id,
    batch_id,
    total_quantity,
    COALESCE(latest_cost, 0.00),
    now()
  FROM stock_calculations;
  
  RAISE NOTICE 'MR stock summary recalculated with prices successfully';
END;
$$;


--
-- Name: recalculate_products_stock_status(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.recalculate_products_stock_status() RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
  -- Clear existing data
  TRUNCATE public.products_stock_status;
  
  -- Recalculate from all transactions
  INSERT INTO public.products_stock_status (
    product_id,
    batch_id,
    location_type,
    location_id,
    current_quantity_strips,
    cost_per_strip,
    last_updated_at
  )
  WITH stock_calculations AS (
    SELECT 
      product_id,
      batch_id,
      location_type,
      location_id,
      SUM(quantity_change) as total_quantity,
      -- Get the latest cost per strip for positive quantities
      (ARRAY_AGG(cost_per_strip_at_transaction ORDER BY created_at DESC))[1] as latest_cost
    FROM (
      -- Destination transactions (incoming stock)
      SELECT 
        product_id,
        batch_id,
        location_type_destination as location_type,
        location_id_destination as location_id,
        CASE 
          WHEN transaction_type LIKE '%STOCK_IN%' OR 
               transaction_type LIKE '%RETURN%' OR
               transaction_type LIKE '%REPLACEMENT_IN%' THEN quantity_strips
          ELSE 0
        END as quantity_change,
        cost_per_strip_at_transaction,
        created_at
      FROM public.stock_transactions
      WHERE location_type_destination IS NOT NULL 
        AND location_id_destination IS NOT NULL
      
      UNION ALL
      
      -- Source transactions (outgoing stock)
      SELECT 
        product_id,
        batch_id,
        location_type_source as location_type,
        location_id_source as location_id,
        CASE 
          WHEN transaction_type LIKE '%DISPATCH%' OR 
               transaction_type LIKE '%SALE%' OR
               transaction_type LIKE '%DAMAGE%' OR
               transaction_type LIKE '%LOSS%' OR
               transaction_type LIKE '%REPLACEMENT_OUT%' THEN -ABS(quantity_strips)
          ELSE 0
        END as quantity_change,
        cost_per_strip_at_transaction,
        created_at
      FROM public.stock_transactions
      WHERE location_type_source IS NOT NULL 
        AND location_id_source IS NOT NULL
    ) all_transactions
    WHERE quantity_change != 0
    GROUP BY product_id, batch_id, location_type, location_id
    HAVING SUM(quantity_change) > 0
  )
  SELECT 
    product_id,
    batch_id,
    location_type,
    location_id,
    total_quantity,
    latest_cost,
    now()
  FROM stock_calculations;
  
  RAISE NOTICE 'Stock status recalculated successfully';
END;
$$;


--
-- Name: update_closing_stock_report(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.update_closing_stock_report() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
    v_report_date DATE := CURRENT_DATE;
    v_old_quantity INTEGER;
    v_new_quantity INTEGER;
    v_transaction_type TEXT;
    v_location_type TEXT;
    v_location_id TEXT;
    v_quantity INTEGER;
BEGIN
    -- Determine transaction type and location
    IF TG_TABLE_NAME = 'stock_purchases' THEN
        v_transaction_type := 'STOCK_IN_GODOWN';
        v_location_type := 'GODOWN';
        v_location_id := NULL;
        v_quantity := NEW.quantity_strips;
    ELSIF TG_TABLE_NAME = 'stock_sales' THEN
        v_transaction_type := NEW.transaction_type;
        v_quantity := NEW.quantity_strips;
        
        -- Handle source location (decrease)
        IF NEW.location_type_source = 'GODOWN' THEN
            v_location_type := 'GODOWN';
            v_location_id := NULL;
        ELSIF NEW.location_type_source = 'MR' THEN
            v_location_type := 'MR';
            v_location_id := NEW.location_id_source;
        END IF;
        
        -- Handle destination location (increase for returns)
        IF NEW.transaction_type LIKE 'RETURN_TO_%' THEN
            IF NEW.location_type_destination = 'GODOWN' THEN
                v_location_type := 'GODOWN';
                v_location_id := NULL;
            ELSIF NEW.location_type_destination = 'MR' THEN
                v_location_type := 'MR';
                v_location_id := NEW.location_id_destination;
            END IF;
        END IF;
    END IF;

    -- Update or insert closing stock record
    INSERT INTO public.closing_stock_report (
        product_id,
        batch_id,
        location_type,
        location_id,
        report_date,
        opening_quantity_strips,
        purchase_quantity_strips,
        sale_quantity_strips,
        return_quantity_strips,
        adjustment_quantity_strips,
        closing_quantity_strips,
        cost_per_strip,
        total_value
    )
    VALUES (
        NEW.product_id,
        NEW.batch_id,
        v_location_type,
        v_location_id,
        v_report_date,
        COALESCE((
            SELECT closing_quantity_strips 
            FROM public.closing_stock_report 
            WHERE product_id = NEW.product_id 
            AND batch_id = NEW.batch_id 
            AND location_type = v_location_type 
            AND location_id = v_location_id 
            AND report_date < v_report_date 
            ORDER BY report_date DESC 
            LIMIT 1
        ), 0),
        CASE WHEN v_transaction_type = 'STOCK_IN_GODOWN' THEN v_quantity ELSE 0 END,
        CASE WHEN v_transaction_type IN ('SALE_DIRECT_GODOWN', 'SALE_BY_MR') THEN v_quantity ELSE 0 END,
        CASE WHEN v_transaction_type LIKE 'RETURN_TO_%' THEN v_quantity ELSE 0 END,
        CASE WHEN v_transaction_type LIKE 'ADJUST_%' THEN v_quantity ELSE 0 END,
        public.calculate_closing_stock(NEW.product_id, NEW.batch_id, v_location_type, v_location_id, v_report_date),
        NEW.cost_per_strip,
        NEW.cost_per_strip * v_quantity
    )
    ON CONFLICT (product_id, batch_id, location_type, location_id, report_date)
    DO UPDATE SET
        opening_quantity_strips = EXCLUDED.opening_quantity_strips,
        purchase_quantity_strips = EXCLUDED.purchase_quantity_strips,
        sale_quantity_strips = EXCLUDED.sale_quantity_strips,
        return_quantity_strips = EXCLUDED.return_quantity_strips,
        adjustment_quantity_strips = EXCLUDED.adjustment_quantity_strips,
        closing_quantity_strips = EXCLUDED.closing_quantity_strips,
        cost_per_strip = EXCLUDED.cost_per_strip,
        total_value = EXCLUDED.total_value,
        last_updated_at = now();

    RETURN NEW;
END;
$$;


--
-- Name: update_mr_stock_summary(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.update_mr_stock_summary() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  -- Only process transactions that affect MR stock
  IF NEW.location_type_destination = 'MR' OR NEW.location_type_source = 'MR' THEN
    
    -- Handle MR as destination (stock increase)
    IF NEW.location_type_destination = 'MR' AND NEW.location_id_destination IS NOT NULL THEN
      INSERT INTO public.mr_stock_summary (mr_user_id, product_id, batch_id, current_quantity_strips, price_per_strip, last_updated_at)
      VALUES (NEW.location_id_destination::UUID, NEW.product_id, NEW.batch_id, NEW.quantity_strips, NEW.cost_per_strip, now())
      ON CONFLICT (mr_user_id, product_id, batch_id)
      DO UPDATE SET 
        current_quantity_strips = mr_stock_summary.current_quantity_strips + NEW.quantity_strips,
        price_per_strip = NEW.cost_per_strip,
        last_updated_at = now();
    END IF;
    
    -- Handle MR as source (stock decrease)
    IF NEW.location_type_source = 'MR' AND NEW.location_id_source IS NOT NULL THEN
      INSERT INTO public.mr_stock_summary (mr_user_id, product_id, batch_id, current_quantity_strips, price_per_strip, last_updated_at)
      VALUES (NEW.location_id_source::UUID, NEW.product_id, NEW.batch_id, -NEW.quantity_strips, NEW.cost_per_strip, now())
      ON CONFLICT (mr_user_id, product_id, batch_id)
      DO UPDATE SET 
        current_quantity_strips = mr_stock_summary.current_quantity_strips - NEW.quantity_strips,
        price_per_strip = NEW.cost_per_strip,
        last_updated_at = now();
    END IF;
    
  END IF;
  
  RETURN NEW;
END;
$$;


--
-- Name: update_mr_stock_summary_from_adjustments(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.update_mr_stock_summary_from_adjustments() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  -- Handle MR as destination (stock increase)
  IF NEW.location_type_destination = 'MR' AND NEW.location_id_destination IS NOT NULL THEN
    INSERT INTO public.mr_stock_summary (mr_user_id, product_id, batch_id, current_quantity_strips, price_per_strip, last_updated_at)
    VALUES (NEW.location_id_destination::UUID, NEW.product_id, NEW.batch_id, NEW.quantity_strips, NEW.cost_per_strip, now())
    ON CONFLICT (mr_user_id, product_id, batch_id)
    DO UPDATE SET 
      current_quantity_strips = mr_stock_summary.current_quantity_strips + NEW.quantity_strips,
      price_per_strip = NEW.cost_per_strip,
      last_updated_at = now();
  END IF;
  
  -- Handle MR as source (stock decrease)
  IF NEW.location_type_source = 'MR' AND NEW.location_id_source IS NOT NULL THEN
    INSERT INTO public.mr_stock_summary (mr_user_id, product_id, batch_id, current_quantity_strips, price_per_strip, last_updated_at)
    VALUES (NEW.location_id_source::UUID, NEW.product_id, NEW.batch_id, -NEW.quantity_strips, NEW.cost_per_strip, now())
    ON CONFLICT (mr_user_id, product_id, batch_id)
    DO UPDATE SET 
      current_quantity_strips = mr_stock_summary.current_quantity_strips - NEW.quantity_strips,
      price_per_strip = NEW.cost_per_strip,
      last_updated_at = now();
  END IF;
  
  RETURN NEW;
END;
$$;


--
-- Name: update_mr_stock_summary_from_sales(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.update_mr_stock_summary_from_sales() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  -- Handle MR as destination (stock increase)
  IF NEW.location_type_destination = 'MR' AND NEW.location_id_destination IS NOT NULL THEN
    INSERT INTO public.mr_stock_summary (mr_user_id, product_id, batch_id, current_quantity_strips, price_per_strip, last_updated_at)
    VALUES (NEW.location_id_destination::UUID, NEW.product_id, NEW.batch_id, NEW.quantity_strips, NEW.cost_per_strip, now())
    ON CONFLICT (mr_user_id, product_id, batch_id)
    DO UPDATE SET 
      current_quantity_strips = mr_stock_summary.current_quantity_strips + NEW.quantity_strips,
      price_per_strip = NEW.cost_per_strip,
      last_updated_at = now();
  END IF;
  
  -- Handle MR as source (stock decrease)
  IF NEW.location_type_source = 'MR' AND NEW.location_id_source IS NOT NULL THEN
    INSERT INTO public.mr_stock_summary (mr_user_id, product_id, batch_id, current_quantity_strips, price_per_strip, last_updated_at)
    VALUES (NEW.location_id_source::UUID, NEW.product_id, NEW.batch_id, -NEW.quantity_strips, NEW.cost_per_strip, now())
    ON CONFLICT (mr_user_id, product_id, batch_id)
    DO UPDATE SET 
      current_quantity_strips = mr_stock_summary.current_quantity_strips - NEW.quantity_strips,
      price_per_strip = NEW.cost_per_strip,
      last_updated_at = now();
  END IF;
  
  RETURN NEW;
END;
$$;


--
-- Name: update_products_stock_status(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.update_products_stock_status() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  -- Process destination location (incoming stock - positive quantities)
  IF NEW.location_type_destination IS NOT NULL AND NEW.location_id_destination IS NOT NULL THEN
    INSERT INTO public.products_stock_status (
      product_id, 
      batch_id, 
      location_type, 
      location_id, 
      current_quantity_strips, 
      cost_per_strip,
      last_updated_at
    )
    VALUES (
      NEW.product_id,
      NEW.batch_id,
      NEW.location_type_destination,
      NEW.location_id_destination,
      NEW.quantity_strips, -- Use quantity as is for destination
      NEW.cost_per_strip_at_transaction,
      now()
    )
    ON CONFLICT (product_id, batch_id, location_type, location_id)
    DO UPDATE SET
      current_quantity_strips = products_stock_status.current_quantity_strips + NEW.quantity_strips,
      cost_per_strip = NEW.cost_per_strip_at_transaction,
      last_updated_at = now();
  END IF;

  -- Process source location (outgoing stock - negative quantities)
  IF NEW.location_type_source IS NOT NULL AND NEW.location_id_source IS NOT NULL THEN
    INSERT INTO public.products_stock_status (
      product_id, 
      batch_id, 
      location_type, 
      location_id, 
      current_quantity_strips, 
      cost_per_strip,
      last_updated_at
    )
    VALUES (
      NEW.product_id,
      NEW.batch_id,
      NEW.location_type_source,
      NEW.location_id_source,
      -NEW.quantity_strips, -- Negate quantity for source
      NEW.cost_per_strip_at_transaction,
      now()
    )
    ON CONFLICT (product_id, batch_id, location_type, location_id)
    DO UPDATE SET
      current_quantity_strips = GREATEST(0, products_stock_status.current_quantity_strips - NEW.quantity_strips),
      last_updated_at = now();
  END IF;

  RETURN NEW;
END;
$$;


--
-- Name: update_updated_at_column(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.update_updated_at_column() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    NEW.updated_at = now();
    RETURN NEW;
END;
$$;


--
-- Name: validate_batch_dates(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.validate_batch_dates() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  -- Check if expiry date is after manufacturing date
  IF NEW.expiry_date <= NEW.manufacturing_date THEN
    RAISE EXCEPTION 'Expiry date must be after manufacturing date';
  END IF;
  
  RETURN NEW;
END;
$$;


--
-- Name: validate_single_base_unit(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.validate_single_base_unit() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  -- If trying to set is_base_unit to true, check if another base unit exists
  IF NEW.is_base_unit = true THEN
    IF EXISTS (
      SELECT 1 FROM public.product_packaging_units 
      WHERE product_id = NEW.product_id 
      AND is_base_unit = true 
      AND id != COALESCE(NEW.id, '00000000-0000-0000-0000-000000000000'::uuid)
    ) THEN
      RAISE EXCEPTION 'Only one base unit per product is allowed';
    END IF;
  END IF;
  
  RETURN NEW;
END;
$$;


--
-- Name: validate_template_name(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.validate_template_name() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  IF NEW.packaging_template IS NOT NULL AND
     NOT EXISTS (
       SELECT 1 FROM public.packaging_templates 
       WHERE template_name = NEW.packaging_template
     ) THEN
    RAISE EXCEPTION 'Invalid template name: %', NEW.packaging_template;
  END IF;
  RETURN NEW;
END;
$$;


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: doctor_clinics; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.doctor_clinics (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    doctor_id uuid NOT NULL,
    clinic_name text NOT NULL,
    latitude numeric(9,6),
    longitude numeric(9,6),
    is_primary boolean DEFAULT false NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL
);


--
-- Name: doctors; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.doctors (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    full_name text NOT NULL,
    specialty text,
    clinic_address text,
    phone_number text,
    email text,
    date_of_birth date,
    anniversary_date date,
    tier character(1),
    latitude numeric(9,6),
    longitude numeric(9,6),
    is_active boolean DEFAULT true NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    created_by uuid,
    CONSTRAINT doctors_tier_check CHECK ((tier = ANY (ARRAY['A'::bpchar, 'B'::bpchar, 'C'::bpchar])))
);


--
-- Name: mr_doctor_allotments; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.mr_doctor_allotments (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    mr_user_id uuid NOT NULL,
    doctor_id uuid NOT NULL
);


--
-- Name: mr_sales_order_items; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.mr_sales_order_items (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    order_id uuid NOT NULL,
    product_id uuid NOT NULL,
    batch_id uuid NOT NULL,
    quantity_strips_sold integer NOT NULL,
    price_per_strip numeric(10,2) NOT NULL,
    line_item_total numeric(10,2) GENERATED ALWAYS AS (((quantity_strips_sold)::numeric * price_per_strip)) STORED,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    CONSTRAINT mr_sales_order_items_price_per_strip_check CHECK ((price_per_strip >= (0)::numeric)),
    CONSTRAINT mr_sales_order_items_quantity_strips_sold_check CHECK ((quantity_strips_sold > 0))
);


--
-- Name: mr_sales_orders; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.mr_sales_orders (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    mr_user_id uuid NOT NULL,
    customer_name text NOT NULL,
    order_date timestamp with time zone DEFAULT now() NOT NULL,
    total_amount numeric(10,2) NOT NULL,
    payment_status public.mr_payment_status DEFAULT 'Pending'::public.mr_payment_status NOT NULL,
    notes text,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    CONSTRAINT mr_sales_orders_total_amount_check CHECK ((total_amount >= (0)::numeric))
);


--
-- Name: mr_sales_targets; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.mr_sales_targets (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    mr_user_id uuid NOT NULL,
    period_type public.target_period_type NOT NULL,
    start_date date NOT NULL,
    end_date date NOT NULL,
    target_sales_amount numeric(12,2) NOT NULL,
    target_tier_bronze numeric(12,2),
    target_tier_gold numeric(12,2),
    product_specific_goals jsonb,
    target_collection_percentage numeric(5,2),
    is_locked boolean DEFAULT false NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    CONSTRAINT mr_sales_targets_target_collection_percentage_check CHECK (((target_collection_percentage > (0)::numeric) AND (target_collection_percentage <= (100)::numeric))),
    CONSTRAINT mr_sales_targets_target_sales_amount_check CHECK ((target_sales_amount > (0)::numeric))
);


--
-- Name: mr_stock_summary; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.mr_stock_summary (
    mr_user_id uuid NOT NULL,
    product_id uuid NOT NULL,
    batch_id uuid NOT NULL,
    current_quantity_strips integer DEFAULT 0 NOT NULL,
    last_updated_at timestamp with time zone DEFAULT now() NOT NULL,
    price_per_strip numeric(10,2) DEFAULT 0.00,
    CONSTRAINT non_negative_quantity CHECK ((current_quantity_strips >= 0))
);


--
-- Name: mr_visit_logs; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.mr_visit_logs (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    mr_user_id uuid NOT NULL,
    doctor_id uuid NOT NULL,
    visit_date timestamp with time zone DEFAULT now() NOT NULL,
    products_detailed jsonb,
    feedback_received text,
    samples_provided jsonb,
    competitor_activity_notes text,
    prescription_potential_notes text,
    next_visit_date date,
    next_visit_objective text,
    linked_sale_order_id uuid,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    is_location_verified boolean,
    distance_from_clinic_meters numeric(10,2),
    clinic_id uuid
);


--
-- Name: packaging_templates; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.packaging_templates (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    template_name text NOT NULL,
    unit_name text NOT NULL,
    conversion_factor_to_strips integer DEFAULT 1 NOT NULL,
    is_base_unit boolean DEFAULT false NOT NULL,
    order_in_hierarchy integer DEFAULT 1 NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    CONSTRAINT positive_conversion_factor CHECK ((conversion_factor_to_strips > 0)),
    CONSTRAINT positive_order CHECK ((order_in_hierarchy > 0))
);


--
-- Name: product_batches; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.product_batches (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    product_id uuid NOT NULL,
    batch_number text NOT NULL,
    manufacturing_date date NOT NULL,
    expiry_date date NOT NULL,
    batch_cost_per_strip numeric(10,2),
    status text DEFAULT 'Active'::text NOT NULL,
    notes text,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    CONSTRAINT positive_batch_cost CHECK (((batch_cost_per_strip > (0)::numeric) OR (batch_cost_per_strip IS NULL))),
    CONSTRAINT valid_batch_status CHECK ((status = ANY (ARRAY['Active'::text, 'Expired'::text, 'Recalled'::text, 'Quarantined'::text])))
);


--
-- Name: product_categories; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.product_categories (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    category_name text NOT NULL,
    description text,
    is_active boolean DEFAULT true NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL
);


--
-- Name: product_formulations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.product_formulations (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    formulation_name text NOT NULL,
    is_active boolean DEFAULT true NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL
);


--
-- Name: product_packaging_units; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.product_packaging_units (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    product_id uuid NOT NULL,
    unit_name text NOT NULL,
    conversion_factor_to_strips integer DEFAULT 1 NOT NULL,
    is_base_unit boolean DEFAULT false NOT NULL,
    order_in_hierarchy integer NOT NULL,
    default_purchase_unit boolean DEFAULT false NOT NULL,
    default_sales_unit_mr boolean DEFAULT false NOT NULL,
    default_sales_unit_direct boolean DEFAULT false NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    template_id uuid,
    CONSTRAINT positive_conversion_factor CHECK ((conversion_factor_to_strips > 0)),
    CONSTRAINT positive_order CHECK ((order_in_hierarchy > 0))
);


--
-- Name: product_sub_categories; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.product_sub_categories (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    sub_category_name text NOT NULL,
    category_id uuid NOT NULL,
    description text,
    is_active boolean DEFAULT true NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL
);


--
-- Name: products; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.products (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    product_code text NOT NULL,
    product_name text NOT NULL,
    generic_name text NOT NULL,
    manufacturer text NOT NULL,
    category_id uuid NOT NULL,
    sub_category_id uuid,
    formulation_id uuid NOT NULL,
    unit_of_measure_smallest text DEFAULT 'Strip'::text NOT NULL,
    base_cost_per_strip numeric(10,2) NOT NULL,
    is_active boolean DEFAULT true NOT NULL,
    storage_conditions text,
    image_url text,
    min_stock_level_godown integer DEFAULT 0,
    min_stock_level_mr integer DEFAULT 0,
    lead_time_days integer DEFAULT 0,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    packaging_template text,
    CONSTRAINT products_base_cost_per_strip_check CHECK ((base_cost_per_strip >= (0)::numeric)),
    CONSTRAINT products_lead_time_days_check CHECK ((lead_time_days >= 0)),
    CONSTRAINT products_min_stock_level_godown_check CHECK ((min_stock_level_godown >= 0)),
    CONSTRAINT products_min_stock_level_mr_check CHECK ((min_stock_level_mr >= 0))
);


--
-- Name: products_stock_status; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.products_stock_status (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    product_id uuid NOT NULL,
    batch_id uuid NOT NULL,
    location_type text NOT NULL,
    location_id text NOT NULL,
    current_quantity_strips integer DEFAULT 0 NOT NULL,
    cost_per_strip numeric DEFAULT 0 NOT NULL,
    total_value numeric GENERATED ALWAYS AS (((current_quantity_strips)::numeric * cost_per_strip)) STORED,
    last_updated_at timestamp with time zone DEFAULT now() NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL
);


--
-- Name: profiles; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.profiles (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    user_id uuid NOT NULL,
    name text NOT NULL,
    email text NOT NULL,
    role public.user_role DEFAULT 'user'::public.user_role NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL
);


--
-- Name: stock_adjustments; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.stock_adjustments (
    adjustment_id uuid DEFAULT gen_random_uuid() NOT NULL,
    adjustment_group_id uuid NOT NULL,
    product_id uuid NOT NULL,
    batch_id uuid NOT NULL,
    adjustment_type text NOT NULL,
    quantity_strips integer NOT NULL,
    location_type_source text,
    location_id_source text,
    location_type_destination text,
    location_id_destination text,
    adjustment_date timestamp with time zone DEFAULT now() NOT NULL,
    reference_document_id text,
    cost_per_strip numeric(10,2) NOT NULL,
    notes text,
    created_by uuid,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    CONSTRAINT positive_adjustment_cost CHECK ((cost_per_strip > (0)::numeric)),
    CONSTRAINT valid_adjustment_type CHECK ((adjustment_type = ANY (ARRAY['RETURN_TO_GODOWN'::text, 'RETURN_TO_MR'::text, 'ADJUST_DAMAGE_GODOWN'::text, 'ADJUST_LOSS_GODOWN'::text, 'ADJUST_DAMAGE_MR'::text, 'ADJUST_LOSS_MR'::text, 'ADJUST_EXPIRED_GODOWN'::text, 'ADJUST_EXPIRED_MR'::text, 'REPLACEMENT_FROM_GODOWN'::text, 'REPLACEMENT_FROM_MR'::text, 'OPENING_STOCK_GODOWN'::text, 'OPENING_STOCK_MR'::text])))
);


--
-- Name: stock_purchases; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.stock_purchases (
    purchase_id uuid DEFAULT gen_random_uuid() NOT NULL,
    purchase_group_id uuid NOT NULL,
    product_id uuid NOT NULL,
    batch_id uuid NOT NULL,
    quantity_strips integer NOT NULL,
    supplier_id text,
    purchase_date timestamp with time zone DEFAULT now() NOT NULL,
    reference_document_id text,
    cost_per_strip numeric(10,2) NOT NULL,
    notes text,
    created_by uuid,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    CONSTRAINT positive_purchase_cost CHECK ((cost_per_strip > (0)::numeric)),
    CONSTRAINT positive_purchase_quantity CHECK ((quantity_strips > 0))
);


--
-- Name: stock_sales; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.stock_sales (
    sale_id uuid DEFAULT gen_random_uuid() NOT NULL,
    sale_group_id uuid NOT NULL,
    product_id uuid NOT NULL,
    batch_id uuid NOT NULL,
    transaction_type text NOT NULL,
    quantity_strips integer NOT NULL,
    location_type_source text NOT NULL,
    location_id_source text,
    location_type_destination text NOT NULL,
    location_id_destination text,
    sale_date timestamp with time zone DEFAULT now() NOT NULL,
    reference_document_id text,
    cost_per_strip numeric(10,2) NOT NULL,
    notes text,
    created_by uuid,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    CONSTRAINT positive_sale_cost CHECK ((cost_per_strip > (0)::numeric)),
    CONSTRAINT positive_sale_quantity CHECK ((quantity_strips > 0)),
    CONSTRAINT valid_sale_location_destination CHECK ((location_type_destination = ANY (ARRAY['MR'::text, 'CUSTOMER'::text]))),
    CONSTRAINT valid_sale_location_source CHECK ((location_type_source = ANY (ARRAY['GODOWN'::text, 'MR'::text]))),
    CONSTRAINT valid_sale_transaction_type CHECK ((transaction_type = ANY (ARRAY['DISPATCH_TO_MR'::text, 'SALE_DIRECT_GODOWN'::text, 'SALE_BY_MR'::text])))
);


--
-- Name: stock_transactions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.stock_transactions (
    transaction_id uuid DEFAULT gen_random_uuid() NOT NULL,
    transaction_group_id uuid NOT NULL,
    product_id uuid NOT NULL,
    batch_id uuid NOT NULL,
    transaction_type text NOT NULL,
    quantity_strips integer NOT NULL,
    location_type_source text,
    location_id_source text,
    location_type_destination text,
    location_id_destination text,
    transaction_date timestamp with time zone DEFAULT now() NOT NULL,
    reference_document_type text,
    reference_document_id text,
    cost_per_strip_at_transaction numeric(10,2) NOT NULL,
    notes text,
    created_by uuid,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    CONSTRAINT positive_cost CHECK ((cost_per_strip_at_transaction > (0)::numeric)),
    CONSTRAINT valid_location_destination CHECK (((location_type_destination = ANY (ARRAY['SUPPLIER'::text, 'GODOWN'::text, 'MR'::text, 'CUSTOMER'::text, 'WASTAGE_BIN'::text])) OR (location_type_destination IS NULL))),
    CONSTRAINT valid_location_source CHECK (((location_type_source = ANY (ARRAY['SUPPLIER'::text, 'GODOWN'::text, 'MR'::text, 'CUSTOMER'::text])) OR (location_type_source IS NULL))),
    CONSTRAINT valid_transaction_type CHECK ((transaction_type = ANY (ARRAY['STOCK_IN_GODOWN'::text, 'DISPATCH_TO_MR'::text, 'SALE_DIRECT_GODOWN'::text, 'SALE_BY_MR'::text, 'RETURN_TO_GODOWN'::text, 'RETURN_TO_MR'::text, 'ADJUST_DAMAGE_GODOWN'::text, 'ADJUST_LOSS_GODOWN'::text, 'ADJUST_DAMAGE_MR'::text, 'ADJUST_LOSS_MR'::text, 'ADJUST_EXPIRED_GODOWN'::text, 'ADJUST_EXPIRED_MR'::text, 'REPLACEMENT_FROM_GODOWN'::text, 'REPLACEMENT_FROM_MR'::text, 'OPENING_STOCK_GODOWN'::text, 'OPENING_STOCK_MR'::text])))
);


--
-- Name: stock_transactions_view; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW public.stock_transactions_view AS
 SELECT stock_purchases.purchase_id AS transaction_id,
    stock_purchases.purchase_group_id AS transaction_group_id,
    stock_purchases.product_id,
    stock_purchases.batch_id,
    'STOCK_IN_GODOWN'::text AS transaction_type,
    stock_purchases.quantity_strips,
    'SUPPLIER'::text AS location_type_source,
    stock_purchases.supplier_id AS location_id_source,
    'GODOWN'::text AS location_type_destination,
    NULL::text AS location_id_destination,
    stock_purchases.purchase_date AS transaction_date,
    'PURCHASE'::text AS reference_document_type,
    stock_purchases.reference_document_id,
    stock_purchases.cost_per_strip AS cost_per_strip_at_transaction,
    stock_purchases.notes,
    stock_purchases.created_by,
    stock_purchases.created_at
   FROM public.stock_purchases
UNION ALL
 SELECT stock_sales.sale_id AS transaction_id,
    stock_sales.sale_group_id AS transaction_group_id,
    stock_sales.product_id,
    stock_sales.batch_id,
    stock_sales.transaction_type,
        CASE
            WHEN (stock_sales.transaction_type = 'DISPATCH_TO_MR'::text) THEN stock_sales.quantity_strips
            WHEN (stock_sales.transaction_type = 'SALE_DIRECT_GODOWN'::text) THEN (- stock_sales.quantity_strips)
            WHEN (stock_sales.transaction_type = 'SALE_BY_MR'::text) THEN (- stock_sales.quantity_strips)
            ELSE stock_sales.quantity_strips
        END AS quantity_strips,
    stock_sales.location_type_source,
    stock_sales.location_id_source,
    stock_sales.location_type_destination,
    stock_sales.location_id_destination,
    stock_sales.sale_date AS transaction_date,
    'SALE'::text AS reference_document_type,
    stock_sales.reference_document_id,
    stock_sales.cost_per_strip AS cost_per_strip_at_transaction,
    stock_sales.notes,
    stock_sales.created_by,
    stock_sales.created_at
   FROM public.stock_sales
UNION ALL
 SELECT stock_adjustments.adjustment_id AS transaction_id,
    stock_adjustments.adjustment_group_id AS transaction_group_id,
    stock_adjustments.product_id,
    stock_adjustments.batch_id,
    stock_adjustments.adjustment_type AS transaction_type,
        CASE
            WHEN (stock_adjustments.adjustment_type ~~ 'RETURN_TO_%'::text) THEN stock_adjustments.quantity_strips
            WHEN (stock_adjustments.adjustment_type ~~ 'ADJUST_%'::text) THEN (- stock_adjustments.quantity_strips)
            WHEN (stock_adjustments.adjustment_type ~~ 'OPENING_STOCK_%'::text) THEN stock_adjustments.quantity_strips
            WHEN (stock_adjustments.adjustment_type ~~ 'REPLACEMENT_%'::text) THEN (- stock_adjustments.quantity_strips)
            ELSE stock_adjustments.quantity_strips
        END AS quantity_strips,
    stock_adjustments.location_type_source,
    stock_adjustments.location_id_source,
    stock_adjustments.location_type_destination,
    stock_adjustments.location_id_destination,
    stock_adjustments.adjustment_date AS transaction_date,
    'ADJUSTMENT'::text AS reference_document_type,
    stock_adjustments.reference_document_id,
    stock_adjustments.cost_per_strip AS cost_per_strip_at_transaction,
    stock_adjustments.notes,
    stock_adjustments.created_by,
    stock_adjustments.created_at
   FROM public.stock_adjustments;


--
-- Name: suppliers; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.suppliers (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    supplier_name text NOT NULL,
    supplier_code text,
    contact_person text,
    phone text,
    email text,
    address text,
    is_active boolean DEFAULT true NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL
);


--
-- Name: template_names; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW public.template_names AS
 SELECT DISTINCT packaging_templates.template_name
   FROM public.packaging_templates;


--
-- Name: doctor_clinics doctor_clinics_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.doctor_clinics
    ADD CONSTRAINT doctor_clinics_pkey PRIMARY KEY (id);


--
-- Name: doctors doctors_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.doctors
    ADD CONSTRAINT doctors_pkey PRIMARY KEY (id);


--
-- Name: mr_doctor_allotments mr_doctor_allotments_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.mr_doctor_allotments
    ADD CONSTRAINT mr_doctor_allotments_pkey PRIMARY KEY (id);


--
-- Name: mr_sales_order_items mr_sales_order_items_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.mr_sales_order_items
    ADD CONSTRAINT mr_sales_order_items_pkey PRIMARY KEY (id);


--
-- Name: mr_sales_orders mr_sales_orders_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.mr_sales_orders
    ADD CONSTRAINT mr_sales_orders_pkey PRIMARY KEY (id);


--
-- Name: mr_sales_targets mr_sales_targets_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.mr_sales_targets
    ADD CONSTRAINT mr_sales_targets_pkey PRIMARY KEY (id);


--
-- Name: mr_stock_summary mr_stock_summary_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.mr_stock_summary
    ADD CONSTRAINT mr_stock_summary_pkey PRIMARY KEY (mr_user_id, product_id, batch_id);


--
-- Name: mr_visit_logs mr_visit_logs_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.mr_visit_logs
    ADD CONSTRAINT mr_visit_logs_pkey PRIMARY KEY (id);


--
-- Name: packaging_templates packaging_templates_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.packaging_templates
    ADD CONSTRAINT packaging_templates_pkey PRIMARY KEY (id);


--
-- Name: product_batches product_batches_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.product_batches
    ADD CONSTRAINT product_batches_pkey PRIMARY KEY (id);


--
-- Name: product_categories product_categories_category_name_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.product_categories
    ADD CONSTRAINT product_categories_category_name_key UNIQUE (category_name);


--
-- Name: product_categories product_categories_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.product_categories
    ADD CONSTRAINT product_categories_pkey PRIMARY KEY (id);


--
-- Name: product_formulations product_formulations_formulation_name_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.product_formulations
    ADD CONSTRAINT product_formulations_formulation_name_key UNIQUE (formulation_name);


--
-- Name: product_formulations product_formulations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.product_formulations
    ADD CONSTRAINT product_formulations_pkey PRIMARY KEY (id);


--
-- Name: product_packaging_units product_packaging_units_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.product_packaging_units
    ADD CONSTRAINT product_packaging_units_pkey PRIMARY KEY (id);


--
-- Name: product_sub_categories product_sub_categories_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.product_sub_categories
    ADD CONSTRAINT product_sub_categories_pkey PRIMARY KEY (id);


--
-- Name: product_sub_categories product_sub_categories_sub_category_name_category_id_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.product_sub_categories
    ADD CONSTRAINT product_sub_categories_sub_category_name_category_id_key UNIQUE (sub_category_name, category_id);


--
-- Name: products products_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.products
    ADD CONSTRAINT products_pkey PRIMARY KEY (id);


--
-- Name: products products_product_code_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.products
    ADD CONSTRAINT products_product_code_key UNIQUE (product_code);


--
-- Name: products_stock_status products_stock_status_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.products_stock_status
    ADD CONSTRAINT products_stock_status_pkey PRIMARY KEY (id);


--
-- Name: products_stock_status products_stock_status_product_id_batch_id_location_type_loc_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.products_stock_status
    ADD CONSTRAINT products_stock_status_product_id_batch_id_location_type_loc_key UNIQUE (product_id, batch_id, location_type, location_id);


--
-- Name: products_stock_status products_stock_status_unique_location; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.products_stock_status
    ADD CONSTRAINT products_stock_status_unique_location UNIQUE (product_id, batch_id, location_type, location_id);


--
-- Name: profiles profiles_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.profiles
    ADD CONSTRAINT profiles_pkey PRIMARY KEY (id);


--
-- Name: profiles profiles_user_id_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.profiles
    ADD CONSTRAINT profiles_user_id_key UNIQUE (user_id);


--
-- Name: stock_adjustments stock_adjustments_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.stock_adjustments
    ADD CONSTRAINT stock_adjustments_pkey PRIMARY KEY (adjustment_id);


--
-- Name: stock_purchases stock_purchases_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.stock_purchases
    ADD CONSTRAINT stock_purchases_pkey PRIMARY KEY (purchase_id);


--
-- Name: stock_sales stock_sales_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.stock_sales
    ADD CONSTRAINT stock_sales_pkey PRIMARY KEY (sale_id);


--
-- Name: stock_transactions stock_transactions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.stock_transactions
    ADD CONSTRAINT stock_transactions_pkey PRIMARY KEY (transaction_id);


--
-- Name: suppliers suppliers_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.suppliers
    ADD CONSTRAINT suppliers_pkey PRIMARY KEY (id);


--
-- Name: suppliers suppliers_supplier_code_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.suppliers
    ADD CONSTRAINT suppliers_supplier_code_key UNIQUE (supplier_code);


--
-- Name: mr_doctor_allotments unique_doctor_allotment; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.mr_doctor_allotments
    ADD CONSTRAINT unique_doctor_allotment UNIQUE (doctor_id);


--
-- Name: mr_sales_targets unique_mr_target_period; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.mr_sales_targets
    ADD CONSTRAINT unique_mr_target_period UNIQUE (mr_user_id, start_date);


--
-- Name: product_batches unique_product_batch_number; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.product_batches
    ADD CONSTRAINT unique_product_batch_number UNIQUE (product_id, batch_number);


--
-- Name: product_packaging_units unique_product_unit_name; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.product_packaging_units
    ADD CONSTRAINT unique_product_unit_name UNIQUE (product_id, unit_name);


--
-- Name: packaging_templates unique_template_unit_name; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.packaging_templates
    ADD CONSTRAINT unique_template_unit_name UNIQUE (template_name, unit_name);


--
-- Name: idx_mr_sales_order_items_order_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_mr_sales_order_items_order_id ON public.mr_sales_order_items USING btree (order_id);


--
-- Name: idx_mr_sales_order_items_product_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_mr_sales_order_items_product_id ON public.mr_sales_order_items USING btree (product_id);


--
-- Name: idx_mr_sales_orders_mr_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_mr_sales_orders_mr_user_id ON public.mr_sales_orders USING btree (mr_user_id);


--
-- Name: idx_mr_sales_orders_order_date; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_mr_sales_orders_order_date ON public.mr_sales_orders USING btree (order_date);


--
-- Name: idx_mr_sales_targets_mr_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_mr_sales_targets_mr_user_id ON public.mr_sales_targets USING btree (mr_user_id);


--
-- Name: idx_mr_sales_targets_period; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_mr_sales_targets_period ON public.mr_sales_targets USING btree (start_date, end_date);


--
-- Name: idx_mr_stock_summary_mr_user; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_mr_stock_summary_mr_user ON public.mr_stock_summary USING btree (mr_user_id);


--
-- Name: idx_mr_stock_summary_product; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_mr_stock_summary_product ON public.mr_stock_summary USING btree (product_id);


--
-- Name: idx_mr_visit_logs_location_verified; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_mr_visit_logs_location_verified ON public.mr_visit_logs USING btree (is_location_verified);


--
-- Name: idx_packaging_templates_name; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_packaging_templates_name ON public.packaging_templates USING btree (template_name);


--
-- Name: idx_product_batches_batch_number; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_product_batches_batch_number ON public.product_batches USING btree (product_id, batch_number);


--
-- Name: idx_product_batches_expiry_date; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_product_batches_expiry_date ON public.product_batches USING btree (expiry_date);


--
-- Name: idx_product_batches_product_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_product_batches_product_id ON public.product_batches USING btree (product_id);


--
-- Name: idx_product_batches_status; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_product_batches_status ON public.product_batches USING btree (status);


--
-- Name: idx_product_packaging_units_order; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_product_packaging_units_order ON public.product_packaging_units USING btree (product_id, order_in_hierarchy);


--
-- Name: idx_product_packaging_units_product_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_product_packaging_units_product_id ON public.product_packaging_units USING btree (product_id);


--
-- Name: idx_product_packaging_units_template_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_product_packaging_units_template_id ON public.product_packaging_units USING btree (template_id);


--
-- Name: idx_product_sub_categories_category_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_product_sub_categories_category_id ON public.product_sub_categories USING btree (category_id);


--
-- Name: idx_products_category_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_products_category_id ON public.products USING btree (category_id);


--
-- Name: idx_products_formulation_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_products_formulation_id ON public.products USING btree (formulation_id);


--
-- Name: idx_products_is_active; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_products_is_active ON public.products USING btree (is_active);


--
-- Name: idx_products_packaging_template; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_products_packaging_template ON public.products USING btree (packaging_template);


--
-- Name: idx_products_product_code; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_products_product_code ON public.products USING btree (product_code);


--
-- Name: idx_products_stock_status_batch_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_products_stock_status_batch_id ON public.products_stock_status USING btree (batch_id);


--
-- Name: idx_products_stock_status_current_quantity; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_products_stock_status_current_quantity ON public.products_stock_status USING btree (current_quantity_strips) WHERE (current_quantity_strips > 0);


--
-- Name: idx_products_stock_status_location; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_products_stock_status_location ON public.products_stock_status USING btree (location_type, location_id);


--
-- Name: idx_products_stock_status_product_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_products_stock_status_product_id ON public.products_stock_status USING btree (product_id);


--
-- Name: idx_products_sub_category_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_products_sub_category_id ON public.products USING btree (sub_category_id);


--
-- Name: idx_stock_adjustments_batch_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_stock_adjustments_batch_id ON public.stock_adjustments USING btree (batch_id);


--
-- Name: idx_stock_adjustments_created_by; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_stock_adjustments_created_by ON public.stock_adjustments USING btree (created_by);


--
-- Name: idx_stock_adjustments_date; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_stock_adjustments_date ON public.stock_adjustments USING btree (adjustment_date);


--
-- Name: idx_stock_adjustments_group_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_stock_adjustments_group_id ON public.stock_adjustments USING btree (adjustment_group_id);


--
-- Name: idx_stock_adjustments_product_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_stock_adjustments_product_id ON public.stock_adjustments USING btree (product_id);


--
-- Name: idx_stock_adjustments_type; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_stock_adjustments_type ON public.stock_adjustments USING btree (adjustment_type);


--
-- Name: idx_stock_purchases_batch_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_stock_purchases_batch_id ON public.stock_purchases USING btree (batch_id);


--
-- Name: idx_stock_purchases_created_by; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_stock_purchases_created_by ON public.stock_purchases USING btree (created_by);


--
-- Name: idx_stock_purchases_date; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_stock_purchases_date ON public.stock_purchases USING btree (purchase_date);


--
-- Name: idx_stock_purchases_group_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_stock_purchases_group_id ON public.stock_purchases USING btree (purchase_group_id);


--
-- Name: idx_stock_purchases_product_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_stock_purchases_product_id ON public.stock_purchases USING btree (product_id);


--
-- Name: idx_stock_sales_batch_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_stock_sales_batch_id ON public.stock_sales USING btree (batch_id);


--
-- Name: idx_stock_sales_created_by; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_stock_sales_created_by ON public.stock_sales USING btree (created_by);


--
-- Name: idx_stock_sales_date; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_stock_sales_date ON public.stock_sales USING btree (sale_date);


--
-- Name: idx_stock_sales_group_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_stock_sales_group_id ON public.stock_sales USING btree (sale_group_id);


--
-- Name: idx_stock_sales_product_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_stock_sales_product_id ON public.stock_sales USING btree (product_id);


--
-- Name: idx_stock_sales_type; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_stock_sales_type ON public.stock_sales USING btree (transaction_type);


--
-- Name: idx_stock_transactions_batch_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_stock_transactions_batch_id ON public.stock_transactions USING btree (batch_id);


--
-- Name: idx_stock_transactions_created_by; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_stock_transactions_created_by ON public.stock_transactions USING btree (created_by);


--
-- Name: idx_stock_transactions_date; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_stock_transactions_date ON public.stock_transactions USING btree (transaction_date);


--
-- Name: idx_stock_transactions_group_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_stock_transactions_group_id ON public.stock_transactions USING btree (transaction_group_id);


--
-- Name: idx_stock_transactions_product_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_stock_transactions_product_id ON public.stock_transactions USING btree (product_id);


--
-- Name: idx_stock_transactions_type; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_stock_transactions_type ON public.stock_transactions USING btree (transaction_type);


--
-- Name: one_primary_clinic_per_doctor; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX one_primary_clinic_per_doctor ON public.doctor_clinics USING btree (doctor_id) WHERE (is_primary = true);


--
-- Name: stock_transactions trigger_update_products_stock_status; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER trigger_update_products_stock_status AFTER INSERT ON public.stock_transactions FOR EACH ROW EXECUTE FUNCTION public.update_products_stock_status();


--
-- Name: stock_adjustments update_mr_stock_summary_adjustments_trigger; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER update_mr_stock_summary_adjustments_trigger AFTER INSERT ON public.stock_adjustments FOR EACH ROW EXECUTE FUNCTION public.update_mr_stock_summary_from_adjustments();


--
-- Name: stock_sales update_mr_stock_summary_sales_trigger; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER update_mr_stock_summary_sales_trigger AFTER INSERT ON public.stock_sales FOR EACH ROW EXECUTE FUNCTION public.update_mr_stock_summary_from_sales();


--
-- Name: stock_transactions update_mr_stock_summary_trigger; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER update_mr_stock_summary_trigger AFTER INSERT ON public.stock_transactions FOR EACH ROW EXECUTE FUNCTION public.update_mr_stock_summary();


--
-- Name: packaging_templates update_packaging_templates_updated_at; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER update_packaging_templates_updated_at BEFORE UPDATE ON public.packaging_templates FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();


--
-- Name: product_batches update_product_batches_updated_at; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER update_product_batches_updated_at BEFORE UPDATE ON public.product_batches FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();


--
-- Name: product_categories update_product_categories_updated_at; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER update_product_categories_updated_at BEFORE UPDATE ON public.product_categories FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();


--
-- Name: product_formulations update_product_formulations_updated_at; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER update_product_formulations_updated_at BEFORE UPDATE ON public.product_formulations FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();


--
-- Name: product_packaging_units update_product_packaging_units_updated_at; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER update_product_packaging_units_updated_at BEFORE UPDATE ON public.product_packaging_units FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();


--
-- Name: product_sub_categories update_product_sub_categories_updated_at; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER update_product_sub_categories_updated_at BEFORE UPDATE ON public.product_sub_categories FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();


--
-- Name: products_stock_status update_products_stock_status_updated_at; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER update_products_stock_status_updated_at BEFORE UPDATE ON public.products_stock_status FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();


--
-- Name: products update_products_updated_at; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER update_products_updated_at BEFORE UPDATE ON public.products FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();


--
-- Name: suppliers update_suppliers_updated_at; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER update_suppliers_updated_at BEFORE UPDATE ON public.suppliers FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();


--
-- Name: product_batches validate_batch_dates_trigger; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER validate_batch_dates_trigger BEFORE INSERT OR UPDATE ON public.product_batches FOR EACH ROW EXECUTE FUNCTION public.validate_batch_dates();


--
-- Name: products validate_product_template_name; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER validate_product_template_name BEFORE INSERT OR UPDATE ON public.products FOR EACH ROW EXECUTE FUNCTION public.validate_template_name();


--
-- Name: product_packaging_units validate_single_base_unit_trigger; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER validate_single_base_unit_trigger BEFORE INSERT OR UPDATE ON public.product_packaging_units FOR EACH ROW EXECUTE FUNCTION public.validate_single_base_unit();


--
-- Name: doctor_clinics doctor_clinics_doctor_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.doctor_clinics
    ADD CONSTRAINT doctor_clinics_doctor_id_fkey FOREIGN KEY (doctor_id) REFERENCES public.doctors(id) ON DELETE CASCADE;


--
-- Name: doctors doctors_created_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.doctors
    ADD CONSTRAINT doctors_created_by_fkey FOREIGN KEY (created_by) REFERENCES public.profiles(user_id) ON DELETE SET NULL;


--
-- Name: mr_doctor_allotments mr_doctor_allotments_doctor_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.mr_doctor_allotments
    ADD CONSTRAINT mr_doctor_allotments_doctor_id_fkey FOREIGN KEY (doctor_id) REFERENCES public.doctors(id) ON DELETE CASCADE;


--
-- Name: mr_doctor_allotments mr_doctor_allotments_mr_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.mr_doctor_allotments
    ADD CONSTRAINT mr_doctor_allotments_mr_user_id_fkey FOREIGN KEY (mr_user_id) REFERENCES public.profiles(user_id) ON DELETE CASCADE;


--
-- Name: mr_sales_order_items mr_sales_order_items_batch_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.mr_sales_order_items
    ADD CONSTRAINT mr_sales_order_items_batch_id_fkey FOREIGN KEY (batch_id) REFERENCES public.product_batches(id) ON DELETE RESTRICT;


--
-- Name: mr_sales_order_items mr_sales_order_items_order_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.mr_sales_order_items
    ADD CONSTRAINT mr_sales_order_items_order_id_fkey FOREIGN KEY (order_id) REFERENCES public.mr_sales_orders(id) ON DELETE CASCADE;


--
-- Name: mr_sales_order_items mr_sales_order_items_product_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.mr_sales_order_items
    ADD CONSTRAINT mr_sales_order_items_product_id_fkey FOREIGN KEY (product_id) REFERENCES public.products(id) ON DELETE RESTRICT;


--
-- Name: mr_sales_orders mr_sales_orders_mr_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.mr_sales_orders
    ADD CONSTRAINT mr_sales_orders_mr_user_id_fkey FOREIGN KEY (mr_user_id) REFERENCES public.profiles(user_id) ON DELETE RESTRICT;


--
-- Name: mr_sales_targets mr_sales_targets_mr_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.mr_sales_targets
    ADD CONSTRAINT mr_sales_targets_mr_user_id_fkey FOREIGN KEY (mr_user_id) REFERENCES public.profiles(user_id) ON DELETE CASCADE;


--
-- Name: mr_stock_summary mr_stock_summary_batch_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.mr_stock_summary
    ADD CONSTRAINT mr_stock_summary_batch_id_fkey FOREIGN KEY (batch_id) REFERENCES public.product_batches(id) ON DELETE CASCADE;


--
-- Name: mr_stock_summary mr_stock_summary_mr_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.mr_stock_summary
    ADD CONSTRAINT mr_stock_summary_mr_user_id_fkey FOREIGN KEY (mr_user_id) REFERENCES auth.users(id) ON DELETE CASCADE;


--
-- Name: mr_stock_summary mr_stock_summary_product_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.mr_stock_summary
    ADD CONSTRAINT mr_stock_summary_product_id_fkey FOREIGN KEY (product_id) REFERENCES public.products(id) ON DELETE CASCADE;


--
-- Name: mr_visit_logs mr_visit_logs_clinic_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.mr_visit_logs
    ADD CONSTRAINT mr_visit_logs_clinic_id_fkey FOREIGN KEY (clinic_id) REFERENCES public.doctor_clinics(id) ON DELETE SET NULL;


--
-- Name: mr_visit_logs mr_visit_logs_doctor_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.mr_visit_logs
    ADD CONSTRAINT mr_visit_logs_doctor_id_fkey FOREIGN KEY (doctor_id) REFERENCES public.doctors(id) ON DELETE RESTRICT;


--
-- Name: mr_visit_logs mr_visit_logs_linked_sale_order_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.mr_visit_logs
    ADD CONSTRAINT mr_visit_logs_linked_sale_order_id_fkey FOREIGN KEY (linked_sale_order_id) REFERENCES public.mr_sales_orders(id) ON DELETE SET NULL;


--
-- Name: mr_visit_logs mr_visit_logs_mr_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.mr_visit_logs
    ADD CONSTRAINT mr_visit_logs_mr_user_id_fkey FOREIGN KEY (mr_user_id) REFERENCES public.profiles(user_id) ON DELETE RESTRICT;


--
-- Name: product_batches product_batches_product_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.product_batches
    ADD CONSTRAINT product_batches_product_id_fkey FOREIGN KEY (product_id) REFERENCES public.products(id) ON DELETE CASCADE;


--
-- Name: product_packaging_units product_packaging_units_product_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.product_packaging_units
    ADD CONSTRAINT product_packaging_units_product_id_fkey FOREIGN KEY (product_id) REFERENCES public.products(id) ON DELETE CASCADE;


--
-- Name: product_packaging_units product_packaging_units_template_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.product_packaging_units
    ADD CONSTRAINT product_packaging_units_template_id_fkey FOREIGN KEY (template_id) REFERENCES public.packaging_templates(id) ON DELETE SET NULL;


--
-- Name: product_sub_categories product_sub_categories_category_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.product_sub_categories
    ADD CONSTRAINT product_sub_categories_category_id_fkey FOREIGN KEY (category_id) REFERENCES public.product_categories(id);


--
-- Name: products products_category_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.products
    ADD CONSTRAINT products_category_id_fkey FOREIGN KEY (category_id) REFERENCES public.product_categories(id);


--
-- Name: products products_formulation_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.products
    ADD CONSTRAINT products_formulation_id_fkey FOREIGN KEY (formulation_id) REFERENCES public.product_formulations(id);


--
-- Name: products_stock_status products_stock_status_batch_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.products_stock_status
    ADD CONSTRAINT products_stock_status_batch_id_fkey FOREIGN KEY (batch_id) REFERENCES public.product_batches(id);


--
-- Name: products_stock_status products_stock_status_product_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.products_stock_status
    ADD CONSTRAINT products_stock_status_product_id_fkey FOREIGN KEY (product_id) REFERENCES public.products(id);


--
-- Name: products products_sub_category_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.products
    ADD CONSTRAINT products_sub_category_id_fkey FOREIGN KEY (sub_category_id) REFERENCES public.product_sub_categories(id);


--
-- Name: profiles profiles_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.profiles
    ADD CONSTRAINT profiles_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE;


--
-- Name: stock_adjustments stock_adjustments_batch_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.stock_adjustments
    ADD CONSTRAINT stock_adjustments_batch_id_fkey FOREIGN KEY (batch_id) REFERENCES public.product_batches(id) ON DELETE RESTRICT;


--
-- Name: stock_adjustments stock_adjustments_created_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.stock_adjustments
    ADD CONSTRAINT stock_adjustments_created_by_fkey FOREIGN KEY (created_by) REFERENCES auth.users(id);


--
-- Name: stock_adjustments stock_adjustments_product_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.stock_adjustments
    ADD CONSTRAINT stock_adjustments_product_id_fkey FOREIGN KEY (product_id) REFERENCES public.products(id) ON DELETE RESTRICT;


--
-- Name: stock_purchases stock_purchases_batch_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.stock_purchases
    ADD CONSTRAINT stock_purchases_batch_id_fkey FOREIGN KEY (batch_id) REFERENCES public.product_batches(id) ON DELETE RESTRICT;


--
-- Name: stock_purchases stock_purchases_created_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.stock_purchases
    ADD CONSTRAINT stock_purchases_created_by_fkey FOREIGN KEY (created_by) REFERENCES auth.users(id);


--
-- Name: stock_purchases stock_purchases_product_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.stock_purchases
    ADD CONSTRAINT stock_purchases_product_id_fkey FOREIGN KEY (product_id) REFERENCES public.products(id) ON DELETE RESTRICT;


--
-- Name: stock_sales stock_sales_batch_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.stock_sales
    ADD CONSTRAINT stock_sales_batch_id_fkey FOREIGN KEY (batch_id) REFERENCES public.product_batches(id) ON DELETE RESTRICT;


--
-- Name: stock_sales stock_sales_created_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.stock_sales
    ADD CONSTRAINT stock_sales_created_by_fkey FOREIGN KEY (created_by) REFERENCES auth.users(id);


--
-- Name: stock_sales stock_sales_product_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.stock_sales
    ADD CONSTRAINT stock_sales_product_id_fkey FOREIGN KEY (product_id) REFERENCES public.products(id) ON DELETE RESTRICT;


--
-- Name: stock_transactions stock_transactions_batch_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.stock_transactions
    ADD CONSTRAINT stock_transactions_batch_id_fkey FOREIGN KEY (batch_id) REFERENCES public.product_batches(id) ON DELETE RESTRICT;


--
-- Name: stock_transactions stock_transactions_created_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.stock_transactions
    ADD CONSTRAINT stock_transactions_created_by_fkey FOREIGN KEY (created_by) REFERENCES auth.users(id);


--
-- Name: stock_transactions stock_transactions_product_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.stock_transactions
    ADD CONSTRAINT stock_transactions_product_id_fkey FOREIGN KEY (product_id) REFERENCES public.products(id) ON DELETE RESTRICT;


--
-- Name: mr_sales_orders trigger_update_updated_at; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.mr_sales_orders
    ADD CONSTRAINT trigger_update_updated_at FOREIGN KEY (id) REFERENCES public.mr_sales_orders(id) ON UPDATE CASCADE;


--
-- Name: profiles Admin can manage all profiles; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Admin can manage all profiles" ON public.profiles USING ((EXISTS ( SELECT 1
   FROM public.profiles p
  WHERE ((p.user_id = auth.uid()) AND (p.role = 'admin'::public.user_role))))) WITH CHECK ((EXISTS ( SELECT 1
   FROM public.profiles p
  WHERE ((p.user_id = auth.uid()) AND (p.role = 'admin'::public.user_role)))));


--
-- Name: suppliers Admin can manage suppliers; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Admin can manage suppliers" ON public.suppliers USING ((EXISTS ( SELECT 1
   FROM public.profiles
  WHERE ((profiles.user_id = auth.uid()) AND (profiles.role = 'admin'::public.user_role)))));


--
-- Name: product_categories Admins can do everything on product_categories; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Admins can do everything on product_categories" ON public.product_categories USING ((EXISTS ( SELECT 1
   FROM public.profiles
  WHERE ((profiles.user_id = auth.uid()) AND (profiles.role = 'admin'::public.user_role)))));


--
-- Name: product_formulations Admins can do everything on product_formulations; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Admins can do everything on product_formulations" ON public.product_formulations USING ((EXISTS ( SELECT 1
   FROM public.profiles
  WHERE ((profiles.user_id = auth.uid()) AND (profiles.role = 'admin'::public.user_role)))));


--
-- Name: product_sub_categories Admins can do everything on product_sub_categories; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Admins can do everything on product_sub_categories" ON public.product_sub_categories USING ((EXISTS ( SELECT 1
   FROM public.profiles
  WHERE ((profiles.user_id = auth.uid()) AND (profiles.role = 'admin'::public.user_role)))));


--
-- Name: products Admins can do everything on products; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Admins can do everything on products" ON public.products USING ((EXISTS ( SELECT 1
   FROM public.profiles
  WHERE ((profiles.user_id = auth.uid()) AND (profiles.role = 'admin'::public.user_role)))));


--
-- Name: profiles MR can view their own profile; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "MR can view their own profile" ON public.profiles FOR SELECT USING (((auth.uid() = user_id) AND (EXISTS ( SELECT 1
   FROM public.profiles p
  WHERE ((p.user_id = auth.uid()) AND (p.role = 'mr'::public.user_role))))));


--
-- Name: mr_sales_order_items MR users can create sales order items; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "MR users can create sales order items" ON public.mr_sales_order_items FOR INSERT TO authenticated WITH CHECK ((EXISTS ( SELECT 1
   FROM public.mr_sales_orders
  WHERE ((mr_sales_orders.id = mr_sales_order_items.order_id) AND (mr_sales_orders.mr_user_id = auth.uid())))));


--
-- Name: mr_sales_orders MR users can create sales orders; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "MR users can create sales orders" ON public.mr_sales_orders FOR INSERT TO authenticated WITH CHECK ((mr_user_id = auth.uid()));


--
-- Name: profiles Users can update their own profile; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Users can update their own profile" ON public.profiles FOR UPDATE USING (((auth.uid() = user_id) AND (EXISTS ( SELECT 1
   FROM public.profiles p
  WHERE ((p.user_id = auth.uid()) AND (p.role = 'user'::public.user_role)))))) WITH CHECK (((auth.uid() = user_id) AND (EXISTS ( SELECT 1
   FROM public.profiles p
  WHERE ((p.user_id = auth.uid()) AND (p.role = 'user'::public.user_role))))));


--
-- Name: suppliers Users can view active suppliers; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Users can view active suppliers" ON public.suppliers FOR SELECT USING (((is_active = true) AND (EXISTS ( SELECT 1
   FROM public.profiles
  WHERE (profiles.user_id = auth.uid())))));


--
-- Name: profiles Users can view their own profile; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Users can view their own profile" ON public.profiles FOR SELECT USING (((auth.uid() = user_id) AND (EXISTS ( SELECT 1
   FROM public.profiles p
  WHERE ((p.user_id = auth.uid()) AND (p.role = 'user'::public.user_role))))));


--
-- Name: product_categories Workers can view product_categories; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Workers can view product_categories" ON public.product_categories FOR SELECT USING ((EXISTS ( SELECT 1
   FROM public.profiles
  WHERE ((profiles.user_id = auth.uid()) AND (profiles.role = ANY (ARRAY['admin'::public.user_role, 'user'::public.user_role]))))));


--
-- Name: product_formulations Workers can view product_formulations; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Workers can view product_formulations" ON public.product_formulations FOR SELECT USING ((EXISTS ( SELECT 1
   FROM public.profiles
  WHERE ((profiles.user_id = auth.uid()) AND (profiles.role = ANY (ARRAY['admin'::public.user_role, 'user'::public.user_role]))))));


--
-- Name: product_sub_categories Workers can view product_sub_categories; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Workers can view product_sub_categories" ON public.product_sub_categories FOR SELECT USING ((EXISTS ( SELECT 1
   FROM public.profiles
  WHERE ((profiles.user_id = auth.uid()) AND (profiles.role = ANY (ARRAY['admin'::public.user_role, 'user'::public.user_role]))))));


--
-- Name: products Workers can view products; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Workers can view products" ON public.products FOR SELECT USING ((EXISTS ( SELECT 1
   FROM public.profiles
  WHERE ((profiles.user_id = auth.uid()) AND (profiles.role = ANY (ARRAY['admin'::public.user_role, 'user'::public.user_role]))))));


--
-- Name: mr_stock_summary; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.mr_stock_summary ENABLE ROW LEVEL SECURITY;

--
-- Name: mr_stock_summary mr_stock_summary_delete_policy; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY mr_stock_summary_delete_policy ON public.mr_stock_summary FOR DELETE TO authenticated USING ((EXISTS ( SELECT 1
   FROM public.profiles
  WHERE ((profiles.user_id = auth.uid()) AND (profiles.role = 'admin'::public.user_role)))));


--
-- Name: mr_stock_summary mr_stock_summary_insert_policy; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY mr_stock_summary_insert_policy ON public.mr_stock_summary FOR INSERT TO authenticated WITH CHECK ((EXISTS ( SELECT 1
   FROM public.profiles
  WHERE ((profiles.user_id = auth.uid()) AND (profiles.role = 'admin'::public.user_role)))));


--
-- Name: mr_stock_summary mr_stock_summary_select_policy; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY mr_stock_summary_select_policy ON public.mr_stock_summary FOR SELECT TO authenticated USING (true);


--
-- Name: mr_stock_summary mr_stock_summary_update_policy; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY mr_stock_summary_update_policy ON public.mr_stock_summary FOR UPDATE TO authenticated USING ((EXISTS ( SELECT 1
   FROM public.profiles
  WHERE ((profiles.user_id = auth.uid()) AND (profiles.role = 'admin'::public.user_role))))) WITH CHECK ((EXISTS ( SELECT 1
   FROM public.profiles
  WHERE ((profiles.user_id = auth.uid()) AND (profiles.role = 'admin'::public.user_role)))));


--
-- Name: packaging_templates; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.packaging_templates ENABLE ROW LEVEL SECURITY;

--
-- Name: packaging_templates packaging_templates_delete_policy; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY packaging_templates_delete_policy ON public.packaging_templates FOR DELETE TO authenticated USING ((EXISTS ( SELECT 1
   FROM public.profiles
  WHERE ((profiles.user_id = auth.uid()) AND (profiles.role = 'admin'::public.user_role)))));


--
-- Name: packaging_templates packaging_templates_insert_policy; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY packaging_templates_insert_policy ON public.packaging_templates FOR INSERT TO authenticated WITH CHECK ((EXISTS ( SELECT 1
   FROM public.profiles
  WHERE ((profiles.user_id = auth.uid()) AND (profiles.role = 'admin'::public.user_role)))));


--
-- Name: packaging_templates packaging_templates_select_policy; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY packaging_templates_select_policy ON public.packaging_templates FOR SELECT TO authenticated USING (true);


--
-- Name: packaging_templates packaging_templates_update_policy; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY packaging_templates_update_policy ON public.packaging_templates FOR UPDATE TO authenticated USING ((EXISTS ( SELECT 1
   FROM public.profiles
  WHERE ((profiles.user_id = auth.uid()) AND (profiles.role = 'admin'::public.user_role))))) WITH CHECK ((EXISTS ( SELECT 1
   FROM public.profiles
  WHERE ((profiles.user_id = auth.uid()) AND (profiles.role = 'admin'::public.user_role)))));


--
-- Name: product_batches; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.product_batches ENABLE ROW LEVEL SECURITY;

--
-- Name: product_batches product_batches_delete_policy; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY product_batches_delete_policy ON public.product_batches FOR DELETE TO authenticated USING ((EXISTS ( SELECT 1
   FROM public.profiles
  WHERE ((profiles.user_id = auth.uid()) AND (profiles.role = 'admin'::public.user_role)))));


--
-- Name: product_batches product_batches_insert_policy; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY product_batches_insert_policy ON public.product_batches FOR INSERT TO authenticated WITH CHECK ((EXISTS ( SELECT 1
   FROM public.profiles
  WHERE ((profiles.user_id = auth.uid()) AND (profiles.role = 'admin'::public.user_role)))));


--
-- Name: product_batches product_batches_select_policy; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY product_batches_select_policy ON public.product_batches FOR SELECT TO authenticated USING (true);


--
-- Name: product_batches product_batches_update_policy; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY product_batches_update_policy ON public.product_batches FOR UPDATE TO authenticated USING ((EXISTS ( SELECT 1
   FROM public.profiles
  WHERE ((profiles.user_id = auth.uid()) AND (profiles.role = 'admin'::public.user_role))))) WITH CHECK ((EXISTS ( SELECT 1
   FROM public.profiles
  WHERE ((profiles.user_id = auth.uid()) AND (profiles.role = 'admin'::public.user_role)))));


--
-- Name: product_categories; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.product_categories ENABLE ROW LEVEL SECURITY;

--
-- Name: product_categories product_categories_delete_policy; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY product_categories_delete_policy ON public.product_categories FOR DELETE TO authenticated USING ((EXISTS ( SELECT 1
   FROM public.profiles
  WHERE ((profiles.user_id = auth.uid()) AND (profiles.role = 'admin'::public.user_role)))));


--
-- Name: product_categories product_categories_insert_policy; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY product_categories_insert_policy ON public.product_categories FOR INSERT TO authenticated WITH CHECK ((EXISTS ( SELECT 1
   FROM public.profiles
  WHERE ((profiles.user_id = auth.uid()) AND (profiles.role = 'admin'::public.user_role)))));


--
-- Name: product_categories product_categories_select_policy; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY product_categories_select_policy ON public.product_categories FOR SELECT TO authenticated USING (true);


--
-- Name: product_categories product_categories_update_policy; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY product_categories_update_policy ON public.product_categories FOR UPDATE TO authenticated USING ((EXISTS ( SELECT 1
   FROM public.profiles
  WHERE ((profiles.user_id = auth.uid()) AND (profiles.role = 'admin'::public.user_role))))) WITH CHECK ((EXISTS ( SELECT 1
   FROM public.profiles
  WHERE ((profiles.user_id = auth.uid()) AND (profiles.role = 'admin'::public.user_role)))));


--
-- Name: product_formulations; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.product_formulations ENABLE ROW LEVEL SECURITY;

--
-- Name: product_formulations product_formulations_delete_policy; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY product_formulations_delete_policy ON public.product_formulations FOR DELETE TO authenticated USING ((EXISTS ( SELECT 1
   FROM public.profiles
  WHERE ((profiles.user_id = auth.uid()) AND (profiles.role = 'admin'::public.user_role)))));


--
-- Name: product_formulations product_formulations_insert_policy; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY product_formulations_insert_policy ON public.product_formulations FOR INSERT TO authenticated WITH CHECK ((EXISTS ( SELECT 1
   FROM public.profiles
  WHERE ((profiles.user_id = auth.uid()) AND (profiles.role = 'admin'::public.user_role)))));


--
-- Name: product_formulations product_formulations_select_policy; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY product_formulations_select_policy ON public.product_formulations FOR SELECT TO authenticated USING (true);


--
-- Name: product_formulations product_formulations_update_policy; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY product_formulations_update_policy ON public.product_formulations FOR UPDATE TO authenticated USING ((EXISTS ( SELECT 1
   FROM public.profiles
  WHERE ((profiles.user_id = auth.uid()) AND (profiles.role = 'admin'::public.user_role))))) WITH CHECK ((EXISTS ( SELECT 1
   FROM public.profiles
  WHERE ((profiles.user_id = auth.uid()) AND (profiles.role = 'admin'::public.user_role)))));


--
-- Name: product_packaging_units; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.product_packaging_units ENABLE ROW LEVEL SECURITY;

--
-- Name: product_packaging_units product_packaging_units_delete_policy; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY product_packaging_units_delete_policy ON public.product_packaging_units FOR DELETE TO authenticated USING ((EXISTS ( SELECT 1
   FROM public.profiles
  WHERE ((profiles.user_id = auth.uid()) AND (profiles.role = 'admin'::public.user_role)))));


--
-- Name: product_packaging_units product_packaging_units_insert_policy; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY product_packaging_units_insert_policy ON public.product_packaging_units FOR INSERT TO authenticated WITH CHECK ((EXISTS ( SELECT 1
   FROM public.profiles
  WHERE ((profiles.user_id = auth.uid()) AND (profiles.role = 'admin'::public.user_role)))));


--
-- Name: product_packaging_units product_packaging_units_select_policy; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY product_packaging_units_select_policy ON public.product_packaging_units FOR SELECT TO authenticated USING (true);


--
-- Name: product_packaging_units product_packaging_units_update_policy; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY product_packaging_units_update_policy ON public.product_packaging_units FOR UPDATE TO authenticated USING ((EXISTS ( SELECT 1
   FROM public.profiles
  WHERE ((profiles.user_id = auth.uid()) AND (profiles.role = 'admin'::public.user_role))))) WITH CHECK ((EXISTS ( SELECT 1
   FROM public.profiles
  WHERE ((profiles.user_id = auth.uid()) AND (profiles.role = 'admin'::public.user_role)))));


--
-- Name: product_sub_categories; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.product_sub_categories ENABLE ROW LEVEL SECURITY;

--
-- Name: product_sub_categories product_sub_categories_delete_policy; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY product_sub_categories_delete_policy ON public.product_sub_categories FOR DELETE TO authenticated USING ((EXISTS ( SELECT 1
   FROM public.profiles
  WHERE ((profiles.user_id = auth.uid()) AND (profiles.role = 'admin'::public.user_role)))));


--
-- Name: product_sub_categories product_sub_categories_insert_policy; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY product_sub_categories_insert_policy ON public.product_sub_categories FOR INSERT TO authenticated WITH CHECK ((EXISTS ( SELECT 1
   FROM public.profiles
  WHERE ((profiles.user_id = auth.uid()) AND (profiles.role = 'admin'::public.user_role)))));


--
-- Name: product_sub_categories product_sub_categories_select_policy; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY product_sub_categories_select_policy ON public.product_sub_categories FOR SELECT TO authenticated USING (true);


--
-- Name: product_sub_categories product_sub_categories_update_policy; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY product_sub_categories_update_policy ON public.product_sub_categories FOR UPDATE TO authenticated USING ((EXISTS ( SELECT 1
   FROM public.profiles
  WHERE ((profiles.user_id = auth.uid()) AND (profiles.role = 'admin'::public.user_role))))) WITH CHECK ((EXISTS ( SELECT 1
   FROM public.profiles
  WHERE ((profiles.user_id = auth.uid()) AND (profiles.role = 'admin'::public.user_role)))));


--
-- Name: products; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.products ENABLE ROW LEVEL SECURITY;

--
-- Name: products products_delete_policy; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY products_delete_policy ON public.products FOR DELETE TO authenticated USING ((EXISTS ( SELECT 1
   FROM public.profiles
  WHERE ((profiles.user_id = auth.uid()) AND (profiles.role = 'admin'::public.user_role)))));


--
-- Name: products products_insert_policy; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY products_insert_policy ON public.products FOR INSERT TO authenticated WITH CHECK ((EXISTS ( SELECT 1
   FROM public.profiles
  WHERE ((profiles.user_id = auth.uid()) AND (profiles.role = 'admin'::public.user_role)))));


--
-- Name: products products_select_policy; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY products_select_policy ON public.products FOR SELECT TO authenticated USING (true);


--
-- Name: products_stock_status; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.products_stock_status ENABLE ROW LEVEL SECURITY;

--
-- Name: products_stock_status products_stock_status_delete_policy; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY products_stock_status_delete_policy ON public.products_stock_status FOR DELETE TO authenticated USING ((EXISTS ( SELECT 1
   FROM public.profiles
  WHERE ((profiles.user_id = auth.uid()) AND (profiles.role = 'admin'::public.user_role)))));


--
-- Name: products_stock_status products_stock_status_insert_policy; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY products_stock_status_insert_policy ON public.products_stock_status FOR INSERT TO authenticated WITH CHECK ((EXISTS ( SELECT 1
   FROM public.profiles
  WHERE ((profiles.user_id = auth.uid()) AND (profiles.role = 'admin'::public.user_role)))));


--
-- Name: products_stock_status products_stock_status_select_policy; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY products_stock_status_select_policy ON public.products_stock_status FOR SELECT TO authenticated USING (true);


--
-- Name: products_stock_status products_stock_status_update_policy; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY products_stock_status_update_policy ON public.products_stock_status FOR UPDATE TO authenticated USING ((EXISTS ( SELECT 1
   FROM public.profiles
  WHERE ((profiles.user_id = auth.uid()) AND (profiles.role = 'admin'::public.user_role))))) WITH CHECK ((EXISTS ( SELECT 1
   FROM public.profiles
  WHERE ((profiles.user_id = auth.uid()) AND (profiles.role = 'admin'::public.user_role)))));


--
-- Name: products products_update_policy; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY products_update_policy ON public.products FOR UPDATE TO authenticated USING ((EXISTS ( SELECT 1
   FROM public.profiles
  WHERE ((profiles.user_id = auth.uid()) AND (profiles.role = 'admin'::public.user_role))))) WITH CHECK ((EXISTS ( SELECT 1
   FROM public.profiles
  WHERE ((profiles.user_id = auth.uid()) AND (profiles.role = 'admin'::public.user_role)))));


--
-- Name: stock_adjustments; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.stock_adjustments ENABLE ROW LEVEL SECURITY;

--
-- Name: stock_adjustments stock_adjustments_delete_policy; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY stock_adjustments_delete_policy ON public.stock_adjustments FOR DELETE TO authenticated USING ((EXISTS ( SELECT 1
   FROM public.profiles
  WHERE ((profiles.user_id = auth.uid()) AND (profiles.role = 'admin'::public.user_role)))));


--
-- Name: stock_adjustments stock_adjustments_insert_policy; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY stock_adjustments_insert_policy ON public.stock_adjustments FOR INSERT TO authenticated WITH CHECK ((EXISTS ( SELECT 1
   FROM public.profiles
  WHERE ((profiles.user_id = auth.uid()) AND (profiles.role = 'admin'::public.user_role)))));


--
-- Name: stock_adjustments stock_adjustments_select_policy; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY stock_adjustments_select_policy ON public.stock_adjustments FOR SELECT TO authenticated USING (true);


--
-- Name: stock_adjustments stock_adjustments_update_policy; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY stock_adjustments_update_policy ON public.stock_adjustments FOR UPDATE TO authenticated USING ((EXISTS ( SELECT 1
   FROM public.profiles
  WHERE ((profiles.user_id = auth.uid()) AND (profiles.role = 'admin'::public.user_role))))) WITH CHECK ((EXISTS ( SELECT 1
   FROM public.profiles
  WHERE ((profiles.user_id = auth.uid()) AND (profiles.role = 'admin'::public.user_role)))));


--
-- Name: stock_purchases; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.stock_purchases ENABLE ROW LEVEL SECURITY;

--
-- Name: stock_purchases stock_purchases_delete_policy; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY stock_purchases_delete_policy ON public.stock_purchases FOR DELETE TO authenticated USING ((EXISTS ( SELECT 1
   FROM public.profiles
  WHERE ((profiles.user_id = auth.uid()) AND (profiles.role = 'admin'::public.user_role)))));


--
-- Name: stock_purchases stock_purchases_insert_policy; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY stock_purchases_insert_policy ON public.stock_purchases FOR INSERT TO authenticated WITH CHECK ((EXISTS ( SELECT 1
   FROM public.profiles
  WHERE ((profiles.user_id = auth.uid()) AND (profiles.role = 'admin'::public.user_role)))));


--
-- Name: stock_purchases stock_purchases_select_policy; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY stock_purchases_select_policy ON public.stock_purchases FOR SELECT TO authenticated USING (true);


--
-- Name: stock_purchases stock_purchases_update_policy; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY stock_purchases_update_policy ON public.stock_purchases FOR UPDATE TO authenticated USING ((EXISTS ( SELECT 1
   FROM public.profiles
  WHERE ((profiles.user_id = auth.uid()) AND (profiles.role = 'admin'::public.user_role))))) WITH CHECK ((EXISTS ( SELECT 1
   FROM public.profiles
  WHERE ((profiles.user_id = auth.uid()) AND (profiles.role = 'admin'::public.user_role)))));


--
-- Name: stock_sales; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.stock_sales ENABLE ROW LEVEL SECURITY;

--
-- Name: stock_sales stock_sales_delete_policy; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY stock_sales_delete_policy ON public.stock_sales FOR DELETE TO authenticated USING ((EXISTS ( SELECT 1
   FROM public.profiles
  WHERE ((profiles.user_id = auth.uid()) AND (profiles.role = 'admin'::public.user_role)))));


--
-- Name: stock_sales stock_sales_insert_policy; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY stock_sales_insert_policy ON public.stock_sales FOR INSERT TO authenticated WITH CHECK ((EXISTS ( SELECT 1
   FROM public.profiles
  WHERE ((profiles.user_id = auth.uid()) AND (profiles.role = 'admin'::public.user_role)))));


--
-- Name: stock_sales stock_sales_select_policy; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY stock_sales_select_policy ON public.stock_sales FOR SELECT TO authenticated USING (true);


--
-- Name: stock_sales stock_sales_update_policy; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY stock_sales_update_policy ON public.stock_sales FOR UPDATE TO authenticated USING ((EXISTS ( SELECT 1
   FROM public.profiles
  WHERE ((profiles.user_id = auth.uid()) AND (profiles.role = 'admin'::public.user_role))))) WITH CHECK ((EXISTS ( SELECT 1
   FROM public.profiles
  WHERE ((profiles.user_id = auth.uid()) AND (profiles.role = 'admin'::public.user_role)))));


--
-- Name: stock_transactions; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.stock_transactions ENABLE ROW LEVEL SECURITY;

--
-- Name: stock_transactions stock_transactions_delete_policy; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY stock_transactions_delete_policy ON public.stock_transactions FOR DELETE TO authenticated USING ((EXISTS ( SELECT 1
   FROM public.profiles
  WHERE ((profiles.user_id = auth.uid()) AND (profiles.role = 'admin'::public.user_role)))));


--
-- Name: stock_transactions stock_transactions_insert_policy; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY stock_transactions_insert_policy ON public.stock_transactions FOR INSERT TO authenticated WITH CHECK ((EXISTS ( SELECT 1
   FROM public.profiles
  WHERE ((profiles.user_id = auth.uid()) AND (profiles.role = 'admin'::public.user_role)))));


--
-- Name: stock_transactions stock_transactions_select_policy; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY stock_transactions_select_policy ON public.stock_transactions FOR SELECT TO authenticated USING (true);


--
-- Name: stock_transactions stock_transactions_update_policy; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY stock_transactions_update_policy ON public.stock_transactions FOR UPDATE TO authenticated USING ((EXISTS ( SELECT 1
   FROM public.profiles
  WHERE ((profiles.user_id = auth.uid()) AND (profiles.role = 'admin'::public.user_role))))) WITH CHECK ((EXISTS ( SELECT 1
   FROM public.profiles
  WHERE ((profiles.user_id = auth.uid()) AND (profiles.role = 'admin'::public.user_role)))));


--
-- Name: suppliers; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.suppliers ENABLE ROW LEVEL SECURITY;

--
-- PostgreSQL database dump complete
--

