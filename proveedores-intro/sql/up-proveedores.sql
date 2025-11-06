UPDATE proveedor
SET
    nombre = 'Proveedor-1-act',
    ciudad = 'Ciudad-B'
WHERE cod_prov = 123;

UPDATE pnatural SET atributo_x = 'Nat-1-act' WHERE cod_prov = 123;

UPDATE pjuridica SET atributo_y = 'Jur-1-act' WHERE cod_prov = 567;

UPDATE pieza SET precio = 70000 WHERE cod_pieza = 002;

UPDATE suministra
SET cantidad = 15
WHERE
    cod_prov = 123
    AND cod_pieza = 002;

-- Notese que se podría añadir un número de orden o similar: PODRÍA CAMBIAR EL MODELO

-- Por ON UPDATE CASCADE

-- Primero, actualiza el cod_prov en la tabla proveedor y luego actualiza el cod_prov en la tabla pnatural

UPDATE proveedor SET cod_prov = 345 WHERE cod_prov = 124;

SHOW CREATE TABLE pnatural