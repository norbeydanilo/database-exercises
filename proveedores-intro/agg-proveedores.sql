SELECT COUNT(*)
FROM suministra
WHERE cantidad > 10;

SELECT SUM(cantidad)
FROM suministra
WHERE cod_prov = 123;

SELECT AVG(cantidad)
FROM suministra
WHERE cod_prov = 123;

SELECT MIN(cantidad), MAX(cantidad)
FROM suministra;

SELECT cod_prov, COUNT(*)
FROM suministra
GROUP BY cod_prov;

SELECT cod_prov, COUNT(*) AS total
FROM suministra
GROUP BY cod_prov
HAVING total > 1;

SELECT cod_prov, COUNT(*) AS total
FROM suministra
GROUP BY cod_prov
HAVING total > 1
ORDER BY total

SELECT cod_prov, COUNT(*) AS total
FROM suministra
GROUP BY cod_prov
HAVING total > 1
ORDER BY total DESC

SELECT cod_prov, COUNT(*) AS total
FROM suministra
GROUP BY cod_prov
HAVING total > 1
ORDER BY total DESC
LIMIT 1

SELECT cod_prov, AVG(cantidad) AS promedio
FROM suministra
GROUP BY cod_prov
HAVING promedio > 10;

-- DISTINCT e IS NULL

SELECT DISTINCT ciudad FROM proveedor;

SELECT nombre FROM proveedor WHERE ciudad IS NULL;
