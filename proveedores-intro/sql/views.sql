---------------------------------------------------------------------
-- CREACIÓN DE VISTAS
---------------------------------------------------------------------

-- 1) Vista: información básica de proveedores
--    (muestra solo columnas comunes)
CREATE VIEW vista_proveedores AS
SELECT
    cod_prov,
    nombre,
    ciudad,
    departamento,
    tipo
FROM proveedor;


-- 2) Vista: piezas con su categoría
--    (JOIN simple entre pieza y categoria)
CREATE VIEW vista_piezas_categoria AS
SELECT
    p.cod_pieza,
    p.nombre AS nombre_pieza,
    p.color,
    p.precio,
    c.nombre AS nombre_categoria
FROM pieza p
JOIN categoria c ON p.cod_categoria = c.cod_categoria;


-- 3) Vista: proveedores naturales
--    (unión entre proveedor y pnatural)
CREATE VIEW vista_prov_naturales AS
SELECT
    pr.cod_prov,
    pr.nombre,
    pr.ciudad,
    pr.departamento,
    pn.atributo_x
FROM proveedor pr
JOIN pnatural pn ON pr.cod_prov = pn.cod_prov;


-- 4) Vista: proveedores jurídicos
--    (unión con pjuridica)
CREATE VIEW vista_prov_juridicos AS
SELECT
    pr.cod_prov,
    pr.nombre,
    pr.ciudad,
    pr.departamento,
    pj.atributo_y
FROM proveedor pr
JOIN pjuridica pj ON pr.cod_prov = pj.cod_prov;


-- 5) Vista: suministros con información del proveedor y pieza
--    (combinación de varias tablas)
CREATE VIEW vista_suministros AS
SELECT
    s.cod_prov,
    pr.nombre AS nombre_proveedor,
    s.cod_pieza,
    pi.nombre AS nombre_pieza,
    s.fecha_hora,
    s.cantidad
FROM suministra s
JOIN proveedor pr ON s.cod_prov = pr.cod_prov
JOIN pieza pi ON s.cod_pieza = pi.cod_pieza;


-- 6) Vista: cantidad suministrada por proveedor
--    (el ejemplo incluye una agregación)
CREATE VIEW vista_total_suministrado_por_proveedor AS
SELECT
    pr.cod_prov,
    pr.nombre,
    SUM(s.cantidad) AS total_suministrado
FROM proveedor pr
JOIN suministra s ON pr.cod_prov = s.cod_prov
GROUP BY pr.cod_prov, pr.nombre
ORDER BY total_suministrado DESC;


-- 7) Vista: piezas más costosas
--    (filtrando con precio)
CREATE VIEW vista_piezas_costosas AS
SELECT
    cod_pieza,
    nombre,
    color,
    precio
FROM pieza
WHERE precio > 100000;   -- modificar a voluntad

-- Como usar las vistas

SELECT * FROM vista_proveedores;
SELECT * FROM vista_piezas_categoria;
SELECT * FROM vista_prov_naturales;
SELECT * FROM vista_suministros;
SELECT * FROM vista_total_suministrado_por_proveedor;
SELECT * FROM vista_piezas_costosas;
