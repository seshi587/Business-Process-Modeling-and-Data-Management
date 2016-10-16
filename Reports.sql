--Report-team-2

-- The data entered as an input is the data that is entered by the employee while filling the reimbursement form
-- This query serves as a verification of this data with the data that is in the existing databases
-- This data would then be stored in the future_expense_calculator table upon the approval and proccessing of the claim form.
-- This will be used for estimating future capped amounts on the different types of expenses claimed by the employees.

-- An example of the data to be entered when prompted are below (remove the single quotes mentioned in the example values)
-- enter any amount when amount is prompted for flight, hotel, car-rental, food or misc.
-- enter flight_from as 'san francisco' and flight_to as 'denver' (You can only select the combinations that is there in the flight_expense table)
-- enter flight class as 'business' (another option is economy)
-- hotel checkout/checkin date should be entered in this format - 'dd-mon-yyyy' or 'dd/mon/yyyy'. Checkout date should be after check in date
-- enter any number for duration of car-rental, food or misc when prompted
-- enter manager last name as 'podder' and first name as 'rajit'
-- enter employee last name as 'albers' and first name as 'emily'. 
-- rajit podder is the manager of emily albers (enter other for mismatch), refer to kp_employees table for other employee manager relation
-- enter vendor name as 'thoughtworks' for correct vendor for emily albers or anything else for mismatch (refer to vendor table for other vendors)
-- enter fn101 for reimbursement form number (find others in the future_expense_calculator table)
-- to be exceeding limit for flights the amount entered should exceed the maximum value for the route and class selected (refer to flight_expense table for such routes)
-- to be exceeding limit for other expensees the amount entered/duration should exceed the values for that expense mentioned in the other_expense table

-- All amount values should be entered or else there would be an error. We are assuming a form cannot be submitted by an employee with empty amount fields. 
-- If a certain expense has not been incurred or a flight has not been taken, then '0' would be the default value for the amount that
-- will be compared to values stored in the database
SELECT REIMBURSE_FORM_NO,
CASE WHEN &FLIGHT_AMOUNT > (SELECT FLIGHT_MAX_COST FROM FLIGHT_EXPENSE WHERE FLIGHT_FROM = UPPER('&FLIGHT_FROM') AND 
FLIGHT_TO = UPPER('&FLIGHT_TO') AND FLIGHT_CLASS = UPPER('&FLIGHT_CLASS')) THEN 'LIMIT EXCEEDED' ELSE 'LIMIT NOT EXCEEDED' END FLIGHT_EXPENSE,
CASE WHEN &HOTEL_EXPENSE_AMOUNT > (SELECT EXPENSE_COST*((TO_DATE('&CHECKOUT_DATE_DD_mon_YYYY')) - (TO_DATE('&CHECKIN_DATE_DD_mon_YYYY'))) FROM OTHER_EXPENSE WHERE EXPENSE_TYPE = 'HOTEL') THEN 'LIMIT EXCEEDED' ELSE 'LIMIT NOT EXCEEDED' END HOTEL_EXPENSE,
CASE WHEN &CAR_RENTAL_AMOUNT > (SELECT EXPENSE_COST*(&CAR_RENTAL_DURATION) FROM OTHER_EXPENSE WHERE EXPENSE_TYPE = 'CAR_RENTAL') THEN 'LIMIT EXCEEDED' ELSE 'LIMIT NOT EXCEEDED' END CAR_RENTAL_EXPENSE,
CASE WHEN &FOOD_EXPENSE_AMOUNT > (SELECT EXPENSE_COST*(&FOOD_EXPENSE_DURATION) FROM OTHER_EXPENSE WHERE EXPENSE_TYPE = 'FOOD') THEN 'LIMIT EXCEEDED' ELSE 'LIMIT NOT EXCEEDED' END FOOD_EXPENSE,
CASE WHEN &MISC_EXPENSE_AMOUNT > (SELECT EXPENSE_COST*(&MISC_EXPENSE_DURATION) FROM OTHER_EXPENSE WHERE EXPENSE_TYPE = 'MISC')THEN 'LIMIT EXCEEDED' ELSE 'LIMIT NOT EXCEEDED' END MISC_EXPENSE,
CASE WHEN LOWER('&MANAGER_LAST_NAME') = LOWER((SELECT m.LAST_NAME FROM KP_EMPLOYEES e JOIN KP_EMPLOYEES m ON (e.MANAGER_ID = m.EMPLOYEE_ID) WHERE LOWER('&&EMPLOYEE_LAST_NAME') = LOWER(e.LAST_NAME) AND LOWER('&&EMPLOYEE_FIRST_NAME') = LOWER(e.FIRST_NAME)))
AND LOWER('&MANAGER_FIRST_NAME') = LOWER((SELECT m.FIRST_NAME FROM KP_EMPLOYEES e JOIN KP_EMPLOYEES m ON (e.MANAGER_ID = m.EMPLOYEE_ID) WHERE LOWER('&EMPLOYEE_LAST_NAME') = LOWER(e.LAST_NAME) AND LOWER('&EMPLOYEE_FIRST_NAME') = LOWER(e.FIRST_NAME)))
THEN 'CORRECT MANAGER' ELSE 'INCORRECT MANAGER' END MANAGER_MATCHED,
CASE WHEN LOWER('&VENDOR_NAME') = LOWER((SELECT n.VENDOR_NAME FROM KP_EMPLOYEES e JOIN VENDOR n ON (e.VENDOR_ID = n.VENDOR_ID) WHERE LOWER('&EMPLOYEE_LAST_NAME') = LOWER(e.LAST_NAME) AND LOWER('&EMPLOYEE_FIRST_NAME') = LOWER(e.FIRST_NAME)))
THEN 'CORRECT VENDOR' ELSE 'INCORRECT VENDOR' END VENDOR_MATCHED
FROM FUTURE_EXPENSE_CALCULATOR
WHERE REIMBURSE_FORM_NO = UPPER('&REIMBURSEMENT_FORM_NUMBER');

-- please run whole script always since undefine command is important as we are using && substitution variable
UNDEFINE EMPLOYEE_LAST_NAME;
UNDEFINE EMPLOYEE_FIRST_NAME;

-- This and similar queries are useful when estimating future capped limits for every type of expense since this would help to find 
-- the maximum, minimum, average and sum by grouping a certain kind of expense.
-- For example this query would help us determmine the maximum, minimum, average amount of the flight expense that is claimed by employees 
-- when taking a particular route on a particular flight class.

-- Because of limited data that we could store in our table, the following values would help in a group by clause
-- enter flight_from as 'san francisco' and flight_to as 'denver'. We have put 4 employees taking this flight route.
-- check future_expense_calculator table for other routes taken by employees
SELECT FLIGHT_CLASS, ROUND(MAX(FLIGHT_EXPENSE_AMOUNT)) MAX_FLIGHT_EXPENSE, ROUND(MIN(FLIGHT_EXPENSE_AMOUNT)) MIN_FLIGHT_EXPENSE, ROUND(AVG(FLIGHT_EXPENSE_AMOUNT)) AVG_FLIGHT_EXPENSE, 
ROUND(SUM(FLIGHT_EXPENSE_AMOUNT)) SUM_FLIGHT_EXPENSE FROM FUTURE_EXPENSE_CALCULATOR 
WHERE LOWER(FLIGHT_FROM) = LOWER('&FLIGHT_FROM') AND LOWER(FLIGHT_TO) =  LOWER('&FLIGHT_TO') GROUP BY FLIGHT_CLASS;  
