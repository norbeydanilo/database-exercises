/* =========================================================
   DCL – Control de Acceso en PostgreSQL con PRUEBAS
   Proveedores – Ejemplo completo
========================================================= */

------------------------------------------------------------
-- 1) Crear un rol general (sin LOGIN)
------------------------------------------------------------
CREATE ROLE rol_proveedores;


------------------------------------------------------------
-- 2) Crear usuario con contraseña
------------------------------------------------------------
CREATE USER usuario1 WITH PASSWORD '1234';


------------------------------------------------------------
-- 3) Asignar el rol al usuario
------------------------------------------------------------
GRANT rol_proveedores TO usuario1;



/* =========================================================
   OTORGAR PRIVILEGIOS AL ROL
========================================================= */

------------------------------------------------------------
-- Otorgar permisos CRUD al rol sobre tablas
------------------------------------------------------------
GRANT SELECT, INSERT, UPDATE, DELETE
ON categoria, pieza, proveedor, pnatural, pjuridica, suministra
TO rol_proveedores;



/* =========================================================
   PRUEBAS – SET SESSION AUTHORIZATION
========================================================= */

------------------------------------------------------------
-- Cambiar sesión a usuario1
------------------------------------------------------------
SET SESSION AUTHORIZATION 'usuario1';

-- Verificar usuario de sesión vs usuario activo
SELECT SESSION_USER, CURRENT_USER;

-- SELECT permitido
SELECT * FROM categoria;

-- INSERT permitido
INSERT INTO categoria (cod_categoria, nombre)
VALUES (100, 'Madera');

-- UPDATE permitido
UPDATE categoria
SET nombre = 'Madera fina'
WHERE cod_categoria = 100;

-- DELETE permitido (por ahora)
DELETE FROM categoria WHERE cod_categoria = 100;

-- Salir
RESET SESSION AUTHORIZATION;



/* =========================================================
   REVOCAR PERMISOS
========================================================= */

------------------------------------------------------------
-- Revocar DELETE sobre categoria
------------------------------------------------------------
REVOKE DELETE ON categoria FROM rol_proveedores;



/* =========================================================
   PRUEBAS TRAS REVOCACIÓN
========================================================= */

SET SESSION AUTHORIZATION 'usuario1';
SELECT SESSION_USER, CURRENT_USER;

-- SELECT permitido
SELECT * FROM categoria;

-- UPDATE permitido
UPDATE categoria
SET nombre = 'Metales'
WHERE cod_categoria = 1;

-- INSERT permitido
INSERT INTO categoria (cod_categoria, nombre)
VALUES (200, 'Plástico');

-- DELETE no permitido (debe fallar)
DELETE FROM categoria WHERE cod_categoria = 200;

RESET SESSION AUTHORIZATION;



/* =========================================================
   VISTAS
========================================================= */

------------------------------------------------------------
-- Crear una vista simple
------------------------------------------------------------
CREATE OR REPLACE VIEW vista_proveedores AS
SELECT cod_prov, nombre, ciudad, departamento
FROM proveedor;


------------------------------------------------------------
-- Otorgar SELECT sobre la vista
------------------------------------------------------------
GRANT SELECT ON vista_proveedores TO rol_proveedores;



/* =========================================================
   PRUEBAS SOBRE LA VISTA
========================================================= */

SET SESSION AUTHORIZATION 'usuario1';
SELECT SESSION_USER, CURRENT_USER;

-- SELECT permitido
SELECT * FROM vista_proveedores;

-- UPDATE no permitido (debe fallar)
UPDATE vista_proveedores
SET ciudad = 'Bogotá'
WHERE cod_prov = 1;

RESET SESSION AUTHORIZATION;


------------------------------------------------------------
-- Revocar SELECT sobre vista
------------------------------------------------------------
REVOKE SELECT ON vista_proveedores FROM rol_proveedores;



/* =========================================================
   PRUEBAS TRAS REVOKE
========================================================= */

SET SESSION AUTHORIZATION 'usuario1';
SELECT SESSION_USER, CURRENT_USER;

-- SELECT no permitido (debe fallar)
SELECT * FROM vista_proveedores;

RESET SESSION AUTHORIZATION;



/* =========================================================
   ROL DE SOLO LECTURA
========================================================= */

------------------------------------------------------------
-- Crear rol de solo lectura
------------------------------------------------------------
CREATE ROLE rol_lectura;

-- Otorgar SELECT sobre todas las tablas del esquema public
GRANT SELECT
ON ALL TABLES IN SCHEMA public
TO rol_lectura;


------------------------------------------------------------
-- Crear usuario lectura y asignar rol
------------------------------------------------------------
CREATE USER usuario_lectura WITH PASSWORD 'abc123';
GRANT rol_lectura TO usuario_lectura;


/* =========================================================
   PRUEBAS usuario_lectura
========================================================= */

SET SESSION AUTHORIZATION 'usuario_lectura';
SELECT SESSION_USER, CURRENT_USER;

-- SELECT permitido
SELECT * FROM proveedor;

-- INSERT no permitido (debe fallar)
INSERT INTO proveedor (cod_prov, nombre, direccion, ciudad, departamento, tipo)
VALUES (500, 'Probando', 'Calle', 'Bogotá', 'Cundinamarca', 'Natural');

RESET SESSION AUTHORIZATION;



/* =========================================================
   ROL ADMIN SOBRE TABLA
========================================================= */

------------------------------------------------------------
-- Rol administrador sobre tabla pieza
------------------------------------------------------------
CREATE ROLE rol_admin_pieza;
GRANT ALL PRIVILEGES ON pieza TO rol_admin_pieza;


------------------------------------------------------------
-- Crear usuario jefe_taller y asignar rol
------------------------------------------------------------
CREATE USER jefe_taller WITH PASSWORD 'pass';
GRANT rol_admin_pieza TO jefe_taller;


/* =========================================================
   PRUEBAS jefe_taller
========================================================= */

SET SESSION AUTHORIZATION 'jefe_taller';
SELECT SESSION_USER, CURRENT_USER;

-- INSERT permitido
INSERT INTO pieza (cod_pieza, nombre, color, precio, cod_categoria)
VALUES (900, 'Motor', 'Negro', 4500000, 1);

-- DELETE permitido
DELETE FROM pieza WHERE cod_pieza = 900;

RESET SESSION AUTHORIZATION;



/* =========================================================
   WITH GRANT OPTION
========================================================= */

------------------------------------------------------------
-- Ejemplo: permitir que usuario1
-- transfiera permisos a otros
------------------------------------------------------------
GRANT SELECT ON proveedor TO usuario1 WITH GRANT OPTION;

-- Probar como usuario1
SET SESSION AUTHORIZATION 'usuario1';
SELECT SESSION_USER, CURRENT_USER;

-- usuario1 ahora puede otorgar permisos a otros
GRANT SELECT ON proveedor TO usuario_lectura;

RESET SESSION AUTHORIZATION;

------------------------------------------------------------
-- Quitar WITH GRANT OPTION
------------------------------------------------------------
REVOKE SELECT ON proveedor FROM usuario1;



/* =========================================================
   REVOCAR ROLES A USUARIOS
========================================================= */

REVOKE rol_proveedores FROM usuario1;
REVOKE rol_lectura FROM usuario_lectura;
REVOKE rol_admin_pieza FROM jefe_taller;



/* =========================================================
   BORRADO
========================================================= */

DROP USER usuario1;
DROP USER usuario_lectura;
DROP USER jefe_taller;

DROP ROLE rol_proveedores;
DROP ROLE rol_lectura;
DROP ROLE rol_admin_pieza;
