--
-- PostgreSQL database dump
--

\restrict BN8D0LmSIYpO7B9rhEKlbxgOvgL0hNqCBl82chgbq3Flqre4HIvg4dHWLWSKScO

-- Dumped from database version 16.10 (Debian 16.10-1.pgdg13+1)
-- Dumped by pg_dump version 16.10 (Debian 16.10-1.pgdg13+1)

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

ALTER TABLE IF EXISTS ONLY public.reports DROP CONSTRAINT IF EXISTS reports_reporter_id_fkey;
ALTER TABLE IF EXISTS ONLY public.report_status_histories DROP CONSTRAINT IF EXISTS report_status_histories_report_id_fkey;
ALTER TABLE IF EXISTS ONLY public.report_status_histories DROP CONSTRAINT IF EXISTS report_status_histories_approver_id_fkey;
DROP INDEX IF EXISTS public.users_email_key;
ALTER TABLE IF EXISTS ONLY public.users DROP CONSTRAINT IF EXISTS users_pkey;
ALTER TABLE IF EXISTS ONLY public.reports DROP CONSTRAINT IF EXISTS reports_pkey;
ALTER TABLE IF EXISTS ONLY public.report_status_histories DROP CONSTRAINT IF EXISTS report_status_histories_pkey;
ALTER TABLE IF EXISTS ONLY public._prisma_migrations DROP CONSTRAINT IF EXISTS _prisma_migrations_pkey;
DROP TABLE IF EXISTS public.users;
DROP TABLE IF EXISTS public.reports;
DROP TABLE IF EXISTS public.report_status_histories;
DROP TABLE IF EXISTS public._prisma_migrations;
DROP TYPE IF EXISTS public."USER_ROLE";
DROP TYPE IF EXISTS public."REPORT_STATUS";
-- *not* dropping schema, since initdb creates it
--
-- Name: public; Type: SCHEMA; Schema: -; Owner: -
--

-- *not* creating schema, since initdb creates it


--
-- Name: SCHEMA public; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON SCHEMA public IS '';


--
-- Name: REPORT_STATUS; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public."REPORT_STATUS" AS ENUM (
    'PENDING',
    'APPROVED',
    'REJECTED'
);


--
-- Name: USER_ROLE; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public."USER_ROLE" AS ENUM (
    'ADMIN',
    'APPROVER',
    'REPORTER'
);


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: _prisma_migrations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public._prisma_migrations (
    id character varying(36) NOT NULL,
    checksum character varying(64) NOT NULL,
    finished_at timestamp with time zone,
    migration_name character varying(255) NOT NULL,
    logs text,
    rolled_back_at timestamp with time zone,
    started_at timestamp with time zone DEFAULT now() NOT NULL,
    applied_steps_count integer DEFAULT 0 NOT NULL
);


--
-- Name: report_status_histories; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.report_status_histories (
    id text NOT NULL,
    report_id text NOT NULL,
    status public."REPORT_STATUS" NOT NULL,
    approver_id text NOT NULL,
    created_at timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp(3) without time zone NOT NULL
);


--
-- Name: reports; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.reports (
    id text NOT NULL,
    title text NOT NULL,
    description text NOT NULL,
    status public."REPORT_STATUS" DEFAULT 'PENDING'::public."REPORT_STATUS" NOT NULL,
    reporter_id text NOT NULL,
    created_at timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp(3) without time zone NOT NULL
);


--
-- Name: users; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.users (
    id text NOT NULL,
    name text NOT NULL,
    email text NOT NULL,
    password text NOT NULL,
    role public."USER_ROLE" DEFAULT 'REPORTER'::public."USER_ROLE" NOT NULL,
    picture_url text,
    is_active boolean DEFAULT true NOT NULL,
    created_by text DEFAULT 'SYSTEM'::text NOT NULL,
    created_at timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp(3) without time zone NOT NULL
);


--
-- Data for Name: _prisma_migrations; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public._prisma_migrations (id, checksum, finished_at, migration_name, logs, rolled_back_at, started_at, applied_steps_count) FROM stdin;
593faade-13e8-47d3-b450-ffe14c413e93	b5b6b38e4fb534e86cdca490bd23720567e2d0ae9d4c3ab1512825f9c1c1d0b7	2026-10-13 14:39:59.026414+00	20261012180919_create_users	\N	\N	2026-10-13 14:39:58.967187+00	1
c217ccd6-facb-4920-a2b1-71bf73b6653a	33dbaa1346dc9435bd9890e8d40c9bc5b9d7585dc4a400225eef3fc618e90238	2026-10-13 14:39:59.079661+00	20261012180930_create_reports	\N	\N	2026-10-13 14:39:59.032078+00	1
1ef00b98-a6de-4b4b-a7a8-71fee0a12ad7	39fbba46a48d9a28340ee3d6afac3b76e71ba6b5215318c178b7d022b0f435a8	2026-10-13 14:39:59.127638+00	20261012181041_create_report_status_histories	\N	\N	2026-10-13 14:39:59.084226+00	1
\.


--
-- Data for Name: report_status_histories; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.report_status_histories (id, report_id, status, approver_id, created_at, updated_at) FROM stdin;
00000000-0000-4000-9200-000000000001	00000000-0000-4000-8000-000000000001	REJECTED	2b55a971-24f2-4e8b-824d-b333805438a8	2026-06-23 01:44:20.121	2026-06-23 01:44:20.121
00000000-0000-4000-9200-000000000002	00000000-0000-4000-8000-000000000002	REJECTED	2b55a971-24f2-4e8b-824d-b333805438a8	2026-07-23 07:32:05.749	2026-07-23 07:32:05.749
00000000-0000-4000-9200-000000000003	00000000-0000-4000-8000-000000000003	REJECTED	2b55a971-24f2-4e8b-824d-b333805438a8	2026-07-03 10:52:11.347	2026-07-03 10:52:11.347
00000000-0000-4000-9200-000000000004	00000000-0000-4000-8000-000000000004	APPROVED	2b55a971-24f2-4e8b-824d-b333805438a8	2026-08-22 16:26:14.46	2026-08-22 16:26:14.46
00000000-0000-4000-9200-000000000006	00000000-0000-4000-8000-000000000006	REJECTED	2b55a971-24f2-4e8b-824d-b333805438a8	2026-08-27 18:40:20.206	2026-08-27 18:40:20.206
00000000-0000-4000-9200-000000000009	00000000-0000-4000-8000-000000000009	APPROVED	2b55a971-24f2-4e8b-824d-b333805438a8	2026-08-04 03:36:37.291	2026-08-04 03:36:37.291
00000000-0000-4000-9200-000000000010	00000000-0000-4000-8000-000000000010	REJECTED	2b55a971-24f2-4e8b-824d-b333805438a8	2026-09-03 18:30:14.905	2026-09-03 18:30:14.905
00000000-0000-4000-9200-000000000011	00000000-0000-4000-8000-000000000011	REJECTED	2b55a971-24f2-4e8b-824d-b333805438a8	2026-07-26 12:45:10.306	2026-07-26 12:45:10.306
00000000-0000-4000-9200-000000000014	00000000-0000-4000-8000-000000000014	APPROVED	2b55a971-24f2-4e8b-824d-b333805438a8	2026-08-02 16:47:22.341	2026-08-02 16:47:22.341
00000000-0000-4000-9200-000000000016	00000000-0000-4000-8000-000000000016	APPROVED	2b55a971-24f2-4e8b-824d-b333805438a8	2026-10-04 18:26:48.895	2026-10-04 18:26:48.895
00000000-0000-4000-9200-000000000017	00000000-0000-4000-8000-000000000017	APPROVED	2b55a971-24f2-4e8b-824d-b333805438a8	2026-08-02 18:30:21.002	2026-08-02 18:30:21.002
00000000-0000-4000-9200-000000000018	00000000-0000-4000-8000-000000000018	APPROVED	2b55a971-24f2-4e8b-824d-b333805438a8	2026-08-06 09:44:05.615	2026-08-06 09:44:05.615
00000000-0000-4000-9200-000000000019	00000000-0000-4000-8000-000000000019	APPROVED	2b55a971-24f2-4e8b-824d-b333805438a8	2026-07-13 09:51:43.858	2026-07-13 09:51:43.858
00000000-0000-4000-9100-000000000020	00000000-0000-4000-8000-000000000020	APPROVED	2b55a971-24f2-4e8b-824d-b333805438a8	2026-09-27 06:47:00.121	2026-09-27 06:47:00.121
00000000-0000-4000-9200-000000000020	00000000-0000-4000-8000-000000000020	REJECTED	2b55a971-24f2-4e8b-824d-b333805438a8	2026-09-28 04:21:03.856	2026-09-28 04:21:03.856
00000000-0000-4000-9200-000000000021	00000000-0000-4000-8000-000000000021	REJECTED	2b55a971-24f2-4e8b-824d-b333805438a8	2026-09-26 22:29:32.116	2026-09-26 22:29:32.116
00000000-0000-4000-9100-000000000024	00000000-0000-4000-8000-000000000024	REJECTED	2b55a971-24f2-4e8b-824d-b333805438a8	2026-09-08 19:21:43.864	2026-09-08 19:21:43.864
00000000-0000-4000-9200-000000000024	00000000-0000-4000-8000-000000000024	APPROVED	2b55a971-24f2-4e8b-824d-b333805438a8	2026-09-09 18:55:07.794	2026-09-09 18:55:07.794
00000000-0000-4000-9200-000000000025	00000000-0000-4000-8000-000000000025	APPROVED	2b55a971-24f2-4e8b-824d-b333805438a8	2026-09-29 18:04:44.482	2026-09-29 18:04:44.482
00000000-0000-4000-9200-000000000027	00000000-0000-4000-8000-000000000027	REJECTED	2b55a971-24f2-4e8b-824d-b333805438a8	2026-07-23 10:16:19.622	2026-07-23 10:16:19.622
00000000-0000-4000-9200-000000000028	00000000-0000-4000-8000-000000000028	APPROVED	2b55a971-24f2-4e8b-824d-b333805438a8	2026-09-17 08:23:17.798	2026-09-17 08:23:17.798
00000000-0000-4000-9200-000000000029	00000000-0000-4000-8000-000000000029	APPROVED	2b55a971-24f2-4e8b-824d-b333805438a8	2026-08-08 09:32:37.289	2026-08-08 09:32:37.289
00000000-0000-4000-9200-000000000030	00000000-0000-4000-8000-000000000030	APPROVED	2b55a971-24f2-4e8b-824d-b333805438a8	2026-09-03 21:44:19.301	2026-09-03 21:44:19.301
00000000-0000-4000-9200-000000000031	00000000-0000-4000-8000-000000000031	APPROVED	2b55a971-24f2-4e8b-824d-b333805438a8	2026-10-02 15:20:17.927	2026-10-02 15:20:17.927
00000000-0000-4000-9200-000000000032	00000000-0000-4000-8000-000000000032	REJECTED	2b55a971-24f2-4e8b-824d-b333805438a8	2026-06-19 11:02:26.975	2026-06-19 11:02:26.975
00000000-0000-4000-9100-000000000034	00000000-0000-4000-8000-000000000034	REJECTED	2b55a971-24f2-4e8b-824d-b333805438a8	2026-06-16 09:00:02.63	2026-06-16 09:00:02.63
00000000-0000-4000-9200-000000000034	00000000-0000-4000-8000-000000000034	APPROVED	2b55a971-24f2-4e8b-824d-b333805438a8	2026-06-17 21:08:26.447	2026-06-17 21:08:26.447
00000000-0000-4000-9200-000000000035	00000000-0000-4000-8000-000000000035	REJECTED	2b55a971-24f2-4e8b-824d-b333805438a8	2026-06-20 02:24:41.964	2026-06-20 02:24:41.964
00000000-0000-4000-9200-000000000038	00000000-0000-4000-8000-000000000038	APPROVED	2b55a971-24f2-4e8b-824d-b333805438a8	2026-08-11 12:12:51.477	2026-08-11 12:12:51.477
00000000-0000-4000-9200-000000000039	00000000-0000-4000-8000-000000000039	APPROVED	2b55a971-24f2-4e8b-824d-b333805438a8	2026-08-25 08:13:53.618	2026-08-25 08:13:53.618
00000000-0000-4000-9100-000000000042	00000000-0000-4000-8000-000000000042	APPROVED	2b55a971-24f2-4e8b-824d-b333805438a8	2026-07-01 15:06:05.569	2026-07-01 15:06:05.569
00000000-0000-4000-9200-000000000042	00000000-0000-4000-8000-000000000042	REJECTED	2b55a971-24f2-4e8b-824d-b333805438a8	2026-07-02 22:23:02.114	2026-07-02 22:23:02.114
00000000-0000-4000-9200-000000000043	00000000-0000-4000-8000-000000000043	APPROVED	2b55a971-24f2-4e8b-824d-b333805438a8	2026-08-26 10:27:00.154	2026-08-26 10:27:00.154
00000000-0000-4000-9200-000000000044	00000000-0000-4000-8000-000000000044	REJECTED	2b55a971-24f2-4e8b-824d-b333805438a8	2026-08-24 03:50:39.262	2026-08-24 03:50:39.262
00000000-0000-4000-9200-000000000045	00000000-0000-4000-8000-000000000045	REJECTED	2b55a971-24f2-4e8b-824d-b333805438a8	2026-07-18 05:03:27.65	2026-07-18 05:03:27.65
00000000-0000-4000-9200-000000000046	00000000-0000-4000-8000-000000000046	APPROVED	2b55a971-24f2-4e8b-824d-b333805438a8	2026-07-12 13:16:21.77	2026-07-12 13:16:21.77
00000000-0000-4000-9200-000000000049	00000000-0000-4000-8000-000000000049	APPROVED	2b55a971-24f2-4e8b-824d-b333805438a8	2026-10-13 14:40:30.162	2026-10-13 14:40:30.162
00000000-0000-4000-9200-000000000050	00000000-0000-4000-8000-000000000050	REJECTED	2b55a971-24f2-4e8b-824d-b333805438a8	2026-09-07 21:22:28.947	2026-09-07 21:22:28.947
00000000-0000-4000-9100-000000000051	00000000-0000-4000-8000-000000000051	REJECTED	2b55a971-24f2-4e8b-824d-b333805438a8	2026-07-03 22:59:30.828	2026-07-03 22:59:30.828
00000000-0000-4000-9200-000000000051	00000000-0000-4000-8000-000000000051	APPROVED	2b55a971-24f2-4e8b-824d-b333805438a8	2026-07-05 03:33:09.448	2026-07-05 03:33:09.448
00000000-0000-4000-9200-000000000053	00000000-0000-4000-8000-000000000053	REJECTED	2b55a971-24f2-4e8b-824d-b333805438a8	2026-07-28 11:35:20.082	2026-07-28 11:35:20.082
00000000-0000-4000-9200-000000000055	00000000-0000-4000-8000-000000000055	APPROVED	2b55a971-24f2-4e8b-824d-b333805438a8	2026-07-19 04:34:14.149	2026-07-19 04:34:14.149
00000000-0000-4000-9200-000000000057	00000000-0000-4000-8000-000000000057	APPROVED	2b55a971-24f2-4e8b-824d-b333805438a8	2026-08-26 20:48:57.36	2026-08-26 20:48:57.36
00000000-0000-4000-9200-000000000058	00000000-0000-4000-8000-000000000058	REJECTED	2b55a971-24f2-4e8b-824d-b333805438a8	2026-09-02 01:58:29.507	2026-09-02 01:58:29.507
00000000-0000-4000-9200-000000000061	00000000-0000-4000-8000-000000000061	APPROVED	2b55a971-24f2-4e8b-824d-b333805438a8	2026-08-18 15:46:11.22	2026-08-18 15:46:11.22
00000000-0000-4000-9200-000000000064	00000000-0000-4000-8000-000000000064	REJECTED	2b55a971-24f2-4e8b-824d-b333805438a8	2026-07-05 14:35:09.315	2026-07-05 14:35:09.315
00000000-0000-4000-9200-000000000067	00000000-0000-4000-8000-000000000067	APPROVED	2b55a971-24f2-4e8b-824d-b333805438a8	2026-09-27 03:12:31.213	2026-09-27 03:12:31.213
00000000-0000-4000-9200-000000000070	00000000-0000-4000-8000-000000000070	APPROVED	2b55a971-24f2-4e8b-824d-b333805438a8	2026-07-25 08:34:26.679	2026-07-25 08:34:26.679
00000000-0000-4000-9100-000000000073	00000000-0000-4000-8000-000000000073	REJECTED	2b55a971-24f2-4e8b-824d-b333805438a8	2026-09-03 03:50:48.964	2026-09-03 03:50:48.964
00000000-0000-4000-9200-000000000073	00000000-0000-4000-8000-000000000073	APPROVED	2b55a971-24f2-4e8b-824d-b333805438a8	2026-09-04 07:04:32.188	2026-09-04 07:04:32.188
00000000-0000-4000-9100-000000000076	00000000-0000-4000-8000-000000000076	APPROVED	2b55a971-24f2-4e8b-824d-b333805438a8	2026-07-28 10:43:54.73	2026-07-28 10:43:54.73
00000000-0000-4000-9200-000000000076	00000000-0000-4000-8000-000000000076	REJECTED	2b55a971-24f2-4e8b-824d-b333805438a8	2026-07-31 07:39:05.781	2026-07-31 07:39:05.781
00000000-0000-4000-9200-000000000078	00000000-0000-4000-8000-000000000078	REJECTED	2b55a971-24f2-4e8b-824d-b333805438a8	2026-08-04 09:05:45.686	2026-08-04 09:05:45.686
00000000-0000-4000-9200-000000000080	00000000-0000-4000-8000-000000000080	REJECTED	2b55a971-24f2-4e8b-824d-b333805438a8	2026-06-18 19:41:37.311	2026-06-18 19:41:37.311
00000000-0000-4000-9200-000000000081	00000000-0000-4000-8000-000000000081	REJECTED	2b55a971-24f2-4e8b-824d-b333805438a8	2026-09-01 13:42:33.709	2026-09-01 13:42:33.709
00000000-0000-4000-9200-000000000084	00000000-0000-4000-8000-000000000084	APPROVED	2b55a971-24f2-4e8b-824d-b333805438a8	2026-06-21 18:12:46.871	2026-06-21 18:12:46.871
00000000-0000-4000-9200-000000000085	00000000-0000-4000-8000-000000000085	REJECTED	2b55a971-24f2-4e8b-824d-b333805438a8	2026-07-04 03:03:53.618	2026-07-04 03:03:53.618
00000000-0000-4000-9200-000000000087	00000000-0000-4000-8000-000000000087	REJECTED	2b55a971-24f2-4e8b-824d-b333805438a8	2026-10-12 05:06:12.578	2026-10-12 05:06:12.578
00000000-0000-4000-9200-000000000088	00000000-0000-4000-8000-000000000088	APPROVED	2b55a971-24f2-4e8b-824d-b333805438a8	2026-07-20 23:06:08.227	2026-07-20 23:06:08.227
00000000-0000-4000-9100-000000000089	00000000-0000-4000-8000-000000000089	REJECTED	2b55a971-24f2-4e8b-824d-b333805438a8	2026-08-20 07:37:12.239	2026-08-20 07:37:12.239
00000000-0000-4000-9200-000000000089	00000000-0000-4000-8000-000000000089	APPROVED	2b55a971-24f2-4e8b-824d-b333805438a8	2026-08-21 11:49:20.402	2026-08-21 11:49:20.402
00000000-0000-4000-9200-000000000090	00000000-0000-4000-8000-000000000090	APPROVED	2b55a971-24f2-4e8b-824d-b333805438a8	2026-08-10 12:27:04.049	2026-08-10 12:27:04.049
00000000-0000-4000-9200-000000000091	00000000-0000-4000-8000-000000000091	REJECTED	2b55a971-24f2-4e8b-824d-b333805438a8	2026-09-21 20:31:31.803	2026-09-21 20:31:31.803
00000000-0000-4000-9200-000000000093	00000000-0000-4000-8000-000000000093	APPROVED	2b55a971-24f2-4e8b-824d-b333805438a8	2026-10-08 16:29:16.626	2026-10-08 16:29:16.626
00000000-0000-4000-9200-000000000094	00000000-0000-4000-8000-000000000094	REJECTED	2b55a971-24f2-4e8b-824d-b333805438a8	2026-07-09 10:12:01.543	2026-07-09 10:12:01.543
00000000-0000-4000-9100-000000000095	00000000-0000-4000-8000-000000000095	APPROVED	2b55a971-24f2-4e8b-824d-b333805438a8	2026-09-29 06:27:59.959	2026-09-29 06:27:59.959
00000000-0000-4000-9200-000000000095	00000000-0000-4000-8000-000000000095	REJECTED	2b55a971-24f2-4e8b-824d-b333805438a8	2026-10-01 16:55:02.481	2026-10-01 16:55:02.481
00000000-0000-4000-9200-000000000096	00000000-0000-4000-8000-000000000096	REJECTED	2b55a971-24f2-4e8b-824d-b333805438a8	2026-07-07 23:15:33.33	2026-07-07 23:15:33.33
00000000-0000-4000-9200-000000000097	00000000-0000-4000-8000-000000000097	REJECTED	2b55a971-24f2-4e8b-824d-b333805438a8	2026-10-11 04:56:01.71	2026-10-11 04:56:01.71
00000000-0000-4000-9100-000000000099	00000000-0000-4000-8000-000000000099	REJECTED	2b55a971-24f2-4e8b-824d-b333805438a8	2026-09-12 11:10:25.847	2026-09-12 11:10:25.847
00000000-0000-4000-9200-000000000099	00000000-0000-4000-8000-000000000099	APPROVED	2b55a971-24f2-4e8b-824d-b333805438a8	2026-09-14 20:48:17.369	2026-09-14 20:48:17.369
\.


--
-- Data for Name: reports; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.reports (id, title, description, status, reporter_id, created_at, updated_at) FROM stdin;
00000000-0000-4000-8000-000000000001	Lampu jalan mati di Jl. Gajah Mada	Beberapa lampu penerangan jalan tidak menyala sehingga area menjadi gelap dan rawan kejahatan. Lokasi: Jl. Gajah Mada. Mohon segera ditindaklanjuti.	REJECTED	9d895d68-e919-4d07-9c60-ff5c649d9ef0	2026-06-22 19:49:56.002	2026-06-23 01:44:20.121
00000000-0000-4000-8000-000000000002	Jalan berlubang di Jl. Hayam Wuruk	Terdapat lubang cukup dalam di badan jalan yang membahayakan pengendara motor, terutama saat malam hari. Lokasi: Jl. Hayam Wuruk. Mohon segera ditindaklanjuti.	REJECTED	d09ee08a-0962-425f-99e7-7504ab99fd7f	2026-07-19 12:12:03.179	2026-07-23 07:32:05.749
00000000-0000-4000-8000-000000000003	Pedagang menutup trotoar di Jl. Diponegoro	Lapak pedagang memenuhi trotoar sehingga pejalan kaki terpaksa berjalan di badan jalan. Lokasi: Jl. Diponegoro. Sudah dilaporkan ke RT setempat namun belum ada tindakan.	REJECTED	9d895d68-e919-4d07-9c60-ff5c649d9ef0	2026-07-01 12:35:57.914	2026-07-03 10:52:11.347
00000000-0000-4000-8000-000000000004	Trotoar rusak di Jl. Dago	Paving trotoar terlepas dan bergelombang sehingga menyulitkan pejalan kaki dan pengguna kursi roda. Lokasi: Jl. Dago. Kondisi semakin parah dalam beberapa hari terakhir.	APPROVED	d09ee08a-0962-425f-99e7-7504ab99fd7f	2026-08-18 02:29:33.831	2026-08-22 16:26:14.46
00000000-0000-4000-8000-000000000005	Lampu lalu lintas tidak berfungsi di Jl. Merdeka	Lampu lalu lintas berkedip kuning terus-menerus sehingga persimpangan menjadi semrawut. Lokasi: Jl. Merdeka. Mohon segera ditindaklanjuti.	PENDING	9d895d68-e919-4d07-9c60-ff5c649d9ef0	2026-08-21 10:37:25.237	2026-08-21 10:37:25.237
00000000-0000-4000-8000-000000000006	Kabel menjuntai di Jl. Asia Afrika	Kabel utilitas menjuntai rendah di atas jalan dan dapat tersangkut kendaraan tinggi. Lokasi: Jl. Asia Afrika. Sudah dilaporkan ke RT setempat namun belum ada tindakan.	REJECTED	d09ee08a-0962-425f-99e7-7504ab99fd7f	2026-08-27 02:27:09.496	2026-08-27 18:40:20.206
00000000-0000-4000-8000-000000000007	Trotoar rusak di Jl. Ahmad Yani	Paving trotoar terlepas dan bergelombang sehingga menyulitkan pejalan kaki dan pengguna kursi roda. Lokasi: Jl. Ahmad Yani. Mohon segera ditindaklanjuti.	PENDING	9d895d68-e919-4d07-9c60-ff5c649d9ef0	2026-09-06 19:49:15.545	2026-09-06 19:49:15.545
00000000-0000-4000-8000-000000000008	Kebocoran pipa air di Jl. Sudirman	Pipa air bersih bocor dan airnya mengalir ke jalan sejak beberapa hari terakhir. Lokasi: Jl. Sudirman. Mohon segera ditindaklanjuti.	PENDING	d09ee08a-0962-425f-99e7-7504ab99fd7f	2026-09-10 11:11:50.105	2026-09-10 11:11:50.105
00000000-0000-4000-8000-000000000009	Kabel menjuntai di Jl. Pasteur	Kabel utilitas menjuntai rendah di atas jalan dan dapat tersangkut kendaraan tinggi. Lokasi: Jl. Pasteur. Mohon segera ditindaklanjuti.	APPROVED	9d895d68-e919-4d07-9c60-ff5c649d9ef0	2026-07-30 23:56:44.812	2026-08-04 03:36:37.291
00000000-0000-4000-8000-000000000010	Kebocoran pipa air di Jl. Pahlawan	Pipa air bersih bocor dan airnya mengalir ke jalan sejak beberapa hari terakhir. Lokasi: Jl. Pahlawan. Sudah dilaporkan ke RT setempat namun belum ada tindakan.	REJECTED	d09ee08a-0962-425f-99e7-7504ab99fd7f	2026-08-30 22:40:43.545	2026-09-03 18:30:14.905
00000000-0000-4000-8000-000000000011	Trotoar rusak di Simpang Lima	Paving trotoar terlepas dan bergelombang sehingga menyulitkan pejalan kaki dan pengguna kursi roda. Lokasi: Simpang Lima. Foto kondisi dapat diberikan jika diperlukan.	REJECTED	9d895d68-e919-4d07-9c60-ff5c649d9ef0	2026-07-26 10:47:44.674	2026-07-26 12:45:10.306
00000000-0000-4000-8000-000000000012	Kebocoran pipa air di Jl. Gajah Mada	Pipa air bersih bocor dan airnya mengalir ke jalan sejak beberapa hari terakhir. Lokasi: Jl. Gajah Mada. Foto kondisi dapat diberikan jika diperlukan.	PENDING	d09ee08a-0962-425f-99e7-7504ab99fd7f	2026-08-20 02:20:02.022	2026-08-20 02:20:02.022
00000000-0000-4000-8000-000000000013	Fasilitas taman rusak di Pasar Baru	Ayunan dan bangku taman rusak sehingga tidak aman digunakan oleh anak-anak. Lokasi: Pasar Baru. Mohon segera ditindaklanjuti.	PENDING	9d895d68-e919-4d07-9c60-ff5c649d9ef0	2026-09-09 07:37:03.406	2026-09-09 07:37:03.406
00000000-0000-4000-8000-000000000014	Lampu jalan mati di Jl. Cihampelas	Beberapa lampu penerangan jalan tidak menyala sehingga area menjadi gelap dan rawan kejahatan. Lokasi: Jl. Cihampelas. Mohon segera ditindaklanjuti.	APPROVED	d09ee08a-0962-425f-99e7-7504ab99fd7f	2026-08-02 05:04:27.232	2026-08-02 16:47:22.341
00000000-0000-4000-8000-000000000015	Polusi suara di Alun-alun	Kebisingan dari aktivitas konstruksi berlangsung hingga larut malam dan mengganggu warga. Lokasi: Alun-alun. Kondisi semakin parah dalam beberapa hari terakhir.	PENDING	9d895d68-e919-4d07-9c60-ff5c649d9ef0	2026-08-25 12:33:27.923	2026-08-25 12:33:27.923
00000000-0000-4000-8000-000000000016	Saluran air tersumbat di Jl. Pahlawan	Drainase tersumbat lumpur dan sampah sehingga air menggenang setiap kali hujan. Lokasi: Jl. Pahlawan. Banyak warga sekitar yang mengeluhkan hal ini.	APPROVED	d09ee08a-0962-425f-99e7-7504ab99fd7f	2026-10-02 17:05:01.213	2026-10-04 18:26:48.895
00000000-0000-4000-8000-000000000017	Saluran air tersumbat di Taman Kota	Drainase tersumbat lumpur dan sampah sehingga air menggenang setiap kali hujan. Lokasi: Taman Kota. Kondisi semakin parah dalam beberapa hari terakhir.	APPROVED	9d895d68-e919-4d07-9c60-ff5c649d9ef0	2026-07-31 14:45:59.685	2026-08-02 18:30:21.002
00000000-0000-4000-8000-000000000018	Sampah menumpuk di Jl. Pemuda	Tumpukan sampah belum diangkut lebih dari seminggu dan mulai menimbulkan bau tidak sedap. Lokasi: Jl. Pemuda. Foto kondisi dapat diberikan jika diperlukan.	APPROVED	d09ee08a-0962-425f-99e7-7504ab99fd7f	2026-08-05 14:19:27.098	2026-08-06 09:44:05.615
00000000-0000-4000-8000-000000000019	Jalan berlubang di Jl. Merdeka	Terdapat lubang cukup dalam di badan jalan yang membahayakan pengendara motor, terutama saat malam hari. Lokasi: Jl. Merdeka. Mohon segera ditindaklanjuti.	APPROVED	9d895d68-e919-4d07-9c60-ff5c649d9ef0	2026-07-10 08:07:03.672	2026-07-13 09:51:43.858
00000000-0000-4000-8000-000000000020	Kabel menjuntai di Taman Kota	Kabel utilitas menjuntai rendah di atas jalan dan dapat tersangkut kendaraan tinggi. Lokasi: Taman Kota. Sudah dilaporkan ke RT setempat namun belum ada tindakan.	REJECTED	d09ee08a-0962-425f-99e7-7504ab99fd7f	2026-09-22 13:17:59.327	2026-09-28 04:21:03.856
00000000-0000-4000-8000-000000000021	Fasilitas taman rusak di Pasar Baru	Ayunan dan bangku taman rusak sehingga tidak aman digunakan oleh anak-anak. Lokasi: Pasar Baru. Mohon segera ditindaklanjuti.	REJECTED	9d895d68-e919-4d07-9c60-ff5c649d9ef0	2026-09-24 00:30:38.734	2026-09-26 22:29:32.116
00000000-0000-4000-8000-000000000022	Polusi suara di Jl. Diponegoro	Kebisingan dari aktivitas konstruksi berlangsung hingga larut malam dan mengganggu warga. Lokasi: Jl. Diponegoro. Sudah dilaporkan ke RT setempat namun belum ada tindakan.	PENDING	d09ee08a-0962-425f-99e7-7504ab99fd7f	2026-06-24 16:34:58.244	2026-06-24 16:34:58.244
00000000-0000-4000-8000-000000000023	Saluran air tersumbat di Jl. Ahmad Yani	Drainase tersumbat lumpur dan sampah sehingga air menggenang setiap kali hujan. Lokasi: Jl. Ahmad Yani. Foto kondisi dapat diberikan jika diperlukan.	PENDING	9d895d68-e919-4d07-9c60-ff5c649d9ef0	2026-08-29 04:00:56.482	2026-08-29 04:00:56.482
00000000-0000-4000-8000-000000000024	Lampu jalan mati di Jl. Gatot Subroto	Beberapa lampu penerangan jalan tidak menyala sehingga area menjadi gelap dan rawan kejahatan. Lokasi: Jl. Gatot Subroto. Kondisi semakin parah dalam beberapa hari terakhir.	APPROVED	d09ee08a-0962-425f-99e7-7504ab99fd7f	2026-09-07 16:25:56.835	2026-09-09 18:55:07.794
00000000-0000-4000-8000-000000000025	Pedagang menutup trotoar di Simpang Lima	Lapak pedagang memenuhi trotoar sehingga pejalan kaki terpaksa berjalan di badan jalan. Lokasi: Simpang Lima. Kondisi semakin parah dalam beberapa hari terakhir.	APPROVED	9d895d68-e919-4d07-9c60-ff5c649d9ef0	2026-09-27 11:11:51.166	2026-09-29 18:04:44.482
00000000-0000-4000-8000-000000000026	Parkir liar di Jl. Veteran	Kendaraan parkir di bahu jalan hingga menyebabkan kemacetan pada jam sibuk. Lokasi: Jl. Veteran. Kondisi semakin parah dalam beberapa hari terakhir.	PENDING	d09ee08a-0962-425f-99e7-7504ab99fd7f	2026-08-22 22:00:51.937	2026-08-22 22:00:51.937
00000000-0000-4000-8000-000000000027	Rambu lalu lintas hilang di Jl. Ahmad Yani	Rambu larangan parkir sudah tidak ada sehingga banyak kendaraan parkir sembarangan. Lokasi: Jl. Ahmad Yani. Mohon segera ditindaklanjuti.	REJECTED	9d895d68-e919-4d07-9c60-ff5c649d9ef0	2026-07-19 12:59:38.166	2026-07-23 10:16:19.622
00000000-0000-4000-8000-000000000028	Lampu jalan mati di Pasar Baru	Beberapa lampu penerangan jalan tidak menyala sehingga area menjadi gelap dan rawan kejahatan. Lokasi: Pasar Baru. Sudah dilaporkan ke RT setempat namun belum ada tindakan.	APPROVED	d09ee08a-0962-425f-99e7-7504ab99fd7f	2026-09-12 18:04:05.671	2026-09-17 08:23:17.798
00000000-0000-4000-8000-000000000029	Pedagang menutup trotoar di Jl. Hayam Wuruk	Lapak pedagang memenuhi trotoar sehingga pejalan kaki terpaksa berjalan di badan jalan. Lokasi: Jl. Hayam Wuruk. Mohon segera ditindaklanjuti.	APPROVED	9d895d68-e919-4d07-9c60-ff5c649d9ef0	2026-08-08 04:30:37.21	2026-08-08 09:32:37.289
00000000-0000-4000-8000-000000000030	Jalan berlubang di Jl. Pasteur	Terdapat lubang cukup dalam di badan jalan yang membahayakan pengendara motor, terutama saat malam hari. Lokasi: Jl. Pasteur. Mohon segera ditindaklanjuti.	APPROVED	d09ee08a-0962-425f-99e7-7504ab99fd7f	2026-08-30 22:32:18.126	2026-09-03 21:44:19.301
00000000-0000-4000-8000-000000000031	Saluran air tersumbat di Jl. Asia Afrika	Drainase tersumbat lumpur dan sampah sehingga air menggenang setiap kali hujan. Lokasi: Jl. Asia Afrika. Sudah dilaporkan ke RT setempat namun belum ada tindakan.	APPROVED	9d895d68-e919-4d07-9c60-ff5c649d9ef0	2026-09-28 09:32:14.255	2026-10-02 15:20:17.927
00000000-0000-4000-8000-000000000032	Genangan banjir di Pasar Baru	Air setinggi betis menggenang setelah hujan deras dan baru surut setelah beberapa jam. Lokasi: Pasar Baru. Sudah dilaporkan ke RT setempat namun belum ada tindakan.	REJECTED	d09ee08a-0962-425f-99e7-7504ab99fd7f	2026-06-18 16:54:43.498	2026-06-19 11:02:26.975
00000000-0000-4000-8000-000000000033	Kabel menjuntai di Jl. Sudirman	Kabel utilitas menjuntai rendah di atas jalan dan dapat tersangkut kendaraan tinggi. Lokasi: Jl. Sudirman. Kondisi semakin parah dalam beberapa hari terakhir.	PENDING	9d895d68-e919-4d07-9c60-ff5c649d9ef0	2026-09-03 04:03:46.512	2026-09-03 04:03:46.512
00000000-0000-4000-8000-000000000034	Parkir liar di Alun-alun	Kendaraan parkir di bahu jalan hingga menyebabkan kemacetan pada jam sibuk. Lokasi: Alun-alun. Banyak warga sekitar yang mengeluhkan hal ini.	APPROVED	d09ee08a-0962-425f-99e7-7504ab99fd7f	2026-06-15 23:07:47.153	2026-06-17 21:08:26.447
00000000-0000-4000-8000-000000000035	Fasilitas taman rusak di Jl. Dago	Ayunan dan bangku taman rusak sehingga tidak aman digunakan oleh anak-anak. Lokasi: Jl. Dago. Mohon segera ditindaklanjuti.	REJECTED	9d895d68-e919-4d07-9c60-ff5c649d9ef0	2026-06-18 15:58:28.769	2026-06-20 02:24:41.964
00000000-0000-4000-8000-000000000037	Fasilitas taman rusak di Jl. Sudirman	Ayunan dan bangku taman rusak sehingga tidak aman digunakan oleh anak-anak. Lokasi: Jl. Sudirman. Sudah dilaporkan ke RT setempat namun belum ada tindakan.	PENDING	9d895d68-e919-4d07-9c60-ff5c649d9ef0	2026-09-13 02:15:02.904	2026-09-13 02:15:02.904
00000000-0000-4000-8000-000000000038	Saluran air tersumbat di Jl. Ahmad Yani	Drainase tersumbat lumpur dan sampah sehingga air menggenang setiap kali hujan. Lokasi: Jl. Ahmad Yani. Foto kondisi dapat diberikan jika diperlukan.	APPROVED	d09ee08a-0962-425f-99e7-7504ab99fd7f	2026-08-10 01:51:33.233	2026-08-11 12:12:51.477
00000000-0000-4000-8000-000000000039	Fasilitas taman rusak di Jl. Pemuda	Ayunan dan bangku taman rusak sehingga tidak aman digunakan oleh anak-anak. Lokasi: Jl. Pemuda. Foto kondisi dapat diberikan jika diperlukan.	APPROVED	9d895d68-e919-4d07-9c60-ff5c649d9ef0	2026-08-21 15:24:43.963	2026-08-25 08:13:53.618
00000000-0000-4000-8000-000000000040	Pedagang menutup trotoar di Jl. Pemuda	Lapak pedagang memenuhi trotoar sehingga pejalan kaki terpaksa berjalan di badan jalan. Lokasi: Jl. Pemuda. Foto kondisi dapat diberikan jika diperlukan.	PENDING	d09ee08a-0962-425f-99e7-7504ab99fd7f	2026-06-16 04:19:03.636	2026-06-16 04:19:03.636
00000000-0000-4000-8000-000000000041	Pedagang menutup trotoar di Jl. Pemuda	Lapak pedagang memenuhi trotoar sehingga pejalan kaki terpaksa berjalan di badan jalan. Lokasi: Jl. Pemuda. Sudah dilaporkan ke RT setempat namun belum ada tindakan.	PENDING	9d895d68-e919-4d07-9c60-ff5c649d9ef0	2026-09-09 00:08:40.778	2026-09-09 00:08:40.778
00000000-0000-4000-8000-000000000042	Lampu lalu lintas tidak berfungsi di Pasar Baru	Lampu lalu lintas berkedip kuning terus-menerus sehingga persimpangan menjadi semrawut. Lokasi: Pasar Baru. Sudah dilaporkan ke RT setempat namun belum ada tindakan.	REJECTED	d09ee08a-0962-425f-99e7-7504ab99fd7f	2026-06-30 07:05:53.187	2026-07-02 22:23:02.114
00000000-0000-4000-8000-000000000043	Lampu lalu lintas tidak berfungsi di Jl. Gatot Subroto	Lampu lalu lintas berkedip kuning terus-menerus sehingga persimpangan menjadi semrawut. Lokasi: Jl. Gatot Subroto. Banyak warga sekitar yang mengeluhkan hal ini.	APPROVED	9d895d68-e919-4d07-9c60-ff5c649d9ef0	2026-08-25 16:05:06.292	2026-08-26 10:27:00.154
00000000-0000-4000-8000-000000000044	Rambu lalu lintas hilang di Simpang Lima	Rambu larangan parkir sudah tidak ada sehingga banyak kendaraan parkir sembarangan. Lokasi: Simpang Lima. Banyak warga sekitar yang mengeluhkan hal ini.	REJECTED	d09ee08a-0962-425f-99e7-7504ab99fd7f	2026-08-22 15:17:58.212	2026-08-24 03:50:39.262
00000000-0000-4000-8000-000000000045	Rambu lalu lintas hilang di Jl. Asia Afrika	Rambu larangan parkir sudah tidak ada sehingga banyak kendaraan parkir sembarangan. Lokasi: Jl. Asia Afrika. Mohon segera ditindaklanjuti.	REJECTED	9d895d68-e919-4d07-9c60-ff5c649d9ef0	2026-07-17 23:47:20.385	2026-07-18 05:03:27.65
00000000-0000-4000-8000-000000000046	Parkir liar di Jl. Pahlawan	Kendaraan parkir di bahu jalan hingga menyebabkan kemacetan pada jam sibuk. Lokasi: Jl. Pahlawan. Foto kondisi dapat diberikan jika diperlukan.	APPROVED	d09ee08a-0962-425f-99e7-7504ab99fd7f	2026-07-12 07:13:30.936	2026-07-12 13:16:21.77
00000000-0000-4000-8000-000000000047	Jalan berlubang di Alun-alun	Terdapat lubang cukup dalam di badan jalan yang membahayakan pengendara motor, terutama saat malam hari. Lokasi: Alun-alun. Kondisi semakin parah dalam beberapa hari terakhir.	PENDING	9d895d68-e919-4d07-9c60-ff5c649d9ef0	2026-08-04 11:50:29.894	2026-08-04 11:50:29.894
00000000-0000-4000-8000-000000000048	Lampu lalu lintas tidak berfungsi di Simpang Lima	Lampu lalu lintas berkedip kuning terus-menerus sehingga persimpangan menjadi semrawut. Lokasi: Simpang Lima. Sudah dilaporkan ke RT setempat namun belum ada tindakan.	PENDING	d09ee08a-0962-425f-99e7-7504ab99fd7f	2026-08-12 19:02:59.581	2026-08-12 19:02:59.581
00000000-0000-4000-8000-000000000049	Kebocoran pipa air di Jl. Cihampelas	Pipa air bersih bocor dan airnya mengalir ke jalan sejak beberapa hari terakhir. Lokasi: Jl. Cihampelas. Banyak warga sekitar yang mengeluhkan hal ini.	APPROVED	9d895d68-e919-4d07-9c60-ff5c649d9ef0	2026-10-12 01:52:10.665	2026-10-13 14:40:30.162
00000000-0000-4000-8000-000000000050	Genangan banjir di Jl. Merdeka	Air setinggi betis menggenang setelah hujan deras dan baru surut setelah beberapa jam. Lokasi: Jl. Merdeka. Banyak warga sekitar yang mengeluhkan hal ini.	REJECTED	d09ee08a-0962-425f-99e7-7504ab99fd7f	2026-09-06 16:02:31.733	2026-09-07 21:22:28.947
00000000-0000-4000-8000-000000000051	Fasilitas taman rusak di Simpang Lima	Ayunan dan bangku taman rusak sehingga tidak aman digunakan oleh anak-anak. Lokasi: Simpang Lima. Banyak warga sekitar yang mengeluhkan hal ini.	APPROVED	9d895d68-e919-4d07-9c60-ff5c649d9ef0	2026-06-29 06:30:43.688	2026-07-05 03:33:09.448
00000000-0000-4000-8000-000000000052	Rambu lalu lintas hilang di Pasar Baru	Rambu larangan parkir sudah tidak ada sehingga banyak kendaraan parkir sembarangan. Lokasi: Pasar Baru. Sudah dilaporkan ke RT setempat namun belum ada tindakan.	PENDING	d09ee08a-0962-425f-99e7-7504ab99fd7f	2026-09-28 10:51:15.619	2026-09-28 10:51:15.619
00000000-0000-4000-8000-000000000053	Lampu lalu lintas tidak berfungsi di Jl. Asia Afrika	Lampu lalu lintas berkedip kuning terus-menerus sehingga persimpangan menjadi semrawut. Lokasi: Jl. Asia Afrika. Banyak warga sekitar yang mengeluhkan hal ini.	REJECTED	9d895d68-e919-4d07-9c60-ff5c649d9ef0	2026-07-27 03:58:37.93	2026-07-28 11:35:20.082
00000000-0000-4000-8000-000000000054	Genangan banjir di Pasar Baru	Air setinggi betis menggenang setelah hujan deras dan baru surut setelah beberapa jam. Lokasi: Pasar Baru. Kondisi semakin parah dalam beberapa hari terakhir.	PENDING	d09ee08a-0962-425f-99e7-7504ab99fd7f	2026-08-04 22:06:17.095	2026-08-04 22:06:17.095
00000000-0000-4000-8000-000000000055	Pedagang menutup trotoar di Jl. Asia Afrika	Lapak pedagang memenuhi trotoar sehingga pejalan kaki terpaksa berjalan di badan jalan. Lokasi: Jl. Asia Afrika. Banyak warga sekitar yang mengeluhkan hal ini.	APPROVED	9d895d68-e919-4d07-9c60-ff5c649d9ef0	2026-07-16 12:00:58.302	2026-07-19 04:34:14.149
00000000-0000-4000-8000-000000000056	Kebocoran pipa air di Alun-alun	Pipa air bersih bocor dan airnya mengalir ke jalan sejak beberapa hari terakhir. Lokasi: Alun-alun. Sudah dilaporkan ke RT setempat namun belum ada tindakan.	PENDING	d09ee08a-0962-425f-99e7-7504ab99fd7f	2026-08-21 15:24:45.65	2026-08-21 15:24:45.65
00000000-0000-4000-8000-000000000057	Polusi suara di Alun-alun	Kebisingan dari aktivitas konstruksi berlangsung hingga larut malam dan mengganggu warga. Lokasi: Alun-alun. Foto kondisi dapat diberikan jika diperlukan.	APPROVED	9d895d68-e919-4d07-9c60-ff5c649d9ef0	2026-08-25 01:14:32.216	2026-08-26 20:48:57.36
00000000-0000-4000-8000-000000000058	Lampu lalu lintas tidak berfungsi di Jl. Pahlawan	Lampu lalu lintas berkedip kuning terus-menerus sehingga persimpangan menjadi semrawut. Lokasi: Jl. Pahlawan. Mohon segera ditindaklanjuti.	REJECTED	d09ee08a-0962-425f-99e7-7504ab99fd7f	2026-08-29 10:32:21.376	2026-09-02 01:58:29.507
00000000-0000-4000-8000-000000000059	Sampah menumpuk di Jl. Pemuda	Tumpukan sampah belum diangkut lebih dari seminggu dan mulai menimbulkan bau tidak sedap. Lokasi: Jl. Pemuda. Banyak warga sekitar yang mengeluhkan hal ini.	PENDING	9d895d68-e919-4d07-9c60-ff5c649d9ef0	2026-10-11 14:33:29.001	2026-10-11 14:33:29.001
00000000-0000-4000-8000-000000000060	Pohon tumbang di Jl. Pemuda	Pohon tumbang menutup sebagian jalan dan berpotensi menimpa kabel listrik di sekitarnya. Lokasi: Jl. Pemuda. Kondisi semakin parah dalam beberapa hari terakhir.	PENDING	d09ee08a-0962-425f-99e7-7504ab99fd7f	2026-09-19 11:07:46.062	2026-09-19 11:07:46.062
00000000-0000-4000-8000-000000000061	Pohon tumbang di Terminal Kota	Pohon tumbang menutup sebagian jalan dan berpotensi menimpa kabel listrik di sekitarnya. Lokasi: Terminal Kota. Mohon segera ditindaklanjuti.	APPROVED	9d895d68-e919-4d07-9c60-ff5c649d9ef0	2026-08-15 21:35:55.383	2026-08-18 15:46:11.22
00000000-0000-4000-8000-000000000062	Lampu lalu lintas tidak berfungsi di Jl. Pasteur	Lampu lalu lintas berkedip kuning terus-menerus sehingga persimpangan menjadi semrawut. Lokasi: Jl. Pasteur. Sudah dilaporkan ke RT setempat namun belum ada tindakan.	PENDING	d09ee08a-0962-425f-99e7-7504ab99fd7f	2026-09-14 17:58:56.346	2026-09-14 17:58:56.346
00000000-0000-4000-8000-000000000063	Saluran air tersumbat di Jl. Pahlawan	Drainase tersumbat lumpur dan sampah sehingga air menggenang setiap kali hujan. Lokasi: Jl. Pahlawan. Mohon segera ditindaklanjuti.	PENDING	9d895d68-e919-4d07-9c60-ff5c649d9ef0	2026-09-07 16:12:05.108	2026-09-07 16:12:05.108
00000000-0000-4000-8000-000000000064	Jalan berlubang di Terminal Kota	Terdapat lubang cukup dalam di badan jalan yang membahayakan pengendara motor, terutama saat malam hari. Lokasi: Terminal Kota. Foto kondisi dapat diberikan jika diperlukan.	REJECTED	d09ee08a-0962-425f-99e7-7504ab99fd7f	2026-07-02 02:10:56.713	2026-07-05 14:35:09.315
00000000-0000-4000-8000-000000000065	Trotoar rusak di Jl. Asia Afrika	Paving trotoar terlepas dan bergelombang sehingga menyulitkan pejalan kaki dan pengguna kursi roda. Lokasi: Jl. Asia Afrika. Foto kondisi dapat diberikan jika diperlukan.	PENDING	9d895d68-e919-4d07-9c60-ff5c649d9ef0	2026-08-09 12:45:42.649	2026-08-09 12:45:42.649
00000000-0000-4000-8000-000000000066	Lampu jalan mati di Jl. Sudirman	Beberapa lampu penerangan jalan tidak menyala sehingga area menjadi gelap dan rawan kejahatan. Lokasi: Jl. Sudirman. Kondisi semakin parah dalam beberapa hari terakhir.	PENDING	d09ee08a-0962-425f-99e7-7504ab99fd7f	2026-08-17 23:49:41.612	2026-08-17 23:49:41.612
00000000-0000-4000-8000-000000000067	Jalan berlubang di Jl. Pemuda	Terdapat lubang cukup dalam di badan jalan yang membahayakan pengendara motor, terutama saat malam hari. Lokasi: Jl. Pemuda. Sudah dilaporkan ke RT setempat namun belum ada tindakan.	APPROVED	9d895d68-e919-4d07-9c60-ff5c649d9ef0	2026-09-26 04:45:26.317	2026-09-27 03:12:31.213
00000000-0000-4000-8000-000000000068	Pohon tumbang di Simpang Lima	Pohon tumbang menutup sebagian jalan dan berpotensi menimpa kabel listrik di sekitarnya. Lokasi: Simpang Lima. Sudah dilaporkan ke RT setempat namun belum ada tindakan.	PENDING	d09ee08a-0962-425f-99e7-7504ab99fd7f	2026-07-17 21:56:10.183	2026-07-17 21:56:10.183
00000000-0000-4000-8000-000000000069	Lampu jalan mati di Jl. Dago	Beberapa lampu penerangan jalan tidak menyala sehingga area menjadi gelap dan rawan kejahatan. Lokasi: Jl. Dago. Sudah dilaporkan ke RT setempat namun belum ada tindakan.	PENDING	9d895d68-e919-4d07-9c60-ff5c649d9ef0	2026-07-11 15:13:44.53	2026-07-11 15:13:44.53
00000000-0000-4000-8000-000000000070	Saluran air tersumbat di Jl. Pasteur	Drainase tersumbat lumpur dan sampah sehingga air menggenang setiap kali hujan. Lokasi: Jl. Pasteur. Kondisi semakin parah dalam beberapa hari terakhir.	APPROVED	d09ee08a-0962-425f-99e7-7504ab99fd7f	2026-07-24 08:37:16.546	2026-07-25 08:34:26.679
00000000-0000-4000-8000-000000000071	Lampu jalan mati di Alun-alun	Beberapa lampu penerangan jalan tidak menyala sehingga area menjadi gelap dan rawan kejahatan. Lokasi: Alun-alun. Mohon segera ditindaklanjuti.	PENDING	9d895d68-e919-4d07-9c60-ff5c649d9ef0	2026-06-18 10:17:21.034	2026-06-18 10:17:21.034
00000000-0000-4000-8000-000000000072	Polusi suara di Jl. Braga	Kebisingan dari aktivitas konstruksi berlangsung hingga larut malam dan mengganggu warga. Lokasi: Jl. Braga. Banyak warga sekitar yang mengeluhkan hal ini.	PENDING	d09ee08a-0962-425f-99e7-7504ab99fd7f	2026-08-14 13:00:34.72	2026-08-14 13:00:34.72
00000000-0000-4000-8000-000000000073	Pohon tumbang di Jl. Sudirman	Pohon tumbang menutup sebagian jalan dan berpotensi menimpa kabel listrik di sekitarnya. Lokasi: Jl. Sudirman. Banyak warga sekitar yang mengeluhkan hal ini.	APPROVED	9d895d68-e919-4d07-9c60-ff5c649d9ef0	2026-08-30 16:50:49.16	2026-09-04 07:04:32.188
00000000-0000-4000-8000-000000000074	Kabel menjuntai di Jl. Hayam Wuruk	Kabel utilitas menjuntai rendah di atas jalan dan dapat tersangkut kendaraan tinggi. Lokasi: Jl. Hayam Wuruk. Foto kondisi dapat diberikan jika diperlukan.	PENDING	d09ee08a-0962-425f-99e7-7504ab99fd7f	2026-06-23 22:04:29.483	2026-06-23 22:04:29.483
00000000-0000-4000-8000-000000000075	Lampu lalu lintas tidak berfungsi di Jl. Diponegoro	Lampu lalu lintas berkedip kuning terus-menerus sehingga persimpangan menjadi semrawut. Lokasi: Jl. Diponegoro. Sudah dilaporkan ke RT setempat namun belum ada tindakan.	PENDING	9d895d68-e919-4d07-9c60-ff5c649d9ef0	2026-07-06 13:47:39.567	2026-07-06 13:47:39.567
00000000-0000-4000-8000-000000000076	Jalan berlubang di Terminal Kota	Terdapat lubang cukup dalam di badan jalan yang membahayakan pengendara motor, terutama saat malam hari. Lokasi: Terminal Kota. Sudah dilaporkan ke RT setempat namun belum ada tindakan.	REJECTED	d09ee08a-0962-425f-99e7-7504ab99fd7f	2026-07-26 16:34:47.079	2026-07-31 07:39:05.781
00000000-0000-4000-8000-000000000077	Parkir liar di Jl. Braga	Kendaraan parkir di bahu jalan hingga menyebabkan kemacetan pada jam sibuk. Lokasi: Jl. Braga. Foto kondisi dapat diberikan jika diperlukan.	PENDING	9d895d68-e919-4d07-9c60-ff5c649d9ef0	2026-08-26 20:06:44.808	2026-08-26 20:06:44.808
00000000-0000-4000-8000-000000000078	Kebocoran pipa air di Jl. Ahmad Yani	Pipa air bersih bocor dan airnya mengalir ke jalan sejak beberapa hari terakhir. Lokasi: Jl. Ahmad Yani. Mohon segera ditindaklanjuti.	REJECTED	d09ee08a-0962-425f-99e7-7504ab99fd7f	2026-07-31 11:21:13.13	2026-08-04 09:05:45.686
00000000-0000-4000-8000-000000000079	Saluran air tersumbat di Jl. Braga	Drainase tersumbat lumpur dan sampah sehingga air menggenang setiap kali hujan. Lokasi: Jl. Braga. Kondisi semakin parah dalam beberapa hari terakhir.	PENDING	9d895d68-e919-4d07-9c60-ff5c649d9ef0	2026-08-24 14:24:13.608	2026-08-24 14:24:13.608
00000000-0000-4000-8000-000000000080	Rambu lalu lintas hilang di Pasar Baru	Rambu larangan parkir sudah tidak ada sehingga banyak kendaraan parkir sembarangan. Lokasi: Pasar Baru. Banyak warga sekitar yang mengeluhkan hal ini.	REJECTED	d09ee08a-0962-425f-99e7-7504ab99fd7f	2026-06-17 08:31:06.708	2026-06-18 19:41:37.311
00000000-0000-4000-8000-000000000081	Pohon tumbang di Simpang Lima	Pohon tumbang menutup sebagian jalan dan berpotensi menimpa kabel listrik di sekitarnya. Lokasi: Simpang Lima. Kondisi semakin parah dalam beberapa hari terakhir.	REJECTED	9d895d68-e919-4d07-9c60-ff5c649d9ef0	2026-08-31 15:11:56.311	2026-09-01 13:42:33.709
00000000-0000-4000-8000-000000000082	Kebocoran pipa air di Jl. Gajah Mada	Pipa air bersih bocor dan airnya mengalir ke jalan sejak beberapa hari terakhir. Lokasi: Jl. Gajah Mada. Kondisi semakin parah dalam beberapa hari terakhir.	PENDING	d09ee08a-0962-425f-99e7-7504ab99fd7f	2026-06-18 00:06:34.416	2026-06-18 00:06:34.416
00000000-0000-4000-8000-000000000083	Kabel menjuntai di Jl. Veteran	Kabel utilitas menjuntai rendah di atas jalan dan dapat tersangkut kendaraan tinggi. Lokasi: Jl. Veteran. Kondisi semakin parah dalam beberapa hari terakhir.	PENDING	9d895d68-e919-4d07-9c60-ff5c649d9ef0	2026-08-26 16:24:48.825	2026-08-26 16:24:48.825
00000000-0000-4000-8000-000000000084	Pohon tumbang di Jl. Braga	Pohon tumbang menutup sebagian jalan dan berpotensi menimpa kabel listrik di sekitarnya. Lokasi: Jl. Braga. Foto kondisi dapat diberikan jika diperlukan.	APPROVED	d09ee08a-0962-425f-99e7-7504ab99fd7f	2026-06-21 10:00:48.838	2026-06-21 18:12:46.871
00000000-0000-4000-8000-000000000085	Saluran air tersumbat di Alun-alun	Drainase tersumbat lumpur dan sampah sehingga air menggenang setiap kali hujan. Lokasi: Alun-alun. Kondisi semakin parah dalam beberapa hari terakhir.	REJECTED	9d895d68-e919-4d07-9c60-ff5c649d9ef0	2026-07-03 14:32:53.832	2026-07-04 03:03:53.618
00000000-0000-4000-8000-000000000086	Lampu lalu lintas tidak berfungsi di Jl. Gajah Mada	Lampu lalu lintas berkedip kuning terus-menerus sehingga persimpangan menjadi semrawut. Lokasi: Jl. Gajah Mada. Banyak warga sekitar yang mengeluhkan hal ini.	PENDING	d09ee08a-0962-425f-99e7-7504ab99fd7f	2026-09-12 00:26:54.821	2026-09-12 00:26:54.821
00000000-0000-4000-8000-000000000087	Parkir liar di Jl. Gatot Subroto	Kendaraan parkir di bahu jalan hingga menyebabkan kemacetan pada jam sibuk. Lokasi: Jl. Gatot Subroto. Sudah dilaporkan ke RT setempat namun belum ada tindakan.	REJECTED	9d895d68-e919-4d07-9c60-ff5c649d9ef0	2026-10-11 08:22:02.756	2026-10-12 05:06:12.578
00000000-0000-4000-8000-000000000088	Polusi suara di Jl. Sudirman	Kebisingan dari aktivitas konstruksi berlangsung hingga larut malam dan mengganggu warga. Lokasi: Jl. Sudirman. Sudah dilaporkan ke RT setempat namun belum ada tindakan.	APPROVED	d09ee08a-0962-425f-99e7-7504ab99fd7f	2026-07-17 06:48:58.594	2026-07-20 23:06:08.227
00000000-0000-4000-8000-000000000089	Polusi suara di Terminal Kota	Kebisingan dari aktivitas konstruksi berlangsung hingga larut malam dan mengganggu warga. Lokasi: Terminal Kota. Banyak warga sekitar yang mengeluhkan hal ini.	APPROVED	9d895d68-e919-4d07-9c60-ff5c649d9ef0	2026-08-16 15:51:37.24	2026-08-21 11:49:20.402
00000000-0000-4000-8000-000000000090	Pohon tumbang di Jl. Hayam Wuruk	Pohon tumbang menutup sebagian jalan dan berpotensi menimpa kabel listrik di sekitarnya. Lokasi: Jl. Hayam Wuruk. Mohon segera ditindaklanjuti.	APPROVED	d09ee08a-0962-425f-99e7-7504ab99fd7f	2026-08-09 00:00:10.428	2026-08-10 12:27:04.049
00000000-0000-4000-8000-000000000091	Sampah menumpuk di Simpang Lima	Tumpukan sampah belum diangkut lebih dari seminggu dan mulai menimbulkan bau tidak sedap. Lokasi: Simpang Lima. Kondisi semakin parah dalam beberapa hari terakhir.	REJECTED	9d895d68-e919-4d07-9c60-ff5c649d9ef0	2026-09-20 03:01:20.675	2026-09-21 20:31:31.803
00000000-0000-4000-8000-000000000092	Fasilitas taman rusak di Jl. Sudirman	Ayunan dan bangku taman rusak sehingga tidak aman digunakan oleh anak-anak. Lokasi: Jl. Sudirman. Mohon segera ditindaklanjuti.	PENDING	d09ee08a-0962-425f-99e7-7504ab99fd7f	2026-09-21 10:57:07.373	2026-09-21 10:57:07.373
00000000-0000-4000-8000-000000000093	Pohon tumbang di Jl. Asia Afrika	Pohon tumbang menutup sebagian jalan dan berpotensi menimpa kabel listrik di sekitarnya. Lokasi: Jl. Asia Afrika. Foto kondisi dapat diberikan jika diperlukan.	APPROVED	9d895d68-e919-4d07-9c60-ff5c649d9ef0	2026-10-05 15:24:41.249	2026-10-08 16:29:16.626
00000000-0000-4000-8000-000000000094	Kebocoran pipa air di Jl. Veteran	Pipa air bersih bocor dan airnya mengalir ke jalan sejak beberapa hari terakhir. Lokasi: Jl. Veteran. Sudah dilaporkan ke RT setempat namun belum ada tindakan.	REJECTED	d09ee08a-0962-425f-99e7-7504ab99fd7f	2026-07-05 21:14:53.124	2026-07-09 10:12:01.543
00000000-0000-4000-8000-000000000095	Trotoar rusak di Jl. Ahmad Yani	Paving trotoar terlepas dan bergelombang sehingga menyulitkan pejalan kaki dan pengguna kursi roda. Lokasi: Jl. Ahmad Yani. Foto kondisi dapat diberikan jika diperlukan.	REJECTED	9d895d68-e919-4d07-9c60-ff5c649d9ef0	2026-09-24 09:19:54.977	2026-10-01 16:55:02.481
00000000-0000-4000-8000-000000000096	Sampah menumpuk di Jl. Pemuda	Tumpukan sampah belum diangkut lebih dari seminggu dan mulai menimbulkan bau tidak sedap. Lokasi: Jl. Pemuda. Sudah dilaporkan ke RT setempat namun belum ada tindakan.	REJECTED	d09ee08a-0962-425f-99e7-7504ab99fd7f	2026-07-05 21:29:43.357	2026-07-07 23:15:33.33
00000000-0000-4000-8000-000000000097	Polusi suara di Jl. Hayam Wuruk	Kebisingan dari aktivitas konstruksi berlangsung hingga larut malam dan mengganggu warga. Lokasi: Jl. Hayam Wuruk. Sudah dilaporkan ke RT setempat namun belum ada tindakan.	REJECTED	9d895d68-e919-4d07-9c60-ff5c649d9ef0	2026-10-07 18:22:57.21	2026-10-11 04:56:01.71
00000000-0000-4000-8000-000000000098	Lampu jalan mati di Terminal Kota	Beberapa lampu penerangan jalan tidak menyala sehingga area menjadi gelap dan rawan kejahatan. Lokasi: Terminal Kota. Foto kondisi dapat diberikan jika diperlukan.	PENDING	d09ee08a-0962-425f-99e7-7504ab99fd7f	2026-07-28 00:48:19.942	2026-07-28 00:48:19.942
00000000-0000-4000-8000-000000000099	Pedagang menutup trotoar di Pasar Baru	Lapak pedagang memenuhi trotoar sehingga pejalan kaki terpaksa berjalan di badan jalan. Lokasi: Pasar Baru. Foto kondisi dapat diberikan jika diperlukan.	APPROVED	9d895d68-e919-4d07-9c60-ff5c649d9ef0	2026-09-09 22:43:44.69	2026-09-14 20:48:17.369
00000000-0000-4000-8000-000000000100	Kabel menjuntai di Simpang Lima	Kabel utilitas menjuntai rendah di atas jalan dan dapat tersangkut kendaraan tinggi. Lokasi: Simpang Lima. Sudah dilaporkan ke RT setempat namun belum ada tindakan.	PENDING	d09ee08a-0962-425f-99e7-7504ab99fd7f	2026-07-18 07:47:10.744	2026-07-18 07:47:10.744
00000000-0000-4000-8000-000000000036	Sampah menumpuk di Jl. Braga	Tumpukan sampah belum diangkut lebih dari seminggu dan mulai menimbulkan bau tidak sedap. Lokasi: Jl. Braga. Foto kondisi dapat diberikan jika diperlukan.	PENDING	d09ee08a-0962-425f-99e7-7504ab99fd7f	2026-06-16 01:51:10.921	2026-10-13 14:43:35.288
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.users (id, name, email, password, role, picture_url, is_active, created_by, created_at, updated_at) FROM stdin;
5ca25496-4fab-4c02-9f09-9372404ffb73	Administrator	administrator@gmail.com	$2b$10$Xlwdjr4lFSc9fox06uKLPupcjdK1o1vmEeegJ5GNuYJs2.CBMjyMq	ADMIN	\N	t	SYSTEM	2026-10-13 14:40:12.955	2026-10-13 14:40:12.955
2b55a971-24f2-4e8b-824d-b333805438a8	Approver	approver@gmail.com	$2b$10$pG6qNexyASIjV5JhG5yaDeD8RG6VnKm571x61.i4JP0.OaPBXLUhO	APPROVER	\N	t	SYSTEM	2026-10-13 14:40:13.019	2026-10-13 14:40:13.019
d09ee08a-0962-425f-99e7-7504ab99fd7f	Reporter 1	reporter1@gmail.com	$2b$10$OZ7QVlvmlyYcXk7Wf4sKZ.xsxi4DCpvo4mdTdRv8KN4/Gp0YZG/.m	REPORTER	\N	t	SYSTEM	2026-10-13 14:40:13.08	2026-10-13 14:40:13.08
9d895d68-e919-4d07-9c60-ff5c649d9ef0	Reporter 2	reporter2@gmail.com	$2b$10$iNh0NmSEsJsdvSEHzrCcc.uJzJKQDMUSfBcOXNVEx6tA.RXxBZm8i	REPORTER	\N	t	SYSTEM	2026-10-13 14:40:13.139	2026-10-13 14:40:13.139
\.


--
-- Name: _prisma_migrations _prisma_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public._prisma_migrations
    ADD CONSTRAINT _prisma_migrations_pkey PRIMARY KEY (id);


--
-- Name: report_status_histories report_status_histories_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.report_status_histories
    ADD CONSTRAINT report_status_histories_pkey PRIMARY KEY (id);


--
-- Name: reports reports_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.reports
    ADD CONSTRAINT reports_pkey PRIMARY KEY (id);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: users_email_key; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX users_email_key ON public.users USING btree (email);


--
-- Name: report_status_histories report_status_histories_approver_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.report_status_histories
    ADD CONSTRAINT report_status_histories_approver_id_fkey FOREIGN KEY (approver_id) REFERENCES public.users(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: report_status_histories report_status_histories_report_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.report_status_histories
    ADD CONSTRAINT report_status_histories_report_id_fkey FOREIGN KEY (report_id) REFERENCES public.reports(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: reports reports_reporter_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.reports
    ADD CONSTRAINT reports_reporter_id_fkey FOREIGN KEY (reporter_id) REFERENCES public.users(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- PostgreSQL database dump complete
--

\unrestrict BN8D0LmSIYpO7B9rhEKlbxgOvgL0hNqCBl82chgbq3Flqre4HIvg4dHWLWSKScO

