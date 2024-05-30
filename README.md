# gardenDataBase
Este repositorio contiene el desarrollo de la creación, inserción y consultas de interès de la base de datos "garden"

# Desarrollo
*1.* Devuelve un listado con el código de oficina y la ciudad donde hay oficinas.

### Consulta
~~~~mysql
SELECT 	
	o.codigoOficina,
	c.nombre
FROM 	
	oficina as o,
	direccionOficina as do,
	ciudad as c
WHERE 	
	o.codigoOficina = do.fkCodigoOficina AND
	c.idCiudad = do.fkIdCiudad;
~~~~

### Resultado
| codigoOficina | nombre            |
| :----------:  | :---------------: |
| OFCBARESP     | Barcelona         |
| OFCBUCCOL     | Bucaramanga       |
| OFCCALCOL     | Cali              |
| OFCCDMXMEX    | Ciudad de México  |
| OFCMADESP     | Madrid            |
| OFCMEDCOL     | Medellín          |
| OFCPACMEX     | Pachuca de Soto   |
| OFCSEVESP     | Sevilla           |
| OFCTOLMEX     | Toluca de Lerdo   |
| OFCZARESP     | Zaragoza          |


*2.* Devuelve un listado con la ciudad y el teléfono de las oficinas de España.

### Consulta
~~~~mysql
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
~~~~

### Resultado

| Ciudad    | NumTelefono  |
|:---------:|:------------:|
| Sevilla   | +34955010010 |
| Zaragoza  | +34976721100 |
| Barcelona | +34934027000 |
| Madrid    | +34915298210 |


*3.* Devuelve un listado con el nombre, apellidos y email de los empleados cuyo
jefe tiene un código de jefe igual a 71.

### Consulta
~~~~mysql
SELECT 	
	nombre,
	concat(apellido1, ' ',  apellido2) as apellidos,
	email
FROM
	empleado
WHERE 
	fkCodigoJefe = 71;
~~~~

### Resultado

| nombre  | apellidos        | email                           |
|:-------:|:----------------:|:-------------------------------:|
| Ángela  | Gutierrez Arango | gutierrezarangoangela@gmail.com |
| Daniel  | Tobón Comba      | pepsimanCombaDani@gmail.com     |
| María   | Correa Martínez  | martinezjulianamaria@gmail.com  |
| Mario   | Galvis Olago     | galvismarioolago@gmail.com      |


*4.* Devuelve el nombre del puesto, nombre, apellidos y email del jefe de la
empresa.

### Consulta
~~~~mysql
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
~~~~

### Resultado

| cargo | nombre       | apellidos      | email                        |
|:-----:|:------------:|:--------------:|:----------------------------:|
| CEO   | Carlos Jhoan | Aguilar Galvis | carlosjhoanaguilar@gmail.com |


*5.* Devuelve un listado con el nombre, apellidos y puesto de aquellos
empleados que no sean representantes de ventas.
*/

### Consulta
~~~~mysql

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
~~~~

### Resultado

| nombre          | apellidos        | cargo                  |
|:---------------:|:----------------:|:----------------------:|
| Carlos Jhoan    | Aguilar Galvis   | CEO                    |
| Luis Alfonso    | Gómez Mancilla   | Gerente de Contabiliad |
| Javier Augusto  | Galvis Chacón    | Asesor Contable        |
| Julio César     | Galvis Chacón    | Auxiliar Contable      |
| Sandra Patricia | González Amador  | Gerente de Tesorería   |
| Clara Milena    | Aguilar Bella    | Tesorero               |
| Juan David      | Gómez Benavides  | Jefe de Ventas         |

*6.* Devuelve un listado con el nombre de los todos los clientes españoles.

### Consulta
~~~~mysql
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
~~~~


### Resultado

| Empresa                                |
|:----------------------------------------:|
| EXPLOTACIONES AGRICOLAS VALJIMENO S.L. |
| AGRO-Spain Ingenieros                  |
| Agropecuària de Moià                   |
| Compo Iberia SL                        |



