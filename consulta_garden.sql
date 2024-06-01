-- Este documento contiene las consultas de la base de datos "garden.sql"

use garden;

/*
	1. Devuelve un listado con el código de oficina y la ciudad donde hay oficinas.
*/



SELECT 	
	o.codigoOficina,
	c.nombre
FROM 	
	oficina as o,
	direccionOficina as do,
	ciudad as c
where 	
	o.codigoOficina = do.fkCodigoOficina AND
	c.idCiudad = fkIdCiudad;

/*
	2. Devuelve un listado con la ciudad y el teléfono de las oficinas de España.
*/

SELECT 	
	distinct c.nombre as Ciudad,
	tof.numero as NumTelefono
FROM 	
	oficina as o,
	direccionOficina as do,
	ciudad as c,
	region as r,
	pais as p,
	telefonoOficina as tof,
	tipoTelefono as tt
WHERE 	
	o.codigoOficina = do.fkCodigoOficina AND
	c.idCiudad = do.fkIdCiudad AND
	tof.fkCodigoOficina = o.codigoOficina AND
	c.fkIdRegion = r.idRegion AND
	r.fkIdPais = p.idPais AND 
	p.idPais = 1;

/*
	*3.* Devuelve un listado con el nombre, apellidos y email de los empleados cuyo
jefe tiene un código de jefe igual a 7.
*/

SELECT 	
	nombre,
	concat(apellido1, ' ',  apellido2) as apellidos,
	email
FROM
	empleado
WHERE 
	fkCodigoJefe = 71;

/*
	*4.* Devuelve el nombre del puesto, nombre, apellidos y email del jefe de la
empresa.

*/

SELECT 	
	ce.cargo,
	e.nombre,
	concat(e.apellido1, ' ',  e.apellido2) as apellidos,
	e.email
FROM
	empleado as e,
	cargoEmpleado as ce
WHERE
	fkCodigoJefe is NULL AND
	e.fkCargoEmpleado = idCargoEmpleado ;
	
/*

/*
	*5.* Devuelve un listado con el nombre, apellidos y puesto de aquellos
empleados que no sean representantes de ventas.
*/

SELECT 	
	e.nombre,
	concat(e.apellido1, ' ',  e.apellido2) as apellidos,
	ce.cargo
FROM
	empleado as e,
	cargoEmpleado as ce
WHERE
	e.fkCargoEmpleado <> 8 AND
	e.fkCargoEmpleado = ce.idCargoEmpleado;

/*
	*6.* Devuelve un listado con el nombre de los todos los clientes españoles.
*/

SELECT 	
	cl.nombreCliente as Empresa
FROM 	
	cliente as cl,
	direccionCliente as dc,
	ciudad as c,
	region as r,
	pais as p
WHERE 	
	c.idCiudad = dc.fkIdCiudad AND
	cl.codigoCliente = dc.fkCodigoCliente AND
	c.fkIdRegion = r.idRegion AND
	r.fkIdPais = p.idPais AND 
	p.idPais = 1;
/*
	*7.* Devuelve un listado con los distintos estados por los que puede pasar un
pedido.
*/


SELECT
	estado
FROM
	estadoPedido;

/*
| estado                |
|:--------------------:|
| Creado                |
| En tránsito           |
| Entregado             |
| Destinatario ausente  |
| Pendiente de recogida |
| En devolución         |
| Retenido en aduanas   |

*/

/*
	*8.* Devuelve un listado con el código de cliente de aquellos clientes que
realizaron algún pago en 2008. Tenga en cuenta que deberá eliminar
aquellos códigos de cliente que aparezcan repetidos. Resuelva la consulta:

	**- Utilizando la función YEAR de MySQL.**
*/

SELECT
	fkCodigoCliente as codigoCliente
FROM
	pago
WHERE
	YEAR(fechaPago) = '2008'
GROUP BY
	codigoCliente;

/*

| codigoCliente |
|:-------------:|
|             1 |
|             2 |
|             4 |
|             5 |
|             6 |
*/

/*
	**- Utilizando la función DATE_FORMAT de MySQL.**
*/

SELECT
	fkCodigoCliente as codigoCliente
FROM
	pago
WHERE
	DATE_FORMAT(fechaPago, "%Y") = '2008'
GROUP BY
	codigoCliente;

/*

| codigoCliente |
|:-------------:|
|             1 |
|             2 |
|             4 |
|             5 |
|             6 |
*/


/*
	**- Sin utilizar ninguna de las funciones anteriores.**
*/

SELECT
	fkCodigoCliente as codigoCliente
FROM
	pago
WHERE
	SUBSTRING(fechaPago, 1, LOCATE('-', fechaPago) - 1) = '2008'
GROUP BY
	codigoCliente;

/*

| codigoCliente |
|:-------------:|
|             1 |
|             2 |
|             4 |
|             5 |
|             6 |
*/



/*
	*9.* Devuelve un listado con el código de pedido, código de cliente, fecha
esperada y fecha de entrega de los pedidos que no han sido entregados a
tiempo.
*/

SELECT
	codigoPedido,
	fkCodigoCliente,
	fechaEsperada,
	fechaEntrega
FROM
	pedido
WHERE
	DATEDIFF(fechaEsperada, fechaEntrega) < 0;
	
/*
| codigoPedido | fkCodigoCliente | fechaEsperada | fechaEntrega |
|:------------:|:---------------:|:-------------:|:------------:|
|            1 |               1 | 2008-07-20    | 2008-07-23   |
|            2 |               2 | 2008-04-20    | 2008-05-02   |
|            5 |               5 | 2008-10-21    | 2008-10-23   |
|            8 |               8 | 2007-04-03    | 2007-04-23   |

*/

/*
	*10.* Devuelve un listado con el código de pedido, código de cliente, fecha
esperada y fecha de entrega de los pedidos cuya fecha de entrega ha sido al
menos dos días antes de la fecha esperada.
*/
	
/*
	- Utilizando la función ADDDATE de MySQL.
*/

SELECT
	codigoPedido,
	fkCodigoCliente,
	fechaEsperada,
	fechaEntrega
FROM
	pedido
WHERE
	ADDDATE(fechaEntrega, INTERVAL 2 DAY) <= fechaEsperada;

/*
| codigoPedido | fkCodigoCliente | fechaEsperada | fechaEntrega |
|:------------:|:---------------:|:-------------:|:------------:|
|            6 |               6 | 2008-09-21    | 2008-09-19   |

*/

/*
	- Utilizando la función DATEDIFF de MySQL.
*/

SELECT
	codigoPedido,
	fkCodigoCliente,
	fechaEsperada,
	fechaEntrega
FROM
	pedido
WHERE
	DATEDIFF(fechaEsperada, fechaEntrega) >= 2;

/*
| codigoPedido | fkCodigoCliente | fechaEsperada | fechaEntrega |
|:------------:|:---------------:|:-------------:|:------------:|
|            6 |               6 | 2008-09-21    | 2008-09-19   |
*/

/*
	*11.* Devuelve un listado de todos los pedidos que fueron rechazados en 2009.
*/

SELECT
	codigoPedido,
	fechaEsperada
FROM
	pedido
WHERE
	YEAR(fechaPedido) = '2009' AND
	fkIdEstado = 8;
	
/*
| codigoPedido |
|:------------:|
|            9 |
|           10 |
|           11 |
|           12 |

/*
	*12.* Devuelve un listado de todos los pedidos que han sido entregados en el
mes de enero de cualquier año.
*/

SELECT
	codigoPedido,
	fechaEntrega
FROM
	pedido
where 
	fkIdEstado = 3 AND
	MONTH(fechaEntrega) = '01';
	
/*
| codigoPedido | fechaEntrega |
|:------------:|:------------:|
|           13 | 2012-01-04   |
|           15 | 2012-01-09   |
|           16 | 2010-01-15   |
*/

/*
	*13.* Devuelve un listado con todos los pagos que se realizaron en el
año 2008 mediante Paypal. Ordene el resultado de mayor a menor.
*/

SELECT	
	idTransaccion,
	fechaPago,
	total
FROM
	pago
WHERE
	YEAR(fechaPago) = '2008' AND
	fkIdFormaPago = 6
ORDER BY
	total DESC;
	
/*
| idTransaccion | fechaPago  | total       |
|:-------------:|:----------:|:-----------:|
| ALK54545654   | 2008-01-10 | 10582000.00 |
| AHV51515654   | 2008-09-17 |  5150000.00 |
| AHJ51215055   | 2008-07-02 |  3540000.00 |
| FGH51651654   | 2008-03-14 |  2560000.00 |

*/

/*
	*14.* Devuelve un listado con todas las formas de pago que aparecen en la
tabla pago. Tenga en cuenta que no deben aparecer formas de pago
repetidas.
*/

SELECT
	f.formaDePago
FROM
	formaPago as f,
	pago as p
WHERE
	p.fkIdFormaPago = f.idFormaPago

GROUP BY
	formaDePago;

/*	
| formaDePago           |
|:---------------------:|
| Efectivo              |
| Tarjeta crédito       |
| Cheque                |
| Transferencia de pago |
| Paypal                |
*/

	*15.* Devuelve un listado con todos los productos que pertenecen a la
gama Ornamentales y que tienen más de 100 unidades en stock. El listado
deberá estar ordenado por su precio de venta, mostrando en primer lugar
los de mayor precio.
*/

SELECT
	p.nombre as Producto,
	pp.cantidaEnStock as stock,
	pp.precioVenta,
	pr.nombre as Proveedor
FROM
	producto as p,
	productoProveedor as pp,
	gama_producto as gm,
	proveedor as pr
WHERE
	p.fkIdGama = gm.idGama AND
	p.codigoProducto = pp.fkCodigoProducto AND
	pr.idProveedor = pp.fkIdProveedor AND
	gm.idGama = 'ORNAMENTALES' AND
	pp.cantidaEnStock > 100
ORDER BY
	pp.precioVenta DESC;

/*
| Producto  | stock | precioVenta | Proveedor                  |
|:---------:|:-----:|:-----------:|:--------------------------:|
| Helecho A |   125 |    15000.00 | SEVILLA PLANTAS S.A        |
| Helecho A |   109 |    13000.00 | VERDE COBRIZO              |
| Begonia A |   108 |    12500.00 | ROSITAS DE KYOTO S.A       |
| Helecho B |   135 |    11000.00 | MIS PLANTOTAS BUACARAMANGA |
| Begonia A |   102 |     9500.00 | ORQUÍDEA JUÁREZ            |
| Helecho C |   136 |     6500.00 | JARDIN EDÉN ZARAGOZA       |
*/

/*
	*16.* Devuelve un listado con todos los clientes que sean de la ciudad de Madrid y
cuyo representante de ventas tenga el código de empleado 87 o 97.
*/

SELECT 
	cl.nombreCliente,
	cl.fkCodigoEMpleadoRepVentas
FROM
	cliente as cl,
	direccionCliente as dc,
	ciudad as c
WHERE
	dc.fkCodigoCliente = cl.codigoCliente AND
	c.idCiudad = dc.fkIdCiudad AND
	c.idCiudad = 4;

/*
| nombreCliente                  | fkCodigoEMpleadoRepVentas |
|:------------------------------:|:-------------------------:|
| JARDÍN MADRILEÑO               |                        87 |
| INDUSTRIAL JARDINERA DE MADRID |                        97 |
*/

/*
	*2.* Muestra el nombre de los clientes que hayan realizado pagos junto con el
nombre de sus representantes de ventas.
*/

SELECT
	DISTINCT cl.nombreCliente as Cliente,
	e.nombre as nombreReprVentas,
	CONCAT(e.apellido1, ' ', e.apellido2) as apellidoReprVentas
FROM
	pago as p
INNER JOIN
	cliente as cl
ON
	p.fkCodigoCliente = cl.codigoCliente
LEFT JOIN
	empleado as e
ON
	cl.fkCodigoEMpleadoRepVentas = e.codigoEmpleado;

	
/*
| Cliente                                        | nombreReprVentas | apellidoReprVentas |
|:----------------------------------------------:|:----------------:|:------------------:|
| AGRO-Spain Ingenieros                          | Mario            | Galvis Olago       |
| Agropecuària de Moià                           | NULL             | NULL               |
| AGROPECUARIA RIO FRIO LTDA                     | Daniel           | Tobón Comba        |
| Casagro                                        | NULL             | NULL               |
| Central Agroindustrial Mexiquense S.A. de C.V. | Ángela           | Gutierrez Arango   |
| Compo Iberia SL                                | Daniel           | Tobón Comba        |
| EXPLOTACIONES AGRICOLAS VALJIMENO S.L.         | Ángela           | Gutierrez Arango   |
| Punto Verde Agro Toluca                        | María            | Correa Martínez    |
*/

-- CONSULTAS MULTITABLA

/*
	*1.* Obtén un listado con el nombre de cada cliente y el nombre y apellido de su
representante de ventas.
*/

SELECT 
	cl.nombreCliente as Cliente,
	e.nombre as nombreReprVentas,
	CONCAT(e.apellido1, ' ', e.apellido2) as apellidoReprVentas
FROM
	cliente as cl
LEFT JOIN
	empleado as e
ON
	cl.fkCodigoEMpleadoRepVentas = e.codigoEmpleado;
	
/*
| Cliente                                        | nombreReprVentas | apellidoReprVentas |
+------------------------------------------------+------------------+--------------------+
| EXPLOTACIONES AGRICOLAS VALJIMENO S.L.         | Ángela           | Gutierrez Arango   |
| AGRO-Spain Ingenieros                          | Mario            | Galvis Olago       |
| Agropecuària de Moià                           | NULL             | NULL               |
| Compo Iberia SL                                | Daniel           | Tobón Comba        |
| Central Agroindustrial Mexiquense S.A. de C.V. | Ángela           | Gutierrez Arango   |
| Punto Verde Agro Toluca                        | María            | Correa Martínez    |
| AGROPECUARIA RIO FRIO LTDA                     | Daniel           | Tobón Comba        |
| Casagro                                        | NULL             | NULL               |
| JARDÍN MADRILEÑO                               | Ángela           | Gutierrez Arango   |
| INDUSTRIAL JARDINERA DE MADRID                 | Daniel           | Tobón Comba        |
*/

/*
	*2.* Muestra el nombre de los clientes que hayan realizado pagos junto con el
nombre de sus representantes de ventas.
*/

SELECT
	DISTINCT cl.nombreCliente as Cliente,
	e.nombre as nombreReprVentas,
	CONCAT(e.apellido1, ' ', e.apellido2) as apellidoReprVentas
FROM
	pago as p
INNER JOIN
	cliente as cl
ON
	p.fkCodigoCliente = cl.codigoCliente
LEFT JOIN
	empleado as e
ON
	cl.fkCodigoEMpleadoRepVentas = e.codigoEmpleado;

	
/*
| Cliente                                        | nombreReprVentas | apellidoReprVentas |
|:----------------------------------------------:|:----------------:|:------------------:|
| AGRO-Spain Ingenieros                          | Mario            | Galvis Olago       |
| Agropecuària de Moià                           | NULL             | NULL               |
| AGROPECUARIA RIO FRIO LTDA                     | Daniel           | Tobón Comba        |
| Casagro                                        | NULL             | NULL               |
| Central Agroindustrial Mexiquense S.A. de C.V. | Ángela           | Gutierrez Arango   |
| Compo Iberia SL                                | Daniel           | Tobón Comba        |
| EXPLOTACIONES AGRICOLAS VALJIMENO S.L.         | Ángela           | Gutierrez Arango   |
| Punto Verde Agro Toluca                        | María            | Correa Martínez    |

*/


/*
	*3.* Muestra el nombre de los clientes que no hayan realizado pagos junto con
el nombre de sus representantes de ventas.
*/
	
SELECT
	DISTINCT cl.nombreCliente as Cliente,
	e.nombre as nombreReprVentas,
	CONCAT(e.apellido1, ' ', e.apellido2) as apellidoReprVentas
FROM
	pago as p
RIGHT JOIN
	cliente as cl
ON
	p.fkCodigoCliente = cl.codigoCliente
LEFT JOIN
	empleado as e
ON
	cl.fkCodigoEMpleadoRepVentas = e.codigoEmpleado
WHERE
	p.idTransaccion is NULL;
	
/*
| Cliente                        | nombreReprVentas | apellidoReprVentas |
|:------------------------------:|:----------------:|:------------------:|
| JARDÍN MADRILEÑO               | Ángela           | Gutierrez Arango   |
| INDUSTRIAL JARDINERA DE MADRID | Daniel           | Tobón Comba        |
*/

/*
	*4.* Devuelve el nombre de los clientes que han hecho pagos y el nombre de sus
representantes junto con la ciudad de la oficina a la que pertenece el
representante.
*/

SELECT
	DISTINCT cl.nombreCliente as Cliente,
	e.nombre as nombreReprVentas,
	CONCAT(e.apellido1, ' ', e.apellido2) as apellidoReprVentas,
	c.nombre as CiudadOficina
FROM
	pago as p
INNER JOIN
	cliente as cl
ON
	p.fkCodigoCliente = cl.codigoCliente
LEFT JOIN
	empleado as e
ON
	cl.fkCodigoEMpleadoRepVentas = e.codigoEmpleado
INNER JOIN
	oficina as ofc
ON
	ofc.codigoOficina = e.fkCodigoOficina
INNER JOIN
	direccionOficina as do
ON
	do.fkCodigoOficina = ofc.codigoOficina
INNER JOIN
	ciudad as c
ON
	c.idCiudad = do.fkIdCiudad;

/*
| Cliente                                        | nombreReprVentas | apellidoReprVentas | CiudadOficina |
|:----------------------------------------------:|:----------------:|:------------------:|:-------------:|
| EXPLOTACIONES AGRICOLAS VALJIMENO S.L.         | Ángela           | Gutierrez Arango   | Madrid        |
| AGRO-Spain Ingenieros                          | Mario            | Galvis Olago       | Zaragoza      |
| Compo Iberia SL                                | Daniel           | Tobón Comba        | Medellín      |
| Central Agroindustrial Mexiquense S.A. de C.V. | Ángela           | Gutierrez Arango   | Madrid        |
| Punto Verde Agro Toluca                        | María            | Correa Martínez    | Medellín      |
| AGROPECUARIA RIO FRIO LTDA                     | Daniel           | Tobón Comba        | Medellín      |
*/

/*
	*5.* Devuelve el nombre de los clientes que no hayan hecho pagos y el nombre
de sus representantes junto con la ciudad de la oficina a la que pertenece el
representante.
*/


SELECT
	DISTINCT cl.nombreCliente as Cliente,
	e.nombre as nombreReprVentas,
	CONCAT(e.apellido1, ' ', e.apellido2) as apellidoReprVentas,
	c.nombre as CiudadOficina
FROM
	pago as p
RIGHT JOIN
	cliente as cl
ON
	p.fkCodigoCliente = cl.codigoCliente
LEFT JOIN
	empleado as e
ON
	cl.fkCodigoEMpleadoRepVentas = e.codigoEmpleado
INNER JOIN
	oficina as ofc
ON
	ofc.codigoOficina = e.fkCodigoOficina
INNER JOIN
	direccionOficina as do
ON
	do.fkCodigoOficina = ofc.codigoOficina
INNER JOIN
	ciudad as c
ON
	c.idCiudad = do.fkIdCiudad
WHERE
	p.idTransaccion is NULL;

/*
	*6.* Lista la dirección de las oficinas que tengan clientes en Madrid.
*/

SELECT
	do.direccion,
	c.nombre as CiudadCliente
FROM
	ciudad as c
INNER JOIN
	direccionCliente as dc
ON
	c.idCiudad = dc.fkIdCiudad
INNER JOIN
	cliente as cl
ON
	cl.codigoCliente = dc.fkCodigoCliente
INNER JOIN
	empleado as e
ON
	e.codigoEmpleado = cl.fkCodigoEMpleadoRepVentas
INNER JOIN
	oficina as ofc
ON
	ofc.codigoOficina = e.fkCodigoOficina
INNER JOIN
	direccionOficina as do
ON
	do.fkCodigoOficina = ofc.codigoOficina
WHERE
	c.idCiudad = 4;
	
/*
| direccion                      | CiudadCliente |
|:------------------------------:|:------:|
| C. de Montalbán, 1, Retiro     | Madrid |
| Cl 44 #52 - 165, La Candelaria | Madrid |

*/
	
/*
	*7.* Devuelve el nombre de los clientes y el nombre de sus representantes junto
con la ciudad de la oficina a la que pertenece el representante.
*/

	
SELECT
	DISTINCT cl.nombreCliente as Cliente,
	e.nombre as nombreReprVentas,
	CONCAT(e.apellido1, ' ', e.apellido2) as apellidoReprVentas,
	c.nombre as CiudadOficina
FROM
	pago as p
INNER JOIN
	cliente as cl
ON
	p.fkCodigoCliente = cl.codigoCliente
LEFT JOIN
	empleado as e
ON
	cl.fkCodigoEMpleadoRepVentas = e.codigoEmpleado
INNER JOIN
	oficina as ofc
ON
	ofc.codigoOficina = e.fkCodigoOficina
INNER JOIN
	direccionOficina as do
ON
	do.fkCodigoOficina = ofc.codigoOficina
INNER JOIN
	ciudad as c
ON
	c.idCiudad = do.fkIdCiudad;
	
	
/*
| Cliente                                        | nombreReprVentas | apellidoReprVentas | CiudadOficina |
|:----------------------------------------------:|:----------------:|:------------------:|:-------------:|
| EXPLOTACIONES AGRICOLAS VALJIMENO S.L.         | Ángela           | Gutierrez Arango   | Madrid        |
| AGRO-Spain Ingenieros                          | Mario            | Galvis Olago       | Zaragoza      |
| Compo Iberia SL                                | Daniel           | Tobón Comba        | Medellín      |
| Central Agroindustrial Mexiquense S.A. de C.V. | Ángela           | Gutierrez Arango   | Madrid        |
| Punto Verde Agro Toluca                        | María            | Correa Martínez    | Medellín      |
| AGROPECUARIA RIO FRIO LTDA                     | Daniel           | Tobón Comba        | Medellín      |
*/	
	

/*
	*8.* Devuelve un listado con el nombre de los empleados junto con el nombre
de sus jefes.
*/
	
SELECT
	e.nombre as nombreEmpleado,
	CONCAT(e.apellido1, ' ', e.apellido2) as apellidoEmpleado,
	j.nombre as nombreJefe,
	CONCAT(j.apellido1, ' ', j.apellido2) as apellidoJefe
FROM
	empleado as e
INNER JOIN
	empleado as j
ON
	e.fkCodigoJefe = j.codigoEmpleado;
	
/*
| nombreEmpleado  | apellidoEmpleado | nombreJefe      | apellidoJefe     |
|:---------------:|:----------------:|:---------------:|:----------------:|
| Luis Alfonso    | Gómez Mancilla   | Carlos Jhoan    | Aguilar Galvis   |
| Javier Augusto  | Galvis Chacón    | Luis Alfonso    | Gómez Mancilla   |
| Julio César     | Galvis Chacón    | Javier Augusto  | Galvis Chacón    |
| Sandra Patricia | González Amador  | Carlos Jhoan    | Aguilar Galvis   |
| Clara Milena    | Aguilar Bella    | Sandra Patricia | González Amador  |
| Juan David      | Gómez Benavides  | Carlos Jhoan    | Aguilar Galvis   |
| Ángela          | Gutierrez Arango | Juan David      | Gómez Benavides  |
| Daniel          | Tobón Comba      | Juan David      | Gómez Benavides  |
| María           | Correa Martínez  | Juan David      | Gómez Benavides  |
| Mario           | Galvis Olago     | Juan David      | Gómez Benavides  |
*/

/*
	*9.* Devuelve un listado que muestre el nombre de cada empleados, el nombre
de su jefe y el nombre del jefe de sus jefe.
*/


SELECT
	e.nombre as nombreEmpleado,
	CONCAT(e.apellido1, ' ', e.apellido2) as apellidoEmpleado,
	j.nombre as nombreJefe,
	CONCAT(j.apellido1, ' ', j.apellido2) as apellidoJefe,
	f.nombre as nombreJefeJefe,
	CONCAT(f.apellido1, ' ', f.apellido2) as apellidoJefeJefe
FROM
	empleado as e
INNER JOIN
	empleado as j
ON
	e.fkCodigoJefe = j.codigoEmpleado
INNER JOIN
	empleado as f
ON
	j.fkCodigoJefe = f.codigoEmpleado;	
	
/*
| nombreEmpleado | apellidoEmpleado | nombreJefe      | apellidoJefe     | nombreJefeJefe | apellidoJefeJefe |
|:--------------:|:----------------:|:---------------:|:----------------:|:--------------:|:----------------:|
| Javier Augusto | Galvis Chacón    | Luis Alfonso    | Gómez Mancilla   | Carlos Jhoan   | Aguilar Galvis   |
| Julio César    | Galvis Chacón    | Javier Augusto  | Galvis Chacón    | Luis Alfonso   | Gómez Mancilla   |
| Clara Milena   | Aguilar Bella    | Sandra Patricia | González Amador  | Carlos Jhoan   | Aguilar Galvis   |
| Ángela         | Gutierrez Arango | Juan David      | Gómez Benavides  | Carlos Jhoan   | Aguilar Galvis   |
| Daniel         | Tobón Comba      | Juan David      | Gómez Benavides  | Carlos Jhoan   | Aguilar Galvis   |
| María          | Correa Martínez  | Juan David      | Gómez Benavides  | Carlos Jhoan   | Aguilar Galvis   |
| Mario          | Galvis Olago     | Juan David      | Gómez Benavides  | Carlos Jhoan   | Aguilar Galvis   |
*/

/*
	*10.* Devuelve el nombre de los clientes a los que no se les ha entregado a
tiempo un pedido.
*/

SELECT
	cl.nombreCliente,
	p.fechaEsperada,
	p.fechaEntrega
FROM
	cliente as cl
INNER JOIN
	pedido as p
ON
	p.fkCodigoCliente = cl.codigoCliente
WHERE
	DATEDIFF(p.fechaEsperada, p.fechaEntrega) < 0;


/*
| nombreCliente                                  | fechaEsperada | fechaEntrega |
|:----------------------------------------------:|:-------------:|:------------:|
| EXPLOTACIONES AGRICOLAS VALJIMENO S.L.         | 2008-07-20    | 2008-07-23   |
| AGRO-Spain Ingenieros                          | 2008-04-20    | 2008-05-02   |
| Central Agroindustrial Mexiquense S.A. de C.V. | 2008-10-21    | 2008-10-23   |
| Casagro                                        | 2007-04-03    | 2007-04-23   |
*/


/*
	*11.* Devuelve un listado de las diferentes gamas de producto que ha comprado
cada cliente.
*/

SELECT
	gm.idGama,
	cl.nombreCliente
FROM
	cliente as cl
INNER JOIN
	pedido as pd
ON
	cl.codigoCliente = pd.fkCodigoCliente
INNER JOIN
	detallePedido as dp
ON
	dp.fkCodigoPedido = pd.codigoPedido
INNER JOIN
	producto as p
ON
	p.codigoProducto = dp.fkCodigoProducto
INNER JOIN
	gama_producto as gm
ON
	gm.idGama = p.fkIdGama;
	
/*
| idGama       | nombreCliente                                  |
|:------------:|:----------------------------------------------:|
| ORNAMENTALES | Central Agroindustrial Mexiquense S.A. de C.V. |
| FRUTALES     | Punto Verde Agro Toluca                        |
| HERRAMIENTAS | EXPLOTACIONES AGRICOLAS VALJIMENO S.L.         |
| HERRAMIENTAS | Central Agroindustrial Mexiquense S.A. de C.V. |
| ORNAMENTALES | EXPLOTACIONES AGRICOLAS VALJIMENO S.L.         |
| ORNAMENTALES | Punto Verde Agro Toluca                        |
| FRUTALES     | EXPLOTACIONES AGRICOLAS VALJIMENO S.L.         |
| FRUTALES     | Central Agroindustrial Mexiquense S.A. de C.V. |
*/

-- CONSULTAS MULTITABLA (externa)

/*
	*1*. Devuelve un listado que muestre solamente los clientes que no han
realizado ningún pago.
*/

SELECT
	cl.nombreCliente
FROM
	cliente as cl
LEFT JOIN
	pago as p
ON
	cl.codigoCliente = p.fkCodigoCliente
WHERE
	p.fkCodigoCliente is NULL;
	

/*
| nombreCliente                  |
|:------------------------------:|
| JARDÍN MADRILEÑO               |
| INDUSTRIAL JARDINERA DE MADRID |

*/
	

/*
	*2.* Devuelve un listado que muestre solamente los clientes que no han
realizado ningún pedido.
*/


SELECT
	cl.nombreCliente,
	pd.codigoPedido
FROM
	cliente as cl
LEFT JOIN
	pedido as pd
ON
	cl.codigoCliente = pd.fkCodigoCliente
WHERE
	pd.codigoPedido is NULL;

/*
| nombreCliente                  | codigoPedido |
|:------------------------------:|:------------:|
| JARDÍN MADRILEÑO               |         NULL |
| INDUSTRIAL JARDINERA DE MADRID |         NULL |
*/

/*
	*3.* Devuelve un listado que muestre los clientes que no han realizado ningún
pago y los que no han realizado ningún pedido.
*/

SELECT
	cl.nombreCliente,
	p.fkCodigoCliente,
	pd.codigoPedido
FROM
	cliente as cl
LEFT JOIN
	pago as p
ON
	cl.codigoCliente = p.fkCodigoCliente

LEFT JOIN
	pedido as pd
ON
	cl.codigoCliente = pd.fkCodigoCliente
WHERE
	pd.codigoPedido is NULL OR
	p.fkCodigoCliente is NULL;

/*
| nombreCliente                  | codigoPedido |
|:------------------------------:|:------------:|
| JARDÍN MADRILEÑO               |         NULL |
| INDUSTRIAL JARDINERA DE MADRID |         NULL |
*/

	
/*
	*4.* Devuelve un listado que muestre solamente los empleados que no tienen
una oficina asociada.
*/

SELECT
	e.codigoEmpleado,
	e.nombre AS nombreEmpleado,
	CONCAT(e.apellido1, ' ', e.apellido2) AS apellidosEmpleados
FROM
	empleado as e
LEFT JOIN
	oficina as ofc
ON
	e.fkCodigoOficina = ofc.codigoOficina
WHERE
	ofc.codigoOficina is NULL;


/*
| codigoEmpleado | nombreEmpleado | apellidosEmpleados  |
|:--------------:|:--------------:|:-------------------:|
|            120 | José Mauricio  | Manosalva Buitrago  |
|            121 | Karen Julieth  | Quintero Hernández  |
*/


/*
*5.* Devuelve un listado que muestre solamente los empleados que no tienen un
cliente asociado.
*/

SELECT
	e.codigoEmpleado,
	e.nombre AS nombreEmpleado,
	CONCAT(e.apellido1, ' ', e.apellido2) AS apellidosEmpleados
FROM
	empleado as e
LEFT JOIN
	cliente as cl
ON
	e.codigoEmpleado = cl.fkCodigoEMpleadoRepVentas
WHERE
	cl.codigoCliente is NULL;	


/*
| codigoEmpleado | nombreEmpleado  | apellidosEmpleados  |
|:--------------:|:---------------:|:-------------------:|
|             10 | Carlos Jhoan    | Aguilar Galvis      |
|             21 | Luis Alfonso    | Gómez Mancilla      |
|             32 | Javier Augusto  | Galvis Chacón       |
|             43 | Julio César     | Galvis Chacón       |
|             51 | Sandra Patricia | González Amador     |
|             65 | Clara Milena    | Aguilar Bella       |
|             71 | Juan David      | Gómez Benavides     |
|            120 | José Mauricio   | Manosalva Buitrago  |
|            121 | Karen Julieth   | Quintero Hernández  |
*/


/*
*6.* Devuelve un listado que muestre solamente los empleados que no tienen un
cliente asociado junto con los datos de la oficina donde trabajan.
*/


SELECT
	e.codigoEmpleado,
	e.nombre AS nombreEmpleado,
	CONCAT(e.apellido1, ' ', e.apellido2) AS apellidosEmpleados,
	ofc.codigoOficina,
	ofc.nombre AS nombreOficina
FROM
	empleado as e
LEFT JOIN
	cliente as cl
ON
	e.codigoEmpleado = cl.fkCodigoEMpleadoRepVentas
INNER JOIN
	oficina as ofc
ON
	e.fkCodigoOficina = ofc.codigoOficina
WHERE
	cl.codigoCliente is NULL;


/*
| codigoEmpleado | nombreEmpleado  | apellidosEmpleados | codigoOficina | nombreOficina             |
|:--------------:|:---------------:|:------------------:|:-------------:|:-------------------------:|
|             10 | Carlos Jhoan    | Aguilar Galvis     | OFCBUCCOL     | Oficina Bucaramanga       |
|             21 | Luis Alfonso    | Gómez Mancilla     | OFCBUCCOL     | Oficina Bucaramanga       |
|             32 | Javier Augusto  | Galvis Chacón      | OFCTOLMEX     | Oficina Toluca de Lerdo   |
|             43 | Julio César     | Galvis Chacón      | OFCPACMEX     | Oficina Pachuca           |
|             51 | Sandra Patricia | González Amador    | OFCCALCOL     | Oficina Cali              |
|             65 | Clara Milena    | Aguilar Bella      | OFCBARESP     | Oficina Barcelona         |
|             71 | Juan David      | Gómez Benavides    | OFCCDMXMEX    | Oficina Ciudad de México  |
/*


/*
*7.* Devuelve un listado que muestre los empleados que no tienen una oficina
asociada y los que no tienen un cliente asociado. 
*/


SELECT
	e.codigoEmpleado,
	e.nombre AS nombreEmpleado,
	CONCAT(e.apellido1, ' ', e.apellido2) AS apellidosEmpleados
FROM
	empleado as e
LEFT JOIN
	cliente as cl
ON
	e.codigoEmpleado = cl.fkCodigoEMpleadoRepVentas
LEFT JOIN
	oficina as ofc
ON
	e.fkCodigoOficina = ofc.codigoOficina
WHERE
	cl.codigoCliente is NULL OR
	ofc.codigoOficina is NULL;


/*
| codigoEmpleado | nombreEmpleado  | apellidosEmpleados  |
|:--------------:|:---------------:|:-------------------:|
|             10 | Carlos Jhoan    | Aguilar Galvis      |
|             21 | Luis Alfonso    | Gómez Mancilla      |
|             32 | Javier Augusto  | Galvis Chacón       |
|             43 | Julio César     | Galvis Chacón       |
|             51 | Sandra Patricia | González Amador     |
|             65 | Clara Milena    | Aguilar Bella       |
|             71 | Juan David      | Gómez Benavides     |
|            120 | José Mauricio   | Manosalva Buitrago  |
|            121 | Karen Julieth   | Quintero Hernández  |
*/


/*
*8.* Devuelve un listado de los productos que nunca han aparecido en un
pedido.
*/

SELECT
	pd.codigoProducto,
	pd.nombre as nombreProducto
FROM
	producto as pd
LEFT JOIN
	detallePedido as dp
ON
	pd.codigoProducto = dp.fkCodigoProducto
WHERE
	dp.fkCodigoProducto is NULL;

/*
| codigoProducto | nombreProducto    |
|:--------------:|:-----------------:|
| 11             | Semilla Curuba    |
| 12             | Semilla Chirimoya |
| 3              | Helecho C         |
| 5              | Begonia B         |
| 6              | Begonia C         |
| 8              | Semilla Maracuyá  |
*/


/*
*9.* Devuelve un listado de los productos que nunca han aparecido en un
pedido. El resultado debe mostrar el nombre, la descripción y la imagen del
producto.
*/


SELECT
	pd.nombre as nombreProducto,
	pd.descripcion,
	pd.imagen
FROM
	producto as pd
LEFT JOIN
	detallePedido as dp
ON
	pd.codigoProducto = dp.fkCodigoProducto
WHERE
	dp.fkCodigoProducto is NULL;


/*
| nombreProducto    | descripcion                         | imagen           |
|:-----------------:|:-----------------------------------:|:----------------:|
| Semilla Curuba    | Sembrarse en terreno seco           | ./semillcur.jpg  |
| Semilla Chirimoya | Sembrarse en terreno seco o húmedo  | ./semillchir.jpg |
| Helecho C         | Planta de exterior                  | ./helechoC.jpg   |
| Begonia B         | Planta de exterior                  | ./begoniaB.jpg   |
| Begonia C         | Planta de exterior                  | ./begoniaC.jpg   |
| Semilla Maracuyá  | Sembrarse en terreno seco           | ./semillmar.jpg  |
*/


/*
*10.* Devuelve las oficinas donde no trabajan ninguno de los empleados que
hayan sido los representantes de ventas de algún cliente que haya realizado
la compra de algún producto de la gama Frutales.
*/



SELECT
	ofi.codigoOficina
FROM
	oficina as ofi
WHERE
	ofi.codigoOficina NOT IN(
			SELECT	
				ofc.codigoOficina
			FROM
				oficina as ofc
			INNER JOIN
				empleado as e
			ON
				e.fkCodigoOficina = ofc.codigoOficina
			INNER JOIN
				cliente as cl
			ON
				cl.fkCodigoEMpleadoRepVentas = e.codigoEmpleado
			INNER JOIN
				pedido as ped
			ON
				ped.fkCodigoCliente = cl.codigoCliente
			INNER JOIN
				detallePedido as dp
			ON
				dp.fkCodigoPedido = ped.codigoPedido
			INNER JOIN
				producto as pd
			ON
				pd.codigoProducto = dp.fkCodigoProducto
			WHERE
				pd.fkIdGama = 'FRUTALES'
			GROUP BY 
				ofc.codigoOficina);

/*
| codigoOficina |
|:-------------:|
| OFCBARESP     |
| OFCBUCCOL     |
| OFCCALCOL     |
| OFCCDMXMEX    |
| OFCPACMEX     |
| OFCSEVESP     |
| OFCTOLMEX     |
| OFCZARESP     |
*/


/*
*11.* Devuelve un listado con los clientes que han realizado algún pedido pero no
han realizado ningún pago.
*/

SELECT
	cl.codigoCliente,
	cl.nombreCliente
FROM
	pedido as ped
INNER JOIN
	cliente as cl
ON
	cl.codigoCliente = ped.fkCodigoCliente
LEFT JOIN
	pago as p
ON
	p.fkCodigoCliente = cl.codigoCliente
WHERE
	p.idTransaccion is NULL;
	


/*
| codigoCliente | nombreCliente                  |
|:-------------:|:------------------------------:|
|             9 | JARDÍN MADRILEÑO               |
|            10 | INDUSTRIAL JARDINERA DE MADRID |
*/


/*
*12.* Devuelve un listado con los datos de los empleados que no tienen clientes
asociados y el nombre de su jefe asociado.
*/

SELECT
	e.codigoEmpleado as codEmpleado,
	e.nombre as nombreEmpleado,
	CONCAT(e.apellido1, ' ', e.apellido2) as apellidoEmpleado,
	j.codigoEmpleado as codJefe,
	j.nombre as nombreJefe,
	CONCAT(j.apellido1, ' ', j.apellido2) as apellidoJefe
FROM
	cliente as cl
RIGHT JOIN
	empleado as e
ON
	cl.fkCodigoEMpleadoRepVentas = e.codigoEmpleado
INNER JOIN
	empleado as j
ON
	e.fkCodigoJefe = j.codigoEmpleado
WHERE
	cl.codigoCliente is NULL;

/*
| codEmpleado | nombreEmpleado  | apellidoEmpleado    | codJefe | nombreJefe      | apellidoJefe       |
|:-----------:|:---------------:|:-------------------:|:-------:|:---------------:|:------------------:|
|          21 | Luis Alfonso    | Gómez Mancilla      |      10 | Carlos Jhoan    | Aguilar Galvis     |
|          32 | Javier Augusto  | Galvis Chacón       |      21 | Luis Alfonso    | Gómez Mancilla     |
|          43 | Julio César     | Galvis Chacón       |      32 | Javier Augusto  | Galvis Chacón      |
|          51 | Sandra Patricia | González Amador     |      10 | Carlos Jhoan    | Aguilar Galvis     |
|          65 | Clara Milena    | Aguilar Bella       |      51 | Sandra Patricia | González Amador    |
|          71 | Juan David      | Gómez Benavides     |      10 | Carlos Jhoan    | Aguilar Galvis     |
|         120 | José Mauricio   | Manosalva Buitrago  |      10 | Carlos Jhoan    | Aguilar Galvis     |
|         121 | Karen Julieth   | Quintero Hernández  |     120 | José Mauricio   | Manosalva Buitrago |
*/

