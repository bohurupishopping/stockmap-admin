-- Add 'mr' role to the user_role enum
-- This migration adds a new role 'mr' to the existing user_role enum type

-- Add the new 'mr' value to the user_role enum
ALTER TYPE public.user_role ADD VALUE 'mr';

-- Note: The is_mr function will be created in a separate migration
-- due to PostgreSQL's requirement that new enum values must be committed
-- before they can be used in functions