CREATE DATABASE  IF NOT EXISTS concesionario;

USE concesionario;

CREATE TABLE coches(
    id int(10) not null auto_increment,
    modelo varchar(100) not null,
    marca varchar(50) not null,
    precio int(20)not null, 
    stock int(255) not null,
    CONSTRAINT pk_coches PRIMARY KEY(id)

)ENGINE=InnoDB;

CREATE TABLE grupos(
    id int(10) not null auto_increment,
    nombre varchar(100) not null,
    ciudad varchar(100),
    CONSTRAINT pk_grupos PRIMARY KEY(id)
)ENGINE=InnoDB;


CREATE TABLE vendedores(
    id int(10) not null auto_increment,
    grupo_id int(10) not null,
    jefe int(10),
    nombre varchar(100) not null,
    apellidos varchar(100),
    cargo varchar(40),
    fecha date,
    sueldo float(20,2),
    comision float(10,2),
    CONSTRAINT pk_vendedores PRIMARY KEY(id),
    CONSTRAINT fk_vendedor_grupo FOREIGN KEY(grupo_id) REFERENCES grupos(id),
    CONSTRAINT fk_vendedor_jefe FOREIGN KEY(jefe) REFERENCES vendedores(id) 
)ENGINE=InnoDB;

CREATE TABLE clientes(
    id int(10) not null auto_increment,
    vendedor_id int(10) not null,
    nombre varchar(100) not null,
    ciudad varchar(100),
    gastado float(50,2),
    fecha date,
    CONSTRAINT pk_clientes PRIMARY KEY(id), 
    CONSTRAINT fk_cliente_vendedor FOREIGN KEY(vendedor_id) REFERENCES vendedores(id)
)ENGINE=InnoDB;

CREATE TABLE encargos(
    id int(10) not null auto_increment,
    cliente_id int(10) not null ,
    coche_id int(10) not null,
    cantidad int(100) not null,
    fecha date,
     CONSTRAINT pk_encargos PRIMARY KEY(id), 
     CONSTRAINT fk_encargo_cliente FOREIGN KEY(cliente_id) REFERENCES clientes(id), 
     CONSTRAINT fk_encargo_coche FOREIGN KEY(coche_id) REFERENCES coches(id)
)ENGINE=InnoDB;

------------------------------------------------

INSERT INTO coches VALUES(NULL, "renault", "renault-i", 14000, 13 );
INSERT INTO coches VALUES(NULL, "ferrari", "ferrari-i", 180300, 15 );
INSERT INTO coches VALUES(NULL, "mazda-miata", "mazda-i", 120400, 1 );
INSERT INTO coches VALUES(NULL, "supra", "supra-i", 123000, 15 );
INSERT INTO coches VALUES(NULL, "chevrolet", "chevrolet-i", 142000, 50 );
INSERT INTO coches VALUES(NULL, "lambor", "lambo-i", 1000, 100 );

--------------------------------------------------------------------

INSERT INTO grupos VALUES(NULL, "directores mecanicos", "new zealand" );
INSERT INTO grupos VALUES(NULL, "vendedores-A", "pereira" );
INSERT INTO grupos VALUES(NULL, "vendedores-B", "armenia" );
INSERT INTO grupos VALUES(NULL, "vendedores-C", "manizales" );
INSERT INTO grupos VALUES(NULL, "vendedores-E", "monteria" );
INSERT INTO grupos VALUES(NULL, "vendedores-F", "chinchina" );

-------------------VENDEDORES----------------------------------

INSERT INTO vendedores VALUES(NULL, 1, NULL, "david", "lopez", "responsable de tienda", CURDATE(), 30000, 4 );
INSERT INTO vendedores VALUES(NULL, 1, 1, "juan", "camer", "tecnico", CURDATE(), 20000, 2 );
INSERT INTO vendedores VALUES(NULL, 1, NULL, "camilo", "quintero", "gerente", CURDATE(), 100000, 4 );
INSERT INTO vendedores VALUES(NULL, 1, 3, "daniel", "gomez", "cen", CURDATE(), 50000, 4 );
INSERT INTO vendedores VALUES(NULL, 1, NULL, "denison", "ten", "responsable de tienda2", CURDATE(), 30000, 4 );

----------------------CLIENTES------------------------------


INSERT INTO clientes VALUES(NULL, 1, "contrucciones Díaz", "pereira", "2000", CURDATE());

INSERT INTO clientes VALUES(NULL, 1, "carnicante", "chinchina", "5000", CURDATE());
INSERT INTO clientes VALUES(NULL, 1, "carnicante", "manizales", "74000", CURDATE());
INSERT INTO clientes VALUES(NULL, 1, "carnicante", "santa marta", "90000", CURDATE());
INSERT INTO clientes VALUES(NULL, 1, "carnicante", "meta", "10000", CURDATE());

---------------ENCARGOS------------------------------------

INSERT INTO encargos VALUES(NULL, 1, 1, 2, CURDATE());
INSERT INTO encargos VALUES(NULL, 2, 2, 4, CURDATE());
INSERT INTO encargos VALUES(NULL, 3, 3, 1, CURDATE());
INSERT INTO encargos VALUES(NULL, 4, 3, 1, CURDATE());
INSERT INTO encargos VALUES(NULL, 5, 6, 2, CURDATE());


--------------------------------------------------------------------

UPDATE vendedores SET comision= 0.5 WHERE sueldo >= 50000;

UPDATE coches SET precio = precio*1.05;

SELECT * FROM vendedores WHERE fecha >= '2018-07-1';  

SELECT nombre, DATEDIFF(CURDATE(), fecha) AS dias FROM vendedores ;

SELECT CONCAT(nombre, " " , apellidos), fecha, DAYNAME(fecha) FROM vendedores;

SELECT nombre, apellidos, sueldo FROM vendedores WHERE cargo= "responsable de tienda";

SELECT * FROM coches WHERE marca LIKE "%A%" AND modelo LIKE "L%";

SELECT * FROM vendedores WHERE grupo_id = 2 ORDER BY sueldo DESC;

SELECT apellidos, fecha, grupo_id FROM vendedores ORDER BY fecha DESC LIMIT 4;

SELECT cargo, COUNT(cargo) FROM vendedores GROUP BY cargo; 

SELECT SUM(sueldo) FROM vendedores;

SELECT grupos.nombre, grupos.id, AVG(sueldo) FROM vendedores, grupos GROUP BY grupo_id HAVING vendedores.grupo_id = grupos.id;


-----une tablas a traves de claves forraneas------
SELECT co.modelo, cl.nombre, SUM(e.cantidad) FROM encargos e INNER JOIN coches co ON co.id = e.coche_id 
INNER JOIN  clientes cl ON cl.id = e.cliente_id GROUP BY e.coche_id, e.cliente_id ;


SELECT co.modelo, cl.nombre, e.cantidad FROM encargos e INNER JOIN coches co ON co.id = e.coche_id 
INNER JOIN  clientes cl ON cl.id = e.cliente_id;


SELECT e.cliente_id,  cl.nombre, SUM(e.cantidad) AS 'cantidad_pedido' FROM encargos e INNER JOIN clientes cl ON  cl.id = e.cliente_id GROUP BY e.cliente_id  ORDER BY cantidad_pedido DESC ;  


------------cuenta los pedidos y los organiza por la columna 2---------------
SELECT cliente_id, COUNT(id) FROM encargos GROUP BY cliente_id ORDER BY 2 DESC LIMIT 2;



SELECT cl.nombre, v.nombre  FROM clientes cl INNER JOIN vendedores v ON v.id = cl.vendedor_id WHERE v.nombre = 'david' ;

SELECT e.id, cl.nombre, CONCAT(co.modelo, " ", co.marca) AS 'coche', e.cantidad FROM encargos e INNER JOIN clientes cl ON cl.id = e.cliente_id INNER JOIN coches co ON co.id = e.coche_id WHERE cl.nombre = 'emi';


SELECT cl.id, cl.nombre, co.modelo FROM encargos e INNER JOIN clientes cl ON cl.id = e.id INNER JOIN coches co ON co.id = e.id WHERE co.modelo = "supra";


--------subconsultas----------------
SELECT * FROM clientes WHERE id IN (SELECT cliente_id FROM encargos WHERE coche_id IN ( SELECT id FROM coches WHERE modelo LIKE 'supra'));

SELECT  FROM clientes INNER JOIN vendedores ve ON ve GROUP BY vendedor_id HAVING COUNT(vendedor_id) >= 2 ;


SELECT * FROM vendedores WHERE id IN (SELECT vendedor_id FROM clientes GROUP BY vendedor_id HAVING COUNT(vendedor_id) >= 2 ) ; 


SELECT * FROM grupos WHERE id IN (SELECT grupo_id FROM vendedores ORDER BY sueldo DESC LIMIT 1);

SELECT grupo_id, nombre, (SELECT nombre FROM grupos WHERE id = grupo_id) AS 'grupo' FROM vendedores ORDER BY sueldo DESC LIMIT 1;


SELECT id, nombre, ciudad FROM clientes WHERE id IN (SELECT cliente_id FROM encargos GROUP BY cliente_id HAVING COUNT(cliente_id) = 2 );

SELECT cl.id, cl.nombre, ve.id, ve.nombre AS 'vendedor' FROM clientes cl INNER JOIN vendedores ve ON ve.id = cl.vendedor_id;



--- unir tablar la misma tabla ----------
SELECT v.id, v.nombre as 'vendedor', vv.id,  vv.nombre as 'jefe' FROM vendedores v INNER JOIN vendedores vv ON vv.id = v.jefe;


SELECT cl.nombre, COUNT(e.cliente_id) as 'pedidos'  FROM encargos e RIGHT JOIN clientes cl ON cl.id = e.cliente_id GROUP BY e.cliente_id ;


SELECT ve.nombre, COUNT(cl.vendedor_id) as 'clientes' FROM clientes cl RIGHT JOIN vendedores ve ON ve.id = cl.vendedor_id GROUP BY ve.id;

CREATE VIEW vendedoresA AS SELECT * FROM vendedores WHERE grupo_id IN (SELECT id FROM grupos WHERE nombre = 'vendedores-A');