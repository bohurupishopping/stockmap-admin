-- Migration: Add price_per_strip to mr_stock_summary table and update trigger functions
-- This migration adds price tracking to MR stock summary and updates the trigger functions
-- to populate the price from stock_transactions_view

-- Step 1: Add price_per_strip column to mr_stock_summary table
ALTER TABLE public.mr_stock_summary 
ADD COLUMN price_per_strip NUMERIC(10,2) DEFAULT 0.00;

-- Step 2: Update existing records with price from latest transactions
UPDATE public.mr_stock_summary 
SET price_per_strip = (
    SELECT COALESCE(stv.cost_per_strip_at_transaction, 0.00)
    FROM public.stock_transactions_view stv
    WHERE stv.product_id = mr_stock_summary.product_id 
    AND stv.batch_id = mr_stock_summary.batch_id
    AND (
        (stv.location_type_destination = 'MR' AND stv.location_id_destination = mr_stock_summary.mr_user_id::text)
        OR 
        (stv.location_type_source = 'MR' AND stv.location_id_source = mr_stock_summary.mr_user_id::text)
    )
    ORDER BY stv.transaction_date DESC, stv.created_at DESC
    LIMIT 1
)
WHERE price_per_strip = 0.00 OR price_per_strip IS NULL;

-- Step 3: Update the main update_mr_stock_summary function
CREATE OR REPLACE FUNCTION public.update_mr_stock_summary() RETURNS trigger
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

-- Step 4: Update the update_mr_stock_summary_from_adjustments function
CREATE OR REPLACE FUNCTION public.update_mr_stock_summary_from_adjustments() RETURNS trigger
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

-- Step 5: Update the update_mr_stock_summary_from_sales function
CREATE OR REPLACE FUNCTION public.update_mr_stock_summary_from_sales() RETURNS trigger
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

-- Step 6: Create a function to recalculate all MR stock summary with correct prices
CREATE OR REPLACE FUNCTION public.recalculate_mr_stock_summary_with_prices() RETURNS void
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

-- Step 7: Run the recalculation to populate existing data with correct prices
SELECT public.recalculate_mr_stock_summary_with_prices();

-- Add comment for documentation
COMMENT ON COLUMN public.mr_stock_summary.price_per_strip IS 'Price per strip from the latest transaction for this product/batch combination';