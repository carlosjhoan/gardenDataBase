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
	c.idCiudad = fkIdCiudad;
~~~~

### Resultado
+---------------+-------------------+  
| codigoOficina | nombre            |  
+---------------+-------------------+  
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
