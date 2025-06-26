-- =======================================================================
-- FILE: employee_data_analysis.sql
-- AUTHOR: Juan Pablo Rivera Portilla
-- DESCRIPTION:
--   This script covers SQL exercises for data filtering, sorting, and scalar
--   functions in Oracle SQL. Organized by practice session, it includes data 
--   queries and formatting techniques for employee-related operations.
--   Exercises are grouped under two main categories:
--   1. Filtering and sorting records.
--   2. Row-level computations and formatting with scalar functions.
-- =======================================================================


-- =======================================================================
-- PRACTICE 2 – FILTERING AND SORTING DATA
-- =======================================================================

-- 1. Retrieve employees hired between June 10 and August 7, 2001.
--    Display their name, job title, and hire date, ordered by hire date.
SELECT Emp_Nombre, Emp_Cargo, Emp_FechaContrato
FROM Empleados
WHERE Emp_FechaContrato BETWEEN TO_DATE('2001-06-10', 'YYYY-MM-DD') AND TO_DATE('2001-08-07', 'YYYY-MM-DD')
ORDER BY Emp_FechaContrato ASC;


-- 2. Retrieve employees earning more than $1,200,000.
--    Also list employees whose salary is NOT between $1,000,000 and $2,000,000.
SELECT Emp_Nombre, Emp_Salario
FROM Empleados
WHERE Emp_Salario > 1200000;

-- Additional filter (not implemented): 
-- WHERE Emp_Salario NOT BETWEEN 1000000 AND 2000000;


-- 3. Repetition of Exercise 1 for emphasis.
SELECT Emp_Nombre, Emp_Cargo, Emp_FechaContrato
FROM Empleados
WHERE Emp_FechaContrato BETWEEN TO_DATE('2001-06-10','YYYY-MM-DD') AND TO_DATE('2001-08-07','YYYY-MM-DD')
ORDER BY Emp_FechaContrato ASC;


-- 4. List employee names and department numbers for departments 10 and 30,
--    sorted alphabetically by employee name.
SELECT Emp_Nombre, Dep_Id
FROM Empleados
WHERE Dep_Id IN (10, 30)
ORDER BY Emp_Nombre ASC;


-- 5. Display employees who receive commissions, showing name, salary,
--    and commission amount, ordered descending by salary and commission.
SELECT Emp_Nombre, Emp_Salario, Emp_Comision
FROM Empleados
WHERE Emp_Comision IS NOT NULL
ORDER BY Emp_Salario DESC, Emp_Comision DESC;


-- =======================================================================
-- PRACTICE 3 – SCALAR (SINGLE-ROW) FUNCTIONS
-- =======================================================================

-- 1. For each employee, display ID, name, salary, and salary increased by 20%,
--    rounded to the nearest 100,000. Also include the increment amount.
SELECT Emp_Id, Emp_Nombre, Emp_Salario, 
       ROUND(Emp_Salario * 1.2, -5) AS "Salario_Incrementado",
       ROUND(Emp_Salario * 0.2, -5) AS "Incremento"
FROM Empleados
ORDER BY Emp_Id;


-- 2. Show each employee's name and the number of months since they were hired.
--    Round the months worked to the nearest integer and sort by this column.
SELECT Emp_Nombre AS "Nombre", ROUND(MONTHS_BETWEEN(SYSDATE, Emp_FechaContrato)) AS "Meses_Trabajados"
FROM Empleados
ORDER BY ROUND(MONTHS_BETWEEN(SYSDATE, Emp_FechaContrato));


-- 3. Create a descriptive sentence for each employee's salary and their goal salary.
--    Format the output using string concatenation and currency formatting.
SELECT emp_nombre || ' gana ' || TO_CHAR(emp_salario, '999,999,999.99') || ' mensualmente, pero quiere ganar ' || 
TO_CHAR(emp_salario*3, '999,999,999.99') || ' en sueldo.' AS Descripcion, emp_salario*3 AS Sueldo_Deseado
FROM empleados;


-- 4. Display employee name, original hire date, and four variations of formatted
--    hire date using TO_CHAR with different format models.
SELECT emp_nombre, 
       emp_fechacontrato, 
       TO_CHAR(emp_fechacontrato, 'DD "de" fmMONTH"," fmYYYY') AS "DIA MES AÑO",
       TO_CHAR(emp_fechacontrato, 'DDsp "de" fmMONTH"," fmYYYY') AS "DIA EN TEXTO",
       TO_CHAR(emp_fechacontrato, 'DDth "de" fmMONTH"," fmYYYY') AS "ORDINAL DATE",
       TO_CHAR(emp_fechacontrato, 'DDspth "de" fmMONTH"," fmYYYY') AS "ORDINAL TEXT DATE"
FROM empleados;


-- 5. For each employee, display their hire date and the first Monday
--    after three months of service. Format the revised date appropriately.
SELECT emp_nombre, emp_fechacontrato, 
       TO_CHAR(NEXT_DAY(ADD_MONTHS(emp_fechacontrato, 3), 'MONDAY'), '"Lunes, el" Ddspth "de" Month, YYYY') AS Fecha_Revisada
FROM empleados;


-- 6. Use the CASE function to assign a grade based on employee job title.
--    Mapping:
--      PRESIDENTE → A
--      GERENTE    → B
--      ANALISTA   → C
--      VENDEDOR   → D
--      OFICINISTA → E
SELECT
  emp_cargo AS Emp_Cargo,
  CASE emp_cargo
    WHEN 'PRESIDENTE' THEN 'A'
    WHEN 'GERENTE' THEN 'B'
    WHEN 'ANALISTA' THEN 'C'
    WHEN 'VENDEDOR' THEN 'D'
    WHEN 'OFICINISTA' THEN 'E'
  END AS Grado
FROM empleados;

-- =======================================================================
-- END OF SCRIPT
-- =======================================================================
