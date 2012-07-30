--
-- PostgreSQL database dump
--

SET statement_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = off;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET escape_string_warning = off;

--
-- Name: finance; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA finance;


--
-- Name: people; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA people;


--
-- Name: product; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA product;


--
-- Name: user_account; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA user_account;


--
-- Name: plpgsql; Type: PROCEDURAL LANGUAGE; Schema: -; Owner: -
--

CREATE OR REPLACE PROCEDURAL LANGUAGE plpgsql;


SET search_path = public, pg_catalog;

--
-- Name: stock_movement_type; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE stock_movement_type AS ENUM (
    'sell',
    'buy',
    'consignation',
    'return',
    'donation',
    'relocation'
);


SET search_path = finance, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: account; Type: TABLE; Schema: finance; Owner: -; Tablespace: 
--

CREATE TABLE account (
    name text NOT NULL,
    bank text,
    account_number text,
    agency text,
    balance money DEFAULT '$0.00'::money NOT NULL
);


--
-- Name: installment; Type: TABLE; Schema: finance; Owner: -; Tablespace: 
--

CREATE TABLE installment (
    ledger integer NOT NULL,
    due date NOT NULL,
    amount money NOT NULL,
    payed boolean DEFAULT false NOT NULL
);


--
-- Name: installment_payment; Type: TABLE; Schema: finance; Owner: -; Tablespace: 
--

CREATE TABLE installment_payment (
    id integer NOT NULL,
    ledger integer NOT NULL,
    due date NOT NULL,
    date date DEFAULT now() NOT NULL,
    amount money NOT NULL,
    account text NOT NULL,
    payment_method text,
    comments text
);


--
-- Name: installment_payment_id_seq; Type: SEQUENCE; Schema: finance; Owner: -
--

CREATE SEQUENCE installment_payment_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: installment_payment_id_seq; Type: SEQUENCE OWNED BY; Schema: finance; Owner: -
--

ALTER SEQUENCE installment_payment_id_seq OWNED BY installment_payment.id;


--
-- Name: ledger; Type: TABLE; Schema: finance; Owner: -; Tablespace: 
--

CREATE TABLE ledger (
    id integer NOT NULL,
    ledger_type text NOT NULL,
    account text NOT NULL,
    value money NOT NULL,
    datetime timestamp without time zone NOT NULL,
    stock_movement integer,
    comment text
);


--
-- Name: ledger_id_seq; Type: SEQUENCE; Schema: finance; Owner: -
--

CREATE SEQUENCE ledger_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: ledger_id_seq; Type: SEQUENCE OWNED BY; Schema: finance; Owner: -
--

ALTER SEQUENCE ledger_id_seq OWNED BY ledger.id;


--
-- Name: ledger_type; Type: TABLE; Schema: finance; Owner: -; Tablespace: 
--

CREATE TABLE ledger_type (
    slug text NOT NULL,
    name text NOT NULL
);


SET search_path = people, pg_catalog;

--
-- Name: address; Type: TABLE; Schema: people; Owner: -; Tablespace: 
--

CREATE TABLE address (
    id  SERIAL NOT NULL,
    person text NOT NULL,
    street_address_line1 TEXT NOT NULL,
    street_address_line2 TEXT,
    borough text,
    city text NOT NULL,
    state text NOT NULL,
    country text NOT NULL,
    phone text
    zip_code text NOT NULL,
    post_office_box text,
    is_main_address boolean DEFAULT true NOT NULL,
);


--
-- Name: bank_account; Type: TABLE; Schema: people; Owner: -; Tablespace: 
--

CREATE TABLE bank_account (
    person text NOT NULL,
    bank text NOT NULL,
    account text NOT NULL,
    agency text,
    is_savings_account boolean DEFAULT false NOT NULL,
    comments text
);


--
-- Name: client; Type: TABLE; Schema: people; Owner: -; Tablespace: 
--

CREATE TABLE client (
    person text NOT NULL
);


--
-- Name: contact; Type: TABLE; Schema: people; Owner: -; Tablespace: 
--

CREATE TABLE contact (
    client text NOT NULL,
    date date DEFAULT now() NOT NULL,
    answered boolean DEFAULT false NOT NULL,
    type text NOT NULL,
    abstract text NOT NULL
);


--
-- Name: document; Type: TABLE; Schema: people; Owner: -; Tablespace: 
--

CREATE TABLE document (
    person text NOT NULL,
    type text NOT NULL,
    value text
);


--
-- Name: employee; Type: TABLE; Schema: people; Owner: -; Tablespace: 
--

CREATE TABLE employee (
    person text NOT NULL
);


--
-- Name: person; Type: TABLE; Schema: people; Owner: -; Tablespace: 
--

CREATE TABLE person (
    slug text NOT NULL,
    name text NOT NULL,
    phone text,
    email text,
    site text,
    comments text
);


--
-- Name: representant; Type: TABLE; Schema: people; Owner: -; Tablespace: 
--

CREATE TABLE representant (
    person text NOT NULL
);


--
-- Name: supplier; Type: TABLE; Schema: people; Owner: -; Tablespace: 
--

CREATE TABLE supplier (
    person text NOT NULL
);


SET search_path = product, pg_catalog;

--
-- Name: category; Type: TABLE; Schema: product; Owner: -; Tablespace: 
--

CREATE TABLE category (
    slug text NOT NULL,
    parent text,
    name text NOT NULL
);


--
-- Name: consignation; Type: TABLE; Schema: product; Owner: -; Tablespace: 
--

CREATE TABLE consignation (
    id integer NOT NULL,
    datetime timestamp without time zone DEFAULT now() NOT NULL,
    expected_return date,
    product integer NOT NULL,
    amount integer NOT NULL,
    representant text NOT NULL,
    stock_movement integer NOT NULL
);


--
-- Name: consignation_id_seq; Type: SEQUENCE; Schema: product; Owner: -
--

CREATE SEQUENCE consignation_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: consignation_id_seq; Type: SEQUENCE OWNED BY; Schema: product; Owner: -
--

ALTER SEQUENCE consignation_id_seq OWNED BY consignation.id;


--
-- Name: place; Type: TABLE; Schema: product; Owner: -; Tablespace: 
--

CREATE TABLE place (
    place text NOT NULL
);


--
-- Name: product; Type: TABLE; Schema: product; Owner: -; Tablespace: 
--

CREATE TABLE product (
    id integer NOT NULL,
    name text NOT NULL,
    supplier text,
    cost money,
    minimum_price money,
    price money NOT NULL,
    weight double precision,
    image bytea,
    short_description text,
    description text
);

CREATE TABLE product_meta (
    product integer NOT NULL,
    name text NOT NULL,
    value text NOT NULL
);
--
-- Name: product_category; Type: TABLE; Schema: product; Owner: -; Tablespace: 
--

CREATE TABLE product_category (
    product integer NOT NULL,
    category text NOT NULL
);


--
-- Name: product_id_seq; Type: SEQUENCE; Schema: product; Owner: -
--

CREATE SEQUENCE product_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: product_id_seq; Type: SEQUENCE OWNED BY; Schema: product; Owner: -
--

ALTER SEQUENCE product_id_seq OWNED BY product.id;


--
-- Name: product_stock; Type: TABLE; Schema: product; Owner: -; Tablespace: 
--

CREATE TABLE product_stock (
    product integer NOT NULL,
    place text NOT NULL,
    amount integer NOT NULL
);


--
-- Name: return; Type: TABLE; Schema: product; Owner: -; Tablespace: 
--

CREATE TABLE return (
    id integer NOT NULL,
    datetime timestamp without time zone DEFAULT now() NOT NULL,
    consignation integer NOT NULL,
    amount integer NOT NULL,
    stock_movement integer,
    ledger integer
);


--
-- Name: return_id_seq; Type: SEQUENCE; Schema: product; Owner: -
--

CREATE SEQUENCE return_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: return_id_seq; Type: SEQUENCE OWNED BY; Schema: product; Owner: -
--

ALTER SEQUENCE return_id_seq OWNED BY return.id;


--
-- Name: stock_movement; Type: TABLE; Schema: product; Owner: -; Tablespace: 
--

CREATE TABLE stock_movement (
    id integer NOT NULL,
    datetime timestamp without time zone NOT NULL,
    amount integer NOT NULL,
    type public.stock_movement_type NOT NULL,
    place text NOT NULL,
    product integer NOT NULL
);


--
-- Name: stock_movement_id_seq; Type: SEQUENCE; Schema: product; Owner: -
--

CREATE SEQUENCE stock_movement_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: stock_movement_id_seq; Type: SEQUENCE OWNED BY; Schema: product; Owner: -
--

ALTER SEQUENCE stock_movement_id_seq OWNED BY stock_movement.id;


--
-- Name: subscription; Type: TABLE; Schema: product; Owner: -; Tablespace: 
--

CREATE TABLE subscription (
    client text NOT NULL,
    product integer NOT NULL,
    active boolean DEFAULT true NOT NULL,
    subscription_date timestamp without time zone DEFAULT now() NOT NULL,
    subscription_edition integer,
    expiry_date timestamp without time zone,
    expiry_edition integer
);


SET search_path = user_account, pg_catalog;

--
-- Name: role; Type: TABLE; Schema: user_account; Owner: -; Tablespace: 
--

CREATE TABLE role (
    role text NOT NULL
);


--
-- Name: user_account; Type: TABLE; Schema: user_account; Owner: -; Tablespace: 
--

CREATE TABLE user_account (
    login text NOT NULL,
    password text NOT NULL,
    name text NOT NULL
);


--
-- Name: user_account_role; Type: TABLE; Schema: user_account; Owner: -; Tablespace: 
--

CREATE TABLE user_account_role (
    login text NOT NULL,
    role text NOT NULL
);


SET search_path = finance, pg_catalog;

--
-- Name: id; Type: DEFAULT; Schema: finance; Owner: -
--

ALTER TABLE installment_payment ALTER COLUMN id SET DEFAULT nextval('installment_payment_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: finance; Owner: -
--

ALTER TABLE ledger ALTER COLUMN id SET DEFAULT nextval('ledger_id_seq'::regclass);


SET search_path = product, pg_catalog;

--
-- Name: id; Type: DEFAULT; Schema: product; Owner: -
--

ALTER TABLE consignation ALTER COLUMN id SET DEFAULT nextval('consignation_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: product; Owner: -
--

ALTER TABLE product ALTER COLUMN id SET DEFAULT nextval('product_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: product; Owner: -
--

ALTER TABLE return ALTER COLUMN id SET DEFAULT nextval('return_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: product; Owner: -
--

ALTER TABLE stock_movement ALTER COLUMN id SET DEFAULT nextval('stock_movement_id_seq'::regclass);


SET search_path = finance, pg_catalog;

--
-- Name: account_pkey; Type: CONSTRAINT; Schema: finance; Owner: -; Tablespace: 
--

ALTER TABLE ONLY account
    ADD CONSTRAINT account_pkey PRIMARY KEY (name);


--
-- Name: installment_payment_pkey; Type: CONSTRAINT; Schema: finance; Owner: -; Tablespace: 
--

ALTER TABLE ONLY installment_payment
    ADD CONSTRAINT installment_payment_pkey PRIMARY KEY (id);


--
-- Name: installment_pkey; Type: CONSTRAINT; Schema: finance; Owner: -; Tablespace: 
--

ALTER TABLE ONLY installment
    ADD CONSTRAINT installment_pkey PRIMARY KEY (ledger, due);


--
-- Name: ledger_pkey; Type: CONSTRAINT; Schema: finance; Owner: -; Tablespace: 
--

ALTER TABLE ONLY ledger
    ADD CONSTRAINT ledger_pkey PRIMARY KEY (id);


--
-- Name: ledger_type_pkey; Type: CONSTRAINT; Schema: finance; Owner: -; Tablespace: 
--

ALTER TABLE ONLY ledger_type
    ADD CONSTRAINT ledger_type_pkey PRIMARY KEY (slug);


SET search_path = people, pg_catalog;

--
-- Name: address_pkey; Type: CONSTRAINT; Schema: people; Owner: -; Tablespace: 
--

ALTER TABLE ONLY address
    ADD CONSTRAINT address_pkey PRIMARY KEY (id);


--
-- Name: bank_account_pkey; Type: CONSTRAINT; Schema: people; Owner: -; Tablespace: 
--

ALTER TABLE ONLY bank_account
    ADD CONSTRAINT bank_account_pkey PRIMARY KEY (person, bank, account);


--
-- Name: client_pkey; Type: CONSTRAINT; Schema: people; Owner: -; Tablespace: 
--

ALTER TABLE ONLY client
    ADD CONSTRAINT client_pkey PRIMARY KEY (person);


--
-- Name: contact_pkey; Type: CONSTRAINT; Schema: people; Owner: -; Tablespace: 
--

ALTER TABLE ONLY contact
    ADD CONSTRAINT contact_pkey PRIMARY KEY (client);


--
-- Name: document_pkey; Type: CONSTRAINT; Schema: people; Owner: -; Tablespace: 
--

ALTER TABLE ONLY document
    ADD CONSTRAINT document_pkey PRIMARY KEY (person, type);


--
-- Name: employee_pkey; Type: CONSTRAINT; Schema: people; Owner: -; Tablespace: 
--

ALTER TABLE ONLY employee
    ADD CONSTRAINT employee_pkey PRIMARY KEY (person);


--
-- Name: person_pkey; Type: CONSTRAINT; Schema: people; Owner: -; Tablespace: 
--

ALTER TABLE ONLY person
    ADD CONSTRAINT person_pkey PRIMARY KEY (slug);


--
-- Name: representant_pkey; Type: CONSTRAINT; Schema: people; Owner: -; Tablespace: 
--

ALTER TABLE ONLY representant
    ADD CONSTRAINT representant_pkey PRIMARY KEY (person);


--
-- Name: supplier_pkey; Type: CONSTRAINT; Schema: people; Owner: -; Tablespace: 
--

ALTER TABLE ONLY supplier
    ADD CONSTRAINT supplier_pkey PRIMARY KEY (person);


SET search_path = product, pg_catalog;

--
-- Name: category_pkey; Type: CONSTRAINT; Schema: product; Owner: -; Tablespace: 
--

ALTER TABLE ONLY category
    ADD CONSTRAINT category_pkey PRIMARY KEY (slug);


--
-- Name: consignation_pkey; Type: CONSTRAINT; Schema: product; Owner: -; Tablespace: 
--

ALTER TABLE ONLY consignation
    ADD CONSTRAINT consignation_pkey PRIMARY KEY (id);


--
-- Name: place_pkey; Type: CONSTRAINT; Schema: product; Owner: -; Tablespace: 
--

ALTER TABLE ONLY place
    ADD CONSTRAINT place_pkey PRIMARY KEY (place);


--
-- Name: product_category_pkey; Type: CONSTRAINT; Schema: product; Owner: -; Tablespace: 
--

ALTER TABLE ONLY product_category
    ADD CONSTRAINT product_category_pkey PRIMARY KEY (product, category);


--
-- Name: product_pkey; Type: CONSTRAINT; Schema: product; Owner: -; Tablespace: 
--

ALTER TABLE ONLY product
    ADD CONSTRAINT product_pkey PRIMARY KEY (id);

ALTER TABLE ONLY product_meta
    ADD CONSTRAINT product_meta_pkey PRIMARY KEY (product, name);


--
-- Name: product_stock_pkey; Type: CONSTRAINT; Schema: product; Owner: -; Tablespace: 
--

ALTER TABLE ONLY product_stock
    ADD CONSTRAINT product_stock_pkey PRIMARY KEY (product, place);


--
-- Name: return_pkey; Type: CONSTRAINT; Schema: product; Owner: -; Tablespace: 
--

ALTER TABLE ONLY return
    ADD CONSTRAINT return_pkey PRIMARY KEY (id);


--
-- Name: stock_movement_pkey; Type: CONSTRAINT; Schema: product; Owner: -; Tablespace: 
--

ALTER TABLE ONLY stock_movement
    ADD CONSTRAINT stock_movement_pkey PRIMARY KEY (id);


--
-- Name: subscription_pkey; Type: CONSTRAINT; Schema: product; Owner: -; Tablespace: 
--

ALTER TABLE ONLY subscription
    ADD CONSTRAINT subscription_pkey PRIMARY KEY (client, product);


SET search_path = user_account, pg_catalog;

--
-- Name: role_pkey; Type: CONSTRAINT; Schema: user_account; Owner: -; Tablespace: 
--

ALTER TABLE ONLY role
    ADD CONSTRAINT role_pkey PRIMARY KEY (role);


--
-- Name: user_account_pkey; Type: CONSTRAINT; Schema: user_account; Owner: -; Tablespace: 
--

ALTER TABLE ONLY user_account
    ADD CONSTRAINT user_account_pkey PRIMARY KEY (login);


--
-- Name: user_account_role_pkey; Type: CONSTRAINT; Schema: user_account; Owner: -; Tablespace: 
--

ALTER TABLE ONLY user_account_role
    ADD CONSTRAINT user_account_role_pkey PRIMARY KEY (login, role);


SET search_path = finance, pg_catalog;

--
-- Name: installment_ledger_fkey; Type: FK CONSTRAINT; Schema: finance; Owner: -
--

ALTER TABLE ONLY installment
    ADD CONSTRAINT installment_ledger_fkey FOREIGN KEY (ledger) REFERENCES ledger(id);


--
-- Name: installment_payment_account_fkey; Type: FK CONSTRAINT; Schema: finance; Owner: -
--

ALTER TABLE ONLY installment_payment
    ADD CONSTRAINT installment_payment_account_fkey FOREIGN KEY (account) REFERENCES account(name);


--
-- Name: installment_payment_ledger_fkey; Type: FK CONSTRAINT; Schema: finance; Owner: -
--

ALTER TABLE ONLY installment_payment
    ADD CONSTRAINT installment_payment_ledger_fkey FOREIGN KEY (ledger, due) REFERENCES installment(ledger, due);


--
-- Name: ledger_account_fkey; Type: FK CONSTRAINT; Schema: finance; Owner: -
--

ALTER TABLE ONLY ledger
    ADD CONSTRAINT ledger_account_fkey FOREIGN KEY (account) REFERENCES account(name);


--
-- Name: ledger_ledger_type_fkey; Type: FK CONSTRAINT; Schema: finance; Owner: -
--

ALTER TABLE ONLY ledger
    ADD CONSTRAINT ledger_ledger_type_fkey FOREIGN KEY (ledger_type) REFERENCES ledger_type(slug);


--
-- Name: ledger_stock_movement_fkey; Type: FK CONSTRAINT; Schema: finance; Owner: -
--

ALTER TABLE ONLY ledger
    ADD CONSTRAINT ledger_stock_movement_fkey FOREIGN KEY (stock_movement) REFERENCES product.stock_movement(id);


SET search_path = people, pg_catalog;

--
-- Name: address_person_fkey; Type: FK CONSTRAINT; Schema: people; Owner: -
--

ALTER TABLE ONLY address
    ADD CONSTRAINT address_person_fkey FOREIGN KEY (person) REFERENCES person(slug)
    ON DELETE CASCADE ON UPDATE CASCADE;


--
-- Name: bank_account_person_fkey; Type: FK CONSTRAINT; Schema: people; Owner: -
--

ALTER TABLE ONLY bank_account
    ADD CONSTRAINT bank_account_person_fkey FOREIGN KEY (person) REFERENCES person(slug)
    ON DELETE CASCADE ON UPDATE CASCADE;


--
-- Name: client_person_fkey; Type: FK CONSTRAINT; Schema: people; Owner: -
--

ALTER TABLE ONLY client
    ADD CONSTRAINT client_person_fkey FOREIGN KEY (person) REFERENCES person(slug)
    ON DELETE CASCADE ON UPDATE CASCADE;


--
-- Name: contact_client_fkey; Type: FK CONSTRAINT; Schema: people; Owner: -
--

ALTER TABLE ONLY contact
    ADD CONSTRAINT contact_client_fkey FOREIGN KEY (client) REFERENCES client(person)
    ON DELETE CASCADE ON UPDATE CASCADE;


--
-- Name: document_person_fkey; Type: FK CONSTRAINT; Schema: people; Owner: -
--

ALTER TABLE ONLY document
    ADD CONSTRAINT document_person_fkey FOREIGN KEY (person) REFERENCES person(slug)
    ON DELETE CASCADE ON UPDATE CASCADE;


--
-- Name: employee_person_fkey; Type: FK CONSTRAINT; Schema: people; Owner: -
--

ALTER TABLE ONLY employee
    ADD CONSTRAINT employee_person_fkey FOREIGN KEY (person) REFERENCES person(slug)
    ON DELETE CASCADE ON UPDATE CASCADE;


--
-- Name: representant_person_fkey; Type: FK CONSTRAINT; Schema: people; Owner: -
--

ALTER TABLE ONLY representant
    ADD CONSTRAINT representant_person_fkey FOREIGN KEY (person) REFERENCES person(slug)
    ON DELETE CASCADE ON UPDATE CASCADE;


--
-- Name: supplier_person_fkey; Type: FK CONSTRAINT; Schema: people; Owner: -
--

ALTER TABLE ONLY supplier
    ADD CONSTRAINT supplier_person_fkey FOREIGN KEY (person) REFERENCES person(slug)
    ON DELETE CASCADE ON UPDATE CASCADE;


SET search_path = product, pg_catalog;

ALTER TABLE ONLY product_meta
    ADD CONSTRAINT product_meta_product_fkey FOREIGN KEY (product) REFERENCES product(id)
    ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Name: consignation_representant_fkey; Type: FK CONSTRAINT; Schema: product; Owner: -
--

ALTER TABLE ONLY consignation
    ADD CONSTRAINT consignation_representant_fkey FOREIGN KEY (representant) REFERENCES people.representant(person)
    ON DELETE CASCADE ON UPDATE CASCADE;


--
-- Name: consignation_stock_movement_fkey; Type: FK CONSTRAINT; Schema: product; Owner: -
--

ALTER TABLE ONLY consignation
    ADD CONSTRAINT consignation_stock_movement_fkey FOREIGN KEY (stock_movement) REFERENCES stock_movement(id)
    ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE ONLY consignation
    ADD CONSTRAINT consignation_product_fkey FOREIGN KEY (product) REFERENCES product(id)
    ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE ONLY category
    ADD CONSTRAINT category_category_fkey FOREIGN KEY (parent) REFERENCES category(slug)
    ON DELETE CASCADE ON UPDATE CASCADE;


--
-- Name: product_category_category_fkey; Type: FK CONSTRAINT; Schema: product; Owner: -
--

ALTER TABLE ONLY product_category
    ADD CONSTRAINT product_category_category_fkey FOREIGN KEY (category) REFERENCES category(slug)
    ON DELETE CASCADE ON UPDATE CASCADE;


--
-- Name: product_category_product_fkey; Type: FK CONSTRAINT; Schema: product; Owner: -
--

ALTER TABLE ONLY product_category
    ADD CONSTRAINT product_category_product_fkey FOREIGN KEY (product) REFERENCES product(id)
    ON DELETE CASCADE ON UPDATE CASCADE;


--
-- Name: product_stock_place_fkey; Type: FK CONSTRAINT; Schema: product; Owner: -
--

ALTER TABLE ONLY product_stock
    ADD CONSTRAINT product_stock_place_fkey FOREIGN KEY (place) REFERENCES place(place)
    ON DELETE CASCADE ON UPDATE CASCADE;


--
-- Name: product_stock_product_fkey; Type: FK CONSTRAINT; Schema: product; Owner: -
--

ALTER TABLE ONLY product_stock
    ADD CONSTRAINT product_stock_product_fkey FOREIGN KEY (product) REFERENCES product(id)
    ON DELETE CASCADE ON UPDATE CASCADE;


--
-- Name: product_supplier_fkey; Type: FK CONSTRAINT; Schema: product; Owner: -
--

ALTER TABLE ONLY product
    ADD CONSTRAINT product_supplier_fkey FOREIGN KEY (supplier) REFERENCES people.supplier(person);


--
-- Name: return_consignation_fkey; Type: FK CONSTRAINT; Schema: product; Owner: -
--

ALTER TABLE ONLY return
    ADD CONSTRAINT return_consignation_fkey FOREIGN KEY (consignation) REFERENCES consignation(id);


--
-- Name: return_ledger_fkey; Type: FK CONSTRAINT; Schema: product; Owner: -
--

ALTER TABLE ONLY return
    ADD CONSTRAINT return_ledger_fkey FOREIGN KEY (ledger) REFERENCES finance.ledger(id);


--
-- Name: return_stock_movement_fkey; Type: FK CONSTRAINT; Schema: product; Owner: -
--

ALTER TABLE ONLY return
    ADD CONSTRAINT return_stock_movement_fkey FOREIGN KEY (stock_movement) REFERENCES stock_movement(id);


--
-- Name: stock_movement_place_fkey; Type: FK CONSTRAINT; Schema: product; Owner: -
--

ALTER TABLE ONLY stock_movement
    ADD CONSTRAINT stock_movement_place_fkey FOREIGN KEY (place) REFERENCES place(place);


--
-- Name: stock_movement_product_fkey; Type: FK CONSTRAINT; Schema: product; Owner: -
--

ALTER TABLE ONLY stock_movement
    ADD CONSTRAINT stock_movement_product_fkey FOREIGN KEY (product) REFERENCES product(id);


--
-- Name: subscription_client_fkey; Type: FK CONSTRAINT; Schema: product; Owner: -
--

ALTER TABLE ONLY subscription
    ADD CONSTRAINT subscription_client_fkey FOREIGN KEY (client) REFERENCES people.client(person);


--
-- Name: subscription_product_fkey; Type: FK CONSTRAINT; Schema: product; Owner: -
--

ALTER TABLE ONLY subscription
    ADD CONSTRAINT subscription_product_fkey FOREIGN KEY (product) REFERENCES product(id);


SET search_path = user_account, pg_catalog;

--
-- Name: user_account_role_login_fkey; Type: FK CONSTRAINT; Schema: user_account; Owner: -
--

ALTER TABLE ONLY user_account_role
    ADD CONSTRAINT user_account_role_login_fkey FOREIGN KEY (login) REFERENCES user_account(login) ON DELETE CASCADE;


--
-- Name: user_account_role_role_fkey; Type: FK CONSTRAINT; Schema: user_account; Owner: -
--

ALTER TABLE ONLY user_account_role
    ADD CONSTRAINT user_account_role_role_fkey FOREIGN KEY (role) REFERENCES role(role) ON DELETE CASCADE;


--
-- PostgreSQL database dump complete
--

