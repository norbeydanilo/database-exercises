/*
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
 INSERT INTO proveedor
 VALUES (
 567,
 'Proveedor-3',
 'DirProv-3',
 'Ciudad-F',
 'Depto-T',
 'Jurídica'
 );
 INSERT INTO proveedor
 VALUES (
 789,
 'Proveedor-4',
 'DirProv-4',
 'Ciudad-Q',
 'Depto-R',
 'Jurídica'
 );
 */

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
    ), (
        567,
        'Proveedor-3',
        'DirProv-3',
        'Ciudad-F',
        'Depto-T',
        'Jurídica'
    ), (
        789,
        'Proveedor-4',
        'DirProv-4',
        'Ciudad-Q',
        'Depto-R',
        'Jurídica'
    ), (
        901,
        'Proveedor-5',
        'DirProv-5',
        'Ciudad-Q',
        'Depto-R',
        'Natural'
    ), (
        102,
        'Proveedor-6',
        'DirProv-6',
        'Ciudad-A',
        'Depto-T',
        'Jurídica'
    ), (
        201,
        'Proveedor-7',
        'DirProv-7',
        'Ciudad-Q',
        'Depto-S',
        'Natural'
    ), (
        302,
        'Proveedor-8',
        'DirProv-8',
        'Ciudad-F',
        'Depto-S',
        'Jurídica'
    );

INSERT INTO pnatural VALUES (123, 'Natural-1');

INSERT INTO pnatural VALUES (345, 'Natural-2');

INSERT INTO pnatural VALUES (901, 'Natural-3');

INSERT INTO pnatural VALUES (201, 'Natural-4');

INSERT INTO pjuridica VALUES (567, 'Juridica-1');

INSERT INTO pjuridica VALUES (789, 'Juridica-2');

INSERT INTO pjuridica VALUES (102, 'Juridica-3');

INSERT INTO pjuridica VALUES (302, 'Juridica-4');

INSERT INTO categoria VALUES (111, 'Categoria-1');

INSERT INTO categoria VALUES (222, 'Categoria-2');

INSERT INTO pieza VALUES (001, 'Pieza-1', 'Azul', 65355, 111);

INSERT INTO pieza VALUES (002, 'Pieza-2', 'Verde', 72500.25, 222);

INSERT INTO pieza VALUES (003, 'Pieza-3', 'Gris', 85500.25, 222);

INSERT INTO pieza VALUES (004, 'Pieza-4', 'Roja', 15500.25, 111);

-- YYYY-MM-DD hh:mm:ss

-- NOW() solo devuelve la fecha y hora hasta los segundos, no incluye microsegundos

-- Para insertar la fecha y hora actuales con microsegundos, se debe usar CURRENT_TIMESTAMP(6)

INSERT INTO suministra VALUES (123, 002, CURRENT_TIMESTAMP(6), 10);

INSERT INTO suministra VALUES (123, 002, CURRENT_TIMESTAMP(6), 10);

INSERT INTO suministra VALUES (345, 003, CURRENT_TIMESTAMP(6), 25);

INSERT INTO suministra VALUES (345, 004, CURRENT_TIMESTAMP(6), 5);

INSERT INTO suministra VALUES (901, 004, CURRENT_TIMESTAMP(6), 20);

INSERT INTO suministra VALUES (201, 003, CURRENT_TIMESTAMP(6), 15);

INSERT INTO suministra VALUES (102, 001, CURRENT_TIMESTAMP(6), 12);

INSERT INTO suministra VALUES (302, 003, CURRENT_TIMESTAMP(6), 5);

INSERT INTO suministra VALUES (789, 001, '2023-05-26 08:22:29', 20);