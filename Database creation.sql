-- Table-team-2

-- creating a table for the location of the employees
CREATE TABLE KP_LOCATION
(LOCATION_ID NUMBER(10) CONSTRAINT LOCATION_ID_PK PRIMARY KEY,
CITY VARCHAR2(30) CONSTRAINT CITY_LOCATION NOT NULL);

-- table for vendor of employees who are contractors
CREATE TABLE VENDOR
(VENDOR_ID  NUMBER(10) CONSTRAINT VENDOR_ID_PK PRIMARY KEY,
VENDOR_NAME VARCHAR2(25) CONSTRAINT MANE_VENDOR NOT NULL);

-- Creating employees table for the employees
CREATE TABLE KP_EMPLOYEES
(EMPLOYEE_ID NUMBER(10) CONSTRAINT EMP_EMPLOYEES_ID_PK PRIMARY KEY,
FIRST_NAME VARCHAR2(20) CONSTRAINT FN_EMPLOYEES NOT NULL,
MIDDLE_NAME VARCHAR2(20),
LAST_NAME VARCHAR2(20) CONSTRAINT LN_EMPLOYEES NOT NULL,
EMAIL VARCHAR2(50) CONSTRAINT EMAIL_EMPLOYEES NOT NULL CONSTRAINT EMAIL_UN_EMPLOYEES UNIQUE,
CONTACT VARCHAR2(16),
ADDRESS_LINE_1 VARCHAR2(50),
ADDRESS_LINE_2 VARCHAR2(50),
CITY VARCHAR2(30),
ST VARCHAR2(20),
ZIP VARCHAR2 (20),
REIMBURSEMENT_MODE VARCHAR2(15) CONSTRAINT RM_EMPLOYEES NOT NULL,
VENDOR_ID NUMBER(10) CONSTRAINT VENDOR_ID_EMPLOYEES_FK REFERENCES VENDOR(VENDOR_ID),
LOCATION_ID NUMBER(10) CONSTRAINT LOCATION_ID_EMPLOYEES_FK NOT NULL REFERENCES KP_LOCATION(LOCATION_ID),
MANAGER_ID NUMBER(10) CONSTRAINT MANAGER_ID_EMPLOYEES_FK REFERENCES KP_EMPLOYEES(EMPLOYEE_ID));

-- table to capture many to many relationship between vendor and location
-- it is assumed that every location of employee, manager or vendor must be at any of the brances of the company
-- the location of vendor is where the contractor is working. So based on the employee's location the possible vendors in the will be displayed in the drop down
-- the location of the manager can be different from the employee. Based on the location of manager selected by the employee, possible manager names will be displayed
CREATE TABLE VENDOR_LOCATION
(VENDOR_ID NUMBER(10) CONSTRAINT VENDOR_ID_FK REFERENCES VENDOR(VENDOR_ID),
LOCATION_ID NUMBER(10) CONSTRAINT LOCATION_ID_FK REFERENCES KP_LOCATION(LOCATION_ID),
PRIMARY KEY(VENDOR_ID, LOCATION_ID));

-- A list of minimum and maximum amount of possible combinations of flight routes and flight class are listed on this table.
-- queries can be written to see whether an employee has exceeded the maximum cost of flights estimated for a particular route and class type.
CREATE TABLE FLIGHT_EXPENSE
(FLIGHT_ID NUMBER(10) CONSTRAINT FLGHT_EXP_PK PRIMARY KEY,
FLIGHT_CLASS VARCHAR2(15) CONSTRAINT FLGHT_CLS NOT NULL,
FLIGHT_FROM VARCHAR2(25) CONSTRAINT FLGHT_FRM NOT NULL,
FLIGHT_TO VARCHAR2(25) CONSTRAINT FLGHT_TO NOT NULL,
FLIGHT_MIN_COST NUMBER(8,2) CONSTRAINT FLGHT_MIN_COST NOT NULL,
FLIGHT_MAX_COST NUMBER(8,2) CONSTRAINT FLGHT_MAX_COST NOT NULL);

-- A capped amount of four different expense types are listed on this table (hotel, car-rental, food and miscellaneous expenses)
-- queries can be written to see whether an employee has exceeded the amount imit estimated for a particular type of expense.
CREATE TABLE OTHER_EXPENSE
(EXPENSE_TYPE VARCHAR2(25) CONSTRAINT EXPNSE_TYPE_PK PRIMARY KEY,
EXPENSE_COST NUMBER(8,2) CONSTRAINT EXPNSE_COST NOT NULL);

-- This table captures all expense types that have been approved. 
-- This table can be used in the future to estimate capped limits for every type of expense.
CREATE TABLE FUTURE_EXPENSE_CALCULATOR
(REIMBURSE_FORM_NO VARCHAR2(20) CONSTRAINT RMBRSE_FORM_NO_PK PRIMARY KEY,
HOTEL_AMOUNT NUMBER(8,2),
HOTEL_CHECKIN DATE,
HOTEL_CHECKOUT DATE,
FOOD_AMOUNT NUMBER(6,2),
FOOD_DURATION NUMBER(2),
CAR_RENT_EXPENSE NUMBER (6,2),
CAR_RENT_DURATION NUMBER (2),
MISC_EXPENSE_AMOUNT NUMBER(6,2),
MISC_EXPENSE_DURATION NUMBER(2),
FLIGHT_EXPENSE_AMOUNT NUMBER (8,2),
FLIGHT_FROM VARCHAR2(25),
FLIGHT_TO VARCHAR2(25),
FLIGHT_CLASS VARCHAR2(20),
EMPLOYEE_ID NUMBER(25));


------------------------------------------------------------------------------------------------------------------------------

-- creates a location table with six different location. 
--The company only has employees working and vendors contracting employees in these locations only
INSERT INTO KP_LOCATION VALUES(201, 'Pleasanton'); 
INSERT INTO KP_LOCATION VALUES(202, 'San Francisco');
INSERT INTO KP_LOCATION VALUES(203, 'San Jose');
INSERT INTO KP_LOCATION VALUES(204, 'Denver');
INSERT INTO KP_LOCATION VALUES(205, 'Portland');
INSERT INTO KP_LOCATION VALUES(206, 'Atlanta');

-- the vendor table has 4 vendors. They provide contractors in six different locations in the location table
INSERT INTO VENDOR VALUES(301, 'Prokarma');
INSERT INTO VENDOR VALUES(302, 'ThoughtWorks');
INSERT INTO VENDOR VALUES(303, 'Cognizant');
INSERT INTO VENDOR VALUES(304, 'Perficient');

-- The employee table has 9 employees. they have the following attributes stored
--employeeId, firstname, middlename, lastname, email, phone, address(all variables), paymentMode, vendorId, locationId, managerId
INSERT INTO KP_EMPLOYEES VALUES(100, 'Ashish', 'Kumar', 'Gupta', 'ashish.gupta@kp.org', '8604358275', '250 main apartments', 'apartment 303', 'pleasanton', 'california', '94566', 'check', null, 201, null);
INSERT INTO KP_EMPLOYEES VALUES(101, 'Rajit', 'Neev', 'Podder', 'rajit.podder@kp.org', '9728385260', '100 oakwood avenue', null, 'pleasanton', 'california', '94566', 'check', null, 201, null);
INSERT INTO KP_EMPLOYEES VALUES(102, 'Sydney', 'M', 'Stewart', 'sydney.stewart@kp.org', '4065497852', '105 grant chamberlain drive', 'apt - 3H', 'denver', 'colorado', '80123', 'paycheck', 301, 204, 100);
INSERT INTO KP_EMPLOYEES VALUES(103, 'Kajori', 'N', 'Banerjee', 'kajori.banerjee@kp.org', '9725487653', '216 S Rusell street', null, 'atlanta', 'georgia', '30301', 'check', null, 206, null);
INSERT INTO KP_EMPLOYEES VALUES(104, 'Emily', 'M', 'Albers', 'emily.albers@kp.org', '6726749007', '3533 vineyard avenue', null, 'pleasanton', 'california', '94566', 'check', 302, 201, 101);
INSERT INTO KP_EMPLOYEES VALUES(105, 'Tina', 'S', 'Chatterjee', 'tina.chattterjee@kp.org', '6589540091', '2439 monroe chase court', null, 'san jose', 'california', '95101', 'paycheck', null, 203, null);
INSERT INTO KP_EMPLOYEES VALUES(106, 'Emily', 'T', 'Wilkinson', 'emily.wilkinson@kp.org', '7328794431', '13 Rchardson Street', 'apt - 202', 'san francisco', 'california', '94102', 'check', 304, 202, 101);
INSERT INTO KP_EMPLOYEES VALUES(107, 'Megan', 'R', 'Iams', 'megan.iams@kp.org', '2025078225', '3276 falcon avenue', null, 'portland', 'oregon', '97213', 'paycheck', 303, 205, null);
INSERT INTO KP_EMPLOYEES VALUES(108, 'Marta', 'P', 'Bugowska', 'marta.bugowska@kp.org', '5659004211', '201 picasso street', null, 'san francisco', 'california', '94102', 'check', 303, 202, null);


-- Flight expense table has only five different options for flights routes and flight class 
-- We have assumed that the source and destination of the flights would be anyone that is already present in the database.
-- A query can be run to check if the flight route and class type entered by the employee has exceeded the maximum amount capped from the same flight details.
INSERT INTO FLIGHT_EXPENSE VALUES(1001, 'BUSINESS', 'SAN FRANCISCO', 'DENVER', 1000, 5000);
INSERT INTO FLIGHT_EXPENSE VALUES(1002, 'BUSINESS', 'SAN JOSE', 'PORTLAND', 1500, 6000);
INSERT INTO FLIGHT_EXPENSE VALUES(1003, 'BUSINESS', 'SAN FRANCISCO', 'ATLANTA', 2000, 7500);
INSERT INTO FLIGHT_EXPENSE VALUES(1004, 'ECONOMY', 'SAN FRANCISCO', 'SAN JOSE', 150, 500);
INSERT INTO FLIGHT_EXPENSE VALUES(1005, 'ECONOMY', 'PLEASANTON', 'DENVER', 400, 1000);

-- the other expense table shows all the four 'other' expense types and the maximum value capped PER DAY for each expense type 
-- A query can be run to check if the limit for any expense type is exceeded by the expenses on these types claimed by the employee
INSERT INTO OTHER_EXPENSE VALUES('HOTEL', 250);
INSERT INTO OTHER_EXPENSE VALUES('CAR_RENTAL', 200);
INSERT INTO OTHER_EXPENSE VALUES('FOOD', 100);
INSERT INTO OTHER_EXPENSE VALUES('MISC', 100);

-- The future expense calculator table has 9 rows of data which shows a variety of amounts, flight routes, hotel dates and duration depending on the type of expense
-- Only hotel date is entered in date format. The other durations are entered in just numbers to avoid complexity while prompting user for inputs.
-- the employee Id is also stored in this table in order to capture information on how much expenses and how many trips an employee has covered.
-- The main purpose of this table is to identify the mimimum, maximum and average costs incurred for every kind of expense for future estimations
-- This would enable to set capped limits for specific kind of expenses which would take inflation into consideration too
INSERT INTO FUTURE_EXPENSE_CALCULATOR VALUES('FN100', 800, '10-may-2016', '14-may-2016', 300, 3, 200, 1, 50, 3, 1200, 'SAN FRANCISCO', 'DENVER', 'BUSINESS', 101);
INSERT INTO FUTURE_EXPENSE_CALCULATOR VALUES('FN101', 1500, '15-may-2016', '18-may-2016', 1000, 5, 750, 3, 300, 5, 5000, 'SAN JOSE', 'PORTLAND', 'BUSINESS', 100);
INSERT INTO FUTURE_EXPENSE_CALCULATOR VALUES('FN102', 400, '21-jan-2016', '23-jan-2016', 300, 4, 300, 4, 2000, 4, 5500, 'SAN FRANCISCO', 'ATLANTA', 'BUSINESS', 104);
INSERT INTO FUTURE_EXPENSE_CALCULATOR VALUES('FN103', 600, '17-feb-2016', '14-feb-2016', 200, 3, 100, 3, 0, 3, 400, 'SAN FRANCISCO', 'SAN JOSE', 'ECONOMY', 108);
INSERT INTO FUTURE_EXPENSE_CALCULATOR VALUES('FN109', 900, '05-dec-2015', '11-dec-2015', 340, 6, 400, 6, 0, 6, 550, 'SAN FRANCISCO', 'DENVER', 'ECONOMY', 105);
INSERT INTO FUTURE_EXPENSE_CALCULATOR VALUES('FN105', 500, '17-aug-2014', '21-aug-2014', 150, 4, 300, 4, 150, 4, 450, 'SAN FRANCISCO', 'DENVER', 'ECONOMY', 100);
INSERT INTO FUTURE_EXPENSE_CALCULATOR VALUES('FN106', 550, '29-july-2014', '03-aug-2014', 350, 5, 200, 5, 100, 5, 350, 'SAN FRANCISCO', 'DENVER', 'ECONOMY', 101);
INSERT INTO FUTURE_EXPENSE_CALCULATOR VALUES('FN107', 470, '14-mar-2016', '19-mar-2016', 300, 4, 200, 4, 175, 4, 1200, 'PLEASANTON', 'DENVER', 'BUSINESS', 100);
INSERT INTO FUTURE_EXPENSE_CALCULATOR VALUES('FN104', 1200, '02-oct-2015', '07-oct-2015', 500, 2, 1000, 2, 250, 2, 0, null, null, 'ECONOMY', 104);
INSERT INTO FUTURE_EXPENSE_CALCULATOR VALUES('FN108', 400, '03-sep-2014', '11-sep-2014', 150, 2, 100, 2, 50, 2, 1400, 'SAN FRANCISCO', 'DENVER', 'BUSINESS', 105);
--------------------------------------------------------
