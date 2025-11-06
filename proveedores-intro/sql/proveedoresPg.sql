-- ---------------------------------------------------------------------
-- Eliminar base de datos si existe
-- ---------------------------------------------------------------------
DROP DATABASE IF EXISTS proveedores;

-- ---------------------------------------------------------------------
-- Crear base de datos
-- ---------------------------------------------------------------------
CREATE DATABASE proveedores with encoding 'utf8mb4';

-- Tabla categoria
CREATE TABLE categoria (
    cod_categoria INT PRIMARY KEY,
    nombre VARCHAR(20) NOT NULL
);

-- Tabla pieza
CREATE TABLE pieza (
    cod_pieza INT PRIMARY KEY,
    nombre VARCHAR(20) NOT NULL,
    color VARCHAR(15) NOT NULL,
    precio NUMERIC(10, 2) NOT NULL CHECK (precio > 0),
    cod_categoria INT NOT NULL,
    FOREIGN KEY (cod_categoria) REFERENCES categoria(cod_categoria) ON DELETE CASCADE
);

-- Tabla proveedor
CREATE TABLE proveedor (
    cod_prov INT PRIMARY KEY,
    nombre VARCHAR(20) NOT NULL,
    direccion VARCHAR(40) NOT NULL,
    ciudad VARCHAR(30) NOT NULL,
    departamento VARCHAR(20) NOT NULL,
    tipo VARCHAR(10) NOT NULL CHECK (tipo IN ('Natural', 'Jurídica'))
);

-- Tabla pnatural
CREATE TABLE pnatural (
    cod_prov INT PRIMARY KEY,
    atributo_x VARCHAR(10) NOT NULL,
    FOREIGN KEY (cod_prov) REFERENCES proveedor(cod_prov) ON DELETE CASCADE
);

-- Tabla pjuridica
CREATE TABLE pjuridica (
    cod_prov INT PRIMARY KEY,
    atributo_y VARCHAR(10) NOT NULL,
    FOREIGN KEY (cod_prov) REFERENCES proveedor(cod_prov) ON DELETE CASCADE
);

-- Tabla suministra
CREATE TABLE suministra (
    cod_prov INT NOT NULL,
    cod_pieza INT NOT NULL,
    fecha_hora TIMESTAMP(6) NOT NULL,
    cantidad INT NOT NULL CHECK (cantidad > 0),
    PRIMARY KEY (cod_prov, cod_pieza, fecha_hora),
    FOREIGN KEY (cod_prov) REFERENCES proveedor(cod_prov) ON DELETE CASCADE,
    FOREIGN KEY (cod_pieza) REFERENCES pieza(cod_pieza) ON DELETE CASCADE
);

-- Ejemplo de DDL adicional -- NO EJECUTAR PARA LA CREACIÓN

-- DROP
DROP TABLE IF EXISTS suministra;

-- ALTER
ALTER TABLE categoria ADD COLUMN descripcion VARCHAR(255) NOT NULL;
ALTER TABLE proveedor ADD COLUMN telefono VARCHAR(15);

ALTER TABLE categoria DROP COLUMN descripcion;
ALTER TABLE proveedor DROP COLUMN telefono;

-- CONSTRAINTS

-- Descripción de cómo se creó la tabla

-- Desde la interfaz de pgAdmin

-- Servers → tu servidor → Databases → <tu_db> → Schemas → public → Tables
-- Clic derecho sobre la tabla → Scripts → CREATE Script
-- Esto muestra el SQL con el que PostgreSQL generaría la tabla.

-- Usando Query Tool

-- SELECT pg_get_tabledef('nombre_tabla'::regclass);

-- Primero, elimina la clave foránea existente
ALTER TABLE pnatural
    DROP CONSTRAINT IF EXISTS pnatural_cod_prov_fkey;

-- Luego, agrega la clave foránea con ON DELETE CASCADE y ON UPDATE CASCADE
ALTER TABLE pnatural
    ADD CONSTRAINT pnatural_cod_prov_fkey
    FOREIGN KEY (cod_prov)
    REFERENCES proveedor(cod_prov)
    ON DELETE CASCADE
    ON UPDATE CASCADE;

-- Para tabla suministra
ALTER TABLE suministra
    DROP CONSTRAINT IF EXISTS suministra_cod_prov_fkey;

ALTER TABLE suministra
    ADD CONSTRAINT suministra_cod_prov_fkey
    FOREIGN KEY (cod_prov)
    REFERENCES proveedor(cod_prov)
    ON DELETE CASCADE
    ON UPDATE CASCADE;
