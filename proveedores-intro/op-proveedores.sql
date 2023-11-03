-- Selección

SELECT * FROM proveedor WHERE ciudad = 'Ciudad-Q';

SELECT * FROM suministra WHERE cantidad > 10;

-- Proyección

SELECT nombre, ciudad FROM proveedor;

SELECT cod_prov, cod_pieza FROM suministra;

-- Diferencia de conjuntos

SELECT cod_prov
FROM proveedor
EXCEPT
SELECT cod_prov
FROM suministra;

-- Instersección

SELECT cod_prov
FROM suministra
INTERSECT
SELECT cod_prov
FROM proveedor;

-- Renombramiento

SELECT cantidad AS cantidad_suministrada FROM suministra;

-- Unión

SELECT cod_prov FROM pnatural UNION SELECT cod_prov FROM pjuridica;

-- CROSS JOIN

SELECT * FROM suministra CROSS JOIN pieza;

SELECT * FROM suministra, pieza;

SELECT *
FROM suministra
    CROSS JOIN pieza
WHERE
    suministra.cod_pieza = pieza.cod_pieza
    AND suministra.cantidad > 10;

-- NATURAL JOIN

SELECT * FROM suministra NATURAL JOIN pieza;

SELECT *
FROM suministra
    NATURAL JOIN pieza
WHERE suministra.cantidad > 10;

SELECT * FROM proveedor NATURAL JOIN suministra;

-- JOIN ON

SELECT
    proveedor.nombre AS nombre_proveedor,
    pieza.nombre AS nombre_pieza,
    suministra.cantidad,
    pieza.cod_categoria
FROM proveedor
    JOIN suministra ON proveedor.cod_prov = suministra.cod_prov
    JOIN pieza ON suministra.cod_pieza = pieza.cod_pieza;

-- LEFT JOIN

SELECT
    proveedor.nombre AS nombre_proveedor,
    pieza.nombre AS nombre_pieza,
    suministra.cantidad
FROM proveedor
    LEFT JOIN suministra ON proveedor.cod_prov = suministra.cod_prov
    LEFT JOIN pieza ON suministra.cod_pieza = pieza.cod_pieza;

-- RIGHT JOIN

SELECT
    proveedor.nombre AS nombre_proveedor,
    pieza.nombre AS nombre_pieza,
    suministra.cantidad
FROM proveedor
    RIGHT JOIN suministra ON proveedor.cod_prov = suministra.cod_prov
    RIGHT JOIN pieza ON suministra.cod_pieza = pieza.cod_pieza;

-- INNER JOIN

SELECT
    proveedor.nombre AS nombre_proveedor,
    pieza.nombre AS nombre_pieza,
    suministra.cantidad
FROM proveedor
    INNER JOIN suministra ON proveedor.cod_prov = suministra.cod_prov
    INNER JOIN pieza ON suministra.cod_pieza = pieza.cod_pieza;