-- Fix RLS policies for MR Sales tables
-- This migration adds missing SELECT policies for mr_sales_orders and mr_sales_order_items

-- =============================================================================
-- MR_SALES_ORDERS TABLE
-- =============================================================================

-- Enable RLS on mr_sales_orders table
ALTER TABLE public.mr_sales_orders ENABLE ROW LEVEL SECURITY;

-- Drop existing policies if they exist
DROP POLICY IF EXISTS "mr_sales_orders_select_policy" ON public.mr_sales_orders;
DROP POLICY IF EXISTS "mr_sales_orders_update_policy" ON public.mr_sales_orders;
DROP POLICY IF EXISTS "mr_sales_orders_delete_policy" ON public.mr_sales_orders;

-- Allow authenticated users to view all MR sales orders
CREATE POLICY "mr_sales_orders_select_policy" ON public.mr_sales_orders
    FOR SELECT
    TO authenticated
    USING (true);

-- Allow MR users to update their own orders, admins can update all
CREATE POLICY "mr_sales_orders_update_policy" ON public.mr_sales_orders
    FOR UPDATE
    TO authenticated
    USING (
        mr_user_id = auth.uid() OR
        EXISTS (
            SELECT 1 FROM public.profiles
            WHERE user_id = auth.uid()
            AND role = 'admin'
        )
    )
    WITH CHECK (
        mr_user_id = auth.uid() OR
        EXISTS (
            SELECT 1 FROM public.profiles
            WHERE user_id = auth.uid()
            AND role = 'admin'
        )
    );

-- Allow only admins to delete MR sales orders
CREATE POLICY "mr_sales_orders_delete_policy" ON public.mr_sales_orders
    FOR DELETE
    TO authenticated
    USING (
        EXISTS (
            SELECT 1 FROM public.profiles
            WHERE user_id = auth.uid()
            AND role = 'admin'
        )
    );

-- =============================================================================
-- MR_SALES_ORDER_ITEMS TABLE
-- =============================================================================

-- Enable RLS on mr_sales_order_items table
ALTER TABLE public.mr_sales_order_items ENABLE ROW LEVEL SECURITY;

-- Drop existing policies if they exist
DROP POLICY IF EXISTS "mr_sales_order_items_select_policy" ON public.mr_sales_order_items;
DROP POLICY IF EXISTS "mr_sales_order_items_update_policy" ON public.mr_sales_order_items;
DROP POLICY IF EXISTS "mr_sales_order_items_delete_policy" ON public.mr_sales_order_items;

-- Allow authenticated users to view all MR sales order items
CREATE POLICY "mr_sales_order_items_select_policy" ON public.mr_sales_order_items
    FOR SELECT
    TO authenticated
    USING (true);

-- Allow MR users to update items for their own orders, admins can update all
CREATE POLICY "mr_sales_order_items_update_policy" ON public.mr_sales_order_items
    FOR UPDATE
    TO authenticated
    USING (
        EXISTS (
            SELECT 1 FROM public.mr_sales_orders
            WHERE mr_sales_orders.id = mr_sales_order_items.order_id
            AND (mr_sales_orders.mr_user_id = auth.uid() OR
                 EXISTS (
                     SELECT 1 FROM public.profiles
                     WHERE user_id = auth.uid()
                     AND role = 'admin'
                 ))
        )
    )
    WITH CHECK (
        EXISTS (
            SELECT 1 FROM public.mr_sales_orders
            WHERE mr_sales_orders.id = mr_sales_order_items.order_id
            AND (mr_sales_orders.mr_user_id = auth.uid() OR
                 EXISTS (
                     SELECT 1 FROM public.profiles
                     WHERE user_id = auth.uid()
                     AND role = 'admin'
                 ))
        )
    );

-- Allow only admins to delete MR sales order items
CREATE POLICY "mr_sales_order_items_delete_policy" ON public.mr_sales_order_items
    FOR DELETE
    TO authenticated
    USING (
        EXISTS (
            SELECT 1 FROM public.profiles
            WHERE user_id = auth.uid()
            AND role = 'admin'
        )
    );

-- =============================================================================
-- GRANT PERMISSIONS
-- =============================================================================

-- Grant necessary permissions to authenticated role
GRANT SELECT ON public.mr_sales_orders TO authenticated;
GRANT INSERT, UPDATE, DELETE ON public.mr_sales_orders TO authenticated;

GRANT SELECT ON public.mr_sales_order_items TO authenticated;
GRANT INSERT, UPDATE, DELETE ON public.mr_sales_order_items TO authenticated;

-- Note: The actual permission enforcement is handled by the RLS policies above
-- The GRANT statements ensure the authenticated role has the necessary base permissions
-- but the RLS policies will restrict access based on user role and ownership