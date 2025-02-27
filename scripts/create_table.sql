SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET row_security = off;

DROP TABLE IF EXISTS customers;
CREATE TABLE customers (
    customerid integer NOT NULL,
    firstname character varying(60) NOT NULL,
    lastname character varying(60) NOT NULL,
    address1 character varying(60) NOT NULL,
    address2 character varying(60),
    city character varying(60) NOT NULL,
    state character varying(60),
    zip integer,
    country character varying(60) NOT NULL,
    region smallint NOT NULL,
    email character varying(60),
    phone character varying(60),
    creditcardtype integer NOT NULL,
    creditcard character varying(60) NOT NULL,
    creditcardexpiration character varying(60) NOT NULL,
    username character varying(60) NOT NULL,
    password character varying(60) NOT NULL,
    age smallint,
    income integer,
    gender character varying(1)
);
