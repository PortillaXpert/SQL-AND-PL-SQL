-- ==========================================================
-- FILE: database_exam_procedures.sql
-- AUTHOR: Juan Pablo Rivera Portilla
-- COURSE: Database Lab II – Systems Engineering
-- DESCRIPTION:
--   SQL and PL/SQL implementations for the first partial exam.
--   Includes data retrieval, stored procedures, functions,
--   exception handling, and data manipulation.
-- ==========================================================

-- ==========================================================
-- POINT 1: Anonymous block with employee details
-- DESCRIPTION:
--   Retrieves employee name (uppercase), job title (lowercase),
--   annual salary, and department name based on input employee ID.
-- ==========================================================
SET SERVEROUTPUT ON;
SET VERIFY OFF;
DECLARE
  v_emp_id Empleados.Emp_Id%TYPE := 1100;
  v_emp_nombre Empleados.Emp_Nombre%TYPE;
  v_emp_cargo Empleados.Emp_Cargo%TYPE;
  v_emp_salario NUMBER(10,2);
  v_dep_nombre Departamentos.Dep_Nombre%TYPE;
BEGIN
  SELECT UPPER(Emp_Nombre), LOWER(Emp_Cargo), Emp_Salario * 12, Dep_Nombre
  INTO v_emp_nombre, v_emp_cargo, v_emp_salario, v_dep_nombre
  FROM Empleados
  JOIN Departamentos ON Empleados.Dep_Id = Departamentos.Dep_Id
  WHERE Emp_Id = v_emp_id;

  DBMS_OUTPUT.PUT_LINE('Name: ' || v_emp_nombre);
  DBMS_OUTPUT.PUT_LINE('Position: ' || v_emp_cargo);
  DBMS_OUTPUT.PUT_LINE('Annual Salary: ' || v_emp_salario);
  DBMS_OUTPUT.PUT_LINE('Department: ' || v_dep_nombre);
END;
/

-- ==========================================================
-- POINT 2: Procedure to insert or update department
-- DESCRIPTION:
--   Inserts a department if it doesn't exist; otherwise updates it.
-- ==========================================================
CREATE OR REPLACE PROCEDURE insertar_departamento (
  p_id Departamentos.Dep_Id%TYPE,
  p_nombre Departamentos.Dep_Nombre%TYPE,
  p_localizacion Departamentos.Dep_Localizacion%TYPE
) IS
  v_count NUMBER;
BEGIN
  SELECT COUNT(*) INTO v_count FROM Departamentos WHERE Dep_Id = p_id;
  IF v_count = 0 THEN
    INSERT INTO Departamentos (Dep_Id, Dep_Nombre, Dep_Localizacion)
    VALUES (p_id, p_nombre, p_localizacion);
    DBMS_OUTPUT.PUT_LINE('Department inserted.');
  ELSE
    UPDATE Departamentos
    SET Dep_Nombre = p_nombre,
        Dep_Localizacion = p_localizacion
    WHERE Dep_Id = p_id;
    DBMS_OUTPUT.PUT_LINE('Department updated.');
  END IF;
END;
/

-- Execute examples
BEGIN
  insertar_departamento(40, 'INGENIERIA', 'CAUCA');
  insertar_departamento(60, 'MARKETING', 'GUAPI');
END;
/

-- ==========================================================
-- POINT 3: Procedure + Function to search clients by first letter
-- DESCRIPTION:
--   Counts and lists clients whose names start with a specific letter,
--   along with their address, location, and assigned employee.
-- ==========================================================
CREATE OR REPLACE FUNCTION contar_clientes(p_letra IN VARCHAR2) RETURN NUMBER AS
  v_num_clientes NUMBER;
BEGIN
  SELECT COUNT(*)
  INTO v_num_clientes
  FROM Clientes
  WHERE UPPER(Cli_Nombre) LIKE UPPER(p_letra || '%');
  RETURN v_num_clientes;
END;
/

CREATE OR REPLACE PROCEDURE sp_buscar_clientes(p_letra IN VARCHAR2) AS
  v_num_clientes NUMBER;
BEGIN
  v_num_clientes := contar_clientes(p_letra);
  IF v_num_clientes = 0 THEN
    DBMS_OUTPUT.PUT_LINE('No clients found starting with: ' || p_letra);
    RETURN;
  END IF;

  DBMS_OUTPUT.PUT_LINE('Clients starting with ' || p_letra || ': ' || v_num_clientes);
  FOR c IN (
    SELECT c.Cli_Nombre, c.Cli_Direccion, c.Cli_Ciudad, c.Cli_Departamento,
           e.Emp_Nombre
    FROM Clientes c
    JOIN Empleados e ON c.Emp_Id = e.Emp_Id
    WHERE UPPER(c.Cli_Nombre) LIKE UPPER(p_letra || '%')
  ) LOOP
    DBMS_OUTPUT.PUT_LINE(c.Cli_Nombre || ', ' || c.Cli_Direccion || ', ' ||
                         c.Cli_Ciudad || ', ' || c.Cli_Departamento || ', ' || c.Emp_Nombre);
  END LOOP;
END;
/

-- Execute procedure with test letters
BEGIN
  sp_buscar_clientes('C');
  sp_buscar_clientes('A');
  sp_buscar_clientes('P');
END;
/

-- ==========================================================
-- POINT 4: Anonymous block with custom exception handling
-- DESCRIPTION:
--   Given a product ID, determines whether it qualifies for a 10% discount
--   based on quantity ordered. Handles custom and no-data exceptions.
-- ==========================================================
DECLARE
  v_producto_id Productos.Pro_Id%TYPE := &producto_id;
  v_producto_nombre Productos.Pro_Nombre%TYPE;
  v_cantidad_productos NUMBER;
BEGIN
  SELECT Pro_Nombre INTO v_producto_nombre
  FROM Productos
  WHERE Pro_Id = v_producto_id;

  SELECT SUM(Ppo_Cantidad) INTO v_cantidad_productos
  FROM ProductosPorOrden
  WHERE Pro_Id = v_producto_id;

  IF v_cantidad_productos > 150 THEN
    DBMS_OUTPUT.PUT_LINE('Product ' || v_producto_nombre || ' qualifies for 10% discount');
  ELSIF v_cantidad_productos <= 100 THEN
    RAISE_APPLICATION_ERROR(-20002, 'Product ID ' || v_producto_id || ' does not qualify for discount');
  ELSE
    RAISE_APPLICATION_ERROR(-20001, 'Product ' || v_producto_nombre || ' does not meet minimum quantity for discount');
  END IF;

EXCEPTION
  WHEN NO_DATA_FOUND THEN
    DBMS_OUTPUT.PUT_LINE('Product with ID ' || v_producto_id || ' does not exist.');
END;
/

-- ==========================================================
-- POINT 5: Function to delete employee by ID
-- DESCRIPTION:
--   Deletes an employee if exists and returns 1; otherwise returns 0.
-- ==========================================================
CREATE OR REPLACE FUNCTION eliminar_empleado(p_id_empleado IN NUMBER)
RETURN NUMBER IS
  v_count NUMBER;
BEGIN
  SELECT COUNT(*) INTO v_count FROM Empleados WHERE Emp_Id = p_id_empleado;
  IF v_count = 0 THEN
    RETURN 0;
  ELSE
    DELETE FROM Empleados WHERE Emp_Id = p_id_empleado;
    RETURN 1;
  END IF;
END;
/

-- Test function in anonymous block
DECLARE
  v_resultado NUMBER;
BEGIN
  v_resultado := eliminar_empleado(5000);
  IF v_resultado = 0 THEN
    RAISE_APPLICATION_ERROR(-20001, 'Employee does not exist.');
  ELSE
    DBMS_OUTPUT.PUT_LINE('Employee deleted successfully.');
  END IF;
END;
/
