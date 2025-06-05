-- RLS Policies for all tables
-- Basic rule: user must be authenticated before accessing the table
-- 1. Any authenticated user can view
-- 2. Only "admin" can alter, create, delete

-- =============================================================================
-- MR_STOCK_SUMMARY TABLE
-- =============================================================================

-- Enable RLS on mr_stock_summary table
ALTER TABLE public.mr_stock_summary ENABLE ROW LEVEL SECURITY;

-- Drop existing policies if they exist
DROP POLICY IF EXISTS "mr_stock_summary_select_policy" ON public.mr_stock_summary;
DROP POLICY IF EXISTS "mr_stock_summary_insert_policy" ON public.mr_stock_summary;
DROP POLICY IF EXISTS "mr_stock_summary_update_policy" ON public.mr_stock_summary;
DROP POLICY IF EXISTS "mr_stock_summary_delete_policy" ON public.mr_stock_summary;

-- Policies for mr_stock_summary
CREATE POLICY "mr_stock_summary_select_policy" ON public.mr_stock_summary
    FOR SELECT
    TO authenticated
    USING (true);

CREATE POLICY "mr_stock_summary_insert_policy" ON public.mr_stock_summary
    FOR INSERT
    TO authenticated
    WITH CHECK (
        EXISTS (
            SELECT 1 FROM public.profiles
            WHERE user_id = auth.uid()
            AND role = 'admin'
        )
    );

CREATE POLICY "mr_stock_summary_update_policy" ON public.mr_stock_summary
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

CREATE POLICY "mr_stock_summary_delete_policy" ON public.mr_stock_summary
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
-- PACKAGING_TEMPLATES TABLE
-- =============================================================================

-- Enable RLS on packaging_templates table
ALTER TABLE public.packaging_templates ENABLE ROW LEVEL SECURITY;

-- Drop existing policies if they exist
DROP POLICY IF EXISTS "packaging_templates_select_policy" ON public.packaging_templates;
DROP POLICY IF EXISTS "packaging_templates_insert_policy" ON public.packaging_templates;
DROP POLICY IF EXISTS "packaging_templates_update_policy" ON public.packaging_templates;
DROP POLICY IF EXISTS "packaging_templates_delete_policy" ON public.packaging_templates;

-- Policies for packaging_templates
CREATE POLICY "packaging_templates_select_policy" ON public.packaging_templates
    FOR SELECT
    TO authenticated
    USING (true);

CREATE POLICY "packaging_templates_insert_policy" ON public.packaging_templates
    FOR INSERT
    TO authenticated
    WITH CHECK (
        EXISTS (
            SELECT 1 FROM public.profiles
            WHERE user_id = auth.uid()
            AND role = 'admin'
        )
    );

CREATE POLICY "packaging_templates_update_policy" ON public.packaging_templates
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

CREATE POLICY "packaging_templates_delete_policy" ON public.packaging_templates
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
-- PRODUCT_BATCHES TABLE
-- =============================================================================

-- Enable RLS on product_batches table
ALTER TABLE public.product_batches ENABLE ROW LEVEL SECURITY;

-- Drop existing policies if they exist
DROP POLICY IF EXISTS "product_batches_select_policy" ON public.product_batches;
DROP POLICY IF EXISTS "product_batches_insert_policy" ON public.product_batches;
DROP POLICY IF EXISTS "product_batches_update_policy" ON public.product_batches;
DROP POLICY IF EXISTS "product_batches_delete_policy" ON public.product_batches;

-- Policies for product_batches
CREATE POLICY "product_batches_select_policy" ON public.product_batches
    FOR SELECT
    TO authenticated
    USING (true);

CREATE POLICY "product_batches_insert_policy" ON public.product_batches
    FOR INSERT
    TO authenticated
    WITH CHECK (
        EXISTS (
            SELECT 1 FROM public.profiles
            WHERE user_id = auth.uid()
            AND role = 'admin'
        )
    );

CREATE POLICY "product_batches_update_policy" ON public.product_batches
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

CREATE POLICY "product_batches_delete_policy" ON public.product_batches
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
-- PRODUCT_CATEGORIES TABLE
-- =============================================================================

-- Enable RLS on product_categories table
ALTER TABLE public.product_categories ENABLE ROW LEVEL SECURITY;

-- Drop existing policies if they exist
DROP POLICY IF EXISTS "product_categories_select_policy" ON public.product_categories;
DROP POLICY IF EXISTS "product_categories_insert_policy" ON public.product_categories;
DROP POLICY IF EXISTS "product_categories_update_policy" ON public.product_categories;
DROP POLICY IF EXISTS "product_categories_delete_policy" ON public.product_categories;

-- Policies for product_categories
CREATE POLICY "product_categories_select_policy" ON public.product_categories
    FOR SELECT
    TO authenticated
    USING (true);

CREATE POLICY "product_categories_insert_policy" ON public.product_categories
    FOR INSERT
    TO authenticated
    WITH CHECK (
        EXISTS (
            SELECT 1 FROM public.profiles
            WHERE user_id = auth.uid()
            AND role = 'admin'
        )
    );

CREATE POLICY "product_categories_update_policy" ON public.product_categories
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

CREATE POLICY "product_categories_delete_policy" ON public.product_categories
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
-- PRODUCT_FORMULATIONS TABLE
-- =============================================================================

-- Enable RLS on product_formulations table
ALTER TABLE public.product_formulations ENABLE ROW LEVEL SECURITY;

-- Drop existing policies if they exist
DROP POLICY IF EXISTS "product_formulations_select_policy" ON public.product_formulations;
DROP POLICY IF EXISTS "product_formulations_insert_policy" ON public.product_formulations;
DROP POLICY IF EXISTS "product_formulations_update_policy" ON public.product_formulations;
DROP POLICY IF EXISTS "product_formulations_delete_policy" ON public.product_formulations;

-- Policies for product_formulations
CREATE POLICY "product_formulations_select_policy" ON public.product_formulations
    FOR SELECT
    TO authenticated
    USING (true);

CREATE POLICY "product_formulations_insert_policy" ON public.product_formulations
    FOR INSERT
    TO authenticated
    WITH CHECK (
        EXISTS (
            SELECT 1 FROM public.profiles
            WHERE user_id = auth.uid()
            AND role = 'admin'
        )
    );

CREATE POLICY "product_formulations_update_policy" ON public.product_formulations
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

CREATE POLICY "product_formulations_delete_policy" ON public.product_formulations
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
-- PRODUCT_PACKAGING_UNITS TABLE
-- =============================================================================

-- Enable RLS on product_packaging_units table
ALTER TABLE public.product_packaging_units ENABLE ROW LEVEL SECURITY;

-- Drop existing policies if they exist
DROP POLICY IF EXISTS "product_packaging_units_select_policy" ON public.product_packaging_units;
DROP POLICY IF EXISTS "product_packaging_units_insert_policy" ON public.product_packaging_units;
DROP POLICY IF EXISTS "product_packaging_units_update_policy" ON public.product_packaging_units;
DROP POLICY IF EXISTS "product_packaging_units_delete_policy" ON public.product_packaging_units;

-- Policies for product_packaging_units
CREATE POLICY "product_packaging_units_select_policy" ON public.product_packaging_units
    FOR SELECT
    TO authenticated
    USING (true);

CREATE POLICY "product_packaging_units_insert_policy" ON public.product_packaging_units
    FOR INSERT
    TO authenticated
    WITH CHECK (
        EXISTS (
            SELECT 1 FROM public.profiles
            WHERE user_id = auth.uid()
            AND role = 'admin'
        )
    );

CREATE POLICY "product_packaging_units_update_policy" ON public.product_packaging_units
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

CREATE POLICY "product_packaging_units_delete_policy" ON public.product_packaging_units
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
-- PRODUCT_SUB_CATEGORIES TABLE
-- =============================================================================

-- Enable RLS on product_sub_categories table
ALTER TABLE public.product_sub_categories ENABLE ROW LEVEL SECURITY;

-- Drop existing policies if they exist
DROP POLICY IF EXISTS "product_sub_categories_select_policy" ON public.product_sub_categories;
DROP POLICY IF EXISTS "product_sub_categories_insert_policy" ON public.product_sub_categories;
DROP POLICY IF EXISTS "product_sub_categories_update_policy" ON public.product_sub_categories;
DROP POLICY IF EXISTS "product_sub_categories_delete_policy" ON public.product_sub_categories;

-- Policies for product_sub_categories
CREATE POLICY "product_sub_categories_select_policy" ON public.product_sub_categories
    FOR SELECT
    TO authenticated
    USING (true);

CREATE POLICY "product_sub_categories_insert_policy" ON public.product_sub_categories
    FOR INSERT
    TO authenticated
    WITH CHECK (
        EXISTS (
            SELECT 1 FROM public.profiles
            WHERE user_id = auth.uid()
            AND role = 'admin'
        )
    );

CREATE POLICY "product_sub_categories_update_policy" ON public.product_sub_categories
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

CREATE POLICY "product_sub_categories_delete_policy" ON public.product_sub_categories
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
-- PRODUCTS TABLE
-- =============================================================================

-- Enable RLS on products table
ALTER TABLE public.products ENABLE ROW LEVEL SECURITY;

-- Drop existing policies if they exist
DROP POLICY IF EXISTS "products_select_policy" ON public.products;
DROP POLICY IF EXISTS "products_insert_policy" ON public.products;
DROP POLICY IF EXISTS "products_update_policy" ON public.products;
DROP POLICY IF EXISTS "products_delete_policy" ON public.products;

-- Policies for products
CREATE POLICY "products_select_policy" ON public.products
    FOR SELECT
    TO authenticated
    USING (true);

CREATE POLICY "products_insert_policy" ON public.products
    FOR INSERT
    TO authenticated
    WITH CHECK (
        EXISTS (
            SELECT 1 FROM public.profiles
            WHERE user_id = auth.uid()
            AND role = 'admin'
        )
    );

CREATE POLICY "products_update_policy" ON public.products
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

CREATE POLICY "products_delete_policy" ON public.products
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
-- PRODUCTS_STOCK_STATUS TABLE
-- =============================================================================

-- Enable RLS on products_stock_status table
ALTER TABLE public.products_stock_status ENABLE ROW LEVEL SECURITY;

-- Drop existing policies if they exist
DROP POLICY IF EXISTS "products_stock_status_select_policy" ON public.products_stock_status;
DROP POLICY IF EXISTS "products_stock_status_insert_policy" ON public.products_stock_status;
DROP POLICY IF EXISTS "products_stock_status_update_policy" ON public.products_stock_status;
DROP POLICY IF EXISTS "products_stock_status_delete_policy" ON public.products_stock_status;

-- Policies for products_stock_status
CREATE POLICY "products_stock_status_select_policy" ON public.products_stock_status
    FOR SELECT
    TO authenticated
    USING (true);

CREATE POLICY "products_stock_status_insert_policy" ON public.products_stock_status
    FOR INSERT
    TO authenticated
    WITH CHECK (
        EXISTS (
            SELECT 1 FROM public.profiles
            WHERE user_id = auth.uid()
            AND role = 'admin'
        )
    );

CREATE POLICY "products_stock_status_update_policy" ON public.products_stock_status
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

CREATE POLICY "products_stock_status_delete_policy" ON public.products_stock_status
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
-- STOCK_PURCHASES TABLE
-- =============================================================================

-- Enable RLS on stock_purchases table
ALTER TABLE public.stock_purchases ENABLE ROW LEVEL SECURITY;

-- Drop existing policies if they exist
DROP POLICY IF EXISTS "stock_purchases_select_policy" ON public.stock_purchases;
DROP POLICY IF EXISTS "stock_purchases_insert_policy" ON public.stock_purchases;
DROP POLICY IF EXISTS "stock_purchases_update_policy" ON public.stock_purchases;
DROP POLICY IF EXISTS "stock_purchases_delete_policy" ON public.stock_purchases;

-- Policies for stock_purchases
CREATE POLICY "stock_purchases_select_policy" ON public.stock_purchases
    FOR SELECT
    TO authenticated
    USING (true);

CREATE POLICY "stock_purchases_insert_policy" ON public.stock_purchases
    FOR INSERT
    TO authenticated
    WITH CHECK (
        EXISTS (
            SELECT 1 FROM public.profiles
            WHERE user_id = auth.uid()
            AND role = 'admin'
        )
    );

CREATE POLICY "stock_purchases_update_policy" ON public.stock_purchases
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

CREATE POLICY "stock_purchases_delete_policy" ON public.stock_purchases
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
-- STOCK_SALES TABLE
-- =============================================================================

-- Enable RLS on stock_sales table
ALTER TABLE public.stock_sales ENABLE ROW LEVEL SECURITY;

-- Drop existing policies if they exist
DROP POLICY IF EXISTS "stock_sales_select_policy" ON public.stock_sales;
DROP POLICY IF EXISTS "stock_sales_insert_policy" ON public.stock_sales;
DROP POLICY IF EXISTS "stock_sales_update_policy" ON public.stock_sales;
DROP POLICY IF EXISTS "stock_sales_delete_policy" ON public.stock_sales;

-- Policies for stock_sales
CREATE POLICY "stock_sales_select_policy" ON public.stock_sales
    FOR SELECT
    TO authenticated
    USING (true);

CREATE POLICY "stock_sales_insert_policy" ON public.stock_sales
    FOR INSERT
    TO authenticated
    WITH CHECK (
        EXISTS (
            SELECT 1 FROM public.profiles
            WHERE user_id = auth.uid()
            AND role = 'admin'
        )
    );

CREATE POLICY "stock_sales_update_policy" ON public.stock_sales
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

CREATE POLICY "stock_sales_delete_policy" ON public.stock_sales
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
-- STOCK_TRANSACTIONS TABLE
-- =============================================================================

-- Enable RLS on stock_transactions table
ALTER TABLE public.stock_transactions ENABLE ROW LEVEL SECURITY;

-- Drop existing policies if they exist
DROP POLICY IF EXISTS "stock_transactions_select_policy" ON public.stock_transactions;
DROP POLICY IF EXISTS "stock_transactions_insert_policy" ON public.stock_transactions;
DROP POLICY IF EXISTS "stock_transactions_update_policy" ON public.stock_transactions;
DROP POLICY IF EXISTS "stock_transactions_delete_policy" ON public.stock_transactions;

-- Policies for stock_transactions
CREATE POLICY "stock_transactions_select_policy" ON public.stock_transactions
    FOR SELECT
    TO authenticated
    USING (true);

CREATE POLICY "stock_transactions_insert_policy" ON public.stock_transactions
    FOR INSERT
    TO authenticated
    WITH CHECK (
        EXISTS (
            SELECT 1 FROM public.profiles
            WHERE user_id = auth.uid()
            AND role = 'admin'
        )
    );

CREATE POLICY "stock_transactions_update_policy" ON public.stock_transactions
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

CREATE POLICY "stock_transactions_delete_policy" ON public.stock_transactions
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

-- Grant necessary permissions to authenticated role for all tables
GRANT SELECT ON public.mr_stock_summary TO authenticated;
GRANT INSERT, UPDATE, DELETE ON public.mr_stock_summary TO authenticated;

GRANT SELECT ON public.packaging_templates TO authenticated;
GRANT INSERT, UPDATE, DELETE ON public.packaging_templates TO authenticated;

GRANT SELECT ON public.product_batches TO authenticated;
GRANT INSERT, UPDATE, DELETE ON public.product_batches TO authenticated;

GRANT SELECT ON public.product_categories TO authenticated;
GRANT INSERT, UPDATE, DELETE ON public.product_categories TO authenticated;

GRANT SELECT ON public.product_formulations TO authenticated;
GRANT INSERT, UPDATE, DELETE ON public.product_formulations TO authenticated;

GRANT SELECT ON public.product_packaging_units TO authenticated;
GRANT INSERT, UPDATE, DELETE ON public.product_packaging_units TO authenticated;

GRANT SELECT ON public.product_sub_categories TO authenticated;
GRANT INSERT, UPDATE, DELETE ON public.product_sub_categories TO authenticated;

GRANT SELECT ON public.products TO authenticated;
GRANT INSERT, UPDATE, DELETE ON public.products TO authenticated;

GRANT SELECT ON public.products_stock_status TO authenticated;
GRANT INSERT, UPDATE, DELETE ON public.products_stock_status TO authenticated;

GRANT SELECT ON public.stock_purchases TO authenticated;
GRANT INSERT, UPDATE, DELETE ON public.stock_purchases TO authenticated;

GRANT SELECT ON public.stock_sales TO authenticated;
GRANT INSERT, UPDATE, DELETE ON public.stock_sales TO authenticated;

GRANT SELECT ON public.stock_transactions TO authenticated;
GRANT INSERT, UPDATE, DELETE ON public.stock_transactions TO authenticated;

-- Note: The actual permission enforcement is handled by the RLS policies above
-- The GRANT statements ensure the authenticated role has the necessary base permissions
-- but the RLS policies will restrict access based on user role