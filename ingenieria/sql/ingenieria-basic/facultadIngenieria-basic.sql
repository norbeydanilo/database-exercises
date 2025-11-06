------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------- DDL -----------------------------------------------------------------
---------------------------------- Creación de los esquemas y tablas (con constraints) ---------------------------------------
------------------------------------------------------------------------------------------------------------------------------

-- El método COPY no funciona en la extensión
-- El fichero completo ejecuta desde pgadmin
--CREATE DATABASE university;

CREATE SCHEMA ingenieria;
CREATE SCHEMA "Ingenieria de Sistemas";
CREATE SCHEMA "Ingenieria Catastral";
CREATE SCHEMA "Ingenieria Industrial";
CREATE SCHEMA "Ingenieria Electrica";
CREATE SCHEMA "Ingenieria Electronica";
CREATE SCHEMA biblioteca;

set search_path = ingenieria, public;
-- show search_path;

CREATE TABLE Profesores(
	id_p smallint PRIMARY KEY CHECK (id_p>0),
	profesion varchar(11) NOT NULL,
	nom_p varchar(14) NOT NULL,
	dir_p varchar(14) NOT NULL,
	tel_p int NOT NULL CHECK (tel_p>0)
);

CREATE TABLE Carreras(
	id_carr smallint PRIMARY KEY CHECK (id_carr>0),
	nom_carr varchar(25) NOT NULL,
	reg_calif int NOT NULL CHECK (reg_calif>0)
);

CREATE TABLE Asignaturas(
	cod_a smallint PRIMARY KEY CHECK (cod_a>0),
	nom_a varchar(40) NOT NULL,
	creditos smallint NOT NULL CHECK (creditos>0),
	int_h smallint NOT NULL CHECK (int_h>0)
);

CREATE TABLE Imparte(
	id_p smallint,
	cod_a smallint,
	grupo smallint CHECK (grupo>0),
	horario varchar(30) NOT NULL,
	constraint pk_imp primary key (id_p, cod_a, grupo),
	constraint fk_impProf foreign key (id_p) references profesores(id_p),
	constraint fk_impCoda foreign key (cod_a) references asignaturas(cod_a)
);

CREATE TABLE Inscribe(
	id_p smallint,
	cod_a smallint,
	grupo smallint,
	cod_e int,
	n1 float(1) check (n1 between 0 and 5) default 0,
	n2 float(1) check (n2 between 0 and 5) default 0,
	n3 float(1) check (n3 between 0 and 5) default 0,
	constraint uk_estasig unique (cod_e, cod_a),
	constraint pk_ins primary key (cod_e, id_p, cod_a, grupo),
	constraint fk_insimp foreign key (id_p, cod_a, grupo) references imparte(id_p, cod_a, grupo)
);

CREATE TABLE Referencia(
	cod_a smallint,
	isbn integer,
	constraint pk_ref primary key (cod_a, isbn),
	constraint fk_refasig foreign key (cod_a) references asignaturas(cod_a)
);

------------------------------------------------- Estudiantes por carrera -------------------------------------------

set search_path = "Ingenieria de Sistemas", public;
-- show search_path;

CREATE TABLE Estudiantes (
	cod_e int PRIMARY KEY CHECK (cod_e>0),
	nom_e varchar(15) NOT NULL,
	dir_e varchar(15) NOT NULL,
	tel_e int NOT NULL CHECK (tel_e>0),
	id_carr smallint NOT NULL,
	fech_nac date NOT NULL,
	CONSTRAINT fk_estcarr foreign key (id_carr) references ingenieria.carreras(id_carr)
);

set search_path = "Ingenieria Catastral", public;

CREATE TABLE Estudiantes (
	cod_e int PRIMARY KEY CHECK (cod_e>0),
	nom_e varchar(15) NOT NULL,
	dir_e varchar(15) NOT NULL,
	tel_e int NOT NULL CHECK (tel_e>0),
	id_carr smallint NOT NULL,
	fech_nac date NOT NULL,
	CONSTRAINT fk_estcarr foreign key (id_carr) references ingenieria.carreras(id_carr)
);

set search_path = "Ingenieria Industrial", public;

CREATE TABLE Estudiantes (
	cod_e int PRIMARY KEY CHECK (cod_e>0),
	nom_e varchar(15) NOT NULL,
	dir_e varchar(15) NOT NULL,
	tel_e int NOT NULL CHECK (tel_e>0),
	id_carr smallint NOT NULL,
	fech_nac date NOT NULL,
	CONSTRAINT fk_estcarr foreign key (id_carr) references ingenieria.carreras(id_carr)
);

set search_path = "Ingenieria Electrica", public;

CREATE TABLE Estudiantes (
	cod_e int PRIMARY KEY CHECK (cod_e>0),
	nom_e varchar(15) NOT NULL,
	dir_e varchar(15) NOT NULL,
	tel_e int NOT NULL CHECK (tel_e>0),
	id_carr smallint NOT NULL,
	fech_nac date NOT NULL,
	CONSTRAINT fk_estcarr foreign key (id_carr) references ingenieria.carreras(id_carr)
);

set search_path = "Ingenieria Electronica", public;

CREATE TABLE Estudiantes (
	cod_e int PRIMARY KEY CHECK (cod_e>0),
	nom_e varchar(15) NOT NULL,
	dir_e varchar(15) NOT NULL,
	tel_e int NOT NULL CHECK (tel_e>0),
	id_carr smallint NOT NULL,
	fech_nac date NOT NULL,
	CONSTRAINT fk_estcarr foreign key (id_carr) references ingenieria.carreras(id_carr)
);

-------------------------------------------------------- Biblioteca -------------------------------------------------

set search_path = biblioteca, public;
-- show search_path;

CREATE TABLE Libros(
	isbn integer PRIMARY KEY check (isbn>0),
	titulo varchar(11) NOT NULL,
	edicion smallint NOT NULL,
	editorial varchar(11) NOT NULL
);

CREATE TABLE Autores(
	id_a smallint PRIMARY KEY check (id_a>0),
	nom_autor varchar(11) NOT NULL,
	nacionalidad varchar(20) NOT NULL
);

CREATE TABLE Ejemplares(
	isbn integer,
	num_ej smallint,
	constraint pk_ejp primary key (isbn, num_ej),
	constraint fk_ejplib foreign key (isbn) references libros(isbn)
);

CREATE TABLE Escribe(
	isbn integer,
	id_a smallint,
	constraint pk_esc primary key (isbn,id_a),
	constraint fk_esclib foreign key (isbn) references libros(isbn),
	constraint fk_escaut foreign key (id_a) references autores(id_a)
);

CREATE TABLE Presta(
	cod_e int,
	isbn integer,
	num_ej smallint,
	fech_p TIMESTAMP DEFAULT now(),
	fech_d TIMESTAMP,
	constraint pk_prest primary key (cod_e, isbn, num_ej, fech_p),
	constraint fk_prestEjemp foreign key (isbn, num_ej) references ejemplares(isbn, num_ej)
);

---------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------- VISTAS -----------------------------------------------------
---------------------------------------------------------------------------------------------------------------------

set search_path = ingenieria, public;

-- Vista que permite consultar la información del profesor
create view info_profesores as 
select *
from profesores
where id_p::text=current_user;

-- Vista estudiantes de la facultad
create view estudiantes_fac as
select cod_e, nom_e, id_carr from "Ingenieria de Sistemas".estudiantes 
union 
select cod_e, nom_e, id_carr from "Ingenieria Catastral".estudiantes
union 
select cod_e, nom_e, id_carr from "Ingenieria Industrial".estudiantes
union 
select cod_e, nom_e, id_carr from "Ingenieria Electrica".estudiantes
union 
select cod_e, nom_e, id_carr from "Ingenieria Electronica".estudiantes;

-- Vista que permite consultar la lista de estudiantes de sus cursos (profesor)
create view lista_estudiantes as
select cod_a, nom_a, grupo, cod_e, nom_e, n1, n2, n3, 
(COALESCE(n1,0)*.35+COALESCE(n2,0)*.35+COALESCE(n3,0)*.3)::real as definitiva
from estudiantes_fac natural join inscribe natural join asignaturas
where id_p::TEXT = current_user
order by cod_a, grupo, cod_e;

-- Vista para que el estudiante pueda consultar sus notas
create view notasEstud as
select cod_e, nom_e, cod_a, nom_a, n1, n2, n3,
	(COALESCE(n1,0)*.35+COALESCE(n2,0)*.35+COALESCE(n3,0)*.3) as definitiva,
	CASE WHEN (COALESCE(n1,0)*.35+COALESCE(n2,0)*.35+COALESCE(n3,0)*.3)<3.0 THEN 'Reprobado'
		ELSE 'Aprobado'
	END as concepto
from estudiantes_fac natural join inscribe natural join asignaturas
where cod_e::text=current_user;

-------------------------------------------------------- Biblioteca -------------------------------------------------

set search_path = biblioteca, public;

-- Vista para consultar la tabla escribe en la facultad de ingeniería
CREATE VIEW consulta_escribe AS
SELECT * from autores natural join libros natural join escribe
ORDER BY id_a,isbn;

-- Vista para consultar prestamos estudiante de la facultad de ingeniería
CREATE VIEW consultar_prest_est AS
SELECT * FROM presta
WHERE cod_e::text = current_user;

---------------------------------------- Para usuario Admin (User postgres) -----------------------------------------

set search_path = ingenieria, public;

-- Vista para la lista de asignaturas con estudiantes
CREATE VIEW listado_facultad_asig AS
SELECT cod_a, nom_a, grupo, cod_e, nom_e FROM ingenieria.estudiantes_fac natural join ingenieria.inscribe natural join ingenieria.asignaturas
ORDER BY cod_a,nom_a,grupo;

-- Vista para la lista de asignaturas con estudiantes y notas por grupos
CREATE VIEW listado_facultad_notas AS
SELECT cod_a, nom_a, grupo, cod_e, nom_e, n1, n2, n3, (COALESCE(n1,0)*.35+COALESCE(n2,0)*.35+COALESCE(n3,0)*.3)::real as definitiva
FROM ingenieria.estudiantes_fac natural join ingenieria.inscribe natural join ingenieria.asignaturas
ORDER BY cod_a,nom_a,grupo;

-- Vista para la lista de prestamos
CREATE VIEW prestamos_universidad AS
SELECT * FROM biblioteca.presta natural join biblioteca.libros ORDER BY cod_e,isbn,fech_p;

---------------------------------------------------------------------------------------------------------------------
-------------------------------------------------- CARGA DE DATOS ---------------------------------------------------
---------------------------------------------------------------------------------------------------------------------

set search_path = ingenieria, public;

COPY Profesores
FROM 'C:\Users\Public\Ingenieria\Profesores.csv'
DELIMITER ';'
CSV HEADER;

COPY Carreras
FROM 'C:\Users\Public\Ingenieria\Carreras.csv'
DELIMITER ';'
CSV HEADER;

COPY Asignaturas
FROM 'C:\Users\Public\Ingenieria\Asignaturas.csv'
DELIMITER ';'
CSV HEADER;

COPY Imparte
FROM 'C:\Users\Public\Ingenieria\Imparte.csv'
DELIMITER ';'
CSV HEADER;

COPY Referencia
FROM 'C:\Users\Public\Ingenieria\Referencia.csv'
DELIMITER ';'
CSV HEADER;

COPY Inscribe
FROM 'C:\Users\Public\Ingenieria\Inscribe.csv'
DELIMITER ';'
CSV HEADER;

-------------------------------------------------------- Por carrera ------------------------------------------------

set search_path = "Ingenieria de Sistemas", public;
COPY Estudiantes
FROM 'C:\Users\Public\Ingenieria\Sistemas\Estudiantes.csv'
DELIMITER ';'
CSV HEADER; 	

set search_path = "Ingenieria Catastral", public;
COPY Estudiantes
FROM 'C:\Users\Public\Ingenieria\Catastral\Estudiantes.csv'
DELIMITER ';'
CSV HEADER;

set search_path = "Ingenieria Industrial", public;
COPY Estudiantes
FROM 'C:\Users\Public\Ingenieria\Industrial\Estudiantes.csv'
DELIMITER ';'
CSV HEADER;

set search_path = "Ingenieria Electrica", public;
COPY Estudiantes
FROM 'C:\Users\Public\Ingenieria\Electrica\Estudiantes.csv'
DELIMITER ';'
CSV HEADER;

set search_path = "Ingenieria Electronica", public;
COPY Estudiantes
FROM 'C:\Users\Public\Ingenieria\Electronica\Estudiantes.csv'
DELIMITER ';'
CSV HEADER;
				
-------------------------------------------------------- Biblioteca --------------------------------------------------------

set search_path = biblioteca, public;

COPY Libros
FROM 'C:\Users\Public\Biblioteca\Libros.csv'
DELIMITER ';'
CSV HEADER;

COPY Autores
FROM 'C:\Users\Public\Biblioteca\Autores.csv'
DELIMITER ';'
CSV HEADER;

COPY Ejemplares
FROM 'C:\Users\Public\Biblioteca\Ejemplares.csv'
DELIMITER ';'
CSV HEADER;

COPY Escribe
FROM 'C:\Users\Public\Biblioteca\Escribe.csv'
DELIMITER ';'
CSV HEADER;

COPY Presta
FROM 'C:\Users\Public\Biblioteca\Presta.csv'
DELIMITER ';'
CSV HEADER;

---------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------- ROLES ------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------

set search_path = ingenieria, public;

-- Rol estudiantes
create role estudiantesIng;
grant usage on schema ingenieria to estudiantesIng;
grant select on ingenieria.notasEstud to estudiantesIng;

-- Rol profesores
create role profesoresIng;
grant usage on schema ingenieria to profesoresIng; 
grant select, update (profesion, nom_p, dir_p, tel_p) on ingenieria.info_profesores to profesoresIng;
grant select, update (n1,n2,n3) on ingenieria.lista_estudiantes to profesoresIng;
grant select on ingenieria.estudiantes_fac to profesoresIng;
grant select, update (n1,n2,n3) on ingenieria.inscribe to profesoresIng;

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
GRANT SELECT ON biblioteca.consulta_escribe TO profesoresIng;

GRANT USAGE ON SCHEMA biblioteca to estudiantesIng;
GRANT SELECT ON biblioteca.autores TO estudiantesIng;
GRANT SELECT ON biblioteca.libros TO estudiantesIng;
GRANT SELECT ON biblioteca.consulta_escribe TO estudiantesIng;
GRANT SELECT ON biblioteca.consultar_prest_est TO estudiantesIng;

---------------------------------------------------------------------------------------------------------------------
------------------------------------------ TRIGGERS Y PROCEDIMIENTOS ------------------------------------------------
---------------------------------------------------------------------------------------------------------------------

set search_path = ingenieria, public;

-- Funcion para crear los usuarios de estudiantes y profesores
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
	-- Si NEW.cod_e NO está en la vista, detengo la inserción con error:
  IF NOT ( NEW.cod_e IN (SELECT cod_e FROM ingenieria.estudiantes_fac) ) THEN
    RAISE EXCEPTION 'No existe estudiante con cod_e = % en ninguna de las tablas Estudiantes', NEW.cod_e;
  END IF;

  -- Si llegó aquí, el estudiante existe en la vista, dejo pasar la inserción
  RETURN NEW;
END;
$insert_inscribe$ LANGUAGE plpgsql;

-- Trigger asociado al insert en la tabla inscribe
CREATE TRIGGER insert_inscribe_trg BEFORE
UPDATE OR INSERT
ON ingenieria.inscribe FOR EACH row
EXECUTE PROCEDURE insert_inscribe();
		
--*************************************************--
					  
-- Ejecutar
set search_path = ingenieria, public;
select crear_usuarios();