CREATE TABLE COMPANY(
    COMPANY_ID INTEGER PRIMARY KEY AUTOINCREMENT,
    NAME VARCHAR(30) NOT NULL,
    DESCRIPTION VARCHAR(60), 
    PRIMARY_CONTACT_ID INTEGER NOT NULL,
    FOREIGN KEY (PRIMARY_CONTACT_ID) REFERENCES ATTENDEE(ATTENDEE_ID)
);

CREATE TABLE PRESENTATION (
    PRESENTATION_ID INTEGER PRIMARY KEY AUTOINCREMENT,
    BOOKED_COMPANY_ID INTEGER NOT NULL,
    BOOKED_ROOM_ID INTEGER NOT NULL,
    START_TIME TIME,
    END_TIME TIME,
    FOREIGN KEY (BOOKED_COMPANY_ID) REFERENCES COMPANY(COMPANY_ID),
    FOREIGN KEY (BOOKED_ROOM_ID) REFERENCES ROOM(ROOM_ID)
);

CREATE TABLE ATTENDEE(
    ATTENDEE_ID INTEGER PRIMARY KEY AUTOINCREMENT,
    FIRST_NAME VARCHAR(30) NOT NULL,
    LAST_NAME VARCHAR(30), 
    PHONE INTEGER,
    EMAIL VARCHAR(30),
    VIP BOOLEAN DEFAULT(0)
);
--Any errors done during table or columns creation, can only be corrected by dropping the entire table.

CREATE TABLE PRESENTATION_ATTENDANCE(
    TICKET_ID INTEGER PRIMARY KEY AUTOINCREMENT,
    PRESENTATION_ID INTEGER,
    ATTENDEE_ID INTEGER,
    FOREIGN KEY (PRESENTATION_ID) REFERENCES PRESENTATION(PRESENTATION_ID),
    FOREIGN KEY (ATTENDEE_ID) REFERENCES ATTENDEE(ATTENDEE_ID)
);

CREATE VIEW PRESENTATION_VW AS

SELECT COMPANY.NAME AS BOOKED_COMPANY,
ROOM.ROOM_ID AS ROOM_NUM,
ROOM.FLOOR_NUMBER AS FLOOR,
ROOM.SEATING_CAPACITY AS SEATS,
START_TIME, END_TIME

FROM PRESENTATION

INNER JOIN COMPANY
ON PRESENTATION.BOOKED_COMPANY_ID = COMPANY.COMPNAY_ID

INNER JOIN ROOM
ON PRESENTATION.BOOKED_ROOM_ID = ROOM.ROOM_ID;

--CREATING  A VIEW

SELECT * FROM PRESENTATION_VW;

--INSERTING DATA

INSERT INTO ATTENDEE(first_name, last_name) VALUES ('jon', 'smith');

INSERT INTO ATTENDEE(first_name, last_name, phone, vip, email) VALUES ('jon', 'skitter', 130173047, 1, 'jo.skits@rexT.org'),
('Scarlet', 'isabelle', 10345701837, 1, 'simply.scarlet.BA.com'),
('He', 'man', 90923034237, 1, 'whoznext.co'),
('mr', 'han', 13412380, 0,'bonsai.han@gmail.com'); --Here, as VIP field is specified, explicit value mention is necessary.

--Insert can also be done via Select

INSERT INTO ATTENDEE(first_name, last_name, email, phone)
SELECT first_name, last_name, email, phone
FROM a_different_table;

--Testing foreign keys

INSERT INTO company(name, description, primary_contact_id)
VALUES('REXt', 'mobile app delivery service', 8);
--[20:11:25] Error while executing SQL query on database 'SargeTechConference': FOREIGN KEY constraint failed

INSERT INTO presentation(booked_company_id, booked_room_id)
VALUES (2, 3);
--[20:11:25] Error while executing SQL query on database 'SargeTechConference': FOREIGN KEY constraint failed

--DELETING DATA

DELETE FROM company;

DELETE FROM attendee
WHERE phone IS NULL;

--TRUNCATE is used in order db platforms, this commands also resets the autoincrements for any primary keys used.

--Updating records

UPDATE attendee SET email = UPPER(email);

UPDATE attendee SET first_name = UPPER(first_name), last_name = UPPER(last_name);

UPDATE attendee SET vip = 1 WHERE attendee_id = 5;

--To delete an entire table

DROP table a_table;