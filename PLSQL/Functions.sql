-- ==========================================================
-- FILE: salary_department_analysis.sql
-- AUTHOR: Juan Pablo Portilla
-- DESCRIPTION:
--   This script includes several stored PL/SQL functions and procedures
--   for analyzing employee salaries and departmental statistics in an Oracle database.
-- ==========================================================

-- ==========================================================
-- FUNCTION: SALARIO_PROMEDIO
-- DESCRIPTION:
--   Compares the average salary between two departments.
--   Receives two department IDs and returns whether
--   department A "supera" (exceeds) or "no supera" department B.
--   Also returns the computed average salaries as OUT parameters.
-- ==========================================================

CREATE OR REPLACE FUNCTION salario_promedio(
  p_idA IN NUMBER, 
  p_idB IN NUMBER, 
  p_salarioA OUT NUMBER, 
  p_salarioB OUT NUMBER
) RETURN VARCHAR2 IS
BEGIN
  SELECT ROUND(AVG(emp_salario)) INTO p_salarioA 
  FROM empleados WHERE dep_id = p_idA;

  SELECT ROUND(AVG(emp_salario)) INTO p_salarioB 
  FROM empleados WHERE dep_id = p_idB;

  IF p_salarioA > p_salarioB THEN
    RETURN 'supera';
  ELSE
    RETURN 'no supera';
  END IF;
END salario_promedio;
/

-- ==========================================================
-- ANONYMOUS BLOCK: EXECUTE SALARIO_PROMEDIO FUNCTION
-- ==========================================================
SET SERVEROUTPUT ON
SET VERIFY OFF
ACCEPT idA NUMBER PROMPT 'Department ID A: '
ACCEPT idB NUMBER PROMPT 'Department ID B: '
DECLARE
  v_result VARCHAR2(50);
  v_salarioA NUMBER;
  v_salarioB NUMBER;
BEGIN
  v_result := salario_promedio(&idA, &idB, v_salarioA, v_salarioB);
  DBMS_OUTPUT.PUT_LINE('The average salary ' || v_salarioA || ' of department ' || &idA || ' ' || v_result ||
                       ' the average salary ' || v_salarioB || ' of department ' || &idB || '.');
EXCEPTION
  WHEN NO_DATA_FOUND THEN
    DBMS_OUTPUT.PUT_LINE('Departments not found.');
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('An error occurred. Contact administration.');
END;
/

-- ==========================================================
-- PROCEDURE: MENOR_SALARIO
-- DESCRIPTION:
--   Retrieves the employee with the lowest salary from a specified department.
--   Takes department name as IN OUT parameter and returns employee name and salary.
-- ==========================================================

CREATE OR REPLACE PROCEDURE menor_salario(
  p_nombre OUT VARCHAR2, 
  p_salario OUT NUMBER, 
  p_nomDep IN OUT VARCHAR2
) IS
BEGIN
  SELECT e.emp_nombre, e.emp_salario, d.dep_nombre
  INTO p_nombre, p_salario, p_nomDep
  FROM empleados e
  INNER JOIN departamentos d ON e.dep_id = d.dep_id
  WHERE d.dep_nombre = p_nomDep
    AND e.emp_salario = (
      SELECT MIN(e.emp_salario)
      FROM empleados e
      INNER JOIN departamentos d ON e.dep_id = d.dep_id
      WHERE d.dep_nombre = p_nomDep);
END menor_salario;
/

-- ==========================================================
-- ANONYMOUS BLOCK: EXECUTE MENOR_SALARIO PROCEDURE
-- ==========================================================
SET SERVEROUTPUT ON
SET VERIFY OFF
ACCEPT nomDep PROMPT 'Enter department name: '
DECLARE
  v_nombre VARCHAR2(50);
  v_salario NUMBER;
  v_nomDep VARCHAR2(50) := '&nomDep';
BEGIN
  menor_salario(v_nombre, v_salario, v_nomDep);
  DBMS_OUTPUT.PUT_LINE('Employee ' || v_nombre || ' has the lowest salary of ' || TO_CHAR(v_salario, '$999,999,999.99') ||
                       ' in department ' || v_nomDep);
EXCEPTION
  WHEN NO_DATA_FOUND THEN
    DBMS_OUTPUT.PUT_LINE('Department not found.');
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('An error occurred. Contact administration.');
END;
/

-- ==========================================================
-- PROCEDURE: INFORMACION_DEPARTAMENTO
-- DESCRIPTION:
--   Retrieves the department ID with the highest total salary sum
--   and returns both the ID and total salary.
-- ==========================================================

CREATE OR REPLACE PROCEDURE Informacion_departamento(
  p_id OUT NUMBER, 
  p_salarios OUT NUMBER
) IS
BEGIN
  SELECT dep_id, MAX(Salario) AS Salario
  INTO p_id, p_salarios
  FROM (
    SELECT SUM(emp_salario) AS Salario, dep_id
    FROM empleados
    GROUP BY dep_id)
  WHERE ROWNUM = 1
  GROUP BY dep_id;
EXCEPTION
  WHEN NO_DATA_FOUND THEN
    DBMS_OUTPUT.PUT_LINE('No departments found.');
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('An error occurred. Contact administration.');
END Informacion_departamento;
/

-- ==========================================================
-- ANONYMOUS BLOCK: EXECUTE INFORMACION_DEPARTAMENTO PROCEDURE
-- ==========================================================
SET SERVEROUTPUT ON
DECLARE
  v_id NUMBER;
  v_salarios NUMBER;
BEGIN
  Informacion_departamento(v_id, v_salarios);
  DBMS_OUTPUT.PUT_LINE('Department ' || v_id || ' has the highest total salary: ' || TO_CHAR(v_salarios, '$999,999,999.99'));
EXCEPTION
  WHEN NO_DATA_FOUND THEN
    DBMS_OUTPUT.PUT_LINE('No departments found.');
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('An error occurred. Contact administration.');
END;
/
