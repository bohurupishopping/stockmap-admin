

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;


CREATE EXTENSION IF NOT EXISTS "pg_net" WITH SCHEMA "extensions";






CREATE EXTENSION IF NOT EXISTS "pgsodium";






COMMENT ON SCHEMA "public" IS 'standard public schema';



CREATE EXTENSION IF NOT EXISTS "pg_graphql" WITH SCHEMA "graphql";






CREATE EXTENSION IF NOT EXISTS "pg_stat_statements" WITH SCHEMA "extensions";






CREATE EXTENSION IF NOT EXISTS "pgcrypto" WITH SCHEMA "extensions";






CREATE EXTENSION IF NOT EXISTS "pgjwt" WITH SCHEMA "extensions";






CREATE EXTENSION IF NOT EXISTS "supabase_vault" WITH SCHEMA "vault";






CREATE EXTENSION IF NOT EXISTS "uuid-ossp" WITH SCHEMA "extensions";






CREATE TYPE "public"."user_role" AS ENUM (
    'admin',
    'user'
);


ALTER TYPE "public"."user_role" OWNER TO "supabase_admin";


CREATE OR REPLACE FUNCTION "public"."calculate_closing_stock"("p_product_id" "uuid", "p_batch_id" "uuid", "p_location_type" "text", "p_location_id" "text", "p_report_date" "date") RETURNS integer
    LANGUAGE "plpgsql"
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


ALTER FUNCTION "public"."calculate_closing_stock"("p_product_id" "uuid", "p_batch_id" "uuid", "p_location_type" "text", "p_location_id" "text", "p_report_date" "date") OWNER TO "supabase_admin";


CREATE OR REPLACE FUNCTION "public"."handle_new_user"() RETURNS "trigger"
    LANGUAGE "plpgsql" SECURITY DEFINER
    SET "search_path" TO ''
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


ALTER FUNCTION "public"."handle_new_user"() OWNER TO "supabase_admin";


CREATE OR REPLACE FUNCTION "public"."is_admin"("user_uuid" "uuid") RETURNS boolean
    LANGUAGE "sql" SECURITY DEFINER
    AS $$
  SELECT EXISTS (
    SELECT 1 FROM public.profiles 
    WHERE user_id = user_uuid AND role = 'admin'
  );
$$;


ALTER FUNCTION "public"."is_admin"("user_uuid" "uuid") OWNER TO "supabase_admin";


CREATE OR REPLACE FUNCTION "public"."recalculate_closing_stock_reports"() RETURNS "void"
    LANGUAGE "plpgsql"
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


ALTER FUNCTION "public"."recalculate_closing_stock_reports"() OWNER TO "supabase_admin";


CREATE OR REPLACE FUNCTION "public"."recalculate_products_stock_status"() RETURNS "void"
    LANGUAGE "plpgsql"
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


ALTER FUNCTION "public"."recalculate_products_stock_status"() OWNER TO "supabase_admin";


CREATE OR REPLACE FUNCTION "public"."update_closing_stock_report"() RETURNS "trigger"
    LANGUAGE "plpgsql"
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


ALTER FUNCTION "public"."update_closing_stock_report"() OWNER TO "supabase_admin";


CREATE OR REPLACE FUNCTION "public"."update_mr_stock_summary"() RETURNS "trigger"
    LANGUAGE "plpgsql"
    AS $$
BEGIN
  -- Only process transactions that affect MR stock
  IF NEW.location_type_destination = 'MR' OR NEW.location_type_source = 'MR' THEN
    
    -- Handle MR as destination (stock increase)
    IF NEW.location_type_destination = 'MR' AND NEW.location_id_destination IS NOT NULL THEN
      INSERT INTO public.mr_stock_summary (mr_user_id, product_id, batch_id, current_quantity_strips, last_updated_at)
      VALUES (NEW.location_id_destination::UUID, NEW.product_id, NEW.batch_id, NEW.quantity_strips, now())
      ON CONFLICT (mr_user_id, product_id, batch_id)
      DO UPDATE SET 
        current_quantity_strips = mr_stock_summary.current_quantity_strips + NEW.quantity_strips,
        last_updated_at = now();
    END IF;
    
    -- Handle MR as source (stock decrease)
    IF NEW.location_type_source = 'MR' AND NEW.location_id_source IS NOT NULL THEN
      INSERT INTO public.mr_stock_summary (mr_user_id, product_id, batch_id, current_quantity_strips, last_updated_at)
      VALUES (NEW.location_id_source::UUID, NEW.product_id, NEW.batch_id, -NEW.quantity_strips, now())
      ON CONFLICT (mr_user_id, product_id, batch_id)
      DO UPDATE SET 
        current_quantity_strips = mr_stock_summary.current_quantity_strips - NEW.quantity_strips,
        last_updated_at = now();
    END IF;
    
  END IF;
  
  RETURN NEW;
END;
$$;


ALTER FUNCTION "public"."update_mr_stock_summary"() OWNER TO "supabase_admin";


CREATE OR REPLACE FUNCTION "public"."update_mr_stock_summary_from_adjustments"() RETURNS "trigger"
    LANGUAGE "plpgsql"
    AS $$
BEGIN
  -- Handle MR as destination (stock increase)
  IF NEW.location_type_destination = 'MR' AND NEW.location_id_destination IS NOT NULL THEN
    INSERT INTO public.mr_stock_summary (mr_user_id, product_id, batch_id, current_quantity_strips, last_updated_at)
    VALUES (NEW.location_id_destination::UUID, NEW.product_id, NEW.batch_id, NEW.quantity_strips, now())
    ON CONFLICT (mr_user_id, product_id, batch_id)
    DO UPDATE SET 
      current_quantity_strips = mr_stock_summary.current_quantity_strips + NEW.quantity_strips,
      last_updated_at = now();
  END IF;
  
  -- Handle MR as source (stock decrease)
  IF NEW.location_type_source = 'MR' AND NEW.location_id_source IS NOT NULL THEN
    INSERT INTO public.mr_stock_summary (mr_user_id, product_id, batch_id, current_quantity_strips, last_updated_at)
    VALUES (NEW.location_id_source::UUID, NEW.product_id, NEW.batch_id, -NEW.quantity_strips, now())
    ON CONFLICT (mr_user_id, product_id, batch_id)
    DO UPDATE SET 
      current_quantity_strips = mr_stock_summary.current_quantity_strips - NEW.quantity_strips,
      last_updated_at = now();
  END IF;
  
  RETURN NEW;
END;
$$;


ALTER FUNCTION "public"."update_mr_stock_summary_from_adjustments"() OWNER TO "supabase_admin";


CREATE OR REPLACE FUNCTION "public"."update_mr_stock_summary_from_sales"() RETURNS "trigger"
    LANGUAGE "plpgsql"
    AS $$
BEGIN
  -- Handle MR as destination (stock increase)
  IF NEW.location_type_destination = 'MR' AND NEW.location_id_destination IS NOT NULL THEN
    INSERT INTO public.mr_stock_summary (mr_user_id, product_id, batch_id, current_quantity_strips, last_updated_at)
    VALUES (NEW.location_id_destination::UUID, NEW.product_id, NEW.batch_id, NEW.quantity_strips, now())
    ON CONFLICT (mr_user_id, product_id, batch_id)
    DO UPDATE SET 
      current_quantity_strips = mr_stock_summary.current_quantity_strips + NEW.quantity_strips,
      last_updated_at = now();
  END IF;
  
  -- Handle MR as source (stock decrease)
  IF NEW.location_type_source = 'MR' AND NEW.location_id_source IS NOT NULL THEN
    INSERT INTO public.mr_stock_summary (mr_user_id, product_id, batch_id, current_quantity_strips, last_updated_at)
    VALUES (NEW.location_id_source::UUID, NEW.product_id, NEW.batch_id, -NEW.quantity_strips, now())
    ON CONFLICT (mr_user_id, product_id, batch_id)
    DO UPDATE SET 
      current_quantity_strips = mr_stock_summary.current_quantity_strips - NEW.quantity_strips,
      last_updated_at = now();
  END IF;
  
  RETURN NEW;
END;
$$;


ALTER FUNCTION "public"."update_mr_stock_summary_from_sales"() OWNER TO "supabase_admin";


CREATE OR REPLACE FUNCTION "public"."update_products_stock_status"() RETURNS "trigger"
    LANGUAGE "plpgsql"
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


ALTER FUNCTION "public"."update_products_stock_status"() OWNER TO "supabase_admin";


CREATE OR REPLACE FUNCTION "public"."update_updated_at_column"() RETURNS "trigger"
    LANGUAGE "plpgsql"
    AS $$
BEGIN
    NEW.updated_at = now();
    RETURN NEW;
END;
$$;


ALTER FUNCTION "public"."update_updated_at_column"() OWNER TO "supabase_admin";


CREATE OR REPLACE FUNCTION "public"."validate_batch_dates"() RETURNS "trigger"
    LANGUAGE "plpgsql"
    AS $$
BEGIN
  -- Check if expiry date is after manufacturing date
  IF NEW.expiry_date <= NEW.manufacturing_date THEN
    RAISE EXCEPTION 'Expiry date must be after manufacturing date';
  END IF;
  
  RETURN NEW;
END;
$$;


ALTER FUNCTION "public"."validate_batch_dates"() OWNER TO "supabase_admin";


CREATE OR REPLACE FUNCTION "public"."validate_single_base_unit"() RETURNS "trigger"
    LANGUAGE "plpgsql"
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


ALTER FUNCTION "public"."validate_single_base_unit"() OWNER TO "supabase_admin";


CREATE OR REPLACE FUNCTION "public"."validate_template_name"() RETURNS "trigger"
    LANGUAGE "plpgsql"
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


ALTER FUNCTION "public"."validate_template_name"() OWNER TO "supabase_admin";

SET default_tablespace = '';

SET default_table_access_method = "heap";


CREATE TABLE IF NOT EXISTS "public"."mr_stock_summary" (
    "mr_user_id" "uuid" NOT NULL,
    "product_id" "uuid" NOT NULL,
    "batch_id" "uuid" NOT NULL,
    "current_quantity_strips" integer DEFAULT 0 NOT NULL,
    "last_updated_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    CONSTRAINT "non_negative_quantity" CHECK (("current_quantity_strips" >= 0))
);


ALTER TABLE "public"."mr_stock_summary" OWNER TO "supabase_admin";


CREATE TABLE IF NOT EXISTS "public"."packaging_templates" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "template_name" "text" NOT NULL,
    "unit_name" "text" NOT NULL,
    "conversion_factor_to_strips" integer DEFAULT 1 NOT NULL,
    "is_base_unit" boolean DEFAULT false NOT NULL,
    "order_in_hierarchy" integer DEFAULT 1 NOT NULL,
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "updated_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    CONSTRAINT "positive_conversion_factor" CHECK (("conversion_factor_to_strips" > 0)),
    CONSTRAINT "positive_order" CHECK (("order_in_hierarchy" > 0))
);


ALTER TABLE "public"."packaging_templates" OWNER TO "supabase_admin";


CREATE TABLE IF NOT EXISTS "public"."product_batches" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "product_id" "uuid" NOT NULL,
    "batch_number" "text" NOT NULL,
    "manufacturing_date" "date" NOT NULL,
    "expiry_date" "date" NOT NULL,
    "batch_cost_per_strip" numeric(10,2),
    "status" "text" DEFAULT 'Active'::"text" NOT NULL,
    "notes" "text",
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "updated_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    CONSTRAINT "positive_batch_cost" CHECK ((("batch_cost_per_strip" > (0)::numeric) OR ("batch_cost_per_strip" IS NULL))),
    CONSTRAINT "valid_batch_status" CHECK (("status" = ANY (ARRAY['Active'::"text", 'Expired'::"text", 'Recalled'::"text", 'Quarantined'::"text"])))
);


ALTER TABLE "public"."product_batches" OWNER TO "supabase_admin";


CREATE TABLE IF NOT EXISTS "public"."product_categories" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "category_name" "text" NOT NULL,
    "description" "text",
    "is_active" boolean DEFAULT true NOT NULL,
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "updated_at" timestamp with time zone DEFAULT "now"() NOT NULL
);


ALTER TABLE "public"."product_categories" OWNER TO "supabase_admin";


CREATE TABLE IF NOT EXISTS "public"."product_formulations" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "formulation_name" "text" NOT NULL,
    "is_active" boolean DEFAULT true NOT NULL,
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "updated_at" timestamp with time zone DEFAULT "now"() NOT NULL
);


ALTER TABLE "public"."product_formulations" OWNER TO "supabase_admin";


CREATE TABLE IF NOT EXISTS "public"."product_packaging_units" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "product_id" "uuid" NOT NULL,
    "unit_name" "text" NOT NULL,
    "conversion_factor_to_strips" integer DEFAULT 1 NOT NULL,
    "is_base_unit" boolean DEFAULT false NOT NULL,
    "order_in_hierarchy" integer NOT NULL,
    "default_purchase_unit" boolean DEFAULT false NOT NULL,
    "default_sales_unit_mr" boolean DEFAULT false NOT NULL,
    "default_sales_unit_direct" boolean DEFAULT false NOT NULL,
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "updated_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "template_id" "uuid",
    CONSTRAINT "positive_conversion_factor" CHECK (("conversion_factor_to_strips" > 0)),
    CONSTRAINT "positive_order" CHECK (("order_in_hierarchy" > 0))
);


ALTER TABLE "public"."product_packaging_units" OWNER TO "supabase_admin";


CREATE TABLE IF NOT EXISTS "public"."product_sub_categories" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "sub_category_name" "text" NOT NULL,
    "category_id" "uuid" NOT NULL,
    "description" "text",
    "is_active" boolean DEFAULT true NOT NULL,
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "updated_at" timestamp with time zone DEFAULT "now"() NOT NULL
);


ALTER TABLE "public"."product_sub_categories" OWNER TO "supabase_admin";


CREATE TABLE IF NOT EXISTS "public"."products" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "product_code" "text" NOT NULL,
    "product_name" "text" NOT NULL,
    "generic_name" "text" NOT NULL,
    "manufacturer" "text" NOT NULL,
    "category_id" "uuid" NOT NULL,
    "sub_category_id" "uuid",
    "formulation_id" "uuid" NOT NULL,
    "unit_of_measure_smallest" "text" DEFAULT 'Strip'::"text" NOT NULL,
    "base_cost_per_strip" numeric(10,2) NOT NULL,
    "is_active" boolean DEFAULT true NOT NULL,
    "storage_conditions" "text",
    "image_url" "text",
    "min_stock_level_godown" integer DEFAULT 0,
    "min_stock_level_mr" integer DEFAULT 0,
    "lead_time_days" integer DEFAULT 0,
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "updated_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "packaging_template" "text",
    CONSTRAINT "products_base_cost_per_strip_check" CHECK (("base_cost_per_strip" >= (0)::numeric)),
    CONSTRAINT "products_lead_time_days_check" CHECK (("lead_time_days" >= 0)),
    CONSTRAINT "products_min_stock_level_godown_check" CHECK (("min_stock_level_godown" >= 0)),
    CONSTRAINT "products_min_stock_level_mr_check" CHECK (("min_stock_level_mr" >= 0))
);


ALTER TABLE "public"."products" OWNER TO "supabase_admin";


COMMENT ON COLUMN "public"."products"."packaging_template" IS 'References the template_name from packaging_templates table. Used to group packaging units.';



CREATE TABLE IF NOT EXISTS "public"."products_stock_status" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "product_id" "uuid" NOT NULL,
    "batch_id" "uuid" NOT NULL,
    "location_type" "text" NOT NULL,
    "location_id" "text" NOT NULL,
    "current_quantity_strips" integer DEFAULT 0 NOT NULL,
    "cost_per_strip" numeric DEFAULT 0 NOT NULL,
    "total_value" numeric GENERATED ALWAYS AS ((("current_quantity_strips")::numeric * "cost_per_strip")) STORED,
    "last_updated_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL
);


ALTER TABLE "public"."products_stock_status" OWNER TO "supabase_admin";


CREATE TABLE IF NOT EXISTS "public"."profiles" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "user_id" "uuid" NOT NULL,
    "name" "text" NOT NULL,
    "email" "text" NOT NULL,
    "role" "public"."user_role" DEFAULT 'user'::"public"."user_role" NOT NULL,
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "updated_at" timestamp with time zone DEFAULT "now"() NOT NULL
);


ALTER TABLE "public"."profiles" OWNER TO "supabase_admin";


CREATE TABLE IF NOT EXISTS "public"."stock_adjustments" (
    "adjustment_id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "adjustment_group_id" "uuid" NOT NULL,
    "product_id" "uuid" NOT NULL,
    "batch_id" "uuid" NOT NULL,
    "adjustment_type" "text" NOT NULL,
    "quantity_strips" integer NOT NULL,
    "location_type_source" "text",
    "location_id_source" "text",
    "location_type_destination" "text",
    "location_id_destination" "text",
    "adjustment_date" timestamp with time zone DEFAULT "now"() NOT NULL,
    "reference_document_id" "text",
    "cost_per_strip" numeric(10,2) NOT NULL,
    "notes" "text",
    "created_by" "uuid",
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    CONSTRAINT "positive_adjustment_cost" CHECK (("cost_per_strip" > (0)::numeric)),
    CONSTRAINT "valid_adjustment_type" CHECK (("adjustment_type" = ANY (ARRAY['RETURN_TO_GODOWN'::"text", 'RETURN_TO_MR'::"text", 'ADJUST_DAMAGE_GODOWN'::"text", 'ADJUST_LOSS_GODOWN'::"text", 'ADJUST_DAMAGE_MR'::"text", 'ADJUST_LOSS_MR'::"text", 'ADJUST_EXPIRED_GODOWN'::"text", 'ADJUST_EXPIRED_MR'::"text", 'REPLACEMENT_FROM_GODOWN'::"text", 'REPLACEMENT_FROM_MR'::"text", 'OPENING_STOCK_GODOWN'::"text", 'OPENING_STOCK_MR'::"text"])))
);


ALTER TABLE "public"."stock_adjustments" OWNER TO "supabase_admin";


CREATE TABLE IF NOT EXISTS "public"."stock_purchases" (
    "purchase_id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "purchase_group_id" "uuid" NOT NULL,
    "product_id" "uuid" NOT NULL,
    "batch_id" "uuid" NOT NULL,
    "quantity_strips" integer NOT NULL,
    "supplier_id" "text",
    "purchase_date" timestamp with time zone DEFAULT "now"() NOT NULL,
    "reference_document_id" "text",
    "cost_per_strip" numeric(10,2) NOT NULL,
    "notes" "text",
    "created_by" "uuid",
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    CONSTRAINT "positive_purchase_cost" CHECK (("cost_per_strip" > (0)::numeric)),
    CONSTRAINT "positive_purchase_quantity" CHECK (("quantity_strips" > 0))
);


ALTER TABLE "public"."stock_purchases" OWNER TO "supabase_admin";


CREATE TABLE IF NOT EXISTS "public"."stock_sales" (
    "sale_id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "sale_group_id" "uuid" NOT NULL,
    "product_id" "uuid" NOT NULL,
    "batch_id" "uuid" NOT NULL,
    "transaction_type" "text" NOT NULL,
    "quantity_strips" integer NOT NULL,
    "location_type_source" "text" NOT NULL,
    "location_id_source" "text",
    "location_type_destination" "text" NOT NULL,
    "location_id_destination" "text",
    "sale_date" timestamp with time zone DEFAULT "now"() NOT NULL,
    "reference_document_id" "text",
    "cost_per_strip" numeric(10,2) NOT NULL,
    "notes" "text",
    "created_by" "uuid",
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    CONSTRAINT "positive_sale_cost" CHECK (("cost_per_strip" > (0)::numeric)),
    CONSTRAINT "positive_sale_quantity" CHECK (("quantity_strips" > 0)),
    CONSTRAINT "valid_sale_location_destination" CHECK (("location_type_destination" = ANY (ARRAY['MR'::"text", 'CUSTOMER'::"text"]))),
    CONSTRAINT "valid_sale_location_source" CHECK (("location_type_source" = ANY (ARRAY['GODOWN'::"text", 'MR'::"text"]))),
    CONSTRAINT "valid_sale_transaction_type" CHECK (("transaction_type" = ANY (ARRAY['DISPATCH_TO_MR'::"text", 'SALE_DIRECT_GODOWN'::"text", 'SALE_BY_MR'::"text"])))
);


ALTER TABLE "public"."stock_sales" OWNER TO "supabase_admin";


CREATE TABLE IF NOT EXISTS "public"."stock_transactions" (
    "transaction_id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "transaction_group_id" "uuid" NOT NULL,
    "product_id" "uuid" NOT NULL,
    "batch_id" "uuid" NOT NULL,
    "transaction_type" "text" NOT NULL,
    "quantity_strips" integer NOT NULL,
    "location_type_source" "text",
    "location_id_source" "text",
    "location_type_destination" "text",
    "location_id_destination" "text",
    "transaction_date" timestamp with time zone DEFAULT "now"() NOT NULL,
    "reference_document_type" "text",
    "reference_document_id" "text",
    "cost_per_strip_at_transaction" numeric(10,2) NOT NULL,
    "notes" "text",
    "created_by" "uuid",
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    CONSTRAINT "positive_cost" CHECK (("cost_per_strip_at_transaction" > (0)::numeric)),
    CONSTRAINT "valid_location_destination" CHECK ((("location_type_destination" = ANY (ARRAY['SUPPLIER'::"text", 'GODOWN'::"text", 'MR'::"text", 'CUSTOMER'::"text", 'WASTAGE_BIN'::"text"])) OR ("location_type_destination" IS NULL))),
    CONSTRAINT "valid_location_source" CHECK ((("location_type_source" = ANY (ARRAY['SUPPLIER'::"text", 'GODOWN'::"text", 'MR'::"text", 'CUSTOMER'::"text"])) OR ("location_type_source" IS NULL))),
    CONSTRAINT "valid_transaction_type" CHECK (("transaction_type" = ANY (ARRAY['STOCK_IN_GODOWN'::"text", 'DISPATCH_TO_MR'::"text", 'SALE_DIRECT_GODOWN'::"text", 'SALE_BY_MR'::"text", 'RETURN_TO_GODOWN'::"text", 'RETURN_TO_MR'::"text", 'ADJUST_DAMAGE_GODOWN'::"text", 'ADJUST_LOSS_GODOWN'::"text", 'ADJUST_DAMAGE_MR'::"text", 'ADJUST_LOSS_MR'::"text", 'ADJUST_EXPIRED_GODOWN'::"text", 'ADJUST_EXPIRED_MR'::"text", 'REPLACEMENT_FROM_GODOWN'::"text", 'REPLACEMENT_FROM_MR'::"text", 'OPENING_STOCK_GODOWN'::"text", 'OPENING_STOCK_MR'::"text"])))
);


ALTER TABLE "public"."stock_transactions" OWNER TO "supabase_admin";


CREATE OR REPLACE VIEW "public"."stock_transactions_view" AS
 SELECT "stock_purchases"."purchase_id" AS "transaction_id",
    "stock_purchases"."purchase_group_id" AS "transaction_group_id",
    "stock_purchases"."product_id",
    "stock_purchases"."batch_id",
    'STOCK_IN_GODOWN'::"text" AS "transaction_type",
    "stock_purchases"."quantity_strips",
    'SUPPLIER'::"text" AS "location_type_source",
    "stock_purchases"."supplier_id" AS "location_id_source",
    'GODOWN'::"text" AS "location_type_destination",
    NULL::"text" AS "location_id_destination",
    "stock_purchases"."purchase_date" AS "transaction_date",
    'PURCHASE'::"text" AS "reference_document_type",
    "stock_purchases"."reference_document_id",
    "stock_purchases"."cost_per_strip" AS "cost_per_strip_at_transaction",
    "stock_purchases"."notes",
    "stock_purchases"."created_by",
    "stock_purchases"."created_at"
   FROM "public"."stock_purchases"
UNION ALL
 SELECT "stock_sales"."sale_id" AS "transaction_id",
    "stock_sales"."sale_group_id" AS "transaction_group_id",
    "stock_sales"."product_id",
    "stock_sales"."batch_id",
    "stock_sales"."transaction_type",
        CASE
            WHEN ("stock_sales"."transaction_type" = 'DISPATCH_TO_MR'::"text") THEN "stock_sales"."quantity_strips"
            WHEN ("stock_sales"."transaction_type" = 'SALE_DIRECT_GODOWN'::"text") THEN (- "stock_sales"."quantity_strips")
            WHEN ("stock_sales"."transaction_type" = 'SALE_BY_MR'::"text") THEN (- "stock_sales"."quantity_strips")
            ELSE "stock_sales"."quantity_strips"
        END AS "quantity_strips",
    "stock_sales"."location_type_source",
    "stock_sales"."location_id_source",
    "stock_sales"."location_type_destination",
    "stock_sales"."location_id_destination",
    "stock_sales"."sale_date" AS "transaction_date",
    'SALE'::"text" AS "reference_document_type",
    "stock_sales"."reference_document_id",
    "stock_sales"."cost_per_strip" AS "cost_per_strip_at_transaction",
    "stock_sales"."notes",
    "stock_sales"."created_by",
    "stock_sales"."created_at"
   FROM "public"."stock_sales"
UNION ALL
 SELECT "stock_adjustments"."adjustment_id" AS "transaction_id",
    "stock_adjustments"."adjustment_group_id" AS "transaction_group_id",
    "stock_adjustments"."product_id",
    "stock_adjustments"."batch_id",
    "stock_adjustments"."adjustment_type" AS "transaction_type",
        CASE
            WHEN ("stock_adjustments"."adjustment_type" ~~ 'RETURN_TO_%'::"text") THEN "stock_adjustments"."quantity_strips"
            WHEN ("stock_adjustments"."adjustment_type" ~~ 'ADJUST_%'::"text") THEN (- "stock_adjustments"."quantity_strips")
            WHEN ("stock_adjustments"."adjustment_type" ~~ 'OPENING_STOCK_%'::"text") THEN "stock_adjustments"."quantity_strips"
            WHEN ("stock_adjustments"."adjustment_type" ~~ 'REPLACEMENT_%'::"text") THEN (- "stock_adjustments"."quantity_strips")
            ELSE "stock_adjustments"."quantity_strips"
        END AS "quantity_strips",
    "stock_adjustments"."location_type_source",
    "stock_adjustments"."location_id_source",
    "stock_adjustments"."location_type_destination",
    "stock_adjustments"."location_id_destination",
    "stock_adjustments"."adjustment_date" AS "transaction_date",
    'ADJUSTMENT'::"text" AS "reference_document_type",
    "stock_adjustments"."reference_document_id",
    "stock_adjustments"."cost_per_strip" AS "cost_per_strip_at_transaction",
    "stock_adjustments"."notes",
    "stock_adjustments"."created_by",
    "stock_adjustments"."created_at"
   FROM "public"."stock_adjustments";


ALTER TABLE "public"."stock_transactions_view" OWNER TO "supabase_admin";


CREATE TABLE IF NOT EXISTS "public"."suppliers" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "supplier_name" "text" NOT NULL,
    "supplier_code" "text",
    "contact_person" "text",
    "phone" "text",
    "email" "text",
    "address" "text",
    "is_active" boolean DEFAULT true NOT NULL,
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "updated_at" timestamp with time zone DEFAULT "now"() NOT NULL
);


ALTER TABLE "public"."suppliers" OWNER TO "supabase_admin";


CREATE OR REPLACE VIEW "public"."template_names" AS
 SELECT DISTINCT "packaging_templates"."template_name"
   FROM "public"."packaging_templates";


ALTER TABLE "public"."template_names" OWNER TO "supabase_admin";


ALTER TABLE ONLY "public"."mr_stock_summary"
    ADD CONSTRAINT "mr_stock_summary_pkey" PRIMARY KEY ("mr_user_id", "product_id", "batch_id");



ALTER TABLE ONLY "public"."packaging_templates"
    ADD CONSTRAINT "packaging_templates_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."product_batches"
    ADD CONSTRAINT "product_batches_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."product_categories"
    ADD CONSTRAINT "product_categories_category_name_key" UNIQUE ("category_name");



ALTER TABLE ONLY "public"."product_categories"
    ADD CONSTRAINT "product_categories_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."product_formulations"
    ADD CONSTRAINT "product_formulations_formulation_name_key" UNIQUE ("formulation_name");



ALTER TABLE ONLY "public"."product_formulations"
    ADD CONSTRAINT "product_formulations_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."product_packaging_units"
    ADD CONSTRAINT "product_packaging_units_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."product_sub_categories"
    ADD CONSTRAINT "product_sub_categories_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."product_sub_categories"
    ADD CONSTRAINT "product_sub_categories_sub_category_name_category_id_key" UNIQUE ("sub_category_name", "category_id");



ALTER TABLE ONLY "public"."products"
    ADD CONSTRAINT "products_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."products"
    ADD CONSTRAINT "products_product_code_key" UNIQUE ("product_code");



ALTER TABLE ONLY "public"."products_stock_status"
    ADD CONSTRAINT "products_stock_status_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."products_stock_status"
    ADD CONSTRAINT "products_stock_status_product_id_batch_id_location_type_loc_key" UNIQUE ("product_id", "batch_id", "location_type", "location_id");



ALTER TABLE ONLY "public"."products_stock_status"
    ADD CONSTRAINT "products_stock_status_unique_location" UNIQUE ("product_id", "batch_id", "location_type", "location_id");



ALTER TABLE ONLY "public"."profiles"
    ADD CONSTRAINT "profiles_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."profiles"
    ADD CONSTRAINT "profiles_user_id_key" UNIQUE ("user_id");



ALTER TABLE ONLY "public"."stock_adjustments"
    ADD CONSTRAINT "stock_adjustments_pkey" PRIMARY KEY ("adjustment_id");



ALTER TABLE ONLY "public"."stock_purchases"
    ADD CONSTRAINT "stock_purchases_pkey" PRIMARY KEY ("purchase_id");



ALTER TABLE ONLY "public"."stock_sales"
    ADD CONSTRAINT "stock_sales_pkey" PRIMARY KEY ("sale_id");



ALTER TABLE ONLY "public"."stock_transactions"
    ADD CONSTRAINT "stock_transactions_pkey" PRIMARY KEY ("transaction_id");



ALTER TABLE ONLY "public"."suppliers"
    ADD CONSTRAINT "suppliers_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."suppliers"
    ADD CONSTRAINT "suppliers_supplier_code_key" UNIQUE ("supplier_code");



ALTER TABLE ONLY "public"."product_batches"
    ADD CONSTRAINT "unique_product_batch_number" UNIQUE ("product_id", "batch_number");



ALTER TABLE ONLY "public"."product_packaging_units"
    ADD CONSTRAINT "unique_product_unit_name" UNIQUE ("product_id", "unit_name");



ALTER TABLE ONLY "public"."packaging_templates"
    ADD CONSTRAINT "unique_template_unit_name" UNIQUE ("template_name", "unit_name");



CREATE INDEX "idx_mr_stock_summary_mr_user" ON "public"."mr_stock_summary" USING "btree" ("mr_user_id");



CREATE INDEX "idx_mr_stock_summary_product" ON "public"."mr_stock_summary" USING "btree" ("product_id");



CREATE INDEX "idx_packaging_templates_name" ON "public"."packaging_templates" USING "btree" ("template_name");



CREATE INDEX "idx_product_batches_batch_number" ON "public"."product_batches" USING "btree" ("product_id", "batch_number");



CREATE INDEX "idx_product_batches_expiry_date" ON "public"."product_batches" USING "btree" ("expiry_date");



CREATE INDEX "idx_product_batches_product_id" ON "public"."product_batches" USING "btree" ("product_id");



CREATE INDEX "idx_product_batches_status" ON "public"."product_batches" USING "btree" ("status");



CREATE INDEX "idx_product_packaging_units_order" ON "public"."product_packaging_units" USING "btree" ("product_id", "order_in_hierarchy");



CREATE INDEX "idx_product_packaging_units_product_id" ON "public"."product_packaging_units" USING "btree" ("product_id");



CREATE INDEX "idx_product_packaging_units_template_id" ON "public"."product_packaging_units" USING "btree" ("template_id");



CREATE INDEX "idx_product_sub_categories_category_id" ON "public"."product_sub_categories" USING "btree" ("category_id");



CREATE INDEX "idx_products_category_id" ON "public"."products" USING "btree" ("category_id");



CREATE INDEX "idx_products_formulation_id" ON "public"."products" USING "btree" ("formulation_id");



CREATE INDEX "idx_products_is_active" ON "public"."products" USING "btree" ("is_active");



CREATE INDEX "idx_products_packaging_template" ON "public"."products" USING "btree" ("packaging_template");



CREATE INDEX "idx_products_product_code" ON "public"."products" USING "btree" ("product_code");



CREATE INDEX "idx_products_stock_status_batch_id" ON "public"."products_stock_status" USING "btree" ("batch_id");



CREATE INDEX "idx_products_stock_status_current_quantity" ON "public"."products_stock_status" USING "btree" ("current_quantity_strips") WHERE ("current_quantity_strips" > 0);



CREATE INDEX "idx_products_stock_status_location" ON "public"."products_stock_status" USING "btree" ("location_type", "location_id");



CREATE INDEX "idx_products_stock_status_product_id" ON "public"."products_stock_status" USING "btree" ("product_id");



CREATE INDEX "idx_products_sub_category_id" ON "public"."products" USING "btree" ("sub_category_id");



CREATE INDEX "idx_stock_adjustments_batch_id" ON "public"."stock_adjustments" USING "btree" ("batch_id");



CREATE INDEX "idx_stock_adjustments_created_by" ON "public"."stock_adjustments" USING "btree" ("created_by");



CREATE INDEX "idx_stock_adjustments_date" ON "public"."stock_adjustments" USING "btree" ("adjustment_date");



CREATE INDEX "idx_stock_adjustments_group_id" ON "public"."stock_adjustments" USING "btree" ("adjustment_group_id");



CREATE INDEX "idx_stock_adjustments_product_id" ON "public"."stock_adjustments" USING "btree" ("product_id");



CREATE INDEX "idx_stock_adjustments_type" ON "public"."stock_adjustments" USING "btree" ("adjustment_type");



CREATE INDEX "idx_stock_purchases_batch_id" ON "public"."stock_purchases" USING "btree" ("batch_id");



CREATE INDEX "idx_stock_purchases_created_by" ON "public"."stock_purchases" USING "btree" ("created_by");



CREATE INDEX "idx_stock_purchases_date" ON "public"."stock_purchases" USING "btree" ("purchase_date");



CREATE INDEX "idx_stock_purchases_group_id" ON "public"."stock_purchases" USING "btree" ("purchase_group_id");



CREATE INDEX "idx_stock_purchases_product_id" ON "public"."stock_purchases" USING "btree" ("product_id");



CREATE INDEX "idx_stock_sales_batch_id" ON "public"."stock_sales" USING "btree" ("batch_id");



CREATE INDEX "idx_stock_sales_created_by" ON "public"."stock_sales" USING "btree" ("created_by");



CREATE INDEX "idx_stock_sales_date" ON "public"."stock_sales" USING "btree" ("sale_date");



CREATE INDEX "idx_stock_sales_group_id" ON "public"."stock_sales" USING "btree" ("sale_group_id");



CREATE INDEX "idx_stock_sales_product_id" ON "public"."stock_sales" USING "btree" ("product_id");



CREATE INDEX "idx_stock_sales_type" ON "public"."stock_sales" USING "btree" ("transaction_type");



CREATE INDEX "idx_stock_transactions_batch_id" ON "public"."stock_transactions" USING "btree" ("batch_id");



CREATE INDEX "idx_stock_transactions_created_by" ON "public"."stock_transactions" USING "btree" ("created_by");



CREATE INDEX "idx_stock_transactions_date" ON "public"."stock_transactions" USING "btree" ("transaction_date");



CREATE INDEX "idx_stock_transactions_group_id" ON "public"."stock_transactions" USING "btree" ("transaction_group_id");



CREATE INDEX "idx_stock_transactions_product_id" ON "public"."stock_transactions" USING "btree" ("product_id");



CREATE INDEX "idx_stock_transactions_type" ON "public"."stock_transactions" USING "btree" ("transaction_type");



CREATE OR REPLACE TRIGGER "trigger_update_products_stock_status" AFTER INSERT ON "public"."stock_transactions" FOR EACH ROW EXECUTE FUNCTION "public"."update_products_stock_status"();



CREATE OR REPLACE TRIGGER "update_mr_stock_summary_adjustments_trigger" AFTER INSERT ON "public"."stock_adjustments" FOR EACH ROW EXECUTE FUNCTION "public"."update_mr_stock_summary_from_adjustments"();



CREATE OR REPLACE TRIGGER "update_mr_stock_summary_sales_trigger" AFTER INSERT ON "public"."stock_sales" FOR EACH ROW EXECUTE FUNCTION "public"."update_mr_stock_summary_from_sales"();



CREATE OR REPLACE TRIGGER "update_mr_stock_summary_trigger" AFTER INSERT ON "public"."stock_transactions" FOR EACH ROW EXECUTE FUNCTION "public"."update_mr_stock_summary"();



CREATE OR REPLACE TRIGGER "update_packaging_templates_updated_at" BEFORE UPDATE ON "public"."packaging_templates" FOR EACH ROW EXECUTE FUNCTION "public"."update_updated_at_column"();



CREATE OR REPLACE TRIGGER "update_product_batches_updated_at" BEFORE UPDATE ON "public"."product_batches" FOR EACH ROW EXECUTE FUNCTION "public"."update_updated_at_column"();



CREATE OR REPLACE TRIGGER "update_product_categories_updated_at" BEFORE UPDATE ON "public"."product_categories" FOR EACH ROW EXECUTE FUNCTION "public"."update_updated_at_column"();



CREATE OR REPLACE TRIGGER "update_product_formulations_updated_at" BEFORE UPDATE ON "public"."product_formulations" FOR EACH ROW EXECUTE FUNCTION "public"."update_updated_at_column"();



CREATE OR REPLACE TRIGGER "update_product_packaging_units_updated_at" BEFORE UPDATE ON "public"."product_packaging_units" FOR EACH ROW EXECUTE FUNCTION "public"."update_updated_at_column"();



CREATE OR REPLACE TRIGGER "update_product_sub_categories_updated_at" BEFORE UPDATE ON "public"."product_sub_categories" FOR EACH ROW EXECUTE FUNCTION "public"."update_updated_at_column"();



CREATE OR REPLACE TRIGGER "update_products_stock_status_updated_at" BEFORE UPDATE ON "public"."products_stock_status" FOR EACH ROW EXECUTE FUNCTION "public"."update_updated_at_column"();



CREATE OR REPLACE TRIGGER "update_products_updated_at" BEFORE UPDATE ON "public"."products" FOR EACH ROW EXECUTE FUNCTION "public"."update_updated_at_column"();



CREATE OR REPLACE TRIGGER "update_suppliers_updated_at" BEFORE UPDATE ON "public"."suppliers" FOR EACH ROW EXECUTE FUNCTION "public"."update_updated_at_column"();



CREATE OR REPLACE TRIGGER "validate_batch_dates_trigger" BEFORE INSERT OR UPDATE ON "public"."product_batches" FOR EACH ROW EXECUTE FUNCTION "public"."validate_batch_dates"();



CREATE OR REPLACE TRIGGER "validate_product_template_name" BEFORE INSERT OR UPDATE ON "public"."products" FOR EACH ROW EXECUTE FUNCTION "public"."validate_template_name"();



CREATE OR REPLACE TRIGGER "validate_single_base_unit_trigger" BEFORE INSERT OR UPDATE ON "public"."product_packaging_units" FOR EACH ROW EXECUTE FUNCTION "public"."validate_single_base_unit"();



ALTER TABLE ONLY "public"."mr_stock_summary"
    ADD CONSTRAINT "mr_stock_summary_batch_id_fkey" FOREIGN KEY ("batch_id") REFERENCES "public"."product_batches"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."mr_stock_summary"
    ADD CONSTRAINT "mr_stock_summary_mr_user_id_fkey" FOREIGN KEY ("mr_user_id") REFERENCES "auth"."users"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."mr_stock_summary"
    ADD CONSTRAINT "mr_stock_summary_product_id_fkey" FOREIGN KEY ("product_id") REFERENCES "public"."products"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."product_batches"
    ADD CONSTRAINT "product_batches_product_id_fkey" FOREIGN KEY ("product_id") REFERENCES "public"."products"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."product_packaging_units"
    ADD CONSTRAINT "product_packaging_units_product_id_fkey" FOREIGN KEY ("product_id") REFERENCES "public"."products"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."product_packaging_units"
    ADD CONSTRAINT "product_packaging_units_template_id_fkey" FOREIGN KEY ("template_id") REFERENCES "public"."packaging_templates"("id") ON DELETE SET NULL;



ALTER TABLE ONLY "public"."product_sub_categories"
    ADD CONSTRAINT "product_sub_categories_category_id_fkey" FOREIGN KEY ("category_id") REFERENCES "public"."product_categories"("id");



ALTER TABLE ONLY "public"."products"
    ADD CONSTRAINT "products_category_id_fkey" FOREIGN KEY ("category_id") REFERENCES "public"."product_categories"("id");



ALTER TABLE ONLY "public"."products"
    ADD CONSTRAINT "products_formulation_id_fkey" FOREIGN KEY ("formulation_id") REFERENCES "public"."product_formulations"("id");



ALTER TABLE ONLY "public"."products_stock_status"
    ADD CONSTRAINT "products_stock_status_batch_id_fkey" FOREIGN KEY ("batch_id") REFERENCES "public"."product_batches"("id");



ALTER TABLE ONLY "public"."products_stock_status"
    ADD CONSTRAINT "products_stock_status_product_id_fkey" FOREIGN KEY ("product_id") REFERENCES "public"."products"("id");



ALTER TABLE ONLY "public"."products"
    ADD CONSTRAINT "products_sub_category_id_fkey" FOREIGN KEY ("sub_category_id") REFERENCES "public"."product_sub_categories"("id");



ALTER TABLE ONLY "public"."profiles"
    ADD CONSTRAINT "profiles_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "auth"."users"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."stock_adjustments"
    ADD CONSTRAINT "stock_adjustments_batch_id_fkey" FOREIGN KEY ("batch_id") REFERENCES "public"."product_batches"("id") ON DELETE RESTRICT;



ALTER TABLE ONLY "public"."stock_adjustments"
    ADD CONSTRAINT "stock_adjustments_created_by_fkey" FOREIGN KEY ("created_by") REFERENCES "auth"."users"("id");



ALTER TABLE ONLY "public"."stock_adjustments"
    ADD CONSTRAINT "stock_adjustments_product_id_fkey" FOREIGN KEY ("product_id") REFERENCES "public"."products"("id") ON DELETE RESTRICT;



ALTER TABLE ONLY "public"."stock_purchases"
    ADD CONSTRAINT "stock_purchases_batch_id_fkey" FOREIGN KEY ("batch_id") REFERENCES "public"."product_batches"("id") ON DELETE RESTRICT;



ALTER TABLE ONLY "public"."stock_purchases"
    ADD CONSTRAINT "stock_purchases_created_by_fkey" FOREIGN KEY ("created_by") REFERENCES "auth"."users"("id");



ALTER TABLE ONLY "public"."stock_purchases"
    ADD CONSTRAINT "stock_purchases_product_id_fkey" FOREIGN KEY ("product_id") REFERENCES "public"."products"("id") ON DELETE RESTRICT;



ALTER TABLE ONLY "public"."stock_sales"
    ADD CONSTRAINT "stock_sales_batch_id_fkey" FOREIGN KEY ("batch_id") REFERENCES "public"."product_batches"("id") ON DELETE RESTRICT;



ALTER TABLE ONLY "public"."stock_sales"
    ADD CONSTRAINT "stock_sales_created_by_fkey" FOREIGN KEY ("created_by") REFERENCES "auth"."users"("id");



ALTER TABLE ONLY "public"."stock_sales"
    ADD CONSTRAINT "stock_sales_product_id_fkey" FOREIGN KEY ("product_id") REFERENCES "public"."products"("id") ON DELETE RESTRICT;



ALTER TABLE ONLY "public"."stock_transactions"
    ADD CONSTRAINT "stock_transactions_batch_id_fkey" FOREIGN KEY ("batch_id") REFERENCES "public"."product_batches"("id") ON DELETE RESTRICT;



ALTER TABLE ONLY "public"."stock_transactions"
    ADD CONSTRAINT "stock_transactions_created_by_fkey" FOREIGN KEY ("created_by") REFERENCES "auth"."users"("id");



ALTER TABLE ONLY "public"."stock_transactions"
    ADD CONSTRAINT "stock_transactions_product_id_fkey" FOREIGN KEY ("product_id") REFERENCES "public"."products"("id") ON DELETE RESTRICT;



CREATE POLICY "Admin can manage suppliers" ON "public"."suppliers" USING ((EXISTS ( SELECT 1
   FROM "public"."profiles"
  WHERE (("profiles"."user_id" = "auth"."uid"()) AND ("profiles"."role" = 'admin'::"public"."user_role")))));



CREATE POLICY "Admins can do everything on product_categories" ON "public"."product_categories" USING ((EXISTS ( SELECT 1
   FROM "public"."profiles"
  WHERE (("profiles"."user_id" = "auth"."uid"()) AND ("profiles"."role" = 'admin'::"public"."user_role")))));



CREATE POLICY "Admins can do everything on product_formulations" ON "public"."product_formulations" USING ((EXISTS ( SELECT 1
   FROM "public"."profiles"
  WHERE (("profiles"."user_id" = "auth"."uid"()) AND ("profiles"."role" = 'admin'::"public"."user_role")))));



CREATE POLICY "Admins can do everything on product_sub_categories" ON "public"."product_sub_categories" USING ((EXISTS ( SELECT 1
   FROM "public"."profiles"
  WHERE (("profiles"."user_id" = "auth"."uid"()) AND ("profiles"."role" = 'admin'::"public"."user_role")))));



CREATE POLICY "Admins can do everything on products" ON "public"."products" USING ((EXISTS ( SELECT 1
   FROM "public"."profiles"
  WHERE (("profiles"."user_id" = "auth"."uid"()) AND ("profiles"."role" = 'admin'::"public"."user_role")))));



CREATE POLICY "Users can update their own profile" ON "public"."profiles" FOR UPDATE USING (("auth"."uid"() = "user_id"));



CREATE POLICY "Users can view active suppliers" ON "public"."suppliers" FOR SELECT USING ((("is_active" = true) AND (EXISTS ( SELECT 1
   FROM "public"."profiles"
  WHERE ("profiles"."user_id" = "auth"."uid"())))));



CREATE POLICY "Users can view their own profile" ON "public"."profiles" FOR SELECT USING (("auth"."uid"() = "user_id"));



CREATE POLICY "Workers can view product_categories" ON "public"."product_categories" FOR SELECT USING ((EXISTS ( SELECT 1
   FROM "public"."profiles"
  WHERE (("profiles"."user_id" = "auth"."uid"()) AND ("profiles"."role" = ANY (ARRAY['admin'::"public"."user_role", 'user'::"public"."user_role"]))))));



CREATE POLICY "Workers can view product_formulations" ON "public"."product_formulations" FOR SELECT USING ((EXISTS ( SELECT 1
   FROM "public"."profiles"
  WHERE (("profiles"."user_id" = "auth"."uid"()) AND ("profiles"."role" = ANY (ARRAY['admin'::"public"."user_role", 'user'::"public"."user_role"]))))));



CREATE POLICY "Workers can view product_sub_categories" ON "public"."product_sub_categories" FOR SELECT USING ((EXISTS ( SELECT 1
   FROM "public"."profiles"
  WHERE (("profiles"."user_id" = "auth"."uid"()) AND ("profiles"."role" = ANY (ARRAY['admin'::"public"."user_role", 'user'::"public"."user_role"]))))));



CREATE POLICY "Workers can view products" ON "public"."products" FOR SELECT USING ((EXISTS ( SELECT 1
   FROM "public"."profiles"
  WHERE (("profiles"."user_id" = "auth"."uid"()) AND ("profiles"."role" = ANY (ARRAY['admin'::"public"."user_role", 'user'::"public"."user_role"]))))));



ALTER TABLE "public"."product_categories" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."product_formulations" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."product_sub_categories" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."products" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."profiles" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."suppliers" ENABLE ROW LEVEL SECURITY;




ALTER PUBLICATION "supabase_realtime" OWNER TO "postgres";


ALTER PUBLICATION "supabase_realtime" ADD TABLE ONLY "public"."stock_adjustments";



ALTER PUBLICATION "supabase_realtime" ADD TABLE ONLY "public"."stock_purchases";



ALTER PUBLICATION "supabase_realtime" ADD TABLE ONLY "public"."stock_sales";






GRANT USAGE ON SCHEMA "public" TO "postgres";
GRANT USAGE ON SCHEMA "public" TO "anon";
GRANT USAGE ON SCHEMA "public" TO "authenticated";
GRANT USAGE ON SCHEMA "public" TO "service_role";




















































































































































































GRANT ALL ON FUNCTION "public"."calculate_closing_stock"("p_product_id" "uuid", "p_batch_id" "uuid", "p_location_type" "text", "p_location_id" "text", "p_report_date" "date") TO "postgres";
GRANT ALL ON FUNCTION "public"."calculate_closing_stock"("p_product_id" "uuid", "p_batch_id" "uuid", "p_location_type" "text", "p_location_id" "text", "p_report_date" "date") TO "anon";
GRANT ALL ON FUNCTION "public"."calculate_closing_stock"("p_product_id" "uuid", "p_batch_id" "uuid", "p_location_type" "text", "p_location_id" "text", "p_report_date" "date") TO "authenticated";
GRANT ALL ON FUNCTION "public"."calculate_closing_stock"("p_product_id" "uuid", "p_batch_id" "uuid", "p_location_type" "text", "p_location_id" "text", "p_report_date" "date") TO "service_role";



GRANT ALL ON FUNCTION "public"."handle_new_user"() TO "postgres";
GRANT ALL ON FUNCTION "public"."handle_new_user"() TO "anon";
GRANT ALL ON FUNCTION "public"."handle_new_user"() TO "authenticated";
GRANT ALL ON FUNCTION "public"."handle_new_user"() TO "service_role";



GRANT ALL ON FUNCTION "public"."is_admin"("user_uuid" "uuid") TO "postgres";
GRANT ALL ON FUNCTION "public"."is_admin"("user_uuid" "uuid") TO "anon";
GRANT ALL ON FUNCTION "public"."is_admin"("user_uuid" "uuid") TO "authenticated";
GRANT ALL ON FUNCTION "public"."is_admin"("user_uuid" "uuid") TO "service_role";



GRANT ALL ON FUNCTION "public"."recalculate_closing_stock_reports"() TO "postgres";
GRANT ALL ON FUNCTION "public"."recalculate_closing_stock_reports"() TO "anon";
GRANT ALL ON FUNCTION "public"."recalculate_closing_stock_reports"() TO "authenticated";
GRANT ALL ON FUNCTION "public"."recalculate_closing_stock_reports"() TO "service_role";



GRANT ALL ON FUNCTION "public"."recalculate_products_stock_status"() TO "postgres";
GRANT ALL ON FUNCTION "public"."recalculate_products_stock_status"() TO "anon";
GRANT ALL ON FUNCTION "public"."recalculate_products_stock_status"() TO "authenticated";
GRANT ALL ON FUNCTION "public"."recalculate_products_stock_status"() TO "service_role";



GRANT ALL ON FUNCTION "public"."update_closing_stock_report"() TO "postgres";
GRANT ALL ON FUNCTION "public"."update_closing_stock_report"() TO "anon";
GRANT ALL ON FUNCTION "public"."update_closing_stock_report"() TO "authenticated";
GRANT ALL ON FUNCTION "public"."update_closing_stock_report"() TO "service_role";



GRANT ALL ON FUNCTION "public"."update_mr_stock_summary"() TO "postgres";
GRANT ALL ON FUNCTION "public"."update_mr_stock_summary"() TO "anon";
GRANT ALL ON FUNCTION "public"."update_mr_stock_summary"() TO "authenticated";
GRANT ALL ON FUNCTION "public"."update_mr_stock_summary"() TO "service_role";



GRANT ALL ON FUNCTION "public"."update_mr_stock_summary_from_adjustments"() TO "postgres";
GRANT ALL ON FUNCTION "public"."update_mr_stock_summary_from_adjustments"() TO "anon";
GRANT ALL ON FUNCTION "public"."update_mr_stock_summary_from_adjustments"() TO "authenticated";
GRANT ALL ON FUNCTION "public"."update_mr_stock_summary_from_adjustments"() TO "service_role";



GRANT ALL ON FUNCTION "public"."update_mr_stock_summary_from_sales"() TO "postgres";
GRANT ALL ON FUNCTION "public"."update_mr_stock_summary_from_sales"() TO "anon";
GRANT ALL ON FUNCTION "public"."update_mr_stock_summary_from_sales"() TO "authenticated";
GRANT ALL ON FUNCTION "public"."update_mr_stock_summary_from_sales"() TO "service_role";



GRANT ALL ON FUNCTION "public"."update_products_stock_status"() TO "postgres";
GRANT ALL ON FUNCTION "public"."update_products_stock_status"() TO "anon";
GRANT ALL ON FUNCTION "public"."update_products_stock_status"() TO "authenticated";
GRANT ALL ON FUNCTION "public"."update_products_stock_status"() TO "service_role";



GRANT ALL ON FUNCTION "public"."update_updated_at_column"() TO "postgres";
GRANT ALL ON FUNCTION "public"."update_updated_at_column"() TO "anon";
GRANT ALL ON FUNCTION "public"."update_updated_at_column"() TO "authenticated";
GRANT ALL ON FUNCTION "public"."update_updated_at_column"() TO "service_role";



GRANT ALL ON FUNCTION "public"."validate_batch_dates"() TO "postgres";
GRANT ALL ON FUNCTION "public"."validate_batch_dates"() TO "anon";
GRANT ALL ON FUNCTION "public"."validate_batch_dates"() TO "authenticated";
GRANT ALL ON FUNCTION "public"."validate_batch_dates"() TO "service_role";



GRANT ALL ON FUNCTION "public"."validate_single_base_unit"() TO "postgres";
GRANT ALL ON FUNCTION "public"."validate_single_base_unit"() TO "anon";
GRANT ALL ON FUNCTION "public"."validate_single_base_unit"() TO "authenticated";
GRANT ALL ON FUNCTION "public"."validate_single_base_unit"() TO "service_role";



GRANT ALL ON FUNCTION "public"."validate_template_name"() TO "postgres";
GRANT ALL ON FUNCTION "public"."validate_template_name"() TO "anon";
GRANT ALL ON FUNCTION "public"."validate_template_name"() TO "authenticated";
GRANT ALL ON FUNCTION "public"."validate_template_name"() TO "service_role";


















GRANT ALL ON TABLE "public"."mr_stock_summary" TO "postgres";
GRANT ALL ON TABLE "public"."mr_stock_summary" TO "anon";
GRANT ALL ON TABLE "public"."mr_stock_summary" TO "authenticated";
GRANT ALL ON TABLE "public"."mr_stock_summary" TO "service_role";



GRANT ALL ON TABLE "public"."packaging_templates" TO "postgres";
GRANT ALL ON TABLE "public"."packaging_templates" TO "anon";
GRANT ALL ON TABLE "public"."packaging_templates" TO "authenticated";
GRANT ALL ON TABLE "public"."packaging_templates" TO "service_role";



GRANT ALL ON TABLE "public"."product_batches" TO "postgres";
GRANT ALL ON TABLE "public"."product_batches" TO "anon";
GRANT ALL ON TABLE "public"."product_batches" TO "authenticated";
GRANT ALL ON TABLE "public"."product_batches" TO "service_role";



GRANT ALL ON TABLE "public"."product_categories" TO "postgres";
GRANT ALL ON TABLE "public"."product_categories" TO "anon";
GRANT ALL ON TABLE "public"."product_categories" TO "authenticated";
GRANT ALL ON TABLE "public"."product_categories" TO "service_role";



GRANT ALL ON TABLE "public"."product_formulations" TO "postgres";
GRANT ALL ON TABLE "public"."product_formulations" TO "anon";
GRANT ALL ON TABLE "public"."product_formulations" TO "authenticated";
GRANT ALL ON TABLE "public"."product_formulations" TO "service_role";



GRANT ALL ON TABLE "public"."product_packaging_units" TO "postgres";
GRANT ALL ON TABLE "public"."product_packaging_units" TO "anon";
GRANT ALL ON TABLE "public"."product_packaging_units" TO "authenticated";
GRANT ALL ON TABLE "public"."product_packaging_units" TO "service_role";



GRANT ALL ON TABLE "public"."product_sub_categories" TO "postgres";
GRANT ALL ON TABLE "public"."product_sub_categories" TO "anon";
GRANT ALL ON TABLE "public"."product_sub_categories" TO "authenticated";
GRANT ALL ON TABLE "public"."product_sub_categories" TO "service_role";



GRANT ALL ON TABLE "public"."products" TO "postgres";
GRANT ALL ON TABLE "public"."products" TO "anon";
GRANT ALL ON TABLE "public"."products" TO "authenticated";
GRANT ALL ON TABLE "public"."products" TO "service_role";



GRANT ALL ON TABLE "public"."products_stock_status" TO "postgres";
GRANT ALL ON TABLE "public"."products_stock_status" TO "anon";
GRANT ALL ON TABLE "public"."products_stock_status" TO "authenticated";
GRANT ALL ON TABLE "public"."products_stock_status" TO "service_role";



GRANT ALL ON TABLE "public"."profiles" TO "postgres";
GRANT ALL ON TABLE "public"."profiles" TO "anon";
GRANT ALL ON TABLE "public"."profiles" TO "authenticated";
GRANT ALL ON TABLE "public"."profiles" TO "service_role";



GRANT ALL ON TABLE "public"."stock_adjustments" TO "postgres";
GRANT ALL ON TABLE "public"."stock_adjustments" TO "anon";
GRANT ALL ON TABLE "public"."stock_adjustments" TO "authenticated";
GRANT ALL ON TABLE "public"."stock_adjustments" TO "service_role";



GRANT ALL ON TABLE "public"."stock_purchases" TO "postgres";
GRANT ALL ON TABLE "public"."stock_purchases" TO "anon";
GRANT ALL ON TABLE "public"."stock_purchases" TO "authenticated";
GRANT ALL ON TABLE "public"."stock_purchases" TO "service_role";



GRANT ALL ON TABLE "public"."stock_sales" TO "postgres";
GRANT ALL ON TABLE "public"."stock_sales" TO "anon";
GRANT ALL ON TABLE "public"."stock_sales" TO "authenticated";
GRANT ALL ON TABLE "public"."stock_sales" TO "service_role";



GRANT ALL ON TABLE "public"."stock_transactions" TO "postgres";
GRANT ALL ON TABLE "public"."stock_transactions" TO "anon";
GRANT ALL ON TABLE "public"."stock_transactions" TO "authenticated";
GRANT ALL ON TABLE "public"."stock_transactions" TO "service_role";



GRANT ALL ON TABLE "public"."stock_transactions_view" TO "postgres";
GRANT ALL ON TABLE "public"."stock_transactions_view" TO "anon";
GRANT ALL ON TABLE "public"."stock_transactions_view" TO "authenticated";
GRANT ALL ON TABLE "public"."stock_transactions_view" TO "service_role";



GRANT ALL ON TABLE "public"."suppliers" TO "postgres";
GRANT ALL ON TABLE "public"."suppliers" TO "anon";
GRANT ALL ON TABLE "public"."suppliers" TO "authenticated";
GRANT ALL ON TABLE "public"."suppliers" TO "service_role";



GRANT ALL ON TABLE "public"."template_names" TO "postgres";
GRANT ALL ON TABLE "public"."template_names" TO "anon";
GRANT ALL ON TABLE "public"."template_names" TO "authenticated";
GRANT ALL ON TABLE "public"."template_names" TO "service_role";



ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON SEQUENCES  TO "postgres";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON SEQUENCES  TO "anon";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON SEQUENCES  TO "authenticated";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON SEQUENCES  TO "service_role";






ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON FUNCTIONS  TO "postgres";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON FUNCTIONS  TO "anon";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON FUNCTIONS  TO "authenticated";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON FUNCTIONS  TO "service_role";






ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON TABLES  TO "postgres";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON TABLES  TO "anon";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON TABLES  TO "authenticated";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON TABLES  TO "service_role";






























RESET ALL;
