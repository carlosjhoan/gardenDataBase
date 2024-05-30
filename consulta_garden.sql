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


+---------------+-------------------+
| codigoOficina | nombre            |
+ :----------:  + :---------------: +
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
+---------------+-------------------+
