--
-- PostgreSQL database dump
--

-- Dumped from database version 9.6.8
-- Dumped by pg_dump version 9.6.8

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: day_tables; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.day_tables (
    id integer NOT NULL,
    project_id integer NOT NULL,
    date date NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: day_tables_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.day_tables_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: day_tables_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.day_tables_id_seq OWNED BY public.day_tables.id;


--
-- Name: images; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.images (
    id integer NOT NULL,
    tag text,
    image_data text,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: images_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.images_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: images_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.images_id_seq OWNED BY public.images.id;


--
-- Name: projects; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.projects (
    id integer NOT NULL,
    creator_id integer NOT NULL,
    name text,
    description text,
    image_url text,
    address text,
    latitude double precision,
    longitude double precision,
    time_state jsonb,
    time_state_parsed jsonb,
    state text,
    check_mode text,
    share_pic text,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: projects_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.projects_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: projects_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.projects_id_seq OWNED BY public.projects.id;


--
-- Name: reservations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.reservations (
    id integer NOT NULL,
    creator_id integer NOT NULL,
    project_id integer NOT NULL,
    state text,
    date date,
    "time" text,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    name text,
    tel text,
    remark text
);


--
-- Name: reservations_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.reservations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: reservations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.reservations_id_seq OWNED BY public.reservations.id;


--
-- Name: time_tables; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.time_tables (
    id integer NOT NULL,
    project_id integer NOT NULL,
    date date,
    "time" text,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    remain integer
);


--
-- Name: time_tables_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.time_tables_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: time_tables_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.time_tables_id_seq OWNED BY public.time_tables.id;


--
-- Name: users; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.users (
    id integer NOT NULL,
    name text NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    tel text,
    openid text,
    tmp_tel text,
    tmp_name text
);


--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.users_id_seq OWNED BY public.users.id;


--
-- Name: day_tables id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.day_tables ALTER COLUMN id SET DEFAULT nextval('public.day_tables_id_seq'::regclass);


--
-- Name: images id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.images ALTER COLUMN id SET DEFAULT nextval('public.images_id_seq'::regclass);


--
-- Name: projects id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.projects ALTER COLUMN id SET DEFAULT nextval('public.projects_id_seq'::regclass);


--
-- Name: reservations id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.reservations ALTER COLUMN id SET DEFAULT nextval('public.reservations_id_seq'::regclass);


--
-- Name: time_tables id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.time_tables ALTER COLUMN id SET DEFAULT nextval('public.time_tables_id_seq'::regclass);


--
-- Name: users id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);


--
-- Name: day_tables day_tables_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.day_tables
    ADD CONSTRAINT day_tables_pkey PRIMARY KEY (id);


--
-- Name: images images_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.images
    ADD CONSTRAINT images_pkey PRIMARY KEY (id);


--
-- Name: projects projects_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.projects
    ADD CONSTRAINT projects_pkey PRIMARY KEY (id);


--
-- Name: reservations reservations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.reservations
    ADD CONSTRAINT reservations_pkey PRIMARY KEY (id);


--
-- Name: time_tables time_tables_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.time_tables
    ADD CONSTRAINT time_tables_pkey PRIMARY KEY (id);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: day_tables day_tables_project_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.day_tables
    ADD CONSTRAINT day_tables_project_id_fkey FOREIGN KEY (project_id) REFERENCES public.projects(id) ON DELETE CASCADE;


--
-- Name: projects projects_creator_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.projects
    ADD CONSTRAINT projects_creator_id_fkey FOREIGN KEY (creator_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: reservations reservations_creator_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.reservations
    ADD CONSTRAINT reservations_creator_id_fkey FOREIGN KEY (creator_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: reservations reservations_project_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.reservations
    ADD CONSTRAINT reservations_project_id_fkey FOREIGN KEY (project_id) REFERENCES public.projects(id) ON DELETE CASCADE;


--
-- Name: time_tables time_tables_project_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.time_tables
    ADD CONSTRAINT time_tables_project_id_fkey FOREIGN KEY (project_id) REFERENCES public.projects(id) ON DELETE CASCADE;


--
-- PostgreSQL database dump complete
--

--
-- PostgreSQL database dump
--

-- Dumped from database version 9.6.8
-- Dumped by pg_dump version 9.6.8

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET client_min_messages = warning;
SET row_security = off;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: kyon
--

CREATE TABLE public.schema_migrations (
    filename text NOT NULL
);


ALTER TABLE public.schema_migrations OWNER TO kyon;

--
-- Data for Name: schema_migrations; Type: TABLE DATA; Schema: public; Owner: kyon
--

COPY public.schema_migrations (filename) FROM stdin;
20180314065239_create_users.rb
20180322031122_create_projects.rb
20180402084613_create_images.rb
20180408092458_create_time_tables.rb
20180410070413_create_day_tables.rb
20180410081326_time_table.rb
20180412065031_create_reservations.rb
20180412081731_create_customers.rb
20180412081733_reservation.rb
20180412084151_customers.rb
20180413042034_users.rb
20180413074527_drop_table.rb
20180413082134_create_reservations.rb
20180417043329_reservation.rb
20180418030358_add_data_to_user.rb
20180418031009_add_data_to_user.rb
20180423024943_update_reservations.rb
20180423025323_update_reservations.rb
\.


--
-- Name: schema_migrations schema_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: kyon
--

ALTER TABLE ONLY public.schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (filename);


--
-- PostgreSQL database dump complete
--

