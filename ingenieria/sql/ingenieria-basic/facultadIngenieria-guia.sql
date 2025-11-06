---------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------- DDL --------------------------------------------------------
------------------ Creación de los esquemas, tablas (con constraints) y vistas --------------------------------------
---------------------------------------------------------------------------------------------------------------------

-- El método COPY no funciona en la extensión
-- El fichero completo ejecuta desde pgadmin
-- Se sugiere hacer la ejecución de DDL toda desde pgadmin
-- Las consultas si se pueden hacer desde VSCode
-- CREATE DATABASE university;

-- El esquema ingenieria es el general. Se creará un esquema por cada carrera.
-- Debe crear al menos 4 carreras.
CREATE SCHEMA ingenieria;
CREATE SCHEMA "Ingenieria de Sistemas";
-- La biblioteca se gestiona por aparte, por lo tanto debe crearse como esquema.
CREATE SCHEMA biblioteca;

-- Dado que los estudiantes son por carrera pero el resto de relaciones son transversales, en el esquema ingenieria 
-- deben ir los profesores, carreras, asignaturas y sus relaciones (imparte, inscribe, referencia).
set search_path = ingenieria, public;

-- Aquí crea entonces dichas tablas con sus constraints.

-- PROFESORES, CARRERAS, ASIGNATURAS, ETC.

------------------------------------------------- Estudiantes por carrera -------------------------------------------

set search_path = "Ingenieria de Sistemas", public;

-- Aquí crea la tabla estudiantes con sus constraints.

set search_path = "Ingenieria XXXXXXX", public;

-- Aquí crea la tabla estudiantes con sus constraints.

-- Continua hasta que se creen las carreras solicitadas.

-------------------------------------------------------- Biblioteca -------------------------------------------------

set search_path = biblioteca, public;

-- Aquí crea las tablas asociadas a la parte de la biblioteca (libros, autores, ejemplares, escribre, presta).

---------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------- VISTAS -----------------------------------------------------
---------------------------------------------------------------------------------------------------------------------

-- Una vista es una tabla virtual que no almacena datos por sí misma, sino que se basa en el resultado de una consulta SQL
-- La sintaxis básica para crear una vista es la siguiente:

-- CREATE VIEW nombre_vista AS consulta;

-- Donde "consulta" es la query SQL que se va a ejecutar cuando se acceda a la vista.

-- Ejemplo:

/*
CREATE VIEW vista_empleados AS 
SELECT id_empleado, nombre, puesto 
FROM empleados 
WHERE salario > 2000;
*/

-- Una vez creada la vista, se puede acceder a ella desde cualquier otro lugar de la base de datos.

-- SELECT * FROM vista_empleados;

-- Para nuestro proyecto:

set search_path = ingenieria, public;

-- Vista que permite consultar la información del profesor
create view info_profesores as 
select *
from profesores
where id_p::text=current_user;
-- Aquí id_p::text=current_user compara si el valor de la columna id_p (convertido a texto) es igual 
-- al nombre del usuario actualmente conectado. Si es así, la fila correspondiente se incluirá en la vista info_profesores.

-- Vista que permite consultar la lista de estudiantes de sus cursos (para el profesor)
create view lista_estudiantes as
select cod_a, nom_a, grupo, cod_e, nom_e, n1, n2, n3, 
(COALESCE(n1,0)*.35+COALESCE(n2,0)*.35+COALESCE(n3,0)*.3)::real as definitiva
from estudiantes_fac natural join inscribe natural join asignaturas
where id_p::TEXT = current_user
order by cod_a, grupo, cod_e;
-- Aquí la función COALESCE() se usa para sustituir NULL por un 0.
-- Nótese que estudiantes_fac es una vista que reune a todos los estudiantes de la facultad de ingeniería.

-------------------------------------------------------- Biblioteca -------------------------------------------------

set search_path = biblioteca, public;

-- Vista para consultar la tabla escribe en la facultad de ingeniería
CREATE VIEW consulta_escribe AS
SELECT * from autores natural join libros natural join escribe
ORDER BY id_a,isbn;

---------------------------------------- Para usuario Admin (User postgres) -----------------------------------------

-- Estas vistas las definimos para el usuario Admin de la base de datos en general.
set search_path = ingenieria, public;

-- Vista para la lista de asignaturas con estudiantes
CREATE VIEW listado_facultad_asig AS
SELECT cod_a, nom_a, grupo, cod_e, nom_e FROM ingenieria.estudiantes_fac natural join ingenieria.inscribe natural join ingenieria.asignaturas
ORDER BY cod_a,nom_a,grupo;

---------------------------------------------------------------------------------------------------------------------
-------------------------------------------------- CARGA DE DATOS ---------------------------------------------------
---------------------------------------------------------------------------------------------------------------------

set search_path = ingenieria, public;

COPY Profesores
FROM 'C:\Users\Public\Ingenieria\Profesores.csv'
DELIMITER ';'
CSV HEADER;

-------------------------------------------------------- Por carrera ------------------------------------------------

set search_path = "Ingenieria de Sistemas", public;
COPY Estudiantes
FROM 'C:\Users\Public\Ingenieria\Sistemas\Estudiantes.csv'
DELIMITER ';'
CSV HEADER;

-------------------------------------------------------- Biblioteca --------------------------------------------------------

set search_path = biblioteca, public;

COPY Libros
FROM 'C:\Users\Public\Biblioteca\Libros.csv'
DELIMITER ';'
CSV HEADER;

---------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------- ROLES ------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------

set search_path = ingenieria, public;

-- Rol estudiantes
create role estudiantesIng;
grant usage on schema ingenieria to estudiantesIng;
grant select on ingenieria.notasEstud to estudiantesIng; -- notasEstud es una vista

-- Rol profesores
create role profesoresIng;
grant usage on schema ingenieria to profesoresIng; 
grant select, update (profesion, nom_p, dir_p, tel_p) on ingenieria.info_profesores to profesoresIng; -- infoProfesores es una vista

-------------------------------------------------------- Biblioteca -------------------------------------------------
set search_path = biblioteca, public;

create user bibliotecau with password 'bibliotecau';
grant usage on schema biblioteca to bibliotecau;
grant usage on schema ingenieria to bibliotecau;		  

GRANT SELECT ON ingenieria.estudiantes_fac TO bibliotecau;
GRANT SELECT ON biblioteca.presta TO bibliotecau;

GRANT USAGE ON SCHEMA biblioteca to profesoresIng;
GRANT SELECT ON biblioteca.autores TO profesoresIng;
GRANT SELECT ON biblioteca.libros TO profesoresIng;

GRANT USAGE ON SCHEMA biblioteca to estudiantesIng;
GRANT SELECT ON biblioteca.autores TO estudiantesIng;

---------------------------------------------------------------------------------------------------------------------
------------------------------------------ TRIGGERS Y PROCEDIMIENTOS ------------------------------------------------
---------------------------------------------------------------------------------------------------------------------

set search_path = ingenieria, public;

-- Funcion para crear los usuarios de estudiantes
CREATE OR REPLACE FUNCTION crear_usuarios() RETURNS void AS
$BODY$
DECLARE f ingenieria.estudiantes_fac%rowtype;
DECLARE r ingenieria.profesores%rowtype;
BEGIN
	FOR f IN SELECT * FROM ingenieria.estudiantes_fac
	LOOP
		if (f.cod_e::text not in (select usename from pg_user)) then
			execute 'create user "'||f.cod_e||'" with password '||''''||f.cod_e||'''';
			execute 'grant estudiantesIng to "'||f.cod_e||'"'; 
		end if;
	END LOOP;
	FOR r IN SELECT * FROM ingenieria.profesores
	LOOP
		if (r.id_p::text not in (select usename from pg_user)) then
			execute 'create user "'||r.id_p||'" with password '||''''||r.id_p||'''';
			execute 'grant profesoresIng to "'||r.id_p||'"'; 
		end if;
	END LOOP;
RETURN;
END
$BODY$
LANGUAGE 'plpgsql' ;

-- Funcion que permite al profesor actualizar unicamente las notas de sus estudiantes 
create or replace function update_est() returns trigger as $update_est$
declare
begin
  update ingenieria.inscribe set 
  n1 = NEW.n1, n2 = NEW.n2, n3 = NEW.n3 
  where cod_e = OLD.cod_e and cod_a = OLD.cod_a and cod_e in (select cod_e from ingenieria.lista_estudiantes where id_p::text = current_user);
  RETURN NEW;
end;
$update_est$
language plpgsql;

-- Trigger asociado al update sobre inscribe
create trigger update_est_trg
instead of update on lista_estudiantes
for each row execute procedure update_est();
								 
-- Validacion insert en Inscribe
CREATE OR REPLACE FUNCTION insert_inscribe() RETURNS
TRIGGER AS $insert_inscribe$
BEGIN
	IF (new.cod_e in (select cod_e from ingenieria.estudiantes_fac)) THEN
		RETURN NEW;
	ELSE 
		RETURN NULL;
	END IF;
END;
$insert_inscribe$ LANGUAGE plpgsql;

-- Trigger asociado al insert en la tabla inscribe
CREATE TRIGGER insert_inscribe_trg BEFORE
UPDATE OR INSERT
ON inscribe FOR EACH row
EXECUTE PROCEDURE insert_inscribe();
		
--*************************************************--
					  
-- Ejecutar
set search_path = ingenieria, public;
select crear_usuarios();