-- Create function to check if user has mr role
-- This migration creates the is_mr function after the 'mr' enum value has been committed

-- Create a function to check if user has mr role (similar to is_admin)
CREATE OR REPLACE FUNCTION public.is_mr(user_uuid UUID)
RETURNS BOOLEAN
LANGUAGE sql
SECURITY DEFINER
AS $$
  SELECT EXISTS (
    SELECT 1 FROM public.profiles 
    WHERE user_id = user_uuid AND role = 'mr'
  );
$$;