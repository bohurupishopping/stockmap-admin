-- Create a custom type for the target period for clarity
CREATE TYPE public.target_period_type AS ENUM (
    'Monthly',
    'Quarterly',
    'Yearly'
);

-- Table to store sales targets for each MR
CREATE TABLE public.mr_sales_targets (
    id UUID NOT NULL DEFAULT gen_random_uuid() PRIMARY KEY,
    mr_user_id UUID NOT NULL REFERENCES public.profiles(user_id) ON DELETE CASCADE,
    
    period_type public.target_period_type NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,

    -- Main Target (could be considered the "Silver" or realistic goal)
    target_sales_amount DECIMAL(12, 2) NOT NULL CHECK (target_sales_amount > 0),

    -- --- ADVANCED ADDITIONS ---
    -- 1. Gamified Tiers (Optional)
    target_tier_bronze DECIMAL(12, 2), -- The minimum goal
    target_tier_gold DECIMAL(12, 2),   -- An exceptional goal

    -- 2. Product-Specific Focus Goals (Optional)
    product_specific_goals JSONB,
    -- Example JSON: 
    -- { "type": "product", "id": "uuid-of-product", "goal_units": 500 }
    -- { "type": "category", "id": "uuid-of-category", "goal_amount": 10000 }

    -- 3. Collection Target (Optional)
    target_collection_percentage DECIMAL(5, 2) CHECK (target_collection_percentage > 0 AND target_collection_percentage <= 100),

    -- 4. Status and Locking
    is_locked BOOLEAN NOT NULL DEFAULT FALSE, -- Admin can lock a target after a certain date

    created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now(),
    updated_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now(),
    
    CONSTRAINT unique_mr_target_period UNIQUE (mr_user_id, start_date)
);

-- Indexes for performance
CREATE INDEX idx_mr_sales_targets_mr_user_id ON public.mr_sales_targets(mr_user_id);
CREATE INDEX idx_mr_sales_targets_period ON public.mr_sales_targets(start_date, end_date);