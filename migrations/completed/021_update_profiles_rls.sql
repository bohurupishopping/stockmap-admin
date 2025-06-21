-- Update RLS policies for profiles table
-- This migration updates the Row Level Security policies to handle admin, user, and mr roles properly

-- Drop existing policies
DROP POLICY IF EXISTS "Users can update their own profile" ON public.profiles;
DROP POLICY IF EXISTS "Users can view their own profile" ON public.profiles;

-- Create new comprehensive policies

-- Admin can do everything (SELECT, INSERT, UPDATE, DELETE)
CREATE POLICY "Admin can manage all profiles" ON public.profiles
    FOR ALL
    TO public
    USING (
        EXISTS (
            SELECT 1 FROM public.profiles p
            WHERE p.user_id = auth.uid() AND p.role = 'admin'
        )
    )
    WITH CHECK (
        EXISTS (
            SELECT 1 FROM public.profiles p
            WHERE p.user_id = auth.uid() AND p.role = 'admin'
        )
    );

-- Users can view and update their own profile
CREATE POLICY "Users can view their own profile" ON public.profiles
    FOR SELECT
    TO public
    USING (
        auth.uid() = user_id AND
        EXISTS (
            SELECT 1 FROM public.profiles p
            WHERE p.user_id = auth.uid() AND p.role = 'user'
        )
    );

CREATE POLICY "Users can update their own profile" ON public.profiles
    FOR UPDATE
    TO public
    USING (
        auth.uid() = user_id AND
        EXISTS (
            SELECT 1 FROM public.profiles p
            WHERE p.user_id = auth.uid() AND p.role = 'user'
        )
    )
    WITH CHECK (
        auth.uid() = user_id AND
        EXISTS (
            SELECT 1 FROM public.profiles p
            WHERE p.user_id = auth.uid() AND p.role = 'user'
        )
    );

-- MR can only view their own profile
CREATE POLICY "MR can view their own profile" ON public.profiles
    FOR SELECT
    TO public
    USING (
        auth.uid() = user_id AND
        EXISTS (
            SELECT 1 FROM public.profiles p
            WHERE p.user_id = auth.uid() AND p.role = 'mr'
        )
    );

-- Ensure RLS is enabled (should already be enabled, but just to be safe)
ALTER TABLE public.profiles ENABLE ROW LEVEL SECURITY;

-- Add comments for documentation
COMMENT ON POLICY "Admin can manage all profiles" ON public.profiles IS 'Admins have full access to all profiles - can view, create, update, and delete any profile';
COMMENT ON POLICY "Users can view their own profile" ON public.profiles IS 'Regular users can only view their own profile data';
COMMENT ON POLICY "Users can update their own profile" ON public.profiles IS 'Regular users can only update their own profile data';
COMMENT ON POLICY "MR can view their own profile" ON public.profiles IS 'Medical Representatives can only view their own profile data';