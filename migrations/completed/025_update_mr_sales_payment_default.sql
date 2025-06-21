-- Migration to update the default payment status from 'Pending' to 'Pending' for mr_sales_orders table
-- This will affect new orders created after this migration is applied

-- Update the default value for payment_status column
ALTER TABLE public.mr_sales_orders 
ALTER COLUMN payment_status SET DEFAULT 'Pending';

-- Optional: Update existing records with 'Pending' status to 'Pending'
-- Uncomment the following line if you want to update existing pending orders
-- UPDATE public.mr_sales_orders SET payment_status = 'Pending' WHERE payment_status = 'Pending';