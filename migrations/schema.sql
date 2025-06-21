--
-- PostgreSQL database dump
--

-- Dumped from database version 15.8
-- Dumped by pg_dump version 17.5 (Debian 17.5-1.pgdg120+1)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: _realtime; Type: SCHEMA; Schema: -; Owner: supabase_admin
--

CREATE SCHEMA _realtime;


ALTER SCHEMA _realtime OWNER TO supabase_admin;

--
-- Name: auth; Type: SCHEMA; Schema: -; Owner: supabase_admin
--

CREATE SCHEMA auth;


ALTER SCHEMA auth OWNER TO supabase_admin;

--
-- Name: extensions; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA extensions;


ALTER SCHEMA extensions OWNER TO postgres;

--
-- Name: graphql; Type: SCHEMA; Schema: -; Owner: supabase_admin
--

CREATE SCHEMA graphql;


ALTER SCHEMA graphql OWNER TO supabase_admin;

--
-- Name: graphql_public; Type: SCHEMA; Schema: -; Owner: supabase_admin
--

CREATE SCHEMA graphql_public;


ALTER SCHEMA graphql_public OWNER TO supabase_admin;

--
-- Name: pg_net; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pg_net WITH SCHEMA extensions;


--
-- Name: EXTENSION pg_net; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION pg_net IS 'Async HTTP';


--
-- Name: pgbouncer; Type: SCHEMA; Schema: -; Owner: pgbouncer
--

CREATE SCHEMA pgbouncer;


ALTER SCHEMA pgbouncer OWNER TO pgbouncer;

--
-- Name: pgsodium; Type: SCHEMA; Schema: -; Owner: supabase_admin
--

CREATE SCHEMA pgsodium;


ALTER SCHEMA pgsodium OWNER TO supabase_admin;

--
-- Name: pgsodium; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pgsodium WITH SCHEMA pgsodium;


--
-- Name: EXTENSION pgsodium; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION pgsodium IS 'Pgsodium is a modern cryptography library for Postgres.';


--
-- Name: realtime; Type: SCHEMA; Schema: -; Owner: supabase_admin
--

CREATE SCHEMA realtime;


ALTER SCHEMA realtime OWNER TO supabase_admin;

--
-- Name: storage; Type: SCHEMA; Schema: -; Owner: supabase_admin
--

CREATE SCHEMA storage;


ALTER SCHEMA storage OWNER TO supabase_admin;

--
-- Name: supabase_functions; Type: SCHEMA; Schema: -; Owner: supabase_admin
--

CREATE SCHEMA supabase_functions;


ALTER SCHEMA supabase_functions OWNER TO supabase_admin;

--
-- Name: vault; Type: SCHEMA; Schema: -; Owner: supabase_admin
--

CREATE SCHEMA vault;


ALTER SCHEMA vault OWNER TO supabase_admin;

--
-- Name: pg_graphql; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pg_graphql WITH SCHEMA graphql;


--
-- Name: EXTENSION pg_graphql; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION pg_graphql IS 'pg_graphql: GraphQL support';


--
-- Name: pg_stat_statements; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pg_stat_statements WITH SCHEMA extensions;


--
-- Name: EXTENSION pg_stat_statements; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION pg_stat_statements IS 'track planning and execution statistics of all SQL statements executed';


--
-- Name: pgcrypto; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pgcrypto WITH SCHEMA extensions;


--
-- Name: EXTENSION pgcrypto; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION pgcrypto IS 'cryptographic functions';


--
-- Name: pgjwt; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pgjwt WITH SCHEMA extensions;


--
-- Name: EXTENSION pgjwt; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION pgjwt IS 'JSON Web Token API for Postgresql';


--
-- Name: supabase_vault; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS supabase_vault WITH SCHEMA vault;


--
-- Name: EXTENSION supabase_vault; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION supabase_vault IS 'Supabase Vault Extension';


--
-- Name: uuid-ossp; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS "uuid-ossp" WITH SCHEMA extensions;


--
-- Name: EXTENSION "uuid-ossp"; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION "uuid-ossp" IS 'generate universally unique identifiers (UUIDs)';


--
-- Name: aal_level; Type: TYPE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TYPE auth.aal_level AS ENUM (
    'aal1',
    'aal2',
    'aal3'
);


ALTER TYPE auth.aal_level OWNER TO supabase_auth_admin;

--
-- Name: code_challenge_method; Type: TYPE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TYPE auth.code_challenge_method AS ENUM (
    's256',
    'plain'
);


ALTER TYPE auth.code_challenge_method OWNER TO supabase_auth_admin;

--
-- Name: factor_status; Type: TYPE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TYPE auth.factor_status AS ENUM (
    'unverified',
    'verified'
);


ALTER TYPE auth.factor_status OWNER TO supabase_auth_admin;

--
-- Name: factor_type; Type: TYPE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TYPE auth.factor_type AS ENUM (
    'totp',
    'webauthn',
    'phone'
);


ALTER TYPE auth.factor_type OWNER TO supabase_auth_admin;

--
-- Name: one_time_token_type; Type: TYPE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TYPE auth.one_time_token_type AS ENUM (
    'confirmation_token',
    'reauthentication_token',
    'recovery_token',
    'email_change_token_new',
    'email_change_token_current',
    'phone_change_token'
);


ALTER TYPE auth.one_time_token_type OWNER TO supabase_auth_admin;

--
-- Name: mr_payment_status; Type: TYPE; Schema: public; Owner: supabase_admin
--

CREATE TYPE public.mr_payment_status AS ENUM (
    'Pending',
    'Paid',
    'Partial'
);


ALTER TYPE public.mr_payment_status OWNER TO supabase_admin;

--
-- Name: target_period_type; Type: TYPE; Schema: public; Owner: supabase_admin
--

CREATE TYPE public.target_period_type AS ENUM (
    'Monthly',
    'Quarterly',
    'Yearly'
);


ALTER TYPE public.target_period_type OWNER TO supabase_admin;

--
-- Name: user_role; Type: TYPE; Schema: public; Owner: supabase_admin
--

CREATE TYPE public.user_role AS ENUM (
    'admin',
    'user',
    'mr'
);


ALTER TYPE public.user_role OWNER TO supabase_admin;

--
-- Name: action; Type: TYPE; Schema: realtime; Owner: supabase_admin
--

CREATE TYPE realtime.action AS ENUM (
    'INSERT',
    'UPDATE',
    'DELETE',
    'TRUNCATE',
    'ERROR'
);


ALTER TYPE realtime.action OWNER TO supabase_admin;

--
-- Name: equality_op; Type: TYPE; Schema: realtime; Owner: supabase_admin
--

CREATE TYPE realtime.equality_op AS ENUM (
    'eq',
    'neq',
    'lt',
    'lte',
    'gt',
    'gte',
    'in'
);


ALTER TYPE realtime.equality_op OWNER TO supabase_admin;

--
-- Name: user_defined_filter; Type: TYPE; Schema: realtime; Owner: supabase_admin
--

CREATE TYPE realtime.user_defined_filter AS (
	column_name text,
	op realtime.equality_op,
	value text
);


ALTER TYPE realtime.user_defined_filter OWNER TO supabase_admin;

--
-- Name: wal_column; Type: TYPE; Schema: realtime; Owner: supabase_admin
--

CREATE TYPE realtime.wal_column AS (
	name text,
	type_name text,
	type_oid oid,
	value jsonb,
	is_pkey boolean,
	is_selectable boolean
);


ALTER TYPE realtime.wal_column OWNER TO supabase_admin;

--
-- Name: wal_rls; Type: TYPE; Schema: realtime; Owner: supabase_admin
--

CREATE TYPE realtime.wal_rls AS (
	wal jsonb,
	is_rls_enabled boolean,
	subscription_ids uuid[],
	errors text[]
);


ALTER TYPE realtime.wal_rls OWNER TO supabase_admin;

--
-- Name: email(); Type: FUNCTION; Schema: auth; Owner: supabase_auth_admin
--

CREATE FUNCTION auth.email() RETURNS text
    LANGUAGE sql STABLE
    AS $$
  select 
  coalesce(
    nullif(current_setting('request.jwt.claim.email', true), ''),
    (nullif(current_setting('request.jwt.claims', true), '')::jsonb ->> 'email')
  )::text
$$;


ALTER FUNCTION auth.email() OWNER TO supabase_auth_admin;

--
-- Name: FUNCTION email(); Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON FUNCTION auth.email() IS 'Deprecated. Use auth.jwt() -> ''email'' instead.';


--
-- Name: jwt(); Type: FUNCTION; Schema: auth; Owner: supabase_auth_admin
--

CREATE FUNCTION auth.jwt() RETURNS jsonb
    LANGUAGE sql STABLE
    AS $$
  select 
    coalesce(
        nullif(current_setting('request.jwt.claim', true), ''),
        nullif(current_setting('request.jwt.claims', true), '')
    )::jsonb
$$;


ALTER FUNCTION auth.jwt() OWNER TO supabase_auth_admin;

--
-- Name: role(); Type: FUNCTION; Schema: auth; Owner: supabase_auth_admin
--

CREATE FUNCTION auth.role() RETURNS text
    LANGUAGE sql STABLE
    AS $$
  select 
  coalesce(
    nullif(current_setting('request.jwt.claim.role', true), ''),
    (nullif(current_setting('request.jwt.claims', true), '')::jsonb ->> 'role')
  )::text
$$;


ALTER FUNCTION auth.role() OWNER TO supabase_auth_admin;

--
-- Name: FUNCTION role(); Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON FUNCTION auth.role() IS 'Deprecated. Use auth.jwt() -> ''role'' instead.';


--
-- Name: uid(); Type: FUNCTION; Schema: auth; Owner: supabase_auth_admin
--

CREATE FUNCTION auth.uid() RETURNS uuid
    LANGUAGE sql STABLE
    AS $$
  select 
  coalesce(
    nullif(current_setting('request.jwt.claim.sub', true), ''),
    (nullif(current_setting('request.jwt.claims', true), '')::jsonb ->> 'sub')
  )::uuid
$$;


ALTER FUNCTION auth.uid() OWNER TO supabase_auth_admin;

--
-- Name: FUNCTION uid(); Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON FUNCTION auth.uid() IS 'Deprecated. Use auth.jwt() -> ''sub'' instead.';


--
-- Name: grant_pg_cron_access(); Type: FUNCTION; Schema: extensions; Owner: postgres
--

CREATE FUNCTION extensions.grant_pg_cron_access() RETURNS event_trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  IF EXISTS (
    SELECT
    FROM pg_event_trigger_ddl_commands() AS ev
    JOIN pg_extension AS ext
    ON ev.objid = ext.oid
    WHERE ext.extname = 'pg_cron'
  )
  THEN
    grant usage on schema cron to postgres with grant option;

    alter default privileges in schema cron grant all on tables to postgres with grant option;
    alter default privileges in schema cron grant all on functions to postgres with grant option;
    alter default privileges in schema cron grant all on sequences to postgres with grant option;

    alter default privileges for user supabase_admin in schema cron grant all
        on sequences to postgres with grant option;
    alter default privileges for user supabase_admin in schema cron grant all
        on tables to postgres with grant option;
    alter default privileges for user supabase_admin in schema cron grant all
        on functions to postgres with grant option;

    grant all privileges on all tables in schema cron to postgres with grant option;
    revoke all on table cron.job from postgres;
    grant select on table cron.job to postgres with grant option;
  END IF;
END;
$$;


ALTER FUNCTION extensions.grant_pg_cron_access() OWNER TO postgres;

--
-- Name: FUNCTION grant_pg_cron_access(); Type: COMMENT; Schema: extensions; Owner: postgres
--

COMMENT ON FUNCTION extensions.grant_pg_cron_access() IS 'Grants access to pg_cron';


--
-- Name: grant_pg_graphql_access(); Type: FUNCTION; Schema: extensions; Owner: supabase_admin
--

CREATE FUNCTION extensions.grant_pg_graphql_access() RETURNS event_trigger
    LANGUAGE plpgsql
    AS $_$
DECLARE
    func_is_graphql_resolve bool;
BEGIN
    func_is_graphql_resolve = (
        SELECT n.proname = 'resolve'
        FROM pg_event_trigger_ddl_commands() AS ev
        LEFT JOIN pg_catalog.pg_proc AS n
        ON ev.objid = n.oid
    );

    IF func_is_graphql_resolve
    THEN
        -- Update public wrapper to pass all arguments through to the pg_graphql resolve func
        DROP FUNCTION IF EXISTS graphql_public.graphql;
        create or replace function graphql_public.graphql(
            "operationName" text default null,
            query text default null,
            variables jsonb default null,
            extensions jsonb default null
        )
            returns jsonb
            language sql
        as $$
            select graphql.resolve(
                query := query,
                variables := coalesce(variables, '{}'),
                "operationName" := "operationName",
                extensions := extensions
            );
        $$;

        -- This hook executes when `graphql.resolve` is created. That is not necessarily the last
        -- function in the extension so we need to grant permissions on existing entities AND
        -- update default permissions to any others that are created after `graphql.resolve`
        grant usage on schema graphql to postgres, anon, authenticated, service_role;
        grant select on all tables in schema graphql to postgres, anon, authenticated, service_role;
        grant execute on all functions in schema graphql to postgres, anon, authenticated, service_role;
        grant all on all sequences in schema graphql to postgres, anon, authenticated, service_role;
        alter default privileges in schema graphql grant all on tables to postgres, anon, authenticated, service_role;
        alter default privileges in schema graphql grant all on functions to postgres, anon, authenticated, service_role;
        alter default privileges in schema graphql grant all on sequences to postgres, anon, authenticated, service_role;

        -- Allow postgres role to allow granting usage on graphql and graphql_public schemas to custom roles
        grant usage on schema graphql_public to postgres with grant option;
        grant usage on schema graphql to postgres with grant option;
    END IF;

END;
$_$;


ALTER FUNCTION extensions.grant_pg_graphql_access() OWNER TO supabase_admin;

--
-- Name: FUNCTION grant_pg_graphql_access(); Type: COMMENT; Schema: extensions; Owner: supabase_admin
--

COMMENT ON FUNCTION extensions.grant_pg_graphql_access() IS 'Grants access to pg_graphql';


--
-- Name: grant_pg_net_access(); Type: FUNCTION; Schema: extensions; Owner: postgres
--

CREATE FUNCTION extensions.grant_pg_net_access() RETURNS event_trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  IF EXISTS (
    SELECT 1
    FROM pg_event_trigger_ddl_commands() AS ev
    JOIN pg_extension AS ext
    ON ev.objid = ext.oid
    WHERE ext.extname = 'pg_net'
  )
  THEN
    IF NOT EXISTS (
      SELECT 1
      FROM pg_roles
      WHERE rolname = 'supabase_functions_admin'
    )
    THEN
      CREATE USER supabase_functions_admin NOINHERIT CREATEROLE LOGIN NOREPLICATION;
    END IF;

    GRANT USAGE ON SCHEMA net TO supabase_functions_admin, postgres, anon, authenticated, service_role;

    IF EXISTS (
      SELECT FROM pg_extension
      WHERE extname = 'pg_net'
      -- all versions in use on existing projects as of 2025-02-20
      -- version 0.12.0 onwards don't need these applied
      AND extversion IN ('0.2', '0.6', '0.7', '0.7.1', '0.8', '0.10.0', '0.11.0')
    ) THEN
      ALTER function net.http_get(url text, params jsonb, headers jsonb, timeout_milliseconds integer) SECURITY DEFINER;
      ALTER function net.http_post(url text, body jsonb, params jsonb, headers jsonb, timeout_milliseconds integer) SECURITY DEFINER;

      ALTER function net.http_get(url text, params jsonb, headers jsonb, timeout_milliseconds integer) SET search_path = net;
      ALTER function net.http_post(url text, body jsonb, params jsonb, headers jsonb, timeout_milliseconds integer) SET search_path = net;

      REVOKE ALL ON FUNCTION net.http_get(url text, params jsonb, headers jsonb, timeout_milliseconds integer) FROM PUBLIC;
      REVOKE ALL ON FUNCTION net.http_post(url text, body jsonb, params jsonb, headers jsonb, timeout_milliseconds integer) FROM PUBLIC;

      GRANT EXECUTE ON FUNCTION net.http_get(url text, params jsonb, headers jsonb, timeout_milliseconds integer) TO supabase_functions_admin, postgres, anon, authenticated, service_role;
      GRANT EXECUTE ON FUNCTION net.http_post(url text, body jsonb, params jsonb, headers jsonb, timeout_milliseconds integer) TO supabase_functions_admin, postgres, anon, authenticated, service_role;
    END IF;
  END IF;
END;
$$;


ALTER FUNCTION extensions.grant_pg_net_access() OWNER TO postgres;

--
-- Name: FUNCTION grant_pg_net_access(); Type: COMMENT; Schema: extensions; Owner: postgres
--

COMMENT ON FUNCTION extensions.grant_pg_net_access() IS 'Grants access to pg_net';


--
-- Name: pgrst_ddl_watch(); Type: FUNCTION; Schema: extensions; Owner: supabase_admin
--

CREATE FUNCTION extensions.pgrst_ddl_watch() RETURNS event_trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
  cmd record;
BEGIN
  FOR cmd IN SELECT * FROM pg_event_trigger_ddl_commands()
  LOOP
    IF cmd.command_tag IN (
      'CREATE SCHEMA', 'ALTER SCHEMA'
    , 'CREATE TABLE', 'CREATE TABLE AS', 'SELECT INTO', 'ALTER TABLE'
    , 'CREATE FOREIGN TABLE', 'ALTER FOREIGN TABLE'
    , 'CREATE VIEW', 'ALTER VIEW'
    , 'CREATE MATERIALIZED VIEW', 'ALTER MATERIALIZED VIEW'
    , 'CREATE FUNCTION', 'ALTER FUNCTION'
    , 'CREATE TRIGGER'
    , 'CREATE TYPE', 'ALTER TYPE'
    , 'CREATE RULE'
    , 'COMMENT'
    )
    -- don't notify in case of CREATE TEMP table or other objects created on pg_temp
    AND cmd.schema_name is distinct from 'pg_temp'
    THEN
      NOTIFY pgrst, 'reload schema';
    END IF;
  END LOOP;
END; $$;


ALTER FUNCTION extensions.pgrst_ddl_watch() OWNER TO supabase_admin;

--
-- Name: pgrst_drop_watch(); Type: FUNCTION; Schema: extensions; Owner: supabase_admin
--

CREATE FUNCTION extensions.pgrst_drop_watch() RETURNS event_trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
  obj record;
BEGIN
  FOR obj IN SELECT * FROM pg_event_trigger_dropped_objects()
  LOOP
    IF obj.object_type IN (
      'schema'
    , 'table'
    , 'foreign table'
    , 'view'
    , 'materialized view'
    , 'function'
    , 'trigger'
    , 'type'
    , 'rule'
    )
    AND obj.is_temporary IS false -- no pg_temp objects
    THEN
      NOTIFY pgrst, 'reload schema';
    END IF;
  END LOOP;
END; $$;


ALTER FUNCTION extensions.pgrst_drop_watch() OWNER TO supabase_admin;

--
-- Name: set_graphql_placeholder(); Type: FUNCTION; Schema: extensions; Owner: supabase_admin
--

CREATE FUNCTION extensions.set_graphql_placeholder() RETURNS event_trigger
    LANGUAGE plpgsql
    AS $_$
    DECLARE
    graphql_is_dropped bool;
    BEGIN
    graphql_is_dropped = (
        SELECT ev.schema_name = 'graphql_public'
        FROM pg_event_trigger_dropped_objects() AS ev
        WHERE ev.schema_name = 'graphql_public'
    );

    IF graphql_is_dropped
    THEN
        create or replace function graphql_public.graphql(
            "operationName" text default null,
            query text default null,
            variables jsonb default null,
            extensions jsonb default null
        )
            returns jsonb
            language plpgsql
        as $$
            DECLARE
                server_version float;
            BEGIN
                server_version = (SELECT (SPLIT_PART((select version()), ' ', 2))::float);

                IF server_version >= 14 THEN
                    RETURN jsonb_build_object(
                        'errors', jsonb_build_array(
                            jsonb_build_object(
                                'message', 'pg_graphql extension is not enabled.'
                            )
                        )
                    );
                ELSE
                    RETURN jsonb_build_object(
                        'errors', jsonb_build_array(
                            jsonb_build_object(
                                'message', 'pg_graphql is only available on projects running Postgres 14 onwards.'
                            )
                        )
                    );
                END IF;
            END;
        $$;
    END IF;

    END;
$_$;


ALTER FUNCTION extensions.set_graphql_placeholder() OWNER TO supabase_admin;

--
-- Name: FUNCTION set_graphql_placeholder(); Type: COMMENT; Schema: extensions; Owner: supabase_admin
--

COMMENT ON FUNCTION extensions.set_graphql_placeholder() IS 'Reintroduces placeholder function for graphql_public.graphql';


--
-- Name: get_auth(text); Type: FUNCTION; Schema: pgbouncer; Owner: postgres
--

CREATE FUNCTION pgbouncer.get_auth(p_usename text) RETURNS TABLE(username text, password text)
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
BEGIN
    RAISE WARNING 'PgBouncer auth request: %', p_usename;

    RETURN QUERY
    SELECT usename::TEXT, passwd::TEXT FROM pg_catalog.pg_shadow
    WHERE usename = p_usename;
END;
$$;


ALTER FUNCTION pgbouncer.get_auth(p_usename text) OWNER TO postgres;

--
-- Name: calculate_closing_stock(uuid, uuid, text, text, date); Type: FUNCTION; Schema: public; Owner: supabase_admin
--

CREATE FUNCTION public.calculate_closing_stock(p_product_id uuid, p_batch_id uuid, p_location_type text, p_location_id text, p_report_date date) RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE
    v_closing_stock INTEGER;
BEGIN
    SELECT COALESCE(
        SUM(
            CASE 
                WHEN transaction_type = 'STOCK_IN_GODOWN' THEN quantity_strips
                WHEN transaction_type IN ('SALE_DIRECT_GODOWN', 'SALE_BY_MR') THEN -quantity_strips
                WHEN transaction_type LIKE 'RETURN_TO_%' THEN quantity_strips
                WHEN transaction_type LIKE 'ADJUST_%' THEN -quantity_strips
                ELSE 0
            END
        ),
        0
    ) INTO v_closing_stock
    FROM public.stock_transactions_view
    WHERE product_id = p_product_id
    AND batch_id = p_batch_id
    AND (
        (location_type_source = p_location_type AND location_id_source = p_location_id)
        OR
        (location_type_destination = p_location_type AND location_id_destination = p_location_id)
    )
    AND transaction_date <= p_report_date;

    RETURN GREATEST(0, v_closing_stock);
END;
$$;


ALTER FUNCTION public.calculate_closing_stock(p_product_id uuid, p_batch_id uuid, p_location_type text, p_location_id text, p_report_date date) OWNER TO supabase_admin;

--
-- Name: create_mr_sale(text, jsonb, numeric, text); Type: FUNCTION; Schema: public; Owner: supabase_admin
--

CREATE FUNCTION public.create_mr_sale(p_customer_name text, p_items jsonb, p_total_amount numeric, p_notes text DEFAULT ''::text) RETURNS uuid
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
DECLARE
    v_order_id UUID;
    v_mr_user_id UUID;
    v_item JSONB;
BEGIN
    -- Get the current user's ID (must be an MR)
    SELECT user_id INTO v_mr_user_id 
    FROM public.profiles 
    WHERE user_id = auth.uid() AND role = 'mr';
    
    IF v_mr_user_id IS NULL THEN
        RAISE EXCEPTION 'User must be an MR to create sales orders';
    END IF;

    -- Create the sales order header
    INSERT INTO public.mr_sales_orders (
        mr_user_id,
        customer_name,
        total_amount,
        notes
    ) VALUES (
        v_mr_user_id,
        p_customer_name,
        p_total_amount,
        p_notes
    ) RETURNING id INTO v_order_id;

    -- Insert each item
    FOR v_item IN SELECT * FROM jsonb_array_elements(p_items)
    LOOP
        INSERT INTO public.mr_sales_order_items (
            order_id,
            product_id,
            batch_id,
            quantity_strips_sold,
            price_per_strip
        ) VALUES (
            v_order_id,
            (v_item->>'product_id')::UUID,
            (v_item->>'batch_id')::UUID,
            (v_item->>'quantity_strips_sold')::INTEGER,
            (v_item->>'price_per_strip')::DECIMAL(10,2)
        );
        
        -- Update stock by reducing the quantity sold
        -- This assumes there's a stock tracking mechanism
        -- You may need to adjust this based on your stock management system
        UPDATE public.mr_stock_summary 
        SET current_quantity_strips = current_quantity_strips - (v_item->>'quantity_strips_sold')::INTEGER
        WHERE product_id = (v_item->>'product_id')::UUID 
        AND batch_id = (v_item->>'batch_id')::UUID
        AND mr_user_id = v_mr_user_id;
    END LOOP;

    RETURN v_order_id;
END;
$$;


ALTER FUNCTION public.create_mr_sale(p_customer_name text, p_items jsonb, p_total_amount numeric, p_notes text) OWNER TO supabase_admin;

--
-- Name: create_product_with_auto_code(text, text, text, uuid, uuid, uuid, text, numeric, boolean, text, text, integer, integer, integer); Type: FUNCTION; Schema: public; Owner: supabase_admin
--

CREATE FUNCTION public.create_product_with_auto_code(p_product_name text, p_generic_name text, p_manufacturer text, p_category_id uuid, p_formulation_id uuid, p_sub_category_id uuid DEFAULT NULL::uuid, p_unit_of_measure_smallest text DEFAULT 'Strip'::text, p_base_cost_per_strip numeric DEFAULT 0, p_is_active boolean DEFAULT true, p_storage_conditions text DEFAULT NULL::text, p_image_url text DEFAULT NULL::text, p_min_stock_level_godown integer DEFAULT 0, p_min_stock_level_mr integer DEFAULT 0, p_lead_time_days integer DEFAULT 0) RETURNS TABLE(id uuid, product_code text, product_name text, generic_name text, manufacturer text, category_id uuid, sub_category_id uuid, formulation_id uuid, unit_of_measure_smallest text, base_cost_per_strip numeric, is_active boolean, storage_conditions text, image_url text, min_stock_level_godown integer, min_stock_level_mr integer, lead_time_days integer, created_at timestamp with time zone, updated_at timestamp with time zone)
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
DECLARE
  v_last_code TEXT;
  v_next_code TEXT;
  v_last_number INTEGER;
  v_next_number INTEGER;
  v_new_product RECORD;
  v_max_retries INTEGER := 5;
  v_retry_count INTEGER := 0;
BEGIN
  -- Loop to handle potential race conditions
  LOOP
    BEGIN
      -- Get the last product code with MAP prefix in a single query
      SELECT products.product_code INTO v_last_code
      FROM public.products
      WHERE products.product_code LIKE 'MAP%'
      ORDER BY products.product_code DESC
      LIMIT 1
      FOR UPDATE; -- Lock to prevent concurrent reads
      
      -- Generate next code
      IF v_last_code IS NULL THEN
        v_next_code := 'MAP00001';
      ELSE
        -- Extract number part and increment
        v_last_number := CAST(SUBSTRING(v_last_code FROM 4) AS INTEGER);
        v_next_number := v_last_number + 1;
        v_next_code := 'MAP' || LPAD(v_next_number::TEXT, 5, '0');
      END IF;
      
      -- Insert the new product
      INSERT INTO public.products (
        product_code,
        product_name,
        generic_name,
        manufacturer,
        category_id,
        sub_category_id,
        formulation_id,
        unit_of_measure_smallest,
        base_cost_per_strip,
        is_active,
        storage_conditions,
        image_url,
        min_stock_level_godown,
        min_stock_level_mr,
        lead_time_days
      ) VALUES (
        v_next_code,
        p_product_name,
        p_generic_name,
        p_manufacturer,
        p_category_id,
        p_sub_category_id,
        p_formulation_id,
        p_unit_of_measure_smallest,
        p_base_cost_per_strip,
        p_is_active,
        p_storage_conditions,
        p_image_url,
        p_min_stock_level_godown,
        p_min_stock_level_mr,
        p_lead_time_days
      )
      RETURNING * INTO v_new_product;
      
      -- If we get here, the insert was successful, exit the loop
      EXIT;
      
    EXCEPTION
      WHEN unique_violation THEN
        -- If there's a unique constraint violation on product_code, retry
        v_retry_count := v_retry_count + 1;
        IF v_retry_count >= v_max_retries THEN
          RAISE EXCEPTION 'Failed to generate unique product code after % retries', v_max_retries;
        END IF;
        -- Continue the loop to try again
    END;
  END LOOP;
  
  -- Return the created product
  RETURN QUERY
  SELECT 
    v_new_product.id,
    v_new_product.product_code,
    v_new_product.product_name,
    v_new_product.generic_name,
    v_new_product.manufacturer,
    v_new_product.category_id,
    v_new_product.sub_category_id,
    v_new_product.formulation_id,
    v_new_product.unit_of_measure_smallest,
    v_new_product.base_cost_per_strip,
    v_new_product.is_active,
    v_new_product.storage_conditions,
    v_new_product.image_url,
    v_new_product.min_stock_level_godown,
    v_new_product.min_stock_level_mr,
    v_new_product.lead_time_days,
    v_new_product.created_at,
    v_new_product.updated_at;
END;
$$;


ALTER FUNCTION public.create_product_with_auto_code(p_product_name text, p_generic_name text, p_manufacturer text, p_category_id uuid, p_formulation_id uuid, p_sub_category_id uuid, p_unit_of_measure_smallest text, p_base_cost_per_strip numeric, p_is_active boolean, p_storage_conditions text, p_image_url text, p_min_stock_level_godown integer, p_min_stock_level_mr integer, p_lead_time_days integer) OWNER TO supabase_admin;

--
-- Name: execute_safe_query(text); Type: FUNCTION; Schema: public; Owner: supabase_admin
--

CREATE FUNCTION public.execute_safe_query(query_text text) RETURNS TABLE(result jsonb)
    LANGUAGE plpgsql SECURITY DEFINER
    AS $_$
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
$_$;


ALTER FUNCTION public.execute_safe_query(query_text text) OWNER TO supabase_admin;

--
-- Name: FUNCTION execute_safe_query(query_text text); Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON FUNCTION public.execute_safe_query(query_text text) IS 'Safely execute SELECT queries for AI assistant with built-in security measures';


--
-- Name: handle_new_user(); Type: FUNCTION; Schema: public; Owner: supabase_admin
--

CREATE FUNCTION public.handle_new_user() RETURNS trigger
    LANGUAGE plpgsql SECURITY DEFINER
    SET search_path TO ''
    AS $$
BEGIN
  INSERT INTO public.profiles (user_id, name, email, role)
  VALUES (
    new.id,
    COALESCE(new.raw_user_meta_data ->> 'name', ''),
    new.email,
    'user'::public.user_role
  );
  RETURN new;
EXCEPTION
  WHEN OTHERS THEN
    -- Log the error but don't block user creation
    RAISE LOG 'Error creating profile for user %: %', new.id, SQLERRM;
    RETURN new;
END;
$$;


ALTER FUNCTION public.handle_new_user() OWNER TO supabase_admin;

--
-- Name: is_admin(uuid); Type: FUNCTION; Schema: public; Owner: supabase_admin
--

CREATE FUNCTION public.is_admin(user_uuid uuid) RETURNS boolean
    LANGUAGE sql SECURITY DEFINER
    AS $$
  SELECT EXISTS (
    SELECT 1 FROM public.profiles 
    WHERE user_id = user_uuid AND role = 'admin'
  );
$$;


ALTER FUNCTION public.is_admin(user_uuid uuid) OWNER TO supabase_admin;

--
-- Name: recalculate_closing_stock_reports(); Type: FUNCTION; Schema: public; Owner: supabase_admin
--

CREATE FUNCTION public.recalculate_closing_stock_reports() RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
    -- Clear existing reports
    TRUNCATE public.closing_stock_report;
    
    -- Recalculate for each unique combination
    WITH location_transactions AS (
        -- Godown transactions
        SELECT 
            product_id,
            batch_id,
            'GODOWN' as location_type,
            NULL as location_id,
            transaction_type,
            CASE 
                WHEN transaction_type = 'STOCK_IN_GODOWN' THEN quantity_strips
                WHEN transaction_type IN ('SALE_DIRECT_GODOWN', 'SALE_BY_MR') THEN quantity_strips
                WHEN transaction_type LIKE 'RETURN_TO_%' THEN quantity_strips
                WHEN transaction_type LIKE 'ADJUST_%' THEN quantity_strips
                ELSE 0
            END as quantity,
            cost_per_strip_at_transaction
        FROM public.stock_transactions_view
        WHERE (location_type_source = 'GODOWN' OR location_type_destination = 'GODOWN')
        
        UNION ALL
        
        -- MR transactions
        SELECT 
            product_id,
            batch_id,
            'MR' as location_type,
            CASE 
                WHEN location_type_source = 'MR' THEN location_id_source
                WHEN location_type_destination = 'MR' THEN location_id_destination
            END as location_id,
            transaction_type,
            CASE 
                WHEN transaction_type = 'DISPATCH_TO_MR' THEN quantity_strips
                WHEN transaction_type = 'SALE_BY_MR' THEN quantity_strips
                WHEN transaction_type LIKE 'RETURN_TO_%' THEN quantity_strips
                WHEN transaction_type LIKE 'ADJUST_%' THEN quantity_strips
                ELSE 0
            END as quantity,
            cost_per_strip_at_transaction
        FROM public.stock_transactions_view
        WHERE (location_type_source = 'MR' OR location_type_destination = 'MR')
        AND (location_id_source IS NOT NULL OR location_id_destination IS NOT NULL)
    ),
    stock_calculations AS (
        SELECT 
            product_id,
            batch_id,
            location_type,
            location_id,
            -- Opening stock (from previous day's closing)
            COALESCE((
                SELECT closing_quantity_strips 
                FROM public.closing_stock_report 
                WHERE product_id = lt.product_id 
                AND batch_id = lt.batch_id 
                AND location_type = lt.location_type 
                AND location_id = lt.location_id 
                AND report_date < CURRENT_DATE 
                ORDER BY report_date DESC 
                LIMIT 1
            ), 0) as opening_quantity,
            -- Purchases (positive)
            SUM(CASE WHEN transaction_type = 'STOCK_IN_GODOWN' THEN quantity ELSE 0 END) as purchase_quantity,
            -- Sales (negative)
            SUM(CASE WHEN transaction_type IN ('SALE_DIRECT_GODOWN', 'SALE_BY_MR') THEN quantity ELSE 0 END) as sale_quantity,
            -- Returns (negative)
            SUM(CASE WHEN transaction_type LIKE 'RETURN_TO_%' THEN quantity ELSE 0 END) as return_quantity,
            -- Adjustments (negative)
            SUM(CASE WHEN transaction_type LIKE 'ADJUST_%' THEN quantity ELSE 0 END) as adjustment_quantity,
            -- Calculate closing stock
            COALESCE((
                SELECT closing_quantity_strips 
                FROM public.closing_stock_report 
                WHERE product_id = lt.product_id 
                AND batch_id = lt.batch_id 
                AND location_type = lt.location_type 
                AND location_id = lt.location_id 
                AND report_date < CURRENT_DATE 
                ORDER BY report_date DESC 
                LIMIT 1
            ), 0) + 
            SUM(CASE WHEN transaction_type = 'STOCK_IN_GODOWN' THEN quantity ELSE 0 END) -
            SUM(CASE WHEN transaction_type IN ('SALE_DIRECT_GODOWN', 'SALE_BY_MR') THEN quantity ELSE 0 END) -
            SUM(CASE WHEN transaction_type LIKE 'RETURN_TO_%' THEN quantity ELSE 0 END) -
            SUM(CASE WHEN transaction_type LIKE 'ADJUST_%' THEN quantity ELSE 0 END) as closing_quantity,
            AVG(cost_per_strip_at_transaction) as avg_cost,
            SUM(cost_per_strip_at_transaction * quantity) as total_value
        FROM location_transactions lt
        GROUP BY product_id, batch_id, location_type, location_id
        HAVING (
            COALESCE((
                SELECT closing_quantity_strips 
                FROM public.closing_stock_report 
                WHERE product_id = lt.product_id 
                AND batch_id = lt.batch_id 
                AND location_type = lt.location_type 
                AND location_id = lt.location_id 
                AND report_date < CURRENT_DATE 
                ORDER BY report_date DESC 
                LIMIT 1
            ), 0) + 
            SUM(CASE WHEN transaction_type = 'STOCK_IN_GODOWN' THEN quantity ELSE 0 END) -
            SUM(CASE WHEN transaction_type IN ('SALE_DIRECT_GODOWN', 'SALE_BY_MR') THEN quantity ELSE 0 END) -
            SUM(CASE WHEN transaction_type LIKE 'RETURN_TO_%' THEN quantity ELSE 0 END) -
            SUM(CASE WHEN transaction_type LIKE 'ADJUST_%' THEN quantity ELSE 0 END)
        ) >= 0
    )
    INSERT INTO public.closing_stock_report (
        product_id,
        batch_id,
        location_type,
        location_id,
        report_date,
        opening_quantity_strips,
        purchase_quantity_strips,
        sale_quantity_strips,
        return_quantity_strips,
        adjustment_quantity_strips,
        closing_quantity_strips,
        cost_per_strip,
        total_value
    )
    SELECT 
        product_id,
        batch_id,
        location_type,
        location_id,
        CURRENT_DATE,
        opening_quantity,
        purchase_quantity,
        sale_quantity,
        return_quantity,
        adjustment_quantity,
        closing_quantity,
        avg_cost,
        total_value
    FROM stock_calculations;
END;
$$;


ALTER FUNCTION public.recalculate_closing_stock_reports() OWNER TO supabase_admin;

--
-- Name: recalculate_mr_stock_summary_with_prices(); Type: FUNCTION; Schema: public; Owner: supabase_admin
--

CREATE FUNCTION public.recalculate_mr_stock_summary_with_prices() RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
  -- Clear existing data
  TRUNCATE public.mr_stock_summary;
  
  -- Recalculate from all transactions with prices
  INSERT INTO public.mr_stock_summary (
    mr_user_id,
    product_id,
    batch_id,
    current_quantity_strips,
    price_per_strip,
    last_updated_at
  )
  WITH mr_transactions AS (
    SELECT 
      CASE 
        WHEN location_type_destination = 'MR' THEN location_id_destination::UUID
        WHEN location_type_source = 'MR' THEN location_id_source::UUID
      END as mr_user_id,
      product_id,
      batch_id,
      CASE 
        WHEN location_type_destination = 'MR' THEN quantity_strips
        WHEN location_type_source = 'MR' THEN -quantity_strips
        ELSE 0
      END as quantity_change,
      cost_per_strip_at_transaction,
      transaction_date,
      created_at
    FROM public.stock_transactions_view
    WHERE (location_type_destination = 'MR' OR location_type_source = 'MR')
    AND (location_id_destination IS NOT NULL OR location_id_source IS NOT NULL)
  ),
  stock_calculations AS (
    SELECT 
      mr_user_id,
      product_id,
      batch_id,
      SUM(quantity_change) as total_quantity,
      -- Get the latest cost per strip for this combination
      (ARRAY_AGG(cost_per_strip_at_transaction ORDER BY transaction_date DESC, created_at DESC))[1] as latest_cost
    FROM mr_transactions
    WHERE mr_user_id IS NOT NULL
    GROUP BY mr_user_id, product_id, batch_id
    HAVING SUM(quantity_change) > 0
  )
  SELECT 
    mr_user_id,
    product_id,
    batch_id,
    total_quantity,
    COALESCE(latest_cost, 0.00),
    now()
  FROM stock_calculations;
  
  RAISE NOTICE 'MR stock summary recalculated with prices successfully';
END;
$$;


ALTER FUNCTION public.recalculate_mr_stock_summary_with_prices() OWNER TO supabase_admin;

--
-- Name: recalculate_products_stock_status(); Type: FUNCTION; Schema: public; Owner: supabase_admin
--

CREATE FUNCTION public.recalculate_products_stock_status() RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
  -- Clear existing data
  TRUNCATE public.products_stock_status;
  
  -- Recalculate from all transactions
  INSERT INTO public.products_stock_status (
    product_id,
    batch_id,
    location_type,
    location_id,
    current_quantity_strips,
    cost_per_strip,
    last_updated_at
  )
  WITH stock_calculations AS (
    SELECT 
      product_id,
      batch_id,
      location_type,
      location_id,
      SUM(quantity_change) as total_quantity,
      -- Get the latest cost per strip for positive quantities
      (ARRAY_AGG(cost_per_strip_at_transaction ORDER BY created_at DESC))[1] as latest_cost
    FROM (
      -- Destination transactions (incoming stock)
      SELECT 
        product_id,
        batch_id,
        location_type_destination as location_type,
        location_id_destination as location_id,
        CASE 
          WHEN transaction_type LIKE '%STOCK_IN%' OR 
               transaction_type LIKE '%RETURN%' OR
               transaction_type LIKE '%REPLACEMENT_IN%' THEN quantity_strips
          ELSE 0
        END as quantity_change,
        cost_per_strip_at_transaction,
        created_at
      FROM public.stock_transactions
      WHERE location_type_destination IS NOT NULL 
        AND location_id_destination IS NOT NULL
      
      UNION ALL
      
      -- Source transactions (outgoing stock)
      SELECT 
        product_id,
        batch_id,
        location_type_source as location_type,
        location_id_source as location_id,
        CASE 
          WHEN transaction_type LIKE '%DISPATCH%' OR 
               transaction_type LIKE '%SALE%' OR
               transaction_type LIKE '%DAMAGE%' OR
               transaction_type LIKE '%LOSS%' OR
               transaction_type LIKE '%REPLACEMENT_OUT%' THEN -ABS(quantity_strips)
          ELSE 0
        END as quantity_change,
        cost_per_strip_at_transaction,
        created_at
      FROM public.stock_transactions
      WHERE location_type_source IS NOT NULL 
        AND location_id_source IS NOT NULL
    ) all_transactions
    WHERE quantity_change != 0
    GROUP BY product_id, batch_id, location_type, location_id
    HAVING SUM(quantity_change) > 0
  )
  SELECT 
    product_id,
    batch_id,
    location_type,
    location_id,
    total_quantity,
    latest_cost,
    now()
  FROM stock_calculations;
  
  RAISE NOTICE 'Stock status recalculated successfully';
END;
$$;


ALTER FUNCTION public.recalculate_products_stock_status() OWNER TO supabase_admin;

--
-- Name: update_closing_stock_report(); Type: FUNCTION; Schema: public; Owner: supabase_admin
--

CREATE FUNCTION public.update_closing_stock_report() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
    v_report_date DATE := CURRENT_DATE;
    v_old_quantity INTEGER;
    v_new_quantity INTEGER;
    v_transaction_type TEXT;
    v_location_type TEXT;
    v_location_id TEXT;
    v_quantity INTEGER;
BEGIN
    -- Determine transaction type and location
    IF TG_TABLE_NAME = 'stock_purchases' THEN
        v_transaction_type := 'STOCK_IN_GODOWN';
        v_location_type := 'GODOWN';
        v_location_id := NULL;
        v_quantity := NEW.quantity_strips;
    ELSIF TG_TABLE_NAME = 'stock_sales' THEN
        v_transaction_type := NEW.transaction_type;
        v_quantity := NEW.quantity_strips;
        
        -- Handle source location (decrease)
        IF NEW.location_type_source = 'GODOWN' THEN
            v_location_type := 'GODOWN';
            v_location_id := NULL;
        ELSIF NEW.location_type_source = 'MR' THEN
            v_location_type := 'MR';
            v_location_id := NEW.location_id_source;
        END IF;
        
        -- Handle destination location (increase for returns)
        IF NEW.transaction_type LIKE 'RETURN_TO_%' THEN
            IF NEW.location_type_destination = 'GODOWN' THEN
                v_location_type := 'GODOWN';
                v_location_id := NULL;
            ELSIF NEW.location_type_destination = 'MR' THEN
                v_location_type := 'MR';
                v_location_id := NEW.location_id_destination;
            END IF;
        END IF;
    END IF;

    -- Update or insert closing stock record
    INSERT INTO public.closing_stock_report (
        product_id,
        batch_id,
        location_type,
        location_id,
        report_date,
        opening_quantity_strips,
        purchase_quantity_strips,
        sale_quantity_strips,
        return_quantity_strips,
        adjustment_quantity_strips,
        closing_quantity_strips,
        cost_per_strip,
        total_value
    )
    VALUES (
        NEW.product_id,
        NEW.batch_id,
        v_location_type,
        v_location_id,
        v_report_date,
        COALESCE((
            SELECT closing_quantity_strips 
            FROM public.closing_stock_report 
            WHERE product_id = NEW.product_id 
            AND batch_id = NEW.batch_id 
            AND location_type = v_location_type 
            AND location_id = v_location_id 
            AND report_date < v_report_date 
            ORDER BY report_date DESC 
            LIMIT 1
        ), 0),
        CASE WHEN v_transaction_type = 'STOCK_IN_GODOWN' THEN v_quantity ELSE 0 END,
        CASE WHEN v_transaction_type IN ('SALE_DIRECT_GODOWN', 'SALE_BY_MR') THEN v_quantity ELSE 0 END,
        CASE WHEN v_transaction_type LIKE 'RETURN_TO_%' THEN v_quantity ELSE 0 END,
        CASE WHEN v_transaction_type LIKE 'ADJUST_%' THEN v_quantity ELSE 0 END,
        public.calculate_closing_stock(NEW.product_id, NEW.batch_id, v_location_type, v_location_id, v_report_date),
        NEW.cost_per_strip,
        NEW.cost_per_strip * v_quantity
    )
    ON CONFLICT (product_id, batch_id, location_type, location_id, report_date)
    DO UPDATE SET
        opening_quantity_strips = EXCLUDED.opening_quantity_strips,
        purchase_quantity_strips = EXCLUDED.purchase_quantity_strips,
        sale_quantity_strips = EXCLUDED.sale_quantity_strips,
        return_quantity_strips = EXCLUDED.return_quantity_strips,
        adjustment_quantity_strips = EXCLUDED.adjustment_quantity_strips,
        closing_quantity_strips = EXCLUDED.closing_quantity_strips,
        cost_per_strip = EXCLUDED.cost_per_strip,
        total_value = EXCLUDED.total_value,
        last_updated_at = now();

    RETURN NEW;
END;
$$;


ALTER FUNCTION public.update_closing_stock_report() OWNER TO supabase_admin;

--
-- Name: update_mr_stock_summary(); Type: FUNCTION; Schema: public; Owner: supabase_admin
--

CREATE FUNCTION public.update_mr_stock_summary() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  -- Only process transactions that affect MR stock
  IF NEW.location_type_destination = 'MR' OR NEW.location_type_source = 'MR' THEN
    
    -- Handle MR as destination (stock increase)
    IF NEW.location_type_destination = 'MR' AND NEW.location_id_destination IS NOT NULL THEN
      INSERT INTO public.mr_stock_summary (mr_user_id, product_id, batch_id, current_quantity_strips, price_per_strip, last_updated_at)
      VALUES (NEW.location_id_destination::UUID, NEW.product_id, NEW.batch_id, NEW.quantity_strips, NEW.cost_per_strip, now())
      ON CONFLICT (mr_user_id, product_id, batch_id)
      DO UPDATE SET 
        current_quantity_strips = mr_stock_summary.current_quantity_strips + NEW.quantity_strips,
        price_per_strip = NEW.cost_per_strip,
        last_updated_at = now();
    END IF;
    
    -- Handle MR as source (stock decrease)
    IF NEW.location_type_source = 'MR' AND NEW.location_id_source IS NOT NULL THEN
      INSERT INTO public.mr_stock_summary (mr_user_id, product_id, batch_id, current_quantity_strips, price_per_strip, last_updated_at)
      VALUES (NEW.location_id_source::UUID, NEW.product_id, NEW.batch_id, -NEW.quantity_strips, NEW.cost_per_strip, now())
      ON CONFLICT (mr_user_id, product_id, batch_id)
      DO UPDATE SET 
        current_quantity_strips = mr_stock_summary.current_quantity_strips - NEW.quantity_strips,
        price_per_strip = NEW.cost_per_strip,
        last_updated_at = now();
    END IF;
    
  END IF;
  
  RETURN NEW;
END;
$$;


ALTER FUNCTION public.update_mr_stock_summary() OWNER TO supabase_admin;

--
-- Name: update_mr_stock_summary_from_adjustments(); Type: FUNCTION; Schema: public; Owner: supabase_admin
--

CREATE FUNCTION public.update_mr_stock_summary_from_adjustments() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  -- Handle MR as destination (stock increase)
  IF NEW.location_type_destination = 'MR' AND NEW.location_id_destination IS NOT NULL THEN
    INSERT INTO public.mr_stock_summary (mr_user_id, product_id, batch_id, current_quantity_strips, price_per_strip, last_updated_at)
    VALUES (NEW.location_id_destination::UUID, NEW.product_id, NEW.batch_id, NEW.quantity_strips, NEW.cost_per_strip, now())
    ON CONFLICT (mr_user_id, product_id, batch_id)
    DO UPDATE SET 
      current_quantity_strips = mr_stock_summary.current_quantity_strips + NEW.quantity_strips,
      price_per_strip = NEW.cost_per_strip,
      last_updated_at = now();
  END IF;
  
  -- Handle MR as source (stock decrease)
  IF NEW.location_type_source = 'MR' AND NEW.location_id_source IS NOT NULL THEN
    INSERT INTO public.mr_stock_summary (mr_user_id, product_id, batch_id, current_quantity_strips, price_per_strip, last_updated_at)
    VALUES (NEW.location_id_source::UUID, NEW.product_id, NEW.batch_id, -NEW.quantity_strips, NEW.cost_per_strip, now())
    ON CONFLICT (mr_user_id, product_id, batch_id)
    DO UPDATE SET 
      current_quantity_strips = mr_stock_summary.current_quantity_strips - NEW.quantity_strips,
      price_per_strip = NEW.cost_per_strip,
      last_updated_at = now();
  END IF;
  
  RETURN NEW;
END;
$$;


ALTER FUNCTION public.update_mr_stock_summary_from_adjustments() OWNER TO supabase_admin;

--
-- Name: update_mr_stock_summary_from_sales(); Type: FUNCTION; Schema: public; Owner: supabase_admin
--

CREATE FUNCTION public.update_mr_stock_summary_from_sales() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  -- Handle MR as destination (stock increase)
  IF NEW.location_type_destination = 'MR' AND NEW.location_id_destination IS NOT NULL THEN
    INSERT INTO public.mr_stock_summary (mr_user_id, product_id, batch_id, current_quantity_strips, price_per_strip, last_updated_at)
    VALUES (NEW.location_id_destination::UUID, NEW.product_id, NEW.batch_id, NEW.quantity_strips, NEW.cost_per_strip, now())
    ON CONFLICT (mr_user_id, product_id, batch_id)
    DO UPDATE SET 
      current_quantity_strips = mr_stock_summary.current_quantity_strips + NEW.quantity_strips,
      price_per_strip = NEW.cost_per_strip,
      last_updated_at = now();
  END IF;
  
  -- Handle MR as source (stock decrease)
  IF NEW.location_type_source = 'MR' AND NEW.location_id_source IS NOT NULL THEN
    INSERT INTO public.mr_stock_summary (mr_user_id, product_id, batch_id, current_quantity_strips, price_per_strip, last_updated_at)
    VALUES (NEW.location_id_source::UUID, NEW.product_id, NEW.batch_id, -NEW.quantity_strips, NEW.cost_per_strip, now())
    ON CONFLICT (mr_user_id, product_id, batch_id)
    DO UPDATE SET 
      current_quantity_strips = mr_stock_summary.current_quantity_strips - NEW.quantity_strips,
      price_per_strip = NEW.cost_per_strip,
      last_updated_at = now();
  END IF;
  
  RETURN NEW;
END;
$$;


ALTER FUNCTION public.update_mr_stock_summary_from_sales() OWNER TO supabase_admin;

--
-- Name: update_products_stock_status(); Type: FUNCTION; Schema: public; Owner: supabase_admin
--

CREATE FUNCTION public.update_products_stock_status() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  -- Process destination location (incoming stock - positive quantities)
  IF NEW.location_type_destination IS NOT NULL AND NEW.location_id_destination IS NOT NULL THEN
    INSERT INTO public.products_stock_status (
      product_id, 
      batch_id, 
      location_type, 
      location_id, 
      current_quantity_strips, 
      cost_per_strip,
      last_updated_at
    )
    VALUES (
      NEW.product_id,
      NEW.batch_id,
      NEW.location_type_destination,
      NEW.location_id_destination,
      NEW.quantity_strips, -- Use quantity as is for destination
      NEW.cost_per_strip_at_transaction,
      now()
    )
    ON CONFLICT (product_id, batch_id, location_type, location_id)
    DO UPDATE SET
      current_quantity_strips = products_stock_status.current_quantity_strips + NEW.quantity_strips,
      cost_per_strip = NEW.cost_per_strip_at_transaction,
      last_updated_at = now();
  END IF;

  -- Process source location (outgoing stock - negative quantities)
  IF NEW.location_type_source IS NOT NULL AND NEW.location_id_source IS NOT NULL THEN
    INSERT INTO public.products_stock_status (
      product_id, 
      batch_id, 
      location_type, 
      location_id, 
      current_quantity_strips, 
      cost_per_strip,
      last_updated_at
    )
    VALUES (
      NEW.product_id,
      NEW.batch_id,
      NEW.location_type_source,
      NEW.location_id_source,
      -NEW.quantity_strips, -- Negate quantity for source
      NEW.cost_per_strip_at_transaction,
      now()
    )
    ON CONFLICT (product_id, batch_id, location_type, location_id)
    DO UPDATE SET
      current_quantity_strips = GREATEST(0, products_stock_status.current_quantity_strips - NEW.quantity_strips),
      last_updated_at = now();
  END IF;

  RETURN NEW;
END;
$$;


ALTER FUNCTION public.update_products_stock_status() OWNER TO supabase_admin;

--
-- Name: update_updated_at_column(); Type: FUNCTION; Schema: public; Owner: supabase_admin
--

CREATE FUNCTION public.update_updated_at_column() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    NEW.updated_at = now();
    RETURN NEW;
END;
$$;


ALTER FUNCTION public.update_updated_at_column() OWNER TO supabase_admin;

--
-- Name: validate_batch_dates(); Type: FUNCTION; Schema: public; Owner: supabase_admin
--

CREATE FUNCTION public.validate_batch_dates() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  -- Check if expiry date is after manufacturing date
  IF NEW.expiry_date <= NEW.manufacturing_date THEN
    RAISE EXCEPTION 'Expiry date must be after manufacturing date';
  END IF;
  
  RETURN NEW;
END;
$$;


ALTER FUNCTION public.validate_batch_dates() OWNER TO supabase_admin;

--
-- Name: validate_single_base_unit(); Type: FUNCTION; Schema: public; Owner: supabase_admin
--

CREATE FUNCTION public.validate_single_base_unit() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  -- If trying to set is_base_unit to true, check if another base unit exists
  IF NEW.is_base_unit = true THEN
    IF EXISTS (
      SELECT 1 FROM public.product_packaging_units 
      WHERE product_id = NEW.product_id 
      AND is_base_unit = true 
      AND id != COALESCE(NEW.id, '00000000-0000-0000-0000-000000000000'::uuid)
    ) THEN
      RAISE EXCEPTION 'Only one base unit per product is allowed';
    END IF;
  END IF;
  
  RETURN NEW;
END;
$$;


ALTER FUNCTION public.validate_single_base_unit() OWNER TO supabase_admin;

--
-- Name: validate_template_name(); Type: FUNCTION; Schema: public; Owner: supabase_admin
--

CREATE FUNCTION public.validate_template_name() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  IF NEW.packaging_template IS NOT NULL AND
     NOT EXISTS (
       SELECT 1 FROM public.packaging_templates 
       WHERE template_name = NEW.packaging_template
     ) THEN
    RAISE EXCEPTION 'Invalid template name: %', NEW.packaging_template;
  END IF;
  RETURN NEW;
END;
$$;


ALTER FUNCTION public.validate_template_name() OWNER TO supabase_admin;

--
-- Name: apply_rls(jsonb, integer); Type: FUNCTION; Schema: realtime; Owner: supabase_admin
--

CREATE FUNCTION realtime.apply_rls(wal jsonb, max_record_bytes integer DEFAULT (1024 * 1024)) RETURNS SETOF realtime.wal_rls
    LANGUAGE plpgsql
    AS $$
declare
-- Regclass of the table e.g. public.notes
entity_ regclass = (quote_ident(wal ->> 'schema') || '.' || quote_ident(wal ->> 'table'))::regclass;

-- I, U, D, T: insert, update ...
action realtime.action = (
    case wal ->> 'action'
        when 'I' then 'INSERT'
        when 'U' then 'UPDATE'
        when 'D' then 'DELETE'
        else 'ERROR'
    end
);

-- Is row level security enabled for the table
is_rls_enabled bool = relrowsecurity from pg_class where oid = entity_;

subscriptions realtime.subscription[] = array_agg(subs)
    from
        realtime.subscription subs
    where
        subs.entity = entity_;

-- Subscription vars
roles regrole[] = array_agg(distinct us.claims_role::text)
    from
        unnest(subscriptions) us;

working_role regrole;
claimed_role regrole;
claims jsonb;

subscription_id uuid;
subscription_has_access bool;
visible_to_subscription_ids uuid[] = '{}';

-- structured info for wal's columns
columns realtime.wal_column[];
-- previous identity values for update/delete
old_columns realtime.wal_column[];

error_record_exceeds_max_size boolean = octet_length(wal::text) > max_record_bytes;

-- Primary jsonb output for record
output jsonb;

begin
perform set_config('role', null, true);

columns =
    array_agg(
        (
            x->>'name',
            x->>'type',
            x->>'typeoid',
            realtime.cast(
                (x->'value') #>> '{}',
                coalesce(
                    (x->>'typeoid')::regtype, -- null when wal2json version <= 2.4
                    (x->>'type')::regtype
                )
            ),
            (pks ->> 'name') is not null,
            true
        )::realtime.wal_column
    )
    from
        jsonb_array_elements(wal -> 'columns') x
        left join jsonb_array_elements(wal -> 'pk') pks
            on (x ->> 'name') = (pks ->> 'name');

old_columns =
    array_agg(
        (
            x->>'name',
            x->>'type',
            x->>'typeoid',
            realtime.cast(
                (x->'value') #>> '{}',
                coalesce(
                    (x->>'typeoid')::regtype, -- null when wal2json version <= 2.4
                    (x->>'type')::regtype
                )
            ),
            (pks ->> 'name') is not null,
            true
        )::realtime.wal_column
    )
    from
        jsonb_array_elements(wal -> 'identity') x
        left join jsonb_array_elements(wal -> 'pk') pks
            on (x ->> 'name') = (pks ->> 'name');

for working_role in select * from unnest(roles) loop

    -- Update `is_selectable` for columns and old_columns
    columns =
        array_agg(
            (
                c.name,
                c.type_name,
                c.type_oid,
                c.value,
                c.is_pkey,
                pg_catalog.has_column_privilege(working_role, entity_, c.name, 'SELECT')
            )::realtime.wal_column
        )
        from
            unnest(columns) c;

    old_columns =
            array_agg(
                (
                    c.name,
                    c.type_name,
                    c.type_oid,
                    c.value,
                    c.is_pkey,
                    pg_catalog.has_column_privilege(working_role, entity_, c.name, 'SELECT')
                )::realtime.wal_column
            )
            from
                unnest(old_columns) c;

    if action <> 'DELETE' and count(1) = 0 from unnest(columns) c where c.is_pkey then
        return next (
            jsonb_build_object(
                'schema', wal ->> 'schema',
                'table', wal ->> 'table',
                'type', action
            ),
            is_rls_enabled,
            -- subscriptions is already filtered by entity
            (select array_agg(s.subscription_id) from unnest(subscriptions) as s where claims_role = working_role),
            array['Error 400: Bad Request, no primary key']
        )::realtime.wal_rls;

    -- The claims role does not have SELECT permission to the primary key of entity
    elsif action <> 'DELETE' and sum(c.is_selectable::int) <> count(1) from unnest(columns) c where c.is_pkey then
        return next (
            jsonb_build_object(
                'schema', wal ->> 'schema',
                'table', wal ->> 'table',
                'type', action
            ),
            is_rls_enabled,
            (select array_agg(s.subscription_id) from unnest(subscriptions) as s where claims_role = working_role),
            array['Error 401: Unauthorized']
        )::realtime.wal_rls;

    else
        output = jsonb_build_object(
            'schema', wal ->> 'schema',
            'table', wal ->> 'table',
            'type', action,
            'commit_timestamp', to_char(
                ((wal ->> 'timestamp')::timestamptz at time zone 'utc'),
                'YYYY-MM-DD"T"HH24:MI:SS.MS"Z"'
            ),
            'columns', (
                select
                    jsonb_agg(
                        jsonb_build_object(
                            'name', pa.attname,
                            'type', pt.typname
                        )
                        order by pa.attnum asc
                    )
                from
                    pg_attribute pa
                    join pg_type pt
                        on pa.atttypid = pt.oid
                where
                    attrelid = entity_
                    and attnum > 0
                    and pg_catalog.has_column_privilege(working_role, entity_, pa.attname, 'SELECT')
            )
        )
        -- Add "record" key for insert and update
        || case
            when action in ('INSERT', 'UPDATE') then
                jsonb_build_object(
                    'record',
                    (
                        select
                            jsonb_object_agg(
                                -- if unchanged toast, get column name and value from old record
                                coalesce((c).name, (oc).name),
                                case
                                    when (c).name is null then (oc).value
                                    else (c).value
                                end
                            )
                        from
                            unnest(columns) c
                            full outer join unnest(old_columns) oc
                                on (c).name = (oc).name
                        where
                            coalesce((c).is_selectable, (oc).is_selectable)
                            and ( not error_record_exceeds_max_size or (octet_length((c).value::text) <= 64))
                    )
                )
            else '{}'::jsonb
        end
        -- Add "old_record" key for update and delete
        || case
            when action = 'UPDATE' then
                jsonb_build_object(
                        'old_record',
                        (
                            select jsonb_object_agg((c).name, (c).value)
                            from unnest(old_columns) c
                            where
                                (c).is_selectable
                                and ( not error_record_exceeds_max_size or (octet_length((c).value::text) <= 64))
                        )
                    )
            when action = 'DELETE' then
                jsonb_build_object(
                    'old_record',
                    (
                        select jsonb_object_agg((c).name, (c).value)
                        from unnest(old_columns) c
                        where
                            (c).is_selectable
                            and ( not error_record_exceeds_max_size or (octet_length((c).value::text) <= 64))
                            and ( not is_rls_enabled or (c).is_pkey ) -- if RLS enabled, we can't secure deletes so filter to pkey
                    )
                )
            else '{}'::jsonb
        end;

        -- Create the prepared statement
        if is_rls_enabled and action <> 'DELETE' then
            if (select 1 from pg_prepared_statements where name = 'walrus_rls_stmt' limit 1) > 0 then
                deallocate walrus_rls_stmt;
            end if;
            execute realtime.build_prepared_statement_sql('walrus_rls_stmt', entity_, columns);
        end if;

        visible_to_subscription_ids = '{}';

        for subscription_id, claims in (
                select
                    subs.subscription_id,
                    subs.claims
                from
                    unnest(subscriptions) subs
                where
                    subs.entity = entity_
                    and subs.claims_role = working_role
                    and (
                        realtime.is_visible_through_filters(columns, subs.filters)
                        or (
                          action = 'DELETE'
                          and realtime.is_visible_through_filters(old_columns, subs.filters)
                        )
                    )
        ) loop

            if not is_rls_enabled or action = 'DELETE' then
                visible_to_subscription_ids = visible_to_subscription_ids || subscription_id;
            else
                -- Check if RLS allows the role to see the record
                perform
                    -- Trim leading and trailing quotes from working_role because set_config
                    -- doesn't recognize the role as valid if they are included
                    set_config('role', trim(both '"' from working_role::text), true),
                    set_config('request.jwt.claims', claims::text, true);

                execute 'execute walrus_rls_stmt' into subscription_has_access;

                if subscription_has_access then
                    visible_to_subscription_ids = visible_to_subscription_ids || subscription_id;
                end if;
            end if;
        end loop;

        perform set_config('role', null, true);

        return next (
            output,
            is_rls_enabled,
            visible_to_subscription_ids,
            case
                when error_record_exceeds_max_size then array['Error 413: Payload Too Large']
                else '{}'
            end
        )::realtime.wal_rls;

    end if;
end loop;

perform set_config('role', null, true);
end;
$$;


ALTER FUNCTION realtime.apply_rls(wal jsonb, max_record_bytes integer) OWNER TO supabase_admin;

--
-- Name: broadcast_changes(text, text, text, text, text, record, record, text); Type: FUNCTION; Schema: realtime; Owner: supabase_admin
--

CREATE FUNCTION realtime.broadcast_changes(topic_name text, event_name text, operation text, table_name text, table_schema text, new record, old record, level text DEFAULT 'ROW'::text) RETURNS void
    LANGUAGE plpgsql
    AS $$
DECLARE
    -- Declare a variable to hold the JSONB representation of the row
    row_data jsonb := '{}'::jsonb;
BEGIN
    IF level = 'STATEMENT' THEN
        RAISE EXCEPTION 'function can only be triggered for each row, not for each statement';
    END IF;
    -- Check the operation type and handle accordingly
    IF operation = 'INSERT' OR operation = 'UPDATE' OR operation = 'DELETE' THEN
        row_data := jsonb_build_object('old_record', OLD, 'record', NEW, 'operation', operation, 'table', table_name, 'schema', table_schema);
        PERFORM realtime.send (row_data, event_name, topic_name);
    ELSE
        RAISE EXCEPTION 'Unexpected operation type: %', operation;
    END IF;
EXCEPTION
    WHEN OTHERS THEN
        RAISE EXCEPTION 'Failed to process the row: %', SQLERRM;
END;

$$;


ALTER FUNCTION realtime.broadcast_changes(topic_name text, event_name text, operation text, table_name text, table_schema text, new record, old record, level text) OWNER TO supabase_admin;

--
-- Name: build_prepared_statement_sql(text, regclass, realtime.wal_column[]); Type: FUNCTION; Schema: realtime; Owner: supabase_admin
--

CREATE FUNCTION realtime.build_prepared_statement_sql(prepared_statement_name text, entity regclass, columns realtime.wal_column[]) RETURNS text
    LANGUAGE sql
    AS $$
      /*
      Builds a sql string that, if executed, creates a prepared statement to
      tests retrive a row from *entity* by its primary key columns.
      Example
          select realtime.build_prepared_statement_sql('public.notes', '{"id"}'::text[], '{"bigint"}'::text[])
      */
          select
      'prepare ' || prepared_statement_name || ' as
          select
              exists(
                  select
                      1
                  from
                      ' || entity || '
                  where
                      ' || string_agg(quote_ident(pkc.name) || '=' || quote_nullable(pkc.value #>> '{}') , ' and ') || '
              )'
          from
              unnest(columns) pkc
          where
              pkc.is_pkey
          group by
              entity
      $$;


ALTER FUNCTION realtime.build_prepared_statement_sql(prepared_statement_name text, entity regclass, columns realtime.wal_column[]) OWNER TO supabase_admin;

--
-- Name: cast(text, regtype); Type: FUNCTION; Schema: realtime; Owner: supabase_admin
--

CREATE FUNCTION realtime."cast"(val text, type_ regtype) RETURNS jsonb
    LANGUAGE plpgsql IMMUTABLE
    AS $$
    declare
      res jsonb;
    begin
      execute format('select to_jsonb(%L::'|| type_::text || ')', val)  into res;
      return res;
    end
    $$;


ALTER FUNCTION realtime."cast"(val text, type_ regtype) OWNER TO supabase_admin;

--
-- Name: check_equality_op(realtime.equality_op, regtype, text, text); Type: FUNCTION; Schema: realtime; Owner: supabase_admin
--

CREATE FUNCTION realtime.check_equality_op(op realtime.equality_op, type_ regtype, val_1 text, val_2 text) RETURNS boolean
    LANGUAGE plpgsql IMMUTABLE
    AS $$
      /*
      Casts *val_1* and *val_2* as type *type_* and check the *op* condition for truthiness
      */
      declare
          op_symbol text = (
              case
                  when op = 'eq' then '='
                  when op = 'neq' then '!='
                  when op = 'lt' then '<'
                  when op = 'lte' then '<='
                  when op = 'gt' then '>'
                  when op = 'gte' then '>='
                  when op = 'in' then '= any'
                  else 'UNKNOWN OP'
              end
          );
          res boolean;
      begin
          execute format(
              'select %L::'|| type_::text || ' ' || op_symbol
              || ' ( %L::'
              || (
                  case
                      when op = 'in' then type_::text || '[]'
                      else type_::text end
              )
              || ')', val_1, val_2) into res;
          return res;
      end;
      $$;


ALTER FUNCTION realtime.check_equality_op(op realtime.equality_op, type_ regtype, val_1 text, val_2 text) OWNER TO supabase_admin;

--
-- Name: is_visible_through_filters(realtime.wal_column[], realtime.user_defined_filter[]); Type: FUNCTION; Schema: realtime; Owner: supabase_admin
--

CREATE FUNCTION realtime.is_visible_through_filters(columns realtime.wal_column[], filters realtime.user_defined_filter[]) RETURNS boolean
    LANGUAGE sql IMMUTABLE
    AS $_$
    /*
    Should the record be visible (true) or filtered out (false) after *filters* are applied
    */
        select
            -- Default to allowed when no filters present
            $2 is null -- no filters. this should not happen because subscriptions has a default
            or array_length($2, 1) is null -- array length of an empty array is null
            or bool_and(
                coalesce(
                    realtime.check_equality_op(
                        op:=f.op,
                        type_:=coalesce(
                            col.type_oid::regtype, -- null when wal2json version <= 2.4
                            col.type_name::regtype
                        ),
                        -- cast jsonb to text
                        val_1:=col.value #>> '{}',
                        val_2:=f.value
                    ),
                    false -- if null, filter does not match
                )
            )
        from
            unnest(filters) f
            join unnest(columns) col
                on f.column_name = col.name;
    $_$;


ALTER FUNCTION realtime.is_visible_through_filters(columns realtime.wal_column[], filters realtime.user_defined_filter[]) OWNER TO supabase_admin;

--
-- Name: list_changes(name, name, integer, integer); Type: FUNCTION; Schema: realtime; Owner: supabase_admin
--

CREATE FUNCTION realtime.list_changes(publication name, slot_name name, max_changes integer, max_record_bytes integer) RETURNS SETOF realtime.wal_rls
    LANGUAGE sql
    SET log_min_messages TO 'fatal'
    AS $$
      with pub as (
        select
          concat_ws(
            ',',
            case when bool_or(pubinsert) then 'insert' else null end,
            case when bool_or(pubupdate) then 'update' else null end,
            case when bool_or(pubdelete) then 'delete' else null end
          ) as w2j_actions,
          coalesce(
            string_agg(
              realtime.quote_wal2json(format('%I.%I', schemaname, tablename)::regclass),
              ','
            ) filter (where ppt.tablename is not null and ppt.tablename not like '% %'),
            ''
          ) w2j_add_tables
        from
          pg_publication pp
          left join pg_publication_tables ppt
            on pp.pubname = ppt.pubname
        where
          pp.pubname = publication
        group by
          pp.pubname
        limit 1
      ),
      w2j as (
        select
          x.*, pub.w2j_add_tables
        from
          pub,
          pg_logical_slot_get_changes(
            slot_name, null, max_changes,
            'include-pk', 'true',
            'include-transaction', 'false',
            'include-timestamp', 'true',
            'include-type-oids', 'true',
            'format-version', '2',
            'actions', pub.w2j_actions,
            'add-tables', pub.w2j_add_tables
          ) x
      )
      select
        xyz.wal,
        xyz.is_rls_enabled,
        xyz.subscription_ids,
        xyz.errors
      from
        w2j,
        realtime.apply_rls(
          wal := w2j.data::jsonb,
          max_record_bytes := max_record_bytes
        ) xyz(wal, is_rls_enabled, subscription_ids, errors)
      where
        w2j.w2j_add_tables <> ''
        and xyz.subscription_ids[1] is not null
    $$;


ALTER FUNCTION realtime.list_changes(publication name, slot_name name, max_changes integer, max_record_bytes integer) OWNER TO supabase_admin;

--
-- Name: quote_wal2json(regclass); Type: FUNCTION; Schema: realtime; Owner: supabase_admin
--

CREATE FUNCTION realtime.quote_wal2json(entity regclass) RETURNS text
    LANGUAGE sql IMMUTABLE STRICT
    AS $$
      select
        (
          select string_agg('' || ch,'')
          from unnest(string_to_array(nsp.nspname::text, null)) with ordinality x(ch, idx)
          where
            not (x.idx = 1 and x.ch = '"')
            and not (
              x.idx = array_length(string_to_array(nsp.nspname::text, null), 1)
              and x.ch = '"'
            )
        )
        || '.'
        || (
          select string_agg('' || ch,'')
          from unnest(string_to_array(pc.relname::text, null)) with ordinality x(ch, idx)
          where
            not (x.idx = 1 and x.ch = '"')
            and not (
              x.idx = array_length(string_to_array(nsp.nspname::text, null), 1)
              and x.ch = '"'
            )
          )
      from
        pg_class pc
        join pg_namespace nsp
          on pc.relnamespace = nsp.oid
      where
        pc.oid = entity
    $$;


ALTER FUNCTION realtime.quote_wal2json(entity regclass) OWNER TO supabase_admin;

--
-- Name: send(jsonb, text, text, boolean); Type: FUNCTION; Schema: realtime; Owner: supabase_admin
--

CREATE FUNCTION realtime.send(payload jsonb, event text, topic text, private boolean DEFAULT true) RETURNS void
    LANGUAGE plpgsql
    AS $$
DECLARE
  partition_name text;
BEGIN
  partition_name := 'messages_' || to_char(NOW(), 'YYYY_MM_DD');

  IF NOT EXISTS (
    SELECT 1
    FROM pg_class c
    JOIN pg_namespace n ON n.oid = c.relnamespace
    WHERE n.nspname = 'realtime'
    AND c.relname = partition_name
  ) THEN
    EXECUTE format(
      'CREATE TABLE realtime.%I PARTITION OF realtime.messages FOR VALUES FROM (%L) TO (%L)',
      partition_name,
      NOW(),
      (NOW() + interval '1 day')::timestamp
    );
  END IF;

  INSERT INTO realtime.messages (payload, event, topic, private, extension)
  VALUES (payload, event, topic, private, 'broadcast');
END;
$$;


ALTER FUNCTION realtime.send(payload jsonb, event text, topic text, private boolean) OWNER TO supabase_admin;

--
-- Name: subscription_check_filters(); Type: FUNCTION; Schema: realtime; Owner: supabase_admin
--

CREATE FUNCTION realtime.subscription_check_filters() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
    /*
    Validates that the user defined filters for a subscription:
    - refer to valid columns that the claimed role may access
    - values are coercable to the correct column type
    */
    declare
        col_names text[] = coalesce(
                array_agg(c.column_name order by c.ordinal_position),
                '{}'::text[]
            )
            from
                information_schema.columns c
            where
                format('%I.%I', c.table_schema, c.table_name)::regclass = new.entity
                and pg_catalog.has_column_privilege(
                    (new.claims ->> 'role'),
                    format('%I.%I', c.table_schema, c.table_name)::regclass,
                    c.column_name,
                    'SELECT'
                );
        filter realtime.user_defined_filter;
        col_type regtype;

        in_val jsonb;
    begin
        for filter in select * from unnest(new.filters) loop
            -- Filtered column is valid
            if not filter.column_name = any(col_names) then
                raise exception 'invalid column for filter %', filter.column_name;
            end if;

            -- Type is sanitized and safe for string interpolation
            col_type = (
                select atttypid::regtype
                from pg_catalog.pg_attribute
                where attrelid = new.entity
                      and attname = filter.column_name
            );
            if col_type is null then
                raise exception 'failed to lookup type for column %', filter.column_name;
            end if;

            -- Set maximum number of entries for in filter
            if filter.op = 'in'::realtime.equality_op then
                in_val = realtime.cast(filter.value, (col_type::text || '[]')::regtype);
                if coalesce(jsonb_array_length(in_val), 0) > 100 then
                    raise exception 'too many values for `in` filter. Maximum 100';
                end if;
            else
                -- raises an exception if value is not coercable to type
                perform realtime.cast(filter.value, col_type);
            end if;

        end loop;

        -- Apply consistent order to filters so the unique constraint on
        -- (subscription_id, entity, filters) can't be tricked by a different filter order
        new.filters = coalesce(
            array_agg(f order by f.column_name, f.op, f.value),
            '{}'
        ) from unnest(new.filters) f;

        return new;
    end;
    $$;


ALTER FUNCTION realtime.subscription_check_filters() OWNER TO supabase_admin;

--
-- Name: to_regrole(text); Type: FUNCTION; Schema: realtime; Owner: supabase_admin
--

CREATE FUNCTION realtime.to_regrole(role_name text) RETURNS regrole
    LANGUAGE sql IMMUTABLE
    AS $$ select role_name::regrole $$;


ALTER FUNCTION realtime.to_regrole(role_name text) OWNER TO supabase_admin;

--
-- Name: topic(); Type: FUNCTION; Schema: realtime; Owner: supabase_realtime_admin
--

CREATE FUNCTION realtime.topic() RETURNS text
    LANGUAGE sql STABLE
    AS $$
select nullif(current_setting('realtime.topic', true), '')::text;
$$;


ALTER FUNCTION realtime.topic() OWNER TO supabase_realtime_admin;

--
-- Name: can_insert_object(text, text, uuid, jsonb); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.can_insert_object(bucketid text, name text, owner uuid, metadata jsonb) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
  INSERT INTO "storage"."objects" ("bucket_id", "name", "owner", "metadata") VALUES (bucketid, name, owner, metadata);
  -- hack to rollback the successful insert
  RAISE sqlstate 'PT200' using
  message = 'ROLLBACK',
  detail = 'rollback successful insert';
END
$$;


ALTER FUNCTION storage.can_insert_object(bucketid text, name text, owner uuid, metadata jsonb) OWNER TO supabase_storage_admin;

--
-- Name: extension(text); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.extension(name text) RETURNS text
    LANGUAGE plpgsql
    AS $$
DECLARE
_parts text[];
_filename text;
BEGIN
	select string_to_array(name, '/') into _parts;
	select _parts[array_length(_parts,1)] into _filename;
	-- @todo return the last part instead of 2
	return reverse(split_part(reverse(_filename), '.', 1));
END
$$;


ALTER FUNCTION storage.extension(name text) OWNER TO supabase_storage_admin;

--
-- Name: filename(text); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.filename(name text) RETURNS text
    LANGUAGE plpgsql
    AS $$
DECLARE
_parts text[];
BEGIN
	select string_to_array(name, '/') into _parts;
	return _parts[array_length(_parts,1)];
END
$$;


ALTER FUNCTION storage.filename(name text) OWNER TO supabase_storage_admin;

--
-- Name: foldername(text); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.foldername(name text) RETURNS text[]
    LANGUAGE plpgsql
    AS $$
DECLARE
_parts text[];
BEGIN
	select string_to_array(name, '/') into _parts;
	return _parts[1:array_length(_parts,1)-1];
END
$$;


ALTER FUNCTION storage.foldername(name text) OWNER TO supabase_storage_admin;

--
-- Name: get_size_by_bucket(); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.get_size_by_bucket() RETURNS TABLE(size bigint, bucket_id text)
    LANGUAGE plpgsql
    AS $$
BEGIN
    return query
        select sum((metadata->>'size')::int) as size, obj.bucket_id
        from "storage".objects as obj
        group by obj.bucket_id;
END
$$;


ALTER FUNCTION storage.get_size_by_bucket() OWNER TO supabase_storage_admin;

--
-- Name: list_multipart_uploads_with_delimiter(text, text, text, integer, text, text); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.list_multipart_uploads_with_delimiter(bucket_id text, prefix_param text, delimiter_param text, max_keys integer DEFAULT 100, next_key_token text DEFAULT ''::text, next_upload_token text DEFAULT ''::text) RETURNS TABLE(key text, id text, created_at timestamp with time zone)
    LANGUAGE plpgsql
    AS $_$
BEGIN
    RETURN QUERY EXECUTE
        'SELECT DISTINCT ON(key COLLATE "C") * from (
            SELECT
                CASE
                    WHEN position($2 IN substring(key from length($1) + 1)) > 0 THEN
                        substring(key from 1 for length($1) + position($2 IN substring(key from length($1) + 1)))
                    ELSE
                        key
                END AS key, id, created_at
            FROM
                storage.s3_multipart_uploads
            WHERE
                bucket_id = $5 AND
                key ILIKE $1 || ''%'' AND
                CASE
                    WHEN $4 != '''' AND $6 = '''' THEN
                        CASE
                            WHEN position($2 IN substring(key from length($1) + 1)) > 0 THEN
                                substring(key from 1 for length($1) + position($2 IN substring(key from length($1) + 1))) COLLATE "C" > $4
                            ELSE
                                key COLLATE "C" > $4
                            END
                    ELSE
                        true
                END AND
                CASE
                    WHEN $6 != '''' THEN
                        id COLLATE "C" > $6
                    ELSE
                        true
                    END
            ORDER BY
                key COLLATE "C" ASC, created_at ASC) as e order by key COLLATE "C" LIMIT $3'
        USING prefix_param, delimiter_param, max_keys, next_key_token, bucket_id, next_upload_token;
END;
$_$;


ALTER FUNCTION storage.list_multipart_uploads_with_delimiter(bucket_id text, prefix_param text, delimiter_param text, max_keys integer, next_key_token text, next_upload_token text) OWNER TO supabase_storage_admin;

--
-- Name: list_objects_with_delimiter(text, text, text, integer, text, text); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.list_objects_with_delimiter(bucket_id text, prefix_param text, delimiter_param text, max_keys integer DEFAULT 100, start_after text DEFAULT ''::text, next_token text DEFAULT ''::text) RETURNS TABLE(name text, id uuid, metadata jsonb, updated_at timestamp with time zone)
    LANGUAGE plpgsql
    AS $_$
BEGIN
    RETURN QUERY EXECUTE
        'SELECT DISTINCT ON(name COLLATE "C") * from (
            SELECT
                CASE
                    WHEN position($2 IN substring(name from length($1) + 1)) > 0 THEN
                        substring(name from 1 for length($1) + position($2 IN substring(name from length($1) + 1)))
                    ELSE
                        name
                END AS name, id, metadata, updated_at
            FROM
                storage.objects
            WHERE
                bucket_id = $5 AND
                name ILIKE $1 || ''%'' AND
                CASE
                    WHEN $6 != '''' THEN
                    name COLLATE "C" > $6
                ELSE true END
                AND CASE
                    WHEN $4 != '''' THEN
                        CASE
                            WHEN position($2 IN substring(name from length($1) + 1)) > 0 THEN
                                substring(name from 1 for length($1) + position($2 IN substring(name from length($1) + 1))) COLLATE "C" > $4
                            ELSE
                                name COLLATE "C" > $4
                            END
                    ELSE
                        true
                END
            ORDER BY
                name COLLATE "C" ASC) as e order by name COLLATE "C" LIMIT $3'
        USING prefix_param, delimiter_param, max_keys, next_token, bucket_id, start_after;
END;
$_$;


ALTER FUNCTION storage.list_objects_with_delimiter(bucket_id text, prefix_param text, delimiter_param text, max_keys integer, start_after text, next_token text) OWNER TO supabase_storage_admin;

--
-- Name: operation(); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.operation() RETURNS text
    LANGUAGE plpgsql STABLE
    AS $$
BEGIN
    RETURN current_setting('storage.operation', true);
END;
$$;


ALTER FUNCTION storage.operation() OWNER TO supabase_storage_admin;

--
-- Name: search(text, text, integer, integer, integer, text, text, text); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.search(prefix text, bucketname text, limits integer DEFAULT 100, levels integer DEFAULT 1, offsets integer DEFAULT 0, search text DEFAULT ''::text, sortcolumn text DEFAULT 'name'::text, sortorder text DEFAULT 'asc'::text) RETURNS TABLE(name text, id uuid, updated_at timestamp with time zone, created_at timestamp with time zone, last_accessed_at timestamp with time zone, metadata jsonb)
    LANGUAGE plpgsql STABLE
    AS $_$
declare
  v_order_by text;
  v_sort_order text;
begin
  case
    when sortcolumn = 'name' then
      v_order_by = 'name';
    when sortcolumn = 'updated_at' then
      v_order_by = 'updated_at';
    when sortcolumn = 'created_at' then
      v_order_by = 'created_at';
    when sortcolumn = 'last_accessed_at' then
      v_order_by = 'last_accessed_at';
    else
      v_order_by = 'name';
  end case;

  case
    when sortorder = 'asc' then
      v_sort_order = 'asc';
    when sortorder = 'desc' then
      v_sort_order = 'desc';
    else
      v_sort_order = 'asc';
  end case;

  v_order_by = v_order_by || ' ' || v_sort_order;

  return query execute
    'with folders as (
       select path_tokens[$1] as folder
       from storage.objects
         where objects.name ilike $2 || $3 || ''%''
           and bucket_id = $4
           and array_length(objects.path_tokens, 1) <> $1
       group by folder
       order by folder ' || v_sort_order || '
     )
     (select folder as "name",
            null as id,
            null as updated_at,
            null as created_at,
            null as last_accessed_at,
            null as metadata from folders)
     union all
     (select path_tokens[$1] as "name",
            id,
            updated_at,
            created_at,
            last_accessed_at,
            metadata
     from storage.objects
     where objects.name ilike $2 || $3 || ''%''
       and bucket_id = $4
       and array_length(objects.path_tokens, 1) = $1
     order by ' || v_order_by || ')
     limit $5
     offset $6' using levels, prefix, search, bucketname, limits, offsets;
end;
$_$;


ALTER FUNCTION storage.search(prefix text, bucketname text, limits integer, levels integer, offsets integer, search text, sortcolumn text, sortorder text) OWNER TO supabase_storage_admin;

--
-- Name: update_updated_at_column(); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.update_updated_at_column() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    NEW.updated_at = now();
    RETURN NEW; 
END;
$$;


ALTER FUNCTION storage.update_updated_at_column() OWNER TO supabase_storage_admin;

--
-- Name: http_request(); Type: FUNCTION; Schema: supabase_functions; Owner: supabase_functions_admin
--

CREATE FUNCTION supabase_functions.http_request() RETURNS trigger
    LANGUAGE plpgsql SECURITY DEFINER
    SET search_path TO 'supabase_functions'
    AS $$
  DECLARE
    request_id bigint;
    payload jsonb;
    url text := TG_ARGV[0]::text;
    method text := TG_ARGV[1]::text;
    headers jsonb DEFAULT '{}'::jsonb;
    params jsonb DEFAULT '{}'::jsonb;
    timeout_ms integer DEFAULT 1000;
  BEGIN
    IF url IS NULL OR url = 'null' THEN
      RAISE EXCEPTION 'url argument is missing';
    END IF;

    IF method IS NULL OR method = 'null' THEN
      RAISE EXCEPTION 'method argument is missing';
    END IF;

    IF TG_ARGV[2] IS NULL OR TG_ARGV[2] = 'null' THEN
      headers = '{"Content-Type": "application/json"}'::jsonb;
    ELSE
      headers = TG_ARGV[2]::jsonb;
    END IF;

    IF TG_ARGV[3] IS NULL OR TG_ARGV[3] = 'null' THEN
      params = '{}'::jsonb;
    ELSE
      params = TG_ARGV[3]::jsonb;
    END IF;

    IF TG_ARGV[4] IS NULL OR TG_ARGV[4] = 'null' THEN
      timeout_ms = 1000;
    ELSE
      timeout_ms = TG_ARGV[4]::integer;
    END IF;

    CASE
      WHEN method = 'GET' THEN
        SELECT http_get INTO request_id FROM net.http_get(
          url,
          params,
          headers,
          timeout_ms
        );
      WHEN method = 'POST' THEN
        payload = jsonb_build_object(
          'old_record', OLD,
          'record', NEW,
          'type', TG_OP,
          'table', TG_TABLE_NAME,
          'schema', TG_TABLE_SCHEMA
        );

        SELECT http_post INTO request_id FROM net.http_post(
          url,
          payload,
          params,
          headers,
          timeout_ms
        );
      ELSE
        RAISE EXCEPTION 'method argument % is invalid', method;
    END CASE;

    INSERT INTO supabase_functions.hooks
      (hook_table_id, hook_name, request_id)
    VALUES
      (TG_RELID, TG_NAME, request_id);

    RETURN NEW;
  END
$$;


ALTER FUNCTION supabase_functions.http_request() OWNER TO supabase_functions_admin;

--
-- Name: secrets_encrypt_secret_secret(); Type: FUNCTION; Schema: vault; Owner: supabase_admin
--

CREATE FUNCTION vault.secrets_encrypt_secret_secret() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
		BEGIN
		        new.secret = CASE WHEN new.secret IS NULL THEN NULL ELSE
			CASE WHEN new.key_id IS NULL THEN NULL ELSE pg_catalog.encode(
			  pgsodium.crypto_aead_det_encrypt(
				pg_catalog.convert_to(new.secret, 'utf8'),
				pg_catalog.convert_to((new.id::text || new.description::text || new.created_at::text || new.updated_at::text)::text, 'utf8'),
				new.key_id::uuid,
				new.nonce
			  ),
				'base64') END END;
		RETURN new;
		END;
		$$;


ALTER FUNCTION vault.secrets_encrypt_secret_secret() OWNER TO supabase_admin;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: extensions; Type: TABLE; Schema: _realtime; Owner: supabase_admin
--

CREATE TABLE _realtime.extensions (
    id uuid NOT NULL,
    type text,
    settings jsonb,
    tenant_external_id text,
    inserted_at timestamp(0) without time zone NOT NULL,
    updated_at timestamp(0) without time zone NOT NULL
);


ALTER TABLE _realtime.extensions OWNER TO supabase_admin;

--
-- Name: schema_migrations; Type: TABLE; Schema: _realtime; Owner: supabase_admin
--

CREATE TABLE _realtime.schema_migrations (
    version bigint NOT NULL,
    inserted_at timestamp(0) without time zone
);


ALTER TABLE _realtime.schema_migrations OWNER TO supabase_admin;

--
-- Name: tenants; Type: TABLE; Schema: _realtime; Owner: supabase_admin
--

CREATE TABLE _realtime.tenants (
    id uuid NOT NULL,
    name text,
    external_id text,
    jwt_secret text,
    max_concurrent_users integer DEFAULT 200 NOT NULL,
    inserted_at timestamp(0) without time zone NOT NULL,
    updated_at timestamp(0) without time zone NOT NULL,
    max_events_per_second integer DEFAULT 100 NOT NULL,
    postgres_cdc_default text DEFAULT 'postgres_cdc_rls'::text,
    max_bytes_per_second integer DEFAULT 100000 NOT NULL,
    max_channels_per_client integer DEFAULT 100 NOT NULL,
    max_joins_per_second integer DEFAULT 500 NOT NULL,
    suspend boolean DEFAULT false,
    jwt_jwks jsonb,
    notify_private_alpha boolean DEFAULT false,
    private_only boolean DEFAULT false NOT NULL
);


ALTER TABLE _realtime.tenants OWNER TO supabase_admin;

--
-- Name: audit_log_entries; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.audit_log_entries (
    instance_id uuid,
    id uuid NOT NULL,
    payload json,
    created_at timestamp with time zone,
    ip_address character varying(64) DEFAULT ''::character varying NOT NULL
);


ALTER TABLE auth.audit_log_entries OWNER TO supabase_auth_admin;

--
-- Name: TABLE audit_log_entries; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.audit_log_entries IS 'Auth: Audit trail for user actions.';


--
-- Name: flow_state; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.flow_state (
    id uuid NOT NULL,
    user_id uuid,
    auth_code text NOT NULL,
    code_challenge_method auth.code_challenge_method NOT NULL,
    code_challenge text NOT NULL,
    provider_type text NOT NULL,
    provider_access_token text,
    provider_refresh_token text,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    authentication_method text NOT NULL,
    auth_code_issued_at timestamp with time zone
);


ALTER TABLE auth.flow_state OWNER TO supabase_auth_admin;

--
-- Name: TABLE flow_state; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.flow_state IS 'stores metadata for pkce logins';


--
-- Name: identities; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.identities (
    provider_id text NOT NULL,
    user_id uuid NOT NULL,
    identity_data jsonb NOT NULL,
    provider text NOT NULL,
    last_sign_in_at timestamp with time zone,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    email text GENERATED ALWAYS AS (lower((identity_data ->> 'email'::text))) STORED,
    id uuid DEFAULT gen_random_uuid() NOT NULL
);


ALTER TABLE auth.identities OWNER TO supabase_auth_admin;

--
-- Name: TABLE identities; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.identities IS 'Auth: Stores identities associated to a user.';


--
-- Name: COLUMN identities.email; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON COLUMN auth.identities.email IS 'Auth: Email is a generated column that references the optional email property in the identity_data';


--
-- Name: instances; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.instances (
    id uuid NOT NULL,
    uuid uuid,
    raw_base_config text,
    created_at timestamp with time zone,
    updated_at timestamp with time zone
);


ALTER TABLE auth.instances OWNER TO supabase_auth_admin;

--
-- Name: TABLE instances; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.instances IS 'Auth: Manages users across multiple sites.';


--
-- Name: mfa_amr_claims; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.mfa_amr_claims (
    session_id uuid NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    authentication_method text NOT NULL,
    id uuid NOT NULL
);


ALTER TABLE auth.mfa_amr_claims OWNER TO supabase_auth_admin;

--
-- Name: TABLE mfa_amr_claims; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.mfa_amr_claims IS 'auth: stores authenticator method reference claims for multi factor authentication';


--
-- Name: mfa_challenges; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.mfa_challenges (
    id uuid NOT NULL,
    factor_id uuid NOT NULL,
    created_at timestamp with time zone NOT NULL,
    verified_at timestamp with time zone,
    ip_address inet NOT NULL,
    otp_code text,
    web_authn_session_data jsonb
);


ALTER TABLE auth.mfa_challenges OWNER TO supabase_auth_admin;

--
-- Name: TABLE mfa_challenges; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.mfa_challenges IS 'auth: stores metadata about challenge requests made';


--
-- Name: mfa_factors; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.mfa_factors (
    id uuid NOT NULL,
    user_id uuid NOT NULL,
    friendly_name text,
    factor_type auth.factor_type NOT NULL,
    status auth.factor_status NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    secret text,
    phone text,
    last_challenged_at timestamp with time zone,
    web_authn_credential jsonb,
    web_authn_aaguid uuid
);


ALTER TABLE auth.mfa_factors OWNER TO supabase_auth_admin;

--
-- Name: TABLE mfa_factors; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.mfa_factors IS 'auth: stores metadata about factors';


--
-- Name: one_time_tokens; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.one_time_tokens (
    id uuid NOT NULL,
    user_id uuid NOT NULL,
    token_type auth.one_time_token_type NOT NULL,
    token_hash text NOT NULL,
    relates_to text NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    CONSTRAINT one_time_tokens_token_hash_check CHECK ((char_length(token_hash) > 0))
);


ALTER TABLE auth.one_time_tokens OWNER TO supabase_auth_admin;

--
-- Name: refresh_tokens; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.refresh_tokens (
    instance_id uuid,
    id bigint NOT NULL,
    token character varying(255),
    user_id character varying(255),
    revoked boolean,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    parent character varying(255),
    session_id uuid
);


ALTER TABLE auth.refresh_tokens OWNER TO supabase_auth_admin;

--
-- Name: TABLE refresh_tokens; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.refresh_tokens IS 'Auth: Store of tokens used to refresh JWT tokens once they expire.';


--
-- Name: refresh_tokens_id_seq; Type: SEQUENCE; Schema: auth; Owner: supabase_auth_admin
--

CREATE SEQUENCE auth.refresh_tokens_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE auth.refresh_tokens_id_seq OWNER TO supabase_auth_admin;

--
-- Name: refresh_tokens_id_seq; Type: SEQUENCE OWNED BY; Schema: auth; Owner: supabase_auth_admin
--

ALTER SEQUENCE auth.refresh_tokens_id_seq OWNED BY auth.refresh_tokens.id;


--
-- Name: saml_providers; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.saml_providers (
    id uuid NOT NULL,
    sso_provider_id uuid NOT NULL,
    entity_id text NOT NULL,
    metadata_xml text NOT NULL,
    metadata_url text,
    attribute_mapping jsonb,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    name_id_format text,
    CONSTRAINT "entity_id not empty" CHECK ((char_length(entity_id) > 0)),
    CONSTRAINT "metadata_url not empty" CHECK (((metadata_url = NULL::text) OR (char_length(metadata_url) > 0))),
    CONSTRAINT "metadata_xml not empty" CHECK ((char_length(metadata_xml) > 0))
);


ALTER TABLE auth.saml_providers OWNER TO supabase_auth_admin;

--
-- Name: TABLE saml_providers; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.saml_providers IS 'Auth: Manages SAML Identity Provider connections.';


--
-- Name: saml_relay_states; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.saml_relay_states (
    id uuid NOT NULL,
    sso_provider_id uuid NOT NULL,
    request_id text NOT NULL,
    for_email text,
    redirect_to text,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    flow_state_id uuid,
    CONSTRAINT "request_id not empty" CHECK ((char_length(request_id) > 0))
);


ALTER TABLE auth.saml_relay_states OWNER TO supabase_auth_admin;

--
-- Name: TABLE saml_relay_states; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.saml_relay_states IS 'Auth: Contains SAML Relay State information for each Service Provider initiated login.';


--
-- Name: schema_migrations; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.schema_migrations (
    version character varying(255) NOT NULL
);


ALTER TABLE auth.schema_migrations OWNER TO supabase_auth_admin;

--
-- Name: TABLE schema_migrations; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.schema_migrations IS 'Auth: Manages updates to the auth system.';


--
-- Name: sessions; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.sessions (
    id uuid NOT NULL,
    user_id uuid NOT NULL,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    factor_id uuid,
    aal auth.aal_level,
    not_after timestamp with time zone,
    refreshed_at timestamp without time zone,
    user_agent text,
    ip inet,
    tag text
);


ALTER TABLE auth.sessions OWNER TO supabase_auth_admin;

--
-- Name: TABLE sessions; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.sessions IS 'Auth: Stores session data associated to a user.';


--
-- Name: COLUMN sessions.not_after; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON COLUMN auth.sessions.not_after IS 'Auth: Not after is a nullable column that contains a timestamp after which the session should be regarded as expired.';


--
-- Name: sso_domains; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.sso_domains (
    id uuid NOT NULL,
    sso_provider_id uuid NOT NULL,
    domain text NOT NULL,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    CONSTRAINT "domain not empty" CHECK ((char_length(domain) > 0))
);


ALTER TABLE auth.sso_domains OWNER TO supabase_auth_admin;

--
-- Name: TABLE sso_domains; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.sso_domains IS 'Auth: Manages SSO email address domain mapping to an SSO Identity Provider.';


--
-- Name: sso_providers; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.sso_providers (
    id uuid NOT NULL,
    resource_id text,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    CONSTRAINT "resource_id not empty" CHECK (((resource_id = NULL::text) OR (char_length(resource_id) > 0)))
);


ALTER TABLE auth.sso_providers OWNER TO supabase_auth_admin;

--
-- Name: TABLE sso_providers; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.sso_providers IS 'Auth: Manages SSO identity provider information; see saml_providers for SAML.';


--
-- Name: COLUMN sso_providers.resource_id; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON COLUMN auth.sso_providers.resource_id IS 'Auth: Uniquely identifies a SSO provider according to a user-chosen resource ID (case insensitive), useful in infrastructure as code.';


--
-- Name: users; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.users (
    instance_id uuid,
    id uuid NOT NULL,
    aud character varying(255),
    role character varying(255),
    email character varying(255),
    encrypted_password character varying(255),
    email_confirmed_at timestamp with time zone,
    invited_at timestamp with time zone,
    confirmation_token character varying(255),
    confirmation_sent_at timestamp with time zone,
    recovery_token character varying(255),
    recovery_sent_at timestamp with time zone,
    email_change_token_new character varying(255),
    email_change character varying(255),
    email_change_sent_at timestamp with time zone,
    last_sign_in_at timestamp with time zone,
    raw_app_meta_data jsonb,
    raw_user_meta_data jsonb,
    is_super_admin boolean,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    phone text DEFAULT NULL::character varying,
    phone_confirmed_at timestamp with time zone,
    phone_change text DEFAULT ''::character varying,
    phone_change_token character varying(255) DEFAULT ''::character varying,
    phone_change_sent_at timestamp with time zone,
    confirmed_at timestamp with time zone GENERATED ALWAYS AS (LEAST(email_confirmed_at, phone_confirmed_at)) STORED,
    email_change_token_current character varying(255) DEFAULT ''::character varying,
    email_change_confirm_status smallint DEFAULT 0,
    banned_until timestamp with time zone,
    reauthentication_token character varying(255) DEFAULT ''::character varying,
    reauthentication_sent_at timestamp with time zone,
    is_sso_user boolean DEFAULT false NOT NULL,
    deleted_at timestamp with time zone,
    is_anonymous boolean DEFAULT false NOT NULL,
    CONSTRAINT users_email_change_confirm_status_check CHECK (((email_change_confirm_status >= 0) AND (email_change_confirm_status <= 2)))
);


ALTER TABLE auth.users OWNER TO supabase_auth_admin;

--
-- Name: TABLE users; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.users IS 'Auth: Stores user login data within a secure schema.';


--
-- Name: COLUMN users.is_sso_user; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON COLUMN auth.users.is_sso_user IS 'Auth: Set this column to true when the account comes from SSO. These accounts can have duplicate emails.';


--
-- Name: doctor_clinics; Type: TABLE; Schema: public; Owner: supabase_admin
--

CREATE TABLE public.doctor_clinics (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    doctor_id uuid NOT NULL,
    clinic_name text NOT NULL,
    latitude numeric(9,6),
    longitude numeric(9,6),
    is_primary boolean DEFAULT false NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.doctor_clinics OWNER TO supabase_admin;

--
-- Name: TABLE doctor_clinics; Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON TABLE public.doctor_clinics IS 'Stores multiple clinic/chamber locations for a doctor, primarily for geotagging and naming.';


--
-- Name: COLUMN doctor_clinics.is_primary; Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON COLUMN public.doctor_clinics.is_primary IS 'Flag to identify the location that corresponds to the main address in the doctors table.';


--
-- Name: doctors; Type: TABLE; Schema: public; Owner: supabase_admin
--

CREATE TABLE public.doctors (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    full_name text NOT NULL,
    specialty text,
    clinic_address text,
    phone_number text,
    email text,
    date_of_birth date,
    anniversary_date date,
    tier character(1),
    latitude numeric(9,6),
    longitude numeric(9,6),
    is_active boolean DEFAULT true NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    created_by uuid,
    CONSTRAINT doctors_tier_check CHECK ((tier = ANY (ARRAY['A'::bpchar, 'B'::bpchar, 'C'::bpchar])))
);


ALTER TABLE public.doctors OWNER TO supabase_admin;

--
-- Name: mr_doctor_allotments; Type: TABLE; Schema: public; Owner: supabase_admin
--

CREATE TABLE public.mr_doctor_allotments (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    mr_user_id uuid NOT NULL,
    doctor_id uuid NOT NULL
);


ALTER TABLE public.mr_doctor_allotments OWNER TO supabase_admin;

--
-- Name: mr_sales_order_items; Type: TABLE; Schema: public; Owner: supabase_admin
--

CREATE TABLE public.mr_sales_order_items (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    order_id uuid NOT NULL,
    product_id uuid NOT NULL,
    batch_id uuid NOT NULL,
    quantity_strips_sold integer NOT NULL,
    price_per_strip numeric(10,2) NOT NULL,
    line_item_total numeric(10,2) GENERATED ALWAYS AS (((quantity_strips_sold)::numeric * price_per_strip)) STORED,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    CONSTRAINT mr_sales_order_items_price_per_strip_check CHECK ((price_per_strip >= (0)::numeric)),
    CONSTRAINT mr_sales_order_items_quantity_strips_sold_check CHECK ((quantity_strips_sold > 0))
);


ALTER TABLE public.mr_sales_order_items OWNER TO supabase_admin;

--
-- Name: mr_sales_orders; Type: TABLE; Schema: public; Owner: supabase_admin
--

CREATE TABLE public.mr_sales_orders (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    mr_user_id uuid NOT NULL,
    customer_name text NOT NULL,
    order_date timestamp with time zone DEFAULT now() NOT NULL,
    total_amount numeric(10,2) NOT NULL,
    payment_status public.mr_payment_status DEFAULT 'Pending'::public.mr_payment_status NOT NULL,
    notes text,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    CONSTRAINT mr_sales_orders_total_amount_check CHECK ((total_amount >= (0)::numeric))
);


ALTER TABLE public.mr_sales_orders OWNER TO supabase_admin;

--
-- Name: mr_sales_targets; Type: TABLE; Schema: public; Owner: supabase_admin
--

CREATE TABLE public.mr_sales_targets (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    mr_user_id uuid NOT NULL,
    period_type public.target_period_type NOT NULL,
    start_date date NOT NULL,
    end_date date NOT NULL,
    target_sales_amount numeric(12,2) NOT NULL,
    target_tier_bronze numeric(12,2),
    target_tier_gold numeric(12,2),
    product_specific_goals jsonb,
    target_collection_percentage numeric(5,2),
    is_locked boolean DEFAULT false NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    CONSTRAINT mr_sales_targets_target_collection_percentage_check CHECK (((target_collection_percentage > (0)::numeric) AND (target_collection_percentage <= (100)::numeric))),
    CONSTRAINT mr_sales_targets_target_sales_amount_check CHECK ((target_sales_amount > (0)::numeric))
);


ALTER TABLE public.mr_sales_targets OWNER TO supabase_admin;

--
-- Name: mr_stock_summary; Type: TABLE; Schema: public; Owner: supabase_admin
--

CREATE TABLE public.mr_stock_summary (
    mr_user_id uuid NOT NULL,
    product_id uuid NOT NULL,
    batch_id uuid NOT NULL,
    current_quantity_strips integer DEFAULT 0 NOT NULL,
    last_updated_at timestamp with time zone DEFAULT now() NOT NULL,
    price_per_strip numeric(10,2) DEFAULT 0.00,
    CONSTRAINT non_negative_quantity CHECK ((current_quantity_strips >= 0))
);


ALTER TABLE public.mr_stock_summary OWNER TO supabase_admin;

--
-- Name: COLUMN mr_stock_summary.price_per_strip; Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON COLUMN public.mr_stock_summary.price_per_strip IS 'Price per strip from the latest transaction for this product/batch combination';


--
-- Name: mr_visit_logs; Type: TABLE; Schema: public; Owner: supabase_admin
--

CREATE TABLE public.mr_visit_logs (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    mr_user_id uuid NOT NULL,
    doctor_id uuid NOT NULL,
    visit_date timestamp with time zone DEFAULT now() NOT NULL,
    products_detailed jsonb,
    feedback_received text,
    samples_provided jsonb,
    competitor_activity_notes text,
    prescription_potential_notes text,
    next_visit_date date,
    next_visit_objective text,
    linked_sale_order_id uuid,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    is_location_verified boolean,
    distance_from_clinic_meters numeric(10,2),
    clinic_id uuid
);


ALTER TABLE public.mr_visit_logs OWNER TO supabase_admin;

--
-- Name: COLUMN mr_visit_logs.is_location_verified; Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON COLUMN public.mr_visit_logs.is_location_verified IS 'Whether the visit was verified to be within the clinic verification radius';


--
-- Name: COLUMN mr_visit_logs.distance_from_clinic_meters; Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON COLUMN public.mr_visit_logs.distance_from_clinic_meters IS 'Distance in meters from the clinic when the visit was logged';


--
-- Name: COLUMN mr_visit_logs.clinic_id; Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON COLUMN public.mr_visit_logs.clinic_id IS 'The specific clinic where the visit took place. Can be NULL for virtual calls or if the visit was at the primary location before it was formally added to the doctor_clinics table.';


--
-- Name: packaging_templates; Type: TABLE; Schema: public; Owner: supabase_admin
--

CREATE TABLE public.packaging_templates (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    template_name text NOT NULL,
    unit_name text NOT NULL,
    conversion_factor_to_strips integer DEFAULT 1 NOT NULL,
    is_base_unit boolean DEFAULT false NOT NULL,
    order_in_hierarchy integer DEFAULT 1 NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    CONSTRAINT positive_conversion_factor CHECK ((conversion_factor_to_strips > 0)),
    CONSTRAINT positive_order CHECK ((order_in_hierarchy > 0))
);


ALTER TABLE public.packaging_templates OWNER TO supabase_admin;

--
-- Name: product_batches; Type: TABLE; Schema: public; Owner: supabase_admin
--

CREATE TABLE public.product_batches (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    product_id uuid NOT NULL,
    batch_number text NOT NULL,
    manufacturing_date date NOT NULL,
    expiry_date date NOT NULL,
    batch_cost_per_strip numeric(10,2),
    status text DEFAULT 'Active'::text NOT NULL,
    notes text,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    CONSTRAINT positive_batch_cost CHECK (((batch_cost_per_strip > (0)::numeric) OR (batch_cost_per_strip IS NULL))),
    CONSTRAINT valid_batch_status CHECK ((status = ANY (ARRAY['Active'::text, 'Expired'::text, 'Recalled'::text, 'Quarantined'::text])))
);


ALTER TABLE public.product_batches OWNER TO supabase_admin;

--
-- Name: product_categories; Type: TABLE; Schema: public; Owner: supabase_admin
--

CREATE TABLE public.product_categories (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    category_name text NOT NULL,
    description text,
    is_active boolean DEFAULT true NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.product_categories OWNER TO supabase_admin;

--
-- Name: product_formulations; Type: TABLE; Schema: public; Owner: supabase_admin
--

CREATE TABLE public.product_formulations (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    formulation_name text NOT NULL,
    is_active boolean DEFAULT true NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.product_formulations OWNER TO supabase_admin;

--
-- Name: product_packaging_units; Type: TABLE; Schema: public; Owner: supabase_admin
--

CREATE TABLE public.product_packaging_units (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    product_id uuid NOT NULL,
    unit_name text NOT NULL,
    conversion_factor_to_strips integer DEFAULT 1 NOT NULL,
    is_base_unit boolean DEFAULT false NOT NULL,
    order_in_hierarchy integer NOT NULL,
    default_purchase_unit boolean DEFAULT false NOT NULL,
    default_sales_unit_mr boolean DEFAULT false NOT NULL,
    default_sales_unit_direct boolean DEFAULT false NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    template_id uuid,
    CONSTRAINT positive_conversion_factor CHECK ((conversion_factor_to_strips > 0)),
    CONSTRAINT positive_order CHECK ((order_in_hierarchy > 0))
);


ALTER TABLE public.product_packaging_units OWNER TO supabase_admin;

--
-- Name: product_sub_categories; Type: TABLE; Schema: public; Owner: supabase_admin
--

CREATE TABLE public.product_sub_categories (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    sub_category_name text NOT NULL,
    category_id uuid NOT NULL,
    description text,
    is_active boolean DEFAULT true NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.product_sub_categories OWNER TO supabase_admin;

--
-- Name: products; Type: TABLE; Schema: public; Owner: supabase_admin
--

CREATE TABLE public.products (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    product_code text NOT NULL,
    product_name text NOT NULL,
    generic_name text NOT NULL,
    manufacturer text NOT NULL,
    category_id uuid NOT NULL,
    sub_category_id uuid,
    formulation_id uuid NOT NULL,
    unit_of_measure_smallest text DEFAULT 'Strip'::text NOT NULL,
    base_cost_per_strip numeric(10,2) NOT NULL,
    is_active boolean DEFAULT true NOT NULL,
    storage_conditions text,
    image_url text,
    min_stock_level_godown integer DEFAULT 0,
    min_stock_level_mr integer DEFAULT 0,
    lead_time_days integer DEFAULT 0,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    packaging_template text,
    CONSTRAINT products_base_cost_per_strip_check CHECK ((base_cost_per_strip >= (0)::numeric)),
    CONSTRAINT products_lead_time_days_check CHECK ((lead_time_days >= 0)),
    CONSTRAINT products_min_stock_level_godown_check CHECK ((min_stock_level_godown >= 0)),
    CONSTRAINT products_min_stock_level_mr_check CHECK ((min_stock_level_mr >= 0))
);


ALTER TABLE public.products OWNER TO supabase_admin;

--
-- Name: COLUMN products.packaging_template; Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON COLUMN public.products.packaging_template IS 'References the template_name from packaging_templates table. Used to group packaging units.';


--
-- Name: products_stock_status; Type: TABLE; Schema: public; Owner: supabase_admin
--

CREATE TABLE public.products_stock_status (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    product_id uuid NOT NULL,
    batch_id uuid NOT NULL,
    location_type text NOT NULL,
    location_id text NOT NULL,
    current_quantity_strips integer DEFAULT 0 NOT NULL,
    cost_per_strip numeric DEFAULT 0 NOT NULL,
    total_value numeric GENERATED ALWAYS AS (((current_quantity_strips)::numeric * cost_per_strip)) STORED,
    last_updated_at timestamp with time zone DEFAULT now() NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.products_stock_status OWNER TO supabase_admin;

--
-- Name: profiles; Type: TABLE; Schema: public; Owner: supabase_admin
--

CREATE TABLE public.profiles (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    user_id uuid NOT NULL,
    name text NOT NULL,
    email text NOT NULL,
    role public.user_role DEFAULT 'user'::public.user_role NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.profiles OWNER TO supabase_admin;

--
-- Name: stock_adjustments; Type: TABLE; Schema: public; Owner: supabase_admin
--

CREATE TABLE public.stock_adjustments (
    adjustment_id uuid DEFAULT gen_random_uuid() NOT NULL,
    adjustment_group_id uuid NOT NULL,
    product_id uuid NOT NULL,
    batch_id uuid NOT NULL,
    adjustment_type text NOT NULL,
    quantity_strips integer NOT NULL,
    location_type_source text,
    location_id_source text,
    location_type_destination text,
    location_id_destination text,
    adjustment_date timestamp with time zone DEFAULT now() NOT NULL,
    reference_document_id text,
    cost_per_strip numeric(10,2) NOT NULL,
    notes text,
    created_by uuid,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    CONSTRAINT positive_adjustment_cost CHECK ((cost_per_strip > (0)::numeric)),
    CONSTRAINT valid_adjustment_type CHECK ((adjustment_type = ANY (ARRAY['RETURN_TO_GODOWN'::text, 'RETURN_TO_MR'::text, 'ADJUST_DAMAGE_GODOWN'::text, 'ADJUST_LOSS_GODOWN'::text, 'ADJUST_DAMAGE_MR'::text, 'ADJUST_LOSS_MR'::text, 'ADJUST_EXPIRED_GODOWN'::text, 'ADJUST_EXPIRED_MR'::text, 'REPLACEMENT_FROM_GODOWN'::text, 'REPLACEMENT_FROM_MR'::text, 'OPENING_STOCK_GODOWN'::text, 'OPENING_STOCK_MR'::text])))
);


ALTER TABLE public.stock_adjustments OWNER TO supabase_admin;

--
-- Name: stock_purchases; Type: TABLE; Schema: public; Owner: supabase_admin
--

CREATE TABLE public.stock_purchases (
    purchase_id uuid DEFAULT gen_random_uuid() NOT NULL,
    purchase_group_id uuid NOT NULL,
    product_id uuid NOT NULL,
    batch_id uuid NOT NULL,
    quantity_strips integer NOT NULL,
    supplier_id text,
    purchase_date timestamp with time zone DEFAULT now() NOT NULL,
    reference_document_id text,
    cost_per_strip numeric(10,2) NOT NULL,
    notes text,
    created_by uuid,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    CONSTRAINT positive_purchase_cost CHECK ((cost_per_strip > (0)::numeric)),
    CONSTRAINT positive_purchase_quantity CHECK ((quantity_strips > 0))
);


ALTER TABLE public.stock_purchases OWNER TO supabase_admin;

--
-- Name: stock_sales; Type: TABLE; Schema: public; Owner: supabase_admin
--

CREATE TABLE public.stock_sales (
    sale_id uuid DEFAULT gen_random_uuid() NOT NULL,
    sale_group_id uuid NOT NULL,
    product_id uuid NOT NULL,
    batch_id uuid NOT NULL,
    transaction_type text NOT NULL,
    quantity_strips integer NOT NULL,
    location_type_source text NOT NULL,
    location_id_source text,
    location_type_destination text NOT NULL,
    location_id_destination text,
    sale_date timestamp with time zone DEFAULT now() NOT NULL,
    reference_document_id text,
    cost_per_strip numeric(10,2) NOT NULL,
    notes text,
    created_by uuid,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    CONSTRAINT positive_sale_cost CHECK ((cost_per_strip > (0)::numeric)),
    CONSTRAINT positive_sale_quantity CHECK ((quantity_strips > 0)),
    CONSTRAINT valid_sale_location_destination CHECK ((location_type_destination = ANY (ARRAY['MR'::text, 'CUSTOMER'::text]))),
    CONSTRAINT valid_sale_location_source CHECK ((location_type_source = ANY (ARRAY['GODOWN'::text, 'MR'::text]))),
    CONSTRAINT valid_sale_transaction_type CHECK ((transaction_type = ANY (ARRAY['DISPATCH_TO_MR'::text, 'SALE_DIRECT_GODOWN'::text, 'SALE_BY_MR'::text])))
);


ALTER TABLE public.stock_sales OWNER TO supabase_admin;

--
-- Name: stock_transactions; Type: TABLE; Schema: public; Owner: supabase_admin
--

CREATE TABLE public.stock_transactions (
    transaction_id uuid DEFAULT gen_random_uuid() NOT NULL,
    transaction_group_id uuid NOT NULL,
    product_id uuid NOT NULL,
    batch_id uuid NOT NULL,
    transaction_type text NOT NULL,
    quantity_strips integer NOT NULL,
    location_type_source text,
    location_id_source text,
    location_type_destination text,
    location_id_destination text,
    transaction_date timestamp with time zone DEFAULT now() NOT NULL,
    reference_document_type text,
    reference_document_id text,
    cost_per_strip_at_transaction numeric(10,2) NOT NULL,
    notes text,
    created_by uuid,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    CONSTRAINT positive_cost CHECK ((cost_per_strip_at_transaction > (0)::numeric)),
    CONSTRAINT valid_location_destination CHECK (((location_type_destination = ANY (ARRAY['SUPPLIER'::text, 'GODOWN'::text, 'MR'::text, 'CUSTOMER'::text, 'WASTAGE_BIN'::text])) OR (location_type_destination IS NULL))),
    CONSTRAINT valid_location_source CHECK (((location_type_source = ANY (ARRAY['SUPPLIER'::text, 'GODOWN'::text, 'MR'::text, 'CUSTOMER'::text])) OR (location_type_source IS NULL))),
    CONSTRAINT valid_transaction_type CHECK ((transaction_type = ANY (ARRAY['STOCK_IN_GODOWN'::text, 'DISPATCH_TO_MR'::text, 'SALE_DIRECT_GODOWN'::text, 'SALE_BY_MR'::text, 'RETURN_TO_GODOWN'::text, 'RETURN_TO_MR'::text, 'ADJUST_DAMAGE_GODOWN'::text, 'ADJUST_LOSS_GODOWN'::text, 'ADJUST_DAMAGE_MR'::text, 'ADJUST_LOSS_MR'::text, 'ADJUST_EXPIRED_GODOWN'::text, 'ADJUST_EXPIRED_MR'::text, 'REPLACEMENT_FROM_GODOWN'::text, 'REPLACEMENT_FROM_MR'::text, 'OPENING_STOCK_GODOWN'::text, 'OPENING_STOCK_MR'::text])))
);


ALTER TABLE public.stock_transactions OWNER TO supabase_admin;

--
-- Name: stock_transactions_view; Type: VIEW; Schema: public; Owner: supabase_admin
--

CREATE VIEW public.stock_transactions_view AS
 SELECT stock_purchases.purchase_id AS transaction_id,
    stock_purchases.purchase_group_id AS transaction_group_id,
    stock_purchases.product_id,
    stock_purchases.batch_id,
    'STOCK_IN_GODOWN'::text AS transaction_type,
    stock_purchases.quantity_strips,
    'SUPPLIER'::text AS location_type_source,
    stock_purchases.supplier_id AS location_id_source,
    'GODOWN'::text AS location_type_destination,
    NULL::text AS location_id_destination,
    stock_purchases.purchase_date AS transaction_date,
    'PURCHASE'::text AS reference_document_type,
    stock_purchases.reference_document_id,
    stock_purchases.cost_per_strip AS cost_per_strip_at_transaction,
    stock_purchases.notes,
    stock_purchases.created_by,
    stock_purchases.created_at
   FROM public.stock_purchases
UNION ALL
 SELECT stock_sales.sale_id AS transaction_id,
    stock_sales.sale_group_id AS transaction_group_id,
    stock_sales.product_id,
    stock_sales.batch_id,
    stock_sales.transaction_type,
        CASE
            WHEN (stock_sales.transaction_type = 'DISPATCH_TO_MR'::text) THEN stock_sales.quantity_strips
            WHEN (stock_sales.transaction_type = 'SALE_DIRECT_GODOWN'::text) THEN (- stock_sales.quantity_strips)
            WHEN (stock_sales.transaction_type = 'SALE_BY_MR'::text) THEN (- stock_sales.quantity_strips)
            ELSE stock_sales.quantity_strips
        END AS quantity_strips,
    stock_sales.location_type_source,
    stock_sales.location_id_source,
    stock_sales.location_type_destination,
    stock_sales.location_id_destination,
    stock_sales.sale_date AS transaction_date,
    'SALE'::text AS reference_document_type,
    stock_sales.reference_document_id,
    stock_sales.cost_per_strip AS cost_per_strip_at_transaction,
    stock_sales.notes,
    stock_sales.created_by,
    stock_sales.created_at
   FROM public.stock_sales
UNION ALL
 SELECT stock_adjustments.adjustment_id AS transaction_id,
    stock_adjustments.adjustment_group_id AS transaction_group_id,
    stock_adjustments.product_id,
    stock_adjustments.batch_id,
    stock_adjustments.adjustment_type AS transaction_type,
        CASE
            WHEN (stock_adjustments.adjustment_type ~~ 'RETURN_TO_%'::text) THEN stock_adjustments.quantity_strips
            WHEN (stock_adjustments.adjustment_type ~~ 'ADJUST_%'::text) THEN (- stock_adjustments.quantity_strips)
            WHEN (stock_adjustments.adjustment_type ~~ 'OPENING_STOCK_%'::text) THEN stock_adjustments.quantity_strips
            WHEN (stock_adjustments.adjustment_type ~~ 'REPLACEMENT_%'::text) THEN (- stock_adjustments.quantity_strips)
            ELSE stock_adjustments.quantity_strips
        END AS quantity_strips,
    stock_adjustments.location_type_source,
    stock_adjustments.location_id_source,
    stock_adjustments.location_type_destination,
    stock_adjustments.location_id_destination,
    stock_adjustments.adjustment_date AS transaction_date,
    'ADJUSTMENT'::text AS reference_document_type,
    stock_adjustments.reference_document_id,
    stock_adjustments.cost_per_strip AS cost_per_strip_at_transaction,
    stock_adjustments.notes,
    stock_adjustments.created_by,
    stock_adjustments.created_at
   FROM public.stock_adjustments;


ALTER VIEW public.stock_transactions_view OWNER TO supabase_admin;

--
-- Name: suppliers; Type: TABLE; Schema: public; Owner: supabase_admin
--

CREATE TABLE public.suppliers (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    supplier_name text NOT NULL,
    supplier_code text,
    contact_person text,
    phone text,
    email text,
    address text,
    is_active boolean DEFAULT true NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.suppliers OWNER TO supabase_admin;

--
-- Name: template_names; Type: VIEW; Schema: public; Owner: supabase_admin
--

CREATE VIEW public.template_names AS
 SELECT DISTINCT packaging_templates.template_name
   FROM public.packaging_templates;


ALTER VIEW public.template_names OWNER TO supabase_admin;

--
-- Name: messages; Type: TABLE; Schema: realtime; Owner: supabase_realtime_admin
--

CREATE TABLE realtime.messages (
    topic text NOT NULL,
    extension text NOT NULL,
    payload jsonb,
    event text,
    private boolean DEFAULT false,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    inserted_at timestamp without time zone DEFAULT now() NOT NULL,
    id uuid DEFAULT gen_random_uuid() NOT NULL
)
PARTITION BY RANGE (inserted_at);


ALTER TABLE realtime.messages OWNER TO supabase_realtime_admin;

--
-- Name: schema_migrations; Type: TABLE; Schema: realtime; Owner: supabase_admin
--

CREATE TABLE realtime.schema_migrations (
    version bigint NOT NULL,
    inserted_at timestamp(0) without time zone
);


ALTER TABLE realtime.schema_migrations OWNER TO supabase_admin;

--
-- Name: subscription; Type: TABLE; Schema: realtime; Owner: supabase_admin
--

CREATE TABLE realtime.subscription (
    id bigint NOT NULL,
    subscription_id uuid NOT NULL,
    entity regclass NOT NULL,
    filters realtime.user_defined_filter[] DEFAULT '{}'::realtime.user_defined_filter[] NOT NULL,
    claims jsonb NOT NULL,
    claims_role regrole GENERATED ALWAYS AS (realtime.to_regrole((claims ->> 'role'::text))) STORED NOT NULL,
    created_at timestamp without time zone DEFAULT timezone('utc'::text, now()) NOT NULL
);


ALTER TABLE realtime.subscription OWNER TO supabase_admin;

--
-- Name: subscription_id_seq; Type: SEQUENCE; Schema: realtime; Owner: supabase_admin
--

ALTER TABLE realtime.subscription ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME realtime.subscription_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: buckets; Type: TABLE; Schema: storage; Owner: supabase_storage_admin
--

CREATE TABLE storage.buckets (
    id text NOT NULL,
    name text NOT NULL,
    owner uuid,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    public boolean DEFAULT false,
    avif_autodetection boolean DEFAULT false,
    file_size_limit bigint,
    allowed_mime_types text[],
    owner_id text
);


ALTER TABLE storage.buckets OWNER TO supabase_storage_admin;

--
-- Name: COLUMN buckets.owner; Type: COMMENT; Schema: storage; Owner: supabase_storage_admin
--

COMMENT ON COLUMN storage.buckets.owner IS 'Field is deprecated, use owner_id instead';


--
-- Name: migrations; Type: TABLE; Schema: storage; Owner: supabase_storage_admin
--

CREATE TABLE storage.migrations (
    id integer NOT NULL,
    name character varying(100) NOT NULL,
    hash character varying(40) NOT NULL,
    executed_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE storage.migrations OWNER TO supabase_storage_admin;

--
-- Name: objects; Type: TABLE; Schema: storage; Owner: supabase_storage_admin
--

CREATE TABLE storage.objects (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    bucket_id text,
    name text,
    owner uuid,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    last_accessed_at timestamp with time zone DEFAULT now(),
    metadata jsonb,
    path_tokens text[] GENERATED ALWAYS AS (string_to_array(name, '/'::text)) STORED,
    version text,
    owner_id text,
    user_metadata jsonb
);


ALTER TABLE storage.objects OWNER TO supabase_storage_admin;

--
-- Name: COLUMN objects.owner; Type: COMMENT; Schema: storage; Owner: supabase_storage_admin
--

COMMENT ON COLUMN storage.objects.owner IS 'Field is deprecated, use owner_id instead';


--
-- Name: s3_multipart_uploads; Type: TABLE; Schema: storage; Owner: supabase_storage_admin
--

CREATE TABLE storage.s3_multipart_uploads (
    id text NOT NULL,
    in_progress_size bigint DEFAULT 0 NOT NULL,
    upload_signature text NOT NULL,
    bucket_id text NOT NULL,
    key text NOT NULL COLLATE pg_catalog."C",
    version text NOT NULL,
    owner_id text,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    user_metadata jsonb
);


ALTER TABLE storage.s3_multipart_uploads OWNER TO supabase_storage_admin;

--
-- Name: s3_multipart_uploads_parts; Type: TABLE; Schema: storage; Owner: supabase_storage_admin
--

CREATE TABLE storage.s3_multipart_uploads_parts (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    upload_id text NOT NULL,
    size bigint DEFAULT 0 NOT NULL,
    part_number integer NOT NULL,
    bucket_id text NOT NULL,
    key text NOT NULL COLLATE pg_catalog."C",
    etag text NOT NULL,
    owner_id text,
    version text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE storage.s3_multipart_uploads_parts OWNER TO supabase_storage_admin;

--
-- Name: hooks; Type: TABLE; Schema: supabase_functions; Owner: supabase_functions_admin
--

CREATE TABLE supabase_functions.hooks (
    id bigint NOT NULL,
    hook_table_id integer NOT NULL,
    hook_name text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    request_id bigint
);


ALTER TABLE supabase_functions.hooks OWNER TO supabase_functions_admin;

--
-- Name: TABLE hooks; Type: COMMENT; Schema: supabase_functions; Owner: supabase_functions_admin
--

COMMENT ON TABLE supabase_functions.hooks IS 'Supabase Functions Hooks: Audit trail for triggered hooks.';


--
-- Name: hooks_id_seq; Type: SEQUENCE; Schema: supabase_functions; Owner: supabase_functions_admin
--

CREATE SEQUENCE supabase_functions.hooks_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE supabase_functions.hooks_id_seq OWNER TO supabase_functions_admin;

--
-- Name: hooks_id_seq; Type: SEQUENCE OWNED BY; Schema: supabase_functions; Owner: supabase_functions_admin
--

ALTER SEQUENCE supabase_functions.hooks_id_seq OWNED BY supabase_functions.hooks.id;


--
-- Name: migrations; Type: TABLE; Schema: supabase_functions; Owner: supabase_functions_admin
--

CREATE TABLE supabase_functions.migrations (
    version text NOT NULL,
    inserted_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE supabase_functions.migrations OWNER TO supabase_functions_admin;

--
-- Name: decrypted_secrets; Type: VIEW; Schema: vault; Owner: supabase_admin
--

CREATE VIEW vault.decrypted_secrets AS
 SELECT secrets.id,
    secrets.name,
    secrets.description,
    secrets.secret,
        CASE
            WHEN (secrets.secret IS NULL) THEN NULL::text
            ELSE
            CASE
                WHEN (secrets.key_id IS NULL) THEN NULL::text
                ELSE convert_from(pgsodium.crypto_aead_det_decrypt(decode(secrets.secret, 'base64'::text), convert_to(((((secrets.id)::text || secrets.description) || (secrets.created_at)::text) || (secrets.updated_at)::text), 'utf8'::name), secrets.key_id, secrets.nonce), 'utf8'::name)
            END
        END AS decrypted_secret,
    secrets.key_id,
    secrets.nonce,
    secrets.created_at,
    secrets.updated_at
   FROM vault.secrets;


ALTER VIEW vault.decrypted_secrets OWNER TO supabase_admin;

--
-- Name: refresh_tokens id; Type: DEFAULT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.refresh_tokens ALTER COLUMN id SET DEFAULT nextval('auth.refresh_tokens_id_seq'::regclass);


--
-- Name: hooks id; Type: DEFAULT; Schema: supabase_functions; Owner: supabase_functions_admin
--

ALTER TABLE ONLY supabase_functions.hooks ALTER COLUMN id SET DEFAULT nextval('supabase_functions.hooks_id_seq'::regclass);


--
-- Name: extensions extensions_pkey; Type: CONSTRAINT; Schema: _realtime; Owner: supabase_admin
--

ALTER TABLE ONLY _realtime.extensions
    ADD CONSTRAINT extensions_pkey PRIMARY KEY (id);


--
-- Name: schema_migrations schema_migrations_pkey; Type: CONSTRAINT; Schema: _realtime; Owner: supabase_admin
--

ALTER TABLE ONLY _realtime.schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);


--
-- Name: tenants tenants_pkey; Type: CONSTRAINT; Schema: _realtime; Owner: supabase_admin
--

ALTER TABLE ONLY _realtime.tenants
    ADD CONSTRAINT tenants_pkey PRIMARY KEY (id);


--
-- Name: mfa_amr_claims amr_id_pk; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.mfa_amr_claims
    ADD CONSTRAINT amr_id_pk PRIMARY KEY (id);


--
-- Name: audit_log_entries audit_log_entries_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.audit_log_entries
    ADD CONSTRAINT audit_log_entries_pkey PRIMARY KEY (id);


--
-- Name: flow_state flow_state_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.flow_state
    ADD CONSTRAINT flow_state_pkey PRIMARY KEY (id);


--
-- Name: identities identities_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.identities
    ADD CONSTRAINT identities_pkey PRIMARY KEY (id);


--
-- Name: identities identities_provider_id_provider_unique; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.identities
    ADD CONSTRAINT identities_provider_id_provider_unique UNIQUE (provider_id, provider);


--
-- Name: instances instances_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.instances
    ADD CONSTRAINT instances_pkey PRIMARY KEY (id);


--
-- Name: mfa_amr_claims mfa_amr_claims_session_id_authentication_method_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.mfa_amr_claims
    ADD CONSTRAINT mfa_amr_claims_session_id_authentication_method_pkey UNIQUE (session_id, authentication_method);


--
-- Name: mfa_challenges mfa_challenges_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.mfa_challenges
    ADD CONSTRAINT mfa_challenges_pkey PRIMARY KEY (id);


--
-- Name: mfa_factors mfa_factors_last_challenged_at_key; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.mfa_factors
    ADD CONSTRAINT mfa_factors_last_challenged_at_key UNIQUE (last_challenged_at);


--
-- Name: mfa_factors mfa_factors_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.mfa_factors
    ADD CONSTRAINT mfa_factors_pkey PRIMARY KEY (id);


--
-- Name: one_time_tokens one_time_tokens_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.one_time_tokens
    ADD CONSTRAINT one_time_tokens_pkey PRIMARY KEY (id);


--
-- Name: refresh_tokens refresh_tokens_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.refresh_tokens
    ADD CONSTRAINT refresh_tokens_pkey PRIMARY KEY (id);


--
-- Name: refresh_tokens refresh_tokens_token_unique; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.refresh_tokens
    ADD CONSTRAINT refresh_tokens_token_unique UNIQUE (token);


--
-- Name: saml_providers saml_providers_entity_id_key; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.saml_providers
    ADD CONSTRAINT saml_providers_entity_id_key UNIQUE (entity_id);


--
-- Name: saml_providers saml_providers_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.saml_providers
    ADD CONSTRAINT saml_providers_pkey PRIMARY KEY (id);


--
-- Name: saml_relay_states saml_relay_states_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.saml_relay_states
    ADD CONSTRAINT saml_relay_states_pkey PRIMARY KEY (id);


--
-- Name: schema_migrations schema_migrations_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);


--
-- Name: sessions sessions_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.sessions
    ADD CONSTRAINT sessions_pkey PRIMARY KEY (id);


--
-- Name: sso_domains sso_domains_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.sso_domains
    ADD CONSTRAINT sso_domains_pkey PRIMARY KEY (id);


--
-- Name: sso_providers sso_providers_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.sso_providers
    ADD CONSTRAINT sso_providers_pkey PRIMARY KEY (id);


--
-- Name: users users_phone_key; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.users
    ADD CONSTRAINT users_phone_key UNIQUE (phone);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: doctor_clinics doctor_clinics_pkey; Type: CONSTRAINT; Schema: public; Owner: supabase_admin
--

ALTER TABLE ONLY public.doctor_clinics
    ADD CONSTRAINT doctor_clinics_pkey PRIMARY KEY (id);


--
-- Name: doctors doctors_pkey; Type: CONSTRAINT; Schema: public; Owner: supabase_admin
--

ALTER TABLE ONLY public.doctors
    ADD CONSTRAINT doctors_pkey PRIMARY KEY (id);


--
-- Name: mr_doctor_allotments mr_doctor_allotments_pkey; Type: CONSTRAINT; Schema: public; Owner: supabase_admin
--

ALTER TABLE ONLY public.mr_doctor_allotments
    ADD CONSTRAINT mr_doctor_allotments_pkey PRIMARY KEY (id);


--
-- Name: mr_sales_order_items mr_sales_order_items_pkey; Type: CONSTRAINT; Schema: public; Owner: supabase_admin
--

ALTER TABLE ONLY public.mr_sales_order_items
    ADD CONSTRAINT mr_sales_order_items_pkey PRIMARY KEY (id);


--
-- Name: mr_sales_orders mr_sales_orders_pkey; Type: CONSTRAINT; Schema: public; Owner: supabase_admin
--

ALTER TABLE ONLY public.mr_sales_orders
    ADD CONSTRAINT mr_sales_orders_pkey PRIMARY KEY (id);


--
-- Name: mr_sales_targets mr_sales_targets_pkey; Type: CONSTRAINT; Schema: public; Owner: supabase_admin
--

ALTER TABLE ONLY public.mr_sales_targets
    ADD CONSTRAINT mr_sales_targets_pkey PRIMARY KEY (id);


--
-- Name: mr_stock_summary mr_stock_summary_pkey; Type: CONSTRAINT; Schema: public; Owner: supabase_admin
--

ALTER TABLE ONLY public.mr_stock_summary
    ADD CONSTRAINT mr_stock_summary_pkey PRIMARY KEY (mr_user_id, product_id, batch_id);


--
-- Name: mr_visit_logs mr_visit_logs_pkey; Type: CONSTRAINT; Schema: public; Owner: supabase_admin
--

ALTER TABLE ONLY public.mr_visit_logs
    ADD CONSTRAINT mr_visit_logs_pkey PRIMARY KEY (id);


--
-- Name: packaging_templates packaging_templates_pkey; Type: CONSTRAINT; Schema: public; Owner: supabase_admin
--

ALTER TABLE ONLY public.packaging_templates
    ADD CONSTRAINT packaging_templates_pkey PRIMARY KEY (id);


--
-- Name: product_batches product_batches_pkey; Type: CONSTRAINT; Schema: public; Owner: supabase_admin
--

ALTER TABLE ONLY public.product_batches
    ADD CONSTRAINT product_batches_pkey PRIMARY KEY (id);


--
-- Name: product_categories product_categories_category_name_key; Type: CONSTRAINT; Schema: public; Owner: supabase_admin
--

ALTER TABLE ONLY public.product_categories
    ADD CONSTRAINT product_categories_category_name_key UNIQUE (category_name);


--
-- Name: product_categories product_categories_pkey; Type: CONSTRAINT; Schema: public; Owner: supabase_admin
--

ALTER TABLE ONLY public.product_categories
    ADD CONSTRAINT product_categories_pkey PRIMARY KEY (id);


--
-- Name: product_formulations product_formulations_formulation_name_key; Type: CONSTRAINT; Schema: public; Owner: supabase_admin
--

ALTER TABLE ONLY public.product_formulations
    ADD CONSTRAINT product_formulations_formulation_name_key UNIQUE (formulation_name);


--
-- Name: product_formulations product_formulations_pkey; Type: CONSTRAINT; Schema: public; Owner: supabase_admin
--

ALTER TABLE ONLY public.product_formulations
    ADD CONSTRAINT product_formulations_pkey PRIMARY KEY (id);


--
-- Name: product_packaging_units product_packaging_units_pkey; Type: CONSTRAINT; Schema: public; Owner: supabase_admin
--

ALTER TABLE ONLY public.product_packaging_units
    ADD CONSTRAINT product_packaging_units_pkey PRIMARY KEY (id);


--
-- Name: product_sub_categories product_sub_categories_pkey; Type: CONSTRAINT; Schema: public; Owner: supabase_admin
--

ALTER TABLE ONLY public.product_sub_categories
    ADD CONSTRAINT product_sub_categories_pkey PRIMARY KEY (id);


--
-- Name: product_sub_categories product_sub_categories_sub_category_name_category_id_key; Type: CONSTRAINT; Schema: public; Owner: supabase_admin
--

ALTER TABLE ONLY public.product_sub_categories
    ADD CONSTRAINT product_sub_categories_sub_category_name_category_id_key UNIQUE (sub_category_name, category_id);


--
-- Name: products products_pkey; Type: CONSTRAINT; Schema: public; Owner: supabase_admin
--

ALTER TABLE ONLY public.products
    ADD CONSTRAINT products_pkey PRIMARY KEY (id);


--
-- Name: products products_product_code_key; Type: CONSTRAINT; Schema: public; Owner: supabase_admin
--

ALTER TABLE ONLY public.products
    ADD CONSTRAINT products_product_code_key UNIQUE (product_code);


--
-- Name: products_stock_status products_stock_status_pkey; Type: CONSTRAINT; Schema: public; Owner: supabase_admin
--

ALTER TABLE ONLY public.products_stock_status
    ADD CONSTRAINT products_stock_status_pkey PRIMARY KEY (id);


--
-- Name: products_stock_status products_stock_status_product_id_batch_id_location_type_loc_key; Type: CONSTRAINT; Schema: public; Owner: supabase_admin
--

ALTER TABLE ONLY public.products_stock_status
    ADD CONSTRAINT products_stock_status_product_id_batch_id_location_type_loc_key UNIQUE (product_id, batch_id, location_type, location_id);


--
-- Name: products_stock_status products_stock_status_unique_location; Type: CONSTRAINT; Schema: public; Owner: supabase_admin
--

ALTER TABLE ONLY public.products_stock_status
    ADD CONSTRAINT products_stock_status_unique_location UNIQUE (product_id, batch_id, location_type, location_id);


--
-- Name: profiles profiles_pkey; Type: CONSTRAINT; Schema: public; Owner: supabase_admin
--

ALTER TABLE ONLY public.profiles
    ADD CONSTRAINT profiles_pkey PRIMARY KEY (id);


--
-- Name: profiles profiles_user_id_key; Type: CONSTRAINT; Schema: public; Owner: supabase_admin
--

ALTER TABLE ONLY public.profiles
    ADD CONSTRAINT profiles_user_id_key UNIQUE (user_id);


--
-- Name: stock_adjustments stock_adjustments_pkey; Type: CONSTRAINT; Schema: public; Owner: supabase_admin
--

ALTER TABLE ONLY public.stock_adjustments
    ADD CONSTRAINT stock_adjustments_pkey PRIMARY KEY (adjustment_id);


--
-- Name: stock_purchases stock_purchases_pkey; Type: CONSTRAINT; Schema: public; Owner: supabase_admin
--

ALTER TABLE ONLY public.stock_purchases
    ADD CONSTRAINT stock_purchases_pkey PRIMARY KEY (purchase_id);


--
-- Name: stock_sales stock_sales_pkey; Type: CONSTRAINT; Schema: public; Owner: supabase_admin
--

ALTER TABLE ONLY public.stock_sales
    ADD CONSTRAINT stock_sales_pkey PRIMARY KEY (sale_id);


--
-- Name: stock_transactions stock_transactions_pkey; Type: CONSTRAINT; Schema: public; Owner: supabase_admin
--

ALTER TABLE ONLY public.stock_transactions
    ADD CONSTRAINT stock_transactions_pkey PRIMARY KEY (transaction_id);


--
-- Name: suppliers suppliers_pkey; Type: CONSTRAINT; Schema: public; Owner: supabase_admin
--

ALTER TABLE ONLY public.suppliers
    ADD CONSTRAINT suppliers_pkey PRIMARY KEY (id);


--
-- Name: suppliers suppliers_supplier_code_key; Type: CONSTRAINT; Schema: public; Owner: supabase_admin
--

ALTER TABLE ONLY public.suppliers
    ADD CONSTRAINT suppliers_supplier_code_key UNIQUE (supplier_code);


--
-- Name: mr_doctor_allotments unique_doctor_allotment; Type: CONSTRAINT; Schema: public; Owner: supabase_admin
--

ALTER TABLE ONLY public.mr_doctor_allotments
    ADD CONSTRAINT unique_doctor_allotment UNIQUE (doctor_id);


--
-- Name: mr_sales_targets unique_mr_target_period; Type: CONSTRAINT; Schema: public; Owner: supabase_admin
--

ALTER TABLE ONLY public.mr_sales_targets
    ADD CONSTRAINT unique_mr_target_period UNIQUE (mr_user_id, start_date);


--
-- Name: product_batches unique_product_batch_number; Type: CONSTRAINT; Schema: public; Owner: supabase_admin
--

ALTER TABLE ONLY public.product_batches
    ADD CONSTRAINT unique_product_batch_number UNIQUE (product_id, batch_number);


--
-- Name: product_packaging_units unique_product_unit_name; Type: CONSTRAINT; Schema: public; Owner: supabase_admin
--

ALTER TABLE ONLY public.product_packaging_units
    ADD CONSTRAINT unique_product_unit_name UNIQUE (product_id, unit_name);


--
-- Name: packaging_templates unique_template_unit_name; Type: CONSTRAINT; Schema: public; Owner: supabase_admin
--

ALTER TABLE ONLY public.packaging_templates
    ADD CONSTRAINT unique_template_unit_name UNIQUE (template_name, unit_name);


--
-- Name: messages messages_pkey; Type: CONSTRAINT; Schema: realtime; Owner: supabase_realtime_admin
--

ALTER TABLE ONLY realtime.messages
    ADD CONSTRAINT messages_pkey PRIMARY KEY (id, inserted_at);


--
-- Name: subscription pk_subscription; Type: CONSTRAINT; Schema: realtime; Owner: supabase_admin
--

ALTER TABLE ONLY realtime.subscription
    ADD CONSTRAINT pk_subscription PRIMARY KEY (id);


--
-- Name: schema_migrations schema_migrations_pkey; Type: CONSTRAINT; Schema: realtime; Owner: supabase_admin
--

ALTER TABLE ONLY realtime.schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);


--
-- Name: buckets buckets_pkey; Type: CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.buckets
    ADD CONSTRAINT buckets_pkey PRIMARY KEY (id);


--
-- Name: migrations migrations_name_key; Type: CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.migrations
    ADD CONSTRAINT migrations_name_key UNIQUE (name);


--
-- Name: migrations migrations_pkey; Type: CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.migrations
    ADD CONSTRAINT migrations_pkey PRIMARY KEY (id);


--
-- Name: objects objects_pkey; Type: CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.objects
    ADD CONSTRAINT objects_pkey PRIMARY KEY (id);


--
-- Name: s3_multipart_uploads_parts s3_multipart_uploads_parts_pkey; Type: CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.s3_multipart_uploads_parts
    ADD CONSTRAINT s3_multipart_uploads_parts_pkey PRIMARY KEY (id);


--
-- Name: s3_multipart_uploads s3_multipart_uploads_pkey; Type: CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.s3_multipart_uploads
    ADD CONSTRAINT s3_multipart_uploads_pkey PRIMARY KEY (id);


--
-- Name: hooks hooks_pkey; Type: CONSTRAINT; Schema: supabase_functions; Owner: supabase_functions_admin
--

ALTER TABLE ONLY supabase_functions.hooks
    ADD CONSTRAINT hooks_pkey PRIMARY KEY (id);


--
-- Name: migrations migrations_pkey; Type: CONSTRAINT; Schema: supabase_functions; Owner: supabase_functions_admin
--

ALTER TABLE ONLY supabase_functions.migrations
    ADD CONSTRAINT migrations_pkey PRIMARY KEY (version);


--
-- Name: extensions_tenant_external_id_index; Type: INDEX; Schema: _realtime; Owner: supabase_admin
--

CREATE INDEX extensions_tenant_external_id_index ON _realtime.extensions USING btree (tenant_external_id);


--
-- Name: extensions_tenant_external_id_type_index; Type: INDEX; Schema: _realtime; Owner: supabase_admin
--

CREATE UNIQUE INDEX extensions_tenant_external_id_type_index ON _realtime.extensions USING btree (tenant_external_id, type);


--
-- Name: tenants_external_id_index; Type: INDEX; Schema: _realtime; Owner: supabase_admin
--

CREATE UNIQUE INDEX tenants_external_id_index ON _realtime.tenants USING btree (external_id);


--
-- Name: audit_logs_instance_id_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX audit_logs_instance_id_idx ON auth.audit_log_entries USING btree (instance_id);


--
-- Name: confirmation_token_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE UNIQUE INDEX confirmation_token_idx ON auth.users USING btree (confirmation_token) WHERE ((confirmation_token)::text !~ '^[0-9 ]*$'::text);


--
-- Name: email_change_token_current_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE UNIQUE INDEX email_change_token_current_idx ON auth.users USING btree (email_change_token_current) WHERE ((email_change_token_current)::text !~ '^[0-9 ]*$'::text);


--
-- Name: email_change_token_new_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE UNIQUE INDEX email_change_token_new_idx ON auth.users USING btree (email_change_token_new) WHERE ((email_change_token_new)::text !~ '^[0-9 ]*$'::text);


--
-- Name: factor_id_created_at_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX factor_id_created_at_idx ON auth.mfa_factors USING btree (user_id, created_at);


--
-- Name: flow_state_created_at_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX flow_state_created_at_idx ON auth.flow_state USING btree (created_at DESC);


--
-- Name: identities_email_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX identities_email_idx ON auth.identities USING btree (email text_pattern_ops);


--
-- Name: INDEX identities_email_idx; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON INDEX auth.identities_email_idx IS 'Auth: Ensures indexed queries on the email column';


--
-- Name: identities_user_id_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX identities_user_id_idx ON auth.identities USING btree (user_id);


--
-- Name: idx_auth_code; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX idx_auth_code ON auth.flow_state USING btree (auth_code);


--
-- Name: idx_user_id_auth_method; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX idx_user_id_auth_method ON auth.flow_state USING btree (user_id, authentication_method);


--
-- Name: mfa_challenge_created_at_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX mfa_challenge_created_at_idx ON auth.mfa_challenges USING btree (created_at DESC);


--
-- Name: mfa_factors_user_friendly_name_unique; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE UNIQUE INDEX mfa_factors_user_friendly_name_unique ON auth.mfa_factors USING btree (friendly_name, user_id) WHERE (TRIM(BOTH FROM friendly_name) <> ''::text);


--
-- Name: mfa_factors_user_id_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX mfa_factors_user_id_idx ON auth.mfa_factors USING btree (user_id);


--
-- Name: one_time_tokens_relates_to_hash_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX one_time_tokens_relates_to_hash_idx ON auth.one_time_tokens USING hash (relates_to);


--
-- Name: one_time_tokens_token_hash_hash_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX one_time_tokens_token_hash_hash_idx ON auth.one_time_tokens USING hash (token_hash);


--
-- Name: one_time_tokens_user_id_token_type_key; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE UNIQUE INDEX one_time_tokens_user_id_token_type_key ON auth.one_time_tokens USING btree (user_id, token_type);


--
-- Name: reauthentication_token_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE UNIQUE INDEX reauthentication_token_idx ON auth.users USING btree (reauthentication_token) WHERE ((reauthentication_token)::text !~ '^[0-9 ]*$'::text);


--
-- Name: recovery_token_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE UNIQUE INDEX recovery_token_idx ON auth.users USING btree (recovery_token) WHERE ((recovery_token)::text !~ '^[0-9 ]*$'::text);


--
-- Name: refresh_tokens_instance_id_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX refresh_tokens_instance_id_idx ON auth.refresh_tokens USING btree (instance_id);


--
-- Name: refresh_tokens_instance_id_user_id_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX refresh_tokens_instance_id_user_id_idx ON auth.refresh_tokens USING btree (instance_id, user_id);


--
-- Name: refresh_tokens_parent_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX refresh_tokens_parent_idx ON auth.refresh_tokens USING btree (parent);


--
-- Name: refresh_tokens_session_id_revoked_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX refresh_tokens_session_id_revoked_idx ON auth.refresh_tokens USING btree (session_id, revoked);


--
-- Name: refresh_tokens_updated_at_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX refresh_tokens_updated_at_idx ON auth.refresh_tokens USING btree (updated_at DESC);


--
-- Name: saml_providers_sso_provider_id_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX saml_providers_sso_provider_id_idx ON auth.saml_providers USING btree (sso_provider_id);


--
-- Name: saml_relay_states_created_at_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX saml_relay_states_created_at_idx ON auth.saml_relay_states USING btree (created_at DESC);


--
-- Name: saml_relay_states_for_email_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX saml_relay_states_for_email_idx ON auth.saml_relay_states USING btree (for_email);


--
-- Name: saml_relay_states_sso_provider_id_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX saml_relay_states_sso_provider_id_idx ON auth.saml_relay_states USING btree (sso_provider_id);


--
-- Name: sessions_not_after_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX sessions_not_after_idx ON auth.sessions USING btree (not_after DESC);


--
-- Name: sessions_user_id_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX sessions_user_id_idx ON auth.sessions USING btree (user_id);


--
-- Name: sso_domains_domain_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE UNIQUE INDEX sso_domains_domain_idx ON auth.sso_domains USING btree (lower(domain));


--
-- Name: sso_domains_sso_provider_id_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX sso_domains_sso_provider_id_idx ON auth.sso_domains USING btree (sso_provider_id);


--
-- Name: sso_providers_resource_id_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE UNIQUE INDEX sso_providers_resource_id_idx ON auth.sso_providers USING btree (lower(resource_id));


--
-- Name: unique_phone_factor_per_user; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE UNIQUE INDEX unique_phone_factor_per_user ON auth.mfa_factors USING btree (user_id, phone);


--
-- Name: user_id_created_at_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX user_id_created_at_idx ON auth.sessions USING btree (user_id, created_at);


--
-- Name: users_email_partial_key; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE UNIQUE INDEX users_email_partial_key ON auth.users USING btree (email) WHERE (is_sso_user = false);


--
-- Name: INDEX users_email_partial_key; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON INDEX auth.users_email_partial_key IS 'Auth: A partial unique index that applies only when is_sso_user is false';


--
-- Name: users_instance_id_email_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX users_instance_id_email_idx ON auth.users USING btree (instance_id, lower((email)::text));


--
-- Name: users_instance_id_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX users_instance_id_idx ON auth.users USING btree (instance_id);


--
-- Name: users_is_anonymous_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX users_is_anonymous_idx ON auth.users USING btree (is_anonymous);


--
-- Name: idx_mr_sales_order_items_order_id; Type: INDEX; Schema: public; Owner: supabase_admin
--

CREATE INDEX idx_mr_sales_order_items_order_id ON public.mr_sales_order_items USING btree (order_id);


--
-- Name: idx_mr_sales_order_items_product_id; Type: INDEX; Schema: public; Owner: supabase_admin
--

CREATE INDEX idx_mr_sales_order_items_product_id ON public.mr_sales_order_items USING btree (product_id);


--
-- Name: idx_mr_sales_orders_mr_user_id; Type: INDEX; Schema: public; Owner: supabase_admin
--

CREATE INDEX idx_mr_sales_orders_mr_user_id ON public.mr_sales_orders USING btree (mr_user_id);


--
-- Name: idx_mr_sales_orders_order_date; Type: INDEX; Schema: public; Owner: supabase_admin
--

CREATE INDEX idx_mr_sales_orders_order_date ON public.mr_sales_orders USING btree (order_date);


--
-- Name: idx_mr_sales_targets_mr_user_id; Type: INDEX; Schema: public; Owner: supabase_admin
--

CREATE INDEX idx_mr_sales_targets_mr_user_id ON public.mr_sales_targets USING btree (mr_user_id);


--
-- Name: idx_mr_sales_targets_period; Type: INDEX; Schema: public; Owner: supabase_admin
--

CREATE INDEX idx_mr_sales_targets_period ON public.mr_sales_targets USING btree (start_date, end_date);


--
-- Name: idx_mr_stock_summary_mr_user; Type: INDEX; Schema: public; Owner: supabase_admin
--

CREATE INDEX idx_mr_stock_summary_mr_user ON public.mr_stock_summary USING btree (mr_user_id);


--
-- Name: idx_mr_stock_summary_product; Type: INDEX; Schema: public; Owner: supabase_admin
--

CREATE INDEX idx_mr_stock_summary_product ON public.mr_stock_summary USING btree (product_id);


--
-- Name: idx_mr_visit_logs_location_verified; Type: INDEX; Schema: public; Owner: supabase_admin
--

CREATE INDEX idx_mr_visit_logs_location_verified ON public.mr_visit_logs USING btree (is_location_verified);


--
-- Name: idx_packaging_templates_name; Type: INDEX; Schema: public; Owner: supabase_admin
--

CREATE INDEX idx_packaging_templates_name ON public.packaging_templates USING btree (template_name);


--
-- Name: idx_product_batches_batch_number; Type: INDEX; Schema: public; Owner: supabase_admin
--

CREATE INDEX idx_product_batches_batch_number ON public.product_batches USING btree (product_id, batch_number);


--
-- Name: idx_product_batches_expiry_date; Type: INDEX; Schema: public; Owner: supabase_admin
--

CREATE INDEX idx_product_batches_expiry_date ON public.product_batches USING btree (expiry_date);


--
-- Name: idx_product_batches_product_id; Type: INDEX; Schema: public; Owner: supabase_admin
--

CREATE INDEX idx_product_batches_product_id ON public.product_batches USING btree (product_id);


--
-- Name: idx_product_batches_status; Type: INDEX; Schema: public; Owner: supabase_admin
--

CREATE INDEX idx_product_batches_status ON public.product_batches USING btree (status);


--
-- Name: idx_product_packaging_units_order; Type: INDEX; Schema: public; Owner: supabase_admin
--

CREATE INDEX idx_product_packaging_units_order ON public.product_packaging_units USING btree (product_id, order_in_hierarchy);


--
-- Name: idx_product_packaging_units_product_id; Type: INDEX; Schema: public; Owner: supabase_admin
--

CREATE INDEX idx_product_packaging_units_product_id ON public.product_packaging_units USING btree (product_id);


--
-- Name: idx_product_packaging_units_template_id; Type: INDEX; Schema: public; Owner: supabase_admin
--

CREATE INDEX idx_product_packaging_units_template_id ON public.product_packaging_units USING btree (template_id);


--
-- Name: idx_product_sub_categories_category_id; Type: INDEX; Schema: public; Owner: supabase_admin
--

CREATE INDEX idx_product_sub_categories_category_id ON public.product_sub_categories USING btree (category_id);


--
-- Name: idx_products_category_id; Type: INDEX; Schema: public; Owner: supabase_admin
--

CREATE INDEX idx_products_category_id ON public.products USING btree (category_id);


--
-- Name: idx_products_formulation_id; Type: INDEX; Schema: public; Owner: supabase_admin
--

CREATE INDEX idx_products_formulation_id ON public.products USING btree (formulation_id);


--
-- Name: idx_products_is_active; Type: INDEX; Schema: public; Owner: supabase_admin
--

CREATE INDEX idx_products_is_active ON public.products USING btree (is_active);


--
-- Name: idx_products_packaging_template; Type: INDEX; Schema: public; Owner: supabase_admin
--

CREATE INDEX idx_products_packaging_template ON public.products USING btree (packaging_template);


--
-- Name: idx_products_product_code; Type: INDEX; Schema: public; Owner: supabase_admin
--

CREATE INDEX idx_products_product_code ON public.products USING btree (product_code);


--
-- Name: idx_products_stock_status_batch_id; Type: INDEX; Schema: public; Owner: supabase_admin
--

CREATE INDEX idx_products_stock_status_batch_id ON public.products_stock_status USING btree (batch_id);


--
-- Name: idx_products_stock_status_current_quantity; Type: INDEX; Schema: public; Owner: supabase_admin
--

CREATE INDEX idx_products_stock_status_current_quantity ON public.products_stock_status USING btree (current_quantity_strips) WHERE (current_quantity_strips > 0);


--
-- Name: idx_products_stock_status_location; Type: INDEX; Schema: public; Owner: supabase_admin
--

CREATE INDEX idx_products_stock_status_location ON public.products_stock_status USING btree (location_type, location_id);


--
-- Name: idx_products_stock_status_product_id; Type: INDEX; Schema: public; Owner: supabase_admin
--

CREATE INDEX idx_products_stock_status_product_id ON public.products_stock_status USING btree (product_id);


--
-- Name: idx_products_sub_category_id; Type: INDEX; Schema: public; Owner: supabase_admin
--

CREATE INDEX idx_products_sub_category_id ON public.products USING btree (sub_category_id);


--
-- Name: idx_stock_adjustments_batch_id; Type: INDEX; Schema: public; Owner: supabase_admin
--

CREATE INDEX idx_stock_adjustments_batch_id ON public.stock_adjustments USING btree (batch_id);


--
-- Name: idx_stock_adjustments_created_by; Type: INDEX; Schema: public; Owner: supabase_admin
--

CREATE INDEX idx_stock_adjustments_created_by ON public.stock_adjustments USING btree (created_by);


--
-- Name: idx_stock_adjustments_date; Type: INDEX; Schema: public; Owner: supabase_admin
--

CREATE INDEX idx_stock_adjustments_date ON public.stock_adjustments USING btree (adjustment_date);


--
-- Name: idx_stock_adjustments_group_id; Type: INDEX; Schema: public; Owner: supabase_admin
--

CREATE INDEX idx_stock_adjustments_group_id ON public.stock_adjustments USING btree (adjustment_group_id);


--
-- Name: idx_stock_adjustments_product_id; Type: INDEX; Schema: public; Owner: supabase_admin
--

CREATE INDEX idx_stock_adjustments_product_id ON public.stock_adjustments USING btree (product_id);


--
-- Name: idx_stock_adjustments_type; Type: INDEX; Schema: public; Owner: supabase_admin
--

CREATE INDEX idx_stock_adjustments_type ON public.stock_adjustments USING btree (adjustment_type);


--
-- Name: idx_stock_purchases_batch_id; Type: INDEX; Schema: public; Owner: supabase_admin
--

CREATE INDEX idx_stock_purchases_batch_id ON public.stock_purchases USING btree (batch_id);


--
-- Name: idx_stock_purchases_created_by; Type: INDEX; Schema: public; Owner: supabase_admin
--

CREATE INDEX idx_stock_purchases_created_by ON public.stock_purchases USING btree (created_by);


--
-- Name: idx_stock_purchases_date; Type: INDEX; Schema: public; Owner: supabase_admin
--

CREATE INDEX idx_stock_purchases_date ON public.stock_purchases USING btree (purchase_date);


--
-- Name: idx_stock_purchases_group_id; Type: INDEX; Schema: public; Owner: supabase_admin
--

CREATE INDEX idx_stock_purchases_group_id ON public.stock_purchases USING btree (purchase_group_id);


--
-- Name: idx_stock_purchases_product_id; Type: INDEX; Schema: public; Owner: supabase_admin
--

CREATE INDEX idx_stock_purchases_product_id ON public.stock_purchases USING btree (product_id);


--
-- Name: idx_stock_sales_batch_id; Type: INDEX; Schema: public; Owner: supabase_admin
--

CREATE INDEX idx_stock_sales_batch_id ON public.stock_sales USING btree (batch_id);


--
-- Name: idx_stock_sales_created_by; Type: INDEX; Schema: public; Owner: supabase_admin
--

CREATE INDEX idx_stock_sales_created_by ON public.stock_sales USING btree (created_by);


--
-- Name: idx_stock_sales_date; Type: INDEX; Schema: public; Owner: supabase_admin
--

CREATE INDEX idx_stock_sales_date ON public.stock_sales USING btree (sale_date);


--
-- Name: idx_stock_sales_group_id; Type: INDEX; Schema: public; Owner: supabase_admin
--

CREATE INDEX idx_stock_sales_group_id ON public.stock_sales USING btree (sale_group_id);


--
-- Name: idx_stock_sales_product_id; Type: INDEX; Schema: public; Owner: supabase_admin
--

CREATE INDEX idx_stock_sales_product_id ON public.stock_sales USING btree (product_id);


--
-- Name: idx_stock_sales_type; Type: INDEX; Schema: public; Owner: supabase_admin
--

CREATE INDEX idx_stock_sales_type ON public.stock_sales USING btree (transaction_type);


--
-- Name: idx_stock_transactions_batch_id; Type: INDEX; Schema: public; Owner: supabase_admin
--

CREATE INDEX idx_stock_transactions_batch_id ON public.stock_transactions USING btree (batch_id);


--
-- Name: idx_stock_transactions_created_by; Type: INDEX; Schema: public; Owner: supabase_admin
--

CREATE INDEX idx_stock_transactions_created_by ON public.stock_transactions USING btree (created_by);


--
-- Name: idx_stock_transactions_date; Type: INDEX; Schema: public; Owner: supabase_admin
--

CREATE INDEX idx_stock_transactions_date ON public.stock_transactions USING btree (transaction_date);


--
-- Name: idx_stock_transactions_group_id; Type: INDEX; Schema: public; Owner: supabase_admin
--

CREATE INDEX idx_stock_transactions_group_id ON public.stock_transactions USING btree (transaction_group_id);


--
-- Name: idx_stock_transactions_product_id; Type: INDEX; Schema: public; Owner: supabase_admin
--

CREATE INDEX idx_stock_transactions_product_id ON public.stock_transactions USING btree (product_id);


--
-- Name: idx_stock_transactions_type; Type: INDEX; Schema: public; Owner: supabase_admin
--

CREATE INDEX idx_stock_transactions_type ON public.stock_transactions USING btree (transaction_type);


--
-- Name: one_primary_clinic_per_doctor; Type: INDEX; Schema: public; Owner: supabase_admin
--

CREATE UNIQUE INDEX one_primary_clinic_per_doctor ON public.doctor_clinics USING btree (doctor_id) WHERE (is_primary = true);


--
-- Name: ix_realtime_subscription_entity; Type: INDEX; Schema: realtime; Owner: supabase_admin
--

CREATE INDEX ix_realtime_subscription_entity ON realtime.subscription USING btree (entity);


--
-- Name: subscription_subscription_id_entity_filters_key; Type: INDEX; Schema: realtime; Owner: supabase_admin
--

CREATE UNIQUE INDEX subscription_subscription_id_entity_filters_key ON realtime.subscription USING btree (subscription_id, entity, filters);


--
-- Name: bname; Type: INDEX; Schema: storage; Owner: supabase_storage_admin
--

CREATE UNIQUE INDEX bname ON storage.buckets USING btree (name);


--
-- Name: bucketid_objname; Type: INDEX; Schema: storage; Owner: supabase_storage_admin
--

CREATE UNIQUE INDEX bucketid_objname ON storage.objects USING btree (bucket_id, name);


--
-- Name: idx_multipart_uploads_list; Type: INDEX; Schema: storage; Owner: supabase_storage_admin
--

CREATE INDEX idx_multipart_uploads_list ON storage.s3_multipart_uploads USING btree (bucket_id, key, created_at);


--
-- Name: idx_objects_bucket_id_name; Type: INDEX; Schema: storage; Owner: supabase_storage_admin
--

CREATE INDEX idx_objects_bucket_id_name ON storage.objects USING btree (bucket_id, name COLLATE "C");


--
-- Name: name_prefix_search; Type: INDEX; Schema: storage; Owner: supabase_storage_admin
--

CREATE INDEX name_prefix_search ON storage.objects USING btree (name text_pattern_ops);


--
-- Name: supabase_functions_hooks_h_table_id_h_name_idx; Type: INDEX; Schema: supabase_functions; Owner: supabase_functions_admin
--

CREATE INDEX supabase_functions_hooks_h_table_id_h_name_idx ON supabase_functions.hooks USING btree (hook_table_id, hook_name);


--
-- Name: supabase_functions_hooks_request_id_idx; Type: INDEX; Schema: supabase_functions; Owner: supabase_functions_admin
--

CREATE INDEX supabase_functions_hooks_request_id_idx ON supabase_functions.hooks USING btree (request_id);


--
-- Name: users on_auth_user_created; Type: TRIGGER; Schema: auth; Owner: supabase_auth_admin
--

CREATE TRIGGER on_auth_user_created AFTER INSERT ON auth.users FOR EACH ROW EXECUTE FUNCTION public.handle_new_user();


--
-- Name: stock_transactions trigger_update_products_stock_status; Type: TRIGGER; Schema: public; Owner: supabase_admin
--

CREATE TRIGGER trigger_update_products_stock_status AFTER INSERT ON public.stock_transactions FOR EACH ROW EXECUTE FUNCTION public.update_products_stock_status();


--
-- Name: stock_adjustments update_mr_stock_summary_adjustments_trigger; Type: TRIGGER; Schema: public; Owner: supabase_admin
--

CREATE TRIGGER update_mr_stock_summary_adjustments_trigger AFTER INSERT ON public.stock_adjustments FOR EACH ROW EXECUTE FUNCTION public.update_mr_stock_summary_from_adjustments();


--
-- Name: stock_sales update_mr_stock_summary_sales_trigger; Type: TRIGGER; Schema: public; Owner: supabase_admin
--

CREATE TRIGGER update_mr_stock_summary_sales_trigger AFTER INSERT ON public.stock_sales FOR EACH ROW EXECUTE FUNCTION public.update_mr_stock_summary_from_sales();


--
-- Name: stock_transactions update_mr_stock_summary_trigger; Type: TRIGGER; Schema: public; Owner: supabase_admin
--

CREATE TRIGGER update_mr_stock_summary_trigger AFTER INSERT ON public.stock_transactions FOR EACH ROW EXECUTE FUNCTION public.update_mr_stock_summary();


--
-- Name: packaging_templates update_packaging_templates_updated_at; Type: TRIGGER; Schema: public; Owner: supabase_admin
--

CREATE TRIGGER update_packaging_templates_updated_at BEFORE UPDATE ON public.packaging_templates FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();


--
-- Name: product_batches update_product_batches_updated_at; Type: TRIGGER; Schema: public; Owner: supabase_admin
--

CREATE TRIGGER update_product_batches_updated_at BEFORE UPDATE ON public.product_batches FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();


--
-- Name: product_categories update_product_categories_updated_at; Type: TRIGGER; Schema: public; Owner: supabase_admin
--

CREATE TRIGGER update_product_categories_updated_at BEFORE UPDATE ON public.product_categories FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();


--
-- Name: product_formulations update_product_formulations_updated_at; Type: TRIGGER; Schema: public; Owner: supabase_admin
--

CREATE TRIGGER update_product_formulations_updated_at BEFORE UPDATE ON public.product_formulations FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();


--
-- Name: product_packaging_units update_product_packaging_units_updated_at; Type: TRIGGER; Schema: public; Owner: supabase_admin
--

CREATE TRIGGER update_product_packaging_units_updated_at BEFORE UPDATE ON public.product_packaging_units FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();


--
-- Name: product_sub_categories update_product_sub_categories_updated_at; Type: TRIGGER; Schema: public; Owner: supabase_admin
--

CREATE TRIGGER update_product_sub_categories_updated_at BEFORE UPDATE ON public.product_sub_categories FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();


--
-- Name: products_stock_status update_products_stock_status_updated_at; Type: TRIGGER; Schema: public; Owner: supabase_admin
--

CREATE TRIGGER update_products_stock_status_updated_at BEFORE UPDATE ON public.products_stock_status FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();


--
-- Name: products update_products_updated_at; Type: TRIGGER; Schema: public; Owner: supabase_admin
--

CREATE TRIGGER update_products_updated_at BEFORE UPDATE ON public.products FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();


--
-- Name: suppliers update_suppliers_updated_at; Type: TRIGGER; Schema: public; Owner: supabase_admin
--

CREATE TRIGGER update_suppliers_updated_at BEFORE UPDATE ON public.suppliers FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();


--
-- Name: product_batches validate_batch_dates_trigger; Type: TRIGGER; Schema: public; Owner: supabase_admin
--

CREATE TRIGGER validate_batch_dates_trigger BEFORE INSERT OR UPDATE ON public.product_batches FOR EACH ROW EXECUTE FUNCTION public.validate_batch_dates();


--
-- Name: products validate_product_template_name; Type: TRIGGER; Schema: public; Owner: supabase_admin
--

CREATE TRIGGER validate_product_template_name BEFORE INSERT OR UPDATE ON public.products FOR EACH ROW EXECUTE FUNCTION public.validate_template_name();


--
-- Name: product_packaging_units validate_single_base_unit_trigger; Type: TRIGGER; Schema: public; Owner: supabase_admin
--

CREATE TRIGGER validate_single_base_unit_trigger BEFORE INSERT OR UPDATE ON public.product_packaging_units FOR EACH ROW EXECUTE FUNCTION public.validate_single_base_unit();


--
-- Name: subscription tr_check_filters; Type: TRIGGER; Schema: realtime; Owner: supabase_admin
--

CREATE TRIGGER tr_check_filters BEFORE INSERT OR UPDATE ON realtime.subscription FOR EACH ROW EXECUTE FUNCTION realtime.subscription_check_filters();


--
-- Name: objects update_objects_updated_at; Type: TRIGGER; Schema: storage; Owner: supabase_storage_admin
--

CREATE TRIGGER update_objects_updated_at BEFORE UPDATE ON storage.objects FOR EACH ROW EXECUTE FUNCTION storage.update_updated_at_column();


--
-- Name: extensions extensions_tenant_external_id_fkey; Type: FK CONSTRAINT; Schema: _realtime; Owner: supabase_admin
--

ALTER TABLE ONLY _realtime.extensions
    ADD CONSTRAINT extensions_tenant_external_id_fkey FOREIGN KEY (tenant_external_id) REFERENCES _realtime.tenants(external_id) ON DELETE CASCADE;


--
-- Name: identities identities_user_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.identities
    ADD CONSTRAINT identities_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE;


--
-- Name: mfa_amr_claims mfa_amr_claims_session_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.mfa_amr_claims
    ADD CONSTRAINT mfa_amr_claims_session_id_fkey FOREIGN KEY (session_id) REFERENCES auth.sessions(id) ON DELETE CASCADE;


--
-- Name: mfa_challenges mfa_challenges_auth_factor_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.mfa_challenges
    ADD CONSTRAINT mfa_challenges_auth_factor_id_fkey FOREIGN KEY (factor_id) REFERENCES auth.mfa_factors(id) ON DELETE CASCADE;


--
-- Name: mfa_factors mfa_factors_user_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.mfa_factors
    ADD CONSTRAINT mfa_factors_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE;


--
-- Name: one_time_tokens one_time_tokens_user_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.one_time_tokens
    ADD CONSTRAINT one_time_tokens_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE;


--
-- Name: refresh_tokens refresh_tokens_session_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.refresh_tokens
    ADD CONSTRAINT refresh_tokens_session_id_fkey FOREIGN KEY (session_id) REFERENCES auth.sessions(id) ON DELETE CASCADE;


--
-- Name: saml_providers saml_providers_sso_provider_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.saml_providers
    ADD CONSTRAINT saml_providers_sso_provider_id_fkey FOREIGN KEY (sso_provider_id) REFERENCES auth.sso_providers(id) ON DELETE CASCADE;


--
-- Name: saml_relay_states saml_relay_states_flow_state_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.saml_relay_states
    ADD CONSTRAINT saml_relay_states_flow_state_id_fkey FOREIGN KEY (flow_state_id) REFERENCES auth.flow_state(id) ON DELETE CASCADE;


--
-- Name: saml_relay_states saml_relay_states_sso_provider_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.saml_relay_states
    ADD CONSTRAINT saml_relay_states_sso_provider_id_fkey FOREIGN KEY (sso_provider_id) REFERENCES auth.sso_providers(id) ON DELETE CASCADE;


--
-- Name: sessions sessions_user_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.sessions
    ADD CONSTRAINT sessions_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE;


--
-- Name: sso_domains sso_domains_sso_provider_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.sso_domains
    ADD CONSTRAINT sso_domains_sso_provider_id_fkey FOREIGN KEY (sso_provider_id) REFERENCES auth.sso_providers(id) ON DELETE CASCADE;


--
-- Name: doctor_clinics doctor_clinics_doctor_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: supabase_admin
--

ALTER TABLE ONLY public.doctor_clinics
    ADD CONSTRAINT doctor_clinics_doctor_id_fkey FOREIGN KEY (doctor_id) REFERENCES public.doctors(id) ON DELETE CASCADE;


--
-- Name: doctors doctors_created_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: supabase_admin
--

ALTER TABLE ONLY public.doctors
    ADD CONSTRAINT doctors_created_by_fkey FOREIGN KEY (created_by) REFERENCES public.profiles(user_id) ON DELETE SET NULL;


--
-- Name: mr_doctor_allotments mr_doctor_allotments_doctor_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: supabase_admin
--

ALTER TABLE ONLY public.mr_doctor_allotments
    ADD CONSTRAINT mr_doctor_allotments_doctor_id_fkey FOREIGN KEY (doctor_id) REFERENCES public.doctors(id) ON DELETE CASCADE;


--
-- Name: mr_doctor_allotments mr_doctor_allotments_mr_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: supabase_admin
--

ALTER TABLE ONLY public.mr_doctor_allotments
    ADD CONSTRAINT mr_doctor_allotments_mr_user_id_fkey FOREIGN KEY (mr_user_id) REFERENCES public.profiles(user_id) ON DELETE CASCADE;


--
-- Name: mr_sales_order_items mr_sales_order_items_batch_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: supabase_admin
--

ALTER TABLE ONLY public.mr_sales_order_items
    ADD CONSTRAINT mr_sales_order_items_batch_id_fkey FOREIGN KEY (batch_id) REFERENCES public.product_batches(id) ON DELETE RESTRICT;


--
-- Name: mr_sales_order_items mr_sales_order_items_order_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: supabase_admin
--

ALTER TABLE ONLY public.mr_sales_order_items
    ADD CONSTRAINT mr_sales_order_items_order_id_fkey FOREIGN KEY (order_id) REFERENCES public.mr_sales_orders(id) ON DELETE CASCADE;


--
-- Name: mr_sales_order_items mr_sales_order_items_product_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: supabase_admin
--

ALTER TABLE ONLY public.mr_sales_order_items
    ADD CONSTRAINT mr_sales_order_items_product_id_fkey FOREIGN KEY (product_id) REFERENCES public.products(id) ON DELETE RESTRICT;


--
-- Name: mr_sales_orders mr_sales_orders_mr_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: supabase_admin
--

ALTER TABLE ONLY public.mr_sales_orders
    ADD CONSTRAINT mr_sales_orders_mr_user_id_fkey FOREIGN KEY (mr_user_id) REFERENCES public.profiles(user_id) ON DELETE RESTRICT;


--
-- Name: mr_sales_targets mr_sales_targets_mr_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: supabase_admin
--

ALTER TABLE ONLY public.mr_sales_targets
    ADD CONSTRAINT mr_sales_targets_mr_user_id_fkey FOREIGN KEY (mr_user_id) REFERENCES public.profiles(user_id) ON DELETE CASCADE;


--
-- Name: mr_stock_summary mr_stock_summary_batch_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: supabase_admin
--

ALTER TABLE ONLY public.mr_stock_summary
    ADD CONSTRAINT mr_stock_summary_batch_id_fkey FOREIGN KEY (batch_id) REFERENCES public.product_batches(id) ON DELETE CASCADE;


--
-- Name: mr_stock_summary mr_stock_summary_mr_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: supabase_admin
--

ALTER TABLE ONLY public.mr_stock_summary
    ADD CONSTRAINT mr_stock_summary_mr_user_id_fkey FOREIGN KEY (mr_user_id) REFERENCES auth.users(id) ON DELETE CASCADE;


--
-- Name: mr_stock_summary mr_stock_summary_product_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: supabase_admin
--

ALTER TABLE ONLY public.mr_stock_summary
    ADD CONSTRAINT mr_stock_summary_product_id_fkey FOREIGN KEY (product_id) REFERENCES public.products(id) ON DELETE CASCADE;


--
-- Name: mr_visit_logs mr_visit_logs_clinic_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: supabase_admin
--

ALTER TABLE ONLY public.mr_visit_logs
    ADD CONSTRAINT mr_visit_logs_clinic_id_fkey FOREIGN KEY (clinic_id) REFERENCES public.doctor_clinics(id) ON DELETE SET NULL;


--
-- Name: mr_visit_logs mr_visit_logs_doctor_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: supabase_admin
--

ALTER TABLE ONLY public.mr_visit_logs
    ADD CONSTRAINT mr_visit_logs_doctor_id_fkey FOREIGN KEY (doctor_id) REFERENCES public.doctors(id) ON DELETE RESTRICT;


--
-- Name: mr_visit_logs mr_visit_logs_linked_sale_order_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: supabase_admin
--

ALTER TABLE ONLY public.mr_visit_logs
    ADD CONSTRAINT mr_visit_logs_linked_sale_order_id_fkey FOREIGN KEY (linked_sale_order_id) REFERENCES public.mr_sales_orders(id) ON DELETE SET NULL;


--
-- Name: mr_visit_logs mr_visit_logs_mr_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: supabase_admin
--

ALTER TABLE ONLY public.mr_visit_logs
    ADD CONSTRAINT mr_visit_logs_mr_user_id_fkey FOREIGN KEY (mr_user_id) REFERENCES public.profiles(user_id) ON DELETE RESTRICT;


--
-- Name: product_batches product_batches_product_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: supabase_admin
--

ALTER TABLE ONLY public.product_batches
    ADD CONSTRAINT product_batches_product_id_fkey FOREIGN KEY (product_id) REFERENCES public.products(id) ON DELETE CASCADE;


--
-- Name: product_packaging_units product_packaging_units_product_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: supabase_admin
--

ALTER TABLE ONLY public.product_packaging_units
    ADD CONSTRAINT product_packaging_units_product_id_fkey FOREIGN KEY (product_id) REFERENCES public.products(id) ON DELETE CASCADE;


--
-- Name: product_packaging_units product_packaging_units_template_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: supabase_admin
--

ALTER TABLE ONLY public.product_packaging_units
    ADD CONSTRAINT product_packaging_units_template_id_fkey FOREIGN KEY (template_id) REFERENCES public.packaging_templates(id) ON DELETE SET NULL;


--
-- Name: product_sub_categories product_sub_categories_category_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: supabase_admin
--

ALTER TABLE ONLY public.product_sub_categories
    ADD CONSTRAINT product_sub_categories_category_id_fkey FOREIGN KEY (category_id) REFERENCES public.product_categories(id);


--
-- Name: products products_category_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: supabase_admin
--

ALTER TABLE ONLY public.products
    ADD CONSTRAINT products_category_id_fkey FOREIGN KEY (category_id) REFERENCES public.product_categories(id);


--
-- Name: products products_formulation_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: supabase_admin
--

ALTER TABLE ONLY public.products
    ADD CONSTRAINT products_formulation_id_fkey FOREIGN KEY (formulation_id) REFERENCES public.product_formulations(id);


--
-- Name: products_stock_status products_stock_status_batch_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: supabase_admin
--

ALTER TABLE ONLY public.products_stock_status
    ADD CONSTRAINT products_stock_status_batch_id_fkey FOREIGN KEY (batch_id) REFERENCES public.product_batches(id);


--
-- Name: products_stock_status products_stock_status_product_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: supabase_admin
--

ALTER TABLE ONLY public.products_stock_status
    ADD CONSTRAINT products_stock_status_product_id_fkey FOREIGN KEY (product_id) REFERENCES public.products(id);


--
-- Name: products products_sub_category_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: supabase_admin
--

ALTER TABLE ONLY public.products
    ADD CONSTRAINT products_sub_category_id_fkey FOREIGN KEY (sub_category_id) REFERENCES public.product_sub_categories(id);


--
-- Name: profiles profiles_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: supabase_admin
--

ALTER TABLE ONLY public.profiles
    ADD CONSTRAINT profiles_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE;


--
-- Name: stock_adjustments stock_adjustments_batch_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: supabase_admin
--

ALTER TABLE ONLY public.stock_adjustments
    ADD CONSTRAINT stock_adjustments_batch_id_fkey FOREIGN KEY (batch_id) REFERENCES public.product_batches(id) ON DELETE RESTRICT;


--
-- Name: stock_adjustments stock_adjustments_created_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: supabase_admin
--

ALTER TABLE ONLY public.stock_adjustments
    ADD CONSTRAINT stock_adjustments_created_by_fkey FOREIGN KEY (created_by) REFERENCES auth.users(id);


--
-- Name: stock_adjustments stock_adjustments_product_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: supabase_admin
--

ALTER TABLE ONLY public.stock_adjustments
    ADD CONSTRAINT stock_adjustments_product_id_fkey FOREIGN KEY (product_id) REFERENCES public.products(id) ON DELETE RESTRICT;


--
-- Name: stock_purchases stock_purchases_batch_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: supabase_admin
--

ALTER TABLE ONLY public.stock_purchases
    ADD CONSTRAINT stock_purchases_batch_id_fkey FOREIGN KEY (batch_id) REFERENCES public.product_batches(id) ON DELETE RESTRICT;


--
-- Name: stock_purchases stock_purchases_created_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: supabase_admin
--

ALTER TABLE ONLY public.stock_purchases
    ADD CONSTRAINT stock_purchases_created_by_fkey FOREIGN KEY (created_by) REFERENCES auth.users(id);


--
-- Name: stock_purchases stock_purchases_product_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: supabase_admin
--

ALTER TABLE ONLY public.stock_purchases
    ADD CONSTRAINT stock_purchases_product_id_fkey FOREIGN KEY (product_id) REFERENCES public.products(id) ON DELETE RESTRICT;


--
-- Name: stock_sales stock_sales_batch_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: supabase_admin
--

ALTER TABLE ONLY public.stock_sales
    ADD CONSTRAINT stock_sales_batch_id_fkey FOREIGN KEY (batch_id) REFERENCES public.product_batches(id) ON DELETE RESTRICT;


--
-- Name: stock_sales stock_sales_created_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: supabase_admin
--

ALTER TABLE ONLY public.stock_sales
    ADD CONSTRAINT stock_sales_created_by_fkey FOREIGN KEY (created_by) REFERENCES auth.users(id);


--
-- Name: stock_sales stock_sales_product_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: supabase_admin
--

ALTER TABLE ONLY public.stock_sales
    ADD CONSTRAINT stock_sales_product_id_fkey FOREIGN KEY (product_id) REFERENCES public.products(id) ON DELETE RESTRICT;


--
-- Name: stock_transactions stock_transactions_batch_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: supabase_admin
--

ALTER TABLE ONLY public.stock_transactions
    ADD CONSTRAINT stock_transactions_batch_id_fkey FOREIGN KEY (batch_id) REFERENCES public.product_batches(id) ON DELETE RESTRICT;


--
-- Name: stock_transactions stock_transactions_created_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: supabase_admin
--

ALTER TABLE ONLY public.stock_transactions
    ADD CONSTRAINT stock_transactions_created_by_fkey FOREIGN KEY (created_by) REFERENCES auth.users(id);


--
-- Name: stock_transactions stock_transactions_product_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: supabase_admin
--

ALTER TABLE ONLY public.stock_transactions
    ADD CONSTRAINT stock_transactions_product_id_fkey FOREIGN KEY (product_id) REFERENCES public.products(id) ON DELETE RESTRICT;


--
-- Name: mr_sales_orders trigger_update_updated_at; Type: FK CONSTRAINT; Schema: public; Owner: supabase_admin
--

ALTER TABLE ONLY public.mr_sales_orders
    ADD CONSTRAINT trigger_update_updated_at FOREIGN KEY (id) REFERENCES public.mr_sales_orders(id) ON UPDATE CASCADE;


--
-- Name: objects objects_bucketId_fkey; Type: FK CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.objects
    ADD CONSTRAINT "objects_bucketId_fkey" FOREIGN KEY (bucket_id) REFERENCES storage.buckets(id);


--
-- Name: s3_multipart_uploads s3_multipart_uploads_bucket_id_fkey; Type: FK CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.s3_multipart_uploads
    ADD CONSTRAINT s3_multipart_uploads_bucket_id_fkey FOREIGN KEY (bucket_id) REFERENCES storage.buckets(id);


--
-- Name: s3_multipart_uploads_parts s3_multipart_uploads_parts_bucket_id_fkey; Type: FK CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.s3_multipart_uploads_parts
    ADD CONSTRAINT s3_multipart_uploads_parts_bucket_id_fkey FOREIGN KEY (bucket_id) REFERENCES storage.buckets(id);


--
-- Name: s3_multipart_uploads_parts s3_multipart_uploads_parts_upload_id_fkey; Type: FK CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.s3_multipart_uploads_parts
    ADD CONSTRAINT s3_multipart_uploads_parts_upload_id_fkey FOREIGN KEY (upload_id) REFERENCES storage.s3_multipart_uploads(id) ON DELETE CASCADE;


--
-- Name: audit_log_entries; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.audit_log_entries ENABLE ROW LEVEL SECURITY;

--
-- Name: flow_state; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.flow_state ENABLE ROW LEVEL SECURITY;

--
-- Name: identities; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.identities ENABLE ROW LEVEL SECURITY;

--
-- Name: instances; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.instances ENABLE ROW LEVEL SECURITY;

--
-- Name: mfa_amr_claims; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.mfa_amr_claims ENABLE ROW LEVEL SECURITY;

--
-- Name: mfa_challenges; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.mfa_challenges ENABLE ROW LEVEL SECURITY;

--
-- Name: mfa_factors; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.mfa_factors ENABLE ROW LEVEL SECURITY;

--
-- Name: one_time_tokens; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.one_time_tokens ENABLE ROW LEVEL SECURITY;

--
-- Name: refresh_tokens; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.refresh_tokens ENABLE ROW LEVEL SECURITY;

--
-- Name: saml_providers; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.saml_providers ENABLE ROW LEVEL SECURITY;

--
-- Name: saml_relay_states; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.saml_relay_states ENABLE ROW LEVEL SECURITY;

--
-- Name: schema_migrations; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.schema_migrations ENABLE ROW LEVEL SECURITY;

--
-- Name: sessions; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.sessions ENABLE ROW LEVEL SECURITY;

--
-- Name: sso_domains; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.sso_domains ENABLE ROW LEVEL SECURITY;

--
-- Name: sso_providers; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.sso_providers ENABLE ROW LEVEL SECURITY;

--
-- Name: users; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.users ENABLE ROW LEVEL SECURITY;

--
-- Name: profiles Admin can manage all profiles; Type: POLICY; Schema: public; Owner: supabase_admin
--

CREATE POLICY "Admin can manage all profiles" ON public.profiles USING ((EXISTS ( SELECT 1
   FROM public.profiles p
  WHERE ((p.user_id = auth.uid()) AND (p.role = 'admin'::public.user_role))))) WITH CHECK ((EXISTS ( SELECT 1
   FROM public.profiles p
  WHERE ((p.user_id = auth.uid()) AND (p.role = 'admin'::public.user_role)))));


--
-- Name: POLICY "Admin can manage all profiles" ON profiles; Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON POLICY "Admin can manage all profiles" ON public.profiles IS 'Admins have full access to all profiles - can view, create, update, and delete any profile';


--
-- Name: suppliers Admin can manage suppliers; Type: POLICY; Schema: public; Owner: supabase_admin
--

CREATE POLICY "Admin can manage suppliers" ON public.suppliers USING ((EXISTS ( SELECT 1
   FROM public.profiles
  WHERE ((profiles.user_id = auth.uid()) AND (profiles.role = 'admin'::public.user_role)))));


--
-- Name: product_categories Admins can do everything on product_categories; Type: POLICY; Schema: public; Owner: supabase_admin
--

CREATE POLICY "Admins can do everything on product_categories" ON public.product_categories USING ((EXISTS ( SELECT 1
   FROM public.profiles
  WHERE ((profiles.user_id = auth.uid()) AND (profiles.role = 'admin'::public.user_role)))));


--
-- Name: product_formulations Admins can do everything on product_formulations; Type: POLICY; Schema: public; Owner: supabase_admin
--

CREATE POLICY "Admins can do everything on product_formulations" ON public.product_formulations USING ((EXISTS ( SELECT 1
   FROM public.profiles
  WHERE ((profiles.user_id = auth.uid()) AND (profiles.role = 'admin'::public.user_role)))));


--
-- Name: product_sub_categories Admins can do everything on product_sub_categories; Type: POLICY; Schema: public; Owner: supabase_admin
--

CREATE POLICY "Admins can do everything on product_sub_categories" ON public.product_sub_categories USING ((EXISTS ( SELECT 1
   FROM public.profiles
  WHERE ((profiles.user_id = auth.uid()) AND (profiles.role = 'admin'::public.user_role)))));


--
-- Name: products Admins can do everything on products; Type: POLICY; Schema: public; Owner: supabase_admin
--

CREATE POLICY "Admins can do everything on products" ON public.products USING ((EXISTS ( SELECT 1
   FROM public.profiles
  WHERE ((profiles.user_id = auth.uid()) AND (profiles.role = 'admin'::public.user_role)))));


--
-- Name: profiles MR can view their own profile; Type: POLICY; Schema: public; Owner: supabase_admin
--

CREATE POLICY "MR can view their own profile" ON public.profiles FOR SELECT USING (((auth.uid() = user_id) AND (EXISTS ( SELECT 1
   FROM public.profiles p
  WHERE ((p.user_id = auth.uid()) AND (p.role = 'mr'::public.user_role))))));


--
-- Name: POLICY "MR can view their own profile" ON profiles; Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON POLICY "MR can view their own profile" ON public.profiles IS 'Medical Representatives can only view their own profile data';


--
-- Name: mr_sales_order_items MR users can create sales order items; Type: POLICY; Schema: public; Owner: supabase_admin
--

CREATE POLICY "MR users can create sales order items" ON public.mr_sales_order_items FOR INSERT TO authenticated WITH CHECK ((EXISTS ( SELECT 1
   FROM public.mr_sales_orders
  WHERE ((mr_sales_orders.id = mr_sales_order_items.order_id) AND (mr_sales_orders.mr_user_id = auth.uid())))));


--
-- Name: mr_sales_orders MR users can create sales orders; Type: POLICY; Schema: public; Owner: supabase_admin
--

CREATE POLICY "MR users can create sales orders" ON public.mr_sales_orders FOR INSERT TO authenticated WITH CHECK ((mr_user_id = auth.uid()));


--
-- Name: profiles Users can update their own profile; Type: POLICY; Schema: public; Owner: supabase_admin
--

CREATE POLICY "Users can update their own profile" ON public.profiles FOR UPDATE USING (((auth.uid() = user_id) AND (EXISTS ( SELECT 1
   FROM public.profiles p
  WHERE ((p.user_id = auth.uid()) AND (p.role = 'user'::public.user_role)))))) WITH CHECK (((auth.uid() = user_id) AND (EXISTS ( SELECT 1
   FROM public.profiles p
  WHERE ((p.user_id = auth.uid()) AND (p.role = 'user'::public.user_role))))));


--
-- Name: POLICY "Users can update their own profile" ON profiles; Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON POLICY "Users can update their own profile" ON public.profiles IS 'Regular users can only update their own profile data';


--
-- Name: suppliers Users can view active suppliers; Type: POLICY; Schema: public; Owner: supabase_admin
--

CREATE POLICY "Users can view active suppliers" ON public.suppliers FOR SELECT USING (((is_active = true) AND (EXISTS ( SELECT 1
   FROM public.profiles
  WHERE (profiles.user_id = auth.uid())))));


--
-- Name: profiles Users can view their own profile; Type: POLICY; Schema: public; Owner: supabase_admin
--

CREATE POLICY "Users can view their own profile" ON public.profiles FOR SELECT USING (((auth.uid() = user_id) AND (EXISTS ( SELECT 1
   FROM public.profiles p
  WHERE ((p.user_id = auth.uid()) AND (p.role = 'user'::public.user_role))))));


--
-- Name: POLICY "Users can view their own profile" ON profiles; Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON POLICY "Users can view their own profile" ON public.profiles IS 'Regular users can only view their own profile data';


--
-- Name: product_categories Workers can view product_categories; Type: POLICY; Schema: public; Owner: supabase_admin
--

CREATE POLICY "Workers can view product_categories" ON public.product_categories FOR SELECT USING ((EXISTS ( SELECT 1
   FROM public.profiles
  WHERE ((profiles.user_id = auth.uid()) AND (profiles.role = ANY (ARRAY['admin'::public.user_role, 'user'::public.user_role]))))));


--
-- Name: product_formulations Workers can view product_formulations; Type: POLICY; Schema: public; Owner: supabase_admin
--

CREATE POLICY "Workers can view product_formulations" ON public.product_formulations FOR SELECT USING ((EXISTS ( SELECT 1
   FROM public.profiles
  WHERE ((profiles.user_id = auth.uid()) AND (profiles.role = ANY (ARRAY['admin'::public.user_role, 'user'::public.user_role]))))));


--
-- Name: product_sub_categories Workers can view product_sub_categories; Type: POLICY; Schema: public; Owner: supabase_admin
--

CREATE POLICY "Workers can view product_sub_categories" ON public.product_sub_categories FOR SELECT USING ((EXISTS ( SELECT 1
   FROM public.profiles
  WHERE ((profiles.user_id = auth.uid()) AND (profiles.role = ANY (ARRAY['admin'::public.user_role, 'user'::public.user_role]))))));


--
-- Name: products Workers can view products; Type: POLICY; Schema: public; Owner: supabase_admin
--

CREATE POLICY "Workers can view products" ON public.products FOR SELECT USING ((EXISTS ( SELECT 1
   FROM public.profiles
  WHERE ((profiles.user_id = auth.uid()) AND (profiles.role = ANY (ARRAY['admin'::public.user_role, 'user'::public.user_role]))))));


--
-- Name: mr_stock_summary; Type: ROW SECURITY; Schema: public; Owner: supabase_admin
--

ALTER TABLE public.mr_stock_summary ENABLE ROW LEVEL SECURITY;

--
-- Name: mr_stock_summary mr_stock_summary_delete_policy; Type: POLICY; Schema: public; Owner: supabase_admin
--

CREATE POLICY mr_stock_summary_delete_policy ON public.mr_stock_summary FOR DELETE TO authenticated USING ((EXISTS ( SELECT 1
   FROM public.profiles
  WHERE ((profiles.user_id = auth.uid()) AND (profiles.role = 'admin'::public.user_role)))));


--
-- Name: mr_stock_summary mr_stock_summary_insert_policy; Type: POLICY; Schema: public; Owner: supabase_admin
--

CREATE POLICY mr_stock_summary_insert_policy ON public.mr_stock_summary FOR INSERT TO authenticated WITH CHECK ((EXISTS ( SELECT 1
   FROM public.profiles
  WHERE ((profiles.user_id = auth.uid()) AND (profiles.role = 'admin'::public.user_role)))));


--
-- Name: mr_stock_summary mr_stock_summary_select_policy; Type: POLICY; Schema: public; Owner: supabase_admin
--

CREATE POLICY mr_stock_summary_select_policy ON public.mr_stock_summary FOR SELECT TO authenticated USING (true);


--
-- Name: mr_stock_summary mr_stock_summary_update_policy; Type: POLICY; Schema: public; Owner: supabase_admin
--

CREATE POLICY mr_stock_summary_update_policy ON public.mr_stock_summary FOR UPDATE TO authenticated USING ((EXISTS ( SELECT 1
   FROM public.profiles
  WHERE ((profiles.user_id = auth.uid()) AND (profiles.role = 'admin'::public.user_role))))) WITH CHECK ((EXISTS ( SELECT 1
   FROM public.profiles
  WHERE ((profiles.user_id = auth.uid()) AND (profiles.role = 'admin'::public.user_role)))));


--
-- Name: packaging_templates; Type: ROW SECURITY; Schema: public; Owner: supabase_admin
--

ALTER TABLE public.packaging_templates ENABLE ROW LEVEL SECURITY;

--
-- Name: packaging_templates packaging_templates_delete_policy; Type: POLICY; Schema: public; Owner: supabase_admin
--

CREATE POLICY packaging_templates_delete_policy ON public.packaging_templates FOR DELETE TO authenticated USING ((EXISTS ( SELECT 1
   FROM public.profiles
  WHERE ((profiles.user_id = auth.uid()) AND (profiles.role = 'admin'::public.user_role)))));


--
-- Name: packaging_templates packaging_templates_insert_policy; Type: POLICY; Schema: public; Owner: supabase_admin
--

CREATE POLICY packaging_templates_insert_policy ON public.packaging_templates FOR INSERT TO authenticated WITH CHECK ((EXISTS ( SELECT 1
   FROM public.profiles
  WHERE ((profiles.user_id = auth.uid()) AND (profiles.role = 'admin'::public.user_role)))));


--
-- Name: packaging_templates packaging_templates_select_policy; Type: POLICY; Schema: public; Owner: supabase_admin
--

CREATE POLICY packaging_templates_select_policy ON public.packaging_templates FOR SELECT TO authenticated USING (true);


--
-- Name: packaging_templates packaging_templates_update_policy; Type: POLICY; Schema: public; Owner: supabase_admin
--

CREATE POLICY packaging_templates_update_policy ON public.packaging_templates FOR UPDATE TO authenticated USING ((EXISTS ( SELECT 1
   FROM public.profiles
  WHERE ((profiles.user_id = auth.uid()) AND (profiles.role = 'admin'::public.user_role))))) WITH CHECK ((EXISTS ( SELECT 1
   FROM public.profiles
  WHERE ((profiles.user_id = auth.uid()) AND (profiles.role = 'admin'::public.user_role)))));


--
-- Name: product_batches; Type: ROW SECURITY; Schema: public; Owner: supabase_admin
--

ALTER TABLE public.product_batches ENABLE ROW LEVEL SECURITY;

--
-- Name: product_batches product_batches_delete_policy; Type: POLICY; Schema: public; Owner: supabase_admin
--

CREATE POLICY product_batches_delete_policy ON public.product_batches FOR DELETE TO authenticated USING ((EXISTS ( SELECT 1
   FROM public.profiles
  WHERE ((profiles.user_id = auth.uid()) AND (profiles.role = 'admin'::public.user_role)))));


--
-- Name: product_batches product_batches_insert_policy; Type: POLICY; Schema: public; Owner: supabase_admin
--

CREATE POLICY product_batches_insert_policy ON public.product_batches FOR INSERT TO authenticated WITH CHECK ((EXISTS ( SELECT 1
   FROM public.profiles
  WHERE ((profiles.user_id = auth.uid()) AND (profiles.role = 'admin'::public.user_role)))));


--
-- Name: product_batches product_batches_select_policy; Type: POLICY; Schema: public; Owner: supabase_admin
--

CREATE POLICY product_batches_select_policy ON public.product_batches FOR SELECT TO authenticated USING (true);


--
-- Name: product_batches product_batches_update_policy; Type: POLICY; Schema: public; Owner: supabase_admin
--

CREATE POLICY product_batches_update_policy ON public.product_batches FOR UPDATE TO authenticated USING ((EXISTS ( SELECT 1
   FROM public.profiles
  WHERE ((profiles.user_id = auth.uid()) AND (profiles.role = 'admin'::public.user_role))))) WITH CHECK ((EXISTS ( SELECT 1
   FROM public.profiles
  WHERE ((profiles.user_id = auth.uid()) AND (profiles.role = 'admin'::public.user_role)))));


--
-- Name: product_categories; Type: ROW SECURITY; Schema: public; Owner: supabase_admin
--

ALTER TABLE public.product_categories ENABLE ROW LEVEL SECURITY;

--
-- Name: product_categories product_categories_delete_policy; Type: POLICY; Schema: public; Owner: supabase_admin
--

CREATE POLICY product_categories_delete_policy ON public.product_categories FOR DELETE TO authenticated USING ((EXISTS ( SELECT 1
   FROM public.profiles
  WHERE ((profiles.user_id = auth.uid()) AND (profiles.role = 'admin'::public.user_role)))));


--
-- Name: product_categories product_categories_insert_policy; Type: POLICY; Schema: public; Owner: supabase_admin
--

CREATE POLICY product_categories_insert_policy ON public.product_categories FOR INSERT TO authenticated WITH CHECK ((EXISTS ( SELECT 1
   FROM public.profiles
  WHERE ((profiles.user_id = auth.uid()) AND (profiles.role = 'admin'::public.user_role)))));


--
-- Name: product_categories product_categories_select_policy; Type: POLICY; Schema: public; Owner: supabase_admin
--

CREATE POLICY product_categories_select_policy ON public.product_categories FOR SELECT TO authenticated USING (true);


--
-- Name: product_categories product_categories_update_policy; Type: POLICY; Schema: public; Owner: supabase_admin
--

CREATE POLICY product_categories_update_policy ON public.product_categories FOR UPDATE TO authenticated USING ((EXISTS ( SELECT 1
   FROM public.profiles
  WHERE ((profiles.user_id = auth.uid()) AND (profiles.role = 'admin'::public.user_role))))) WITH CHECK ((EXISTS ( SELECT 1
   FROM public.profiles
  WHERE ((profiles.user_id = auth.uid()) AND (profiles.role = 'admin'::public.user_role)))));


--
-- Name: product_formulations; Type: ROW SECURITY; Schema: public; Owner: supabase_admin
--

ALTER TABLE public.product_formulations ENABLE ROW LEVEL SECURITY;

--
-- Name: product_formulations product_formulations_delete_policy; Type: POLICY; Schema: public; Owner: supabase_admin
--

CREATE POLICY product_formulations_delete_policy ON public.product_formulations FOR DELETE TO authenticated USING ((EXISTS ( SELECT 1
   FROM public.profiles
  WHERE ((profiles.user_id = auth.uid()) AND (profiles.role = 'admin'::public.user_role)))));


--
-- Name: product_formulations product_formulations_insert_policy; Type: POLICY; Schema: public; Owner: supabase_admin
--

CREATE POLICY product_formulations_insert_policy ON public.product_formulations FOR INSERT TO authenticated WITH CHECK ((EXISTS ( SELECT 1
   FROM public.profiles
  WHERE ((profiles.user_id = auth.uid()) AND (profiles.role = 'admin'::public.user_role)))));


--
-- Name: product_formulations product_formulations_select_policy; Type: POLICY; Schema: public; Owner: supabase_admin
--

CREATE POLICY product_formulations_select_policy ON public.product_formulations FOR SELECT TO authenticated USING (true);


--
-- Name: product_formulations product_formulations_update_policy; Type: POLICY; Schema: public; Owner: supabase_admin
--

CREATE POLICY product_formulations_update_policy ON public.product_formulations FOR UPDATE TO authenticated USING ((EXISTS ( SELECT 1
   FROM public.profiles
  WHERE ((profiles.user_id = auth.uid()) AND (profiles.role = 'admin'::public.user_role))))) WITH CHECK ((EXISTS ( SELECT 1
   FROM public.profiles
  WHERE ((profiles.user_id = auth.uid()) AND (profiles.role = 'admin'::public.user_role)))));


--
-- Name: product_packaging_units; Type: ROW SECURITY; Schema: public; Owner: supabase_admin
--

ALTER TABLE public.product_packaging_units ENABLE ROW LEVEL SECURITY;

--
-- Name: product_packaging_units product_packaging_units_delete_policy; Type: POLICY; Schema: public; Owner: supabase_admin
--

CREATE POLICY product_packaging_units_delete_policy ON public.product_packaging_units FOR DELETE TO authenticated USING ((EXISTS ( SELECT 1
   FROM public.profiles
  WHERE ((profiles.user_id = auth.uid()) AND (profiles.role = 'admin'::public.user_role)))));


--
-- Name: product_packaging_units product_packaging_units_insert_policy; Type: POLICY; Schema: public; Owner: supabase_admin
--

CREATE POLICY product_packaging_units_insert_policy ON public.product_packaging_units FOR INSERT TO authenticated WITH CHECK ((EXISTS ( SELECT 1
   FROM public.profiles
  WHERE ((profiles.user_id = auth.uid()) AND (profiles.role = 'admin'::public.user_role)))));


--
-- Name: product_packaging_units product_packaging_units_select_policy; Type: POLICY; Schema: public; Owner: supabase_admin
--

CREATE POLICY product_packaging_units_select_policy ON public.product_packaging_units FOR SELECT TO authenticated USING (true);


--
-- Name: product_packaging_units product_packaging_units_update_policy; Type: POLICY; Schema: public; Owner: supabase_admin
--

CREATE POLICY product_packaging_units_update_policy ON public.product_packaging_units FOR UPDATE TO authenticated USING ((EXISTS ( SELECT 1
   FROM public.profiles
  WHERE ((profiles.user_id = auth.uid()) AND (profiles.role = 'admin'::public.user_role))))) WITH CHECK ((EXISTS ( SELECT 1
   FROM public.profiles
  WHERE ((profiles.user_id = auth.uid()) AND (profiles.role = 'admin'::public.user_role)))));


--
-- Name: product_sub_categories; Type: ROW SECURITY; Schema: public; Owner: supabase_admin
--

ALTER TABLE public.product_sub_categories ENABLE ROW LEVEL SECURITY;

--
-- Name: product_sub_categories product_sub_categories_delete_policy; Type: POLICY; Schema: public; Owner: supabase_admin
--

CREATE POLICY product_sub_categories_delete_policy ON public.product_sub_categories FOR DELETE TO authenticated USING ((EXISTS ( SELECT 1
   FROM public.profiles
  WHERE ((profiles.user_id = auth.uid()) AND (profiles.role = 'admin'::public.user_role)))));


--
-- Name: product_sub_categories product_sub_categories_insert_policy; Type: POLICY; Schema: public; Owner: supabase_admin
--

CREATE POLICY product_sub_categories_insert_policy ON public.product_sub_categories FOR INSERT TO authenticated WITH CHECK ((EXISTS ( SELECT 1
   FROM public.profiles
  WHERE ((profiles.user_id = auth.uid()) AND (profiles.role = 'admin'::public.user_role)))));


--
-- Name: product_sub_categories product_sub_categories_select_policy; Type: POLICY; Schema: public; Owner: supabase_admin
--

CREATE POLICY product_sub_categories_select_policy ON public.product_sub_categories FOR SELECT TO authenticated USING (true);


--
-- Name: product_sub_categories product_sub_categories_update_policy; Type: POLICY; Schema: public; Owner: supabase_admin
--

CREATE POLICY product_sub_categories_update_policy ON public.product_sub_categories FOR UPDATE TO authenticated USING ((EXISTS ( SELECT 1
   FROM public.profiles
  WHERE ((profiles.user_id = auth.uid()) AND (profiles.role = 'admin'::public.user_role))))) WITH CHECK ((EXISTS ( SELECT 1
   FROM public.profiles
  WHERE ((profiles.user_id = auth.uid()) AND (profiles.role = 'admin'::public.user_role)))));


--
-- Name: products; Type: ROW SECURITY; Schema: public; Owner: supabase_admin
--

ALTER TABLE public.products ENABLE ROW LEVEL SECURITY;

--
-- Name: products products_delete_policy; Type: POLICY; Schema: public; Owner: supabase_admin
--

CREATE POLICY products_delete_policy ON public.products FOR DELETE TO authenticated USING ((EXISTS ( SELECT 1
   FROM public.profiles
  WHERE ((profiles.user_id = auth.uid()) AND (profiles.role = 'admin'::public.user_role)))));


--
-- Name: products products_insert_policy; Type: POLICY; Schema: public; Owner: supabase_admin
--

CREATE POLICY products_insert_policy ON public.products FOR INSERT TO authenticated WITH CHECK ((EXISTS ( SELECT 1
   FROM public.profiles
  WHERE ((profiles.user_id = auth.uid()) AND (profiles.role = 'admin'::public.user_role)))));


--
-- Name: products products_select_policy; Type: POLICY; Schema: public; Owner: supabase_admin
--

CREATE POLICY products_select_policy ON public.products FOR SELECT TO authenticated USING (true);


--
-- Name: products_stock_status; Type: ROW SECURITY; Schema: public; Owner: supabase_admin
--

ALTER TABLE public.products_stock_status ENABLE ROW LEVEL SECURITY;

--
-- Name: products_stock_status products_stock_status_delete_policy; Type: POLICY; Schema: public; Owner: supabase_admin
--

CREATE POLICY products_stock_status_delete_policy ON public.products_stock_status FOR DELETE TO authenticated USING ((EXISTS ( SELECT 1
   FROM public.profiles
  WHERE ((profiles.user_id = auth.uid()) AND (profiles.role = 'admin'::public.user_role)))));


--
-- Name: products_stock_status products_stock_status_insert_policy; Type: POLICY; Schema: public; Owner: supabase_admin
--

CREATE POLICY products_stock_status_insert_policy ON public.products_stock_status FOR INSERT TO authenticated WITH CHECK ((EXISTS ( SELECT 1
   FROM public.profiles
  WHERE ((profiles.user_id = auth.uid()) AND (profiles.role = 'admin'::public.user_role)))));


--
-- Name: products_stock_status products_stock_status_select_policy; Type: POLICY; Schema: public; Owner: supabase_admin
--

CREATE POLICY products_stock_status_select_policy ON public.products_stock_status FOR SELECT TO authenticated USING (true);


--
-- Name: products_stock_status products_stock_status_update_policy; Type: POLICY; Schema: public; Owner: supabase_admin
--

CREATE POLICY products_stock_status_update_policy ON public.products_stock_status FOR UPDATE TO authenticated USING ((EXISTS ( SELECT 1
   FROM public.profiles
  WHERE ((profiles.user_id = auth.uid()) AND (profiles.role = 'admin'::public.user_role))))) WITH CHECK ((EXISTS ( SELECT 1
   FROM public.profiles
  WHERE ((profiles.user_id = auth.uid()) AND (profiles.role = 'admin'::public.user_role)))));


--
-- Name: products products_update_policy; Type: POLICY; Schema: public; Owner: supabase_admin
--

CREATE POLICY products_update_policy ON public.products FOR UPDATE TO authenticated USING ((EXISTS ( SELECT 1
   FROM public.profiles
  WHERE ((profiles.user_id = auth.uid()) AND (profiles.role = 'admin'::public.user_role))))) WITH CHECK ((EXISTS ( SELECT 1
   FROM public.profiles
  WHERE ((profiles.user_id = auth.uid()) AND (profiles.role = 'admin'::public.user_role)))));


--
-- Name: stock_adjustments; Type: ROW SECURITY; Schema: public; Owner: supabase_admin
--

ALTER TABLE public.stock_adjustments ENABLE ROW LEVEL SECURITY;

--
-- Name: stock_adjustments stock_adjustments_delete_policy; Type: POLICY; Schema: public; Owner: supabase_admin
--

CREATE POLICY stock_adjustments_delete_policy ON public.stock_adjustments FOR DELETE TO authenticated USING ((EXISTS ( SELECT 1
   FROM public.profiles
  WHERE ((profiles.user_id = auth.uid()) AND (profiles.role = 'admin'::public.user_role)))));


--
-- Name: stock_adjustments stock_adjustments_insert_policy; Type: POLICY; Schema: public; Owner: supabase_admin
--

CREATE POLICY stock_adjustments_insert_policy ON public.stock_adjustments FOR INSERT TO authenticated WITH CHECK ((EXISTS ( SELECT 1
   FROM public.profiles
  WHERE ((profiles.user_id = auth.uid()) AND (profiles.role = 'admin'::public.user_role)))));


--
-- Name: stock_adjustments stock_adjustments_select_policy; Type: POLICY; Schema: public; Owner: supabase_admin
--

CREATE POLICY stock_adjustments_select_policy ON public.stock_adjustments FOR SELECT TO authenticated USING (true);


--
-- Name: stock_adjustments stock_adjustments_update_policy; Type: POLICY; Schema: public; Owner: supabase_admin
--

CREATE POLICY stock_adjustments_update_policy ON public.stock_adjustments FOR UPDATE TO authenticated USING ((EXISTS ( SELECT 1
   FROM public.profiles
  WHERE ((profiles.user_id = auth.uid()) AND (profiles.role = 'admin'::public.user_role))))) WITH CHECK ((EXISTS ( SELECT 1
   FROM public.profiles
  WHERE ((profiles.user_id = auth.uid()) AND (profiles.role = 'admin'::public.user_role)))));


--
-- Name: stock_purchases; Type: ROW SECURITY; Schema: public; Owner: supabase_admin
--

ALTER TABLE public.stock_purchases ENABLE ROW LEVEL SECURITY;

--
-- Name: stock_purchases stock_purchases_delete_policy; Type: POLICY; Schema: public; Owner: supabase_admin
--

CREATE POLICY stock_purchases_delete_policy ON public.stock_purchases FOR DELETE TO authenticated USING ((EXISTS ( SELECT 1
   FROM public.profiles
  WHERE ((profiles.user_id = auth.uid()) AND (profiles.role = 'admin'::public.user_role)))));


--
-- Name: stock_purchases stock_purchases_insert_policy; Type: POLICY; Schema: public; Owner: supabase_admin
--

CREATE POLICY stock_purchases_insert_policy ON public.stock_purchases FOR INSERT TO authenticated WITH CHECK ((EXISTS ( SELECT 1
   FROM public.profiles
  WHERE ((profiles.user_id = auth.uid()) AND (profiles.role = 'admin'::public.user_role)))));


--
-- Name: stock_purchases stock_purchases_select_policy; Type: POLICY; Schema: public; Owner: supabase_admin
--

CREATE POLICY stock_purchases_select_policy ON public.stock_purchases FOR SELECT TO authenticated USING (true);


--
-- Name: stock_purchases stock_purchases_update_policy; Type: POLICY; Schema: public; Owner: supabase_admin
--

CREATE POLICY stock_purchases_update_policy ON public.stock_purchases FOR UPDATE TO authenticated USING ((EXISTS ( SELECT 1
   FROM public.profiles
  WHERE ((profiles.user_id = auth.uid()) AND (profiles.role = 'admin'::public.user_role))))) WITH CHECK ((EXISTS ( SELECT 1
   FROM public.profiles
  WHERE ((profiles.user_id = auth.uid()) AND (profiles.role = 'admin'::public.user_role)))));


--
-- Name: stock_sales; Type: ROW SECURITY; Schema: public; Owner: supabase_admin
--

ALTER TABLE public.stock_sales ENABLE ROW LEVEL SECURITY;

--
-- Name: stock_sales stock_sales_delete_policy; Type: POLICY; Schema: public; Owner: supabase_admin
--

CREATE POLICY stock_sales_delete_policy ON public.stock_sales FOR DELETE TO authenticated USING ((EXISTS ( SELECT 1
   FROM public.profiles
  WHERE ((profiles.user_id = auth.uid()) AND (profiles.role = 'admin'::public.user_role)))));


--
-- Name: stock_sales stock_sales_insert_policy; Type: POLICY; Schema: public; Owner: supabase_admin
--

CREATE POLICY stock_sales_insert_policy ON public.stock_sales FOR INSERT TO authenticated WITH CHECK ((EXISTS ( SELECT 1
   FROM public.profiles
  WHERE ((profiles.user_id = auth.uid()) AND (profiles.role = 'admin'::public.user_role)))));


--
-- Name: stock_sales stock_sales_select_policy; Type: POLICY; Schema: public; Owner: supabase_admin
--

CREATE POLICY stock_sales_select_policy ON public.stock_sales FOR SELECT TO authenticated USING (true);


--
-- Name: stock_sales stock_sales_update_policy; Type: POLICY; Schema: public; Owner: supabase_admin
--

CREATE POLICY stock_sales_update_policy ON public.stock_sales FOR UPDATE TO authenticated USING ((EXISTS ( SELECT 1
   FROM public.profiles
  WHERE ((profiles.user_id = auth.uid()) AND (profiles.role = 'admin'::public.user_role))))) WITH CHECK ((EXISTS ( SELECT 1
   FROM public.profiles
  WHERE ((profiles.user_id = auth.uid()) AND (profiles.role = 'admin'::public.user_role)))));


--
-- Name: stock_transactions; Type: ROW SECURITY; Schema: public; Owner: supabase_admin
--

ALTER TABLE public.stock_transactions ENABLE ROW LEVEL SECURITY;

--
-- Name: stock_transactions stock_transactions_delete_policy; Type: POLICY; Schema: public; Owner: supabase_admin
--

CREATE POLICY stock_transactions_delete_policy ON public.stock_transactions FOR DELETE TO authenticated USING ((EXISTS ( SELECT 1
   FROM public.profiles
  WHERE ((profiles.user_id = auth.uid()) AND (profiles.role = 'admin'::public.user_role)))));


--
-- Name: stock_transactions stock_transactions_insert_policy; Type: POLICY; Schema: public; Owner: supabase_admin
--

CREATE POLICY stock_transactions_insert_policy ON public.stock_transactions FOR INSERT TO authenticated WITH CHECK ((EXISTS ( SELECT 1
   FROM public.profiles
  WHERE ((profiles.user_id = auth.uid()) AND (profiles.role = 'admin'::public.user_role)))));


--
-- Name: stock_transactions stock_transactions_select_policy; Type: POLICY; Schema: public; Owner: supabase_admin
--

CREATE POLICY stock_transactions_select_policy ON public.stock_transactions FOR SELECT TO authenticated USING (true);


--
-- Name: stock_transactions stock_transactions_update_policy; Type: POLICY; Schema: public; Owner: supabase_admin
--

CREATE POLICY stock_transactions_update_policy ON public.stock_transactions FOR UPDATE TO authenticated USING ((EXISTS ( SELECT 1
   FROM public.profiles
  WHERE ((profiles.user_id = auth.uid()) AND (profiles.role = 'admin'::public.user_role))))) WITH CHECK ((EXISTS ( SELECT 1
   FROM public.profiles
  WHERE ((profiles.user_id = auth.uid()) AND (profiles.role = 'admin'::public.user_role)))));


--
-- Name: suppliers; Type: ROW SECURITY; Schema: public; Owner: supabase_admin
--

ALTER TABLE public.suppliers ENABLE ROW LEVEL SECURITY;

--
-- Name: messages; Type: ROW SECURITY; Schema: realtime; Owner: supabase_realtime_admin
--

ALTER TABLE realtime.messages ENABLE ROW LEVEL SECURITY;

--
-- Name: buckets; Type: ROW SECURITY; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE storage.buckets ENABLE ROW LEVEL SECURITY;

--
-- Name: migrations; Type: ROW SECURITY; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE storage.migrations ENABLE ROW LEVEL SECURITY;

--
-- Name: objects; Type: ROW SECURITY; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE storage.objects ENABLE ROW LEVEL SECURITY;

--
-- Name: s3_multipart_uploads; Type: ROW SECURITY; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE storage.s3_multipart_uploads ENABLE ROW LEVEL SECURITY;

--
-- Name: s3_multipart_uploads_parts; Type: ROW SECURITY; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE storage.s3_multipart_uploads_parts ENABLE ROW LEVEL SECURITY;

--
-- Name: supabase_realtime; Type: PUBLICATION; Schema: -; Owner: postgres
--

CREATE PUBLICATION supabase_realtime WITH (publish = 'insert, update, delete, truncate');


ALTER PUBLICATION supabase_realtime OWNER TO postgres;

--
-- Name: supabase_realtime doctors; Type: PUBLICATION TABLE; Schema: public; Owner: postgres
--

ALTER PUBLICATION supabase_realtime ADD TABLE ONLY public.doctors;


--
-- Name: supabase_realtime mr_sales_orders; Type: PUBLICATION TABLE; Schema: public; Owner: postgres
--

ALTER PUBLICATION supabase_realtime ADD TABLE ONLY public.mr_sales_orders;


--
-- Name: supabase_realtime mr_stock_summary; Type: PUBLICATION TABLE; Schema: public; Owner: postgres
--

ALTER PUBLICATION supabase_realtime ADD TABLE ONLY public.mr_stock_summary;


--
-- Name: supabase_realtime stock_adjustments; Type: PUBLICATION TABLE; Schema: public; Owner: postgres
--

ALTER PUBLICATION supabase_realtime ADD TABLE ONLY public.stock_adjustments;


--
-- Name: supabase_realtime stock_purchases; Type: PUBLICATION TABLE; Schema: public; Owner: postgres
--

ALTER PUBLICATION supabase_realtime ADD TABLE ONLY public.stock_purchases;


--
-- Name: supabase_realtime stock_sales; Type: PUBLICATION TABLE; Schema: public; Owner: postgres
--

ALTER PUBLICATION supabase_realtime ADD TABLE ONLY public.stock_sales;


--
-- Name: SCHEMA auth; Type: ACL; Schema: -; Owner: supabase_admin
--

GRANT USAGE ON SCHEMA auth TO anon;
GRANT USAGE ON SCHEMA auth TO authenticated;
GRANT USAGE ON SCHEMA auth TO service_role;
GRANT ALL ON SCHEMA auth TO supabase_auth_admin;
GRANT ALL ON SCHEMA auth TO dashboard_user;
GRANT ALL ON SCHEMA auth TO postgres;


--
-- Name: SCHEMA extensions; Type: ACL; Schema: -; Owner: postgres
--

GRANT USAGE ON SCHEMA extensions TO anon;
GRANT USAGE ON SCHEMA extensions TO authenticated;
GRANT USAGE ON SCHEMA extensions TO service_role;
GRANT ALL ON SCHEMA extensions TO dashboard_user;


--
-- Name: SCHEMA net; Type: ACL; Schema: -; Owner: supabase_admin
--

GRANT USAGE ON SCHEMA net TO supabase_functions_admin;
GRANT USAGE ON SCHEMA net TO postgres;
GRANT USAGE ON SCHEMA net TO anon;
GRANT USAGE ON SCHEMA net TO authenticated;
GRANT USAGE ON SCHEMA net TO service_role;


--
-- Name: SCHEMA public; Type: ACL; Schema: -; Owner: pg_database_owner
--

GRANT USAGE ON SCHEMA public TO postgres;
GRANT USAGE ON SCHEMA public TO anon;
GRANT USAGE ON SCHEMA public TO authenticated;
GRANT USAGE ON SCHEMA public TO service_role;


--
-- Name: SCHEMA realtime; Type: ACL; Schema: -; Owner: supabase_admin
--

GRANT USAGE ON SCHEMA realtime TO postgres;
GRANT USAGE ON SCHEMA realtime TO anon;
GRANT USAGE ON SCHEMA realtime TO authenticated;
GRANT USAGE ON SCHEMA realtime TO service_role;
GRANT ALL ON SCHEMA realtime TO supabase_realtime_admin;


--
-- Name: SCHEMA storage; Type: ACL; Schema: -; Owner: supabase_admin
--

GRANT ALL ON SCHEMA storage TO postgres;
GRANT USAGE ON SCHEMA storage TO anon;
GRANT USAGE ON SCHEMA storage TO authenticated;
GRANT USAGE ON SCHEMA storage TO service_role;
GRANT ALL ON SCHEMA storage TO supabase_storage_admin;
GRANT ALL ON SCHEMA storage TO dashboard_user;


--
-- Name: SCHEMA supabase_functions; Type: ACL; Schema: -; Owner: supabase_admin
--

GRANT USAGE ON SCHEMA supabase_functions TO postgres;
GRANT USAGE ON SCHEMA supabase_functions TO anon;
GRANT USAGE ON SCHEMA supabase_functions TO authenticated;
GRANT USAGE ON SCHEMA supabase_functions TO service_role;
GRANT ALL ON SCHEMA supabase_functions TO supabase_functions_admin;


--
-- Name: FUNCTION email(); Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON FUNCTION auth.email() TO dashboard_user;


--
-- Name: FUNCTION jwt(); Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON FUNCTION auth.jwt() TO postgres;
GRANT ALL ON FUNCTION auth.jwt() TO dashboard_user;


--
-- Name: FUNCTION role(); Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON FUNCTION auth.role() TO dashboard_user;


--
-- Name: FUNCTION uid(); Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON FUNCTION auth.uid() TO dashboard_user;


--
-- Name: FUNCTION algorithm_sign(signables text, secret text, algorithm text); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.algorithm_sign(signables text, secret text, algorithm text) TO dashboard_user;
GRANT ALL ON FUNCTION extensions.algorithm_sign(signables text, secret text, algorithm text) TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION armor(bytea); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.armor(bytea) TO dashboard_user;
GRANT ALL ON FUNCTION extensions.armor(bytea) TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION armor(bytea, text[], text[]); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.armor(bytea, text[], text[]) TO dashboard_user;
GRANT ALL ON FUNCTION extensions.armor(bytea, text[], text[]) TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION crypt(text, text); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.crypt(text, text) TO dashboard_user;
GRANT ALL ON FUNCTION extensions.crypt(text, text) TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION dearmor(text); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.dearmor(text) TO dashboard_user;
GRANT ALL ON FUNCTION extensions.dearmor(text) TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION decrypt(bytea, bytea, text); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.decrypt(bytea, bytea, text) TO dashboard_user;
GRANT ALL ON FUNCTION extensions.decrypt(bytea, bytea, text) TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION decrypt_iv(bytea, bytea, bytea, text); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.decrypt_iv(bytea, bytea, bytea, text) TO dashboard_user;
GRANT ALL ON FUNCTION extensions.decrypt_iv(bytea, bytea, bytea, text) TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION digest(bytea, text); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.digest(bytea, text) TO dashboard_user;
GRANT ALL ON FUNCTION extensions.digest(bytea, text) TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION digest(text, text); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.digest(text, text) TO dashboard_user;
GRANT ALL ON FUNCTION extensions.digest(text, text) TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION encrypt(bytea, bytea, text); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.encrypt(bytea, bytea, text) TO dashboard_user;
GRANT ALL ON FUNCTION extensions.encrypt(bytea, bytea, text) TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION encrypt_iv(bytea, bytea, bytea, text); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.encrypt_iv(bytea, bytea, bytea, text) TO dashboard_user;
GRANT ALL ON FUNCTION extensions.encrypt_iv(bytea, bytea, bytea, text) TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION gen_random_bytes(integer); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.gen_random_bytes(integer) TO dashboard_user;
GRANT ALL ON FUNCTION extensions.gen_random_bytes(integer) TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION gen_random_uuid(); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.gen_random_uuid() TO dashboard_user;
GRANT ALL ON FUNCTION extensions.gen_random_uuid() TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION gen_salt(text); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.gen_salt(text) TO dashboard_user;
GRANT ALL ON FUNCTION extensions.gen_salt(text) TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION gen_salt(text, integer); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.gen_salt(text, integer) TO dashboard_user;
GRANT ALL ON FUNCTION extensions.gen_salt(text, integer) TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION grant_pg_cron_access(); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.grant_pg_cron_access() FROM postgres;
GRANT ALL ON FUNCTION extensions.grant_pg_cron_access() TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.grant_pg_cron_access() TO dashboard_user;


--
-- Name: FUNCTION grant_pg_graphql_access(); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.grant_pg_graphql_access() TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION grant_pg_net_access(); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.grant_pg_net_access() FROM postgres;
GRANT ALL ON FUNCTION extensions.grant_pg_net_access() TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.grant_pg_net_access() TO dashboard_user;


--
-- Name: FUNCTION hmac(bytea, bytea, text); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.hmac(bytea, bytea, text) TO dashboard_user;
GRANT ALL ON FUNCTION extensions.hmac(bytea, bytea, text) TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION hmac(text, text, text); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.hmac(text, text, text) TO dashboard_user;
GRANT ALL ON FUNCTION extensions.hmac(text, text, text) TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION pg_stat_statements(showtext boolean, OUT userid oid, OUT dbid oid, OUT toplevel boolean, OUT queryid bigint, OUT query text, OUT plans bigint, OUT total_plan_time double precision, OUT min_plan_time double precision, OUT max_plan_time double precision, OUT mean_plan_time double precision, OUT stddev_plan_time double precision, OUT calls bigint, OUT total_exec_time double precision, OUT min_exec_time double precision, OUT max_exec_time double precision, OUT mean_exec_time double precision, OUT stddev_exec_time double precision, OUT rows bigint, OUT shared_blks_hit bigint, OUT shared_blks_read bigint, OUT shared_blks_dirtied bigint, OUT shared_blks_written bigint, OUT local_blks_hit bigint, OUT local_blks_read bigint, OUT local_blks_dirtied bigint, OUT local_blks_written bigint, OUT temp_blks_read bigint, OUT temp_blks_written bigint, OUT blk_read_time double precision, OUT blk_write_time double precision, OUT temp_blk_read_time double precision, OUT temp_blk_write_time double precision, OUT wal_records bigint, OUT wal_fpi bigint, OUT wal_bytes numeric, OUT jit_functions bigint, OUT jit_generation_time double precision, OUT jit_inlining_count bigint, OUT jit_inlining_time double precision, OUT jit_optimization_count bigint, OUT jit_optimization_time double precision, OUT jit_emission_count bigint, OUT jit_emission_time double precision); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.pg_stat_statements(showtext boolean, OUT userid oid, OUT dbid oid, OUT toplevel boolean, OUT queryid bigint, OUT query text, OUT plans bigint, OUT total_plan_time double precision, OUT min_plan_time double precision, OUT max_plan_time double precision, OUT mean_plan_time double precision, OUT stddev_plan_time double precision, OUT calls bigint, OUT total_exec_time double precision, OUT min_exec_time double precision, OUT max_exec_time double precision, OUT mean_exec_time double precision, OUT stddev_exec_time double precision, OUT rows bigint, OUT shared_blks_hit bigint, OUT shared_blks_read bigint, OUT shared_blks_dirtied bigint, OUT shared_blks_written bigint, OUT local_blks_hit bigint, OUT local_blks_read bigint, OUT local_blks_dirtied bigint, OUT local_blks_written bigint, OUT temp_blks_read bigint, OUT temp_blks_written bigint, OUT blk_read_time double precision, OUT blk_write_time double precision, OUT temp_blk_read_time double precision, OUT temp_blk_write_time double precision, OUT wal_records bigint, OUT wal_fpi bigint, OUT wal_bytes numeric, OUT jit_functions bigint, OUT jit_generation_time double precision, OUT jit_inlining_count bigint, OUT jit_inlining_time double precision, OUT jit_optimization_count bigint, OUT jit_optimization_time double precision, OUT jit_emission_count bigint, OUT jit_emission_time double precision) TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION pg_stat_statements_info(OUT dealloc bigint, OUT stats_reset timestamp with time zone); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.pg_stat_statements_info(OUT dealloc bigint, OUT stats_reset timestamp with time zone) TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION pg_stat_statements_reset(userid oid, dbid oid, queryid bigint); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.pg_stat_statements_reset(userid oid, dbid oid, queryid bigint) TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION pgp_armor_headers(text, OUT key text, OUT value text); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.pgp_armor_headers(text, OUT key text, OUT value text) TO dashboard_user;
GRANT ALL ON FUNCTION extensions.pgp_armor_headers(text, OUT key text, OUT value text) TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION pgp_key_id(bytea); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.pgp_key_id(bytea) TO dashboard_user;
GRANT ALL ON FUNCTION extensions.pgp_key_id(bytea) TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION pgp_pub_decrypt(bytea, bytea); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.pgp_pub_decrypt(bytea, bytea) TO dashboard_user;
GRANT ALL ON FUNCTION extensions.pgp_pub_decrypt(bytea, bytea) TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION pgp_pub_decrypt(bytea, bytea, text); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.pgp_pub_decrypt(bytea, bytea, text) TO dashboard_user;
GRANT ALL ON FUNCTION extensions.pgp_pub_decrypt(bytea, bytea, text) TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION pgp_pub_decrypt(bytea, bytea, text, text); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.pgp_pub_decrypt(bytea, bytea, text, text) TO dashboard_user;
GRANT ALL ON FUNCTION extensions.pgp_pub_decrypt(bytea, bytea, text, text) TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION pgp_pub_decrypt_bytea(bytea, bytea); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.pgp_pub_decrypt_bytea(bytea, bytea) TO dashboard_user;
GRANT ALL ON FUNCTION extensions.pgp_pub_decrypt_bytea(bytea, bytea) TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION pgp_pub_decrypt_bytea(bytea, bytea, text); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.pgp_pub_decrypt_bytea(bytea, bytea, text) TO dashboard_user;
GRANT ALL ON FUNCTION extensions.pgp_pub_decrypt_bytea(bytea, bytea, text) TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION pgp_pub_decrypt_bytea(bytea, bytea, text, text); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.pgp_pub_decrypt_bytea(bytea, bytea, text, text) TO dashboard_user;
GRANT ALL ON FUNCTION extensions.pgp_pub_decrypt_bytea(bytea, bytea, text, text) TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION pgp_pub_encrypt(text, bytea); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.pgp_pub_encrypt(text, bytea) TO dashboard_user;
GRANT ALL ON FUNCTION extensions.pgp_pub_encrypt(text, bytea) TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION pgp_pub_encrypt(text, bytea, text); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.pgp_pub_encrypt(text, bytea, text) TO dashboard_user;
GRANT ALL ON FUNCTION extensions.pgp_pub_encrypt(text, bytea, text) TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION pgp_pub_encrypt_bytea(bytea, bytea); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.pgp_pub_encrypt_bytea(bytea, bytea) TO dashboard_user;
GRANT ALL ON FUNCTION extensions.pgp_pub_encrypt_bytea(bytea, bytea) TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION pgp_pub_encrypt_bytea(bytea, bytea, text); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.pgp_pub_encrypt_bytea(bytea, bytea, text) TO dashboard_user;
GRANT ALL ON FUNCTION extensions.pgp_pub_encrypt_bytea(bytea, bytea, text) TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION pgp_sym_decrypt(bytea, text); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.pgp_sym_decrypt(bytea, text) TO dashboard_user;
GRANT ALL ON FUNCTION extensions.pgp_sym_decrypt(bytea, text) TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION pgp_sym_decrypt(bytea, text, text); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.pgp_sym_decrypt(bytea, text, text) TO dashboard_user;
GRANT ALL ON FUNCTION extensions.pgp_sym_decrypt(bytea, text, text) TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION pgp_sym_decrypt_bytea(bytea, text); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.pgp_sym_decrypt_bytea(bytea, text) TO dashboard_user;
GRANT ALL ON FUNCTION extensions.pgp_sym_decrypt_bytea(bytea, text) TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION pgp_sym_decrypt_bytea(bytea, text, text); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.pgp_sym_decrypt_bytea(bytea, text, text) TO dashboard_user;
GRANT ALL ON FUNCTION extensions.pgp_sym_decrypt_bytea(bytea, text, text) TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION pgp_sym_encrypt(text, text); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.pgp_sym_encrypt(text, text) TO dashboard_user;
GRANT ALL ON FUNCTION extensions.pgp_sym_encrypt(text, text) TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION pgp_sym_encrypt(text, text, text); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.pgp_sym_encrypt(text, text, text) TO dashboard_user;
GRANT ALL ON FUNCTION extensions.pgp_sym_encrypt(text, text, text) TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION pgp_sym_encrypt_bytea(bytea, text); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.pgp_sym_encrypt_bytea(bytea, text) TO dashboard_user;
GRANT ALL ON FUNCTION extensions.pgp_sym_encrypt_bytea(bytea, text) TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION pgp_sym_encrypt_bytea(bytea, text, text); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.pgp_sym_encrypt_bytea(bytea, text, text) TO dashboard_user;
GRANT ALL ON FUNCTION extensions.pgp_sym_encrypt_bytea(bytea, text, text) TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION pgrst_ddl_watch(); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.pgrst_ddl_watch() TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION pgrst_drop_watch(); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.pgrst_drop_watch() TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION set_graphql_placeholder(); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.set_graphql_placeholder() TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION sign(payload json, secret text, algorithm text); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.sign(payload json, secret text, algorithm text) TO dashboard_user;
GRANT ALL ON FUNCTION extensions.sign(payload json, secret text, algorithm text) TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION try_cast_double(inp text); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.try_cast_double(inp text) TO dashboard_user;
GRANT ALL ON FUNCTION extensions.try_cast_double(inp text) TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION url_decode(data text); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.url_decode(data text) TO dashboard_user;
GRANT ALL ON FUNCTION extensions.url_decode(data text) TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION url_encode(data bytea); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.url_encode(data bytea) TO dashboard_user;
GRANT ALL ON FUNCTION extensions.url_encode(data bytea) TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION uuid_generate_v1(); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.uuid_generate_v1() TO dashboard_user;
GRANT ALL ON FUNCTION extensions.uuid_generate_v1() TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION uuid_generate_v1mc(); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.uuid_generate_v1mc() TO dashboard_user;
GRANT ALL ON FUNCTION extensions.uuid_generate_v1mc() TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION uuid_generate_v3(namespace uuid, name text); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.uuid_generate_v3(namespace uuid, name text) TO dashboard_user;
GRANT ALL ON FUNCTION extensions.uuid_generate_v3(namespace uuid, name text) TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION uuid_generate_v4(); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.uuid_generate_v4() TO dashboard_user;
GRANT ALL ON FUNCTION extensions.uuid_generate_v4() TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION uuid_generate_v5(namespace uuid, name text); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.uuid_generate_v5(namespace uuid, name text) TO dashboard_user;
GRANT ALL ON FUNCTION extensions.uuid_generate_v5(namespace uuid, name text) TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION uuid_nil(); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.uuid_nil() TO dashboard_user;
GRANT ALL ON FUNCTION extensions.uuid_nil() TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION uuid_ns_dns(); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.uuid_ns_dns() TO dashboard_user;
GRANT ALL ON FUNCTION extensions.uuid_ns_dns() TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION uuid_ns_oid(); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.uuid_ns_oid() TO dashboard_user;
GRANT ALL ON FUNCTION extensions.uuid_ns_oid() TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION uuid_ns_url(); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.uuid_ns_url() TO dashboard_user;
GRANT ALL ON FUNCTION extensions.uuid_ns_url() TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION uuid_ns_x500(); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.uuid_ns_x500() TO dashboard_user;
GRANT ALL ON FUNCTION extensions.uuid_ns_x500() TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION verify(token text, secret text, algorithm text); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.verify(token text, secret text, algorithm text) TO dashboard_user;
GRANT ALL ON FUNCTION extensions.verify(token text, secret text, algorithm text) TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION graphql("operationName" text, query text, variables jsonb, extensions jsonb); Type: ACL; Schema: graphql_public; Owner: supabase_admin
--

GRANT ALL ON FUNCTION graphql_public.graphql("operationName" text, query text, variables jsonb, extensions jsonb) TO postgres;
GRANT ALL ON FUNCTION graphql_public.graphql("operationName" text, query text, variables jsonb, extensions jsonb) TO anon;
GRANT ALL ON FUNCTION graphql_public.graphql("operationName" text, query text, variables jsonb, extensions jsonb) TO authenticated;
GRANT ALL ON FUNCTION graphql_public.graphql("operationName" text, query text, variables jsonb, extensions jsonb) TO service_role;


--
-- Name: FUNCTION get_auth(p_usename text); Type: ACL; Schema: pgbouncer; Owner: postgres
--

REVOKE ALL ON FUNCTION pgbouncer.get_auth(p_usename text) FROM PUBLIC;
GRANT ALL ON FUNCTION pgbouncer.get_auth(p_usename text) TO pgbouncer;


--
-- Name: FUNCTION crypto_aead_det_decrypt(message bytea, additional bytea, key_uuid uuid, nonce bytea); Type: ACL; Schema: pgsodium; Owner: pgsodium_keymaker
--

GRANT ALL ON FUNCTION pgsodium.crypto_aead_det_decrypt(message bytea, additional bytea, key_uuid uuid, nonce bytea) TO service_role;


--
-- Name: FUNCTION crypto_aead_det_encrypt(message bytea, additional bytea, key_uuid uuid, nonce bytea); Type: ACL; Schema: pgsodium; Owner: pgsodium_keymaker
--

GRANT ALL ON FUNCTION pgsodium.crypto_aead_det_encrypt(message bytea, additional bytea, key_uuid uuid, nonce bytea) TO service_role;


--
-- Name: FUNCTION crypto_aead_det_keygen(); Type: ACL; Schema: pgsodium; Owner: supabase_admin
--

GRANT ALL ON FUNCTION pgsodium.crypto_aead_det_keygen() TO service_role;


--
-- Name: FUNCTION calculate_closing_stock(p_product_id uuid, p_batch_id uuid, p_location_type text, p_location_id text, p_report_date date); Type: ACL; Schema: public; Owner: supabase_admin
--

GRANT ALL ON FUNCTION public.calculate_closing_stock(p_product_id uuid, p_batch_id uuid, p_location_type text, p_location_id text, p_report_date date) TO postgres;
GRANT ALL ON FUNCTION public.calculate_closing_stock(p_product_id uuid, p_batch_id uuid, p_location_type text, p_location_id text, p_report_date date) TO anon;
GRANT ALL ON FUNCTION public.calculate_closing_stock(p_product_id uuid, p_batch_id uuid, p_location_type text, p_location_id text, p_report_date date) TO authenticated;
GRANT ALL ON FUNCTION public.calculate_closing_stock(p_product_id uuid, p_batch_id uuid, p_location_type text, p_location_id text, p_report_date date) TO service_role;


--
-- Name: FUNCTION create_mr_sale(p_customer_name text, p_items jsonb, p_total_amount numeric, p_notes text); Type: ACL; Schema: public; Owner: supabase_admin
--

GRANT ALL ON FUNCTION public.create_mr_sale(p_customer_name text, p_items jsonb, p_total_amount numeric, p_notes text) TO postgres;
GRANT ALL ON FUNCTION public.create_mr_sale(p_customer_name text, p_items jsonb, p_total_amount numeric, p_notes text) TO anon;
GRANT ALL ON FUNCTION public.create_mr_sale(p_customer_name text, p_items jsonb, p_total_amount numeric, p_notes text) TO authenticated;
GRANT ALL ON FUNCTION public.create_mr_sale(p_customer_name text, p_items jsonb, p_total_amount numeric, p_notes text) TO service_role;


--
-- Name: FUNCTION create_product_with_auto_code(p_product_name text, p_generic_name text, p_manufacturer text, p_category_id uuid, p_formulation_id uuid, p_sub_category_id uuid, p_unit_of_measure_smallest text, p_base_cost_per_strip numeric, p_is_active boolean, p_storage_conditions text, p_image_url text, p_min_stock_level_godown integer, p_min_stock_level_mr integer, p_lead_time_days integer); Type: ACL; Schema: public; Owner: supabase_admin
--

GRANT ALL ON FUNCTION public.create_product_with_auto_code(p_product_name text, p_generic_name text, p_manufacturer text, p_category_id uuid, p_formulation_id uuid, p_sub_category_id uuid, p_unit_of_measure_smallest text, p_base_cost_per_strip numeric, p_is_active boolean, p_storage_conditions text, p_image_url text, p_min_stock_level_godown integer, p_min_stock_level_mr integer, p_lead_time_days integer) TO postgres;
GRANT ALL ON FUNCTION public.create_product_with_auto_code(p_product_name text, p_generic_name text, p_manufacturer text, p_category_id uuid, p_formulation_id uuid, p_sub_category_id uuid, p_unit_of_measure_smallest text, p_base_cost_per_strip numeric, p_is_active boolean, p_storage_conditions text, p_image_url text, p_min_stock_level_godown integer, p_min_stock_level_mr integer, p_lead_time_days integer) TO anon;
GRANT ALL ON FUNCTION public.create_product_with_auto_code(p_product_name text, p_generic_name text, p_manufacturer text, p_category_id uuid, p_formulation_id uuid, p_sub_category_id uuid, p_unit_of_measure_smallest text, p_base_cost_per_strip numeric, p_is_active boolean, p_storage_conditions text, p_image_url text, p_min_stock_level_godown integer, p_min_stock_level_mr integer, p_lead_time_days integer) TO authenticated;
GRANT ALL ON FUNCTION public.create_product_with_auto_code(p_product_name text, p_generic_name text, p_manufacturer text, p_category_id uuid, p_formulation_id uuid, p_sub_category_id uuid, p_unit_of_measure_smallest text, p_base_cost_per_strip numeric, p_is_active boolean, p_storage_conditions text, p_image_url text, p_min_stock_level_godown integer, p_min_stock_level_mr integer, p_lead_time_days integer) TO service_role;


--
-- Name: FUNCTION execute_safe_query(query_text text); Type: ACL; Schema: public; Owner: supabase_admin
--

GRANT ALL ON FUNCTION public.execute_safe_query(query_text text) TO postgres;
GRANT ALL ON FUNCTION public.execute_safe_query(query_text text) TO anon;
GRANT ALL ON FUNCTION public.execute_safe_query(query_text text) TO authenticated;
GRANT ALL ON FUNCTION public.execute_safe_query(query_text text) TO service_role;


--
-- Name: FUNCTION handle_new_user(); Type: ACL; Schema: public; Owner: supabase_admin
--

GRANT ALL ON FUNCTION public.handle_new_user() TO postgres;
GRANT ALL ON FUNCTION public.handle_new_user() TO anon;
GRANT ALL ON FUNCTION public.handle_new_user() TO authenticated;
GRANT ALL ON FUNCTION public.handle_new_user() TO service_role;


--
-- Name: FUNCTION is_admin(user_uuid uuid); Type: ACL; Schema: public; Owner: supabase_admin
--

GRANT ALL ON FUNCTION public.is_admin(user_uuid uuid) TO postgres;
GRANT ALL ON FUNCTION public.is_admin(user_uuid uuid) TO anon;
GRANT ALL ON FUNCTION public.is_admin(user_uuid uuid) TO authenticated;
GRANT ALL ON FUNCTION public.is_admin(user_uuid uuid) TO service_role;


--
-- Name: FUNCTION recalculate_closing_stock_reports(); Type: ACL; Schema: public; Owner: supabase_admin
--

GRANT ALL ON FUNCTION public.recalculate_closing_stock_reports() TO postgres;
GRANT ALL ON FUNCTION public.recalculate_closing_stock_reports() TO anon;
GRANT ALL ON FUNCTION public.recalculate_closing_stock_reports() TO authenticated;
GRANT ALL ON FUNCTION public.recalculate_closing_stock_reports() TO service_role;


--
-- Name: FUNCTION recalculate_mr_stock_summary_with_prices(); Type: ACL; Schema: public; Owner: supabase_admin
--

GRANT ALL ON FUNCTION public.recalculate_mr_stock_summary_with_prices() TO postgres;
GRANT ALL ON FUNCTION public.recalculate_mr_stock_summary_with_prices() TO anon;
GRANT ALL ON FUNCTION public.recalculate_mr_stock_summary_with_prices() TO authenticated;
GRANT ALL ON FUNCTION public.recalculate_mr_stock_summary_with_prices() TO service_role;


--
-- Name: FUNCTION recalculate_products_stock_status(); Type: ACL; Schema: public; Owner: supabase_admin
--

GRANT ALL ON FUNCTION public.recalculate_products_stock_status() TO postgres;
GRANT ALL ON FUNCTION public.recalculate_products_stock_status() TO anon;
GRANT ALL ON FUNCTION public.recalculate_products_stock_status() TO authenticated;
GRANT ALL ON FUNCTION public.recalculate_products_stock_status() TO service_role;


--
-- Name: FUNCTION update_closing_stock_report(); Type: ACL; Schema: public; Owner: supabase_admin
--

GRANT ALL ON FUNCTION public.update_closing_stock_report() TO postgres;
GRANT ALL ON FUNCTION public.update_closing_stock_report() TO anon;
GRANT ALL ON FUNCTION public.update_closing_stock_report() TO authenticated;
GRANT ALL ON FUNCTION public.update_closing_stock_report() TO service_role;


--
-- Name: FUNCTION update_mr_stock_summary(); Type: ACL; Schema: public; Owner: supabase_admin
--

GRANT ALL ON FUNCTION public.update_mr_stock_summary() TO postgres;
GRANT ALL ON FUNCTION public.update_mr_stock_summary() TO anon;
GRANT ALL ON FUNCTION public.update_mr_stock_summary() TO authenticated;
GRANT ALL ON FUNCTION public.update_mr_stock_summary() TO service_role;


--
-- Name: FUNCTION update_mr_stock_summary_from_adjustments(); Type: ACL; Schema: public; Owner: supabase_admin
--

GRANT ALL ON FUNCTION public.update_mr_stock_summary_from_adjustments() TO postgres;
GRANT ALL ON FUNCTION public.update_mr_stock_summary_from_adjustments() TO anon;
GRANT ALL ON FUNCTION public.update_mr_stock_summary_from_adjustments() TO authenticated;
GRANT ALL ON FUNCTION public.update_mr_stock_summary_from_adjustments() TO service_role;


--
-- Name: FUNCTION update_mr_stock_summary_from_sales(); Type: ACL; Schema: public; Owner: supabase_admin
--

GRANT ALL ON FUNCTION public.update_mr_stock_summary_from_sales() TO postgres;
GRANT ALL ON FUNCTION public.update_mr_stock_summary_from_sales() TO anon;
GRANT ALL ON FUNCTION public.update_mr_stock_summary_from_sales() TO authenticated;
GRANT ALL ON FUNCTION public.update_mr_stock_summary_from_sales() TO service_role;


--
-- Name: FUNCTION update_products_stock_status(); Type: ACL; Schema: public; Owner: supabase_admin
--

GRANT ALL ON FUNCTION public.update_products_stock_status() TO postgres;
GRANT ALL ON FUNCTION public.update_products_stock_status() TO anon;
GRANT ALL ON FUNCTION public.update_products_stock_status() TO authenticated;
GRANT ALL ON FUNCTION public.update_products_stock_status() TO service_role;


--
-- Name: FUNCTION update_updated_at_column(); Type: ACL; Schema: public; Owner: supabase_admin
--

GRANT ALL ON FUNCTION public.update_updated_at_column() TO postgres;
GRANT ALL ON FUNCTION public.update_updated_at_column() TO anon;
GRANT ALL ON FUNCTION public.update_updated_at_column() TO authenticated;
GRANT ALL ON FUNCTION public.update_updated_at_column() TO service_role;


--
-- Name: FUNCTION validate_batch_dates(); Type: ACL; Schema: public; Owner: supabase_admin
--

GRANT ALL ON FUNCTION public.validate_batch_dates() TO postgres;
GRANT ALL ON FUNCTION public.validate_batch_dates() TO anon;
GRANT ALL ON FUNCTION public.validate_batch_dates() TO authenticated;
GRANT ALL ON FUNCTION public.validate_batch_dates() TO service_role;


--
-- Name: FUNCTION validate_single_base_unit(); Type: ACL; Schema: public; Owner: supabase_admin
--

GRANT ALL ON FUNCTION public.validate_single_base_unit() TO postgres;
GRANT ALL ON FUNCTION public.validate_single_base_unit() TO anon;
GRANT ALL ON FUNCTION public.validate_single_base_unit() TO authenticated;
GRANT ALL ON FUNCTION public.validate_single_base_unit() TO service_role;


--
-- Name: FUNCTION validate_template_name(); Type: ACL; Schema: public; Owner: supabase_admin
--

GRANT ALL ON FUNCTION public.validate_template_name() TO postgres;
GRANT ALL ON FUNCTION public.validate_template_name() TO anon;
GRANT ALL ON FUNCTION public.validate_template_name() TO authenticated;
GRANT ALL ON FUNCTION public.validate_template_name() TO service_role;


--
-- Name: FUNCTION apply_rls(wal jsonb, max_record_bytes integer); Type: ACL; Schema: realtime; Owner: supabase_admin
--

GRANT ALL ON FUNCTION realtime.apply_rls(wal jsonb, max_record_bytes integer) TO postgres;
GRANT ALL ON FUNCTION realtime.apply_rls(wal jsonb, max_record_bytes integer) TO dashboard_user;
GRANT ALL ON FUNCTION realtime.apply_rls(wal jsonb, max_record_bytes integer) TO anon;
GRANT ALL ON FUNCTION realtime.apply_rls(wal jsonb, max_record_bytes integer) TO authenticated;
GRANT ALL ON FUNCTION realtime.apply_rls(wal jsonb, max_record_bytes integer) TO service_role;
GRANT ALL ON FUNCTION realtime.apply_rls(wal jsonb, max_record_bytes integer) TO supabase_realtime_admin;


--
-- Name: FUNCTION broadcast_changes(topic_name text, event_name text, operation text, table_name text, table_schema text, new record, old record, level text); Type: ACL; Schema: realtime; Owner: supabase_admin
--

GRANT ALL ON FUNCTION realtime.broadcast_changes(topic_name text, event_name text, operation text, table_name text, table_schema text, new record, old record, level text) TO postgres;
GRANT ALL ON FUNCTION realtime.broadcast_changes(topic_name text, event_name text, operation text, table_name text, table_schema text, new record, old record, level text) TO dashboard_user;


--
-- Name: FUNCTION build_prepared_statement_sql(prepared_statement_name text, entity regclass, columns realtime.wal_column[]); Type: ACL; Schema: realtime; Owner: supabase_admin
--

GRANT ALL ON FUNCTION realtime.build_prepared_statement_sql(prepared_statement_name text, entity regclass, columns realtime.wal_column[]) TO postgres;
GRANT ALL ON FUNCTION realtime.build_prepared_statement_sql(prepared_statement_name text, entity regclass, columns realtime.wal_column[]) TO dashboard_user;
GRANT ALL ON FUNCTION realtime.build_prepared_statement_sql(prepared_statement_name text, entity regclass, columns realtime.wal_column[]) TO anon;
GRANT ALL ON FUNCTION realtime.build_prepared_statement_sql(prepared_statement_name text, entity regclass, columns realtime.wal_column[]) TO authenticated;
GRANT ALL ON FUNCTION realtime.build_prepared_statement_sql(prepared_statement_name text, entity regclass, columns realtime.wal_column[]) TO service_role;
GRANT ALL ON FUNCTION realtime.build_prepared_statement_sql(prepared_statement_name text, entity regclass, columns realtime.wal_column[]) TO supabase_realtime_admin;


--
-- Name: FUNCTION "cast"(val text, type_ regtype); Type: ACL; Schema: realtime; Owner: supabase_admin
--

GRANT ALL ON FUNCTION realtime."cast"(val text, type_ regtype) TO postgres;
GRANT ALL ON FUNCTION realtime."cast"(val text, type_ regtype) TO dashboard_user;
GRANT ALL ON FUNCTION realtime."cast"(val text, type_ regtype) TO anon;
GRANT ALL ON FUNCTION realtime."cast"(val text, type_ regtype) TO authenticated;
GRANT ALL ON FUNCTION realtime."cast"(val text, type_ regtype) TO service_role;
GRANT ALL ON FUNCTION realtime."cast"(val text, type_ regtype) TO supabase_realtime_admin;


--
-- Name: FUNCTION check_equality_op(op realtime.equality_op, type_ regtype, val_1 text, val_2 text); Type: ACL; Schema: realtime; Owner: supabase_admin
--

GRANT ALL ON FUNCTION realtime.check_equality_op(op realtime.equality_op, type_ regtype, val_1 text, val_2 text) TO postgres;
GRANT ALL ON FUNCTION realtime.check_equality_op(op realtime.equality_op, type_ regtype, val_1 text, val_2 text) TO dashboard_user;
GRANT ALL ON FUNCTION realtime.check_equality_op(op realtime.equality_op, type_ regtype, val_1 text, val_2 text) TO anon;
GRANT ALL ON FUNCTION realtime.check_equality_op(op realtime.equality_op, type_ regtype, val_1 text, val_2 text) TO authenticated;
GRANT ALL ON FUNCTION realtime.check_equality_op(op realtime.equality_op, type_ regtype, val_1 text, val_2 text) TO service_role;
GRANT ALL ON FUNCTION realtime.check_equality_op(op realtime.equality_op, type_ regtype, val_1 text, val_2 text) TO supabase_realtime_admin;


--
-- Name: FUNCTION is_visible_through_filters(columns realtime.wal_column[], filters realtime.user_defined_filter[]); Type: ACL; Schema: realtime; Owner: supabase_admin
--

GRANT ALL ON FUNCTION realtime.is_visible_through_filters(columns realtime.wal_column[], filters realtime.user_defined_filter[]) TO postgres;
GRANT ALL ON FUNCTION realtime.is_visible_through_filters(columns realtime.wal_column[], filters realtime.user_defined_filter[]) TO dashboard_user;
GRANT ALL ON FUNCTION realtime.is_visible_through_filters(columns realtime.wal_column[], filters realtime.user_defined_filter[]) TO anon;
GRANT ALL ON FUNCTION realtime.is_visible_through_filters(columns realtime.wal_column[], filters realtime.user_defined_filter[]) TO authenticated;
GRANT ALL ON FUNCTION realtime.is_visible_through_filters(columns realtime.wal_column[], filters realtime.user_defined_filter[]) TO service_role;
GRANT ALL ON FUNCTION realtime.is_visible_through_filters(columns realtime.wal_column[], filters realtime.user_defined_filter[]) TO supabase_realtime_admin;


--
-- Name: FUNCTION list_changes(publication name, slot_name name, max_changes integer, max_record_bytes integer); Type: ACL; Schema: realtime; Owner: supabase_admin
--

GRANT ALL ON FUNCTION realtime.list_changes(publication name, slot_name name, max_changes integer, max_record_bytes integer) TO postgres;
GRANT ALL ON FUNCTION realtime.list_changes(publication name, slot_name name, max_changes integer, max_record_bytes integer) TO dashboard_user;
GRANT ALL ON FUNCTION realtime.list_changes(publication name, slot_name name, max_changes integer, max_record_bytes integer) TO anon;
GRANT ALL ON FUNCTION realtime.list_changes(publication name, slot_name name, max_changes integer, max_record_bytes integer) TO authenticated;
GRANT ALL ON FUNCTION realtime.list_changes(publication name, slot_name name, max_changes integer, max_record_bytes integer) TO service_role;
GRANT ALL ON FUNCTION realtime.list_changes(publication name, slot_name name, max_changes integer, max_record_bytes integer) TO supabase_realtime_admin;


--
-- Name: FUNCTION quote_wal2json(entity regclass); Type: ACL; Schema: realtime; Owner: supabase_admin
--

GRANT ALL ON FUNCTION realtime.quote_wal2json(entity regclass) TO postgres;
GRANT ALL ON FUNCTION realtime.quote_wal2json(entity regclass) TO dashboard_user;
GRANT ALL ON FUNCTION realtime.quote_wal2json(entity regclass) TO anon;
GRANT ALL ON FUNCTION realtime.quote_wal2json(entity regclass) TO authenticated;
GRANT ALL ON FUNCTION realtime.quote_wal2json(entity regclass) TO service_role;
GRANT ALL ON FUNCTION realtime.quote_wal2json(entity regclass) TO supabase_realtime_admin;


--
-- Name: FUNCTION send(payload jsonb, event text, topic text, private boolean); Type: ACL; Schema: realtime; Owner: supabase_admin
--

GRANT ALL ON FUNCTION realtime.send(payload jsonb, event text, topic text, private boolean) TO postgres;
GRANT ALL ON FUNCTION realtime.send(payload jsonb, event text, topic text, private boolean) TO dashboard_user;


--
-- Name: FUNCTION subscription_check_filters(); Type: ACL; Schema: realtime; Owner: supabase_admin
--

GRANT ALL ON FUNCTION realtime.subscription_check_filters() TO postgres;
GRANT ALL ON FUNCTION realtime.subscription_check_filters() TO dashboard_user;
GRANT ALL ON FUNCTION realtime.subscription_check_filters() TO anon;
GRANT ALL ON FUNCTION realtime.subscription_check_filters() TO authenticated;
GRANT ALL ON FUNCTION realtime.subscription_check_filters() TO service_role;
GRANT ALL ON FUNCTION realtime.subscription_check_filters() TO supabase_realtime_admin;


--
-- Name: FUNCTION to_regrole(role_name text); Type: ACL; Schema: realtime; Owner: supabase_admin
--

GRANT ALL ON FUNCTION realtime.to_regrole(role_name text) TO postgres;
GRANT ALL ON FUNCTION realtime.to_regrole(role_name text) TO dashboard_user;
GRANT ALL ON FUNCTION realtime.to_regrole(role_name text) TO anon;
GRANT ALL ON FUNCTION realtime.to_regrole(role_name text) TO authenticated;
GRANT ALL ON FUNCTION realtime.to_regrole(role_name text) TO service_role;
GRANT ALL ON FUNCTION realtime.to_regrole(role_name text) TO supabase_realtime_admin;


--
-- Name: FUNCTION topic(); Type: ACL; Schema: realtime; Owner: supabase_realtime_admin
--

GRANT ALL ON FUNCTION realtime.topic() TO postgres;
GRANT ALL ON FUNCTION realtime.topic() TO dashboard_user;


--
-- Name: FUNCTION http_request(); Type: ACL; Schema: supabase_functions; Owner: supabase_functions_admin
--

REVOKE ALL ON FUNCTION supabase_functions.http_request() FROM PUBLIC;
GRANT ALL ON FUNCTION supabase_functions.http_request() TO anon;
GRANT ALL ON FUNCTION supabase_functions.http_request() TO authenticated;
GRANT ALL ON FUNCTION supabase_functions.http_request() TO service_role;
GRANT ALL ON FUNCTION supabase_functions.http_request() TO postgres;


--
-- Name: TABLE audit_log_entries; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE auth.audit_log_entries TO dashboard_user;
GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE auth.audit_log_entries TO postgres;
GRANT SELECT ON TABLE auth.audit_log_entries TO postgres WITH GRANT OPTION;


--
-- Name: TABLE flow_state; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE auth.flow_state TO postgres;
GRANT SELECT ON TABLE auth.flow_state TO postgres WITH GRANT OPTION;
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE auth.flow_state TO dashboard_user;


--
-- Name: TABLE identities; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE auth.identities TO postgres;
GRANT SELECT ON TABLE auth.identities TO postgres WITH GRANT OPTION;
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE auth.identities TO dashboard_user;


--
-- Name: TABLE instances; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE auth.instances TO dashboard_user;
GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE auth.instances TO postgres;
GRANT SELECT ON TABLE auth.instances TO postgres WITH GRANT OPTION;


--
-- Name: TABLE mfa_amr_claims; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE auth.mfa_amr_claims TO postgres;
GRANT SELECT ON TABLE auth.mfa_amr_claims TO postgres WITH GRANT OPTION;
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE auth.mfa_amr_claims TO dashboard_user;


--
-- Name: TABLE mfa_challenges; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE auth.mfa_challenges TO postgres;
GRANT SELECT ON TABLE auth.mfa_challenges TO postgres WITH GRANT OPTION;
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE auth.mfa_challenges TO dashboard_user;


--
-- Name: TABLE mfa_factors; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE auth.mfa_factors TO postgres;
GRANT SELECT ON TABLE auth.mfa_factors TO postgres WITH GRANT OPTION;
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE auth.mfa_factors TO dashboard_user;


--
-- Name: TABLE one_time_tokens; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE auth.one_time_tokens TO postgres;
GRANT SELECT ON TABLE auth.one_time_tokens TO postgres WITH GRANT OPTION;
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE auth.one_time_tokens TO dashboard_user;


--
-- Name: TABLE refresh_tokens; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE auth.refresh_tokens TO dashboard_user;
GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE auth.refresh_tokens TO postgres;
GRANT SELECT ON TABLE auth.refresh_tokens TO postgres WITH GRANT OPTION;


--
-- Name: SEQUENCE refresh_tokens_id_seq; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON SEQUENCE auth.refresh_tokens_id_seq TO dashboard_user;
GRANT ALL ON SEQUENCE auth.refresh_tokens_id_seq TO postgres;


--
-- Name: TABLE saml_providers; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE auth.saml_providers TO postgres;
GRANT SELECT ON TABLE auth.saml_providers TO postgres WITH GRANT OPTION;
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE auth.saml_providers TO dashboard_user;


--
-- Name: TABLE saml_relay_states; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE auth.saml_relay_states TO postgres;
GRANT SELECT ON TABLE auth.saml_relay_states TO postgres WITH GRANT OPTION;
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE auth.saml_relay_states TO dashboard_user;


--
-- Name: TABLE schema_migrations; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE auth.schema_migrations TO dashboard_user;
GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE auth.schema_migrations TO postgres;
GRANT SELECT ON TABLE auth.schema_migrations TO postgres WITH GRANT OPTION;


--
-- Name: TABLE sessions; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE auth.sessions TO postgres;
GRANT SELECT ON TABLE auth.sessions TO postgres WITH GRANT OPTION;
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE auth.sessions TO dashboard_user;


--
-- Name: TABLE sso_domains; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE auth.sso_domains TO postgres;
GRANT SELECT ON TABLE auth.sso_domains TO postgres WITH GRANT OPTION;
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE auth.sso_domains TO dashboard_user;


--
-- Name: TABLE sso_providers; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE auth.sso_providers TO postgres;
GRANT SELECT ON TABLE auth.sso_providers TO postgres WITH GRANT OPTION;
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE auth.sso_providers TO dashboard_user;


--
-- Name: TABLE users; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE auth.users TO dashboard_user;
GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE auth.users TO postgres;
GRANT SELECT ON TABLE auth.users TO postgres WITH GRANT OPTION;


--
-- Name: TABLE pg_stat_statements; Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE extensions.pg_stat_statements TO postgres WITH GRANT OPTION;


--
-- Name: TABLE pg_stat_statements_info; Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE extensions.pg_stat_statements_info TO postgres WITH GRANT OPTION;


--
-- Name: TABLE decrypted_key; Type: ACL; Schema: pgsodium; Owner: supabase_admin
--

GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE pgsodium.decrypted_key TO pgsodium_keyholder;


--
-- Name: TABLE masking_rule; Type: ACL; Schema: pgsodium; Owner: supabase_admin
--

GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE pgsodium.masking_rule TO pgsodium_keyholder;


--
-- Name: TABLE mask_columns; Type: ACL; Schema: pgsodium; Owner: supabase_admin
--

GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE pgsodium.mask_columns TO pgsodium_keyholder;


--
-- Name: TABLE doctor_clinics; Type: ACL; Schema: public; Owner: supabase_admin
--

GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE public.doctor_clinics TO postgres;
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE public.doctor_clinics TO anon;
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE public.doctor_clinics TO authenticated;
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE public.doctor_clinics TO service_role;


--
-- Name: TABLE doctors; Type: ACL; Schema: public; Owner: supabase_admin
--

GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE public.doctors TO postgres;
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE public.doctors TO anon;
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE public.doctors TO authenticated;
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE public.doctors TO service_role;


--
-- Name: TABLE mr_doctor_allotments; Type: ACL; Schema: public; Owner: supabase_admin
--

GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE public.mr_doctor_allotments TO postgres;
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE public.mr_doctor_allotments TO anon;
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE public.mr_doctor_allotments TO authenticated;
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE public.mr_doctor_allotments TO service_role;


--
-- Name: TABLE mr_sales_order_items; Type: ACL; Schema: public; Owner: supabase_admin
--

GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE public.mr_sales_order_items TO postgres;
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE public.mr_sales_order_items TO anon;
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE public.mr_sales_order_items TO authenticated;
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE public.mr_sales_order_items TO service_role;


--
-- Name: TABLE mr_sales_orders; Type: ACL; Schema: public; Owner: supabase_admin
--

GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE public.mr_sales_orders TO postgres;
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE public.mr_sales_orders TO anon;
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE public.mr_sales_orders TO authenticated;
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE public.mr_sales_orders TO service_role;


--
-- Name: TABLE mr_sales_targets; Type: ACL; Schema: public; Owner: supabase_admin
--

GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE public.mr_sales_targets TO postgres;
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE public.mr_sales_targets TO anon;
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE public.mr_sales_targets TO authenticated;
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE public.mr_sales_targets TO service_role;


--
-- Name: TABLE mr_stock_summary; Type: ACL; Schema: public; Owner: supabase_admin
--

GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE public.mr_stock_summary TO postgres;
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE public.mr_stock_summary TO anon;
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE public.mr_stock_summary TO authenticated;
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE public.mr_stock_summary TO service_role;


--
-- Name: TABLE mr_visit_logs; Type: ACL; Schema: public; Owner: supabase_admin
--

GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE public.mr_visit_logs TO postgres;
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE public.mr_visit_logs TO anon;
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE public.mr_visit_logs TO authenticated;
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE public.mr_visit_logs TO service_role;


--
-- Name: TABLE packaging_templates; Type: ACL; Schema: public; Owner: supabase_admin
--

GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE public.packaging_templates TO postgres;
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE public.packaging_templates TO anon;
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE public.packaging_templates TO authenticated;
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE public.packaging_templates TO service_role;


--
-- Name: TABLE product_batches; Type: ACL; Schema: public; Owner: supabase_admin
--

GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE public.product_batches TO postgres;
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE public.product_batches TO anon;
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE public.product_batches TO authenticated;
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE public.product_batches TO service_role;


--
-- Name: TABLE product_categories; Type: ACL; Schema: public; Owner: supabase_admin
--

GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE public.product_categories TO postgres;
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE public.product_categories TO anon;
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE public.product_categories TO authenticated;
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE public.product_categories TO service_role;


--
-- Name: TABLE product_formulations; Type: ACL; Schema: public; Owner: supabase_admin
--

GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE public.product_formulations TO postgres;
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE public.product_formulations TO anon;
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE public.product_formulations TO authenticated;
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE public.product_formulations TO service_role;


--
-- Name: TABLE product_packaging_units; Type: ACL; Schema: public; Owner: supabase_admin
--

GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE public.product_packaging_units TO postgres;
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE public.product_packaging_units TO anon;
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE public.product_packaging_units TO authenticated;
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE public.product_packaging_units TO service_role;


--
-- Name: TABLE product_sub_categories; Type: ACL; Schema: public; Owner: supabase_admin
--

GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE public.product_sub_categories TO postgres;
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE public.product_sub_categories TO anon;
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE public.product_sub_categories TO authenticated;
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE public.product_sub_categories TO service_role;


--
-- Name: TABLE products; Type: ACL; Schema: public; Owner: supabase_admin
--

GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE public.products TO postgres;
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE public.products TO anon;
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE public.products TO authenticated;
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE public.products TO service_role;


--
-- Name: TABLE products_stock_status; Type: ACL; Schema: public; Owner: supabase_admin
--

GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE public.products_stock_status TO postgres;
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE public.products_stock_status TO anon;
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE public.products_stock_status TO authenticated;
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE public.products_stock_status TO service_role;


--
-- Name: TABLE profiles; Type: ACL; Schema: public; Owner: supabase_admin
--

GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE public.profiles TO postgres;
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE public.profiles TO anon;
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE public.profiles TO authenticated;
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE public.profiles TO service_role;


--
-- Name: TABLE stock_adjustments; Type: ACL; Schema: public; Owner: supabase_admin
--

GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE public.stock_adjustments TO postgres;
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE public.stock_adjustments TO anon;
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE public.stock_adjustments TO authenticated;
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE public.stock_adjustments TO service_role;


--
-- Name: TABLE stock_purchases; Type: ACL; Schema: public; Owner: supabase_admin
--

GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE public.stock_purchases TO postgres;
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE public.stock_purchases TO anon;
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE public.stock_purchases TO authenticated;
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE public.stock_purchases TO service_role;


--
-- Name: TABLE stock_sales; Type: ACL; Schema: public; Owner: supabase_admin
--

GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE public.stock_sales TO postgres;
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE public.stock_sales TO anon;
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE public.stock_sales TO authenticated;
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE public.stock_sales TO service_role;


--
-- Name: TABLE stock_transactions; Type: ACL; Schema: public; Owner: supabase_admin
--

GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE public.stock_transactions TO postgres;
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE public.stock_transactions TO anon;
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE public.stock_transactions TO authenticated;
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE public.stock_transactions TO service_role;


--
-- Name: TABLE stock_transactions_view; Type: ACL; Schema: public; Owner: supabase_admin
--

GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE public.stock_transactions_view TO postgres;
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE public.stock_transactions_view TO anon;
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE public.stock_transactions_view TO authenticated;
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE public.stock_transactions_view TO service_role;


--
-- Name: TABLE suppliers; Type: ACL; Schema: public; Owner: supabase_admin
--

GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE public.suppliers TO postgres;
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE public.suppliers TO anon;
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE public.suppliers TO authenticated;
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE public.suppliers TO service_role;


--
-- Name: TABLE template_names; Type: ACL; Schema: public; Owner: supabase_admin
--

GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE public.template_names TO postgres;
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE public.template_names TO anon;
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE public.template_names TO authenticated;
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE public.template_names TO service_role;


--
-- Name: TABLE messages; Type: ACL; Schema: realtime; Owner: supabase_realtime_admin
--

GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE realtime.messages TO postgres;
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE realtime.messages TO dashboard_user;
GRANT SELECT,INSERT,UPDATE ON TABLE realtime.messages TO anon;
GRANT SELECT,INSERT,UPDATE ON TABLE realtime.messages TO authenticated;
GRANT SELECT,INSERT,UPDATE ON TABLE realtime.messages TO service_role;


--
-- Name: TABLE schema_migrations; Type: ACL; Schema: realtime; Owner: supabase_admin
--

GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE realtime.schema_migrations TO postgres;
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE realtime.schema_migrations TO dashboard_user;
GRANT SELECT ON TABLE realtime.schema_migrations TO anon;
GRANT SELECT ON TABLE realtime.schema_migrations TO authenticated;
GRANT SELECT ON TABLE realtime.schema_migrations TO service_role;
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE realtime.schema_migrations TO supabase_realtime_admin;


--
-- Name: TABLE subscription; Type: ACL; Schema: realtime; Owner: supabase_admin
--

GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE realtime.subscription TO postgres;
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE realtime.subscription TO dashboard_user;
GRANT SELECT ON TABLE realtime.subscription TO anon;
GRANT SELECT ON TABLE realtime.subscription TO authenticated;
GRANT SELECT ON TABLE realtime.subscription TO service_role;
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE realtime.subscription TO supabase_realtime_admin;


--
-- Name: SEQUENCE subscription_id_seq; Type: ACL; Schema: realtime; Owner: supabase_admin
--

GRANT ALL ON SEQUENCE realtime.subscription_id_seq TO postgres;
GRANT ALL ON SEQUENCE realtime.subscription_id_seq TO dashboard_user;
GRANT USAGE ON SEQUENCE realtime.subscription_id_seq TO anon;
GRANT USAGE ON SEQUENCE realtime.subscription_id_seq TO authenticated;
GRANT USAGE ON SEQUENCE realtime.subscription_id_seq TO service_role;
GRANT ALL ON SEQUENCE realtime.subscription_id_seq TO supabase_realtime_admin;


--
-- Name: TABLE buckets; Type: ACL; Schema: storage; Owner: supabase_storage_admin
--

GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE storage.buckets TO anon;
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE storage.buckets TO authenticated;
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE storage.buckets TO service_role;
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE storage.buckets TO postgres;


--
-- Name: TABLE migrations; Type: ACL; Schema: storage; Owner: supabase_storage_admin
--

GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE storage.migrations TO anon;
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE storage.migrations TO authenticated;
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE storage.migrations TO service_role;
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE storage.migrations TO postgres;


--
-- Name: TABLE objects; Type: ACL; Schema: storage; Owner: supabase_storage_admin
--

GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE storage.objects TO anon;
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE storage.objects TO authenticated;
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE storage.objects TO service_role;
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE storage.objects TO postgres;


--
-- Name: TABLE s3_multipart_uploads; Type: ACL; Schema: storage; Owner: supabase_storage_admin
--

GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE storage.s3_multipart_uploads TO service_role;
GRANT SELECT ON TABLE storage.s3_multipart_uploads TO authenticated;
GRANT SELECT ON TABLE storage.s3_multipart_uploads TO anon;


--
-- Name: TABLE s3_multipart_uploads_parts; Type: ACL; Schema: storage; Owner: supabase_storage_admin
--

GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE storage.s3_multipart_uploads_parts TO service_role;
GRANT SELECT ON TABLE storage.s3_multipart_uploads_parts TO authenticated;
GRANT SELECT ON TABLE storage.s3_multipart_uploads_parts TO anon;


--
-- Name: TABLE hooks; Type: ACL; Schema: supabase_functions; Owner: supabase_functions_admin
--

GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE supabase_functions.hooks TO anon;
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE supabase_functions.hooks TO authenticated;
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE supabase_functions.hooks TO service_role;


--
-- Name: SEQUENCE hooks_id_seq; Type: ACL; Schema: supabase_functions; Owner: supabase_functions_admin
--

GRANT ALL ON SEQUENCE supabase_functions.hooks_id_seq TO anon;
GRANT ALL ON SEQUENCE supabase_functions.hooks_id_seq TO authenticated;
GRANT ALL ON SEQUENCE supabase_functions.hooks_id_seq TO service_role;


--
-- Name: TABLE migrations; Type: ACL; Schema: supabase_functions; Owner: supabase_functions_admin
--

GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE supabase_functions.migrations TO anon;
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE supabase_functions.migrations TO authenticated;
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE supabase_functions.migrations TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR SEQUENCES; Type: DEFAULT ACL; Schema: auth; Owner: supabase_auth_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_auth_admin IN SCHEMA auth GRANT ALL ON SEQUENCES TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_auth_admin IN SCHEMA auth GRANT ALL ON SEQUENCES TO dashboard_user;


--
-- Name: DEFAULT PRIVILEGES FOR FUNCTIONS; Type: DEFAULT ACL; Schema: auth; Owner: supabase_auth_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_auth_admin IN SCHEMA auth GRANT ALL ON FUNCTIONS TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_auth_admin IN SCHEMA auth GRANT ALL ON FUNCTIONS TO dashboard_user;


--
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: auth; Owner: supabase_auth_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_auth_admin IN SCHEMA auth GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLES TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_auth_admin IN SCHEMA auth GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLES TO dashboard_user;


--
-- Name: DEFAULT PRIVILEGES FOR SEQUENCES; Type: DEFAULT ACL; Schema: extensions; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA extensions GRANT ALL ON SEQUENCES TO postgres WITH GRANT OPTION;


--
-- Name: DEFAULT PRIVILEGES FOR FUNCTIONS; Type: DEFAULT ACL; Schema: extensions; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA extensions GRANT ALL ON FUNCTIONS TO postgres WITH GRANT OPTION;


--
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: extensions; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA extensions GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLES TO postgres WITH GRANT OPTION;


--
-- Name: DEFAULT PRIVILEGES FOR SEQUENCES; Type: DEFAULT ACL; Schema: graphql; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql GRANT ALL ON SEQUENCES TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql GRANT ALL ON SEQUENCES TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql GRANT ALL ON SEQUENCES TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql GRANT ALL ON SEQUENCES TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR FUNCTIONS; Type: DEFAULT ACL; Schema: graphql; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql GRANT ALL ON FUNCTIONS TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql GRANT ALL ON FUNCTIONS TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql GRANT ALL ON FUNCTIONS TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql GRANT ALL ON FUNCTIONS TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: graphql; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLES TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLES TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLES TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLES TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR SEQUENCES; Type: DEFAULT ACL; Schema: graphql_public; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql_public GRANT ALL ON SEQUENCES TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql_public GRANT ALL ON SEQUENCES TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql_public GRANT ALL ON SEQUENCES TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql_public GRANT ALL ON SEQUENCES TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR FUNCTIONS; Type: DEFAULT ACL; Schema: graphql_public; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql_public GRANT ALL ON FUNCTIONS TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql_public GRANT ALL ON FUNCTIONS TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql_public GRANT ALL ON FUNCTIONS TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql_public GRANT ALL ON FUNCTIONS TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: graphql_public; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql_public GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLES TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql_public GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLES TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql_public GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLES TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql_public GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLES TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR SEQUENCES; Type: DEFAULT ACL; Schema: pgsodium; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA pgsodium GRANT ALL ON SEQUENCES TO pgsodium_keyholder;


--
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: pgsodium; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA pgsodium GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLES TO pgsodium_keyholder;


--
-- Name: DEFAULT PRIVILEGES FOR SEQUENCES; Type: DEFAULT ACL; Schema: pgsodium_masks; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA pgsodium_masks GRANT ALL ON SEQUENCES TO pgsodium_keyiduser;


--
-- Name: DEFAULT PRIVILEGES FOR FUNCTIONS; Type: DEFAULT ACL; Schema: pgsodium_masks; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA pgsodium_masks GRANT ALL ON FUNCTIONS TO pgsodium_keyiduser;


--
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: pgsodium_masks; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA pgsodium_masks GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLES TO pgsodium_keyiduser;


--
-- Name: DEFAULT PRIVILEGES FOR SEQUENCES; Type: DEFAULT ACL; Schema: public; Owner: postgres
--

ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON SEQUENCES TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON SEQUENCES TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON SEQUENCES TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON SEQUENCES TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR SEQUENCES; Type: DEFAULT ACL; Schema: public; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON SEQUENCES TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON SEQUENCES TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON SEQUENCES TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON SEQUENCES TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR FUNCTIONS; Type: DEFAULT ACL; Schema: public; Owner: postgres
--

ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON FUNCTIONS TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON FUNCTIONS TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON FUNCTIONS TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON FUNCTIONS TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR FUNCTIONS; Type: DEFAULT ACL; Schema: public; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON FUNCTIONS TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON FUNCTIONS TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON FUNCTIONS TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON FUNCTIONS TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: public; Owner: postgres
--

ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLES TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLES TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLES TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLES TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: public; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLES TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLES TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLES TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLES TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR SEQUENCES; Type: DEFAULT ACL; Schema: realtime; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA realtime GRANT ALL ON SEQUENCES TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA realtime GRANT ALL ON SEQUENCES TO dashboard_user;


--
-- Name: DEFAULT PRIVILEGES FOR FUNCTIONS; Type: DEFAULT ACL; Schema: realtime; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA realtime GRANT ALL ON FUNCTIONS TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA realtime GRANT ALL ON FUNCTIONS TO dashboard_user;


--
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: realtime; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA realtime GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLES TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA realtime GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLES TO dashboard_user;


--
-- Name: DEFAULT PRIVILEGES FOR SEQUENCES; Type: DEFAULT ACL; Schema: storage; Owner: postgres
--

ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON SEQUENCES TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON SEQUENCES TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON SEQUENCES TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON SEQUENCES TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR FUNCTIONS; Type: DEFAULT ACL; Schema: storage; Owner: postgres
--

ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON FUNCTIONS TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON FUNCTIONS TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON FUNCTIONS TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON FUNCTIONS TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: storage; Owner: postgres
--

ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLES TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLES TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLES TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLES TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR SEQUENCES; Type: DEFAULT ACL; Schema: supabase_functions; Owner: postgres
--

ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA supabase_functions GRANT ALL ON SEQUENCES TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA supabase_functions GRANT ALL ON SEQUENCES TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA supabase_functions GRANT ALL ON SEQUENCES TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA supabase_functions GRANT ALL ON SEQUENCES TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR FUNCTIONS; Type: DEFAULT ACL; Schema: supabase_functions; Owner: postgres
--

ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA supabase_functions GRANT ALL ON FUNCTIONS TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA supabase_functions GRANT ALL ON FUNCTIONS TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA supabase_functions GRANT ALL ON FUNCTIONS TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA supabase_functions GRANT ALL ON FUNCTIONS TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: supabase_functions; Owner: postgres
--

ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA supabase_functions GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLES TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA supabase_functions GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLES TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA supabase_functions GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLES TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA supabase_functions GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLES TO service_role;


--
-- Name: issue_graphql_placeholder; Type: EVENT TRIGGER; Schema: -; Owner: supabase_admin
--

CREATE EVENT TRIGGER issue_graphql_placeholder ON sql_drop
         WHEN TAG IN ('DROP EXTENSION')
   EXECUTE FUNCTION extensions.set_graphql_placeholder();


ALTER EVENT TRIGGER issue_graphql_placeholder OWNER TO supabase_admin;

--
-- Name: issue_pg_cron_access; Type: EVENT TRIGGER; Schema: -; Owner: supabase_admin
--

CREATE EVENT TRIGGER issue_pg_cron_access ON ddl_command_end
         WHEN TAG IN ('CREATE EXTENSION')
   EXECUTE FUNCTION extensions.grant_pg_cron_access();


ALTER EVENT TRIGGER issue_pg_cron_access OWNER TO supabase_admin;

--
-- Name: issue_pg_graphql_access; Type: EVENT TRIGGER; Schema: -; Owner: supabase_admin
--

CREATE EVENT TRIGGER issue_pg_graphql_access ON ddl_command_end
         WHEN TAG IN ('CREATE FUNCTION')
   EXECUTE FUNCTION extensions.grant_pg_graphql_access();


ALTER EVENT TRIGGER issue_pg_graphql_access OWNER TO supabase_admin;

--
-- Name: issue_pg_net_access; Type: EVENT TRIGGER; Schema: -; Owner: postgres
--

CREATE EVENT TRIGGER issue_pg_net_access ON ddl_command_end
         WHEN TAG IN ('CREATE EXTENSION')
   EXECUTE FUNCTION extensions.grant_pg_net_access();


ALTER EVENT TRIGGER issue_pg_net_access OWNER TO postgres;

--
-- Name: pgrst_ddl_watch; Type: EVENT TRIGGER; Schema: -; Owner: supabase_admin
--

CREATE EVENT TRIGGER pgrst_ddl_watch ON ddl_command_end
   EXECUTE FUNCTION extensions.pgrst_ddl_watch();


ALTER EVENT TRIGGER pgrst_ddl_watch OWNER TO supabase_admin;

--
-- Name: pgrst_drop_watch; Type: EVENT TRIGGER; Schema: -; Owner: supabase_admin
--

CREATE EVENT TRIGGER pgrst_drop_watch ON sql_drop
   EXECUTE FUNCTION extensions.pgrst_drop_watch();


ALTER EVENT TRIGGER pgrst_drop_watch OWNER TO supabase_admin;

--
-- PostgreSQL database dump complete
--

