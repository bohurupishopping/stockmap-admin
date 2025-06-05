-- RLS Policies for stock_adjustments table
-- Basic rule: user must be authenticated before accessing the table
-- 1. Any authenticated user can view
-- 2. Only "admin" can alter, create, delete

-- Enable RLS on stock_adjustments table
ALTER TABLE public.stock_adjustments ENABLE ROW LEVEL SECURITY;

-- Drop existing policies if they exist
DROP POLICY IF EXISTS "stock_adjustments_select_policy" ON public.stock_adjustments;
DROP POLICY IF EXISTS "stock_adjustments_insert_policy" ON public.stock_adjustments;
DROP POLICY IF EXISTS "stock_adjustments_update_policy" ON public.stock_adjustments;
DROP POLICY IF EXISTS "stock_adjustments_delete_policy" ON public.stock_adjustments;

-- Policy 1: Any authenticated user can SELECT (view) records
CREATE POLICY "stock_adjustments_select_policy" ON public.stock_adjustments
    FOR SELECT
    TO authenticated
    USING (true);

-- Policy 2: Only admin users can INSERT (create) new records
CREATE POLICY "stock_adjustments_insert_policy" ON public.stock_adjustments
    FOR INSERT
    TO authenticated
    WITH CHECK (
        EXISTS (
            SELECT 1 FROM public.profiles
            WHERE user_id = auth.uid()
            AND role = 'admin'
        )
    );

-- Policy 3: Only admin users can UPDATE (alter) existing records
CREATE POLICY "stock_adjustments_update_policy" ON public.stock_adjustments
    FOR UPDATE
    TO authenticated
    USING (
        EXISTS (
            SELECT 1 FROM public.profiles
            WHERE user_id = auth.uid()
            AND role = 'admin'
        )
    )
    WITH CHECK (
        EXISTS (
            SELECT 1 FROM public.profiles
            WHERE user_id = auth.uid()
            AND role = 'admin'
        )
    );

-- Policy 4: Only admin users can DELETE records
CREATE POLICY "stock_adjustments_delete_policy" ON public.stock_adjustments
    FOR DELETE
    TO authenticated
    USING (
        EXISTS (
            SELECT 1 FROM public.profiles
            WHERE user_id = auth.uid()
            AND role = 'admin'
        )
    );

-- Grant necessary permissions to authenticated role
GRANT SELECT ON public.stock_adjustments TO authenticated;
GRANT INSERT, UPDATE, DELETE ON public.stock_adjustments TO authenticated;

-- Note: The actual permission enforcement is handled by the RLS policies above
-- The GRANT statements ensure the authenticated role has the necessary base permissions
-- but the RLS policies will restrict access based on user role