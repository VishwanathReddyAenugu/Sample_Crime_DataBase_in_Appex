-------------------------DROP SEQ--------------------------------------         
DROP 	SEQUENCE	REGION_SEQ;
DROP 	SEQUENCE	LOCATION_SEQ;
DROP 	SEQUENCE	FINANCIAL_SEQ;
DROP 	SEQUENCE	OFFENCE_SEQ;
DROP 	SEQUENCE	CRIME_REGISTER_SEQ;
DROP 	SEQUENCE	OFFICER_SEQ;
--------------------------------DROP TRIG------------------------------
DROP TRIGGER REGION_TRIG;
DROP TRIGGER LOCATION_TRIG;
DROP TRIGGER FINANCIAL_TRIG;
DROP TRIGGER OFFENCE_TRIG;
DROP TRIGGER CRIME_REGISTER_TRIG;
DROP TRIGGER OFFICER_TRIG;
--------------------------DROP TABLES ----------------------------------
DROP TABLE 	LOCATION  CASCADE CONSTRAINTS;
DROP TABLE 	REGION  CASCADE CONSTRAINTS;
DROP TABLE 	OFFENCE  CASCADE CONSTRAINTS;
DROP TABLE 	FINANCIAL  CASCADE CONSTRAINTS;
DROP TABLE 	CRIME_REGISTER  CASCADE CONSTRAINTS;
DROP TABLE 	OFFICER  CASCADE CONSTRAINTS;
-------------------------CREATE SEQ--------------------------------------
CREATE 	SEQUENCE	REGION_SEQ	START WITH 1 INCREMENT BY 1;
CREATE 	SEQUENCE	LOCATION_SEQ	START WITH 1 INCREMENT BY 1;
CREATE 	SEQUENCE	FINANCIAL_SEQ	START WITH 1 INCREMENT BY 1;
CREATE 	SEQUENCE	OFFENCE_SEQ	START WITH 1 INCREMENT BY 1;
CREATE 	SEQUENCE	CRIME_REGISTER_SEQ	START WITH 1 INCREMENT BY 1;
CREATE 	SEQUENCE	OFFICER_SEQ	START WITH 1 INCREMENT BY 1;
---------------------------DROP VIEW--------------------------------------
--DROP VIEW CRIME_V;
---------------------------CREATE TABLES--------------------------------
-----------------------------REGION--------------------------------------
CREATE TABLE REGION(
    region_id   NUMBER(8),
    region_name VARCHAR2(32),
    Total_numbers_per_Region    NUMBER(8)   DEFAULT(0),
    CONSTRAINT 		PK_REGION 		PRIMARY KEY (region_id)
);
-----------------------------LOCATION--------------------------------------
CREATE TABLE LOCATION(
    location_id NUMBER(8),
    House_no    NUMBER(4)   DEFAULT(NULL),
    street_name   VARCHAR2(32)	NOT NULL,
    post_code   VARCHAR2(8)		NOT NULL UNIQUE,
    city_name   VARCHAR2(32),
    region_id   NUMBER(8),
    CONSTRAINT pk_location PRIMARY KEY(location_id),
    CONSTRAINT UNIQUE_location UNIQUE(House_no, street_name, city_name)
);
ALTER TABLE LOCATION ADD CONSTRAINT FK_REGION	FOREIGN KEY(region_id) REFERENCES REGION(region_id) ON DELETE CASCADE;
------------------------OFFICER------------------------------------------------------
CREATE TABLE OFFICER(
    officer_id   NUMBER(8),
    first_name    VARCHAR2(32),
    middle_name    VARCHAR2(32) DEFAULT NULL,
    last_name    VARCHAR2(32),
    DOB           DATE,
    GENDER        VARCHAR2(8),
    DEPARTMENT    VARCHAR2(32),
    RANK          NUMBER(8),
    CONSTRAINT 		PK_OFFICER 		PRIMARY KEY (officer_id)
);
-----------------------------FINANCIAL--------------------------------------
CREATE TABLE FINANCIAL(
    financial_id    NUMBER(8),
    financial_year  NUMBER(4),
    Total_England_per_Crime   NUMBER(8) DEFAULT(0),
    CONSTRAINT pk_financial_id PRIMARY KEY(financial_id)
);


-----------------------------CRIME_REGISTER--------------------------------------
CREATE TABLE CRIME_REGISTER(
    crime_id         NUMBER(4),
    crime_name       varchar2(20),
    location_id      NUMBER(8),
    reported_date    DATE    NOT NULL, --MM/DD/YY
    police_id        NUMBER(4),
    crime_status     VARCHAR2(8) CHECK (crime_status in('OPEN', 'CLOSED', 'open','closed')),
    closed_date      DATE   DEFAULT NULL, --MM/DD/YY
    reporter_id      NUMBER(8),
    officer_note     VARCHAR2(128),
    crime_type       VARCHAR2(15),
    linked_crime_id  NUMBER(8),
    detective_id     NUMBER(8),
    CONSTRAINT pk_crime_reg PRIMARY KEY (crime_id)
);
ALTER TABLE CRIME_REGISTER ADD CONSTRAINT fk_crime_reg_loc FOREIGN KEY (location_id) REFERENCES LOCATION(location_id) ON DELETE CASCADE;
ALTER TABLE CRIME_REGISTER ADD CONSTRAINT FK_OFFICER	     FOREIGN KEY(police_id)    REFERENCES OFFICER(officer_id) ON DELETE CASCADE;
ALTER TABLE CRIME_REGISTER ADD CONSTRAINT FK_detective	     FOREIGN KEY(detective_id)    REFERENCES OFFICER(officer_id) ON DELETE CASCADE;
COMMIT;
/


-----------------------------OFFENCE--------------------------------------
CREATE TABLE OFFENCE(
    offence_id     NUMBER(8),
    offence_type   VARCHAR2(32) NOT NULL,  
    financial_id   NUMBER(8),
    crime_id       NUMBER(8),        
    CONSTRAINT pk_offence PRIMARY KEY(offence_id)
);
ALTER TABLE OFFENCE ADD CONSTRAINT fk_offence_region_id FOREIGN KEY(financial_id) REFERENCES FINANCIAL(financial_id) ON DELETE CASCADE;
ALTER TABLE OFFENCE ADD CONSTRAINT fk_offence_CRIME_REG FOREIGN KEY(crime_id) REFERENCES CRIME_REGISTER(CRIME_id) ON DELETE CASCADE;
-----------------------------------------------------------------------------------------
-------------------------------TRIGGERS--------------------------------------------------
-------------------------------REGION----------------------------------------------------
CREATE OR REPLACE TRIGGER REGION_TRIG
BEFORE INSERT ON REGION 
FOR EACH ROW 
BEGIN
    IF :NEW.region_id IS NULL THEN
        SELECT REGION_SEQ.NEXTVAL INTO :NEW.region_id FROM SYS.DUAL;
    END IF;    
END;
/
-----------------------LOCATION-------------------------------------------------------

CREATE OR REPLACE TRIGGER LOCATION_TRIG
BEFORE INSERT ON LOCATION 
FOR EACH ROW 
BEGIN
    IF :NEW.location_id IS NULL THEN
        SELECT LOCATION_SEQ.NEXTVAL INTO :NEW.location_id FROM SYS.DUAL;
    END IF;    
END;
/
------------------------OFFICER-------------------------------------------------

CREATE OR REPLACE TRIGGER OFFICER_TRIG
BEFORE INSERT ON OFFICER 
FOR EACH ROW 
BEGIN
    IF :NEW.officer_id IS NULL THEN
        SELECT OFFICER_SEQ.NEXTVAL INTO :NEW.OFFICER_id FROM SYS.DUAL;
    END IF;    
END;
/

------------------------FINANCIAL-----------------------------------------------
CREATE OR REPLACE TRIGGER FINANCIAL_TRIG
BEFORE INSERT ON FINANCIAL 
FOR EACH ROW 
BEGIN
    IF :NEW.FINANCIAL_id IS NULL THEN
        SELECT FINANCIAL_SEQ.NEXTVAL INTO :NEW.FINANCIAL_ID FROM SYS.DUAL;
    END IF;    
END;
/
-----------------------------OFFENCE---------------------------------------------

CREATE OR REPLACE TRIGGER OFFENCE_TRIG
BEFORE INSERT ON OFFENCE 
FOR EACH ROW 
BEGIN
    IF :NEW.OFFENCE_id IS NULL THEN
        SELECT OFFENCE_SEQ.NEXTVAL INTO :NEW.OFFENCE_ID FROM SYS.DUAL;
    END IF;    
END;
/
-----------------------------CRIME_REGISTER-------------------------------------
CREATE OR REPLACE TRIGGER CRIME_REGISTER_TRIG
BEFORE INSERT ON CRIME_REGISTER 
FOR EACH ROW 
BEGIN
    IF :NEW.CRIME_id IS NULL THEN
        SELECT CRIME_REGISTER_SEQ.NEXTVAL INTO :NEW.CRIME_ID FROM SYS.DUAL;
    END IF;    
END;
/
--------------------------------------------------------------------------------



DROP TABLE crime_reporter CASCADE CONSTRAINTS;
CREATE TABLE crime_reporter
(
	reporter_id	    NUMBER PRIMARY KEY,
	reporter_name 	VARCHAR2(35),
	address	       VARCHAR2(60)
);


INSERT INTO REGION(region_id,region_name,Total_numbers_per_Region) VALUES (REGION_SEQ.nextval,'YORKSHIRE',0);
INSERT INTO REGION(REGION_ID,REGION_NAME) VALUES (REGION_SEQ.nextval,'Mid WALES');
INSERT INTO REGION(REGION_ID,REGION_NAME) VALUES (REGION_SEQ.nextval,'South West, England');
INSERT INTO REGION(REGION_ID,REGION_NAME) VALUES (REGION_SEQ.nextval,'East, England');
INSERT INTO REGION(REGION_ID,REGION_NAME) VALUES (REGION_SEQ.nextval,'North West, England');
INSERT INTO REGION(REGION_ID,REGION_NAME) VALUES (REGION_SEQ.nextval,'London');

------------------------------------------------------------------------LOCATION-----------------------------------------------------------------------------------

INSERT INTO LOCATION (location_id,House_no,street_name,post_code,city_name,region_id) VALUES (LOCATION_SEQ.nextval,1,'ASHROAD','LS10','LEEDS',1);
INSERT INTO LOCATION (location_id,House_no,street_name,post_code,city_name,region_id) VALUES (LOCATION_SEQ.nextval,2,'STREET1','BDP','BRADFORD',1);
INSERT INTO LOCATION (location_id,House_no,street_name,post_code,city_name,region_id) VALUES (LOCATION_SEQ.nextval,12,'STREET5','SA46','Lampeter',2);
INSERT INTO LOCATION (location_id,House_no,street_name,post_code,city_name,region_id) VALUES (LOCATION_SEQ.nextval,5,'STREET3','BS8','Bristol',3);

INSERT INTO LOCATION (location_id,House_no,street_name,post_code,city_name,region_id) VALUES (LOCATION_SEQ.nextval,5,'STREET5','CB3','Cambridge',3);
INSERT INTO LOCATION (location_id,House_no,street_name,post_code,city_name,region_id) VALUES (LOCATION_SEQ.nextval,5,'STREET3','LA1','Lancaster',3);
INSERT INTO LOCATION (location_id,House_no,street_name,post_code,city_name,region_id) VALUES (LOCATION_SEQ.nextval,5,'STREET2','LE5','Leicester',3);
INSERT INTO LOCATION (location_id,House_no,street_name,post_code,city_name,region_id) VALUES (LOCATION_SEQ.nextval,5,'STREET3','L3','Liverpool',3);
INSERT INTO LOCATION (location_id,House_no,street_name,post_code,city_name,region_id) VALUES (LOCATION_SEQ.nextval,5,'STREET8','EC1A','City of London',3);

------------------------------------------------------------------------OFFICER-----------------------------------------------------------------------------------
INSERT INTO OFFICER (officer_id,first_name,middle_name,last_name,DOB,GENDER,DEPARTMENT,RANK) VALUES (OFFICER_SEQ.nextval,'Cece	','Leatrice','Hollands','07-15-1980','Male','Investigation',1);
INSERT INTO OFFICER (officer_id,first_name,middle_name,last_name,DOB,GENDER,DEPARTMENT,RANK) VALUES (OFFICER_SEQ.nextval,'Mary	','Beth','Aitken','01-23-1990','female','law enforcement',2);
INSERT INTO OFFICER (officer_id,first_name,middle_name,last_name,DOB,GENDER,DEPARTMENT,RANK) VALUES (OFFICER_SEQ.nextval,'Amelia	','Bob','Simmons','3-11-1985','female','Investigation',1);
INSERT INTO OFFICER (officer_id,first_name,middle_name,last_name,DOB,GENDER,DEPARTMENT,RANK) VALUES (OFFICER_SEQ.nextval,'Hannah	','Cliff','Tucker','12-13-1984','female','law enforcement',1);
INSERT INTO OFFICER (officer_id,first_name,middle_name,last_name,DOB,GENDER,DEPARTMENT,RANK) VALUES (OFFICER_SEQ.nextval,'Lennie	','Avaline','Thompsett','11-28-1978','male','law enforcement',2);
INSERT INTO OFFICER (officer_id,first_name,middle_name,last_name,DOB,GENDER,DEPARTMENT,RANK) VALUES (OFFICER_SEQ.nextval,'Abigail','','McDonald','05-25-1984','Male','law enforcement',2);
INSERT INTO OFFICER (officer_id,first_name,middle_name,last_name,DOB,GENDER,DEPARTMENT,RANK) VALUES (OFFICER_SEQ.nextval,'Stephanie	','','Gill','2-03-1986','Male','law enforcement',3);
INSERT INTO OFFICER (officer_id,first_name,middle_name,last_name,DOB,GENDER,DEPARTMENT,RANK) VALUES (OFFICER_SEQ.nextval,'Nicholas	','','Parsons','2-1-1988','Male','law enforcement',1);
INSERT INTO OFFICER (officer_id,first_name,middle_name,last_name,DOB,GENDER,DEPARTMENT,RANK) VALUES (OFFICER_SEQ.nextval,'Kimberly	','','Randall','9-17-1975','Male','law enforcement',2);
INSERT INTO OFFICER (officer_id,first_name,middle_name,last_name,DOB,GENDER,DEPARTMENT,RANK) VALUES (OFFICER_SEQ.nextval,'Kimberly	','','Oliver','6-16-1988','female','Investigation',1);
INSERT INTO OFFICER (officer_id,first_name,middle_name,last_name,DOB,GENDER,DEPARTMENT,RANK) VALUES (OFFICER_SEQ.nextval,'Anne	','','Dickens','02-9-1984','female','law enforcement',3);
INSERT INTO OFFICER (officer_id,first_name,middle_name,last_name,DOB,GENDER,DEPARTMENT,RANK) VALUES (OFFICER_SEQ.nextval,'Joe	','','Randall','07-24-1987','Male','law enforcement',1);
INSERT INTO OFFICER (officer_id,first_name,middle_name,last_name,DOB,GENDER,DEPARTMENT,RANK) VALUES (OFFICER_SEQ.nextval,'Connor	','M','Ferguson','8-16-1981','Male','law enforcement',1);
INSERT INTO OFFICER (officer_id,first_name,middle_name,last_name,DOB,GENDER,DEPARTMENT,RANK) VALUES (OFFICER_SEQ.nextval,'Max	','','Brown','10-11-1982','Male','law enforcement',4);
INSERT INTO OFFICER (officer_id,first_name,middle_name,last_name,DOB,GENDER,DEPARTMENT,RANK) VALUES (OFFICER_SEQ.nextval,'Stewart	','','Kerr','05-13-1984','Male','Investigation',1);
------------------------------------------------------------------------FINANCIAL------------------------------------------------------------------------------------

INSERT INTO FINANCIAL (financial_id,financial_year,Total_England_per_Crime) VALUES (FINANCIAL_SEQ.nextval,2015,0);
INSERT INTO FINANCIAL (financial_id,financial_year,Total_England_per_Crime) VALUES (FINANCIAL_SEQ.nextval,2016,0);
INSERT INTO FINANCIAL (financial_id,financial_year,Total_England_per_Crime) VALUES (FINANCIAL_SEQ.nextval,2017,0);
INSERT INTO FINANCIAL (financial_id,financial_year,Total_England_per_Crime) VALUES (FINANCIAL_SEQ.nextval,2018,0);
INSERT INTO FINANCIAL (financial_id,financial_year,Total_England_per_Crime) VALUES (FINANCIAL_SEQ.nextval,2019,0);

------------------------------------------------------------------------OFFENCE------------------------------------------------------------------------------------
INSERT INTO OFFENCE(offence_id, offence_type, financial_id) VALUES (OFFENCE_SEQ.nextval,'DRUNK AND DRIVE',1);
INSERT INTO OFFENCE(offence_id, offence_type, financial_id) VALUES (OFFENCE_SEQ.nextval,'Armed robbery',2);
INSERT INTO OFFENCE(offence_id, offence_type, financial_id) VALUES (OFFENCE_SEQ.nextval,'Blackmail',5);
INSERT INTO OFFENCE(offence_id, offence_type, financial_id) VALUES (OFFENCE_SEQ.nextval,'Forgery',2);
INSERT INTO OFFENCE(offence_id, offence_type, financial_id) VALUES (OFFENCE_SEQ.nextval,'Kidnapping',1);
INSERT INTO OFFENCE(offence_id, offence_type, financial_id) VALUES (OFFENCE_SEQ.nextval,'Armed robbery',4);
INSERT INTO OFFENCE(offence_id, offence_type, financial_id) VALUES (OFFENCE_SEQ.nextval,'Blackmail',3);
INSERT INTO OFFENCE(offence_id, offence_type, financial_id) VALUES (OFFENCE_SEQ.nextval,'Blackmail',1);
INSERT INTO OFFENCE(offence_id, offence_type, financial_id) VALUES (OFFENCE_SEQ.nextval,'Forgery',2);
------------------------------------------------------------------------CRIME_REGISTER------------------------------------------------------------------------------------
INSERT INTO CRIME_REGISTER(crime_id, CRIME_NAME, location_id, reported_date, police_id, crime_status, reporter_id, officer_note) 
VALUES(CRIME_REGISTER_SEQ.nextval,'Theft',1,'05-24-2015',5,'CLOSED',1,'case is reported at 2pm afternoon');

INSERT INTO CRIME_REGISTER(crime_id, CRIME_NAME, location_id, reported_date, police_id, crime_status, reporter_id, officer_note) 
VALUES(CRIME_REGISTER_SEQ.nextval,'hit and run',1,'11-02-2015',5,'OPEN',2,'');

INSERT INTO CRIME_REGISTER(crime_id, CRIME_NAME, location_id, reported_date, police_id, crime_status, reporter_id, officer_note) 
VALUES(CRIME_REGISTER_SEQ.nextval,'armed robbery',2,'01-15-2016',7,'OPEN',3,'');

INSERT INTO CRIME_REGISTER(crime_id, CRIME_NAME, location_id, reported_date, police_id, crime_status, reporter_id, officer_note) 
VALUES(CRIME_REGISTER_SEQ.nextval,'murder',4,'10-29-2017',8,'CLOSED',1,'');

INSERT INTO CRIME_REGISTER(crime_id, CRIME_NAME, location_id, reported_date, police_id, crime_status, reporter_id, officer_note) 
VALUES(CRIME_REGISTER_SEQ.nextval,'armed robbery',1,'02-13-2019',9,'OPEN',4,'');

INSERT INTO CRIME_REGISTER(crime_id, CRIME_NAME, location_id, reported_date, police_id, crime_status, reporter_id, officer_note) 
VALUES(CRIME_REGISTER_SEQ.nextval,'Black mail',2,'05-09-2019',2,'CLOSED',5,'');

INSERT INTO CRIME_REGISTER(crime_id, CRIME_NAME, location_id, reported_date, police_id, crime_status, reporter_id, officer_note) 
VALUES(CRIME_REGISTER_SEQ.nextval,'Theft',5,'7-19-2019',3,'CLOSED',2,'');

--------------------------------------------------reporter--------------------------------------------------
INSERT INTO crime_reporter(reporter_id,reporter_name,address) VALUES (1,'RAVINDER','LS6 HYDE PARK');
INSERT INTO crime_reporter(reporter_id,reporter_name,address) VALUES (2,'SANAL','LS6 HEADINGLEY AVE');
INSERT INTO crime_reporter(reporter_id,reporter_name,address) VALUES (3,'VISHWANATH','ASHVILL TERRACE, LS6');
INSERT INTO crime_reporter(reporter_id,reporter_name,address) VALUES (4,'SANAL','LS6 HEADINGLY');
INSERT INTO crime_reporter(reporter_id,reporter_name,address) VALUES (5,'ALEX','W11 LONDON');
--------------------------------------------------------------------------CRIME_V---------------------------------------------------

DROP VIEW CRIME_STAT ;
CREATE VIEW CRIME_STAT AS SELECT COUNT(crime_id) CRIMES, reported_date, location_id FROM CRIME_REGISTER GROUP BY  location_id, reported_date;
------------------------------------------------crime_report_view--------------------------------------------
DROP VIEW crime_report_view;
CREATE VIEW crime_report_view AS
    SELECT CRIME_ID, CRIME_NAME, REPORTED_DATE, CLOSED_DATE, CRIME_STATUS, CRIME_TYPE, OFFICER_NOTE,
    HOUSE_NO, STREET_NAME, POST_CODE, CITY_NAME, REGION_NAME,
    FIRST_NAME, MIDDLE_NAME, LAST_NAME, DOB, GENDER, DEPARTMENT,RANK
    FROM CRIME_REGISTER, LOCATION, REGION, OFFICER
    where CRIME_REGISTER.LOCATION_ID = LOCATION.LOCATION_ID and
          CRIME_REGISTER.POLICE_ID = OFFICER.OFFICER_ID and
          LOCATION.REGION_ID = REGION.REGION_ID;
--------------------------------------------------------------------------------------------
--CREATE VIEW CRIME_V AS 
--SELECT reported_date, street_name, city_name, region_name, crime_status, officer_note
--FROM CRIME_REGISTER C, LOCATION L, REGION R
--WHERE C.location_id = L.location_id AND L.region_id = R.region_id;


/*
UPDATE CRIME_REGISTER SET detective_id=2, linked_crime_id = NULL, OFFICER_NOTE = '', CRIME_TYPE = 'primary' WHERE crime_id = 1;
UPDATE CRIME_REGISTER SET detective_id=2, linked_crime_id = NULL, OFFICER_NOTE = '', CRIME_TYPE = 'primary' WHERE crime_id = 1;
UPDATE CRIME_REGISTER SET detective_id=2, linked_crime_id = NULL, OFFICER_NOTE = '', CRIME_TYPE = 'primary' WHERE crime_id = 1;
UPDATE CRIME_REGISTER SET detective_id=2, linked_crime_id = NULL, OFFICER_NOTE = '', CRIME_TYPE = 'primary' WHERE crime_id = 1;
UPDATE CRIME_REGISTER SET detective_id=2, linked_crime_id = NULL, OFFICER_NOTE = '', CRIME_TYPE = 'primary' WHERE crime_id = 1;
UPDATE CRIME_REGISTER SET detective_id=2, linked_crime_id = NULL, OFFICER_NOTE = '', CRIME_TYPE = 'primary' WHERE crime_id = 1;
UPDATE CRIME_REGISTER SET detective_id=2, linked_crime_id = NULL, OFFICER_NOTE = '', CRIME_TYPE = 'primary' WHERE crime_id = 1;
UPDATE CRIME_REGISTER SET detective_id=2, linked_crime_id = NULL, OFFICER_NOTE = '', CRIME_TYPE = 'primary' WHERE crime_id = 1;
UPDATE CRIME_REGISTER SET detective_id=2, linked_crime_id = NULL, OFFICER_NOTE = '', CRIME_TYPE = 'primary' WHERE crime_id = 1;
UPDATE CRIME_REGISTER SET detective_id=2, linked_crime_id = NULL, OFFICER_NOTE = '', CRIME_TYPE = 'primary' WHERE crime_id = 1;
UPDATE CRIME_REGISTER SET detective_id=2, linked_crime_id = NULL, OFFICER_NOTE = '', CRIME_TYPE = 'primary' WHERE crime_id = 1;
UPDATE CRIME_REGISTER SET detective_id=2, linked_crime_id = NULL, OFFICER_NOTE = '', CRIME_TYPE = 'primary' WHERE crime_id = 1;
UPDATE CRIME_REGISTER SET detective_id=2, linked_crime_id = NULL, OFFICER_NOTE = '', CRIME_TYPE = 'primary' WHERE crime_id = 1;
UPDATE CRIME_REGISTER SET detective_id=2, linked_crime_id = NULL, OFFICER_NOTE = '', CRIME_TYPE = 'primary' WHERE crime_id = 1;



INSERT INTO CRIME_REGISTER(crime_id, location_id, reported_date, police_id, crime_status, reporter_id, officer_note) 
VALUES(CRIME_REGISTER_SEQ.nextval,1,'05-24-2015',5,'CLOSED',1,'case is reported at 2pm afternoon');

INSERT INTO CRIME_REGISTER(crime_id, location_id, reported_date, police_id, crime_status, reporter_id, officer_note) 
VALUES(CRIME_REGISTER_SEQ.nextval,1,'11-02-2015',5,'OPEN',2,'');

INSERT INTO CRIME_REGISTER(crime_id, location_id, reported_date, police_id, crime_status, reporter_id, officer_note) 
VALUES(CRIME_REGISTER_SEQ.nextval,2,'01-15-2016',7,'OPEN',3,'');

INSERT INTO CRIME_REGISTER(crime_id, location_id, reported_date, police_id, crime_status, reporter_id, officer_note) 
VALUES(CRIME_REGISTER_SEQ.nextval,4,'10-29-2017',8,'CLOSED',1,'');

INSERT INTO CRIME_REGISTER(crime_id, location_id, reported_date, police_id, crime_status, reporter_id, officer_note) 
VALUES(CRIME_REGISTER_SEQ.nextval,1,'02-13-2019',9,'OPEN',4,'');

INSERT INTO CRIME_REGISTER(crime_id, location_id, reported_date, police_id, crime_status, reporter_id, officer_note) 
VALUES(CRIME_REGISTER_SEQ.nextval,2,'05-09-2019',2,'CLOSED',5,'');

INSERT INTO CRIME_REGISTER(crime_id, location_id, reported_date, police_id, crime_status, reporter_id, officer_note) 
VALUES(CRIME_REGISTER_SEQ.nextval,5,'7-19-2019',3,'CLOSED',2,'');
*/
