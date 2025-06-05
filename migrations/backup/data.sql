SET session_replication_role = replica;

--
-- PostgreSQL database dump
--

-- Dumped from database version 15.8
-- Dumped by pg_dump version 15.8

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Data for Name: audit_log_entries; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY "auth"."audit_log_entries" ("instance_id", "id", "payload", "created_at", "ip_address") FROM stdin;
00000000-0000-0000-0000-000000000000	e7f17316-3545-4003-8c22-add2f57761aa	{"action":"user_confirmation_requested","actor_id":"32951248-848b-4b17-9cef-e0e8ee782b3e","actor_username":"pritam@bohurupi.com","actor_via_sso":false,"log_type":"user","traits":{"provider":"email"}}	2025-05-30 02:06:40.00703+00	
00000000-0000-0000-0000-000000000000	ad06d504-88e9-4a3d-af4a-4e3c83d6caba	{"action":"user_deleted","actor_id":"00000000-0000-0000-0000-000000000000","actor_username":"service_role","actor_via_sso":false,"log_type":"team","traits":{"user_email":"pritam@bohurupi.com","user_id":"32951248-848b-4b17-9cef-e0e8ee782b3e","user_phone":""}}	2025-05-30 02:10:59.00759+00	
00000000-0000-0000-0000-000000000000	214be258-a717-45d1-b70e-9ce252cbbd29	{"action":"user_signedup","actor_id":"3755485e-a536-4234-830b-164febe71c12","actor_username":"pritam@bohurupi.com","actor_via_sso":false,"log_type":"team","traits":{"provider":"email"}}	2025-05-30 02:11:14.860488+00	
00000000-0000-0000-0000-000000000000	402d4765-25c9-4bfd-8c83-220f32874dd6	{"action":"login","actor_id":"3755485e-a536-4234-830b-164febe71c12","actor_username":"pritam@bohurupi.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-05-30 02:11:14.865441+00	
00000000-0000-0000-0000-000000000000	4ef8d806-4f83-44eb-a406-00a39ec6cb7f	{"action":"login","actor_id":"3755485e-a536-4234-830b-164febe71c12","actor_username":"pritam@bohurupi.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-05-30 02:11:17.238653+00	
00000000-0000-0000-0000-000000000000	d5e37c19-19f3-430d-8a75-cba17902b9c4	{"action":"logout","actor_id":"3755485e-a536-4234-830b-164febe71c12","actor_username":"pritam@bohurupi.com","actor_via_sso":false,"log_type":"account"}	2025-05-30 02:11:18.537833+00	
00000000-0000-0000-0000-000000000000	ae567e13-eff2-4e03-aa31-2b0e213ee332	{"action":"login","actor_id":"3755485e-a536-4234-830b-164febe71c12","actor_username":"pritam@bohurupi.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-05-30 02:11:30.708227+00	
00000000-0000-0000-0000-000000000000	d830c3ec-06e1-449f-9919-ea20cc273a81	{"action":"login","actor_id":"3755485e-a536-4234-830b-164febe71c12","actor_username":"pritam@bohurupi.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-05-30 04:57:41.107967+00	
00000000-0000-0000-0000-000000000000	1f5b09d6-e1b3-48c6-881b-c025d0496ec8	{"action":"token_refreshed","actor_id":"3755485e-a536-4234-830b-164febe71c12","actor_username":"pritam@bohurupi.com","actor_via_sso":false,"log_type":"token"}	2025-05-30 06:00:32.666288+00	
00000000-0000-0000-0000-000000000000	68981038-9c11-4b9c-b5cb-2f196cd62b7e	{"action":"token_revoked","actor_id":"3755485e-a536-4234-830b-164febe71c12","actor_username":"pritam@bohurupi.com","actor_via_sso":false,"log_type":"token"}	2025-05-30 06:00:32.669075+00	
00000000-0000-0000-0000-000000000000	ef2a7127-c87f-4489-88d7-c527117c3154	{"action":"token_refreshed","actor_id":"3755485e-a536-4234-830b-164febe71c12","actor_username":"pritam@bohurupi.com","actor_via_sso":false,"log_type":"token"}	2025-05-30 06:59:14.187561+00	
00000000-0000-0000-0000-000000000000	5d038476-00cc-46df-beff-aa470a67978d	{"action":"token_revoked","actor_id":"3755485e-a536-4234-830b-164febe71c12","actor_username":"pritam@bohurupi.com","actor_via_sso":false,"log_type":"token"}	2025-05-30 06:59:14.189343+00	
00000000-0000-0000-0000-000000000000	000277c8-2a6a-4f62-bdc6-3e5fd4eec238	{"action":"logout","actor_id":"3755485e-a536-4234-830b-164febe71c12","actor_username":"pritam@bohurupi.com","actor_via_sso":false,"log_type":"account"}	2025-05-30 07:01:25.606977+00	
00000000-0000-0000-0000-000000000000	46e19719-862b-499f-8db2-92a07d76149d	{"action":"login","actor_id":"3755485e-a536-4234-830b-164febe71c12","actor_username":"pritam@bohurupi.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-05-30 07:01:33.657091+00	
00000000-0000-0000-0000-000000000000	d4049c2b-b0a2-472a-bbdd-f5f91b635f2c	{"action":"token_refreshed","actor_id":"3755485e-a536-4234-830b-164febe71c12","actor_username":"pritam@bohurupi.com","actor_via_sso":false,"log_type":"token"}	2025-05-30 08:14:08.176759+00	
00000000-0000-0000-0000-000000000000	81944f86-5c14-4091-a22d-5c04106c9374	{"action":"token_revoked","actor_id":"3755485e-a536-4234-830b-164febe71c12","actor_username":"pritam@bohurupi.com","actor_via_sso":false,"log_type":"token"}	2025-05-30 08:14:08.178991+00	
00000000-0000-0000-0000-000000000000	ca8df2b5-8af1-4d09-b392-809e5f36fede	{"action":"token_refreshed","actor_id":"3755485e-a536-4234-830b-164febe71c12","actor_username":"pritam@bohurupi.com","actor_via_sso":false,"log_type":"token"}	2025-05-30 09:12:56.61294+00	
00000000-0000-0000-0000-000000000000	a82e3bbe-36fc-40ac-9c55-b71dfede9daf	{"action":"token_revoked","actor_id":"3755485e-a536-4234-830b-164febe71c12","actor_username":"pritam@bohurupi.com","actor_via_sso":false,"log_type":"token"}	2025-05-30 09:12:56.614264+00	
00000000-0000-0000-0000-000000000000	6e7b4659-0c06-425c-bf99-7ff2d00f4c23	{"action":"token_refreshed","actor_id":"3755485e-a536-4234-830b-164febe71c12","actor_username":"pritam@bohurupi.com","actor_via_sso":false,"log_type":"token"}	2025-05-30 10:11:27.666266+00	
00000000-0000-0000-0000-000000000000	fb019c34-a464-4c97-adf5-aeccfa9c669b	{"action":"token_revoked","actor_id":"3755485e-a536-4234-830b-164febe71c12","actor_username":"pritam@bohurupi.com","actor_via_sso":false,"log_type":"token"}	2025-05-30 10:11:27.667531+00	
00000000-0000-0000-0000-000000000000	fd5f7d9e-7b06-44a1-9db4-1b2de434dfb5	{"action":"token_refreshed","actor_id":"3755485e-a536-4234-830b-164febe71c12","actor_username":"pritam@bohurupi.com","actor_via_sso":false,"log_type":"token"}	2025-05-30 13:13:05.963092+00	
00000000-0000-0000-0000-000000000000	bee18091-4b2c-455f-a9ac-5b99cf5684af	{"action":"token_revoked","actor_id":"3755485e-a536-4234-830b-164febe71c12","actor_username":"pritam@bohurupi.com","actor_via_sso":false,"log_type":"token"}	2025-05-30 13:13:05.964444+00	
00000000-0000-0000-0000-000000000000	667f40a8-8b88-45f0-b0c3-72a07d3563e1	{"action":"token_refreshed","actor_id":"3755485e-a536-4234-830b-164febe71c12","actor_username":"pritam@bohurupi.com","actor_via_sso":false,"log_type":"token"}	2025-05-30 14:11:44.317558+00	
00000000-0000-0000-0000-000000000000	b9e37738-3b04-44e5-b549-3510f1a22813	{"action":"token_revoked","actor_id":"3755485e-a536-4234-830b-164febe71c12","actor_username":"pritam@bohurupi.com","actor_via_sso":false,"log_type":"token"}	2025-05-30 14:11:44.318999+00	
00000000-0000-0000-0000-000000000000	770bc02c-c573-4577-a524-a5ccd7f06f4f	{"action":"token_refreshed","actor_id":"3755485e-a536-4234-830b-164febe71c12","actor_username":"pritam@bohurupi.com","actor_via_sso":false,"log_type":"token"}	2025-05-30 15:10:44.236193+00	
00000000-0000-0000-0000-000000000000	c8c2b4fc-1d64-493c-9139-6cee0d2511f9	{"action":"token_revoked","actor_id":"3755485e-a536-4234-830b-164febe71c12","actor_username":"pritam@bohurupi.com","actor_via_sso":false,"log_type":"token"}	2025-05-30 15:10:44.238057+00	
00000000-0000-0000-0000-000000000000	dbc5a459-2cc1-429e-a91f-38266819180b	{"action":"token_refreshed","actor_id":"3755485e-a536-4234-830b-164febe71c12","actor_username":"pritam@bohurupi.com","actor_via_sso":false,"log_type":"token"}	2025-05-30 16:10:33.626386+00	
00000000-0000-0000-0000-000000000000	acad31a5-d91d-494b-91ca-4bb7a18f797a	{"action":"token_revoked","actor_id":"3755485e-a536-4234-830b-164febe71c12","actor_username":"pritam@bohurupi.com","actor_via_sso":false,"log_type":"token"}	2025-05-30 16:10:33.628389+00	
00000000-0000-0000-0000-000000000000	2ef800fc-368d-4068-84a2-9d47a71243e2	{"action":"token_refreshed","actor_id":"3755485e-a536-4234-830b-164febe71c12","actor_username":"pritam@bohurupi.com","actor_via_sso":false,"log_type":"token"}	2025-05-30 17:09:03.811603+00	
00000000-0000-0000-0000-000000000000	2919e4cb-3d56-406f-9ebf-15bf0f9a081d	{"action":"token_revoked","actor_id":"3755485e-a536-4234-830b-164febe71c12","actor_username":"pritam@bohurupi.com","actor_via_sso":false,"log_type":"token"}	2025-05-30 17:09:03.812925+00	
00000000-0000-0000-0000-000000000000	a1e37453-5e57-4941-bea6-e0b626088306	{"action":"login","actor_id":"3755485e-a536-4234-830b-164febe71c12","actor_username":"pritam@bohurupi.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-05-30 17:55:00.699962+00	
00000000-0000-0000-0000-000000000000	9f31ec3d-2549-44af-a603-6d9ad866ae9f	{"action":"token_refreshed","actor_id":"3755485e-a536-4234-830b-164febe71c12","actor_username":"pritam@bohurupi.com","actor_via_sso":false,"log_type":"token"}	2025-05-31 05:20:43.51792+00	
00000000-0000-0000-0000-000000000000	25a17197-8a91-4411-bc1d-50d226b80cf1	{"action":"token_revoked","actor_id":"3755485e-a536-4234-830b-164febe71c12","actor_username":"pritam@bohurupi.com","actor_via_sso":false,"log_type":"token"}	2025-05-31 05:20:43.520156+00	
00000000-0000-0000-0000-000000000000	f33868c0-1064-4776-81ee-97d7f7f81297	{"action":"login","actor_id":"3755485e-a536-4234-830b-164febe71c12","actor_username":"pritam@bohurupi.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-05-31 05:22:00.159898+00	
00000000-0000-0000-0000-000000000000	083b0322-fb7d-4378-b909-395adb7eca8f	{"action":"token_refreshed","actor_id":"3755485e-a536-4234-830b-164febe71c12","actor_username":"pritam@bohurupi.com","actor_via_sso":false,"log_type":"token"}	2025-05-31 06:20:55.7196+00	
00000000-0000-0000-0000-000000000000	3056b657-c739-41da-9c96-5490d6154495	{"action":"token_revoked","actor_id":"3755485e-a536-4234-830b-164febe71c12","actor_username":"pritam@bohurupi.com","actor_via_sso":false,"log_type":"token"}	2025-05-31 06:20:55.721461+00	
00000000-0000-0000-0000-000000000000	676812f5-6ce4-4460-8520-b6d7a845c07d	{"action":"token_refreshed","actor_id":"3755485e-a536-4234-830b-164febe71c12","actor_username":"pritam@bohurupi.com","actor_via_sso":false,"log_type":"token"}	2025-05-31 07:19:19.468402+00	
00000000-0000-0000-0000-000000000000	3b5581d1-56cf-4620-a18a-b1dc485050fe	{"action":"token_revoked","actor_id":"3755485e-a536-4234-830b-164febe71c12","actor_username":"pritam@bohurupi.com","actor_via_sso":false,"log_type":"token"}	2025-05-31 07:19:19.46966+00	
00000000-0000-0000-0000-000000000000	b147fde2-6e50-4b55-9409-3aa45382459b	{"action":"token_refreshed","actor_id":"3755485e-a536-4234-830b-164febe71c12","actor_username":"pritam@bohurupi.com","actor_via_sso":false,"log_type":"token"}	2025-05-31 08:51:04.286233+00	
00000000-0000-0000-0000-000000000000	3382687b-157c-49c4-a780-d2eecb7f9c44	{"action":"token_revoked","actor_id":"3755485e-a536-4234-830b-164febe71c12","actor_username":"pritam@bohurupi.com","actor_via_sso":false,"log_type":"token"}	2025-05-31 08:51:04.287544+00	
00000000-0000-0000-0000-000000000000	5d45b7a4-2a07-4519-8fb8-48138421c7ee	{"action":"token_refreshed","actor_id":"3755485e-a536-4234-830b-164febe71c12","actor_username":"pritam@bohurupi.com","actor_via_sso":false,"log_type":"token"}	2025-05-31 09:28:14.846024+00	
00000000-0000-0000-0000-000000000000	e378d9b0-763a-4db6-91c6-cf0aabf93fc0	{"action":"token_revoked","actor_id":"3755485e-a536-4234-830b-164febe71c12","actor_username":"pritam@bohurupi.com","actor_via_sso":false,"log_type":"token"}	2025-05-31 09:28:14.847812+00	
00000000-0000-0000-0000-000000000000	4588c3ab-7499-45d8-a294-564c9b476f33	{"action":"login","actor_id":"3755485e-a536-4234-830b-164febe71c12","actor_username":"pritam@bohurupi.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-05-31 09:28:57.763731+00	
00000000-0000-0000-0000-000000000000	010effc3-31e9-4006-9878-807eef066812	{"action":"login","actor_id":"3755485e-a536-4234-830b-164febe71c12","actor_username":"pritam@bohurupi.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-05-31 09:48:08.855997+00	
00000000-0000-0000-0000-000000000000	96935a53-de29-4669-8f37-377543a3e560	{"action":"token_refreshed","actor_id":"3755485e-a536-4234-830b-164febe71c12","actor_username":"pritam@bohurupi.com","actor_via_sso":false,"log_type":"token"}	2025-05-31 09:57:15.040339+00	
00000000-0000-0000-0000-000000000000	6fa8796f-bae4-4025-a526-444748b981db	{"action":"token_revoked","actor_id":"3755485e-a536-4234-830b-164febe71c12","actor_username":"pritam@bohurupi.com","actor_via_sso":false,"log_type":"token"}	2025-05-31 09:57:15.043119+00	
00000000-0000-0000-0000-000000000000	6741004b-975f-4ecd-b501-55ef2046f00f	{"action":"token_refreshed","actor_id":"3755485e-a536-4234-830b-164febe71c12","actor_username":"pritam@bohurupi.com","actor_via_sso":false,"log_type":"token"}	2025-05-31 11:08:35.858765+00	
00000000-0000-0000-0000-000000000000	b6d93d95-6c9d-483a-9d30-c4bde40930c4	{"action":"token_revoked","actor_id":"3755485e-a536-4234-830b-164febe71c12","actor_username":"pritam@bohurupi.com","actor_via_sso":false,"log_type":"token"}	2025-05-31 11:08:35.860417+00	
00000000-0000-0000-0000-000000000000	e5b2c896-0e71-43d0-9fc4-e401d8866e76	{"action":"token_refreshed","actor_id":"3755485e-a536-4234-830b-164febe71c12","actor_username":"pritam@bohurupi.com","actor_via_sso":false,"log_type":"token"}	2025-05-31 11:08:35.887864+00	
00000000-0000-0000-0000-000000000000	bda82f1d-7acc-4578-b198-88d2347576a7	{"action":"token_revoked","actor_id":"3755485e-a536-4234-830b-164febe71c12","actor_username":"pritam@bohurupi.com","actor_via_sso":false,"log_type":"token"}	2025-05-31 11:08:35.88948+00	
00000000-0000-0000-0000-000000000000	cc320ff7-b53d-44dd-8b05-87ba0931acea	{"action":"token_refreshed","actor_id":"3755485e-a536-4234-830b-164febe71c12","actor_username":"pritam@bohurupi.com","actor_via_sso":false,"log_type":"token"}	2025-05-31 12:08:23.107488+00	
00000000-0000-0000-0000-000000000000	edbd25d5-cd00-42de-89d0-0f86857eaa0f	{"action":"token_revoked","actor_id":"3755485e-a536-4234-830b-164febe71c12","actor_username":"pritam@bohurupi.com","actor_via_sso":false,"log_type":"token"}	2025-05-31 12:08:23.109137+00	
00000000-0000-0000-0000-000000000000	2321f0fe-a5ce-49d9-ae49-989ab1f3af36	{"action":"token_refreshed","actor_id":"3755485e-a536-4234-830b-164febe71c12","actor_username":"pritam@bohurupi.com","actor_via_sso":false,"log_type":"token"}	2025-05-31 13:07:03.11596+00	
00000000-0000-0000-0000-000000000000	a13f1c96-7dd2-4d24-a44c-188a7de5abdf	{"action":"token_revoked","actor_id":"3755485e-a536-4234-830b-164febe71c12","actor_username":"pritam@bohurupi.com","actor_via_sso":false,"log_type":"token"}	2025-05-31 13:07:03.118365+00	
00000000-0000-0000-0000-000000000000	1da81492-c618-487d-9c1f-68a069c38da9	{"action":"token_refreshed","actor_id":"3755485e-a536-4234-830b-164febe71c12","actor_username":"pritam@bohurupi.com","actor_via_sso":false,"log_type":"token"}	2025-05-31 14:06:30.613859+00	
00000000-0000-0000-0000-000000000000	6352ae31-1e0b-49ea-a100-c516c2f67a99	{"action":"token_revoked","actor_id":"3755485e-a536-4234-830b-164febe71c12","actor_username":"pritam@bohurupi.com","actor_via_sso":false,"log_type":"token"}	2025-05-31 14:06:30.615541+00	
00000000-0000-0000-0000-000000000000	b12bb86a-8aaf-4c40-92b4-79f6ad4609fe	{"action":"token_refreshed","actor_id":"3755485e-a536-4234-830b-164febe71c12","actor_username":"pritam@bohurupi.com","actor_via_sso":false,"log_type":"token"}	2025-05-31 15:04:58.18637+00	
00000000-0000-0000-0000-000000000000	25ac5f33-d849-45ef-b5e4-5025e7cb7dce	{"action":"token_revoked","actor_id":"3755485e-a536-4234-830b-164febe71c12","actor_username":"pritam@bohurupi.com","actor_via_sso":false,"log_type":"token"}	2025-05-31 15:04:58.188252+00	
00000000-0000-0000-0000-000000000000	8eb4607a-1133-415a-bf52-7c244603cc60	{"action":"token_refreshed","actor_id":"3755485e-a536-4234-830b-164febe71c12","actor_username":"pritam@bohurupi.com","actor_via_sso":false,"log_type":"token"}	2025-05-31 16:22:11.334985+00	
00000000-0000-0000-0000-000000000000	b97d13f8-d69a-463f-8417-bba0145e44ff	{"action":"token_revoked","actor_id":"3755485e-a536-4234-830b-164febe71c12","actor_username":"pritam@bohurupi.com","actor_via_sso":false,"log_type":"token"}	2025-05-31 16:22:11.338191+00	
00000000-0000-0000-0000-000000000000	6f693c10-c097-46c6-bc7e-0302cb5d50d0	{"action":"token_refreshed","actor_id":"3755485e-a536-4234-830b-164febe71c12","actor_username":"pritam@bohurupi.com","actor_via_sso":false,"log_type":"token"}	2025-05-31 17:20:59.470151+00	
00000000-0000-0000-0000-000000000000	9d9968aa-9b5c-4209-81a2-cccbe73bb906	{"action":"token_revoked","actor_id":"3755485e-a536-4234-830b-164febe71c12","actor_username":"pritam@bohurupi.com","actor_via_sso":false,"log_type":"token"}	2025-05-31 17:20:59.473066+00	
00000000-0000-0000-0000-000000000000	2534edae-002b-4083-9611-56bacec24b4e	{"action":"login","actor_id":"3755485e-a536-4234-830b-164febe71c12","actor_username":"pritam@bohurupi.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-05-31 18:19:07.009836+00	
00000000-0000-0000-0000-000000000000	8fe6c261-1993-4595-bc04-ca276f4c7192	{"action":"token_refreshed","actor_id":"3755485e-a536-4234-830b-164febe71c12","actor_username":"pritam@bohurupi.com","actor_via_sso":false,"log_type":"token"}	2025-05-31 18:20:37.809763+00	
00000000-0000-0000-0000-000000000000	1fd80971-cc40-43d7-bfaa-ade98a289bed	{"action":"token_revoked","actor_id":"3755485e-a536-4234-830b-164febe71c12","actor_username":"pritam@bohurupi.com","actor_via_sso":false,"log_type":"token"}	2025-05-31 18:20:37.813539+00	
00000000-0000-0000-0000-000000000000	2b7de4e0-2812-43f7-8b90-5ed227d7bc70	{"action":"login","actor_id":"3755485e-a536-4234-830b-164febe71c12","actor_username":"pritam@bohurupi.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-05-31 18:27:50.279095+00	
00000000-0000-0000-0000-000000000000	79b99f08-5f06-4922-a81f-a68743ce8264	{"action":"login","actor_id":"3755485e-a536-4234-830b-164febe71c12","actor_username":"pritam@bohurupi.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-05-31 18:36:09.997775+00	
00000000-0000-0000-0000-000000000000	39b46c9b-cdb5-4c16-9ba4-a73434c9ca1a	{"action":"token_refreshed","actor_id":"3755485e-a536-4234-830b-164febe71c12","actor_username":"pritam@bohurupi.com","actor_via_sso":false,"log_type":"token"}	2025-06-01 05:34:28.094381+00	
00000000-0000-0000-0000-000000000000	859ef5c4-6ae9-42ec-a83e-367e7a702ffc	{"action":"token_revoked","actor_id":"3755485e-a536-4234-830b-164febe71c12","actor_username":"pritam@bohurupi.com","actor_via_sso":false,"log_type":"token"}	2025-06-01 05:34:28.096299+00	
00000000-0000-0000-0000-000000000000	8fe6cbab-9330-4c9b-89e9-74513c2b3acd	{"action":"token_refreshed","actor_id":"3755485e-a536-4234-830b-164febe71c12","actor_username":"pritam@bohurupi.com","actor_via_sso":false,"log_type":"token"}	2025-06-01 06:36:50.483191+00	
00000000-0000-0000-0000-000000000000	360b812e-eea2-4168-a6c7-695be4bd3f4e	{"action":"token_revoked","actor_id":"3755485e-a536-4234-830b-164febe71c12","actor_username":"pritam@bohurupi.com","actor_via_sso":false,"log_type":"token"}	2025-06-01 06:36:50.485678+00	
00000000-0000-0000-0000-000000000000	cd4a042f-985c-4af6-89a1-eadb1a1e5adb	{"action":"login","actor_id":"3755485e-a536-4234-830b-164febe71c12","actor_username":"pritam@bohurupi.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-06-01 06:53:06.609323+00	
00000000-0000-0000-0000-000000000000	10e5473c-c7e1-4de5-8e51-a897f150c8c1	{"action":"token_refreshed","actor_id":"3755485e-a536-4234-830b-164febe71c12","actor_username":"pritam@bohurupi.com","actor_via_sso":false,"log_type":"token"}	2025-06-01 09:08:25.94996+00	
00000000-0000-0000-0000-000000000000	e7f4c534-4a2e-4990-a448-a78e4ce58596	{"action":"token_revoked","actor_id":"3755485e-a536-4234-830b-164febe71c12","actor_username":"pritam@bohurupi.com","actor_via_sso":false,"log_type":"token"}	2025-06-01 09:08:25.952039+00	
00000000-0000-0000-0000-000000000000	f732a5d3-2d3c-4303-9fd8-c67b5086003c	{"action":"login","actor_id":"3755485e-a536-4234-830b-164febe71c12","actor_username":"pritam@bohurupi.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-06-01 09:59:11.79619+00	
00000000-0000-0000-0000-000000000000	4d34877f-06f2-40df-ba43-f026cf19a79a	{"action":"logout","actor_id":"3755485e-a536-4234-830b-164febe71c12","actor_username":"pritam@bohurupi.com","actor_via_sso":false,"log_type":"account"}	2025-06-01 10:00:30.480384+00	
00000000-0000-0000-0000-000000000000	efbbfe35-4bc9-4ff7-ac85-ffac214c2f97	{"action":"login","actor_id":"3755485e-a536-4234-830b-164febe71c12","actor_username":"pritam@bohurupi.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-06-01 10:03:08.567111+00	
00000000-0000-0000-0000-000000000000	b87d1d5a-2bb4-41e3-a3b4-56580aa5dfed	{"action":"login","actor_id":"3755485e-a536-4234-830b-164febe71c12","actor_username":"pritam@bohurupi.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-06-01 10:08:48.554966+00	
00000000-0000-0000-0000-000000000000	5daeae40-d515-45e4-b674-8e7edcba2432	{"action":"token_refreshed","actor_id":"3755485e-a536-4234-830b-164febe71c12","actor_username":"pritam@bohurupi.com","actor_via_sso":false,"log_type":"token"}	2025-06-01 11:08:13.822319+00	
00000000-0000-0000-0000-000000000000	51462228-730c-41e4-8bc1-3ea422f80e85	{"action":"token_revoked","actor_id":"3755485e-a536-4234-830b-164febe71c12","actor_username":"pritam@bohurupi.com","actor_via_sso":false,"log_type":"token"}	2025-06-01 11:08:13.823777+00	
00000000-0000-0000-0000-000000000000	93d78b49-b634-4bb0-86cb-95dd024f4d16	{"action":"token_refreshed","actor_id":"3755485e-a536-4234-830b-164febe71c12","actor_username":"pritam@bohurupi.com","actor_via_sso":false,"log_type":"token"}	2025-06-01 11:11:11.367814+00	
00000000-0000-0000-0000-000000000000	7cac1120-2a10-4433-b132-1148916f07e4	{"action":"token_revoked","actor_id":"3755485e-a536-4234-830b-164febe71c12","actor_username":"pritam@bohurupi.com","actor_via_sso":false,"log_type":"token"}	2025-06-01 11:11:11.369872+00	
00000000-0000-0000-0000-000000000000	db72db9b-4486-4ed1-abc3-e162a071ce25	{"action":"token_refreshed","actor_id":"3755485e-a536-4234-830b-164febe71c12","actor_username":"pritam@bohurupi.com","actor_via_sso":false,"log_type":"token"}	2025-06-01 12:07:44.276079+00	
00000000-0000-0000-0000-000000000000	633d90c5-851f-450e-a9f8-00dfe3a96255	{"action":"token_revoked","actor_id":"3755485e-a536-4234-830b-164febe71c12","actor_username":"pritam@bohurupi.com","actor_via_sso":false,"log_type":"token"}	2025-06-01 12:07:44.278024+00	
00000000-0000-0000-0000-000000000000	da22b9e6-f75c-4b3e-8ecf-30139a1377e4	{"action":"token_refreshed","actor_id":"3755485e-a536-4234-830b-164febe71c12","actor_username":"pritam@bohurupi.com","actor_via_sso":false,"log_type":"token"}	2025-06-01 12:28:33.877133+00	
00000000-0000-0000-0000-000000000000	f9df73d0-1d49-409d-8e68-2a83edca5ce0	{"action":"token_revoked","actor_id":"3755485e-a536-4234-830b-164febe71c12","actor_username":"pritam@bohurupi.com","actor_via_sso":false,"log_type":"token"}	2025-06-01 12:28:33.879291+00	
00000000-0000-0000-0000-000000000000	3366e7f9-a89a-4e3c-8f21-76b71328da70	{"action":"login","actor_id":"3755485e-a536-4234-830b-164febe71c12","actor_username":"pritam@bohurupi.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-06-01 12:35:18.68351+00	
00000000-0000-0000-0000-000000000000	de3787b2-ea3b-4ba3-bfdd-37963398ed98	{"action":"login","actor_id":"3755485e-a536-4234-830b-164febe71c12","actor_username":"pritam@bohurupi.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-06-01 12:55:02.208776+00	
00000000-0000-0000-0000-000000000000	cd850309-f832-45ed-842a-73e1b130ffbf	{"action":"login","actor_id":"3755485e-a536-4234-830b-164febe71c12","actor_username":"pritam@bohurupi.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-06-01 13:07:30.077252+00	
00000000-0000-0000-0000-000000000000	ed2c085b-de01-4c5e-9b5d-58f282a27371	{"action":"token_refreshed","actor_id":"3755485e-a536-4234-830b-164febe71c12","actor_username":"pritam@bohurupi.com","actor_via_sso":false,"log_type":"token"}	2025-06-01 13:43:56.73957+00	
00000000-0000-0000-0000-000000000000	9829207c-aa70-44f9-af50-265f2642a453	{"action":"token_revoked","actor_id":"3755485e-a536-4234-830b-164febe71c12","actor_username":"pritam@bohurupi.com","actor_via_sso":false,"log_type":"token"}	2025-06-01 13:43:56.741158+00	
00000000-0000-0000-0000-000000000000	c37f7129-bc5f-4988-970f-1b932d5892aa	{"action":"token_refreshed","actor_id":"3755485e-a536-4234-830b-164febe71c12","actor_username":"pritam@bohurupi.com","actor_via_sso":false,"log_type":"token"}	2025-06-01 14:06:55.913107+00	
00000000-0000-0000-0000-000000000000	ca9225a5-5078-4ddb-8d3c-5d92861b9432	{"action":"token_revoked","actor_id":"3755485e-a536-4234-830b-164febe71c12","actor_username":"pritam@bohurupi.com","actor_via_sso":false,"log_type":"token"}	2025-06-01 14:06:55.915016+00	
00000000-0000-0000-0000-000000000000	56e5c262-d6e3-43b4-bf72-ffcc6e962960	{"action":"token_refreshed","actor_id":"3755485e-a536-4234-830b-164febe71c12","actor_username":"pritam@bohurupi.com","actor_via_sso":false,"log_type":"token"}	2025-06-01 14:57:11.796977+00	
00000000-0000-0000-0000-000000000000	e5c90f85-be0d-444b-ac0f-71620dc2e279	{"action":"token_revoked","actor_id":"3755485e-a536-4234-830b-164febe71c12","actor_username":"pritam@bohurupi.com","actor_via_sso":false,"log_type":"token"}	2025-06-01 14:57:11.798274+00	
00000000-0000-0000-0000-000000000000	1fa651d1-d0b6-4bd9-b232-d2e3479502bb	{"action":"token_refreshed","actor_id":"3755485e-a536-4234-830b-164febe71c12","actor_username":"pritam@bohurupi.com","actor_via_sso":false,"log_type":"token"}	2025-06-01 15:06:25.8302+00	
00000000-0000-0000-0000-000000000000	b8d08528-b65e-45c5-b3dc-c18e6c0e1918	{"action":"token_revoked","actor_id":"3755485e-a536-4234-830b-164febe71c12","actor_username":"pritam@bohurupi.com","actor_via_sso":false,"log_type":"token"}	2025-06-01 15:06:25.831442+00	
00000000-0000-0000-0000-000000000000	7c207351-18db-4706-95a3-564215d477ee	{"action":"login","actor_id":"3755485e-a536-4234-830b-164febe71c12","actor_username":"pritam@bohurupi.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-06-01 15:13:24.071694+00	
00000000-0000-0000-0000-000000000000	8fd0cb5b-c6a8-4621-9cc3-f262d34df2ab	{"action":"login","actor_id":"3755485e-a536-4234-830b-164febe71c12","actor_username":"pritam@bohurupi.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-06-01 15:15:50.849516+00	
00000000-0000-0000-0000-000000000000	b442004d-6a6d-4b21-b6f8-92ceba91f42b	{"action":"token_refreshed","actor_id":"3755485e-a536-4234-830b-164febe71c12","actor_username":"pritam@bohurupi.com","actor_via_sso":false,"log_type":"token"}	2025-06-01 16:15:17.628404+00	
00000000-0000-0000-0000-000000000000	176ef62c-b72b-4bb1-8789-ea6a7199086d	{"action":"token_revoked","actor_id":"3755485e-a536-4234-830b-164febe71c12","actor_username":"pritam@bohurupi.com","actor_via_sso":false,"log_type":"token"}	2025-06-01 16:15:17.63249+00	
00000000-0000-0000-0000-000000000000	ca6cea7c-35f6-4f40-91ee-2b3b35dab91e	{"action":"token_refreshed","actor_id":"3755485e-a536-4234-830b-164febe71c12","actor_username":"pritam@bohurupi.com","actor_via_sso":false,"log_type":"token"}	2025-06-01 16:20:14.094148+00	
00000000-0000-0000-0000-000000000000	26b794fa-5989-47dd-aabc-8e764a634126	{"action":"token_revoked","actor_id":"3755485e-a536-4234-830b-164febe71c12","actor_username":"pritam@bohurupi.com","actor_via_sso":false,"log_type":"token"}	2025-06-01 16:20:14.096224+00	
00000000-0000-0000-0000-000000000000	618cdd4f-4be7-4c1b-8a6c-3108bf4b9307	{"action":"token_refreshed","actor_id":"3755485e-a536-4234-830b-164febe71c12","actor_username":"pritam@bohurupi.com","actor_via_sso":false,"log_type":"token"}	2025-06-01 16:31:33.890042+00	
00000000-0000-0000-0000-000000000000	0d53dc4b-943e-468f-9a13-129bcd2f0d8d	{"action":"token_revoked","actor_id":"3755485e-a536-4234-830b-164febe71c12","actor_username":"pritam@bohurupi.com","actor_via_sso":false,"log_type":"token"}	2025-06-01 16:31:33.891932+00	
00000000-0000-0000-0000-000000000000	f1dfd717-f432-4dcb-b576-0d9ef9a65883	{"action":"login","actor_id":"3755485e-a536-4234-830b-164febe71c12","actor_username":"pritam@bohurupi.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-06-01 17:13:58.981395+00	
00000000-0000-0000-0000-000000000000	330d0f3a-4801-456b-b107-586df12d38db	{"action":"token_refreshed","actor_id":"3755485e-a536-4234-830b-164febe71c12","actor_username":"pritam@bohurupi.com","actor_via_sso":false,"log_type":"token"}	2025-06-01 17:30:07.172823+00	
00000000-0000-0000-0000-000000000000	ba5c98f4-cdeb-4102-ad6b-5e41cca9c270	{"action":"token_revoked","actor_id":"3755485e-a536-4234-830b-164febe71c12","actor_username":"pritam@bohurupi.com","actor_via_sso":false,"log_type":"token"}	2025-06-01 17:30:07.174683+00	
00000000-0000-0000-0000-000000000000	66ffdd03-c453-47a5-9305-9278a8349e9b	{"action":"token_refreshed","actor_id":"3755485e-a536-4234-830b-164febe71c12","actor_username":"pritam@bohurupi.com","actor_via_sso":false,"log_type":"token"}	2025-06-01 17:30:08.115337+00	
00000000-0000-0000-0000-000000000000	9910db7a-b9bf-4601-9075-3dec2d36de6f	{"action":"token_refreshed","actor_id":"3755485e-a536-4234-830b-164febe71c12","actor_username":"pritam@bohurupi.com","actor_via_sso":false,"log_type":"token"}	2025-06-01 17:53:55.36917+00	
00000000-0000-0000-0000-000000000000	1d54bb96-3c09-4048-8406-a37373eb9c28	{"action":"token_revoked","actor_id":"3755485e-a536-4234-830b-164febe71c12","actor_username":"pritam@bohurupi.com","actor_via_sso":false,"log_type":"token"}	2025-06-01 17:53:55.372782+00	
00000000-0000-0000-0000-000000000000	3102d3fb-b927-45a9-a633-0c4837dcf299	{"action":"token_refreshed","actor_id":"3755485e-a536-4234-830b-164febe71c12","actor_username":"pritam@bohurupi.com","actor_via_sso":false,"log_type":"token"}	2025-06-01 18:36:27.996696+00	
00000000-0000-0000-0000-000000000000	2503f26c-be90-4ea4-9720-13c5a5f8e27d	{"action":"token_revoked","actor_id":"3755485e-a536-4234-830b-164febe71c12","actor_username":"pritam@bohurupi.com","actor_via_sso":false,"log_type":"token"}	2025-06-01 18:36:27.999912+00	
00000000-0000-0000-0000-000000000000	a5e3309b-9b47-47cb-b581-0b5723483d88	{"action":"token_refreshed","actor_id":"3755485e-a536-4234-830b-164febe71c12","actor_username":"pritam@bohurupi.com","actor_via_sso":false,"log_type":"token"}	2025-06-02 02:11:31.471449+00	
00000000-0000-0000-0000-000000000000	c9883923-5e16-488e-a32f-a99b8817ff6a	{"action":"token_revoked","actor_id":"3755485e-a536-4234-830b-164febe71c12","actor_username":"pritam@bohurupi.com","actor_via_sso":false,"log_type":"token"}	2025-06-02 02:11:31.472915+00	
00000000-0000-0000-0000-000000000000	d2e83bb3-2b6d-49a8-ad01-3b342e436a35	{"action":"token_refreshed","actor_id":"3755485e-a536-4234-830b-164febe71c12","actor_username":"pritam@bohurupi.com","actor_via_sso":false,"log_type":"token"}	2025-06-02 02:15:35.148575+00	
00000000-0000-0000-0000-000000000000	911ddc97-28e4-4b1e-a4da-c5146ca1d7a9	{"action":"token_revoked","actor_id":"3755485e-a536-4234-830b-164febe71c12","actor_username":"pritam@bohurupi.com","actor_via_sso":false,"log_type":"token"}	2025-06-02 02:15:35.1524+00	
00000000-0000-0000-0000-000000000000	8f2cd03f-4254-4287-8805-b764bec95e45	{"action":"token_refreshed","actor_id":"3755485e-a536-4234-830b-164febe71c12","actor_username":"pritam@bohurupi.com","actor_via_sso":false,"log_type":"token"}	2025-06-02 02:46:45.715186+00	
00000000-0000-0000-0000-000000000000	db70a7e8-ba8a-45d1-8337-ff50bce3e28d	{"action":"token_revoked","actor_id":"3755485e-a536-4234-830b-164febe71c12","actor_username":"pritam@bohurupi.com","actor_via_sso":false,"log_type":"token"}	2025-06-02 02:46:45.718141+00	
00000000-0000-0000-0000-000000000000	a4625358-96e7-46f8-86aa-3ac5ad7434a9	{"action":"token_refreshed","actor_id":"3755485e-a536-4234-830b-164febe71c12","actor_username":"pritam@bohurupi.com","actor_via_sso":false,"log_type":"token"}	2025-06-02 03:04:17.385226+00	
00000000-0000-0000-0000-000000000000	4ca1a51c-27a5-4a83-a81d-f6298fa47947	{"action":"token_revoked","actor_id":"3755485e-a536-4234-830b-164febe71c12","actor_username":"pritam@bohurupi.com","actor_via_sso":false,"log_type":"token"}	2025-06-02 03:04:17.387845+00	
00000000-0000-0000-0000-000000000000	e86df43a-1a7d-4f22-8f0a-8b09b66587fa	{"action":"login","actor_id":"3755485e-a536-4234-830b-164febe71c12","actor_username":"pritam@bohurupi.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-06-02 03:51:18.560436+00	
00000000-0000-0000-0000-000000000000	225d22d3-34a8-4008-bfbf-3d0c6eab6884	{"action":"token_refreshed","actor_id":"3755485e-a536-4234-830b-164febe71c12","actor_username":"pritam@bohurupi.com","actor_via_sso":false,"log_type":"token"}	2025-06-02 04:02:47.871241+00	
00000000-0000-0000-0000-000000000000	33f71a2b-7e56-4387-8557-a7fe9f55e7c4	{"action":"token_revoked","actor_id":"3755485e-a536-4234-830b-164febe71c12","actor_username":"pritam@bohurupi.com","actor_via_sso":false,"log_type":"token"}	2025-06-02 04:02:47.874243+00	
00000000-0000-0000-0000-000000000000	353bbef8-54ab-469e-a0e0-5dddd6082dbf	{"action":"token_refreshed","actor_id":"3755485e-a536-4234-830b-164febe71c12","actor_username":"pritam@bohurupi.com","actor_via_sso":false,"log_type":"token"}	2025-06-02 04:04:47.615559+00	
00000000-0000-0000-0000-000000000000	a534e7b6-7f61-408c-8ff1-80b5b4fdc320	{"action":"token_revoked","actor_id":"3755485e-a536-4234-830b-164febe71c12","actor_username":"pritam@bohurupi.com","actor_via_sso":false,"log_type":"token"}	2025-06-02 04:04:47.617491+00	
00000000-0000-0000-0000-000000000000	124b67e6-3007-4de8-9197-f8d7dff3ad0f	{"action":"token_refreshed","actor_id":"3755485e-a536-4234-830b-164febe71c12","actor_username":"pritam@bohurupi.com","actor_via_sso":false,"log_type":"token"}	2025-06-02 04:11:10.631669+00	
00000000-0000-0000-0000-000000000000	987e9bfd-25cc-4880-99f9-6afc69b1a5a4	{"action":"token_revoked","actor_id":"3755485e-a536-4234-830b-164febe71c12","actor_username":"pritam@bohurupi.com","actor_via_sso":false,"log_type":"token"}	2025-06-02 04:11:10.63355+00	
00000000-0000-0000-0000-000000000000	27a33b8f-b710-43ef-a9a2-9dc046cb0bbb	{"action":"token_refreshed","actor_id":"3755485e-a536-4234-830b-164febe71c12","actor_username":"pritam@bohurupi.com","actor_via_sso":false,"log_type":"token"}	2025-06-02 04:50:49.183807+00	
00000000-0000-0000-0000-000000000000	03e9a89e-032e-4b20-91f3-10c27d7f2aaa	{"action":"token_revoked","actor_id":"3755485e-a536-4234-830b-164febe71c12","actor_username":"pritam@bohurupi.com","actor_via_sso":false,"log_type":"token"}	2025-06-02 04:50:49.186794+00	
00000000-0000-0000-0000-000000000000	777cdcde-3eea-49be-8d42-9d2d0bbcb3ec	{"action":"token_refreshed","actor_id":"3755485e-a536-4234-830b-164febe71c12","actor_username":"pritam@bohurupi.com","actor_via_sso":false,"log_type":"token"}	2025-06-02 05:09:51.886082+00	
00000000-0000-0000-0000-000000000000	b954c462-908b-4b6d-a112-7df81a33bf0c	{"action":"token_revoked","actor_id":"3755485e-a536-4234-830b-164febe71c12","actor_username":"pritam@bohurupi.com","actor_via_sso":false,"log_type":"token"}	2025-06-02 05:09:51.888067+00	
00000000-0000-0000-0000-000000000000	aa436997-126b-4fd4-bde1-a4ab7aa4b5f1	{"action":"token_refreshed","actor_id":"3755485e-a536-4234-830b-164febe71c12","actor_username":"pritam@bohurupi.com","actor_via_sso":false,"log_type":"token"}	2025-06-02 05:50:13.318741+00	
00000000-0000-0000-0000-000000000000	1811f5cf-3548-4cc2-b610-a93bac52dd9c	{"action":"token_revoked","actor_id":"3755485e-a536-4234-830b-164febe71c12","actor_username":"pritam@bohurupi.com","actor_via_sso":false,"log_type":"token"}	2025-06-02 05:50:13.320752+00	
00000000-0000-0000-0000-000000000000	1146bf71-2835-4103-866d-78d337601035	{"action":"token_refreshed","actor_id":"3755485e-a536-4234-830b-164febe71c12","actor_username":"pritam@bohurupi.com","actor_via_sso":false,"log_type":"token"}	2025-06-02 06:11:57.124243+00	
00000000-0000-0000-0000-000000000000	9de3c57f-1f58-4137-aa4a-5aa098b6a18c	{"action":"token_revoked","actor_id":"3755485e-a536-4234-830b-164febe71c12","actor_username":"pritam@bohurupi.com","actor_via_sso":false,"log_type":"token"}	2025-06-02 06:11:57.126327+00	
00000000-0000-0000-0000-000000000000	336a6234-5a8d-43b1-a381-592be3927465	{"action":"token_refreshed","actor_id":"3755485e-a536-4234-830b-164febe71c12","actor_username":"pritam@bohurupi.com","actor_via_sso":false,"log_type":"token"}	2025-06-02 06:49:42.578242+00	
00000000-0000-0000-0000-000000000000	78257514-bdc9-4298-99a0-33417f491f94	{"action":"token_revoked","actor_id":"3755485e-a536-4234-830b-164febe71c12","actor_username":"pritam@bohurupi.com","actor_via_sso":false,"log_type":"token"}	2025-06-02 06:49:42.579766+00	
00000000-0000-0000-0000-000000000000	5a489fd4-1c93-44dd-aaeb-44c2a61698a6	{"action":"login","actor_id":"3755485e-a536-4234-830b-164febe71c12","actor_username":"pritam@bohurupi.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-06-02 06:57:58.238379+00	
00000000-0000-0000-0000-000000000000	34b273cd-3331-4d0f-a4fa-4e6f1de6b2f9	{"action":"token_refreshed","actor_id":"3755485e-a536-4234-830b-164febe71c12","actor_username":"pritam@bohurupi.com","actor_via_sso":false,"log_type":"token"}	2025-06-02 08:46:10.024545+00	
00000000-0000-0000-0000-000000000000	3052d024-5c7e-467d-86be-83344ed400aa	{"action":"token_revoked","actor_id":"3755485e-a536-4234-830b-164febe71c12","actor_username":"pritam@bohurupi.com","actor_via_sso":false,"log_type":"token"}	2025-06-02 08:46:10.025936+00	
\.


--
-- Data for Name: flow_state; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY "auth"."flow_state" ("id", "user_id", "auth_code", "code_challenge_method", "code_challenge", "provider_type", "provider_access_token", "provider_refresh_token", "created_at", "updated_at", "authentication_method", "auth_code_issued_at") FROM stdin;
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY "auth"."users" ("instance_id", "id", "aud", "role", "email", "encrypted_password", "email_confirmed_at", "invited_at", "confirmation_token", "confirmation_sent_at", "recovery_token", "recovery_sent_at", "email_change_token_new", "email_change", "email_change_sent_at", "last_sign_in_at", "raw_app_meta_data", "raw_user_meta_data", "is_super_admin", "created_at", "updated_at", "phone", "phone_confirmed_at", "phone_change", "phone_change_token", "phone_change_sent_at", "email_change_token_current", "email_change_confirm_status", "banned_until", "reauthentication_token", "reauthentication_sent_at", "is_sso_user", "deleted_at", "is_anonymous") FROM stdin;
00000000-0000-0000-0000-000000000000	3755485e-a536-4234-830b-164febe71c12	authenticated	authenticated	pritam@bohurupi.com	$2a$10$ynkQ9ooRBzOrp5ZcG7/qsOL5dxJK9bpL2579ZDbVZB38nBsN8Nzni	2025-05-30 02:11:14.861527+00	\N		\N		\N			\N	2025-06-02 06:57:58.240582+00	{"provider": "email", "providers": ["email"]}	{"sub": "3755485e-a536-4234-830b-164febe71c12", "name": "Pritam", "email": "pritam@bohurupi.com", "email_verified": false, "phone_verified": false}	\N	2025-05-30 02:11:14.840248+00	2025-06-02 08:46:10.030205+00	\N	\N			\N		0	\N		\N	f	\N	f
\.


--
-- Data for Name: identities; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY "auth"."identities" ("provider_id", "user_id", "identity_data", "provider", "last_sign_in_at", "created_at", "updated_at", "id") FROM stdin;
3755485e-a536-4234-830b-164febe71c12	3755485e-a536-4234-830b-164febe71c12	{"sub": "3755485e-a536-4234-830b-164febe71c12", "name": "Pritam", "email": "pritam@bohurupi.com", "email_verified": false, "phone_verified": false}	email	2025-05-30 02:11:14.855936+00	2025-05-30 02:11:14.856014+00	2025-05-30 02:11:14.856014+00	48b11cf2-3668-4f95-8dc4-146226dc31f2
\.


--
-- Data for Name: instances; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY "auth"."instances" ("id", "uuid", "raw_base_config", "created_at", "updated_at") FROM stdin;
\.


--
-- Data for Name: sessions; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY "auth"."sessions" ("id", "user_id", "created_at", "updated_at", "factor_id", "aal", "not_after", "refreshed_at", "user_agent", "ip", "tag") FROM stdin;
dbef5347-7ae6-4eda-89d6-e1c0d9525853	3755485e-a536-4234-830b-164febe71c12	2025-05-31 18:27:50.281103+00	2025-05-31 18:27:50.281103+00	\N	aal1	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36	172.69.95.45	\N
0c6b6e78-84ed-48d0-a555-2fae7fdc64ad	3755485e-a536-4234-830b-164febe71c12	2025-05-31 18:36:10.000544+00	2025-06-02 02:15:35.162823+00	\N	aal1	\N	2025-06-02 02:15:35.162564	Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Mobile Safari/537.36	162.158.227.14	\N
0871a62a-9ee2-40ef-8666-0cf27da11e64	3755485e-a536-4234-830b-164febe71c12	2025-06-01 10:03:08.569284+00	2025-06-01 10:03:08.569284+00	\N	aal1	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36	172.69.95.205	\N
eecff29f-5c69-4097-b91c-c5ae0a1940c3	3755485e-a536-4234-830b-164febe71c12	2025-05-30 07:01:33.658571+00	2025-05-31 05:20:43.528407+00	\N	aal1	\N	2025-05-31 05:20:43.528238	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36	172.69.94.181	\N
f91006fc-8b54-4920-b7b5-50822554b3b5	3755485e-a536-4234-830b-164febe71c12	2025-06-01 10:08:48.556203+00	2025-06-01 12:07:44.285713+00	\N	aal1	\N	2025-06-01 12:07:44.285572	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36	162.158.227.14	\N
6055468c-ef67-49b7-a77f-43737a9de40a	3755485e-a536-4234-830b-164febe71c12	2025-05-30 17:55:00.701403+00	2025-05-31 09:28:14.853209+00	\N	aal1	\N	2025-05-31 09:28:14.853047	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36	172.69.178.124	\N
20b4869f-d493-4a5e-85c8-c7a927538c0d	3755485e-a536-4234-830b-164febe71c12	2025-05-31 09:28:57.765743+00	2025-05-31 09:28:57.765743+00	\N	aal1	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36	172.69.178.124	\N
cddaca41-595c-48d2-93f1-b20705a258b9	3755485e-a536-4234-830b-164febe71c12	2025-06-01 12:35:18.685459+00	2025-06-01 12:35:18.685459+00	\N	aal1	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36	162.158.227.191	\N
8314913a-aaf6-4ab1-b65e-719453ffda99	3755485e-a536-4234-830b-164febe71c12	2025-05-31 09:48:08.85838+00	2025-05-31 11:08:35.895491+00	\N	aal1	\N	2025-05-31 11:08:35.89535	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36	172.69.95.73	\N
6c626193-9b32-4cbe-b338-c222c17240ec	3755485e-a536-4234-830b-164febe71c12	2025-06-01 12:55:02.211231+00	2025-06-01 12:55:02.211231+00	\N	aal1	\N	\N	Dart/3.8 (dart:io)	172.69.87.135	\N
ac187787-d061-4219-8e5d-399869fff961	3755485e-a536-4234-830b-164febe71c12	2025-05-31 05:22:00.163277+00	2025-06-02 04:02:47.885432+00	\N	aal1	\N	2025-06-02 04:02:47.885256	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36	172.69.94.155	\N
0c4eead8-43a3-46eb-b27a-85436c0864f3	3755485e-a536-4234-830b-164febe71c12	2025-06-01 17:13:58.983328+00	2025-06-02 04:11:10.639577+00	\N	aal1	\N	2025-06-02 04:11:10.639482	Dart/3.8 (dart:io)	162.158.227.15	\N
b76c2b22-67c1-4ca8-be28-e9cb689f13d5	3755485e-a536-4234-830b-164febe71c12	2025-05-31 18:19:07.012303+00	2025-05-31 18:19:07.012303+00	\N	aal1	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36	162.158.227.191	\N
35a1df3f-98c1-4042-8852-6383f2a1163f	3755485e-a536-4234-830b-164febe71c12	2025-06-01 13:07:30.07888+00	2025-06-01 15:06:25.836837+00	\N	aal1	\N	2025-06-01 15:06:25.836698	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36	172.69.95.11	\N
fb8cf2fc-eb56-4c79-b5de-5dd234da01c6	3755485e-a536-4234-830b-164febe71c12	2025-06-01 15:13:24.073136+00	2025-06-01 15:13:24.073136+00	\N	aal1	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36	172.69.178.68	\N
cb559136-e043-4490-94e3-ae453c137b63	3755485e-a536-4234-830b-164febe71c12	2025-06-01 15:15:50.851893+00	2025-06-01 16:15:17.641836+00	\N	aal1	\N	2025-06-01 16:15:17.641587	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36	172.69.94.209	\N
f2675804-84ae-4dcf-b460-f1dbe25f0703	3755485e-a536-4234-830b-164febe71c12	2025-06-01 06:53:06.612789+00	2025-06-02 06:11:57.131217+00	\N	aal1	\N	2025-06-02 06:11:57.131117	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36	172.69.95.172	\N
0dc92c43-9bec-4dd1-80a5-111f60453e3f	3755485e-a536-4234-830b-164febe71c12	2025-06-02 03:51:18.563073+00	2025-06-02 06:49:42.585244+00	\N	aal1	\N	2025-06-02 06:49:42.585125	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36	172.69.179.32	\N
83cef42e-975b-45b8-99f5-a772ed1b8c1c	3755485e-a536-4234-830b-164febe71c12	2025-06-02 06:57:58.24081+00	2025-06-02 08:46:10.031956+00	\N	aal1	\N	2025-06-02 08:46:10.031836	Dart/3.8 (dart:io)	162.158.235.81	\N
\.


--
-- Data for Name: mfa_amr_claims; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY "auth"."mfa_amr_claims" ("session_id", "created_at", "updated_at", "authentication_method", "id") FROM stdin;
eecff29f-5c69-4097-b91c-c5ae0a1940c3	2025-05-30 07:01:33.663436+00	2025-05-30 07:01:33.663436+00	password	418dd4bc-f5ac-4632-9c30-efbd35838162
6055468c-ef67-49b7-a77f-43737a9de40a	2025-05-30 17:55:00.704442+00	2025-05-30 17:55:00.704442+00	password	12e72209-1427-40a6-979a-d7f5fddbd686
ac187787-d061-4219-8e5d-399869fff961	2025-05-31 05:22:00.170443+00	2025-05-31 05:22:00.170443+00	password	ea47cc0d-aa4b-4933-af48-1cb8f41df62e
20b4869f-d493-4a5e-85c8-c7a927538c0d	2025-05-31 09:28:57.769252+00	2025-05-31 09:28:57.769252+00	password	93077988-a079-4b11-9a02-e7c950c3c58f
8314913a-aaf6-4ab1-b65e-719453ffda99	2025-05-31 09:48:08.862265+00	2025-05-31 09:48:08.862265+00	password	771b53e1-b0ca-42ee-b65a-458f9b8e8e5d
b76c2b22-67c1-4ca8-be28-e9cb689f13d5	2025-05-31 18:19:07.019212+00	2025-05-31 18:19:07.019212+00	password	499e8abc-6d59-429d-b66a-14102db1c218
dbef5347-7ae6-4eda-89d6-e1c0d9525853	2025-05-31 18:27:50.285761+00	2025-05-31 18:27:50.285761+00	password	d832e96e-957d-4be7-b3a8-36c49225a6cf
0c6b6e78-84ed-48d0-a555-2fae7fdc64ad	2025-05-31 18:36:10.005057+00	2025-05-31 18:36:10.005057+00	password	1fbdf676-dd63-421a-99ce-d3d7d984f72d
f2675804-84ae-4dcf-b460-f1dbe25f0703	2025-06-01 06:53:06.620547+00	2025-06-01 06:53:06.620547+00	password	9a626188-3d18-4646-ab87-44c8d5a758e4
0871a62a-9ee2-40ef-8666-0cf27da11e64	2025-06-01 10:03:08.574824+00	2025-06-01 10:03:08.574824+00	password	0acc9ac3-bcec-416b-811b-9691379ebf33
f91006fc-8b54-4920-b7b5-50822554b3b5	2025-06-01 10:08:48.559033+00	2025-06-01 10:08:48.559033+00	password	71f0d04e-a2b1-41fc-96b1-81f69393565a
cddaca41-595c-48d2-93f1-b20705a258b9	2025-06-01 12:35:18.690062+00	2025-06-01 12:35:18.690062+00	password	739e3544-44e8-43ab-9a30-7a583f99e31d
6c626193-9b32-4cbe-b338-c222c17240ec	2025-06-01 12:55:02.216386+00	2025-06-01 12:55:02.216386+00	password	de5c4c54-92aa-4cf5-bda6-b33a36026d5e
35a1df3f-98c1-4042-8852-6383f2a1163f	2025-06-01 13:07:30.084355+00	2025-06-01 13:07:30.084355+00	password	659132c6-f9af-40b6-99d4-3d34120a6e94
fb8cf2fc-eb56-4c79-b5de-5dd234da01c6	2025-06-01 15:13:24.077244+00	2025-06-01 15:13:24.077244+00	password	5b12a112-c196-4b56-96be-e37fed8e67bd
cb559136-e043-4490-94e3-ae453c137b63	2025-06-01 15:15:50.856748+00	2025-06-01 15:15:50.856748+00	password	7e92d5fc-8edc-41ec-b30a-52297d9ea61d
0c4eead8-43a3-46eb-b27a-85436c0864f3	2025-06-01 17:13:58.988343+00	2025-06-01 17:13:58.988343+00	password	be4db9d4-725c-413a-9611-d12b00af97ee
0dc92c43-9bec-4dd1-80a5-111f60453e3f	2025-06-02 03:51:18.569462+00	2025-06-02 03:51:18.569462+00	password	0af67e1b-92da-4c9a-b8c5-d8cb0a2af93d
83cef42e-975b-45b8-99f5-a772ed1b8c1c	2025-06-02 06:57:58.247275+00	2025-06-02 06:57:58.247275+00	password	9e43b876-6724-4b9e-b864-db60e4d1f843
\.


--
-- Data for Name: mfa_factors; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY "auth"."mfa_factors" ("id", "user_id", "friendly_name", "factor_type", "status", "created_at", "updated_at", "secret", "phone", "last_challenged_at", "web_authn_credential", "web_authn_aaguid") FROM stdin;
\.


--
-- Data for Name: mfa_challenges; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY "auth"."mfa_challenges" ("id", "factor_id", "created_at", "verified_at", "ip_address", "otp_code", "web_authn_session_data") FROM stdin;
\.


--
-- Data for Name: one_time_tokens; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY "auth"."one_time_tokens" ("id", "user_id", "token_type", "token_hash", "relates_to", "created_at", "updated_at") FROM stdin;
\.


--
-- Data for Name: refresh_tokens; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY "auth"."refresh_tokens" ("instance_id", "id", "token", "user_id", "revoked", "created_at", "updated_at", "parent", "session_id") FROM stdin;
00000000-0000-0000-0000-000000000000	7	XPwuHrO_DFJNiB1DHw5c0g	3755485e-a536-4234-830b-164febe71c12	t	2025-05-30 07:01:33.660582+00	2025-05-30 08:14:08.180248+00	\N	eecff29f-5c69-4097-b91c-c5ae0a1940c3
00000000-0000-0000-0000-000000000000	8	PIoFpQLyDcXKBGYCGXd8Dw	3755485e-a536-4234-830b-164febe71c12	t	2025-05-30 08:14:08.181447+00	2025-05-30 09:12:56.615345+00	XPwuHrO_DFJNiB1DHw5c0g	eecff29f-5c69-4097-b91c-c5ae0a1940c3
00000000-0000-0000-0000-000000000000	9	PRp346mO2zRNN5hwREPnug	3755485e-a536-4234-830b-164febe71c12	t	2025-05-30 09:12:56.616371+00	2025-05-30 10:11:27.668707+00	PIoFpQLyDcXKBGYCGXd8Dw	eecff29f-5c69-4097-b91c-c5ae0a1940c3
00000000-0000-0000-0000-000000000000	10	A0rJLn9g0X6VW_7sEWEeZA	3755485e-a536-4234-830b-164febe71c12	t	2025-05-30 10:11:27.66977+00	2025-05-30 13:13:05.965308+00	PRp346mO2zRNN5hwREPnug	eecff29f-5c69-4097-b91c-c5ae0a1940c3
00000000-0000-0000-0000-000000000000	11	KTUJjKZPnmUA2NdiWkjIfA	3755485e-a536-4234-830b-164febe71c12	t	2025-05-30 13:13:05.966094+00	2025-05-30 14:11:44.320139+00	A0rJLn9g0X6VW_7sEWEeZA	eecff29f-5c69-4097-b91c-c5ae0a1940c3
00000000-0000-0000-0000-000000000000	12	MOH0_JoLwALOsB96VButdg	3755485e-a536-4234-830b-164febe71c12	t	2025-05-30 14:11:44.321066+00	2025-05-30 15:10:44.23948+00	KTUJjKZPnmUA2NdiWkjIfA	eecff29f-5c69-4097-b91c-c5ae0a1940c3
00000000-0000-0000-0000-000000000000	13	6aV3gqBlhWri2W6BM9IMcQ	3755485e-a536-4234-830b-164febe71c12	t	2025-05-30 15:10:44.24084+00	2025-05-30 16:10:33.629888+00	MOH0_JoLwALOsB96VButdg	eecff29f-5c69-4097-b91c-c5ae0a1940c3
00000000-0000-0000-0000-000000000000	14	V8B4gX80xRvX5VTGJUM5ag	3755485e-a536-4234-830b-164febe71c12	t	2025-05-30 16:10:33.631021+00	2025-05-30 17:09:03.813836+00	6aV3gqBlhWri2W6BM9IMcQ	eecff29f-5c69-4097-b91c-c5ae0a1940c3
00000000-0000-0000-0000-000000000000	15	IH0Wndvm8dS8jApn8Nb0yw	3755485e-a536-4234-830b-164febe71c12	t	2025-05-30 17:09:03.814699+00	2025-05-31 05:20:43.522416+00	V8B4gX80xRvX5VTGJUM5ag	eecff29f-5c69-4097-b91c-c5ae0a1940c3
00000000-0000-0000-0000-000000000000	17	vt4_cp0PXuu8YAUO8asCEw	3755485e-a536-4234-830b-164febe71c12	f	2025-05-31 05:20:43.523324+00	2025-05-31 05:20:43.523324+00	IH0Wndvm8dS8jApn8Nb0yw	eecff29f-5c69-4097-b91c-c5ae0a1940c3
00000000-0000-0000-0000-000000000000	18	Q3wnGMtwACKZ_K2kM8UC5A	3755485e-a536-4234-830b-164febe71c12	t	2025-05-31 05:22:00.166789+00	2025-05-31 06:20:55.722789+00	\N	ac187787-d061-4219-8e5d-399869fff961
00000000-0000-0000-0000-000000000000	19	IyiglBqG92dKI1PftzB1iQ	3755485e-a536-4234-830b-164febe71c12	t	2025-05-31 06:20:55.724153+00	2025-05-31 07:19:19.470449+00	Q3wnGMtwACKZ_K2kM8UC5A	ac187787-d061-4219-8e5d-399869fff961
00000000-0000-0000-0000-000000000000	20	lrFI1ksl4tGfMxgQlFoNaw	3755485e-a536-4234-830b-164febe71c12	t	2025-05-31 07:19:19.471175+00	2025-05-31 08:51:04.288721+00	IyiglBqG92dKI1PftzB1iQ	ac187787-d061-4219-8e5d-399869fff961
00000000-0000-0000-0000-000000000000	16	fmVSSQXaQBhPfEcawS5O7g	3755485e-a536-4234-830b-164febe71c12	t	2025-05-30 17:55:00.702686+00	2025-05-31 09:28:14.848727+00	\N	6055468c-ef67-49b7-a77f-43737a9de40a
00000000-0000-0000-0000-000000000000	22	bPvNdz4pb3YirTD5krLtKw	3755485e-a536-4234-830b-164febe71c12	f	2025-05-31 09:28:14.849457+00	2025-05-31 09:28:14.849457+00	fmVSSQXaQBhPfEcawS5O7g	6055468c-ef67-49b7-a77f-43737a9de40a
00000000-0000-0000-0000-000000000000	23	mb7d_BZC_QaJ-WlyHI2LXQ	3755485e-a536-4234-830b-164febe71c12	f	2025-05-31 09:28:57.767147+00	2025-05-31 09:28:57.767147+00	\N	20b4869f-d493-4a5e-85c8-c7a927538c0d
00000000-0000-0000-0000-000000000000	21	50VydxrQlbhLMB2PGp9ttA	3755485e-a536-4234-830b-164febe71c12	t	2025-05-31 08:51:04.28986+00	2025-05-31 09:57:15.044667+00	lrFI1ksl4tGfMxgQlFoNaw	ac187787-d061-4219-8e5d-399869fff961
00000000-0000-0000-0000-000000000000	25	yWtmaTcj9bILZ2cQB4CJ4A	3755485e-a536-4234-830b-164febe71c12	t	2025-05-31 09:57:15.046137+00	2025-05-31 11:08:35.861456+00	50VydxrQlbhLMB2PGp9ttA	ac187787-d061-4219-8e5d-399869fff961
00000000-0000-0000-0000-000000000000	24	5EgU3UvG_8smFdBfmnCcPg	3755485e-a536-4234-830b-164febe71c12	t	2025-05-31 09:48:08.860119+00	2025-05-31 11:08:35.890412+00	\N	8314913a-aaf6-4ab1-b65e-719453ffda99
00000000-0000-0000-0000-000000000000	27	iDEfOmhaAv8pDrewJP-T0w	3755485e-a536-4234-830b-164febe71c12	f	2025-05-31 11:08:35.891446+00	2025-05-31 11:08:35.891446+00	5EgU3UvG_8smFdBfmnCcPg	8314913a-aaf6-4ab1-b65e-719453ffda99
00000000-0000-0000-0000-000000000000	26	hGf0-s2Ac5UFD3kyRj-6kQ	3755485e-a536-4234-830b-164febe71c12	t	2025-05-31 11:08:35.862781+00	2025-05-31 12:08:23.110007+00	yWtmaTcj9bILZ2cQB4CJ4A	ac187787-d061-4219-8e5d-399869fff961
00000000-0000-0000-0000-000000000000	28	7h4T2Vx3ikzpbR4bM2GM-w	3755485e-a536-4234-830b-164febe71c12	t	2025-05-31 12:08:23.110811+00	2025-05-31 13:07:03.119737+00	hGf0-s2Ac5UFD3kyRj-6kQ	ac187787-d061-4219-8e5d-399869fff961
00000000-0000-0000-0000-000000000000	29	-ZAHD-LLaYXmQs-C5kKV7Q	3755485e-a536-4234-830b-164febe71c12	t	2025-05-31 13:07:03.120679+00	2025-05-31 14:06:30.616552+00	7h4T2Vx3ikzpbR4bM2GM-w	ac187787-d061-4219-8e5d-399869fff961
00000000-0000-0000-0000-000000000000	30	fjx_TCdIfytorm000IQxFw	3755485e-a536-4234-830b-164febe71c12	t	2025-05-31 14:06:30.617467+00	2025-05-31 15:04:58.189699+00	-ZAHD-LLaYXmQs-C5kKV7Q	ac187787-d061-4219-8e5d-399869fff961
00000000-0000-0000-0000-000000000000	31	KeQvdA8eeSK4g9JyORPDgQ	3755485e-a536-4234-830b-164febe71c12	t	2025-05-31 15:04:58.191375+00	2025-05-31 16:22:11.339826+00	fjx_TCdIfytorm000IQxFw	ac187787-d061-4219-8e5d-399869fff961
00000000-0000-0000-0000-000000000000	32	TacdsdIHdOgxLiKFwf2DtA	3755485e-a536-4234-830b-164febe71c12	t	2025-05-31 16:22:11.341182+00	2025-05-31 17:20:59.474917+00	KeQvdA8eeSK4g9JyORPDgQ	ac187787-d061-4219-8e5d-399869fff961
00000000-0000-0000-0000-000000000000	34	sFRQcYJQmvTqcQWSqagcSg	3755485e-a536-4234-830b-164febe71c12	f	2025-05-31 18:19:07.015513+00	2025-05-31 18:19:07.015513+00	\N	b76c2b22-67c1-4ca8-be28-e9cb689f13d5
00000000-0000-0000-0000-000000000000	33	ZZpUNWX8okUbkpr69dkfYA	3755485e-a536-4234-830b-164febe71c12	t	2025-05-31 17:20:59.476294+00	2025-05-31 18:20:37.814707+00	TacdsdIHdOgxLiKFwf2DtA	ac187787-d061-4219-8e5d-399869fff961
00000000-0000-0000-0000-000000000000	36	EdzC0Iw9GGResIAUwemFsg	3755485e-a536-4234-830b-164febe71c12	f	2025-05-31 18:27:50.283127+00	2025-05-31 18:27:50.283127+00	\N	dbef5347-7ae6-4eda-89d6-e1c0d9525853
00000000-0000-0000-0000-000000000000	35	f6yty0FnuFL5Zt1bZGlzrA	3755485e-a536-4234-830b-164febe71c12	t	2025-05-31 18:20:37.815737+00	2025-06-01 05:34:28.097567+00	ZZpUNWX8okUbkpr69dkfYA	ac187787-d061-4219-8e5d-399869fff961
00000000-0000-0000-0000-000000000000	38	nme02PJBLnhP0oLCyKMA9w	3755485e-a536-4234-830b-164febe71c12	t	2025-06-01 05:34:28.098556+00	2025-06-01 06:36:50.487447+00	f6yty0FnuFL5Zt1bZGlzrA	ac187787-d061-4219-8e5d-399869fff961
00000000-0000-0000-0000-000000000000	39	GSrf4e2ZccUls2OyguBofw	3755485e-a536-4234-830b-164febe71c12	t	2025-06-01 06:36:50.489282+00	2025-06-01 09:08:25.953714+00	nme02PJBLnhP0oLCyKMA9w	ac187787-d061-4219-8e5d-399869fff961
00000000-0000-0000-0000-000000000000	43	vcu6zabS1IatNZHmLbQTqA	3755485e-a536-4234-830b-164febe71c12	f	2025-06-01 10:03:08.571142+00	2025-06-01 10:03:08.571142+00	\N	0871a62a-9ee2-40ef-8666-0cf27da11e64
00000000-0000-0000-0000-000000000000	44	Roeo9rLyRmQ44zlpoh5Hng	3755485e-a536-4234-830b-164febe71c12	t	2025-06-01 10:08:48.557426+00	2025-06-01 11:08:13.825008+00	\N	f91006fc-8b54-4920-b7b5-50822554b3b5
00000000-0000-0000-0000-000000000000	40	UG7grL81vZAUEXipdhgNoA	3755485e-a536-4234-830b-164febe71c12	t	2025-06-01 06:53:06.61616+00	2025-06-01 11:11:11.371155+00	\N	f2675804-84ae-4dcf-b460-f1dbe25f0703
00000000-0000-0000-0000-000000000000	45	3UhNSRcKJi2n-k9--Be_uw	3755485e-a536-4234-830b-164febe71c12	t	2025-06-01 11:08:13.825827+00	2025-06-01 12:07:44.279295+00	Roeo9rLyRmQ44zlpoh5Hng	f91006fc-8b54-4920-b7b5-50822554b3b5
00000000-0000-0000-0000-000000000000	47	r9j6ffEO4AAqJ-jSr-PUAA	3755485e-a536-4234-830b-164febe71c12	f	2025-06-01 12:07:44.280403+00	2025-06-01 12:07:44.280403+00	3UhNSRcKJi2n-k9--Be_uw	f91006fc-8b54-4920-b7b5-50822554b3b5
00000000-0000-0000-0000-000000000000	46	G-Vg4gQTdSnGj8V3BKOJ3A	3755485e-a536-4234-830b-164febe71c12	t	2025-06-01 11:11:11.371912+00	2025-06-01 12:28:33.880862+00	UG7grL81vZAUEXipdhgNoA	f2675804-84ae-4dcf-b460-f1dbe25f0703
00000000-0000-0000-0000-000000000000	49	raKcgQDO3SHn_rOPAWgvlQ	3755485e-a536-4234-830b-164febe71c12	f	2025-06-01 12:35:18.687443+00	2025-06-01 12:35:18.687443+00	\N	cddaca41-595c-48d2-93f1-b20705a258b9
00000000-0000-0000-0000-000000000000	50	BzTR9FsPVk590y6YUtvqjQ	3755485e-a536-4234-830b-164febe71c12	f	2025-06-01 12:55:02.213718+00	2025-06-01 12:55:02.213718+00	\N	6c626193-9b32-4cbe-b338-c222c17240ec
00000000-0000-0000-0000-000000000000	48	7eZFy9D0S3RRCMFk9_y-rg	3755485e-a536-4234-830b-164febe71c12	t	2025-06-01 12:28:33.881743+00	2025-06-01 13:43:56.741931+00	G-Vg4gQTdSnGj8V3BKOJ3A	f2675804-84ae-4dcf-b460-f1dbe25f0703
00000000-0000-0000-0000-000000000000	51	Va85LsGzvLGCUOOSBt2A9A	3755485e-a536-4234-830b-164febe71c12	t	2025-06-01 13:07:30.080506+00	2025-06-01 14:06:55.916449+00	\N	35a1df3f-98c1-4042-8852-6383f2a1163f
00000000-0000-0000-0000-000000000000	52	NYSHbqtFrBdGtqKPww-lwg	3755485e-a536-4234-830b-164febe71c12	t	2025-06-01 13:43:56.743077+00	2025-06-01 14:57:11.799133+00	7eZFy9D0S3RRCMFk9_y-rg	f2675804-84ae-4dcf-b460-f1dbe25f0703
00000000-0000-0000-0000-000000000000	53	T8cXUkbiwkoHIJ-BhbaxOQ	3755485e-a536-4234-830b-164febe71c12	t	2025-06-01 14:06:55.918093+00	2025-06-01 15:06:25.832373+00	Va85LsGzvLGCUOOSBt2A9A	35a1df3f-98c1-4042-8852-6383f2a1163f
00000000-0000-0000-0000-000000000000	41	0tPZMoJTpxRvGakWNdqHvA	3755485e-a536-4234-830b-164febe71c12	t	2025-06-01 09:08:25.95493+00	2025-06-01 16:31:33.893083+00	GSrf4e2ZccUls2OyguBofw	ac187787-d061-4219-8e5d-399869fff961
00000000-0000-0000-0000-000000000000	37	WEMY2m_NGunZzKgUzRk-uw	3755485e-a536-4234-830b-164febe71c12	t	2025-05-31 18:36:10.002281+00	2025-06-02 02:15:35.15427+00	\N	0c6b6e78-84ed-48d0-a555-2fae7fdc64ad
00000000-0000-0000-0000-000000000000	78	UrBw4GuX5Nk8tCrcmIzkaA	3755485e-a536-4234-830b-164febe71c12	t	2025-06-02 06:57:58.242982+00	2025-06-02 08:46:10.027085+00	\N	83cef42e-975b-45b8-99f5-a772ed1b8c1c
00000000-0000-0000-0000-000000000000	55	QyoMNhr9If3nmaHbMftIuA	3755485e-a536-4234-830b-164febe71c12	f	2025-06-01 15:06:25.833164+00	2025-06-01 15:06:25.833164+00	T8cXUkbiwkoHIJ-BhbaxOQ	35a1df3f-98c1-4042-8852-6383f2a1163f
00000000-0000-0000-0000-000000000000	56	vkCD7zc_-SxNKCrrvO5SmA	3755485e-a536-4234-830b-164febe71c12	f	2025-06-01 15:13:24.074721+00	2025-06-01 15:13:24.074721+00	\N	fb8cf2fc-eb56-4c79-b5de-5dd234da01c6
00000000-0000-0000-0000-000000000000	79	M1LRBhR15oKY2OpPLzrfAw	3755485e-a536-4234-830b-164febe71c12	f	2025-06-02 08:46:10.028436+00	2025-06-02 08:46:10.028436+00	UrBw4GuX5Nk8tCrcmIzkaA	83cef42e-975b-45b8-99f5-a772ed1b8c1c
00000000-0000-0000-0000-000000000000	57	-768xTEcRym-ZEddF91cQA	3755485e-a536-4234-830b-164febe71c12	t	2025-06-01 15:15:50.853484+00	2025-06-01 16:15:17.634588+00	\N	cb559136-e043-4490-94e3-ae453c137b63
00000000-0000-0000-0000-000000000000	58	AfU2-8l9sYsqfouYpQsSVw	3755485e-a536-4234-830b-164febe71c12	f	2025-06-01 16:15:17.636153+00	2025-06-01 16:15:17.636153+00	-768xTEcRym-ZEddF91cQA	cb559136-e043-4490-94e3-ae453c137b63
00000000-0000-0000-0000-000000000000	54	Q6L_iztw3PrQd_L55fMADA	3755485e-a536-4234-830b-164febe71c12	t	2025-06-01 14:57:11.800086+00	2025-06-01 16:20:14.097595+00	NYSHbqtFrBdGtqKPww-lwg	f2675804-84ae-4dcf-b460-f1dbe25f0703
00000000-0000-0000-0000-000000000000	60	FwduDGnXmatn8m0XpVvKpg	3755485e-a536-4234-830b-164febe71c12	t	2025-06-01 16:31:33.894344+00	2025-06-01 17:30:07.175767+00	0tPZMoJTpxRvGakWNdqHvA	ac187787-d061-4219-8e5d-399869fff961
00000000-0000-0000-0000-000000000000	59	AKWcyo1QzHeebqrxLPGvQA	3755485e-a536-4234-830b-164febe71c12	t	2025-06-01 16:20:14.099168+00	2025-06-01 17:53:55.374826+00	Q6L_iztw3PrQd_L55fMADA	f2675804-84ae-4dcf-b460-f1dbe25f0703
00000000-0000-0000-0000-000000000000	61	imxS2ZphQu4qxkxKkudZDg	3755485e-a536-4234-830b-164febe71c12	t	2025-06-01 17:13:58.985473+00	2025-06-01 18:36:28.001023+00	\N	0c4eead8-43a3-46eb-b27a-85436c0864f3
00000000-0000-0000-0000-000000000000	64	qLOOgRRww-YHptq2uzXY5g	3755485e-a536-4234-830b-164febe71c12	t	2025-06-01 18:36:28.002307+00	2025-06-02 02:11:31.473897+00	imxS2ZphQu4qxkxKkudZDg	0c4eead8-43a3-46eb-b27a-85436c0864f3
00000000-0000-0000-0000-000000000000	66	bX8xdPgQHLFct3gkcSZvOw	3755485e-a536-4234-830b-164febe71c12	f	2025-06-02 02:15:35.156305+00	2025-06-02 02:15:35.156305+00	WEMY2m_NGunZzKgUzRk-uw	0c6b6e78-84ed-48d0-a555-2fae7fdc64ad
00000000-0000-0000-0000-000000000000	63	ORxW-Ralb-rFBPntsceK2Q	3755485e-a536-4234-830b-164febe71c12	t	2025-06-01 17:53:55.376396+00	2025-06-02 02:46:45.720141+00	AKWcyo1QzHeebqrxLPGvQA	f2675804-84ae-4dcf-b460-f1dbe25f0703
00000000-0000-0000-0000-000000000000	62	BgH8jhLGeu8O0l2ozqvR5Q	3755485e-a536-4234-830b-164febe71c12	t	2025-06-01 17:30:07.176746+00	2025-06-02 03:04:17.389511+00	FwduDGnXmatn8m0XpVvKpg	ac187787-d061-4219-8e5d-399869fff961
00000000-0000-0000-0000-000000000000	68	FH2oyt5233DCNvm-HGSx7Q	3755485e-a536-4234-830b-164febe71c12	t	2025-06-02 03:04:17.391362+00	2025-06-02 04:02:47.877935+00	BgH8jhLGeu8O0l2ozqvR5Q	ac187787-d061-4219-8e5d-399869fff961
00000000-0000-0000-0000-000000000000	70	muLXc1GSgBSozecIBbbXCQ	3755485e-a536-4234-830b-164febe71c12	f	2025-06-02 04:02:47.880333+00	2025-06-02 04:02:47.880333+00	FH2oyt5233DCNvm-HGSx7Q	ac187787-d061-4219-8e5d-399869fff961
00000000-0000-0000-0000-000000000000	67	49N2VEP_yKkX6bysEtWTIw	3755485e-a536-4234-830b-164febe71c12	t	2025-06-02 02:46:45.721882+00	2025-06-02 04:04:47.618507+00	ORxW-Ralb-rFBPntsceK2Q	f2675804-84ae-4dcf-b460-f1dbe25f0703
00000000-0000-0000-0000-000000000000	65	UP3x4NseZOEHpHaCkbUPHg	3755485e-a536-4234-830b-164febe71c12	t	2025-06-02 02:11:31.475272+00	2025-06-02 04:11:10.634534+00	qLOOgRRww-YHptq2uzXY5g	0c4eead8-43a3-46eb-b27a-85436c0864f3
00000000-0000-0000-0000-000000000000	72	XzauJ_LUojMwL5w7cA9zMw	3755485e-a536-4234-830b-164febe71c12	f	2025-06-02 04:11:10.635854+00	2025-06-02 04:11:10.635854+00	UP3x4NseZOEHpHaCkbUPHg	0c4eead8-43a3-46eb-b27a-85436c0864f3
00000000-0000-0000-0000-000000000000	69	uTvZOcxA9ZcTlgVAAb9zxA	3755485e-a536-4234-830b-164febe71c12	t	2025-06-02 03:51:18.566029+00	2025-06-02 04:50:49.188591+00	\N	0dc92c43-9bec-4dd1-80a5-111f60453e3f
00000000-0000-0000-0000-000000000000	71	eBvKAFxliRkv62NWA9oMKA	3755485e-a536-4234-830b-164febe71c12	t	2025-06-02 04:04:47.619354+00	2025-06-02 05:09:51.889947+00	49N2VEP_yKkX6bysEtWTIw	f2675804-84ae-4dcf-b460-f1dbe25f0703
00000000-0000-0000-0000-000000000000	73	44a689zerzZYhIHmIRQTKg	3755485e-a536-4234-830b-164febe71c12	t	2025-06-02 04:50:49.190232+00	2025-06-02 05:50:13.322351+00	uTvZOcxA9ZcTlgVAAb9zxA	0dc92c43-9bec-4dd1-80a5-111f60453e3f
00000000-0000-0000-0000-000000000000	74	KLHb8q6UC66H2X6lXTKjOw	3755485e-a536-4234-830b-164febe71c12	t	2025-06-02 05:09:51.891095+00	2025-06-02 06:11:57.12741+00	eBvKAFxliRkv62NWA9oMKA	f2675804-84ae-4dcf-b460-f1dbe25f0703
00000000-0000-0000-0000-000000000000	76	r9fEBggAUw_xCOfRF_wSAA	3755485e-a536-4234-830b-164febe71c12	f	2025-06-02 06:11:57.128224+00	2025-06-02 06:11:57.128224+00	KLHb8q6UC66H2X6lXTKjOw	f2675804-84ae-4dcf-b460-f1dbe25f0703
00000000-0000-0000-0000-000000000000	75	s6QXx2oJt2UVznSM22TnCQ	3755485e-a536-4234-830b-164febe71c12	t	2025-06-02 05:50:13.323531+00	2025-06-02 06:49:42.580609+00	44a689zerzZYhIHmIRQTKg	0dc92c43-9bec-4dd1-80a5-111f60453e3f
00000000-0000-0000-0000-000000000000	77	SMgrpNOSeQ_rWxhdT5Xwvw	3755485e-a536-4234-830b-164febe71c12	f	2025-06-02 06:49:42.581425+00	2025-06-02 06:49:42.581425+00	s6QXx2oJt2UVznSM22TnCQ	0dc92c43-9bec-4dd1-80a5-111f60453e3f
\.


--
-- Data for Name: sso_providers; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY "auth"."sso_providers" ("id", "resource_id", "created_at", "updated_at") FROM stdin;
\.


--
-- Data for Name: saml_providers; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY "auth"."saml_providers" ("id", "sso_provider_id", "entity_id", "metadata_xml", "metadata_url", "attribute_mapping", "created_at", "updated_at", "name_id_format") FROM stdin;
\.


--
-- Data for Name: saml_relay_states; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY "auth"."saml_relay_states" ("id", "sso_provider_id", "request_id", "for_email", "redirect_to", "created_at", "updated_at", "flow_state_id") FROM stdin;
\.


--
-- Data for Name: sso_domains; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY "auth"."sso_domains" ("id", "sso_provider_id", "domain", "created_at", "updated_at") FROM stdin;
\.


--
-- Data for Name: product_categories; Type: TABLE DATA; Schema: public; Owner: supabase_admin
--

COPY "public"."product_categories" ("id", "category_name", "description", "is_active", "created_at", "updated_at") FROM stdin;
54abc0fb-2689-4257-8123-e152e074dedd	Injektion		t	2025-05-30 02:12:00.514319+00	2025-05-30 02:12:00.514319+00
d5cc0d7e-20b6-4c37-9b69-c9a4c1de1192	Tablet		t	2025-05-30 16:23:31.279698+00	2025-05-30 16:23:31.279698+00
47ab7b77-da87-468e-8f45-de6abc261f39	Oral Care		t	2025-06-02 02:49:14.616857+00	2025-06-02 02:49:14.616857+00
\.


--
-- Data for Name: product_formulations; Type: TABLE DATA; Schema: public; Owner: supabase_admin
--

COPY "public"."product_formulations" ("id", "formulation_name", "is_active", "created_at", "updated_at") FROM stdin;
9c1fd489-17a5-4916-a10a-e5fdebeceef1	Demo	t	2025-05-30 02:12:24.373599+00	2025-05-30 02:12:24.373599+00
54a1d4b9-46a4-4c41-a0a7-dc59d263c4be	Tablet	t	2025-05-30 16:34:12.17244+00	2025-05-30 16:34:12.17244+00
069281da-477d-4280-8519-a0a05baa39cb	Liquid	t	2025-06-02 02:50:28.483055+00	2025-06-02 02:50:28.483055+00
\.


--
-- Data for Name: product_sub_categories; Type: TABLE DATA; Schema: public; Owner: supabase_admin
--

COPY "public"."product_sub_categories" ("id", "sub_category_name", "category_id", "description", "is_active", "created_at", "updated_at") FROM stdin;
adf976c0-244d-490b-a59b-273516926285	10mg	54abc0fb-2689-4257-8123-e152e074dedd		t	2025-05-30 02:12:13.292695+00	2025-05-30 02:12:13.292695+00
15e0ce44-e0f9-46b5-b4b1-3322a6d5a3af	Head	d5cc0d7e-20b6-4c37-9b69-c9a4c1de1192		t	2025-05-30 16:23:39.62432+00	2025-05-30 16:23:39.62432+00
26dd0b83-adc1-4292-8ac6-62ff260b9ba4	Mouthwash	47ab7b77-da87-468e-8f45-de6abc261f39		t	2025-06-02 02:49:35.550842+00	2025-06-02 02:49:35.550842+00
\.


--
-- Data for Name: products; Type: TABLE DATA; Schema: public; Owner: supabase_admin
--

COPY "public"."products" ("id", "product_code", "product_name", "generic_name", "manufacturer", "category_id", "sub_category_id", "formulation_id", "unit_of_measure_smallest", "base_cost_per_strip", "is_active", "storage_conditions", "image_url", "min_stock_level_godown", "min_stock_level_mr", "lead_time_days", "created_at", "updated_at", "packaging_template") FROM stdin;
64ee6ca5-9cff-49db-b0c7-0ab9925a57fd	MAP00002	Mvastin 100mg	Mvastin 100mg Injection	Roche Products India Pvt Ltd	54abc0fb-2689-4257-8123-e152e074dedd	adf976c0-244d-490b-a59b-273516926285	9c1fd489-17a5-4916-a10a-e5fdebeceef1	Strip	120.00	t		https://cdn01.pharmeasy.in/dam/products_otc/I03302/caripap-strip-of-15-tablets-1-1733830566.jpg	0	0	0	2025-05-31 07:07:05.456726+00	2025-06-01 17:53:09.727877+00	\N
8b35f1c2-2e51-42cb-8fcb-5d9fad1c4253	MAP00001	Avastin 1000mg	Avastin 1000mg Tablet	Roche Products India Pvt Ltd	d5cc0d7e-20b6-4c37-9b69-c9a4c1de1192	\N	54a1d4b9-46a4-4c41-a0a7-dc59d263c4be	Strip	25.00	t		https://cdn01.pharmeasy.in/dam/products_otc/159115/shelcal-500mg-strip-of-15-tablets-2-1679999355.jpg	0	0	0	2025-05-30 16:34:26.28961+00	2025-06-01 17:53:24.046212+00	\N
b9b19e99-fecd-4d84-b77b-ec41f34999dd	SPD285	Avastin 100mg	Avastin 100mg Injection	Roche Products India Pvt Ltd	54abc0fb-2689-4257-8123-e152e074dedd	adf976c0-244d-490b-a59b-273516926285	9c1fd489-17a5-4916-a10a-e5fdebeceef1	Strip	100.00	t		https://cdn01.pharmeasy.in/dam/products_otc/K58847/everherb-karela-jamun-juice-helps-maintains-healthy-sugar-levels-weight-management-1l-pack-of-2-6.1-1739451211.jpg	0	0	0	2025-05-30 02:12:56.025279+00	2025-06-01 17:53:40.985824+00	\N
2fef80a2-0da2-4243-a60b-39d6918e32e9	MAP00003	Cofsils Gargle	Cofsils Gargle	Cipla Health Ltd	47ab7b77-da87-468e-8f45-de6abc261f39	26dd0b83-adc1-4292-8ac6-62ff260b9ba4	069281da-477d-4280-8519-a0a05baa39cb	Strip	100.00	t		https://cdn01.pharmeasy.in/dam/products_otc/F96910/cofsils-experdine-gargle-100-ml-3-1654169505.jpg	10	0	0	2025-06-02 02:51:37.132731+00	2025-06-02 02:51:37.132731+00	\N
31140cd1-3f14-4ce2-948c-540b199679b5	MAP00004	Sensodyne 	Sensodyne Complete Protection+ Mouth Wash	Pontika Aerotech Ltd	47ab7b77-da87-468e-8f45-de6abc261f39	26dd0b83-adc1-4292-8ac6-62ff260b9ba4	069281da-477d-4280-8519-a0a05baa39cb	Strip	123.00	t		https://images.apollo247.in/pub/media/catalog/product/s/e/sen0508_1-.jpg	0	0	0	2025-06-02 02:56:27.817149+00	2025-06-02 02:56:27.817149+00	\N
\.


--
-- Data for Name: product_batches; Type: TABLE DATA; Schema: public; Owner: supabase_admin
--

COPY "public"."product_batches" ("id", "product_id", "batch_number", "manufacturing_date", "expiry_date", "batch_cost_per_strip", "status", "notes", "created_at", "updated_at") FROM stdin;
71d09ac7-caa9-4e2d-87e2-70893409257a	b9b19e99-fecd-4d84-b77b-ec41f34999dd	PNMX-B001-23	2025-04-01	2025-06-30	100.00	Active	\N	2025-05-30 05:00:42.568808+00	2025-05-30 05:00:42.568808+00
3cea9de2-50ac-48f1-9c1e-f44f027ed2c3	b9b19e99-fecd-4d84-b77b-ec41f34999dd	HFSD-B001-23	2025-05-01	2025-11-06	100.00	Active	\N	2025-05-31 07:13:10.426396+00	2025-05-31 07:13:10.426396+00
7480217f-fb01-43f9-9d0b-352be40602da	64ee6ca5-9cff-49db-b0c7-0ab9925a57fd	VFSD-B001-23	2025-04-01	2025-06-30	120.00	Active	\N	2025-05-31 07:09:43.013543+00	2025-05-31 17:54:02.807209+00
\.


--
-- Data for Name: mr_stock_summary; Type: TABLE DATA; Schema: public; Owner: supabase_admin
--

COPY "public"."mr_stock_summary" ("mr_user_id", "product_id", "batch_id", "current_quantity_strips", "last_updated_at") FROM stdin;
\.


--
-- Data for Name: packaging_templates; Type: TABLE DATA; Schema: public; Owner: supabase_admin
--

COPY "public"."packaging_templates" ("id", "template_name", "unit_name", "conversion_factor_to_strips", "is_base_unit", "order_in_hierarchy", "created_at", "updated_at") FROM stdin;
b71a6461-f640-460c-a8ea-f1d5f1883735	Standard Pharma	Strip	1	t	1	2025-05-30 17:19:10.341687+00	2025-05-30 17:19:10.341687+00
c5d0f6d0-1203-4c0c-b34b-20689a0512dd	Standard Pharma	Box	10	f	2	2025-05-30 17:19:10.341687+00	2025-05-30 17:19:10.341687+00
774c3474-e9e0-4c61-a1bc-613333776670	Standard Pharma	Carton	100	f	3	2025-05-30 17:19:10.341687+00	2025-05-30 17:19:10.341687+00
4d9725e9-114d-42c4-abc4-2773d9ff6d1c	Tablet Packaging	Strip	1	t	1	2025-05-30 17:19:10.341687+00	2025-05-30 17:19:10.341687+00
d2e3fd52-6cd8-484d-9caf-2cd501969b7d	Tablet Packaging	Box	10	f	2	2025-05-30 17:19:10.341687+00	2025-05-30 17:19:10.341687+00
964890af-9c0e-4f2a-8a82-ccff18ea276b	Tablet Packaging	Case	50	f	3	2025-05-30 17:19:10.341687+00	2025-05-30 17:19:10.341687+00
fc6dc6f1-aa57-4d65-b3e2-32d9735f0795	Liquid Medicine	Pack	6	f	2	2025-05-30 17:19:10.341687+00	2025-05-30 17:19:10.341687+00
4492aa0d-be2a-4878-b0fb-53eae6fe5c6d	Liquid Medicine	Carton	24	f	3	2025-05-30 17:19:10.341687+00	2025-05-30 17:19:10.341687+00
fab4df67-78dc-4226-be1c-4387eacddc09	Liquid Medicine	Bottle	1	t	1	2025-05-30 17:19:10.341687+00	2025-05-31 06:58:50.703247+00
\.


--
-- Data for Name: product_packaging_units; Type: TABLE DATA; Schema: public; Owner: supabase_admin
--

COPY "public"."product_packaging_units" ("id", "product_id", "unit_name", "conversion_factor_to_strips", "is_base_unit", "order_in_hierarchy", "default_purchase_unit", "default_sales_unit_mr", "default_sales_unit_direct", "created_at", "updated_at", "template_id") FROM stdin;
9cdf8594-cfe5-49dd-80b3-61dd16030f53	b9b19e99-fecd-4d84-b77b-ec41f34999dd	Pack	1	t	1	f	f	f	2025-05-30 05:43:46.016682+00	2025-05-30 17:46:08.519898+00	c5d0f6d0-1203-4c0c-b34b-20689a0512dd
fd3d69e4-c439-4e88-b3f0-f788f0db610a	8b35f1c2-2e51-42cb-8fcb-5d9fad1c4253	Box	10	t	2	f	f	f	2025-05-31 05:44:46.188029+00	2025-05-31 05:44:46.188029+00	c5d0f6d0-1203-4c0c-b34b-20689a0512dd
42ae5375-4356-4b22-bb93-92d73c24c73a	b9b19e99-fecd-4d84-b77b-ec41f34999dd	Box	10	f	2	t	f	f	2025-05-31 05:45:31.29346+00	2025-05-31 05:45:31.29346+00	c5d0f6d0-1203-4c0c-b34b-20689a0512dd
b02bf199-c3c4-439b-9c13-45db0cd91527	64ee6ca5-9cff-49db-b0c7-0ab9925a57fd	Strip	1	t	1	f	f	t	2025-05-31 07:07:06.1772+00	2025-05-31 07:07:06.1772+00	4d9725e9-114d-42c4-abc4-2773d9ff6d1c
ef6d8be4-79dc-45c8-b9a4-d38c8a86972e	64ee6ca5-9cff-49db-b0c7-0ab9925a57fd	Box	10	f	2	t	t	f	2025-05-31 07:07:06.1772+00	2025-05-31 07:07:06.1772+00	d2e3fd52-6cd8-484d-9caf-2cd501969b7d
257da17f-0516-48d7-8201-791aad2a7362	64ee6ca5-9cff-49db-b0c7-0ab9925a57fd	Case	50	f	3	f	f	f	2025-05-31 07:07:06.1772+00	2025-05-31 07:07:06.1772+00	964890af-9c0e-4f2a-8a82-ccff18ea276b
31f2e2bf-d098-434c-9e4e-a8283d04816b	2fef80a2-0da2-4243-a60b-39d6918e32e9	Bottle	1	t	1	f	f	t	2025-06-02 02:51:37.922961+00	2025-06-02 02:51:37.922961+00	fab4df67-78dc-4226-be1c-4387eacddc09
70776eae-6f4b-488d-92d9-256d72e0fbe2	2fef80a2-0da2-4243-a60b-39d6918e32e9	Pack	6	f	2	t	t	f	2025-06-02 02:51:37.922961+00	2025-06-02 02:51:37.922961+00	fc6dc6f1-aa57-4d65-b3e2-32d9735f0795
13a90a44-b4ff-494a-aa92-827d87d03797	2fef80a2-0da2-4243-a60b-39d6918e32e9	Carton	24	f	3	f	f	f	2025-06-02 02:51:37.922961+00	2025-06-02 02:51:37.922961+00	4492aa0d-be2a-4878-b0fb-53eae6fe5c6d
6bae6a73-9a9e-42a0-966a-55c2baea4bde	31140cd1-3f14-4ce2-948c-540b199679b5	Bottle	1	t	1	f	f	t	2025-06-02 02:56:28.525765+00	2025-06-02 02:56:28.525765+00	fab4df67-78dc-4226-be1c-4387eacddc09
06f046d9-4251-4484-bdb9-d26427cca19e	31140cd1-3f14-4ce2-948c-540b199679b5	Pack	6	f	2	t	t	f	2025-06-02 02:56:28.525765+00	2025-06-02 02:56:28.525765+00	fc6dc6f1-aa57-4d65-b3e2-32d9735f0795
99e5cf9c-ba55-4fef-85e3-9e8053c30eb1	31140cd1-3f14-4ce2-948c-540b199679b5	Carton	24	f	3	f	f	f	2025-06-02 02:56:28.525765+00	2025-06-02 02:56:28.525765+00	4492aa0d-be2a-4878-b0fb-53eae6fe5c6d
\.


--
-- Data for Name: products_stock_status; Type: TABLE DATA; Schema: public; Owner: supabase_admin
--

COPY "public"."products_stock_status" ("id", "product_id", "batch_id", "location_type", "location_id", "current_quantity_strips", "cost_per_strip", "last_updated_at", "created_at") FROM stdin;
\.


--
-- Data for Name: profiles; Type: TABLE DATA; Schema: public; Owner: supabase_admin
--

COPY "public"."profiles" ("id", "user_id", "name", "email", "role", "created_at", "updated_at") FROM stdin;
a0ce0311-abb5-4b82-a45b-e1b6789d2ac4	3755485e-a536-4234-830b-164febe71c12	Pritam	pritam@bohurupi.com	admin	2025-05-30 02:11:14.839723+00	2025-05-30 02:11:14.839723+00
\.


--
-- Data for Name: stock_adjustments; Type: TABLE DATA; Schema: public; Owner: supabase_admin
--

COPY "public"."stock_adjustments" ("adjustment_id", "adjustment_group_id", "product_id", "batch_id", "adjustment_type", "quantity_strips", "location_type_source", "location_id_source", "location_type_destination", "location_id_destination", "adjustment_date", "reference_document_id", "cost_per_strip", "notes", "created_by", "created_at") FROM stdin;
2a4e2000-bf03-49af-9d9e-f85c029874b1	5b8e4671-4157-4a13-a4ea-8d2a6a3a326c	b9b19e99-fecd-4d84-b77b-ec41f34999dd	3cea9de2-50ac-48f1-9c1e-f44f027ed2c3	RETURN_TO_GODOWN	3	CUSTOMER	CUSTOMER	GODOWN	GODOWN	2025-05-31 00:00:00+00	\N	100.00		3755485e-a536-4234-830b-164febe71c12	2025-05-31 14:46:03.892312+00
58e0e604-3164-4a33-bf0e-ff5ae5b93ea2	81f0e155-aa84-433b-a157-1cd1e19c0e60	b9b19e99-fecd-4d84-b77b-ec41f34999dd	3cea9de2-50ac-48f1-9c1e-f44f027ed2c3	RETURN_TO_GODOWN	10	CUSTOMER	CUSTOMER	GODOWN	GODOWN	2025-06-01 00:00:00+00	\N	100.00		3755485e-a536-4234-830b-164febe71c12	2025-06-01 05:55:46.509454+00
\.


--
-- Data for Name: stock_purchases; Type: TABLE DATA; Schema: public; Owner: supabase_admin
--

COPY "public"."stock_purchases" ("purchase_id", "purchase_group_id", "product_id", "batch_id", "quantity_strips", "supplier_id", "purchase_date", "reference_document_id", "cost_per_strip", "notes", "created_by", "created_at") FROM stdin;
2fcffbf6-a68e-4f63-bad9-4324851cc454	1ea39695-9ee7-491a-b41d-46b2f48e19f1	b9b19e99-fecd-4d84-b77b-ec41f34999dd	3cea9de2-50ac-48f1-9c1e-f44f027ed2c3	100	MediPharma Ltd	2025-05-31 00:00:00+00	454545	100.00		3755485e-a536-4234-830b-164febe71c12	2025-05-31 14:28:14.876461+00
b6c20f10-0816-43f5-ae8b-3cb2a22445f2	59228cc8-a89a-44f8-bff6-190ee9d22a4a	b9b19e99-fecd-4d84-b77b-ec41f34999dd	71d09ac7-caa9-4e2d-87e2-70893409257a	1000	MediPharma Ltd	2025-05-31 00:00:00+00	45454553g	100.00		3755485e-a536-4234-830b-164febe71c12	2025-05-31 14:48:30.215883+00
7604dc43-aa99-4de5-babc-357ee9ad6343	5d179183-bba9-4f8c-ba0d-381a2e281eb7	64ee6ca5-9cff-49db-b0c7-0ab9925a57fd	7480217f-fb01-43f9-9d0b-352be40602da	20	Pharma Solutions	2025-05-31 00:00:00+00	45454553g	120.00		3755485e-a536-4234-830b-164febe71c12	2025-05-31 15:15:54.574181+00
a31a193a-0f88-4c6d-b1bb-37aa1b4e9856	f6dedf62-2371-4926-bb84-44a2dfe559b1	b9b19e99-fecd-4d84-b77b-ec41f34999dd	3cea9de2-50ac-48f1-9c1e-f44f027ed2c3	30	MediPharma Ltd	2025-05-31 00:00:00+00	45454553h	100.00		3755485e-a536-4234-830b-164febe71c12	2025-05-31 16:46:52.896146+00
846f8e3c-7c12-413f-a1d8-fd4bbcd41a0f	e0d36bfb-b187-4e80-9d20-047e4806b3aa	64ee6ca5-9cff-49db-b0c7-0ab9925a57fd	7480217f-fb01-43f9-9d0b-352be40602da	350	Global Healthcare	2025-05-31 00:00:00+00	454545	120.00		3755485e-a536-4234-830b-164febe71c12	2025-05-31 17:53:03.319531+00
\.


--
-- Data for Name: stock_sales; Type: TABLE DATA; Schema: public; Owner: supabase_admin
--

COPY "public"."stock_sales" ("sale_id", "sale_group_id", "product_id", "batch_id", "transaction_type", "quantity_strips", "location_type_source", "location_id_source", "location_type_destination", "location_id_destination", "sale_date", "reference_document_id", "cost_per_strip", "notes", "created_by", "created_at") FROM stdin;
63bfc50b-0cd6-406c-9f94-8ecb871f4a3a	781d8e9c-2304-47dd-8a4b-ef2fbe47afc9	b9b19e99-fecd-4d84-b77b-ec41f34999dd	3cea9de2-50ac-48f1-9c1e-f44f027ed2c3	SALE_DIRECT_GODOWN	20	GODOWN	GODOWN_MAIN	CUSTOMER	Divine	2025-05-31 00:00:00+00	455454	100.00		3755485e-a536-4234-830b-164febe71c12	2025-05-31 14:28:55.533941+00
284c776a-51f7-48de-9c51-5475605506e0	3f735023-72ac-4890-83b0-d28606668ed6	b9b19e99-fecd-4d84-b77b-ec41f34999dd	71d09ac7-caa9-4e2d-87e2-70893409257a	SALE_DIRECT_GODOWN	50	GODOWN	GODOWN_MAIN	CUSTOMER	Divine3	2025-05-31 00:00:00+00	25454B	100.00		3755485e-a536-4234-830b-164febe71c12	2025-05-31 14:50:11.531273+00
60128344-aa6c-4310-99e9-64e87ee354e4	e00e6898-097a-436c-9f43-1902b9c9871a	b9b19e99-fecd-4d84-b77b-ec41f34999dd	71d09ac7-caa9-4e2d-87e2-70893409257a	SALE_DIRECT_GODOWN	30	GODOWN	GODOWN_MAIN	CUSTOMER	Divine3	2025-05-31 00:00:00+00	25454	100.00		3755485e-a536-4234-830b-164febe71c12	2025-05-31 18:02:21.519929+00
cd87b103-c8fe-46ad-a620-f1512b278fc5	8529d933-b48c-420b-83d6-69771f382c9a	b9b19e99-fecd-4d84-b77b-ec41f34999dd	71d09ac7-caa9-4e2d-87e2-70893409257a	SALE_DIRECT_GODOWN	20	GODOWN	GODOWN_MAIN	CUSTOMER	Divine	2025-05-31 00:00:00+00	25454KK	100.00		3755485e-a536-4234-830b-164febe71c12	2025-05-31 18:22:02.229487+00
\.


--
-- Data for Name: stock_transactions; Type: TABLE DATA; Schema: public; Owner: supabase_admin
--

COPY "public"."stock_transactions" ("transaction_id", "transaction_group_id", "product_id", "batch_id", "transaction_type", "quantity_strips", "location_type_source", "location_id_source", "location_type_destination", "location_id_destination", "transaction_date", "reference_document_type", "reference_document_id", "cost_per_strip_at_transaction", "notes", "created_by", "created_at") FROM stdin;
\.


--
-- Data for Name: suppliers; Type: TABLE DATA; Schema: public; Owner: supabase_admin
--

COPY "public"."suppliers" ("id", "supplier_name", "supplier_code", "contact_person", "phone", "email", "address", "is_active", "created_at", "updated_at") FROM stdin;
35604734-c3b0-4f2d-bc3f-25a07d490991	MediPharma Ltd	MED001	John Smith	+91-9876543210	john@medipharma.com	\N	t	2025-05-30 02:32:27.076252+00	2025-05-30 02:32:27.076252+00
1a77e162-21b0-4f07-897f-ffdafc7c3834	Global Healthcare	GLB001	Sarah Johnson	+91-9876543211	sarah@globalhc.com	\N	t	2025-05-30 02:32:27.076252+00	2025-05-30 02:32:27.076252+00
19ba9e0a-86c5-4a05-bb22-845c10e3879a	Pharma Solutions	PHA001	Mike Wilson	+91-9876543212	mike@pharmasol.com	\N	t	2025-05-30 02:32:27.076252+00	2025-05-30 02:32:27.076252+00
\.


--
-- Data for Name: buckets; Type: TABLE DATA; Schema: storage; Owner: supabase_storage_admin
--

COPY "storage"."buckets" ("id", "name", "owner", "created_at", "updated_at", "public", "avif_autodetection", "file_size_limit", "allowed_mime_types", "owner_id") FROM stdin;
\.


--
-- Data for Name: objects; Type: TABLE DATA; Schema: storage; Owner: supabase_storage_admin
--

COPY "storage"."objects" ("id", "bucket_id", "name", "owner", "created_at", "updated_at", "last_accessed_at", "metadata", "version", "owner_id", "user_metadata") FROM stdin;
\.


--
-- Data for Name: s3_multipart_uploads; Type: TABLE DATA; Schema: storage; Owner: supabase_storage_admin
--

COPY "storage"."s3_multipart_uploads" ("id", "in_progress_size", "upload_signature", "bucket_id", "key", "version", "owner_id", "created_at", "user_metadata") FROM stdin;
\.


--
-- Data for Name: s3_multipart_uploads_parts; Type: TABLE DATA; Schema: storage; Owner: supabase_storage_admin
--

COPY "storage"."s3_multipart_uploads_parts" ("id", "upload_id", "size", "part_number", "bucket_id", "key", "etag", "owner_id", "version", "created_at") FROM stdin;
\.


--
-- Data for Name: hooks; Type: TABLE DATA; Schema: supabase_functions; Owner: supabase_functions_admin
--

COPY "supabase_functions"."hooks" ("id", "hook_table_id", "hook_name", "created_at", "request_id") FROM stdin;
\.


--
-- Name: refresh_tokens_id_seq; Type: SEQUENCE SET; Schema: auth; Owner: supabase_auth_admin
--

SELECT pg_catalog.setval('"auth"."refresh_tokens_id_seq"', 79, true);


--
-- Name: hooks_id_seq; Type: SEQUENCE SET; Schema: supabase_functions; Owner: supabase_functions_admin
--

SELECT pg_catalog.setval('"supabase_functions"."hooks_id_seq"', 1, false);


--
-- PostgreSQL database dump complete
--

RESET ALL;
