-- ===================================================================
-- Author: Juan Pablo Portilla
-- Description: Stored procedures, record collections, and cursors
-- Language: PL/SQL (Oracle SQL)
-- ===================================================================

-- ================================================================
-- Exercise 1: Insert example product records for testing purposes
-- ================================================================
INSERT INTO PRODUCTOS (PRO_ID, PRO_NOMBRE) VALUES ('30100211', 'SSD 500GB');
INSERT INTO PRODUCTOS (PRO_ID, PRO_NOMBRE) VALUES ('30100212', 'Graphics Card TX500');
INSERT INTO PRODUCTOS (PRO_ID, PRO_NOMBRE) VALUES ('30100213', 'Monitor 27 LG');

-- ================================================================
-- Exercise 2: Create procedure to delete a product by its ID
-- ================================================================
CREATE OR REPLACE PROCEDURE DeleteP(P_ID PRODUCTOS.PRO_ID%TYPE)
AS
  v_id productos.pro_id%TYPE := p_id;
BEGIN
  DELETE FROM productos WHERE pro_id = v_id;
  DBMS_OUTPUT.PUT_LINE('Product with ID ' || v_id || ' has been deleted.');
END;
/

-- Test Deletion
EXECUTE DeleteP('30100213');
EXECUTE DeleteP('30100212');
EXECUTE DeleteP('30100211');

-- ================================================================
-- Exercise 3: Procedure to insert or update an employee
-- If the employee exists, update only job title, salary, and dept.
-- ================================================================
CREATE OR REPLACE PROCEDURE update_or_add(
  p_id IN NUMBER,
  p_nombre IN VARCHAR2,
  p_cargo IN VARCHAR2,
  p_jefe IN NUMBER,
  p_contrato IN DATE,
  p_salario IN NUMBER,
  p_comision IN NUMBER,
  p_dep IN NUMBER
) AS
  v_empleado empleados%ROWTYPE;
  v_count NUMBER := 0;
BEGIN
  v_empleado.emp_id := p_id;
  v_empleado.emp_nombre := p_nombre;
  v_empleado.emp_cargo := p_cargo;
  v_empleado.emp_jefe := p_jefe;
  v_empleado.emp_fechacontrato := p_contrato;
  v_empleado.emp_salario := p_salario;
  v_empleado.emp_comision := p_comision;
  v_empleado.dep_id := p_dep;

  SELECT COUNT(emp_id)
  INTO v_count
  FROM empleados
  WHERE emp_id = p_id;

  IF v_count = 0 THEN
    INSERT INTO empleados VALUES v_empleado;
    DBMS_OUTPUT.PUT_LINE('Employee inserted.');
  ELSE
    UPDATE empleados
    SET emp_cargo = v_empleado.emp_cargo,
        emp_salario = v_empleado.emp_salario,
        dep_id = v_empleado.dep_id
    WHERE emp_id = v_empleado.emp_id;
    DBMS_OUTPUT.PUT_LINE('Employee updated.');
  END IF;
END;
/

-- Test Cases
EXECUTE update_or_add(1000, 'CRISTIANO', 'OFFICE CLERK', 1100, TO_DATE('01/01/2031','DD/MM/YYYY'), 2000000, NULL, 30);
EXECUTE update_or_add(1400, 'OBREGON', 'SALESPERSON', 1100, TO_DATE('15/05/2003','DD/MM/YYYY'), 3000000, NULL, 20);

-- ================================================================
-- Exercise 4: Bulk collect products into a PL/SQL table and print
-- ================================================================
DECLARE
  TYPE tabla_productos IS TABLE OF productos%ROWTYPE;
  v_productos tabla_productos;
  i INTEGER := 1;
BEGIN
  SELECT * BULK COLLECT INTO v_productos FROM productos;

  WHILE i <= v_productos.COUNT LOOP
    DBMS_OUTPUT.PUT_LINE('Product ID: ' || v_productos(i).pro_id ||
                         ', Product Name: ' || v_productos(i).pro_nombre);
    i := i + 1;
  END LOOP;
EXCEPTION
  WHEN no_data_found THEN NULL;
  WHEN OTHERS THEN RAISE;
END;
/

-- ================================================================
-- Exercise 5: Show each employee and their direct manager's name
-- ================================================================
CREATE OR REPLACE PROCEDURE mostrar_jefe_directo AS
  v_nombre_empleado empleados.emp_nombre%TYPE;
  v_nombre_jefe empleados.emp_nombre%TYPE;
  CURSOR c_empleados IS SELECT emp_nombre, emp_jefe FROM empleados;
BEGIN
  FOR empleado IN c_empleados LOOP
    BEGIN
      SELECT emp_nombre INTO v_nombre_jefe FROM empleados WHERE emp_id = empleado.emp_jefe;
      v_nombre_empleado := empleado.emp_nombre;
      DBMS_OUTPUT.PUT_LINE('Employee ' || v_nombre_empleado || ' reports to ' || v_nombre_jefe);
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Employee ' || empleado.emp_nombre || ' has no registered manager.');
    END;
  END LOOP;
END;
/

-- Test Procedure
EXECUTE mostrar_jefe_directo;

-- ================================================================
-- Exercise 6: Count and list employees whose name starts with a letter
-- ================================================================
CREATE OR REPLACE PROCEDURE num_empleados(letra IN VARCHAR2) IS
  TYPE nombres_empleados IS TABLE OF empleados.emp_nombre%TYPE;
  v_nombres nombres_empleados;
  v_contador NUMBER := 0;

  CURSOR c_empleados IS
    SELECT emp_nombre FROM empleados WHERE emp_nombre LIKE letra || '%';
BEGIN
  OPEN c_empleados;
  FETCH c_empleados BULK COLLECT INTO v_nombres;
  CLOSE c_empleados;

  v_contador := v_nombres.COUNT;

  DBMS_OUTPUT.PUT_LINE('Number of employees whose name starts with ' || letra || ': ' || v_contador);

  IF v_contador > 0 THEN
    FOR i IN 1..v_contador LOOP
      DBMS_OUTPUT.PUT_LINE('- ' || v_nombres(i));
    END LOOP;
  END IF;
EXCEPTION
  WHEN NO_DATA_FOUND THEN
    DBMS_OUTPUT.PUT_LINE('No employees found with names starting with ' || letra);
END;
/

-- Test with various letters
DECLARE l VARCHAR2(1);
BEGIN l := 'S'; num_empleados(l); END;
/

BEGIN l := 'F'; num_empleados(l); END;
/

BEGIN l := 'B'; num_empleados(l); END;
/
