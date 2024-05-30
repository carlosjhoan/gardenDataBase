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

