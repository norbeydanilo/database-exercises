-- Elimina la base de datos 'proveedores' si existe

DROP DATABASE IF EXISTS proveedores;

-- Crea la base de datos 'proveedores' si no existe

CREATE DATABASE IF NOT EXISTS proveedores CHARACTER SET utf8mb4;

-- Selecciona la base de datos 'proveedores' para usarla

USE proveedores;

-- Crea la tabla 'categoria' con los campos 'cod_categoria' y 'nombre'

CREATE TABLE
    categoria (
        cod_categoria INT NOT NULL,
        nombre VARCHAR(20) NOT NULL,
        PRIMARY KEY (cod_categoria)
    );

-- Crea la tabla 'pieza' con los campos 'cod_pieza', 'nombre', 'color', 'precio' y 'cod_categoria'

CREATE TABLE
    pieza (
        cod_pieza INT NOT NULL,
        nombre VARCHAR(20) NOT NULL,
        color VARCHAR(15) NOT NULL,
        precio DECIMAL(10, 2) NOT NULL CHECK (precio > 0),
        cod_categoria INT NOT NULL,
        PRIMARY KEY (cod_pieza),
        FOREIGN KEY (cod_categoria) REFERENCES categoria(cod_categoria) ON DELETE CASCADE
    );

-- Crea la tabla 'proveedor' con los campos 'cod_prov', 'nombre', 'direccion', 'ciudad', 'departamento' y 'tipo'

CREATE TABLE
    proveedor (
        cod_prov INT NOT NULL,
        nombre VARCHAR(20) NOT NULL,
        direccion VARCHAR(40) NOT NULL,
        ciudad VARCHAR(30) NOT NULL,
        departamento VARCHAR(20) NOT NULL,
        tipo ENUM ('Natural', 'Jurídica') NOT NULL,
        PRIMARY KEY (cod_prov)
    );

-- Crea la tabla 'pnatural' con los campos 'cod_prov' y 'atributo_x'

CREATE TABLE
    pnatural (
        cod_prov INT NOT NULL,
        atributo_x VARCHAR(10) NOT NULL,
        PRIMARY KEY (cod_prov),
        FOREIGN KEY (cod_prov) REFERENCES proveedor(cod_prov) ON DELETE CASCADE
    );

-- Crea la tabla 'pjuridica' con los campos 'cod_prov' y 'atributo_y'

CREATE TABLE
    pjuridica (
        cod_prov INT NOT NULL,
        atributo_y VARCHAR(10) NOT NULL,
        PRIMARY KEY (cod_prov),
        FOREIGN KEY (cod_prov) REFERENCES proveedor(cod_prov) ON DELETE CASCADE
    );

-- Crea la tabla 'suministra' con los campos 'cod_prov', 'cod_pieza', 'fecha_hora' y 'cantidad'
-- DATETIME(6) incluye microsegundos

CREATE TABLE
    suministra (
        cod_prov INT NOT NULL,
        cod_pieza INT NOT NULL,
        fecha_hora DATETIME(6) NOT NULL,
        cantidad INT NOT NULL CHECK (cantidad > 0),
        FOREIGN KEY (cod_prov) REFERENCES proveedor(cod_prov) ON DELETE CASCADE,
        FOREIGN KEY (cod_pieza) REFERENCES pieza(cod_pieza) ON DELETE CASCADE,
        PRIMARY KEY (
            cod_prov,
            cod_pieza,
            fecha_hora
        )
    );