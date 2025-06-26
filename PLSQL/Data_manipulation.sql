-- ==========================================================
-- FILE: data_manipulation_practice.sql
-- AUTHOR: Juan Pablo Portilla
-- DESCRIPTION:
--   This script demonstrates basic data manipulation in SQL:
--   - Creating a table
--   - Inserting rows (explicitly and implicitly)
--   - Using substitution variables
--   - Updating and deleting records
--   - Using anonymous PL/SQL blocks for dynamic data entry
-- ==========================================================

-- Create the MI_EMPLEADO table
CREATE TABLE MI_EMPLEADO 
(
  MEMP_ID NUMBER NOT NULL,
  MMEMP_APELLIDO VARCHAR2(20),
  MEMP_LOGIN VARCHAR2(20),
  MEMP_SALARIO FLOAT,
  CONSTRAINT MI_EMPLEADO_PK PRIMARY KEY (MEMP_ID)
);

-- View table structure (for reference)
-- DESC MI_EMPLEADO;

-- Explicit INSERTs for rows 1 to 3
INSERT INTO MI_EMPLEADO (MEMP_ID, MMEMP_APELLIDO, MEMP_LOGIN, MEMP_SALARIO)
VALUES (1, 'ROBLEDO', 'Omar Orobledo', 1500000);

INSERT INTO MI_EMPLEADO (MEMP_ID, MMEMP_APELLIDO, MEMP_LOGIN, MEMP_SALARIO)
VALUES (2, 'NAVIA', 'Gustavo Gnavia', 2300000);

INSERT INTO MI_EMPLEADO (MEMP_ID, MMEMP_APELLIDO, MEMP_LOGIN, MEMP_SALARIO)
VALUES (3, 'ALARCON', 'Lucia Lalarcon', 1700000);

-- Implicit INSERTs for rows 4 and 5
INSERT INTO MI_EMPLEADO
VALUES (4, 'HURTADO', 'Milena Mhurtado', 950000);

INSERT INTO MI_EMPLEADO
VALUES (5, 'JURADO', 'Roberto rjurado', 670000);

-- Confirm inserted records
SELECT * FROM MI_EMPLEADO;

-- INSERT using substitution variables and PL/SQL block
-- File: CargaEmp.sql
SET VERIFY OFF;
SET ECHO OFF;
DECLARE
  v_id NUMBER(38) := &id;
  v_apellido VARCHAR2(50) := '&Apellido';
  v_nombre VARCHAR2(50) := '&Nombre';
  v_password VARCHAR2(50) := CONCAT(UPPER(SUBSTR(v_nombre,1,1)), LOWER(v_apellido));
  v_salario NUMBER(38) := &Salario;
BEGIN
  INSERT INTO MI_EMPLEADO VALUES (v_id, v_apellido, v_nombre, v_password, v_salario);
  COMMIT;
END;
/

-- Confirm inserted row
SELECT * FROM MI_EMPLEADO;

-- Repeat permanent version of dynamic insertion
SET VERIFY OFF;
SET ECHO OFF;
DECLARE
  v_id NUMBER(38) := &id;
  v_apellido VARCHAR2(50) := '&Apellido';
  v_nombre VARCHAR2(50) := '&Nombre';
  v_password VARCHAR2(50) := CONCAT(UPPER(SUBSTR(v_nombre,1,1)), LOWER(v_apellido));
  v_salario NUMBER(38) := &Salario;
BEGIN
  INSERT INTO MI_EMPLEADO VALUES (v_id, v_apellido, v_nombre, v_password, v_salario);
  COMMIT;
END;
/

-- Updates and deletes
UPDATE MI_EMPLEADO
SET MEMP_ID = 8
WHERE MEMP_ID = 1;
COMMIT;

DELETE FROM MI_EMPLEADO
WHERE MEMP_ID = 8;
COMMIT;

-- Update surname for employee ID 3
UPDATE MI_EMPLEADO
SET MMEMP_APELLIDO = 'PEREZ'
WHERE MEMP_ID = 3;

-- Update salaries < 1,000,000 to 1,200,000
UPDATE MI_EMPLEADO
SET MEMP_SALARIO = 1200000
WHERE MEMP_SALARIO < 1000000;

-- Confirm updates
SELECT * FROM MI_EMPLEADO;

-- Delete employee 'Lucia Perez' using name pattern
DELETE FROM MI_EMPLEADO
WHERE MMEMP_APELLIDO = 'PEREZ'
AND MEMP_LOGIN LIKE 'L%';

-- Confirm deletion
SELECT * FROM MI_EMPLEADO;

-- Finalize changes
COMMIT;
