-- Create function to handle MR sales order creation
CREATE OR REPLACE FUNCTION public.create_mr_sale(
    p_customer_name TEXT,
    p_items JSONB,
    p_total_amount DECIMAL(10,2),
    p_notes TEXT DEFAULT ''
)
RETURNS UUID
LANGUAGE plpgsql
SECURITY DEFINER
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

-- Grant execute permission to authenticated users
GRANT EXECUTE ON FUNCTION public.create_mr_sale(TEXT, JSONB, DECIMAL, TEXT) TO authenticated;

-- Add RLS policy for the function
CREATE POLICY "MR users can create sales orders" ON public.mr_sales_orders
    FOR INSERT TO authenticated
    WITH CHECK (mr_user_id = auth.uid());

CREATE POLICY "MR users can create sales order items" ON public.mr_sales_order_items
    FOR INSERT TO authenticated
    WITH CHECK (
        EXISTS (
            SELECT 1 FROM public.mr_sales_orders 
            WHERE id = order_id AND mr_user_id = auth.uid()
        )
    );