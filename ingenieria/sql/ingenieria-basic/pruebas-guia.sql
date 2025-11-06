------------------------------------------------------------ PRUEBAS ----------------------------------------------------

-- Profesor de ingenieria

SET SESSION AUTHORIZATION '11001';
SELECT SESSION_USER, CURRENT_USER;

SELECT * FROM ingenieria.lista_estudiantes;
SELECT * FROM biblioteca.libros;
SELECT * FROM ingenieria.info_profesores;
UPDATE ingenieria.info_profesores SET nom_p = 'Mi nombre' where current_user = id_p::text;

-- Estudiante de ingenieria

SET SESSION AUTHORIZATION '1000001';
SELECT SESSION_USER, CURRENT_USER;

SELECT * FROM biblioteca.consulta_escribe;

-- Administrador

SET SESSION AUTHORIZATION 'postgres';

select * from ingenieria.prestamos_universidad;

-- Bibliotecario

SET SESSION AUTHORIZATION 'bibliotecau';

SELECT * FROM biblioteca.presta;