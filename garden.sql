-- Base de datos de la empresa Garden

create database if not exists garden;
use garden;

-- Creación de la tabla gama_producto
CREATE TABLE gama_producto(
	idGama VARCHAR(50),
	descripcionTexto TEXT,
	descripcionHTML TEXT,
	imagen VARCHAR(256),
	CONSTRAINT pk_id_gama_producto PRIMARY KEY(idGama)
);

-- Creación de la tabla País
CREATE TABLE pais(
	idPais INT AUTO_INCREMENT,
	nombre VARCHAR(100) NOT NULL,
	CONSTRAINT pk_id_pais PRIMARY KEY(idPais)
);

-- Creación de la tabla Región
CREATE TABLE region(
	idRegion INT AUTO_INCREMENT,
	nombre VARCHAR(100) NOT NULL,
	fkIdPais INT NOT NULL,
	CONSTRAINT pk_id_region PRIMARY KEY(idRegion),
	CONSTRAINT fk_id_region_pais FOREIGN KEY(fkIdPais) REFERENCES pais(idPais)
);

-- Creación de la tabla Región
CREATE TABLE ciudad(
	idCiudad INT AUTO_INCREMENT,
	nombre VARCHAR(100) NOT NULL,
	codPostal VARCHAR(11) NOT NULL,
	fkIdRegion INT NOT NULL,
	CONSTRAINT pk_id_ciudad PRIMARY KEY(idCiudad),
	CONSTRAINT fk_id_ciudad_region FOREIGN KEY(fkIdRegion) REFERENCES region(idRegion)
);

-- Creación de la tabla Proveedor
CREATE TABLE proveedor(
	idProveedor INT AUTO_INCREMENT,
	nombre varchar(50) NOT NULL,
	nit VARCHAR(13) UNIQUE,
	fkIdCiudad INT,
	email VARCHAR(50) UNIQUE,
	CONSTRAINT pk_id_proveedor PRIMARY KEY(idProveedor),
	CONSTRAINT fk_id_ciudad_ciudad FOREIGN KEY(fkIdCiudad) REFERENCES ciudad(idCiudad)
);

-- Creación Tipo_Telefono_Proveedor
CREATE TABLE tipoTelefono(
	idTipoTelefono  INT AUTO_INCREMENT,
	tipo VARCHAR(20),
	CONSTRAINT pk_id_tipo_telefono PRIMARY KEY(idTipoTelefono)
);


-- Creación Teléfonos Proveedores
CREATE TABLE telefonoProveedor(
	idTelefProveedor INT AUTO_INCREMENT,
	numero VARCHAR(20),
	fkIdTipoTelefono INT,
	fkIdProveedor INT,
	CONSTRAINT pk_id_telef_proveedor PRIMARY KEY(idTelefProveedor),
	CONSTRAINT fk_id_proveedor_telef FOREIGN KEY(fkIdProveedor) REFERENCES proveedor(idProveedor),
	CONSTRAINT fk_id_tipo_telef_proveedor FOREIGN KEY(fkIdTipoTelefono) REFERENCES tipoTelefono(idTipoTelefono)
);


-- Creación de la tabla producto
CREATE TABLE producto(
	codigoProducto VARCHAR(15),
	nombre VARCHAR(70)  NOT NULL,
	fkIdGama VARCHAR(50) NOT NULL,
	dimensiones VARCHAR(25),
	descripcion TEXT,
	CONSTRAINT pk_codigo_producto PRIMARY KEY(codigoProducto),
	CONSTRAINT fk_id_gama_producto FOREIGN KEY(fkIdGama) REFERENCES gama_producto(idGama)
);

-- Creación de la tabla productoProveedor
CREATE TABLE productoProveedor(
	fkCodigoProducto VARCHAR(15) NOT NULL,
	fkIdProveedor INT NOT NULL,
	cantidaEnStock SMALLINT(6) NOT NULL,
	precioVenta DECIMAL(15, 2) NOT NULL,
	precioProveedor DECIMAL(15,2),
	CONSTRAINT pk_producto_proveedor PRIMARY KEY(fkCodigoProducto, fkIdProveedor),
	CONSTRAINT fk_codigo_producto_proveedor FOREIGN KEY(fkCodigoProducto) REFERENCES producto(codigoProducto),
	CONSTRAINT fk_id_proveedor_producto FOREIGN KEY(fkIdProveedor) REFERENCES proveedor(idProveedor)
	
);

-- Creación de la tabla tipoDireccion
CREATE TABLE tipoDireccion(
	idTipoDireccion INT AUTO_INCREMENT,
	tipo VARCHAR(20),
	CONSTRAINT pk_id_tipo_direccion PRIMARY KEY(idTipoDireccion)
);

-- Creación de la tabla Oficina
CREATE TABLE oficina(
	codigoOficina VARCHAR(10),
	nombre VARCHAR(50),
	CONSTRAINT pk_codigo_oficina PRIMARY KEY(codigoOficina)
);


-- Creación de la tabla direccionOficina
CREATE TABLE direccionOficina(
	idDireccion INT AUTO_INCREMENT,
	direccion VARCHAR(20),
	fkIdCiudad INT,
	fkIdTipoDireccion INT,
	fkCodigoOficina VARCHAR(10),
	CONSTRAINT pk_codigo_producto PRIMARY KEY(idDireccion),
	CONSTRAINT fk_id_ciudad_direccion_oficina FOREIGN KEY(fkIdCiudad) REFERENCES ciudad(idCiudad),
	CONSTRAINT fk_id_tipo_direccion_oficina FOREIGN KEY(fkIdTipoDireccion) REFERENCES tipoDireccion(idTipoDireccion),
	CONSTRAINT fk_id_codigo_oficina_direccion FOREIGN KEY(fkCodigoOficina) REFERENCES oficina(codigoOficina)
);

-- Creación de la tabla telefonoCliente
CREATE TABLE telefonoOficina(
	idTelefOficina INT AUTO_INCREMENT,
	numero VARCHAR(20),
	fkIdTipoTelefono INT,
	fkCodigoOficina VARCHAR(10),
	CONSTRAINT pk_id_telefoficina PRIMARY KEY(idTelefOficina),
	CONSTRAINT fk_id_oficina_telef FOREIGN KEY(fkCodigoOficina) REFERENCES oficina(codigoOficina),
	CONSTRAINT fk_id_tipo_telef_oficina FOREIGN KEY(fkIdTipoTelefono) REFERENCES tipoTelefono(idTipoTelefono)
);


-- cargoEmpleado
CREATE TABLE cargoEmpleado(
	idCargoEmpleado INT,
	cargo VARCHAR(50) NOT NULL,
	CONSTRAINT pk_cargo_empleado PRIMARY KEY(idCargoEmpleado)
);

-- Creación de la tabla empleado
CREATE TABLE empleado(
	codigoEmpleado INT(11),
	nombre VARCHAR(50) NOT NULL,
	apellido1 VARCHAR(50) NOT NULL,
	apellido2 VARCHAR(50),
	extension VARCHAR(10) NOT NULL,
	email VARCHAR(100) NOT NULL UNIQUE,
	fkCodigoOficina VARCHAR(10) NOT NULL,
	fkCodigoJefe INT(11),
	fkCargoEmpleado INT,
	CONSTRAINT pk_codigo_empleado PRIMARY KEY(CodigoEmpleado),
	CONSTRAINT fk_id_codigo_jefe_empleado FOREIGN KEY(fkCodigoJefe) REFERENCES empleado(codigoEmpleado),
	CONSTRAINT fk_id_codigo_oficina_empleado FOREIGN KEY(fkCodigoOficina) REFERENCES oficina(codigoOficina),
	CONSTRAINT fk_id_cargo_empleado FOREIGN KEY(fkCargoEmpleado) REFERENCES cargoEmpleado(idCargoEmpleado)
);

-- Creación de la tabla formaPago
CREATE TABLE formaPago(
	idFormaPago INT AUTO_INCREMENT,
	formaDePago VARCHAR(25) NOT NULL,
	CONSTRAINT pk_id_forma_pago PRIMARY KEY(idFormaPago)
);

-- Creación de la tabla cliente
CREATE TABLE cliente(
	codigoCliente INT(11),
	nombreCliente VARCHAR(50),
	fkCodigoEMpleadoRepVentas INT(11),
	limiteCredito DECIMAL(15, 2),
	CONSTRAINT pk_codigo_cliente PRIMARY KEY(codigoCliente),
	CONSTRAINT fk_empleado_codigo_cliente FOREIGN KEY(fkCodigoEMpleadoRepVentas) REFERENCES empleado(codigoEmpleado)	
);

-- Creación de la tabla telefonoCliente
CREATE TABLE telefonoCliente(
	idTelefCliente INT AUTO_INCREMENT,
	numero VARCHAR(20),
	fkIdTipoTelefono INT,
	fkIdCliente INT,
	CONSTRAINT pk_id_telef_cliente PRIMARY KEY(idTelefCliente),
	CONSTRAINT fk_id_cliente_telef FOREIGN KEY(fkIdCliente) REFERENCES cliente(codigoCliente),
	CONSTRAINT fk_id_tipo_telef_cliente FOREIGN KEY(fkIdTipoTelefono) REFERENCES tipoTelefono(idTipoTelefono)
);

-- Creación de la tabla direccionCliente
CREATE TABLE direccionCliente(
	idDireccionCliente INT AUTO_INCREMENT,
	direccion VARCHAR(20),
	fkIdCiudad INT,
	fkIdTipoDireccion INT,
	fkCodigoCliente INT(11),
	CONSTRAINT pk_id_direccion_cliente PRIMARY KEY(idDireccionCliente),
	CONSTRAINT fk_id_ciudad_direccion_cliente FOREIGN KEY(fkIdCiudad) REFERENCES ciudad(idCiudad),
	CONSTRAINT fk_id_tipo_direccion_cliente FOREIGN KEY(fkIdTipoDireccion) REFERENCES tipoDireccion(idTipoDireccion),
	CONSTRAINT fk_id_codigo_cliente_direccion FOREIGN KEY(fkCodigoCliente) REFERENCES cliente(codigoCliente)
);

-- Creación de la tabla formaPago
CREATE TABLE pago(
	idTransaccion VARCHAR(40),
	fkCodigoCliente INT(11),
	fkIdFormaPago INT NOT NULL,
	fechaPago DATE NOT NULL,
	total DECIMAL(15,2) NOT NULL,
	CONSTRAINT pk_pago PRIMARY KEY(idTransaccion, fkCodigoCliente),
	CONSTRAINT fk_codigo_cliente_pago FOREIGN KEY(fkCodigoCliente) REFERENCES cliente(codigoCliente),
	CONSTRAINT fk_id_forma_pago FOREIGN KEY(fkIdFormaPago) REFERENCES formaPago(idFormaPago)
);

-- Creación de la tabla clienteContacto
CREATE TABLE clienteContacto(
	idContactoCliente INT AUTO_INCREMENT,
	nombreContacto VARCHAR(50) NOT NULL,
	apellidoContacto VARCHAR(50) NOT NULL,
	email VARCHAR(200) NOT NULL UNIQUE,
	fkCodigoCliente INT(11) NOT NULL,
	CONSTRAINT pk_ContactoCliente PRIMARY KEY(idContactoCliente),
	CONSTRAINT fk_codigo_contacto_cliente FOREIGN KEY(fkCodigoCliente) REFERENCES cliente(codigoCliente)
);

-- Creación de tabla telefonoContactoCliente
CREATE TABLE telefonoContactoCliente(
	idTelefContactoCliente INT AUTO_INCREMENT,
	numero VARCHAR(20),
	fkIdTipoTelefono INT,
	fkIdContactoCliente INT,
	CONSTRAINT pk_id_telef_contacto_cliente PRIMARY KEY(idTelefContactoCliente),
	CONSTRAINT fk_id_Contacto_Cliente_Telef FOREIGN KEY(fkIdContactoCliente) REFERENCES clienteContacto(idContactoCliente),
	CONSTRAINT fk_id_tipo_telef_contacto_cliente FOREIGN KEY(fkIdTipoTelefono) REFERENCES tipoTelefono(idTipoTelefono)
);

-- creación de la tabla estadoPedido
CREATE TABLE estadoPedido(
	idEstadoPedido INT AUTO_INCREMENT,
	estado VARCHAR(25) NOT NULL,
	CONSTRAINT pk_id_estado_pedido PRIMARY KEY(idEstadoPedido)
);


-- creación de la tabla pedido
CREATE TABLE pedido(
	codigoPedido INT(11),
	fechaPedido DATE NOT NULL,
	fechaEsperada DATE NOT NULL,
	fechaEntrega DATE,
	fkIdEstado INT NOT NULL,
	comentarios TEXT,
	fkCodigoCliente INT(11) NOT NULL,
	CONSTRAINT pk_id_codigo_pedido PRIMARY KEY(codigoPedido),
	CONSTRAINT fk_id_estado_contacto_cliente FOREIGN KEY(fkIdEstado) REFERENCES estadoPedido(idEstadoPedido),
	CONSTRAINT fk_codigo_cliente_pedido FOREIGN KEY(fkCodigoCliente) REFERENCES cliente(codigoCliente)	
);

-- Creación de la tabla detallePedido
CREATE TABLE detallePedido(
	fkCodigoPedido INT(11) NOT NULL,
	fkCodigoProducto VARCHAR(15) NOT NULL,
	cantidad INT(11) NOT NULL,
	precioUnidad DECIMAL(15,2) NOT NULL,
	numeroLinea SMALLINT(6) NOT NULL,
	CONSTRAINT pk_id_detalle_pedido PRIMARY KEY(fkCodigoPedido, fkCodigoProducto),
	CONSTRAINT fk_id_codigo_pedido_detalle FOREIGN KEY(fkCodigoPedido) REFERENCES pedido(codigoPedido),
	CONSTRAINT fk_id_codigo_producto_detalle FOREIGN KEY(fkCodigoProducto) REFERENCES producto(codigoProducto)
);

-- INSERCIONES EN LAS TABLAS
-- Inserciones en la tabla pais
insert into pais(nombre)
values ('España'), ('Colombia'), ('México');

-- inserciones en la tabla region
insert into region(nombre, fkIdPais)
values 	('Andalucía', 1),
	('Aragón', 1),
	('Cataluña', 1),
	('Comunidad de Madrid', 1),
	('Santander', 2),
	('Valle del Cauca', 2),
	('Antioquia', 2),
	('Estado de México', 3),
	('Hidalgo', 3),
	('Ciudad de México', 3);
	
-- Inserciones en la tabla ciudad
insert into ciudad(nombre, codPostal, fkIdregion)
values	('Sevilla', '41001', 1),
	('Zaragoza', '50001', 2),
	('Barcelona', '08001', 3),
	('Madrid', '28001', 4),
	('Bucaramanga', '680001', 5),
	('Cali', '760000', 6),
	('Medellín', '050001', 7),
	('Toluca de Lerdo', '50000', 8),
	('Pachuca de Soto', '42000', 9),
	('Ciudad de México', '01000', 10);


-- inserciones en la tabla oficina
insert into oficina(codigoOficina, nombre)
values 	('OFCSEVESP', 'Oficina Sevilla'),
	('OFCZARESP', 'Oficina Zaragoza'),
	('OFCBARESP', 'Oficina Barcelona'),
	('OFCMADESP','Oficina Madrid'),
	('OFCBUCCOL','Oficina Bucaramanga'),
	('OFCCALCOL','Oficina Cali'),
	('OFCMEDCOL','Oficina Medellín'),
	('OFCTOLMEX','Oficina Toluca de Lerdo'),
	('OFCPACMEX','Oficina Pachuca'),
	('OFCCDMXMEX','Oficina Ciudad de México');

-- inserciones en la tabla  tipoDireccion
insert into tipoDireccion(tipo)
values 	('Despacho'),
	('Facturación'),
	('Entrega');

-- inserciones en la tabla direccionOficina 
insert into direccionOficina(direccion, fkIdCiudad, fkIdTipoDireccion, fkCodigoOficina)
values	('Paseo Las Delicias S/N 41012', 1, 1, 'OFCSEVESP'),
	('Pl. de Ntra. Sra. del Pilar, 18, Casco Antiguo', 2, 1, 'OFCZARESP'),
	('Pl. de Sant Jaume, 1, Ciutat Vella' , 3 , 1 , 'OFCBARESP'),
	('C. de Montalbán, 1, Retiro' , 4 , 1 , 'OFCMADESP'),
	( 'Cra. 11 #34-52, García Rovira', 5, 1, 'OFCBUCCOL'),
	('Centro Administrativo Municipal, Av. 2 Nte. #10 - 70, San Pedro' , 6, 1, 'OFCCALCOL'),
	('Cl 44 #52 - 165, La Candelaria', 7, 1, 'OFCMEDCOL'),
	('Av. Independencia 207, Centro', 8, 1, 'OFCTOLMEX'),
	( 'General, Gral. Pedro Ma Anaya 1, Centro', 9, 1, 'OFCPACMEX'),
	( 'P.za de la Constitución 2, Centro Histórico', 10, 1, 'OFCCDMXMEX');








