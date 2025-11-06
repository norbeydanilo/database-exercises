-- IN

-- Proveedores con suministros mayores a 10:
SELECT nombre
FROM proveedor
WHERE
    cod_prov IN (
        SELECT cod_prov
        FROM suministra
        WHERE
            cantidad > 10
    );

-- NOT IN

-- Proveedores sin suministros mayores a 10:
SELECT nombre
FROM proveedor
WHERE
    cod_prov NOT IN(
        SELECT cod_prov
        FROM suministra
        WHERE
            cantidad > 10
    );

-- EXISTS

-- Proveedores con al menos un suministro mayor a 10:
SELECT nombre
FROM proveedor
WHERE
    EXISTS (
        SELECT *
        FROM suministra
        WHERE
            proveedor.cod_prov = suministra.cod_prov
            AND cantidad > 10
    );

-- NOT EXISTS

-- Proveedores sin suministros mayores a 10 (usando NOT EXISTS):
SELECT nombre
FROM proveedor
WHERE
    NOT EXISTS (
        SELECT *
        FROM suministra
        WHERE
            proveedor.cod_prov = suministra.cod_prov
            AND cantidad > 10
    );

-- IN, HAVING, DISTINCT

-- Proveedores que han suministrado un solo tipo de pieza con una cantidad total superior a 10 unidades.
SELECT nombre, cod_prov
FROM proveedor
WHERE
    cod_prov IN (
        SELECT cod_prov
        FROM suministra
        GROUP BY
            cod_prov
        HAVING
            COUNT(DISTINCT cod_pieza) = 1
            AND SUM(cantidad) > 10
    );

-- Consulta derivada

-- Lista de proveedores junto con el total de unidades suministradas por cada uno.
SELECT proveedores.nombre, suministros_totales.total_cantidad
FROM
    proveedor AS proveedores
    JOIN (
        SELECT cod_prov, SUM(cantidad) AS total_cantidad
        FROM suministra
        GROUP BY
            cod_prov
    ) AS suministros_totales ON proveedores.cod_prov = suministros_totales.cod_prov;

-- WITH

-- Lista de proveedores junto con el total de unidades suministradas por cada uno (usando una CTE).
WITH
    suministros_totales AS (
        SELECT cod_prov, SUM(cantidad) AS total_cantidad
        FROM suministra
        GROUP BY
            cod_prov
    )
SELECT proveedores.nombre, suministros_totales.total_cantidad
FROM
    proveedor AS proveedores
    JOIN suministros_totales ON proveedores.cod_prov = suministros_totales.cod_prov;

-- Esta consulta es similar a la anterior, pero utiliza una expresión de tabla común (CTE) llamada "suministros_totales" para calcular la suma total de unidades suministradas por cada proveedor. Luego, se realiza un JOIN entre la tabla "proveedor" y la CTE para mostrar el nombre del proveedor y la cantidad total suministrada.