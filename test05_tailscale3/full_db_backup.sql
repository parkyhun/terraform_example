--
-- PostgreSQL database cluster dump
--

\restrict D9drmSAOBt7O9Wp3HZx5OQUnNaJj1ldBeMboBOdqUaKcAF5VC9rLsIYeSwZ9hCa

SET default_transaction_read_only = off;

SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;

--
-- Roles
--

CREATE ROLE kim;
ALTER ROLE kim WITH NOSUPERUSER INHERIT NOCREATEROLE NOCREATEDB LOGIN NOREPLICATION NOBYPASSRLS PASSWORD 'SCRAM-SHA-256$4096:aSsrj0WR0G7SVeW2WINHsw==$9r8f6n+28WC+P65d4iVBTlox5YPlJzeDrZKlqja84OM=:iBFYp8WJxeeXTwPShh1Y7ofnSE1FZiU9ynVVeIK5d/k=';
CREATE ROLE postgres;
ALTER ROLE postgres WITH SUPERUSER INHERIT CREATEROLE CREATEDB LOGIN REPLICATION BYPASSRLS PASSWORD 'SCRAM-SHA-256$4096:+h0wQY2Go7E9tFWC8UflMA==$eL0FVu7cd31LDdGu5BaQJMcrkd3t9HMPe7Lnov50Mbw=:VkC3jRI9F6F3ycPr7411kzph47BPr60FidIEc+Tq6Ns=';
CREATE ROLE scott;
ALTER ROLE scott WITH NOSUPERUSER INHERIT NOCREATEROLE NOCREATEDB LOGIN NOREPLICATION NOBYPASSRLS PASSWORD 'SCRAM-SHA-256$4096:2oa+T/DWBOsaN4PVj3Syxw==$vhQ8wsuY9YOpGeQHEXKJxMH69bBrwvyHkKRdkVfXHnY=:rRN0zg3q3P8vzBRLDOPaQ92DkF4GKUtPaXPDf1Y/XGA=';

--
-- User Configurations
--








\unrestrict D9drmSAOBt7O9Wp3HZx5OQUnNaJj1ldBeMboBOdqUaKcAF5VC9rLsIYeSwZ9hCa

--
-- Databases
--

--
-- Database "template1" dump
--

\connect template1

--
-- PostgreSQL database dump
--

\restrict FiJO1NhnSm28y6qKjZcC9R3xTPLUFoBtCCrZ2bX5SrdYwFaVd0xUCUiIqSbOLfL

-- Dumped from database version 15.17
-- Dumped by pg_dump version 15.17

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
-- PostgreSQL database dump complete
--

\unrestrict FiJO1NhnSm28y6qKjZcC9R3xTPLUFoBtCCrZ2bX5SrdYwFaVd0xUCUiIqSbOLfL

--
-- Database "kim_db" dump
--

--
-- PostgreSQL database dump
--

\restrict b5M28iE5LramVS8SxSJ3xf5ugkbCqWhwOg4JbHGcPzvZMyrR5ttH8c1ub9fv60S

-- Dumped from database version 15.17
-- Dumped by pg_dump version 15.17

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
-- Name: kim_db; Type: DATABASE; Schema: -; Owner: kim
--

CREATE DATABASE kim_db WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE_PROVIDER = libc LOCALE = 'en_US.UTF-8';


ALTER DATABASE kim_db OWNER TO kim;

\unrestrict b5M28iE5LramVS8SxSJ3xf5ugkbCqWhwOg4JbHGcPzvZMyrR5ttH8c1ub9fv60S
\connect kim_db
\restrict b5M28iE5LramVS8SxSJ3xf5ugkbCqWhwOg4JbHGcPzvZMyrR5ttH8c1ub9fv60S

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

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: member; Type: TABLE; Schema: public; Owner: kim
--

CREATE TABLE public.member (
    num integer NOT NULL,
    name text NOT NULL,
    addr text
);


ALTER TABLE public.member OWNER TO kim;

--
-- Name: member_seq; Type: SEQUENCE; Schema: public; Owner: kim
--

CREATE SEQUENCE public.member_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.member_seq OWNER TO kim;

--
-- Name: post; Type: TABLE; Schema: public; Owner: kim
--

CREATE TABLE public.post (
    num integer NOT NULL,
    writer text NOT NULL,
    title text NOT NULL,
    coneat text,
    created_at timestamp without time zone
);


ALTER TABLE public.post OWNER TO kim;

--
-- Name: post_seq; Type: SEQUENCE; Schema: public; Owner: kim
--

CREATE SEQUENCE public.post_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.post_seq OWNER TO kim;

--
-- Name: test_seq; Type: SEQUENCE; Schema: public; Owner: kim
--

CREATE SEQUENCE public.test_seq
    START WITH 10
    INCREMENT BY 10
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.test_seq OWNER TO kim;

--
-- Name: todo; Type: TABLE; Schema: public; Owner: kim
--

CREATE TABLE public.todo (
    num integer NOT NULL,
    content character varying(20),
    created_at timestamp without time zone DEFAULT now()
);


ALTER TABLE public.todo OWNER TO kim;

--
-- Name: todo_num_seq; Type: SEQUENCE; Schema: public; Owner: kim
--

CREATE SEQUENCE public.todo_num_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.todo_num_seq OWNER TO kim;

--
-- Name: todo_num_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: kim
--

ALTER SEQUENCE public.todo_num_seq OWNED BY public.todo.num;


--
-- Name: todo num; Type: DEFAULT; Schema: public; Owner: kim
--

ALTER TABLE ONLY public.todo ALTER COLUMN num SET DEFAULT nextval('public.todo_num_seq'::regclass);


--
-- Data for Name: member; Type: TABLE DATA; Schema: public; Owner: kim
--

COPY public.member (num, name, addr) FROM stdin;
1	kim	an
2	김구라	노량진
3	박영헌	안산
4	김민서	고잔
\.


--
-- Data for Name: post; Type: TABLE DATA; Schema: public; Owner: kim
--

COPY public.post (num, writer, title, coneat, created_at) FROM stdin;
1	kim	hello	어쩌구.. 저쩌구..	2026-04-03 01:10:47.312398
2	park	hello2	어쩌구.. 저쩌구..1	2026-04-03 01:10:59.080058
3	jo	hello3	어쩌구.. 저쩌구..2	2026-04-03 01:11:10.967605
\.


--
-- Data for Name: todo; Type: TABLE DATA; Schema: public; Owner: kim
--

COPY public.todo (num, content, created_at) FROM stdin;
1	python 공부하기	2026-04-03 02:07:10.173196
2	linux  공부하기	2026-04-03 02:08:10.090212
3	docker  공부하기	2026-04-03 02:08:16.954709
\.


--
-- Name: member_seq; Type: SEQUENCE SET; Schema: public; Owner: kim
--

SELECT pg_catalog.setval('public.member_seq', 4, true);


--
-- Name: post_seq; Type: SEQUENCE SET; Schema: public; Owner: kim
--

SELECT pg_catalog.setval('public.post_seq', 3, true);


--
-- Name: test_seq; Type: SEQUENCE SET; Schema: public; Owner: kim
--

SELECT pg_catalog.setval('public.test_seq', 40, true);


--
-- Name: todo_num_seq; Type: SEQUENCE SET; Schema: public; Owner: kim
--

SELECT pg_catalog.setval('public.todo_num_seq', 3, true);


--
-- Name: member member_pkey; Type: CONSTRAINT; Schema: public; Owner: kim
--

ALTER TABLE ONLY public.member
    ADD CONSTRAINT member_pkey PRIMARY KEY (num);


--
-- Name: post post_pkey; Type: CONSTRAINT; Schema: public; Owner: kim
--

ALTER TABLE ONLY public.post
    ADD CONSTRAINT post_pkey PRIMARY KEY (num);


--
-- Name: todo todo_pkey; Type: CONSTRAINT; Schema: public; Owner: kim
--

ALTER TABLE ONLY public.todo
    ADD CONSTRAINT todo_pkey PRIMARY KEY (num);


--
-- PostgreSQL database dump complete
--

\unrestrict b5M28iE5LramVS8SxSJ3xf5ugkbCqWhwOg4JbHGcPzvZMyrR5ttH8c1ub9fv60S

--
-- Database "postgres" dump
--

\connect postgres

--
-- PostgreSQL database dump
--

\restrict XWOmatRDM1XaZ5iQ6oS1GRvKfmLEv9fRY2kkAwxsKQTNQPgmWxS7lxhK5MTY0Zw

-- Dumped from database version 15.17
-- Dumped by pg_dump version 15.17

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
-- PostgreSQL database dump complete
--

\unrestrict XWOmatRDM1XaZ5iQ6oS1GRvKfmLEv9fRY2kkAwxsKQTNQPgmWxS7lxhK5MTY0Zw

--
-- Database "scott_db" dump
--

--
-- PostgreSQL database dump
--

\restrict LCpogMr3T0XbOPgtpYaRFKxIDGr8JiZkjEUOVeZ2Wzptbs0hDaclHxAWHTT9arD

-- Dumped from database version 15.17
-- Dumped by pg_dump version 15.17

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
-- Name: scott_db; Type: DATABASE; Schema: -; Owner: scott
--

CREATE DATABASE scott_db WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE_PROVIDER = libc LOCALE = 'en_US.UTF-8';


ALTER DATABASE scott_db OWNER TO scott;

\unrestrict LCpogMr3T0XbOPgtpYaRFKxIDGr8JiZkjEUOVeZ2Wzptbs0hDaclHxAWHTT9arD
\connect scott_db
\restrict LCpogMr3T0XbOPgtpYaRFKxIDGr8JiZkjEUOVeZ2Wzptbs0hDaclHxAWHTT9arD

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

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: dept; Type: TABLE; Schema: public; Owner: scott
--

CREATE TABLE public.dept (
    deptno integer NOT NULL,
    dname character varying(14),
    loc character varying(13)
);


ALTER TABLE public.dept OWNER TO scott;

--
-- Name: emp; Type: TABLE; Schema: public; Owner: scott
--

CREATE TABLE public.emp (
    empno integer NOT NULL,
    ename character varying(10),
    job character varying(9),
    mgr integer,
    hiredate date,
    sal numeric(7,2),
    comm numeric(7,2),
    deptno integer
);


ALTER TABLE public.emp OWNER TO scott;

--
-- Name: member; Type: TABLE; Schema: public; Owner: scott
--

CREATE TABLE public.member (
    num integer NOT NULL,
    name text NOT NULL,
    addr text
);


ALTER TABLE public.member OWNER TO scott;

--
-- Name: member_num_seq; Type: SEQUENCE; Schema: public; Owner: scott
--

CREATE SEQUENCE public.member_num_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.member_num_seq OWNER TO scott;

--
-- Name: member_num_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: scott
--

ALTER SEQUENCE public.member_num_seq OWNED BY public.member.num;


--
-- Name: notice; Type: TABLE; Schema: public; Owner: scott
--

CREATE TABLE public.notice (
    num integer NOT NULL,
    content text
);


ALTER TABLE public.notice OWNER TO scott;

--
-- Name: notice_num_seq; Type: SEQUENCE; Schema: public; Owner: scott
--

CREATE SEQUENCE public.notice_num_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.notice_num_seq OWNER TO scott;

--
-- Name: notice_num_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: scott
--

ALTER SEQUENCE public.notice_num_seq OWNED BY public.notice.num;


--
-- Name: post; Type: TABLE; Schema: public; Owner: scott
--

CREATE TABLE public.post (
    num integer NOT NULL,
    writer character varying(50) NOT NULL,
    title character varying(100),
    content text,
    created_at timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.post OWNER TO scott;

--
-- Name: post_num_seq; Type: SEQUENCE; Schema: public; Owner: scott
--

CREATE SEQUENCE public.post_num_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.post_num_seq OWNER TO scott;

--
-- Name: post_num_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: scott
--

ALTER SEQUENCE public.post_num_seq OWNED BY public.post.num;


--
-- Name: member num; Type: DEFAULT; Schema: public; Owner: scott
--

ALTER TABLE ONLY public.member ALTER COLUMN num SET DEFAULT nextval('public.member_num_seq'::regclass);


--
-- Name: notice num; Type: DEFAULT; Schema: public; Owner: scott
--

ALTER TABLE ONLY public.notice ALTER COLUMN num SET DEFAULT nextval('public.notice_num_seq'::regclass);


--
-- Name: post num; Type: DEFAULT; Schema: public; Owner: scott
--

ALTER TABLE ONLY public.post ALTER COLUMN num SET DEFAULT nextval('public.post_num_seq'::regclass);


--
-- Data for Name: dept; Type: TABLE DATA; Schema: public; Owner: scott
--

COPY public.dept (deptno, dname, loc) FROM stdin;
10	ACCOUNTING	NEW YORK
20	RESEARCH	DALLAS
30	SALES	CHICAGO
40	OPERATIONS	BOSTON
\.


--
-- Data for Name: emp; Type: TABLE DATA; Schema: public; Owner: scott
--

COPY public.emp (empno, ename, job, mgr, hiredate, sal, comm, deptno) FROM stdin;
7369	SMITH	CLERK	7902	1980-12-17	800.00	\N	20
7499	ALLEN	SALESMAN	7698	1981-02-20	1600.00	300.00	30
7521	WARD	SALESMAN	7698	1981-02-22	1250.00	500.00	30
7566	JONES	MANAGER	7839	1981-04-02	2975.00	\N	20
7654	MARTIN	SALESMAN	7698	1981-09-28	1250.00	1400.00	30
7698	BLAKE	MANAGER	7839	1981-05-01	2850.00	\N	30
7782	CLARK	MANAGER	7839	1981-06-09	2450.00	\N	10
7788	SCOTT	ANALYST	7566	1987-07-13	3000.00	\N	20
7839	KING	PRESIDENT	\N	1981-11-17	5000.00	\N	10
7844	TURNER	SALESMAN	7698	1981-09-08	1500.00	0.00	30
7876	ADAMS	CLERK	7788	1987-07-13	1100.00	\N	20
7900	JAMES	CLERK	7698	1981-12-03	950.00	\N	30
7902	FORD	ANALYST	7566	1981-12-03	3000.00	\N	20
7934	MILLER	CLERK	7782	1982-01-23	1300.00	\N	10
\.


--
-- Data for Name: member; Type: TABLE DATA; Schema: public; Owner: scott
--

COPY public.member (num, name, addr) FROM stdin;
1	김구라	노량진
3	김구라3	노량진3
4	원숭이	\N
\.


--
-- Data for Name: notice; Type: TABLE DATA; Schema: public; Owner: scott
--

COPY public.notice (num, content) FROM stdin;
1	오늘은 성공 입니다.
2	행복한 시간 보내세요.
3	서로 서로 .
\.


--
-- Data for Name: post; Type: TABLE DATA; Schema: public; Owner: scott
--

COPY public.post (num, writer, title, content, created_at) FROM stdin;
1	kim	hello	...bye	2026-04-20 19:40:26.387492
4	park	hi	hello\r\n	2026-04-20 20:32:40.287669
8	zx	zx	xzxzs	2026-04-21 19:08:57.486811
5	asdasd	asdweq	qweqsa	2026-04-21 18:15:45.587958
7	FDS	SA	ASaaa	2026-04-21 18:38:28.717629
6	ㅁㅁㅁ	ㅁㄴadsdas	ㅇㄴㅁadsfas	2026-04-21 18:36:40.548835
\.


--
-- Name: member_num_seq; Type: SEQUENCE SET; Schema: public; Owner: scott
--

SELECT pg_catalog.setval('public.member_num_seq', 4, true);


--
-- Name: notice_num_seq; Type: SEQUENCE SET; Schema: public; Owner: scott
--

SELECT pg_catalog.setval('public.notice_num_seq', 3, true);


--
-- Name: post_num_seq; Type: SEQUENCE SET; Schema: public; Owner: scott
--

SELECT pg_catalog.setval('public.post_num_seq', 8, true);


--
-- Name: dept dept_pkey; Type: CONSTRAINT; Schema: public; Owner: scott
--

ALTER TABLE ONLY public.dept
    ADD CONSTRAINT dept_pkey PRIMARY KEY (deptno);


--
-- Name: emp emp_pkey; Type: CONSTRAINT; Schema: public; Owner: scott
--

ALTER TABLE ONLY public.emp
    ADD CONSTRAINT emp_pkey PRIMARY KEY (empno);


--
-- Name: member member_pkey; Type: CONSTRAINT; Schema: public; Owner: scott
--

ALTER TABLE ONLY public.member
    ADD CONSTRAINT member_pkey PRIMARY KEY (num);


--
-- Name: notice notice_pkey; Type: CONSTRAINT; Schema: public; Owner: scott
--

ALTER TABLE ONLY public.notice
    ADD CONSTRAINT notice_pkey PRIMARY KEY (num);


--
-- Name: post post_pkey; Type: CONSTRAINT; Schema: public; Owner: scott
--

ALTER TABLE ONLY public.post
    ADD CONSTRAINT post_pkey PRIMARY KEY (num);


--
-- Name: emp emp_deptno_fkey; Type: FK CONSTRAINT; Schema: public; Owner: scott
--

ALTER TABLE ONLY public.emp
    ADD CONSTRAINT emp_deptno_fkey FOREIGN KEY (deptno) REFERENCES public.dept(deptno);


--
-- PostgreSQL database dump complete
--

\unrestrict LCpogMr3T0XbOPgtpYaRFKxIDGr8JiZkjEUOVeZ2Wzptbs0hDaclHxAWHTT9arD

--
-- PostgreSQL database cluster dump complete
--

