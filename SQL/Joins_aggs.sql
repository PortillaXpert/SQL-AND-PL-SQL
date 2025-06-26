-- =============================================================
-- FILE: multi_table_joins_and_aggregates.sql
-- AUTHOR: Juan Pablo Rivera Portilla
-- DESCRIPTION:
--   SQL practice including JOIN operations, aggregation, grouping,
--   and subqueries. Well-structured examples demonstrate common
--   business queries, written in clean SQL for reuse and clarity.
-- =============================================================

-- =============================================================
-- PRACTICE 4: Retrieving Data from Multiple Tables Using JOIN
-- =============================================================

-- 1. Unique list of job titles in department 30 with department location
SELECT DISTINCT e.Emp_Cargo, d.Dep_Localizacion
FROM Empleados e
JOIN Departamentos d ON e.Dep_Id = d.Dep_Id
WHERE e.Dep_Id = 30;

-- 2. Employee and their manager info
SELECT e.Emp_Nombre AS Empleado, e.Emp_Id AS "Emp#",
       j.Emp_Nombre AS Jefe, e.Emp_Jefe AS "Jefe#"
FROM Empleados e
JOIN Empleados j ON e.Emp_Jefe = j.Emp_Id;

-- 3. Same as above, but includes President with no manager
SELECT e.Emp_Nombre AS Empleado, e.Emp_Id AS "Emp#",
       COALESCE(j.Emp_Nombre, '---') AS Jefe, e.Emp_Jefe AS "Jefe#"
FROM Empleados e
LEFT JOIN Empleados j ON e.Emp_Jefe = j.Emp_Id
ORDER BY e.Emp_Id;

-- 4. Employees hired after SANCHEZ
-- Oracle syntax
SELECT e.Emp_Nombre, e.Emp_FechaContrato
FROM Empleados e
JOIN Empleados s ON e.Emp_FechaContrato > s.Emp_FechaContrato
WHERE s.Emp_Nombre = 'SANCHEZ'
ORDER BY e.Emp_FechaContrato;

-- SQL-1999 syntax
SELECT e.Emp_Nombre, e.Emp_FechaContrato
FROM Empleados e
JOIN Empleados s ON s.Emp_Nombre = 'SANCHEZ'
WHERE e.Emp_FechaContrato > s.Emp_FechaContrato
ORDER BY e.Emp_FechaContrato;

-- 5. Employees hired before their managers
-- Oracle syntax
SELECT e.Emp_Nombre AS "Empleado", e.Emp_FechaContrato AS "Fecha de contrato Empleado",
       j.Emp_Nombre AS "Jefe", j.Emp_FechaContrato AS "Fecha de contrato Jefe"
FROM Empleados e
JOIN Empleados j ON e.Emp_Jefe = j.Emp_Id
WHERE e.Emp_FechaContrato < j.Emp_FechaContrato;

-- SQL-1999 syntax (same)
SELECT e.Emp_Nombre AS Empleado, e.Emp_FechaContrato AS "Fecha de contrato Empleado",
       j.Emp_Nombre AS Jefe, j.Emp_FechaContrato AS "Fecha de contrato Jefe"
FROM Empleados e
JOIN Empleados j ON e.Emp_Jefe = j.Emp_Id
WHERE e.Emp_FechaContrato < j.Emp_FechaContrato;


-- =============================================================
-- PRACTICE 5: Aggregating Data Using Group Functions
-- =============================================================

-- 1. Salary stats across all employees
SELECT ROUND(MAX(Emp_Salario)) AS Maximo,
       ROUND(MIN(Emp_Salario)) AS Minimo,
       ROUND(SUM(Emp_Salario)) AS Suma,
       ROUND(AVG(Emp_Salario)) AS Promedio
FROM Empleados;

-- 2. Same stats grouped by job title
SELECT Emp_Cargo,
       ROUND(MAX(Emp_Salario)) AS Maximo,
       ROUND(MIN(Emp_Salario)) AS Minimo,
       ROUND(SUM(Emp_Salario)) AS Suma,
       ROUND(AVG(Emp_Salario)) AS Promedio
FROM Empleados
GROUP BY Emp_Cargo;

-- 3. Managers with min salary >= 1,300,000
SELECT e.Emp_Jefe AS "Jefe#",
       MIN(e.Emp_Salario) AS Salario_Minimo
FROM Empleados e
WHERE e.Emp_Jefe IS NOT NULL
GROUP BY e.Emp_Jefe
HAVING MIN(e.Emp_Salario) >= 1300000
ORDER BY Salario_Minimo DESC;

-- 4. Department summary: name, location, # employees, avg salary
SELECT d.Dep_Nombre AS Nombre,
       d.Dep_Localizacion AS Localización,
       COUNT(e.Emp_Id) AS "Número de Empleados",
       ROUND(AVG(e.Emp_Salario), 1) AS Salario
FROM Departamentos d
LEFT JOIN Empleados e ON d.Dep_Id = e.Dep_Id
GROUP BY d.Dep_Nombre, d.Dep_Localizacion
ORDER BY d.Dep_Nombre;

-- 5. Pivot table: total salary per position by department (10, 20, 30)
SELECT e.Emp_Cargo AS "Position",
       SUM(CASE WHEN e.Dep_Id = 10 THEN e.Emp_Salario ELSE 0 END) AS "Department 10",
       SUM(CASE WHEN e.Dep_Id = 20 THEN e.Emp_Salario ELSE 0 END) AS "Department 20",
       SUM(CASE WHEN e.Dep_Id = 30 THEN e.Emp_Salario ELSE 0 END) AS "Department 30"
FROM Empleados e
WHERE e.Dep_Id IN (10, 20, 30)
GROUP BY e.Emp_Cargo;


-- =============================================================
-- PRACTICE 6: Subqueries
-- =============================================================

-- 1. Employees in same department as JIMENEZ (excluding JIMENEZ)
SELECT Emp_Nombre, Emp_FechaContrato
FROM Empleados
WHERE Dep_Id = (SELECT Dep_Id FROM Empleados WHERE Emp_Nombre = 'JIMENEZ')
  AND Emp_Nombre != 'JIMENEZ';

-- 2. Employees working in any department of employees whose name contains 'P'
SELECT Emp_Id, Emp_Nombre
FROM Empleados
WHERE Dep_Id IN (
  SELECT Dep_Id FROM Empleados WHERE Emp_Nombre LIKE '%P%'
);

-- 3. Employees in departments located in CALI
SELECT e.Emp_Nombre, e.Emp_Cargo, e.Dep_Id
FROM Empleados e
JOIN Departamentos d ON e.Dep_Id = d.Dep_Id
WHERE d.Dep_Localizacion = 'CALI';

-- 4. Employees managed by LOPEZ
SELECT Emp_Nombre, Emp_Salario
FROM Empleados
WHERE Emp_Jefe = (
  SELECT Emp_Id FROM Empleados WHERE Emp_Nombre = 'LOPEZ'
);

-- 5. Employees in department named CONTABILIDAD
SELECT d.Dep_Id, e.Emp_Nombre, e.Emp_Cargo
FROM Departamentos d
JOIN Empleados e ON d.Dep_Id = e.Dep_Id
WHERE d.Dep_Nombre = 'CONTABILIDAD';
