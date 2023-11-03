# Proveedores

## Enunciado

Tenemos que diseñar una base de datos sobre proveedores y disponemos de la siguiente información:

- De cada proveedor conocemos su nombre, dirección, ciudad, departamento y un código de proveedor que será único para cada uno de ellos.
- Nos interesa llevar un control de las piezas que nos suministra cada proveedor. Es importante conocer la cantidad de las diferentes piezas que nos suministra y en qué fecha lo hace. Tenga en cuenta que un mismo proveedor nos puede suministrar una pieza con el mismo código en diferentes fechas. El diseño de la base de datos debe permitir almacenar un histórico con todas las fechas y las cantidades que nos ha proporcionado un proveedor.
- Una misma pieza puede ser suministrada por diferentes proveedores.
- De cada pieza conocemos un código que será único, nombre, color, precio y categoría.
- Pueden existir varias categorías y para cada categoría hay un nombre y un código de categoría único.
- Una pieza sólo puede pertenecer a una categoría.

## Modelo Entidad-Relación

![](MER.png)

## Modelo Relacional

### Opción 1

- **Proveedor** = (<u>**codigo_prov**</u>, nombre, direccion, ciudad, departamento, tipo)

- **Pieza** = (<u>**codigo_pieza**</u>, nombre, color, precio, ***codigo_cate***)

- **Categoria** = (<u>**codigo_cate**</u>, nombre)

- **Suministra** = (<u>***codigo_prov***</u>, <u>***codigo_pieza***</u>, <u>**fecha_hora**</u>, cantidad)

- **Natural** = (<u>***codigo_prov***</u>, AtributoX)

- **Juridica** = (<u>***codigo_prov***</u>, AtributoY)

### Opcion 2

- **Pieza** = (<u>**codigo_pieza**</u>, nombre, color, precio, ***codigo_cate***)

- **Categoria** = (<u>**codigo_cate**</u>, nombre)

- **Suministra** = (<u>***id_prov***</u>, <u>***codigo_pieza***</u>, <u>**fecha_hora**</u>, cantidad)

- **Natural** = (<u>**id_prov**</u>, nombre, direccion, ciudad, departamento, AtributoX)

- **Juridica** = (<u>**id_prov**</u>, nombre, direccion, ciudad, departamento, AtributoY)

## SQL -- MySQL

### DDL para crear la base de datos

**Usando DDL defina la estructura de datos. Ejecute el fichero [`proveedores.sql`](proveedores.sql) en la shell de MySQL.**

**Para su entendimiento puede seguir las instrucciones y pasos a continuación:**

Eliminar la base de datos 'proveedores' si existe

```sql
DROP DATABASE IF EXISTS proveedores;
```

Crear la base de datos 'proveedores'

```sql
CREATE DATABASE IF NOT EXISTS proveedores CHARACTER SET utf8mb4;
```

Seleccionar la base de datos 'proveedores' para usarla

```sql
USE proveedores;
```

Crea la tabla 'categoria' con los campos 'cod_categoria' y 'nombre'

```sql
CREATE TABLE
    categoria (
        cod_categoria INT NOT NULL,
        nombre VARCHAR(20) NOT NULL,
        PRIMARY KEY (cod_categoria)
    );
```

Crea la tabla 'pieza' con los campos 'cod_pieza', 'nombre', 'color', 'precio' y 'cod_categoria'

```sql
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
```

La cláusula `ON DELETE CASCADE` en SQL se utiliza para especificar que cuando un registro en la tabla principal (en este caso, `categoria`) es eliminado, también se deben eliminar automáticamente todos los registros correspondientes en la tabla secundaria (en este caso, `pieza`) que hacen referencia al registro eliminado.

En otras palabras, si tienes una categoría específica que se elimina de la tabla `categoria`, todos las piezas que pertenecen a esa categoría también se eliminarán de la tabla `pieza`. Esto ayuda a mantener la integridad de los datos en la base de datos.

En SQL, además de `ON DELETE CASCADE`, existen otras opciones que puedes usar para definir el comportamiento de las claves foráneas cuando se elimina un registro en la tabla principal:

1. `ON DELETE SET NULL`: Si se elimina un registro en la tabla principal, todos los registros correspondientes en la tabla secundaria que hacen referencia al registro eliminado se establecerán en NULL.

2. `ON DELETE NO ACTION` o `ON DELETE RESTRICT`: Estas son las opciones predeterminadas. Si intentas eliminar un registro en la tabla principal que tiene registros correspondientes en la tabla secundaria, la base de datos no permitirá la operación y generará un error.

3. `ON DELETE SET DEFAULT`: Si se elimina un registro en la tabla principal, todos los registros correspondientes en la tabla secundaria que hacen referencia al registro eliminado se establecerán en su valor predeterminado. Sin embargo, esta opción no es tan comúnmente utilizada y no está disponible en todos los sistemas de gestión de bases de datos.

Crea la tabla 'proveedor' con los campos 'cod_prov', 'nombre', 'direccion', 'ciudad', 'departamento' y 'tipo'

```sql
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
```

`ENUM` es un tipo de dato en SQL que permite especificar un conjunto fijo de valores predefinidos aceptados para un campo en particular. En este caso, `ENUM ('Natural', 'Jurídica')` significa que el campo `tipo` solo puede tomar los valores 'Natural' o 'Jurídica'. Si intentamos insertar un valor diferente a estos, la base de datos generará un error.

Además, `NOT NULL` significa que el campo `tipo` debe tener un valor en cada registro; no puede ser dejado en blanco.

Por lo tanto, al definir `tipo ENUM ('Natural', 'Jurídica') NOT NULL`, estamos asegurando que cada proveedor en la tabla `proveedor` debe ser clasificado como 'Natural' o 'Jurídica', y no puede ser dejado sin clasificar.

Crea la tabla 'pnatural' con los campos 'cod_prov' y 'atributo_x'

```sql
CREATE TABLE
    pnatural (
        cod_prov INT NOT NULL,
        atributo_x VARCHAR(10) NOT NULL,
        PRIMARY KEY (cod_prov),
        FOREIGN KEY (cod_prov) REFERENCES proveedor(cod_prov) ON DELETE CASCADE
    );
```

Crea la tabla 'pjuridica' con los campos 'cod_prov' y 'atributo_y'

```sql
CREATE TABLE
    pjuridica (
        cod_prov INT NOT NULL,
        atributo_y VARCHAR(10) NOT NULL,
        PRIMARY KEY (cod_prov),
        FOREIGN KEY (cod_prov) REFERENCES proveedor(cod_prov) ON DELETE CASCADE
    );
```

Crea la tabla 'suministra' con los campos 'cod_prov', 'cod_pieza', 'fecha_hora' y 'cantidad'

```sql
CREATE TABLE
    suministra (
        cod_prov INT NOT NULL,
        cod_pieza INT NOT NULL,
        fecha_hora DATETIME(6) NOT NULL, -- hasta microsegundos
        cantidad INT NOT NULL CHECK (cantidad > 0),
        FOREIGN KEY (cod_prov) REFERENCES proveedor(cod_prov) ON DELETE CASCADE,
        FOREIGN KEY (cod_pieza) REFERENCES pieza(cod_pieza) ON DELETE CASCADE,
        PRIMARY KEY (
            cod_prov,
            cod_pieza,
            fecha_hora
        )
    );
```

### DML para Insertar

**Usando DML para insertar datos. Ejecute el fichero [`in-proveedores.sql`](in-proveedores.sql) en la shell de MySQL para insertar datos en las tablas.**

Formas de insertar:

```sql
INSERT INTO proveedor
VALUES (
        123,
        'Proveedor-1',
        'DirProv-1',
        'Ciudad-A',
        'Depto-D',
        'Natural'
    );

INSERT INTO proveedor
VALUES (
        345,
        'Proveedor-2',
        'DirProv-2',
        'Ciudad-A',
        'Depto-S',
        'Natural'
    );
```

O de la forma:

```sql
INSERT INTO
    proveedor (
        cod_prov,
        nombre,
        direccion,
        ciudad,
        departamento,
        tipo
    )
VALUES (
        123,
        'Proveedor-1',
        'DirProv-1',
        'Ciudad-A',
        'Depto-D',
        'Natural'
    ), (
        345,
        'Proveedor-2',
        'DirProv-2',
        'Ciudad-A',
        'Depto-S',
        'Natural'
    );
```

### DML para Actualizar

**Usando DML para actualizar datos. Ejecute el fichero [`up-proveedores.sql`](up-proveedores.sql) en la shell de MySQL para actualizar datos en las tablas.**

Actualizando un conjunto de atributos:

```sql
UPDATE proveedor
SET
    nombre = 'Proveedor-1-act',
    ciudad = 'Ciudad-B'
WHERE cod_prov = 123;
```

Actualizando un solo atributo:

```sql
UPDATE pjuridica SET atributo_y = 'Jur-1-act' WHERE cod_prov = 567;
```

¿Qué sucede cuando intenta actualizar empleando la siguiente consulta? ¿Cuáles serán los atributos y tuplas que se van a modificar? ¿Qué estrategias se pueden proponer?

```sql
UPDATE suministra
SET cantidad = 15
WHERE
    cod_prov = 123
    AND cod_pieza = 002;
``` 

Para la actualización en cascada se debe indicar la opción `ON UPDATE CASCADE` en las claves foráneas.

Es necesario, si no lo realizó, aplicar el `DDL` `ALTER TABLE` para incluir la opción de la actualización en cascada.

Antes de ejecutar la siguiente operación:

```sql
UPDATE proveedor SET cod_prov = 124 WHERE cod_prov = 345;
```

Altere la tabla `suministra` para agregar la cláusula `ON UPDATE CASCADE`:

```sql
ALTER TABLE suministra ADD CONSTRAINT fk_suministra_pieza FOREIGN KEY (cod_pieza) REFERENCES pieza(cod_pieza) ON DELETE CASCADE ON UPDATE CASCADE;
```

Recuerde que requiere de la eliminación previa de la `CONSTRAINT fk_suministra_pieza` para asignar la nueva restricción de integridad referencial.

Si no indicó el nombre de la `CONSTRAINT` cuando creó la tabla, deberá verificar cómo el motor la creó por defecto a través de:

```sql
SHOW CREATE TABLE suministra; -- verifique el nombre de la constraint

-- Eliminando la constraint

ALTER TABLE suministra DROP FOREIGN KEY suministra_ibfk_1;
```

Haga lo mismo para la(s) tabla(s) en la(s) que el `código del proveedor` es foráneo.

### DML para Eliminar

**Usando DML para eliminar datos. Ejecute el fichero [`del-proveedores.sql`](del-proveedores.sql) en la shell de MySQL para eliminar datos en las tablas.**

Ejemplos de eliminación de tuplas:

```sql
DELETE FROM proveedor WHERE cod_prov = 102;

DELETE FROM pieza WHERE cod_pieza = 001;
```

Note que la primera clúsula efectuará una eliminación en cascada. Es decir, ese proveedor va a ser eliminado también automáticamente en las tablas donde sea clave ajena. 

### Algebra Relacional -- Consultas

**Usando Algebra Relacional para realizar consultas. Ejecute el fichero [`op-proveedores.sql`](op-proveedores.sql) en la shell de MySQL para realizar consultas.**

El álgebra relacional es un conjunto de operaciones que se utilizan para manipular relaciones (tablas) en una base de datos relacional. Explicación breve de cada una de las operaciones con el ejemplo en cuestión:

1. **Selección**: Esta operación se utiliza para seleccionar un subconjunto de tuplas de una relación que satisfacen una condición dada. En SQL, se utiliza la cláusula `WHERE` para especificar la condición.

```sql
SELECT * FROM proveedor WHERE ciudad = 'Ciudad-Q';
SELECT * FROM suministra WHERE cantidad > 10;
```

2. **Proyección**: Esta operación se utiliza para seleccionar ciertas columnas de una relación y descartar las demás. En SQL, se especifican las columnas deseadas después de la palabra clave `SELECT`.

```sql
SELECT nombre, ciudad FROM proveedor;
SELECT cod_prov, cod_pieza FROM suministra;
```

3. **Diferencia de conjuntos**: Esta operación se utiliza para obtener las tuplas que están en una relación pero no en otra. En SQL, se utiliza la cláusula `EXCEPT`.

```sql
SELECT cod_prov
FROM proveedor
EXCEPT
SELECT cod_prov
FROM suministra;
```

4. **Renombramiento**: Esta operación se utiliza para cambiar el nombre de las columnas de salida de una consulta. En SQL, se utiliza la palabra clave `AS`.

```sql
SELECT cantidad AS cantidad_suministrada FROM suministra;
```

5. **Unión**: Esta operación se utiliza para combinar las tuplas de dos relaciones en una sola. En SQL, se utiliza la cláusula `UNION`.

```sql
SELECT cod_prov FROM pnatural UNION SELECT cod_prov FROM pjuridica;
```

6. **CROSS JOIN**: Esta operación produce el producto cartesiano de dos relaciones. En SQL, se utiliza la cláusula `CROSS JOIN`.

```sql
SELECT * FROM suministra CROSS JOIN pieza;
SELECT * FROM suministra, pieza;
SELECT *
FROM suministra
    CROSS JOIN pieza
WHERE
    suministra.cod_pieza = pieza.cod_pieza
    AND suministra.cantidad > 10;
```

7. **Intersección**: Esta operación se utiliza para obtener las tuplas que están tanto en una relación como en otra. En SQL, se utiliza la cláusula `INTERSECT`.

```sql
SELECT cod_prov
FROM suministra
INTERSECT
SELECT cod_prov
FROM proveedor;
```

8. **NATURAL JOIN**: Esta operación combina dos relaciones basándose en todas las columnas con el mismo nombre. En SQL, se utiliza la cláusula `NATURAL JOIN`.

```sql
SELECT * FROM suministra NATURAL JOIN pieza;
SELECT *
FROM suministra
    NATURAL JOIN pieza
WHERE suministra.cantidad > 10;
SELECT * FROM proveedor NATURAL JOIN suministra;
```

9. **JOIN ON**: Esta operación combina dos relaciones basándose en una condición dada. En SQL, se utiliza la cláusula `JOIN ... ON`.

```sql
SELECT
    proveedor.nombre AS nombre_proveedor,
    pieza.nombre AS nombre_pieza,
    suministra.cantidad,
    pieza.cod_categoria
FROM proveedor
    JOIN suministra ON proveedor.cod_prov = suministra.cod_prov
    JOIN pieza ON suministra.cod_pieza = pieza.cod_pieza;
```

10. **LEFT JOIN**: Esta operación combina dos relaciones y devuelve todas las tuplas de la relación izquierda y las tuplas coincidentes de la relación derecha. En SQL, se utiliza la cláusula `LEFT JOIN`.

```sql
SELECT
    proveedor.nombre AS nombre_proveedor,
    pieza.nombre AS nombre_pieza,
    suministra.cantidad
FROM proveedor
    LEFT JOIN suministra ON proveedor.cod_prov = suministra.cod_prov
    LEFT JOIN pieza ON suministra.cod_pieza = pieza.cod_pieza;
```

11. **RIGHT JOIN**: Esta operación combina dos relaciones y devuelve todas las tuplas de la relación derecha y las tuplas coincidentes de la relación izquierda. En SQL, se utiliza la cláusula `RIGHT JOIN`.

```sql
SELECT
    proveedor.nombre AS nombre_proveedor,
    pieza.nombre AS nombre_pieza,
    suministra.cantidad
FROM proveedor
    RIGHT JOIN suministra ON proveedor.cod_prov = suministra.cod_prov
    RIGHT JOIN pieza ON suministra.cod_pieza = pieza.cod_pieza;
```

12. **INNER JOIN**: Esta operación combina dos relaciones basándose en una condición dada y devuelve solo las tuplas que satisfacen esa condición. En SQL, se utiliza la cláusula `INNER JOIN` o simplemente `JOIN`.

```sql
SELECT
    proveedor.nombre AS nombre_proveedor,
    pieza.nombre AS nombre_pieza,
    suministra.cantidad
FROM proveedor
    INNER JOIN suministra ON proveedor.cod_prov = suministra.cod_prov
    INNER JOIN pieza ON suministra.cod_pieza = pieza.cod_pieza;
```

### Funciones de agregación

**Usando las funciones de agregación para realizar consultas. Ejecute el fichero [`agg-proveedores.sql`](agg-proveedores.sql) en la shell de MySQL para realizar consultas.**

1. `SELECT COUNT(*) FROM suministra WHERE cantidad > 10;`
   Esta sentencia cuenta el número total de filas en la tabla `suministra` donde el valor de `cantidad` es mayor que 10.

2. `SELECT SUM(cantidad) FROM suministra WHERE cod_prov = 123;`
   Esta sentencia suma todos los valores de `cantidad` en la tabla `suministra` donde `cod_prov` es igual a 123.

3. `SELECT AVG(cantidad) FROM suministra WHERE cod_prov = 123;`
   Esta sentencia calcula el promedio de los valores de `cantidad` en la tabla `suministra` donde `cod_prov` es igual a 123.

4. `SELECT MIN(cantidad), MAX(cantidad) FROM suministra;`
   Esta sentencia selecciona el valor mínimo y máximo de `cantidad` en la tabla `suministra`.

5. `SELECT cod_prov, COUNT(*) FROM suministra GROUP BY cod_prov;`
   Esta sentencia cuenta el número total de filas para cada `cod_prov` en la tabla `suministra`.

6. `SELECT cod_prov, COUNT(*) AS total FROM suministra GROUP BY cod_prov HAVING total > 1;`
   Esta sentencia selecciona `cod_prov` y cuenta el número total de filas para cada `cod_prov` en la tabla `suministra`, pero solo incluye aquellos `cod_prov` que tienen más de una fila.

7. `SELECT cod_prov, COUNT(*) AS total FROM suministra GROUP BY cod_prov HAVING total > 1 ORDER BY total;`
   Similar a la anterior, pero ordena los resultados por el conteo total en orden ascendente.

8. `SELECT cod_prov, COUNT(*) AS total FROM suministra GROUP BY cod_prov HAVING total > 1 ORDER BY total DESC;`
   Similar a la anterior, pero ordena los resultados por el conteo total en orden descendente.

9. `SELECT cod_prov, COUNT(*) AS total FROM suministra GROUP BY cod_prov HAVING total > 1 ORDER BY total DESC LIMIT 1;`
   Similar a la anterior, pero solo devuelve el `cod_prov` con el mayor conteo total.

10. `SELECT cod_prov, AVG(cantidad) AS promedio FROM suministra GROUP BY cod_prov HAVING promedio > 10;`
    Esta sentencia selecciona `cod_prov` y calcula el promedio de `cantidad` para cada `cod_prov` en la tabla `suministra`, pero solo incluye aquellos `cod_prov` que tienen un promedio mayor que 10.

### Subconsultas anidadas

**Usando lo visto respecto a subconsultas anidadas para realizar consultas más avanzadas. Ejecute el fichero [`sub-proveedores.sql`](sub-proveedores.sql) en la shell de MySQL para realizar consultas.**

Las subconsultas anidadas son consultas que se colocan dentro de otras consultas, generalmente en la cláusula `WHERE` o `HAVING`. Las subconsultas anidadas pueden utilizar los siguientes operadores:

1. **IN**: Este operador se utiliza para comprobar si un valor está dentro de un conjunto de valores devueltos por la subconsulta.

```sql
SELECT nombre FROM proveedor WHERE cod_prov IN (SELECT cod_prov FROM suministra WHERE cantidad > 10);
```

En este ejemplo, la consulta devuelve los nombres de los proveedores que suministran más de 10 piezas de algún tipo.

2. **NOT IN**: Este operador se utiliza para comprobar si un valor no está dentro de un conjunto de valores devueltos por la subconsulta.

```sql
SELECT nombre FROM proveedor WHERE cod_prov NOT IN (SELECT cod_prov FROM suministra WHERE cantidad > 10);
```

En este ejemplo, la consulta devuelve los nombres de los proveedores que no suministran más de 10 piezas de ningún tipo.

3. **EXISTS**: Este operador se utiliza para comprobar si la subconsulta devuelve alguna tupla.

```sql
SELECT nombre FROM proveedor WHERE EXISTS (SELECT * FROM suministra WHERE proveedor.cod_prov = suministra.cod_prov AND cantidad > 10);
```

En este ejemplo, la consulta devuelve los nombres de los proveedores que suministran más de 10 piezas de algún tipo.

4. **NOT EXISTS**: Este operador se utiliza para comprobar si la subconsulta no devuelve ninguna tupla.

```sql
SELECT nombre FROM proveedor WHERE NOT EXISTS (SELECT * FROM suministra WHERE proveedor.cod_prov = suministra.cod_prov AND cantidad > 10);
```

En este ejemplo, la consulta devuelve los nombres de los proveedores que no suministran más de 10 piezas de ningún tipo.

5. Composición de subconsultas

```sql
SELECT nombre, cod_prov
FROM proveedor 
WHERE cod_prov IN (
    SELECT cod_prov 
    FROM suministra 
    GROUP BY cod_prov 
    HAVING COUNT(DISTINCT cod_pieza) = 1 AND SUM(cantidad) > 10
);
```

Esta consulta seleccionará los nombres de los proveedores cuyos códigos de proveedor (`cod_prov`) están en un subconjunto de códigos de proveedor que están asociados a una única pieza (`cod_pieza`) y suministran una cantidad total mayor a 10. En otras palabras, seleccionará los grupos que tienen un único `cod_pieza` y una cantidad total suministrada mayor a 10.

6. Subconsulta en la cláusula `FROM`, también conocida como consulta derivada:

```sql
SELECT proveedores.nombre, suministros_totales.total_cantidad
FROM proveedor AS proveedores
JOIN (
    SELECT cod_prov, SUM(cantidad) AS total_cantidad
    FROM suministra
    GROUP BY cod_prov
) AS suministros_totales
ON proveedores.cod_prov = suministros_totales.cod_prov;
```

En este ejemplo, la subconsulta en la cláusula `FROM` calcula la cantidad total suministrada por cada proveedor. Luego, esta subconsulta se une con la tabla `proveedor` para obtener los nombres de los proveedores.

La subconsulta se trata como una tabla temporal que sólo existe para los propósitos de esta consulta. En este caso, la subconsulta se ha asignado el alias `suministros_totales` para su uso en la consulta principal.

7. **WITH**: Es una forma de crear una subconsulta en la cláusula `FROM`. En SQL, se utiliza la palabra clave `WITH`.

Se usa la cláusula `WITH` para definir una consulta común de tabla (CTE):

```sql
WITH suministros_totales AS (
    SELECT cod_prov, SUM(cantidad) AS total_cantidad
    FROM suministra
    GROUP BY cod_prov
)
SELECT proveedores.nombre, suministros_totales.total_cantidad
FROM proveedor AS proveedores
JOIN suministros_totales
ON proveedores.cod_prov = suministros_totales.cod_prov;
```

En este ejemplo, la consulta `WITH` crea una CTE llamada `suministros_totales` que calcula la cantidad total suministrada por cada proveedor. Luego, esta CTE se une con la tabla `proveedor` para obtener los nombres de los proveedores.

Las CTEs son una forma poderosa de crear consultas más legibles y mantenibles, ya que permiten dividir consultas complejas en partes más manejables.

> Create by Norbey Danilo Muñoz Cañón, 2023.
>
> The idea of ​​intellectual property is fundamentally wrong. Knowledge belongs to all people!