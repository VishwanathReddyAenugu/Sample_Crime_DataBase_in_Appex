---------------------------------------------------------------------------crime_types----------------------------------------------------
DROP TABLE crime_types CASCADE CONSTRAINTS;
CREATE TABLE crime_types
(
  crime_type_id Number(3) PRIMARY KEY,
  CRIME_TYPE VARCHAR2(30) UNIQUE NOT NULL --crime_type in ('primary','secondary')
);
---------------------------------------------------------------------------department----------------------------------------------------
DROP TABLE department cascade constraints;
CREATE TABLE department
(
	dep_id   	NUMBER PRIMARY KEY,
	dep_name	VARCHAR2(30)
);
-------------------------------------------------------------------------------police------------------------------------------------------------------
DROP TABLE police cascade constraints;
CREATE TABLE police
(
	police_id	NUMBER(3) PRIMARY KEY,
	name	VARCHAR(35) NOT NULL,
  dept_no  NUMBER NOT NULL,
	FOREIGN KEY(dept_no) REFERENCES department(dep_id)
);
-------------------------------------------------------------------------------people_involved------------------------------------------------------------------
DROP TABLE people_involved CASCADE CONSTRAINTS;
CREATE TABLE people_involved
(
	person_id     	NUMBER(2) PRIMARY KEY,
	address	        VARCHAR2(50),
	gender        	VARCHAR2(10) CHECK (gender in('MALE', 'FEMALE', 'OTHER')),
	dob	            DATE , -- MM/DD/YY
  age             NUMBER DEFAULT NULL,
	name	          VARCHAR2(35)        
);
-------------------------------------------------------------------------------crimes_closed-------------------------------------------------
DROP TABLE crimes_closed CASCADE CONSTRAINTS;
CREATE TABLE crimes_closed
(
 closed_crime_id    NUMBER PRIMARY KEY ,
 solved_date        DATE NOT NULL,
 detective_id       NUMBER NOT NULL,
 criminal_name      VARCHAR2(35) DEFAULT NULL
);

-------------------------------------------------------------------------------crime_reporter-------------------------------------------------------
DROP TABLE crime_reporter CASCADE CONSTRAINTS;
CREATE TABLE crime_reporter
(
	reporter_id	    NUMBER PRIMARY KEY,
	reporter_name 	VARCHAR2(35),
	address	       VARCHAR2(60)
);
--------------------------------------------------------------------------------region-----------------------------------------------------------
DROP TABLE region CASCADE CONSTRAINTS;
CREATE TABLE region
(
	region_id	          NUMBER PRIMARY KEY,
	region_name                VARCHAR2(25), -- UNIQUE
  Total_numbers_per_Region   NUMBER DEFAULT 0
);
--------------------------------------------------------------------------------city-----------------------------------------------------
DROP TABLE city CASCADE CONSTRAINTS;
CREATE TABLE city
(
	location_id	          NUMBER PRIMARY KEY,
	city	                  VARCHAR2(25),
  post_code              varchar2(15),
	region_id	             NUMBER NOT NULL,
  FOREIGN KEY(region_id) REFERENCES region(region_id) ON DELETE CASCADE
);

-------------------------------------------------------------------------------crimes_open---------------------------------------------------------
DROP TABLE crimes_open CASCADE CONSTRAINTS;
CREATE TABLE crimes_open
(
	open_crime_id	NUMBER PRIMARY KEY,
	detective_id	NUMBER,
  recent_update    VARCHAR2(100) DEFAULT NULL
);
--------------------------------------------------------------------------------officer-----------------------------------------------------------
DROP TABLE officer cascade constraints;
CREATE TABLE officer
(
	police_id	              NUMBER PRIMARY KEY,
	head_officer_id     	  NUMBER, -- DEFAULT NULL
	rank	                  NUMBER,
  FOREIGN KEY(police_id) REFERENCES POLICE(police_id) ON DELETE CASCADE
);
--------------------------------------------------------------------------------detective------------------------------------
DROP TABLE detective CASCADE CONSTRAINTS;
CREATE TABLE detective
(
	police_id	NUMBER PRIMARY KEY,
	number_of_cases_solved	NUMBER, -- derived attribute DEFAOULT 0
	FOREIGN KEY(police_id) REFERENCES POLICE(police_id) ON DELETE CASCADE
);
-------------------------------------------------------------------------------CRIME_REGISTER------------------------------------------------------------
--DROP TABLE CRIME_REGISTER CASCADE CONSTRAINTS;
--CREATE TABLE CRIME_REGISTER
--(
--	crime_id                NUMBER PRIMARY KEY,
--	reported_date     	DATE,
--	crime_status      	VARCHAR2(10) NOT NULL ,
--	officer_note      	VARCHAR2(500),
--	fk1_reporter_id   	NUMBER NOT NULL,
--       fk2_location_id   	NUMBER NOT NULL,
--	fk3_police_id    	NUMBER NOT NULL,
--        fk4_open_crime_id       NUMBER ,
--        fk5_closed_crime_id     NUMBER ,
--  FOREIGN KEY(fk2_location_id)  REFERENCES crime_reporter(reporter_id),
--  FOREIGN KEY(fk1_reporter_id)  REFERENCES city(location_id),
--  FOREIGN KEY(fk3_police_id)   REFERENCES officer(police_id),
--  FOREIGN KEY(fk4_open_crime_id) REFERENCES crimes_open(open_crime_id),
--  FOREIGN KEY(fk5_closed_crime_id)   REFERENCES crimes_closed(closed_crime_id),
--  CONSTRAINT ch_crime_status CHECK (crime_status in('open', 'closed'))
--);

DROP TABLE CRIME_REGISTER CASCADE CONSTRAINTS;
CREATE TABLE CRIME_REGISTER
(
	crime_id                NUMBER PRIMARY KEY,
	reported_date     	DATE,
	crime_status      	VARCHAR2(10) CHECK (crime_status in('OPEN', 'CLOSED','open','closed','Open','Closed')),
	officer_note      	VARCHAR2(500),
	fk1_reporter_id   	NUMBER NOT NULL,
        fk2_location_id   	NUMBER NOT NULL,
	fk3_police_id    	NUMBER NOT NULL,
  FOREIGN KEY(fk1_reporter_id)  REFERENCES crime_reporter(reporter_id),
  FOREIGN KEY(fk2_location_id)  REFERENCES city(location_id),
  FOREIGN KEY(fk3_police_id)    REFERENCES officer(police_id)
);



------------------------------------------------------------------------offence--------------------------------------------------------------------------------------
DROP TABLE offence CASCADE CONSTRAINTS;
CREATE TABLE offence
(
	OFFENCE_ID	      NUMBER PRIMARY KEY,
	offence_kind	    VARCHAR2(35) NOT NULL,
  offence_numbers   NUMBER DEFAULT 0
);
--------------------------------------------------------------------------YEAR------------------------------------------------------------------------------------
DROP TABLE YEAR CASCADE CONSTRAINTS;
CREATE TABLE YEAR
(
	finincial_year			NUMBER PRIMARY KEY,
	Total#_England_per_Crime	NUMBER  DEFAULT 0     -- DEFAULT 0
);
------------------------------------------------------------------------------ offence_time_link_entity------------------------------------------------------------------
DROP TABLE offence_time_link_entity CASCADE CONSTRAINTS;
CREATE TABLE offence_time_link_entity
(
	      fk1_OFFENCE_ID   	NUMBER NOT NULL,
	      fk2_finincial_year	NUMBER NOT NULL,
        PRIMARY KEY(fk1_OFFENCE_ID,fk2_finincial_year),

        FOREIGN KEY(fk1_OFFENCE_ID) REFERENCES offence(OFFENCE_ID),
        FOREIGN KEY(fk2_finincial_year) REFERENCES YEAR(finincial_year)
);
------------------------------------------------------------------------------suspect------------------------------------------------------
DROP TABLE suspect CASCADE CONSTRAINTS;
CREATE TABLE suspect
(
	person_id	        NUMBER PRIMARY KEY,
	num_of_crimes	        NUMBER DEFAULT 0,
	previous_address	VARCHAR2(50) DEFAULT 'SAME AS PREVIOUS',
	FOREIGN KEY(person_id) REFERENCES people_involved(person_id) ON DELETE CASCADE
);
-------------------------------------------------------------------------------witness-----------------------------------------------------
DROP TABLE witness CASCADE CONSTRAINTS;
CREATE TABLE witness
(
	person_id	NUMBER PRIMARY KEY,
	num_of_crimes_witnessed	NUMBER DEFAULT 0,
	any_crime_record	VARCHAR2(50) CHECK (any_crime_record in('YES', 'NO')),
	FOREIGN KEY(person_id) REFERENCES people_involved(person_id) ON DELETE CASCADE
);
------------------------------------------------------------------------------victim------------------------------------------------------
DROP TABLE victim CASCADE CONSTRAINTS;
CREATE TABLE victim
(
	person_id	NUMBER PRIMARY KEY,
	relation_with_suspect	VARCHAR(35),
	relation_with_witness	VARCHAR(35),
	
	FOREIGN KEY(person_id) REFERENCES people_involved(person_id) ON DELETE CASCADE 
);
------------------------------------------------------------------------------crime_events------------------------------------------------------
--DROP TABLE crime_events CASCADE CONSTRAINTS;
--CREATE TABLE crime_events
--(
--	event_id	            NUMBER PRIMARY KEY,
--	event_date	          DATE,
--	location_id	          NUMBER NOT NULL,
-- linked_crime_id       NUMBER,
--offence_id            NUMBER,
--  FOREIGN KEY(linked_crime_id) REFERENCES CRIME_REGISTER(crime_id),
 -- FOREIGN KEY(offence_id) REFERENCES offence(OFFENCE_ID)
--);

DROP TABLE crime_events CASCADE CONSTRAINTS;
CREATE TABLE crime_events
(
	event_id	          NUMBER PRIMARY KEY,
	event_date	          DATE,
	location_id	          NUMBER NOT NULL,
        linked_crime_id           NUMBER NOT NULL,
        offence_id                NUMBER,
        evidence                  varchar2(50) DEFAULT NULL,   -- biometrics, wepons, any other objects       
        FOREIGN KEY(linked_crime_id) REFERENCES CRIME_REGISTER(crime_id),
        FOREIGN KEY(offence_id) REFERENCES offence(OFFENCE_ID)
);
---------------------------------------------------------------------------crime_events_suspect---------------------------------------------------------
DROP TABLE crime_events_suspect cascade constraints;
CREATE TABLE crime_events_suspect
(
	s_event_id	NUMBER,
	d_person_id	NUMBER,
	PRIMARY KEY (s_event_id,d_person_id),
  FOREIGN KEY(s_event_id) REFERENCES crime_events(event_id),
	FOREIGN KEY(d_person_id) REFERENCES suspect(person_id) 
);
------------------------------------------------------------------------------crime_events_witness------------------------------------------------------
DROP TABLE crime_events_witness cascade constraints;
CREATE TABLE crime_events_witness
(
	s_event_id	NUMBER,
	d_person_id	NUMBER,
	PRIMARY KEY (s_event_id,d_person_id),
	FOREIGN KEY(s_event_id) REFERENCES crime_events(event_id),
	FOREIGN KEY(d_person_id) REFERENCES witness(person_id)
);
------------------------------------------------------------------------------crime_events_victim------------------------------------------------------
DROP TABLE crime_events_victim cascade constraints;
CREATE TABLE crime_events_victim
(
	s_event_id	NUMBER,
	d_person_id	NUMBER DEFAULT NULL,
	PRIMARY KEY (s_event_id,d_person_id),
	FOREIGN KEY(s_event_id) REFERENCES crime_events(event_id),
	FOREIGN KEY(d_person_id) REFERENCES victim(person_id)
);

-----------------------------------------------REGION-------------------------------------------------------------------------------------------------
DROP SEQUENCE seq_reg_id;
CREATE SEQUENCE seq_reg_id
START WITH 1
INCREMENT BY 1;

ALTER TABLE REGION MODIFY REGION_NAME VARCHAR2(35 CHAR);

INSERT INTO REGION(REGION_ID,REGION_NAME,TOTAL_NUMBERS_PER_REGION) VALUES (seq_reg_id.nextval,'YORKSHIRE',0);
INSERT INTO REGION(REGION_ID,REGION_NAME) VALUES (seq_reg_id.nextval,'Mid WALES');
INSERT INTO REGION(REGION_ID,REGION_NAME) VALUES (seq_reg_id.nextval,'South West, England');
INSERT INTO REGION(REGION_ID,REGION_NAME) VALUES (seq_reg_id.nextval,'East, England');
INSERT INTO REGION(REGION_ID,REGION_NAME) VALUES (seq_reg_id.nextval,'North West, England');
INSERT INTO REGION(REGION_ID,REGION_NAME) VALUES (seq_reg_id.nextval,'London');

-----------------------------------------------CITY-------------------------------------------------------------------------------------------------------------------
DROP SEQUENCE seq_loc_id;
CREATE SEQUENCE seq_loc_id
START WITH 1
INCREMENT BY 1;

ALTER TABLE CITY MODIFY CITY VARCHAR2(35 CHAR);

INSERT INTO CITY (LOCATION_ID,CITY,POST_CODE,REGION_ID) VALUES (seq_loc_id.nextval,'LEEDS','LS10',1);
INSERT INTO CITY (LOCATION_ID,CITY,POST_CODE,REGION_ID) VALUES (seq_loc_id.nextval,'BRADFORD','BDP',1);
INSERT INTO CITY (LOCATION_ID,CITY,POST_CODE,REGION_ID) VALUES (seq_loc_id.nextval,'Lampeter','SA46',2);
INSERT INTO CITY (LOCATION_ID,CITY,POST_CODE,REGION_ID) VALUES (seq_loc_id.nextval,'Bristol','BS8',3);

INSERT into CITY (LOCATION_ID, CITY, POST_CODE, REGION_ID) VALUES (seq_loc_id.nextval,'Cambridge','CB3',4);
INSERT into CITY (LOCATION_ID, CITY, POST_CODE, REGION_ID) VALUES (seq_loc_id.nextval,'Lancaster','LA1',5);
INSERT into CITY (LOCATION_ID, CITY, POST_CODE, REGION_ID) VALUES (seq_loc_id.nextval,'Leicester','LE5',4);
INSERT into CITY (LOCATION_ID, CITY, POST_CODE, REGION_ID) VALUES (seq_loc_id.nextval,'Liverpool','L3',5);
INSERT into CITY (LOCATION_ID, CITY, POST_CODE, REGION_ID) VALUES (seq_loc_id.nextval,'City of London','EC1A',6);

----------------------------------------------------DEPARTMENT--------------------------------------------------------------------------------------------------------------
INSERT INTO department(DEP_ID,DEP_NAME) VALUES (1,'LAW ENFORCEMENT');
INSERT INTO department(DEP_ID,DEP_NAME) VALUES (2,'INVESTIGATION');
----------------------------------------------------YEAR--------------------------------------------------------------------------------------------------------------
INSERT INTO YEAR(finincial_year,Total#_England_per_Crime) VALUES (2015,0);
INSERT INTO YEAR(finincial_year) VALUES (2016);
INSERT INTO YEAR(finincial_year) VALUES (2017);
INSERT INTO YEAR(finincial_year) VALUES (2018);
INSERT INTO YEAR(finincial_year) VALUES (2019);
--------------------------------------------CRIME_TYPES----------------------------------------------------------------------------------------------------------------------
INSERT into crime_types(crime_type_id , CRIME_TYPE) VALUES (1,'PRIMARY');
INSERT into crime_types(crime_type_id , CRIME_TYPE) VALUES (2,'SECONDARY');
------------------------------------------POLICE------------------------------------------------------------------------------------------
INSERT INTO police(police_id,name,dept_no) VALUES(1,'JHON',1);
INSERT INTO police(police_id,name,dept_no) VALUES(2,'PETER',1);
INSERT INTO police(police_id,name,dept_no) VALUES(3,'TOM',2);
INSERT INTO police(police_id,name,dept_no) VALUES(4,'HARRIS',2);
INSERT INTO police(police_id,name,dept_no) VALUES(5,'RICHARD',1);
INSERT INTO police(police_id,name,dept_no) VALUES(6,'CHARLS',1);
INSERT INTO police(police_id,name,dept_no) VALUES(7,'HUDSON',1);

INSERT INTO police(police_id,name,dept_no) VALUES(8,'SAM',1);
INSERT INTO police(police_id,name,dept_no) VALUES(9,'DONALD',1);
INSERT INTO police(police_id,name,dept_no) VALUES(10,'NICK',1);
INSERT INTO police(police_id,name,dept_no) VALUES(11,'ALEX',1);
INSERT INTO police(police_id,name,dept_no) VALUES(12,'JOHNSON',2);
INSERT INTO police(police_id,name,dept_no) VALUES(13,'CHRISTOFER',2);
INSERT INTO police(police_id,name,dept_no) VALUES(14,'DAVID',2);
---------------------------------------------OFFICER---------------------------------------------------------------------------------------
INSERT INTO officer(police_id,head_officer_id,rank) VALUES (1,NULL,1);
INSERT INTO officer(police_id,head_officer_id,rank) VALUES (2,1,2);    
INSERT INTO officer(police_id,head_officer_id,rank) VALUES (5,1,2);  
INSERT INTO officer(police_id,head_officer_id,rank) VALUES (6,NULL,1); 
INSERT INTO officer(police_id,head_officer_id,rank) VALUES (7,6,2); 


INSERT INTO officer(police_id,head_officer_id,rank) VALUES (8,6,2);
INSERT INTO officer(police_id,head_officer_id,rank) VALUES (9,1,2);
INSERT INTO officer(police_id,head_officer_id,rank) VALUES (10,1,2);
INSERT INTO officer(police_id,head_officer_id,rank) VALUES (11,6,2);
---------------------------------------DETECTIVE---------------------------------------------------------------------------------------------
INSERT INTO detective(police_id,number_of_cases_solved) VALUES (3,0);
INSERT INTO detective(police_id) VALUES (4);

INSERT INTO detective(police_id) VALUES (12);
INSERT INTO detective(police_id) VALUES (13);
INSERT INTO detective(police_id) VALUES (14);
-----------------------------------------CRIME_REPORTER-------------------------------------------------------------------------------------------
INSERT INTO crime_reporter(reporter_id,reporter_name,address) VALUES (1,'RAVINDER','LS6 HYDE PARK');
INSERT INTO crime_reporter(reporter_id,reporter_name,address) VALUES (2,'SANAL','LS6 HEADINGLEY AVE');
INSERT INTO crime_reporter(reporter_id,reporter_name,address) VALUES (3,'VISHWANATH','ASHVILL TERRACE, LS6');
INSERT INTO crime_reporter(reporter_id,reporter_name,address) VALUES (4,'SANAL','LS6 HEADINGLY');
INSERT INTO crime_reporter(reporter_id,reporter_name,address) VALUES (5,'ALEX','W11 LONDON');
-----------------------------------------------PEOPLE_INVOLVED-------------------------------------------------------------------------------------
DROP SEQUENCE people_id;
CREATE SEQUENCE people_id
START WITH 1
INCREMENT BY 1;

INSERT INTO people_involved(person_id,address,gender,dob,name) VALUES (people_id.nextval,'20 BURLEY PARK','MALE','01-01-1986','AMIT');
INSERT INTO people_involved(person_id,address,gender,dob,name) VALUES (people_id.nextval,'5 HEADINGLY','MALE', '12-26-2000','AKASH');
INSERT INTO people_involved(person_id,address,gender,dob,name) VALUES (people_id.nextval,'Highgate,North London','FEMALE', '12-26-2016','JANE');



INSERT INTO people_involved(person_id,address,gender,dob,name) VALUES (people_id.nextval,'Wellfield Road','MALE','08-7-1991','Susan Thompson');
INSERT INTO people_involved(person_id,address,gender,dob,name) VALUES (people_id.nextval,'George Street','FEMALE','09-10-1995','Rebecca Morgan');
INSERT INTO people_involved(person_id,address,gender,dob,name) VALUES (people_id.nextval,'14 Tottenham Court Road','MALE','03-06-1995','Jason Miller');
INSERT INTO people_involved(person_id,address,gender,dob,name) VALUES (people_id.nextval,'Morningside Road Edinburgh','MALE','04-04-1998','Marc Melton');
INSERT INTO people_involved(person_id,address,gender,dob,name) VALUES (people_id.nextval,'91 Western Road Brighton','FEMALE','05-30-1983','Lisa Keyes');
INSERT INTO people_involved(person_id,address,gender,dob,name) VALUES (people_id.nextval,'27 Colmore Row Birmingham','MALE','08-18-1991','Simon Jones');
INSERT INTO people_involved(person_id,address,gender,dob,name) VALUES (people_id.nextval,'42  Park Row 42  Park Row','FEMALE','02-24-1986','Sarah Gregory');
INSERT INTO people_involved(person_id,address,gender,dob,name) VALUES (people_id.nextval,'Wellfield Road','MALE','03-29-1991','Steven Crisp');


INSERT INTO people_involved(person_id,address,gender,dob,name) VALUES (people_id.nextval,'CARDIGAN ROAD LEEDS','FEMALE','04/01/1955','Isabel H Wilkinson');
INSERT INTO people_involved(person_id,address,gender,dob,name) VALUES (people_id.nextval,'88  High Street ASHEN','FEMALE','5/2/1994','	Sophia N Fox');
INSERT INTO people_involved(person_id,address,gender,dob,name) VALUES (people_id.nextval,'39  Castledore Road TWIZELL HOUSE','MALE','4/3/1995','Aidan M McDonald');
INSERT INTO people_involved(person_id,address,gender,dob,name) VALUES (people_id.nextval,'32  Horsefair Green','MALE','3/8/1990','Isobel L Morton');
---------------------------------------SUSPECT---------------------------------------------------------------------------------------------
INSERT INTO suspect(person_id,previous_address) VALUES (1,'58  Hindhead Road EASINGTON COLLIERY');
INSERT INTO suspect(person_id) VALUES (2);
INSERT INTO suspect(person_id) VALUES (3);
INSERT INTO suspect(person_id) VALUES (4);
INSERT INTO suspect(person_id,previous_address) VALUES (5,'41 Jesmond Rd KILLIEHUNTLY');
----------------------------------VICTIM--------------------------------------------------------------------------------------------------
INSERT INTO VICTIM(person_id,relation_with_suspect,relation_with_witness) VALUES(6,'BROTHER','MOTHER');
INSERT INTO VICTIM(person_id) VALUES(7);
INSERT INTO VICTIM(person_id) VALUES(8);
INSERT INTO VICTIM(person_id) VALUES(9);
INSERT INTO VICTIM(person_id) VALUES(10);
------------------------------------WITNESS--------------------------------------------------------------------------------------
INSERT INTO witness(person_id,num_of_crimes_witnessed,any_crime_record) VALUES (11,0,'NO');
INSERT INTO witness(person_id,num_of_crimes_witnessed,any_crime_record) VALUES (12,0,'YES');
INSERT INTO witness(person_id,any_crime_record) VALUES (13,'NO');
INSERT INTO witness(person_id,any_crime_record) VALUES (14,'NO');
INSERT INTO witness(person_id,any_crime_record) VALUES (15,'NO');
---------------------------offence---------------------------------------------------------------------------------------------------
INSERT INTO offence(OFFENCE_ID, offence_kind, offence_numbers) VALUES (1,'DRUNK AND DRIVE',0);
INSERT INTO offence(OFFENCE_ID, offence_kind) VALUES (2,'Armed robbery');
INSERT INTO offence(OFFENCE_ID, offence_kind) VALUES (3,'Blackmail');
INSERT INTO offence(OFFENCE_ID, offence_kind) VALUES (4,'Forgery');
INSERT INTO offence(OFFENCE_ID, offence_kind) VALUES (5,'Kidnapping');
-------------------------------------16_OFFENCE_YEAR_LINK_ENTITY-----------------------------------------------------------------------------------------------
INSERT INTO offence_time_link_entity (fk1_OFFENCE_ID,fk2_finincial_year) VALUES (1,2015);
INSERT INTO offence_time_link_entity (fk1_OFFENCE_ID,fk2_finincial_year) VALUES (1,2016);
INSERT INTO offence_time_link_entity (fk1_OFFENCE_ID,fk2_finincial_year) VALUES (1,2017);
INSERT INTO offence_time_link_entity (fk1_OFFENCE_ID,fk2_finincial_year) VALUES (1,2018);
INSERT INTO offence_time_link_entity (fk1_OFFENCE_ID,fk2_finincial_year) VALUES (1,2019);
INSERT INTO offence_time_link_entity (fk1_OFFENCE_ID,fk2_finincial_year) VALUES (2,2015);
INSERT INTO offence_time_link_entity (fk1_OFFENCE_ID,fk2_finincial_year) VALUES (2,2016);
INSERT INTO offence_time_link_entity (fk1_OFFENCE_ID,fk2_finincial_year) VALUES (2,2017);
INSERT INTO offence_time_link_entity (fk1_OFFENCE_ID,fk2_finincial_year) VALUES (2,2018);
INSERT INTO offence_time_link_entity (fk1_OFFENCE_ID,fk2_finincial_year) VALUES (2,2019);
INSERT INTO offence_time_link_entity (fk1_OFFENCE_ID,fk2_finincial_year) VALUES (3,2015);
INSERT INTO offence_time_link_entity (fk1_OFFENCE_ID,fk2_finincial_year) VALUES (3,2016);
INSERT INTO offence_time_link_entity (fk1_OFFENCE_ID,fk2_finincial_year) VALUES (3,2017);
INSERT INTO offence_time_link_entity (fk1_OFFENCE_ID,fk2_finincial_year) VALUES (3,2018);
INSERT INTO offence_time_link_entity (fk1_OFFENCE_ID,fk2_finincial_year) VALUES (3,2019);
INSERT INTO offence_time_link_entity (fk1_OFFENCE_ID,fk2_finincial_year) VALUES (4,2015);
INSERT INTO offence_time_link_entity (fk1_OFFENCE_ID,fk2_finincial_year) VALUES (4,2016);
INSERT INTO offence_time_link_entity (fk1_OFFENCE_ID,fk2_finincial_year) VALUES (4,2017);
INSERT INTO offence_time_link_entity (fk1_OFFENCE_ID,fk2_finincial_year) VALUES (4,2018);
INSERT INTO offence_time_link_entity (fk1_OFFENCE_ID,fk2_finincial_year) VALUES (4,2019);
INSERT INTO offence_time_link_entity (fk1_OFFENCE_ID,fk2_finincial_year) VALUES (5,2015);
INSERT INTO offence_time_link_entity (fk1_OFFENCE_ID,fk2_finincial_year) VALUES (5,2016);
INSERT INTO offence_time_link_entity (fk1_OFFENCE_ID,fk2_finincial_year) VALUES (5,2017);
INSERT INTO offence_time_link_entity (fk1_OFFENCE_ID,fk2_finincial_year) VALUES (5,2018);
INSERT INTO offence_time_link_entity (fk1_OFFENCE_ID,fk2_finincial_year) VALUES (5,2019);
--------------------------------------17_CRIME_REGISTER-----------------------------------------------------------------------------
INSERT INTO CRIME_REGISTER(crime_id, reported_date, crime_status, officer_note, fk1_reporter_id, fk2_location_id, fk3_police_id) VALUES(1,'05-24-2015','CLOSED','reporter was bleeding and is taken to hospital immediately',1,1,2);

INSERT INTO CRIME_REGISTER(crime_id, reported_date, crime_status, fk1_reporter_id, fk2_location_id, fk3_police_id) VALUES(2,'11-02-2015','OPEN',2,1,5);
INSERT INTO CRIME_REGISTER(crime_id, reported_date, crime_status, fk1_reporter_id, fk2_location_id, fk3_police_id) VALUES(3,'01-15-2016','OPEN',3,2,7);
INSERT INTO CRIME_REGISTER(crime_id, reported_date, crime_status, fk1_reporter_id, fk2_location_id, fk3_police_id) VALUES(4,'10-29-2017','CLOSED',1,4,8);
INSERT INTO CRIME_REGISTER(crime_id, reported_date, crime_status, fk1_reporter_id, fk2_location_id, fk3_police_id) VALUES(5,'02-13-2019','OPEN',4,1,9);
INSERT INTO CRIME_REGISTER(crime_id, reported_date, crime_status, fk1_reporter_id, fk2_location_id, fk3_police_id) VALUES(6,'05-09-2019','CLOSED',5,2,2);

----------------------------------------18_CLOSED_CRIMES---------------------------------------------------------------------------
INSERT INTO crimes_closed(closed_crime_id, solved_date, detective_id, criminal_name) VALUES(1,'11-02-2019',3,'John');
INSERT INTO crimes_closed(closed_crime_id, solved_date, detective_id, criminal_name) VALUES(4,'08-22-2015',4,'JOHNSON');
INSERT INTO crimes_closed(closed_crime_id, solved_date, detective_id, criminal_name) VALUES(6,'12-18-2019',13,'DAVID');

-------------------------------------------19_OPEN_CRIMES-----------------------------------------------------------------------------------------
INSERT INTO crimes_open(open_crime_id, detective_id, recent_update) VALUES(2,3,'BIOMETRICS FOUND AT THE VICTIMS HOUSE');
INSERT INTO crimes_open(open_crime_id, detective_id) VALUES(3,13);
INSERT INTO crimes_open(open_crime_id, detective_id) VALUES(5,14);
-----------------------------------------20_CRIME_EVENTS-------------------------------------------------------------------------------------------
INSERT INTO crime_events(event_id, event_date, location_id, linked_crime_id, offence_id, evidence) VALUES(1,'1-5-2015',1,1,4,'BIOMETRICS');
INSERT INTO crime_events(event_id, event_date, location_id, linked_crime_id, offence_id, evidence) VALUES(2,'1-5-2015',1,1,2,'wepons');
INSERT INTO crime_events(event_id, event_date, location_id, linked_crime_id, offence_id, evidence) VALUES(3,'4-25-2016',2,2,1,'COUGHT IN RED HAND');
INSERT INTO crime_events(event_id, event_date, location_id, linked_crime_id, offence_id, evidence) VALUES(4,'1-5-2015',3,3,2,'CC_FOOTAGE');
INSERT INTO crime_events(event_id, event_date, location_id, linked_crime_id, offence_id, evidence) VALUES(5,'1-5-2015',4,3,5,'DNA');
INSERT INTO crime_events(event_id, event_date, location_id, linked_crime_id, offence_id, evidence) VALUES(6,'1-5-2015',5,2,2,'wepons');
INSERT INTO crime_events(event_id, event_date, location_id, linked_crime_id, offence_id, evidence) VALUES(7,'1-5-2015',6,4,3,'CC_FOOTAGE');
INSERT INTO crime_events(event_id, event_date, location_id, linked_crime_id, offence_id, evidence) VALUES(8,'1-5-2015',5,5,5,'CC_FOOTAGE');
INSERT INTO crime_events(event_id, event_date, location_id, linked_crime_id, offence_id, evidence) VALUES(9,'1-5-2015',7,4,2,'wepons');
INSERT INTO crime_events(event_id, event_date, location_id, linked_crime_id, offence_id, evidence) VALUES(10,'1-5-2015',9,5,2,'wepons');
----------------------------------------21_crime_events_suspect--------------------------------------------------------------------------------------------
INSERT INTO crime_events_suspect(s_event_id,d_person_id) VALUES (1,1);
INSERT INTO crime_events_suspect(s_event_id,d_person_id) VALUES (2,1);
INSERT INTO crime_events_suspect(s_event_id,d_person_id) VALUES (3,1);
INSERT INTO crime_events_suspect(s_event_id,d_person_id) VALUES (4,2);
INSERT INTO crime_events_suspect(s_event_id,d_person_id) VALUES (5,3);
INSERT INTO crime_events_suspect(s_event_id,d_person_id) VALUES (6,4);
INSERT INTO crime_events_suspect(s_event_id,d_person_id) VALUES (7,5);
INSERT INTO crime_events_suspect(s_event_id,d_person_id) VALUES (8,5);
INSERT INTO crime_events_suspect(s_event_id,d_person_id) VALUES (9,1);
INSERT INTO crime_events_suspect(s_event_id,d_person_id) VALUES (10,2);
-------------------------------------22_CRIME_EVENTS_VICTIM-----------------------------------------------------------------------------------------------
INSERT INTO crime_events_victim(s_event_id, d_person_id) VALUES (1,6);
INSERT INTO crime_events_victim(s_event_id, d_person_id) VALUES (2,6);
INSERT INTO crime_events_victim(s_event_id, d_person_id) VALUES (3,9);
INSERT INTO crime_events_victim(s_event_id, d_person_id) VALUES (4,7);
INSERT INTO crime_events_victim(s_event_id, d_person_id) VALUES (5,10);
INSERT INTO crime_events_victim(s_event_id, d_person_id) VALUES (6,6);
INSERT INTO crime_events_victim(s_event_id, d_person_id) VALUES (7,8);
INSERT INTO crime_events_victim(s_event_id, d_person_id) VALUES (8,7);
INSERT INTO crime_events_victim(s_event_id, d_person_id) VALUES (9,10);
INSERT INTO crime_events_victim(s_event_id, d_person_id) VALUES (10,9);

------------------------------------------------------------------------------------------------------------------------------------

