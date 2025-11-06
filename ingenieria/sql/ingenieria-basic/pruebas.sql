-- Active: 1715901970166@@127.0.0.1@5432@university
-- Para verificar roles

SELECT rolname FROM pg_roles WHERE pg_has_role('11001', oid, 'member');
select rolname from pg_roles;

show search_path;
set search_path to ingenieria;

-- Eliminar y revocar

REVOKE ALL PRIVILEGES ON ALL TABLES IN SCHEMA ingenieria FROM estudiantesIng;
REVOKE ALL PRIVILEGES ON ALL TABLES IN SCHEMA biblioteca FROM estudiantesIng;
REVOKE ALL PRIVILEGES ON ALL TABLES IN SCHEMA ingenieria FROM profesoresIng;
REVOKE ALL PRIVILEGES ON ALL TABLES IN SCHEMA biblioteca FROM profesoresIng;
REVOKE ALL PRIVILEGES ON ALL TABLES IN SCHEMA biblioteca FROM bibliotecau;
REVOKE ALL PRIVILEGES ON ALL TABLES IN SCHEMA ingenieria FROM bibliotecau;

--REVOKE ALL PRIVILEGES ON ALL TABLES IN SCHEMA asab FROM estudiantesAsab;
--REVOKE ALL PRIVILEGES ON ALL TABLES IN SCHEMA asab FROM profesoresAsab;

drop role estudiantesIng;
drop role profesoresIng;
drop role bibliotecau;

-- Delete users

CREATE OR REPLACE FUNCTION delete_usuarios() RETURNS void AS
$BODY$
DECLARE f ingenieria.estudiantes_fac%rowtype;
DECLARE r ingenieria.profesores%rowtype;
BEGIN
	FOR f IN SELECT * FROM ingenieria.estudiantes_fac
	LOOP
		if (f.cod_e::text in (select usename from pg_user)) then
			execute 'drop user "'||f.cod_e||'"';
		end if;
	END LOOP;
	FOR r IN SELECT * FROM ingenieria.profesores
	LOOP
		if (r.id_p::text in (select usename from pg_user)) then
			execute 'drop user "'||r.id_p||'" ';
		end if;
	END LOOP;
RETURN;
END
$BODY$
LANGUAGE 'plpgsql' ;

select delete_usuarios();
------------------------------------------------------------ PRUEBAS ----------------------------------------------------

-- Profesor de ingenieria

SET SESSION AUTHORIZATION '11001';
SELECT SESSION_USER, CURRENT_USER;

-- Consulta lista de sus estudiantes
SELECT * FROM ingenieria.lista_estudiantes;
-- Actualiza notas de la lista de sus estudiantes
UPDATE ingenieria.lista_estudiantes SET n1 = '5' WHERE cod_e = '1000001' and cod_a = '1101';
-- Consulta libros, autores y quién los escribe
SELECT * FROM biblioteca.consulta_escribe;
SELECT * FROM biblioteca.autores;
SELECT * FROM biblioteca.libros;
-- Consulta información como profesor
SELECT * FROM ingenieria.info_profesores;
-- Actualiza información como profesor
UPDATE ingenieria.info_profesores SET nom_p = 'Profesor 1' where current_user = id_p::text;

-- Estudiante de ingenieria

SET SESSION AUTHORIZATION '1000001';
SELECT SESSION_USER, CURRENT_USER;

-- Consulta sus notas
SELECT * FROM ingenieria.notasEstud;
-- Consulta libros, autores y quién los escribe
SELECT * FROM biblioteca.consulta_escribe;
SELECT * FROM biblioteca.autores;
SELECT * FROM biblioteca.libros;
-- Consulta prestamos
SELECT * FROM biblioteca.consultar_prest_est;

-- Administrador

SET SESSION AUTHORIZATION 'postgres';

select * from ingenieria.listado_facultad_asig;
select * from ingenieria.listado_facultad_notas;
select * from ingenieria.prestamos_universidad;

-- Bibliotecario

SET SESSION AUTHORIZATION 'bibliotecau';

SELECT * FROM biblioteca.presta;

-- Inserción

INSERT INTO ingenieria.inscribe (id_p, cod_a, grupo, cod_e, n1, n2, n3)
VALUES (11001,  1101,    1,     2,   3.5,  4.0,  4.7);

INSERT INTO ingenieria.inscribe (id_p, cod_a, grupo, cod_e, n1, n2, n3)
VALUES (11001,  1101,    1,     1000005,   3.5,  4.0,  4.7);

GRANT INSERT ON ingenieria.inscribe TO profesoresIng;

SELECT * FROM ingenieria.inscribe WHERE cod_e=1000005;