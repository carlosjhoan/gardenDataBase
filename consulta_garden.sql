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
