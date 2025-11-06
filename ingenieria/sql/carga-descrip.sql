-- DROP database IF EXISTS universidad;
-- DROP schema ingenieria CASCADE;

create database universidad;

-- connect to universidad // open database pgAdmin -- esto para crear schemas en universidad
-- psql -U postgres -h 127.0.0.1 -p 5432 -d universidad

-- En un .sql diferente ejecutar las demás líneas: psql -d universidad -f script.sql
-- O hacerlo manual conectándose y ejecutando.

create schema ingenieria;

show search_path;

set search_path to ingenieria;

create table ingenieria.estudiantes (
    cod_e bigint,
    nom_e varchar(70),
    dir_e varchar(70),
    tel_e bigint,
    cod_carr int,
    f_nac date
);

create table ingenieria.asignaturas (
    cod_a int,
    nom_a varchar(70),
    ih int,
    cred int
);

create table ingenieria.autores (id_a int, nom_aut varchar(70));

create table ingenieria.carreras (
    cod_carr int,
    nom_carr varchar(70)
);

create table ingenieria.ejemplares (num_ej int, isbn int);

create table ingenieria.escribe (id_a int, isbn int);

create table ingenieria.imparte (
    id_p bigint,
    cod_a int,
    grupo int,
    horario varchar(50)
);

create table ingenieria.inscribe (
    cod_e bigint,
    id_p bigint,
    cod_a int,
    grupo int,
    n1 decimal(4, 2),
    n2 decimal(4, 2),
    n3 decimal(4, 2)
);

create table ingenieria.libros (
    isbn int,
    titulo varchar(50),
    edicion int
);

create table ingenieria.presta (
    cod_e bigint,
    isbn int,
    num_ej int,
    fecha_p date,
    fecha_d date
);

create table ingenieria.profesores (
    id_p bigint,
    nom_p varchar(70),
    profesion varchar(70),
    tel_p bigint
);

create table ingenieria.referencia (cod_a int, isbn int);

-- Carga de datos en las tablas

copy ingenieria.estudiantes (
    cod_e,
    nom_e,
    dir_e,
    tel_e,
    cod_carr,
    f_nac
)
from 'C:\Users\Public\Estudiantes.csv' csv DELIMITER ';' HEADER;

copy ingenieria.asignaturas (cod_a, nom_a, ih, cred)
from 'C:\Users\Public\Asignaturas.csv' csv DELIMITER ';' HEADER;

copy ingenieria.autores (id_a, nom_aut)
from 'C:\Users\Public\Autores.csv' csv DELIMITER ';' HEADER;

copy ingenieria.carreras (cod_carr, nom_carr)
from 'C:\Users\Public\Carreras.csv' csv DELIMITER ';' HEADER;

copy ingenieria.ejemplares (num_ej, isbn)
from 'C:\Users\Public\Ejemplares.csv' csv DELIMITER ';' HEADER;

copy ingenieria.escribe (id_a, isbn)
from 'C:\Users\Public\Escribe.csv' csv DELIMITER ';' HEADER;

copy ingenieria.imparte (id_p, cod_a, grupo, horario)
from 'C:\Users\Public\Imparte.csv' csv DELIMITER ';' HEADER;

copy ingenieria.inscribe (
    cod_e,
    id_p,
    cod_a,
    grupo,
    n1,
    n2,
    n3
)
from 'C:\Users\Public\Inscribe.csv' csv DELIMITER ';' HEADER;

copy ingenieria.libros (isbn, titulo, edicion)
from 'C:\Users\Public\Libros.csv' csv DELIMITER ';' HEADER;

copy ingenieria.presta (
    cod_e,
    isbn,
    num_ej,
    fecha_p,
    fecha_d
)
from 'C:\Users\Public\Presta.csv' csv DELIMITER ';' HEADER;

copy ingenieria.profesores (id_p, nom_p, profesion, tel_p)
from 'C:\Users\Public\Profesores.csv' csv DELIMITER ';' HEADER;

copy ingenieria.referencia (cod_a, isbn)
from 'C:\Users\Public\Referencia.csv' csv DELIMITER ';' HEADER;