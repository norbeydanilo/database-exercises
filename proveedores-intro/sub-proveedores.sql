-- IN
SELECT nombre FROM proveedor WHERE cod_prov IN (SELECT cod_prov FROM suministra WHERE cantidad > 10);

-- NOT IN
SELECT nombre FROM proveedor WHERE cod_prov NOT IN (SELECT cod_prov FROM suministra WHERE cantidad > 10);

-- EXISTS
SELECT nombre FROM proveedor WHERE EXISTS (SELECT * FROM suministra WHERE proveedor.cod_prov = suministra.cod_prov AND cantidad > 10);

-- NOT EXISTS
SELECT nombre FROM proveedor WHERE NOT EXISTS (SELECT * FROM suministra WHERE proveedor.cod_prov = suministra.cod_prov AND cantidad > 10);

-- IN, HAVING, DISTINCT

SELECT nombre, cod_prov 
FROM proveedor 
WHERE cod_prov IN (
    SELECT cod_prov 
    FROM suministra 
    GROUP BY cod_prov 
    HAVING COUNT(DISTINCT cod_pieza) = 1 AND SUM(cantidad) > 10
);

-- Consulta derivada

SELECT proveedores.nombre, suministros_totales.total_cantidad
FROM proveedor AS proveedores
JOIN (
    SELECT cod_prov, SUM(cantidad) AS total_cantidad
    FROM suministra
    GROUP BY cod_prov
) AS suministros_totales
ON proveedores.cod_prov = suministros_totales.cod_prov;

-- WITH

WITH suministros_totales AS (
    SELECT cod_prov, SUM(cantidad) AS total_cantidad
    FROM suministra
    GROUP BY cod_prov
)
SELECT proveedores.nombre, suministros_totales.total_cantidad
FROM proveedor AS proveedores
JOIN suministros_totales
ON proveedores.cod_prov = suministros_totales.cod_prov;