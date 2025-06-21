-- Create a safe query execution function for AI assistant
-- This function allows only SELECT queries and has built-in security measures

CREATE OR REPLACE FUNCTION public.execute_safe_query(query_text TEXT)
RETURNS TABLE(result JSONB)
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
    clean_query TEXT;
    result_record RECORD;
    result_array JSONB := '[]'::JSONB;
BEGIN
    -- Clean and validate the query
    clean_query := TRIM(query_text);
    
    -- Security check: Only allow SELECT statements
    IF NOT (UPPER(clean_query) LIKE 'SELECT%') THEN
        RAISE EXCEPTION 'Only SELECT queries are allowed';
    END IF;
    
    -- Additional security: Block dangerous keywords
    IF UPPER(clean_query) ~ '(DROP|DELETE|UPDATE|INSERT|ALTER|CREATE|TRUNCATE|GRANT|REVOKE)' THEN
        RAISE EXCEPTION 'Query contains prohibited keywords';
    END IF;
    
    -- Limit query complexity (basic check)
    IF LENGTH(clean_query) > 2000 THEN
        RAISE EXCEPTION 'Query too long';
    END IF;
    
    -- Execute the query and return results as JSONB
    FOR result_record IN EXECUTE clean_query LOOP
        result_array := result_array || to_jsonb(result_record);
    END LOOP;
    
    -- Limit result size
    IF jsonb_array_length(result_array) > 100 THEN
        result_array := jsonb_path_query_array(result_array, '$[0 to 99]');
    END IF;
    
    RETURN QUERY SELECT result_array;
END;
$$;

-- Grant execute permission to authenticated users
GRANT EXECUTE ON FUNCTION public.execute_safe_query(TEXT) TO authenticated;

-- Create RLS policy if needed
ALTER FUNCTION public.execute_safe_query(TEXT) OWNER TO supabase_admin;

COMMENT ON FUNCTION public.execute_safe_query(TEXT) IS 'Safely execute SELECT queries for AI assistant with built-in security measures';