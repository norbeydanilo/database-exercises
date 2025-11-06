set search_path = ingenieria, public;

-- Eliminar y revocar

REVOKE ALL PRIVILEGES ON ALL TABLES IN SCHEMA ingenieria FROM estudiantesIng;
REVOKE ALL PRIVILEGES ON ALL TABLES IN SCHEMA biblioteca FROM estudiantesIng;
REVOKE ALL PRIVILEGES ON ALL TABLES IN SCHEMA ingenieria FROM profesoresIng;
REVOKE ALL PRIVILEGES ON ALL TABLES IN SCHEMA biblioteca FROM profesoresIng;
REVOKE ALL PRIVILEGES ON ALL TABLES IN SCHEMA biblioteca FROM bibliotecau;
REVOKE ALL PRIVILEGES ON ALL TABLES IN SCHEMA ingenieria FROM bibliotecau;

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

-- Para verificar roles

SELECT rolname FROM pg_roles WHERE pg_has_role('11001', oid, 'member');
select rolname from pg_roles;

show search_path;
set search_path to ingenieria;