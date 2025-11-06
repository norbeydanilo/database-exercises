-- Selección

SELECT * FROM proveedor WHERE ciudad = 'Ciudad-Q';

SELECT * FROM suministra WHERE cantidad > 10;

-- Proyección

SELECT nombre, ciudad FROM proveedor;

SELECT cod_prov, cod_pieza FROM suministra;

SELECT nombre, color FROM pieza;

SELECT nombre FROM categoria;

-- Diferencia de conjuntos

-- Proveedores que no han realizado suministros:

SELECT cod_prov
FROM proveedor EXCEPT
SELECT cod_prov
FROM suministra;

-- Obtener las categorías de piezas que no tienen suministros en la actualidad:

SELECT c.cod_categoria, c.nombre
FROM categoria c EXCEPT
SELECT DISTINCT
    pz.cod_categoria,
    pz.nombre
FROM pieza pz
    JOIN suministra s ON pz.cod_pieza = s.cod_pieza
WHERE
    s.fecha_hora >= CURRENT_TIMESTAMP - INTERVAL '7 days';

-- Intersección

-- Proveedores con suministros registrados en la tabla "suministra"

SELECT cod_prov
FROM suministra INTERSECT
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
WHERE
    suministra.cantidad > 10;

SELECT * FROM proveedor NATURAL JOIN suministra;

-- JOIN ON

-- Obtener el nombre del proveedor, nombre de la pieza y cantidad suministrada:

SELECT
    proveedor.nombre AS nombre_proveedor,
    pieza.nombre AS nombre_pieza,
    suministra.cantidad,
    pieza.cod_categoria
FROM
    proveedor
    JOIN suministra ON proveedor.cod_prov = suministra.cod_prov
    JOIN pieza ON suministra.cod_pieza = pieza.cod_pieza;

SELECT
    p.nombre AS nombre_proveedor,
    pz.nombre AS nombre_pieza,
    cantidad
FROM
    proveedor p
    JOIN suministra s ON p.cod_prov = s.cod_prov
    JOIN pieza pz ON pz.cod_pieza = s.cod_pieza;

-- LEFT JOIN

-- Obtener el nombre del proveedor, nombre de la pieza y cantidad suministrada, incluso si no hay suministro para la pieza:

SELECT
    proveedor.nombre AS nombre_proveedor,
    pieza.nombre AS nombre_pieza,
    suministra.cantidad
FROM
    proveedor
    LEFT JOIN suministra ON proveedor.cod_prov = suministra.cod_prov
    LEFT JOIN pieza ON suministra.cod_pieza = pieza.cod_pieza;

-- RIGHT JOIN

-- Proveedores, piezas y cantidades suministradas (incluye proveedores sin suministros)

SELECT
    proveedor.nombre AS nombre_proveedor,
    pieza.nombre AS nombre_pieza,
    suministra.cantidad
FROM
    proveedor
    RIGHT JOIN suministra ON proveedor.cod_prov = suministra.cod_prov
    RIGHT JOIN pieza ON suministra.cod_pieza = pieza.cod_pieza;

-- INNER JOIN

-- Proveedores, piezas y cantidades suministradas (solo con registros de suministro)

SELECT
    proveedor.nombre AS nombre_proveedor,
    pieza.nombre AS nombre_pieza,
    suministra.cantidad
FROM
    proveedor
    INNER JOIN suministra ON proveedor.cod_prov = suministra.cod_prov
    INNER JOIN pieza ON suministra.cod_pieza = pieza.cod_pieza;

-- Más consultas

-- Obtener el nombre del proveedor, nombre de la pieza y precio de la pieza para los suministros realizados en el 2023:

SELECT
    p.nombre AS nombre_proveedor,
    pz.nombre AS nombre_pieza,
    pz.precio
FROM
    proveedor p
    JOIN suministra s ON p.cod_prov = s.cod_prov
    JOIN pieza pz ON pz.cod_pieza = s.cod_pieza
WHERE
    YEAR(s.fecha_hora) = 2023;

-- Obtener el nombre del proveedor, nombre de la categoría y nombre de la pieza para las piezas de la categoría "Categoria-1":

SELECT
    p.nombre AS nombre_proveedor,
    c.nombre AS nombre_categoria,
    pz.nombre AS nombre_pieza
FROM
    proveedor p
    JOIN suministra s ON p.cod_prov = s.cod_prov
    JOIN pieza pz ON pz.cod_pieza = s.cod_pieza
    JOIN categoria c ON pz.cod_categoria = c.cod_categoria
WHERE
    c.nombre = 'Categoria-1';

-- Obtener el nombre del proveedor, nombre de la pieza y precio de la pieza para los suministros realizados por proveedores con atributo_x "Natural-1":

SELECT
    p.nombre AS nombre_proveedor,
    pz.nombre AS nombre_pieza,
    pz.precio
FROM
    proveedor p
    NATURAL JOIN suministra s
    NATURAL JOIN pieza pz
    NATURAL JOIN pnatural pn
WHERE
    pn.atributo_x = 'Natural-1';

-- Obtener el nombre del proveedor, nombre de la pieza y precio de la pieza para los suministros realizados por proveedores con tipo "Natural":

SELECT
    p.nombre AS nombre_proveedor,
    pz.nombre AS nombre_pieza,
    pz.precio
FROM
    proveedor p
    INNER JOIN suministra s ON p.cod_prov = s.cod_prov
    INNER JOIN pieza pz ON pz.cod_pieza = s.cod_pieza
WHERE
    p.tipo = 'Natural';