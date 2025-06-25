-- @Author: Juan Pablo Rivera Portilla

-- Exercise 1: Prompt the user to enter their name. Then, within an anonymous block, print: My name is ____.
SET SERVEROUTPUT ON;
SET VERIFY OFF;
DECLARE
BEGIN
  DBMS_OUTPUT.PUT_LINE('My name is ' || '&name');
END;
/


-- Exercise 2: (WITHOUT ANONYMOUS BLOCK). Select the employee ID, name, salary, and the department name where they work, for employees with the job title 'GERENTE'.
SELECT e.emp_id, e.emp_name, e.emp_salary, d.dep_name 
FROM employees e 
INNER JOIN departments d ON e.dep_id = d.dep_id
WHERE e.emp_title = 'GERENTE'
ORDER BY e.emp_name;


-- Exercise 3: Use a substitution variable. Through an anonymous block, select the employee ID, name, salary, and department name for employees with the job title 'PRESIDENTE'. Format the salary in currency format.
SET SERVEROUTPUT ON;
SET VERIFY OFF;
DECLARE
    v_emp_id employees.emp_id%TYPE;
    v_emp_name employees.emp_name%TYPE;
    v_emp_salary employees.emp_salary%TYPE;
    v_dep_name departments.dep_name%TYPE;
BEGIN
    SELECT e.emp_id, e.emp_name, e.emp_salary, d.dep_name
    INTO v_emp_id, v_emp_name, v_emp_salary, v_dep_name
    FROM employees e 
    INNER JOIN departments d ON e.dep_id = d.dep_id
    WHERE e.emp_title = 'PRESIDENTE';

    DBMS_OUTPUT.PUT_LINE('Employee with ID ' || v_emp_id || ' named ' || v_emp_name || ' has a salary of ' || TO_CHAR(v_emp_salary, '$999,999,999.99') || ' and belongs to the department ' || v_dep_name);
END;
/


-- Exercise 4: Use a substitution variable. Through an anonymous block, select the employee ID, name, salary, and department name where the job title is 'GERENTE'.
-- Note: This causes an error if multiple rows are returned because SELECT INTO expects exactly one row.
SET SERVEROUTPUT ON;
SET VERIFY OFF;
DECLARE
    v_emp_id employees.emp_id%TYPE;
    v_emp_name employees.emp_name%TYPE;
    v_emp_salary employees.emp_salary%TYPE;
    v_dep_name departments.dep_name%TYPE;
BEGIN
    SELECT e.emp_id, e.emp_name, e.emp_salary, d.dep_name
    INTO v_emp_id, v_emp_name, v_emp_salary, v_dep_name
    FROM employees e 
    INNER JOIN departments d ON e.dep_id = d.dep_id
    WHERE e.emp_title = 'GERENTE';
END;
/

-- Explanation:
-- 1. The anonymous block fails because it returns multiple rows while SELECT INTO expects a single result.
-- 2. This issue can be resolved using a cursor.

-- Exercise 5: Use a substitution variable. Create an anonymous block that prints: "Employee X has Y as their boss".
-- The employee ID will be prompted via substitution. X and Y will display the names.
SET SERVEROUTPUT ON;
SET VERIFY OFF;
DECLARE
    v_employee employees.emp_name%TYPE;
    v_boss employees.emp_name%TYPE;
BEGIN
    SELECT emp_name INTO v_boss FROM employees WHERE emp_boss IS NULL;
    SELECT emp_name INTO v_employee FROM employees WHERE emp_id = &id;
    DBMS_OUTPUT.PUT_LINE('Employee ' || v_employee || ' has ' || v_boss || ' as their boss');
END;
/


-- Exercise 6: Prompt the user to enter a name via a substitution variable.
-- In an anonymous block, assign the value to a global variable and print both values.
SET SERVEROUTPUT ON;
SET VERIFY OFF;
ACCEPT name CHAR PROMPT 'Enter a person''s name: ';
DECLARE
    g_globalName VARCHAR2(30) := '&name';
BEGIN
    DBMS_OUTPUT.PUT_LINE('Substitution variable: ' || '&&name' || '    Global variable: ' || g_globalName);
END;
/


-- Exercise 7: (WITH and WITHOUT ANONYMOUS BLOCK). Select employee name, title, salary, and a 10% increase in salary.
-- The salary column name is to be reused. Sort by the increase in descending order. Use substitution variables.

-- Without anonymous block:
SELECT e.emp_name, e.emp_title, 
       TO_CHAR(e.emp_salary, '$999,999,999.99') AS "Salary", 
       TO_CHAR(e.emp_salary * 1.1, '$999,999,999.99') AS "Increase" 
FROM employees e
ORDER BY "Increase" DESC;


-- With anonymous block using cursor (to handle multiple rows):
SET SERVEROUTPUT ON;
SET VERIFY OFF;
DECLARE
    CURSOR emp_cursor IS
        SELECT emp_name, emp_title, emp_salary FROM employees;
    v_name employees.emp_name%TYPE;
    v_title employees.emp_title%TYPE;
    v_salary employees.emp_salary%TYPE;
    v_increase NUMBER;
BEGIN
    FOR rec IN emp_cursor LOOP
        v_name := rec.emp_name;
        v_title := rec.emp_title;
        v_salary := rec.emp_salary;
        v_increase := v_salary * 1.1;
        DBMS_OUTPUT.PUT_LINE('Employee: ' || v_name || ', Title: ' || v_title ||
                             ', Salary: ' || TO_CHAR(v_salary, '$999,999,999.99') ||
                             ', Increased Salary: ' || TO_CHAR(v_increase, '$999,999,999.99'));
    END LOOP;
END;
/
