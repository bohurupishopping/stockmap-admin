-- Migration: Create atomic product creation function
-- This function generates the next product code and creates the product in a single transaction
-- to prevent duplicate product codes in concurrent scenarios

-- Create function to atomically create product with auto-generated code
CREATE OR REPLACE FUNCTION public.create_product_with_auto_code(
  p_product_name TEXT,
  p_generic_name TEXT,
  p_manufacturer TEXT,
  p_category_id UUID,
  p_formulation_id UUID,
  p_sub_category_id UUID DEFAULT NULL,
  p_unit_of_measure_smallest TEXT DEFAULT 'Strip',
  p_base_cost_per_strip DECIMAL(10,2) DEFAULT 0,
  p_is_active BOOLEAN DEFAULT true,
  p_storage_conditions TEXT DEFAULT NULL,
  p_image_url TEXT DEFAULT NULL,
  p_min_stock_level_godown INTEGER DEFAULT 0,
  p_min_stock_level_mr INTEGER DEFAULT 0,
  p_lead_time_days INTEGER DEFAULT 0
)
RETURNS TABLE(
  id UUID,
  product_code TEXT,
  product_name TEXT,
  generic_name TEXT,
  manufacturer TEXT,
  category_id UUID,
  sub_category_id UUID,
  formulation_id UUID,
  unit_of_measure_smallest TEXT,
  base_cost_per_strip DECIMAL(10,2),
  is_active BOOLEAN,
  storage_conditions TEXT,
  image_url TEXT,
  min_stock_level_godown INTEGER,
  min_stock_level_mr INTEGER,
  lead_time_days INTEGER,
  created_at TIMESTAMP WITH TIME ZONE,
  updated_at TIMESTAMP WITH TIME ZONE
)
LANGUAGE plpgsql
SECURITY DEFINER
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

-- Grant execute permission to authenticated users
GRANT EXECUTE ON FUNCTION public.create_product_with_auto_code(
  TEXT, TEXT, TEXT, UUID, UUID, UUID, TEXT, DECIMAL(10,2), BOOLEAN, TEXT, TEXT, INTEGER, INTEGER, INTEGER
) TO authenticated;

-- Create RLS policy for the function
-- The function uses SECURITY DEFINER, so it runs with the privileges of the function owner
-- We still need to ensure proper access control through existing table policies