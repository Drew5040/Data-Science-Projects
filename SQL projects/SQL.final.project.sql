

-- Andrew O'Drain
-- CIS 2109
-- December 12, 2022
-- Final Project


-- create ZIP CODE table

CREATE TABLE zip_code

( zip_code_id               NUMBER(10)      NOT NULL,
  zip                                VARCHAR(10),
  
  CONSTRAINT zip_code_id_pk
  PRIMARY KEY (zip_code_id),
  UNIQUE(zip));
  
  




--  create RESIDENT table

CREATE TABLE resident

( resident_id                         NUMBER(10)               NOT NULL,
  first_name                          VARCHAR(30)      NOT NULL,
  last_name                           VARCHAR(30)      NOT NULL,
  str_address                         VARCHAR(30)      NOT NULL,
  birth_date                           DATE                     NOT NULL,
  ssn                                         VARCHAR(11)      NOT NULL,
  zip_code_id                        NUMBER              NOT NULL,
  
   CONSTRAINT    resident_id_pk
   PRIMARY KEY  ( resident_id ),
   CONSTRAINT  zip_code_id_fk_one
   FOREIGN KEY  ( zip_code_id)
   REFERENCES  zip_code(zip_code_id),
   UNIQUE (ssn));


-- create RESIDENT PHONE NUMBER table

CREATE TABLE resident_phone_number

( phone_number                 NUMBER(10)               NOT NULL,
  resident_id                         NUMBER(10)               NOT NULL,
 
   CONSTRAINT    phone_number_resident_id_cpk
   PRIMARY KEY  ( phone_number, resident_id ),
   CONSTRAINT  resident_id_fk_one
   FOREIGN KEY ( resident_id)
   REFERENCES  resident(resident_id));
   


-- create TEST CENTER table

CREATE TABLE test_center

( test_center_id                  NUMBER(10)               NOT NULL,
  center_name                     VARCHAR(30)             NOT NULL,
  street_address                  VARCHAR(30)             NOT NULL,
  zip_code_id                        NUMBER (10)             NOT NULL,
  
   CONSTRAINT    test_center_id_pk
   PRIMARY KEY  ( test_center_id ),
   CONSTRAINT  zip_code_id_fk_two
   FOREIGN KEY  ( zip_code_id)
   REFERENCES  zip_code(zip_code_id));


CREATE TABLE goes_to

( resident_id                        NUMBER(10)               NOT NULL,
  test_center_id                  NUMBER(10)              NOT NULL,
  test_date                           DATE                     NOT NULL,
  test_time                           TIMESTAMP        NOT NULL,
  test_result                         VARCHAR(100)    NOT NULL,
 
                CONSTRAINT resident_id_test_center_id_pk
                PRIMARY KEY (resident_id, test_center_id),
                CONSTRAINT resident_id_fk_two
                FOREIGN KEY (resident_id)
                REFERENCES resident(resident_id),
                CONSTRAINT test_center_id_fk_one
                FOREIGN KEY (test_center_id)
                REFERENCES test_center(test_center_id));



CREATE TABLE county

( county_id                           NUMBER(10)               NOT NULL,
  county_name                    VARCHAR(50)             NOT NULL,
  population                          NUMERIC(11,2)                     NOT NULL,

                CONSTRAINT county_id_pk
                PRIMARY KEY (county_id),
                UNIQUE(county_name));





CREATE TABLE city

( city_id                               NUMBER(10)               NOT NULL,
  city_name                        VARCHAR(50)              NOT NULL,
  populace                           NUMERIC(11,2)              NOT NULL,
  county_id                          NUMBER(10)               NOT NULL,
  zip_code_id                      NUMBER (10)              NOT NULL,
 
                CONSTRAINT city_id_pk
                PRIMARY KEY (city_id),
                CONSTRAINT county_id_fk
                FOREIGN KEY (county_id)
                REFERENCES county(county_id),
                CONSTRAINT zip_code_id_fk_three
                FOREIGN KEY (zip_code_id)
                REFERENCES zip_code(zip_code_id));


DROP TABLE city;
DROP TABLE county;
DROP TABLE gets_tested_at;
DROP TABLE test_center;
DROP TABLE resident_phone_number;
DROP TABLE resident;
DROP TABLE zip_code;















































































































