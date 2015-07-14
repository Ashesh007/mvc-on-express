--
-- PostgreSQL database dump
--

SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;

-- SHOW config_file;

--
-- Name: config_type; Type: TYPE; Schema: public;
--

CREATE TYPE config_type AS ENUM (
    'STRING',
    'INTEGER',
    'BOOLEAN'
);


--
-- Name: device_info; Type: TYPE; Schema: public;
--

CREATE TYPE device_info AS (
	handset character varying(15),
	version character varying(10),
	imei bigint
);


--
-- Name: platform_type; Type: TYPE; Schema: public;
--

CREATE TYPE platform_type AS ENUM (
    'ANDROID',
    'IOS'
);


SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: wa_api_app_versions; Type: TABLE; Schema: public; ; Tablespace:
--

CREATE TABLE wa_api_app_versions (
    id integer NOT NULL,
    api_version character varying(10) NOT NULL,
    app_version character varying(10) NOT NULL,
    status smallint NOT NULL DEFAULT 1,
    platform platform_type DEFAULT 'ANDROID'::platform_type NOT NULL
);


--
-- Name: COLUMN wa_api_app_versions.status; Type: COMMENT; Schema: public;
--

COMMENT ON COLUMN wa_api_app_versions.status IS '1 - ACTIVE, 2 - INACTIVE';


--
-- Name: wa_api_app_versions_id_seq; Type: SEQUENCE; Schema: public;
--

CREATE SEQUENCE wa_api_app_versions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: wa_api_app_versions_id_seq; Type: SEQUENCE OWNED BY; Schema: public;
--

ALTER SEQUENCE wa_api_app_versions_id_seq OWNED BY wa_api_app_versions.id;


--
-- Name: wa_config; Type: TABLE; Schema: public; ; Tablespace:
--

CREATE TABLE wa_config (
    id integer NOT NULL,
    conf_name character varying(40) NOT NULL,
    conf_value text NOT NULL,
    conf_type config_type DEFAULT 'STRING'::config_type NOT NULL
);


--
-- Name: COLUMN wa_config.conf_type; Type: COMMENT; Schema: public;
--

COMMENT ON COLUMN wa_config.conf_type IS 'STRING, INTEGER, BOOLEAN';


--
-- Name: wa_config_id_seq; Type: SEQUENCE; Schema: public;
--

CREATE SEQUENCE wa_config_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: wa_config_id_seq; Type: SEQUENCE OWNED BY; Schema: public;
--

ALTER SEQUENCE wa_config_id_seq OWNED BY wa_config.id;


--
-- Name: wa_oauth_clients; Type: TABLE; Schema: public; ; Tablespace:
--

CREATE TABLE wa_oauth_clients (
    id integer NOT NULL,
    secret_key character varying(50) NOT NULL,
    device platform_type NOT NULL,
    created_dt timestamp without time zone DEFAULT localtimestamp NOT NULL,
    updated_dt timestamp without time zone DEFAULT localtimestamp NOT NULL
);


--
-- Name: wa_oauth_clients_id_seq; Type: SEQUENCE; Schema: public;
--

CREATE SEQUENCE wa_oauth_clients_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: wa_oauth_clients_id_seq; Type: SEQUENCE OWNED BY; Schema: public;
--

ALTER SEQUENCE wa_oauth_clients_id_seq OWNED BY wa_oauth_clients.id;


--
-- Name: wa_oauth_users; Type: TABLE; Schema: public; ; Tablespace:
--

CREATE TABLE wa_oauth_users (
    id integer NOT NULL,
    user_id integer NOT NULL,
    access_token character varying(32) NOT NULL,
    created_at timestamp without time zone DEFAULT localtimestamp NOT NULL,
    expiry_date timestamp without time zone
);


--
-- Name: wa_oauth_users_id_seq; Type: SEQUENCE; Schema: public;
--

CREATE SEQUENCE wa_oauth_users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: wa_oauth_users_id_seq; Type: SEQUENCE OWNED BY; Schema: public;
--

ALTER SEQUENCE wa_oauth_users_id_seq OWNED BY wa_oauth_users.id;


--
-- Name: wa_user; Type: TABLE; Schema: public; ; Tablespace:
--

CREATE TABLE wa_user (
    id integer NOT NULL,
    first_name character varying(30) NOT NULL,
    last_name character varying(30) NOT NULL,
    email_id character varying(30) NOT NULL,
    phone_no BIGINT NOT NULL,
    password_hash character varying(60) NOT NULL,
    country character varying(2) DEFAULT 'IN'::character varying NOT NULL,
    is_phone_verified smallint NOT NULL DEFAULT 1,
    image character varying(255),
    status smallint NOT NULL DEFAULT 1,
    user_url character varying(50),
    bio character varying(200),
    created_at timestamp without time zone DEFAULT localtimestamp NOT NULL,
    updated_at timestamp without time zone DEFAULT localtimestamp NOT NULL
);


--
-- Name: COLUMN wa_user.is_phone_verified; Type: COMMENT; Schema: public;
--

COMMENT ON COLUMN wa_user.is_phone_verified IS '1 - Not Verified, 2 - Verified';

--
-- Name: COLUMN wa_user.is_phone_verified; Type: COMMENT; Schema: public;
--

COMMENT ON COLUMN wa_user.status IS '1 - user inactive, 2 - user active';


--
-- Name: wa_user_audit_log; Type: TABLE; Schema: public; ; Tablespace:
--

CREATE TABLE wa_user_audit_log (
    id integer NOT NULL,
    user_id integer NOT NULL,
    data json
);


--
-- Name: wa_user_audit_log_id_seq; Type: SEQUENCE; Schema: public;
--

CREATE SEQUENCE wa_user_audit_log_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: wa_user_audit_log_id_seq; Type: SEQUENCE OWNED BY; Schema: public;
--

ALTER SEQUENCE wa_user_audit_log_id_seq OWNED BY wa_user_audit_log.id;


--
-- Name: wa_user_id_seq; Type: SEQUENCE; Schema: public;
--

CREATE SEQUENCE wa_user_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: wa_user_settings; Type: TABLE; Schema: public; ; Tablespace:
--

CREATE TABLE wa_user_settings (
    id integer NOT NULL,
    user_id integer NOT NULL,
    settings json[]
);


--
-- Name: wa_user_settings_id_seq; Type: SEQUENCE; Schema: public;
--

CREATE SEQUENCE wa_user_settings_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: wa_user_settings_id_seq; Type: SEQUENCE OWNED BY; Schema: public;
--

ALTER SEQUENCE wa_user_settings_id_seq OWNED BY wa_user_settings.id;


--
-- Name: wa_user_versioning; Type: TABLE; Schema: public; ; Tablespace:
--

CREATE TABLE wa_user_versioning (
    id integer NOT NULL,
    user_id integer NOT NULL,
    api_app_id integer NOT NULL,
    device character varying(50) NOT NULL,
    platform character varying(30) NOT NULL,
    platform_version character varying(10) NOT NULL,
    imei character varying(15) NOT NULL,
    registered_id  TEXT,
    active_from timestamp without time zone DEFAULT localtimestamp NOT NULL,
    active_till timestamp without time zone DEFAULT localtimestamp NOT NULL,
    status smallint DEFAULT 1 NOT NULL
);


--
-- Name: COLUMN wa_user_versioning.status; Type: COMMENT; Schema: public;
--

COMMENT ON COLUMN wa_user_versioning.status IS '1 - ACTIVE, 2 - INACTIVE';


--
-- Name: wa_user_versioning_id_seq1; Type: SEQUENCE; Schema: public;
--

CREATE SEQUENCE wa_user_versioning_id_seq1
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: wa_user_versioning_id_seq1; Type: SEQUENCE OWNED BY; Schema: public;
--

ALTER SEQUENCE wa_user_versioning_id_seq1 OWNED BY wa_user_versioning.id;

--
-- Name: id; Type: DEFAULT; Schema: public;
--

ALTER TABLE ONLY wa_api_app_versions ALTER COLUMN id SET DEFAULT nextval('wa_api_app_versions_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public;
--

ALTER TABLE ONLY wa_config ALTER COLUMN id SET DEFAULT nextval('wa_config_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public;
--

ALTER TABLE ONLY wa_oauth_clients ALTER COLUMN id SET DEFAULT nextval('wa_oauth_clients_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public;
--

ALTER TABLE ONLY wa_oauth_users ALTER COLUMN id SET DEFAULT nextval('wa_oauth_users_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public;
--

ALTER TABLE ONLY wa_user ALTER COLUMN id SET DEFAULT nextval('wa_user_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public;
--

ALTER TABLE ONLY wa_user_audit_log ALTER COLUMN id SET DEFAULT nextval('wa_user_audit_log_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public;
--

ALTER TABLE ONLY wa_user_settings ALTER COLUMN id SET DEFAULT nextval('wa_user_settings_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public;
--

ALTER TABLE ONLY wa_user_versioning ALTER COLUMN id SET DEFAULT nextval('wa_user_versioning_id_seq1'::regclass);


--
-- Name: user_id_undex; Type: CONSTRAINT; Schema: public; ; Tablespace:
--

ALTER TABLE ONLY wa_user
    ADD CONSTRAINT user_id_undex PRIMARY KEY (id);


--
-- Name: version_id_index; Type: CONSTRAINT; Schema: public; ; Tablespace:
--

ALTER TABLE ONLY wa_api_app_versions
    ADD CONSTRAINT version_id_index PRIMARY KEY (id);


--
-- Name: wa_access_token_unique; Type: CONSTRAINT; Schema: public; ; Tablespace:
--

ALTER TABLE ONLY wa_oauth_users
    ADD CONSTRAINT wa_access_token_unique UNIQUE (access_token);


--
-- Name: wa_email_id_unique; Type: CONSTRAINT; Schema: public; ; Tablespace:
--

ALTER TABLE ONLY wa_user
    ADD CONSTRAINT wa_email_id_unique UNIQUE (email_id);


--
-- Name: wa_phone_no_unique; Type: CONSTRAINT; Schema: public; ; Tablespace:
--

ALTER TABLE ONLY wa_user
    ADD CONSTRAINT wa_phone_no_unique UNIQUE (phone_no);


--
-- Name: wa_ref_cd_unq; Type: CONSTRAINT; Schema: public; ; Tablespace:
--

ALTER TABLE ONLY wa_oauth_clients
    ADD CONSTRAINT wa_secret_key_unique UNIQUE (secret_key);


--
-- Name: wa_oauth_users_user_id_fkey1; Type: FK CONSTRAINT; Schema: public;
--

ALTER TABLE ONLY wa_oauth_users
    ADD CONSTRAINT wa_oauth_users_user_id_fkey1 FOREIGN KEY (user_id) REFERENCES wa_user(id);


--
-- Name: wa_user_audit_log_user_id_fkey; Type: FK CONSTRAINT; Schema: public;
--

ALTER TABLE ONLY wa_user_audit_log
    ADD CONSTRAINT wa_user_audit_log_user_id_fkey FOREIGN KEY (user_id) REFERENCES wa_user(id);


--
-- Name: wa_user_settings_user_id_fkey1; Type: FK CONSTRAINT; Schema: public;
--

ALTER TABLE ONLY wa_user_settings
    ADD CONSTRAINT wa_user_settings_user_id_fkey1 FOREIGN KEY (user_id) REFERENCES wa_user(id);


--
-- Name: wa_user_versioning_api_app_id_fkey1; Type: FK CONSTRAINT; Schema: public;
--

ALTER TABLE ONLY wa_user_versioning
    ADD CONSTRAINT wa_user_versioning_api_app_id_fkey1 FOREIGN KEY (api_app_id) REFERENCES wa_api_app_versions(id);


--
-- Name: wa_user_versioning_user_id_fkey1; Type: FK CONSTRAINT; Schema: public;
--

ALTER TABLE ONLY wa_user_versioning
    ADD CONSTRAINT wa_user_versioning_user_id_fkey1 FOREIGN KEY (user_id) REFERENCES wa_user(id);


--
-- Name: public; Type: ACL; Schema: -; Owner: postgres
--

REVOKE ALL ON SCHEMA public FROM PUBLIC;
REVOKE ALL ON SCHEMA public FROM postgres;
GRANT ALL ON SCHEMA public TO postgres;
GRANT ALL ON SCHEMA public TO PUBLIC;


--
-- PostgreSQL database dump complete
--



ALTER TABLE ONLY wa_config ADD CONSTRAINT config_id_undex primary key (id);

ALTER TABLE ONLY wa_oauth_clients ADD CONSTRAINT oauth_clients_id_undex primary key (id);

ALTER TABLE ONLY wa_oauth_users ADD CONSTRAINT oauth_users_id_undex primary key (id);

ALTER TABLE ONLY wa_user_audit_log ADD CONSTRAINT user_audit_log_id_undex primary key (id);

ALTER TABLE ONLY wa_user_settings ADD CONSTRAINT user_settings_id_undex primary key (id);

ALTER TABLE ONLY wa_user_versioning ADD CONSTRAINT user_versioning_id_undex primary key (id);


--
-- Name: expire_old_access_token(integer); Type: FUNCTION; Schema: public;
--

CREATE OR REPLACE FUNCTION expire_old_access_token(userid integer) RETURNS integer
    LANGUAGE plpgsql
    AS $$
BEGIN
    UPDATE wa_oauth_users SET expiry_date = CURRENT_TIMESTAMP where user_id = userid AND expiry_date > CURRENT_TIMESTAMP;
    return 1;
END;
$$;

--
-- temp data deployment query
--

INSERT INTO wa_config (conf_name, conf_value, conf_type) VALUES
('pagination_limit', 12, 'INTEGER'),
('requests_per_transaction', 2, 'INTEGER'),
('min_cash_out_amount', 100, 'INTEGER'),
('min_transfer_amount', 1, 'INTEGER'),
('max_balance_amount', 10000, 'INTEGER'),
('GOOGLE_API_KEY', 'AIzaSyBa48W1I2WviCUYlaIjEBCGVCZntyEg4_E', 'STRING');

INSERT INTO wa_api_app_versions (api_version, app_version, status, platform) VALUES
            ('0.1.0', '0.1.0', 1, 'ANDROID'),
            ('0.1.0', '0.1.0', 1, 'IOS');

INSERT INTO wa_oauth_clients(
             secret_key, device, created_dt, updated_dt)
    VALUES ( '798456132132asdkjcvnioaebve', 'ANDROID', localtimestamp, localtimestamp) , ( 'asdh798456132132asdkjcvnioaebve', 'IOS', localtimestamp, localtimestamp);

INSERT INTO wa_user( first_name, last_name, email_id, phone_no, password_hash, country, is_phone_verified, image, status)
    VALUES ( 'Ashesh', 'Khatri', 'ashesh@ambab.com', 8384888899, '123456', 'IN', 2,'/home/Desktop/ashesh.jpg', 2),
       ( 'Ajay', 'Shenoy', 'ajay@ambab.com', 5428963105, '123456', 'IN', 2,'/home/Desktop/ajay.jpg', 2),
       ( 'Ankur', 'Pandey', 'ankur.p@ambab.com', 1234567890, '123456', 'IN',  2,'/home/Desktop/ankur.jpg', 2),
       ( 'Raj', 'Agrawal', 'raj@ambab.com', 8745963210, '123456', 'IN', 2,'/home/Desktop/raj.jpg', 2),
       ( 'Rekha', 'Sutar', 'rekha@ambab.com', 7485963210, '123456', 'IN', 2,'/home/Desktop/rekha.jpg', 2),
       ( 'Vinayak', 'Parekh', 'vinayak@ambab.com', 1425367890, '123456', 'IN', 2,'/home/Desktop/vinayak.jpg', 2);

INSERT INTO wa_oauth_users (user_id, access_token, expiry_date) VALUES
        (1, 'asdfghjkl123456789qwertyuiop9874', localtimestamp + INTERVAL '100 days'),
        (2, 'asdfghjkl123456789qwertyuiop9875', localtimestamp + INTERVAL '100 days'),
        (3, 'asdfghjkl123456789qwertyuiop9876', localtimestamp + INTERVAL '100 days'),
        (4, 'asdfghjkl123456789qwertyuiop9877', localtimestamp + INTERVAL '100 days'),
        (5, 'asdfghjkl123456789qwertyuiop9878', localtimestamp + INTERVAL '100 days'),
        (6, 'asdfghjkl123456789qwertyuiop9879', localtimestamp + INTERVAL '100 days');

INSERT INTO wa_user_versioning (user_id, api_app_id, device, platform, platform_version,
        imei, status) VALUES
        (1, 1, 'Google Nexus 5 - 4.4.2 - API 19 - 1080x1920', 'ANDROID', '4.4.2',
        '000000000000001', 1),
        (2, 1, 'Sony Experis Z - 4.4.2 - API 19 - 1080x1920', 'ANDROID', '4.4.2',
        '000000000000002', 1),
        (3, 1, 'Micromax CANVAS A114 - 4.4.0 - API 19 - 1080x1920', 'ANDROID', '4.4.0',
        '000000000000003', 1),
        (4, 2, 'Iphone 5 - 4.4.2 - API 19 - 1080x1920', 'IOS', '4.4.2',
        '000000000000004', 1),
        (5, 2, 'Iphone 6 - 4.4.2 - API 19 - 1080x1920', 'IOS', '4.4.2',
        '000000000000005', 1),
        (6, 2, 'Iphone 6+ - 4.4.2 - API 19 - 1080x1920', 'IOS', '4.4.2',
        '000000000000006', 1);