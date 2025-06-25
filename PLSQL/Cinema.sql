-- ==========================================================
-- FILE: movie_actor_analysis.sql
-- AUTHOR: Juan Pablo
-- DESCRIPTION:
--   This script contains two PL/SQL programs:
--   1. A function that returns the number of actors in a given movie 
--      who earn more than $1,000,000, displaying their details.
--   2. A procedure that lists the top 3 movies with the highest number 
--      of actors who have a representative.
-- ==========================================================


-- ==========================================================
-- FUNCTION: INFO_ACTORES
-- DESCRIPTION:
--   Returns the number of actors in a given movie who earn 
--   more than $1,000,000.
--   For each actor, the function prints:
--     - Actor name
--     - Number of distinct movies they’ve participated in
--     - Salary
--   If no actors match the criteria, it raises an exception.
-- ==========================================================

CREATE OR REPLACE FUNCTION info_actores(p_pelicula pelicula.pel_id%TYPE) RETURN NUMBER IS
  TYPE t_actor_info IS RECORD (
    act_nombre actor.act_nombre%TYPE,
    num_peliculas NUMBER,
    salario NUMBER
  );
  TYPE t_actor_info_tab IS TABLE OF t_actor_info;
  v_actor_info_tab t_actor_info_tab := t_actor_info_tab();
  v_num_actores NUMBER := 0;
BEGIN
  SELECT a.act_nombre, COUNT(DISTINCT ac.pel_id), ac.salario
  BULK COLLECT INTO v_actor_info_tab
  FROM actor a
  INNER JOIN actua ac ON a.act_id = ac.act_id
  WHERE ac.pel_id = p_pelicula AND ac.salario > 1000000
  GROUP BY a.act_id, a.act_nombre, ac.salario;
  
  IF v_actor_info_tab.COUNT = 0 THEN
    RAISE_APPLICATION_ERROR(-20002, 'The movie has no actors with salary over 1,000,000.');
  END IF;
  
  FOR i IN 1..v_actor_info_tab.COUNT LOOP
    v_num_actores := v_num_actores + 1;
    DBMS_OUTPUT.PUT_LINE('Actor ' || v_num_actores || ': ' || v_actor_info_tab(i).act_nombre || ', with ' || v_actor_info_tab(i).num_peliculas || ' movies and salary: ' || v_actor_info_tab(i).salario);
  END LOOP;
  
  RETURN v_num_actores;
END;
/

-- ==========================================================
-- EXAMPLE: EXECUTE INFO_ACTORES FOR MOVIE ID = 1
-- ==========================================================
DECLARE
  v_num_actores NUMBER;
BEGIN
  v_num_actores := INFO_ACTORES(1);
  DBMS_OUTPUT.PUT_LINE('Number of actors: ' || v_num_actores);
END;
/

-- ==========================================================
-- EXAMPLE: EXECUTE INFO_ACTORES FOR MOVIE ID = 4
-- ==========================================================
DECLARE
  v_num_actores NUMBER;
BEGIN
  v_num_actores := INFO_ACTORES(4);
  DBMS_OUTPUT.PUT_LINE('Number of actors: ' || v_num_actores);
END;
/




-- ==========================================================
-- PROCEDURE: PROC_PA
-- DESCRIPTION:
--   Retrieves the top 3 movies with the most actors who 
--   have a representative (rep_id IS NOT NULL).
--   For each, prints:
--     - Movie name
--     - Number of represented actors
--   Ordered by actor count DESC and movie name ASC.
-- ==========================================================

CREATE OR REPLACE PROCEDURE PROC_PA AS
  TYPE t_pel_actores IS RECORD (
    pel_nombre pelicula.pel_nombre%TYPE,
    num_actores NUMBER
  );
  TYPE t_pel_actores_tab IS TABLE OF t_pel_actores;
  v_pel_actores_tab t_pel_actores_tab := t_pel_actores_tab();

  CURSOR c_pel_actores IS
    SELECT p.pel_nombre, COUNT(DISTINCT a.rep_id) AS num_actores
    FROM pelicula p
    INNER JOIN actua ac ON p.pel_id = ac.pel_id
    INNER JOIN actor a ON ac.act_id = a.act_id
    WHERE a.rep_id IS NOT NULL
    GROUP BY p.pel_nombre
    HAVING COUNT(DISTINCT a.rep_id) >= 1
    ORDER BY COUNT(DISTINCT a.rep_id) DESC, p.pel_nombre ASC;
BEGIN
  OPEN c_pel_actores;
  FETCH c_pel_actores BULK COLLECT INTO v_pel_actores_tab LIMIT 3;
  
  FOR i IN 1..3 LOOP
    IF i <= v_pel_actores_tab.COUNT THEN
      DBMS_OUTPUT.PUT_LINE('Movie ' || i || ': ' || v_pel_actores_tab(i).pel_nombre || ', with ' || v_pel_actores_tab(i).num_actores || ' represented actors');
    END IF;
  END LOOP;

  CLOSE c_pel_actores;
END;
/

-- ==========================================================
-- EXECUTE: RUN THE PROC_PA PROCEDURE
-- ==========================================================
EXECUTE PROC_PA;
