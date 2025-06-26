-- =============================================
-- Author: Juan Pablo Rivera Portilla
-- Program: Systems Engineering
-- Subject: Databases II - Partial Exam
-- =============================================

-- =============================================
-- Procedure: sp_update
-- Purpose: Update or insert employee record, with user-defined exception handling
-- =============================================
CREATE OR REPLACE PROCEDURE sp_update 
(p_id IN empleados.emp_id%type, 
p_nombre IN empleados.emp_nombre%type, 
p_cargo IN empleados.emp_cargo%type, 
p_jefe IN empleados.emp_jefe%type,
p_fechacontrato IN empleados.emp_fechacontrato%type, 
p_salario IN empleados.emp_salario%type, 
p_comision IN empleados.emp_comision%type, 
p_dep_id IN empleados.dep_id%type)
IS
  v_is NUMBER;
BEGIN
  SELECT COUNT(*) INTO v_is FROM empleados WHERE emp_id = p_id;

  IF (v_is = 0) THEN
    INSERT INTO empleados 
    VALUES (p_id, p_nombre, p_cargo, p_jefe, p_fechacontrato, p_salario, p_comision, p_dep_id);
  ELSE
    UPDATE empleados 
    SET emp_nombre = p_nombre,
        emp_cargo = p_cargo,
        emp_jefe = p_jefe, 
        emp_fechacontrato = p_fechacontrato, 
        emp_salario = p_salario, 
        emp_comision = p_comision, 
        dep_id = p_dep_id
    WHERE emp_id = p_id;
  END IF;

EXCEPTION
  WHEN no_data_found THEN
    DBMS_OUTPUT.PUT_LINE('Employee does not exist.');
  WHEN others THEN
    DBMS_OUTPUT.PUT_LINE('The task could not be completed.');
END sp_update;

-- Execute procedure
EXECUTE sp_update(1000, 'CRISTIANO', 'VENDEDOR', 1000, '01-JAN-31', 1100000, 1800000, 30);


-- =============================================
-- Procedure: sp_listar_datos
-- Purpose: Return employee with highest salary in a given department
-- =============================================
CREATE OR REPLACE PROCEDURE sp_listar_datos
(p_nombre_empleado OUT empleados.emp_nombre%TYPE,
p_salario_empleado OUT empleados.emp_salario%TYPE,
p_nombre_departamento IN OUT departamentos.dep_nombre%TYPE)
IS
BEGIN
  SELECT e.emp_nombre, e.emp_salario, d.dep_nombre
  INTO p_nombre_empleado, p_salario_empleado, p_nombre_departamento
  FROM empleados e
  INNER JOIN departamentos d ON e.dep_id = d.dep_id
  WHERE d.dep_nombre = p_nombre_departamento
  AND e.emp_salario = (
    SELECT MAX(emp_salario)
    FROM empleados e
    INNER JOIN departamentos d ON e.dep_id = d.dep_id
    WHERE d.dep_nombre = p_nombre_departamento
  );
END sp_listar_datos;

-- Anonymous block to invoke procedure
ACCEPT depto PROMPT 'Enter department name:';
DECLARE
  v_name empleados.emp_nombre%TYPE;
  v_sal empleados.emp_salario%TYPE;
  v_depttt departamentos.dep_nombre%TYPE := UPPER('&depto');
BEGIN
  sp_listar_datos(v_name, v_sal, v_depttt);
  DBMS_OUTPUT.PUT_LINE('Employee: ' || v_name || ' Salary: '|| TO_CHAR(v_sal, '$999,999,999.99') || ' Department: ' || v_depttt);
EXCEPTION
  WHEN NO_DATA_FOUND THEN
    DBMS_OUTPUT.PUT_LINE('No such department or no employees found.');
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('Task could not be completed.');
END;


-- =============================================
-- Procedure: sp_sal_dept
-- Purpose: Find department with the highest total salary
-- =============================================
CREATE OR REPLACE PROCEDURE sp_sal_dept
(v_suma_sal OUT empleados.emp_salario%TYPE,
v_id_dep OUT empleados.dep_id%TYPE)
IS
BEGIN
  SELECT MAX(Salario), dep_id
  INTO v_suma_sal, v_id_dep
  FROM (
    SELECT SUM(emp_salario) AS Salario, dep_id 
    FROM empleados 
    GROUP BY dep_id
  )
  WHERE ROWNUM = 1;
END sp_sal_dept;

-- Anonymous block
DECLARE
  v_sum empleados.emp_salario%TYPE;
  v_did empleados.dep_id%TYPE;
BEGIN
  sp_sal_dept(v_sum, v_did);
  DBMS_OUTPUT.PUT_LINE('Department with highest total salary => ID: ' || v_did || ' SALARY: ' || TO_CHAR(v_sum, '$999,999,999.99'));
END;


-- =============================================
-- Table: MENSAJE
-- =============================================
DROP TABLE MENSAJE;
CREATE TABLE MENSAJE (
  id_men NUMBER NOT NULL,
  num_men NUMBER NOT NULL,
  CONSTRAINT PK_MENSAJE PRIMARY KEY (id_men)
);

-- =============================================
-- Procedure: SP_LOOP
-- Purpose: Insert using LOOP control structure
-- =============================================
CREATE OR REPLACE PROCEDURE SP_LOOP
IS
  V_i NUMBER := 1;
BEGIN
  LOOP
    IF V_i != 6 AND V_i != 8 THEN
      INSERT INTO MENSAJE (id_men, num_men) VALUES (V_i, V_i * 10);
      DBMS_OUTPUT.PUT_LINE('ID: ' || V_i || ' NUM: ' || (V_i * 10));
    END IF;
    V_i := V_i + 1;
    EXIT WHEN V_i > 10;
  END LOOP;
END;

EXECUTE SP_LOOP;

-- =============================================
-- Procedure: SP_WHILE
-- Purpose: Insert using WHILE control structure
-- =============================================
CREATE OR REPLACE PROCEDURE SP_WHILE
IS
  V_i NUMBER := 1;
BEGIN
  WHILE V_i <= 10 LOOP
    IF V_i != 6 AND V_i != 8 THEN
      INSERT INTO MENSAJE (id_men, num_men) VALUES (V_i, V_i * 10);
      DBMS_OUTPUT.PUT_LINE('ID: ' || V_i || ' NUM: ' || (V_i * 10));
    END IF;
    V_i := V_i + 1;
  END LOOP;
END;

EXECUTE SP_WHILE;

-- =============================================
-- Procedure: SP_FOR
-- Purpose: Insert using FOR control structure
-- =============================================
CREATE OR REPLACE PROCEDURE SP_FOR
IS
BEGIN
  FOR i IN 1..10 LOOP
    IF i != 6 AND i != 8 THEN
      INSERT INTO MENSAJE (id_men, num_men) VALUES (i, i * 10);
      DBMS_OUTPUT.PUT_LINE('ID: ' || i || ' NUM: ' || (i * 10));
    END IF;
  END LOOP;
END;

EXECUTE SP_FOR;

-- Anonymous block to choose and run the desired procedure
ACCEPT it NUMBER PROMPT 'Choose a number: 1.LOOP 2.WHILE 3.FOR';
DECLARE
BEGIN
  CASE &it
    WHEN 1 THEN SP_LOOP;
    WHEN 2 THEN SP_WHILE;
    WHEN 3 THEN SP_FOR;
  END CASE;
END;
