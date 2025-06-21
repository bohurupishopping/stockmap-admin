-- Create a custom type for payment status to enforce consistency
CREATE TYPE public.mr_payment_status AS ENUM (
    'Pending',
    'Paid',
    'Partial'
);

-- 1. Table to store the "header" information for each sale made by an MR
CREATE TABLE public.mr_sales_orders (
    id UUID NOT NULL DEFAULT gen_random_uuid() PRIMARY KEY,
    mr_user_id UUID NOT NULL REFERENCES public.profiles(user_id) ON DELETE RESTRICT,
    customer_name TEXT NOT NULL,
    order_date TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now(),
    total_amount DECIMAL(10, 2) NOT NULL CHECK (total_amount >= 0),
    payment_status public.mr_payment_status NOT NULL DEFAULT 'Pending',
    notes TEXT,
    created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now(),
    updated_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now(),

    -- Add a trigger to automatically update the 'updated_at' column
    CONSTRAINT trigger_update_updated_at FOREIGN KEY (id) REFERENCES mr_sales_orders(id) ON UPDATE CASCADE
);

-- Add indexes for faster querying
CREATE INDEX idx_mr_sales_orders_mr_user_id ON public.mr_sales_orders(mr_user_id);
CREATE INDEX idx_mr_sales_orders_order_date ON public.mr_sales_orders(order_date);


-- 2. Table to store the individual items (products) within each sales order
CREATE TABLE public.mr_sales_order_items (
    id UUID NOT NULL DEFAULT gen_random_uuid() PRIMARY KEY,
    order_id UUID NOT NULL REFERENCES public.mr_sales_orders(id) ON DELETE CASCADE,
    product_id UUID NOT NULL REFERENCES public.products(id) ON DELETE RESTRICT,
    batch_id UUID NOT NULL REFERENCES public.product_batches(id) ON DELETE RESTRICT,
    quantity_strips_sold INTEGER NOT NULL CHECK (quantity_strips_sold > 0),
    price_per_strip DECIMAL(10, 2) NOT NULL CHECK (price_per_strip >= 0),
    
    -- This automatically calculates the total for the line item
    line_item_total DECIMAL(10, 2) GENERATED ALWAYS AS (quantity_strips_sold * price_per_strip) STORED,
    
    created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now()
);

-- Add indexes for faster querying
CREATE INDEX idx_mr_sales_order_items_order_id ON public.mr_sales_order_items(order_id);
CREATE INDEX idx_mr_sales_order_items_product_id ON public.mr_sales_order_items(product_id);