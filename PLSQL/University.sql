-- SUBMITTED BY: JUAN PABLO PORTILLA

-- 1. Anonymous block that asks the user for a student code and prints their name
SET SERVEROUTPUT ON;
DECLARE
   v_nombre_estudiante ESTUDIANTE.NOMBRE%TYPE;
   v_codigo_estudiante ESTUDIANTE.CODIGO%TYPE := &codigo_estudiante;
BEGIN
   SELECT NOMBRE INTO v_nombre_estudiante
   FROM ESTUDIANTE
   WHERE CODIGO = v_codigo_estudiante;
   
   DBMS_OUTPUT.PUT_LINE('El nombre del estudiante con código ' || v_codigo_estudiante || ' es ' || v_nombre_estudiante);
END;
-- Run with student code 111

-- 2. Stored procedure that prints the student's name, code, and program
CREATE OR REPLACE PROCEDURE imprimir(codigo_id IN estudiante.codigo%TYPE)
IS
  v_nombre estudiante.nombre%TYPE;
  v_programa programa.nombre%TYPE;
  v_id_programa programa.programa_id%TYPE;
BEGIN
  SELECT e.nombre, p.nombre, p.programa_id
  INTO v_nombre, v_programa, v_id_programa
  FROM estudiante e
  INNER JOIN programa p ON e.programa_id = p.programa_id
  WHERE e.codigo = codigo_id;

  DBMS_OUTPUT.PUT_LINE('El estudiante ' || v_nombre || ' con código ' || codigo_id || ' estudia ' || v_programa || ' con código de programa ' || v_id_programa);
END;
-- EXECUTE imprimir(312);

-- 3. Stored procedure to check faculty budget and print an appropriate message
CREATE OR REPLACE PROCEDURE mostrar_presupuesto(id_facultad IN NUMBER)
IS
  presupuesto facultad.presupuestoanual%TYPE;
  nombre_facultad facultad.nombre%TYPE;
BEGIN
  SELECT nombre, presupuestoanual
  INTO nombre_facultad, presupuesto 
  FROM facultad
  WHERE facultad_id = id_facultad;

  IF presupuesto = 0 THEN
    DBMS_OUTPUT.PUT_LINE('La facultad ' || nombre_facultad || ' no tiene presupuesto');
  ELSE
    DBMS_OUTPUT.PUT_LINE('La facultad ' || nombre_facultad || ' tiene un presupuesto de: $' || TO_CHAR(presupuesto, '$999,999,999.99'));
  END IF;
END;
-- EXECUTE mostrar_presupuesto(300);

-- 4. Procedure that calculates total professor salaries and compares with faculty budget
CREATE OR REPLACE PROCEDURE calcular_salarios_facultad(p_id_facultad IN facultad.facultad_id%TYPE)
IS
  v_suma_salarios profesor.salario%TYPE;
  v_presupuesto_facultad facultad.presupuestoanual%TYPE;
BEGIN
  SELECT SUM(salario) INTO v_suma_salarios FROM profesor WHERE facultad_id = p_id_facultad;
  SELECT presupuestoanual INTO v_presupuesto_facultad FROM facultad WHERE facultad_id = p_id_facultad;

  IF v_suma_salarios > v_presupuesto_facultad THEN
    DBMS_OUTPUT.PUT_LINE('La facultad ELECTRONICA no tiene presupuesto para salarios');
  ELSE
    DBMS_OUTPUT.PUT_LINE('La facultad DERECHO tiene un presupuesto de: $' || v_presupuesto_facultad || ' de los cuales gasta en salarios $' || v_suma_salarios);
  END IF;
END;
-- EXECUTE calcular_salarios_facultad(300);

-- 5. Anonymous block that inserts multiple professors with dynamic values
DECLARE
  nombre profesor.nombre%TYPE := 'profesor1';
  salario profesor.salario%TYPE := 2000;
  idFacultad profesor.facultad_id%TYPE := 300;
  cedula NUMBER := 333;
BEGIN
  WHILE salario <= 10000 LOOP
    INSERT INTO Profesor (CEDULA, NOMBRE, SALARIO, FACULTAD_ID)
    VALUES (cedula, nombre, salario * 2, idFacultad);

    salario := salario + 1000;
    cedula := cedula + 111;
  END LOOP;
  COMMIT;
END;