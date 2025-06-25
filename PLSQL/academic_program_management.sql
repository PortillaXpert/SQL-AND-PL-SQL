-- ================================================================
-- FILE: academic_program_management.sql
-- AUTHOR: Juan Pablo
-- DESCRIPTION:
--   This script contains:
--     - A PL/SQL package for academic program management
--     - Anonymous blocks to test the package
--     - Various database triggers enforcing business rules
-- ================================================================


-- ================================================================
-- PACKAGE: PRO_GESTION
-- DESCRIPTION:
--   Package for managing academic programs.
--   It includes:
--     1. A function to return the number of students in a given program.
--     2. A procedure to store program names and creation dates in a nested table.
--     3. A function that returns all programs created before the year 2000.
-- ================================================================

CREATE OR REPLACE PACKAGE PRO_GESTION AS
    TYPE PROGRAMA_REC IS RECORD (
        NOMBRE PROGRAMA.NOMBRE%TYPE,
        FECHA_CREACION PROGRAMA.FECHA_CREACION%TYPE
    );
    TYPE PROGRAMAS_TBL IS TABLE OF PROGRAMA_REC;

    FUNCTION NUM_ESTUDIANTES_PROGRAMA(P_PROGRAMA_ID IN PROGRAMA.PROGRAMA_ID%TYPE)
        RETURN NUMBER;

    PROCEDURE GUARDAR_PROGRAMAS;

    FUNCTION CURSOR_PROGRAMAS_ANTES_2000
        RETURN PROGRAMAS_TBL;
END PRO_GESTION;
/

CREATE OR REPLACE PACKAGE BODY PRO_GESTION AS
    FUNCTION NUM_ESTUDIANTES_PROGRAMA(P_PROGRAMA_ID IN PROGRAMA.PROGRAMA_ID%TYPE)
        RETURN NUMBER
    AS
        V_NUM_ESTUDIANTES NUMBER;
    BEGIN
        SELECT COUNT(*)
        INTO V_NUM_ESTUDIANTES
        FROM ESTUDIANTE
        WHERE PROGRAMA_ID = P_PROGRAMA_ID;
        RETURN V_NUM_ESTUDIANTES;
    END;

    PROCEDURE GUARDAR_PROGRAMAS
    AS
        V_PROGRAMAS PROGRAMAS_TBL := PROGRAMAS_TBL();
    BEGIN
        FOR PROGRAMA_REC IN (
            SELECT NOMBRE, FECHA_CREACION FROM PROGRAMA
        ) LOOP
            V_PROGRAMAS.EXTEND;
            V_PROGRAMAS(V_PROGRAMAS.LAST) := PROGRAMA_REC;
        END LOOP;

        DBMS_OUTPUT.PUT_LINE('Programs saved in nested table:');
        FOR I IN 1..V_PROGRAMAS.COUNT LOOP
            DBMS_OUTPUT.PUT_LINE(V_PROGRAMAS(I).NOMBRE || ' - ' || V_PROGRAMAS(I).FECHA_CREACION);
        END LOOP;
    END;

    FUNCTION CURSOR_PROGRAMAS_ANTES_2000
        RETURN PROGRAMAS_TBL
    AS
        V_PROGRAMAS PROGRAMAS_TBL := PROGRAMAS_TBL();
    BEGIN
        FOR PROGRAMA_REC IN (
            SELECT NOMBRE, FECHA_CREACION
            FROM PROGRAMA
            WHERE FECHA_CREACION < TO_DATE('2000-01-01', 'YYYY-MM-DD')
        ) LOOP
            V_PROGRAMAS.EXTEND;
            V_PROGRAMAS(V_PROGRAMAS.LAST) := PROGRAMA_REC;
        END LOOP;
        RETURN V_PROGRAMAS;
    END;
END PRO_GESTION;
/

-- ================================================================
-- ANONYMOUS BLOCK: DISPLAY PROGRAMS CREATED BEFORE 2000
-- ================================================================

SET SERVEROUTPUT ON;

DECLARE
    V_PROGRAMAS PRO_GESTION.PROGRAMAS_TBL := PRO_GESTION.CURSOR_PROGRAMAS_ANTES_2000;
BEGIN
    DBMS_OUTPUT.PUT_LINE('Programs created before the year 2000:');
    FOR I IN 1..V_PROGRAMAS.COUNT LOOP
        DBMS_OUTPUT.PUT_LINE(V_PROGRAMAS(I).NOMBRE);
    END LOOP;
END;
/

-- ================================================================
-- ANONYMOUS BLOCK: GET NUMBER OF STUDENTS IN A PROGRAM
-- ================================================================

DECLARE
    programa_id NUMBER := 11;
    num_estudiantes NUMBER;
BEGIN
    num_estudiantes := PRO_GESTION.NUM_ESTUDIANTES_PROGRAMA(programa_id);
    DBMS_OUTPUT.PUT_LINE('Number of students in program ' || programa_id || ' is: ' || num_estudiantes);
END;
/

-- ================================================================
-- TRIGGER: LIMIT NUMBER OF FACULTIES TO MAX 5
-- ================================================================

CREATE OR REPLACE TRIGGER tr_limit_facultades
BEFORE INSERT ON FACULTAD
DECLARE
  v_num_facultades NUMBER;
BEGIN
  SELECT COUNT(*) INTO v_num_facultades FROM FACULTAD;
  IF v_num_facultades >= 5 THEN
    RAISE_APPLICATION_ERROR(-20001, 'Cannot insert more than 5 faculties.');
  END IF;
END;
/

-- ================================================================
-- TRIGGER: PREVENT STUDENTS FROM JOINING PROGRAMS IN FACULTIES WITH NO PROFESSORS
-- ================================================================

CREATE OR REPLACE TRIGGER tr_check_programa_facultad
BEFORE INSERT OR UPDATE OF programa_id ON ESTUDIANTE
FOR EACH ROW
DECLARE
  v_num_profesores NUMBER;
BEGIN
  IF :NEW.programa_id IS NULL THEN
    RETURN;
  END IF;

  SELECT COUNT(*) INTO v_num_profesores
  FROM PROFESOR
  WHERE FACULTAD_ID = (
    SELECT FACULTAD_ID FROM PROGRAMA WHERE PROGRAMA_ID = :NEW.programa_id
  );

  IF v_num_profesores = 0 THEN
    RAISE_APPLICATION_ERROR(-20001, 'Cannot associate student to a program from a faculty without professors.');
  END IF;
END;
/

-- ================================================================
-- TRIGGER: AUTO-CREATE FACULTY IF NOT EXISTS ON PROGRAM INSERT
-- ================================================================

CREATE OR REPLACE TRIGGER tr_facultad_temporal
BEFORE INSERT ON PROGRAMA
FOR EACH ROW
DECLARE
  v_count NUMBER;
BEGIN
  SELECT COUNT(*) INTO v_count FROM FACULTAD WHERE FACULTAD_ID = :NEW.FACULTAD_ID;
  IF v_count = 0 THEN
    INSERT INTO FACULTAD (FACULTAD_ID, NOMBRE, PRESUPUESTOANUAL, TOTALSALARIOS)
    VALUES (:NEW.FACULTAD_ID, 'TemporaryFaculty', 0, 0);
    DBMS_OUTPUT.PUT_LINE('Temporary faculty created with ID ' || :NEW.FACULTAD_ID);
  END IF;
END;
/

-- Sample insert that would trigger the above:
INSERT INTO PROGRAMA (PROGRAMA_ID, NOMBRE, FECHA_CREACION, FACULTAD_ID)
VALUES (110, 'FINE ARTS', TO_DATE('1952-12-10', 'YYYY-MM-DD'), 120000);
/

-- ================================================================
-- TRIGGER: LIMIT STUDENTS TO MAX 10 PER PROGRAM
-- ================================================================

CREATE OR REPLACE TRIGGER limite_estudiantes
BEFORE INSERT OR UPDATE ON ESTUDIANTE
FOR EACH ROW
DECLARE
  total_estudiantes NUMBER;
BEGIN
  SELECT COUNT(*) INTO total_estudiantes
  FROM ESTUDIANTE
  WHERE PROGRAMA_ID = :NEW.PROGRAMA_ID;

  IF total_estudiantes >= 10 THEN
    RAISE_APPLICATION_ERROR(-20001, 'Cannot have more than 10 students per program.');
  END IF;
END;
/

-- ================================================================
-- END OF SCRIPT
-- ================================================================
