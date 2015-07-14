DELIMITER $$
--
-- Procedimientos
--
CREATE PROCEDURE `PRUEBA`()
BEGIN
	declare i INT default 1;
	SET i = 1;
	
	INSERT INTO productos
		SELECT 	a.idArticulo as id_producto, 
			CASE a.categoria
		        WHEN 'b' THEN 1
		        WHEN 'c' THEN 2
		        WHEN 'f' THEN 3
		        WHEN 'v' THEN 4
		    END as id_categoria_producto,
			a.nombre as nombre_producto, 
			a.descripcion, 
			ad.precio_compra as precio_compra,
			CASE a.categoria
		        WHEN 'f' THEN a.precio_venta1
		        ELSE a.precio_venta2
		    END as precio_cliente_frecuente,
			1 as habilitado,
			now() as created_at,
			now() as updated_at
		FROM 	fede_delvalle.articulos as a,
				fede_delvalle.articulos_detalles as ad
		WHERE 	a.idArticulo=ad.idArticulo
		GROUP BY id_producto
		ORDER BY id_producto;

	WHILE i <= 3 DO
		INSERT INTO sucursales_productos
			SELECT 	CONCAT(i, a.idArticulo) as id_sucursal_producto, 
				i as id_sucursal, 
				a.idArticulo as id_producto, 
				0 as cantidad,
				0 as stock,
				1 as habilitado,
				now() as created_at,
				now() as updated_at
			FROM 	fede_delvalle.articulos as a,
					fede_delvalle.articulos_detalles as ad
			WHERE 	a.idArticulo=ad.idArticulo
			GROUP BY id_producto
			ORDER BY id_producto;
		SET i = i + 1;
		
	END WHILE;
END$$

CREATE PROCEDURE `SPD_CONSULTAR_CLIENTES`()
BEGIN
		select c.id_cliente,
			dp.* , 
			tc.tipo_de_cliente
		from datos_personales as dp,
			clientes as c, 
			tipos_de_clientes as tc
		where c.id_cliente <> 1
			and c.id_datos_personales=dp.id_datos_personales
			and c.id_tipo_de_cliente=tc.id_tipo_de_cliente ;
	END$$

CREATE PROCEDURE `SPD_CONSULTAR_DEVOLUCIONES`()
BEGIN
		select d.*,
			dp.nombre, dp.apellido_paterno, s.nombre_sucursal
		from datos_personales as dp,
			devoluciones as d, 
			empleados as e,
			sucursales as s
		where d.id_empleado=e.id_empleado
			and e.id_sucursal=s.id_sucursal
			and e.id_datos_personales=dp.id_datos_personales
		ORDER BY d.created_at;
	END$$

CREATE PROCEDURE `SPD_CONSULTAR_DEVOLUCIONES_EMPLEADO_PARACORTE`(id int)
BEGIN
		select d.*,
			dp.nombre, dp.apellido_paterno
		from datos_personales as dp,
			devoluciones as d, 
			empleados as e
		where id=e.id_empleado
			and d.id_empleado=e.id_empleado
			and e.id_datos_personales=dp.id_datos_personales;
	END$$

CREATE PROCEDURE `SPD_CONSULTAR_DEVOLUCIONES_PARACORTE`()
BEGIN
		select d.*,
			dp.nombre, dp.apellido_paterno
		from datos_personales as dp,
			devoluciones as d, 
			empleados as e
		where d.id_empleado=e.id_empleado
			and e.id_datos_personales=dp.id_datos_personales;
	END$$

CREATE PROCEDURE `SPD_CONSULTAR_DEVOLUCIONES_SUCURSAL_PARACORTE`(id int)
BEGIN
		select d.*,
			dp.nombre, dp.apellido_paterno
		from datos_personales as dp,
			devoluciones as d, 
			empleados as e
		where d.id_sucursal=id
			and d.id_empleado=e.id_empleado
			and e.id_datos_personales=dp.id_datos_personales;
	END$$

CREATE PROCEDURE `SPD_CONSULTAR_EMPLEADOS`()
BEGIN
		select e.*,
			dp.nombre , 
			dp.apellido_paterno, 
			s.id_sucursal,
			s.nombre_sucursal, 
			u.username, 
			te.tipo_de_empleado
		from datos_personales as dp,
			empleados as e, 
			sucursales as s, 
			usuarios as u, 
			tipos_de_empleados as te
		where e.id_datos_personales=dp.id_datos_personales
			and e.id_sucursal=s.id_sucursal
			and u.id_empleado=e.id_empleado
			and e.id_tipo_de_empleado=te.id_tipo_de_empleado ;

	END$$

CREATE PROCEDURE `SPD_CONSULTAR_PRODUCTOS_SUCURSAL`( idSucursal int)
BEGIN
		select p.id_producto, p.nombre_producto, p.descripcion, p.precio_compra, 
			p.precio_cliente_frecuente, cdp.categoria,
			sp.cantidad, sp.stock, sp.created_at, sp.updated_at, sp.id_sucursal
		from productos as p,
			sucursales_productos as sp,
			sucursales as s,
			categorias_de_productos as cdp
		where sp.id_sucursal=idSucursal
			and sp.id_sucursal=s.id_sucursal
			and p.id_producto=sp.id_producto
			and p.id_categoria_de_producto=cdp.id_categoria_de_producto
		order by p.nombre_producto;
	END$$

CREATE PROCEDURE `SPD_CONSULTAR_PRODUCTOS_SUCURSALES`()
BEGIN
		select s.nombre_sucursal, s.id_sucursal,
			p.id_producto, p.nombre_producto, p.descripcion, 
			p.id_categoria_de_producto, p.precio_cliente_frecuente,
			cdp.categoria,
			sp.cantidad, sp.stock, sp.created_at, sp.updated_at
		from productos as p,
			sucursales_productos as sp,
			sucursales as s,
			categorias_de_productos as cdp
		where sp.id_sucursal=s.id_sucursal
			and p.id_producto=sp.id_producto
			and p.id_categoria_de_producto=cdp.id_categoria_de_producto ;

	END$$

CREATE PROCEDURE `SPD_CONSULTAR_VENTAS`()
BEGIN
		select v.*,
			dp.nombre, dp.apellido_paterno, s.nombre_sucursal
		from datos_personales as dp,
			ventas as v, 
			empleados as e,
			sucursales as s
		where v.id_empleado=e.id_empleado
			and e.id_sucursal=s.id_sucursal
			and e.id_datos_personales=dp.id_datos_personales;
	END$$

CREATE PROCEDURE `SPD_CONSULTAR_VENTAS_EMPLEADO_PARACORTE`(id int)
BEGIN
		select v.*,
			dp.nombre, dp.apellido_paterno
		from datos_personales as dp,
			ventas as v, 
			empleados as e
		where e.id_empleado=id
			and v.id_empleado=e.id_empleado
			and e.id_datos_personales=dp.id_datos_personales;
	END$$

CREATE PROCEDURE `SPD_CONSULTAR_VENTAS_PARACORTE`()
BEGIN
		select v.*,
			dp.nombre, dp.apellido_paterno
		from datos_personales as dp,
			ventas as v, 
			empleados as e
		where v.id_empleado=e.id_empleado
			and e.id_datos_personales=dp.id_datos_personales;
	END$$

CREATE PROCEDURE `SPD_CONSULTAR_VENTAS_SUCURSAL_PARACORTE`(id int)
BEGIN
		select v.*,
			dp.nombre, dp.apellido_paterno
		from datos_personales as dp,
			ventas as v, 
			empleados as e
		where v.id_sucursal=id
			and v.id_empleado=e.id_empleado
			and e.id_datos_personales=dp.id_datos_personales;
	END$$

CREATE PROCEDURE `SPD_CONSULTA_CLIENTE`( id int)
BEGIN
		select c.id_cliente,
			c.id_tipo_de_cliente,
			dp.*
		from datos_personales as dp,
			clientes as c
		where c.id_cliente=id
			and c.id_datos_personales=dp.id_datos_personales;
	END$$

CREATE PROCEDURE `SPD_CONSULTA_EMPLEADO`( id int)
BEGIN
		select e.*,
			dp.* , 
			s.id_sucursal,
			s.nombre_sucursal, 
			u.username, 
			u.habilitado uhabilitado, 
			te.tipo_de_empleado
		from datos_personales as dp,
			empleados as e, 
			sucursales as s, 
			usuarios as u, 
			tipos_de_empleados as te
		where e.id_empleado=id
			and e.id_datos_personales=dp.id_datos_personales
			and u.id_empleado=e.id_empleado
			and e.id_sucursal=s.id_sucursal
			and e.id_tipo_de_empleado=te.id_tipo_de_empleado ;

	END$$

CREATE PROCEDURE `SPD_CONSULTA_EMPLEADOS_SUCURSAL`( id int)
BEGIN
		select e.*,
			dp.* , 
			s.id_sucursal,
			s.nombre_sucursal, 
			u.username, 
			u.habilitado uhabilitado, 
			te.tipo_de_empleado
		from datos_personales as dp,
			empleados as e, 
			sucursales as s, 
			usuarios as u, 
			tipos_de_empleados as te
		where s.id_sucursal=id
			and e.id_datos_personales=dp.id_datos_personales
			and u.id_empleado=e.id_empleado
			and e.id_sucursal=s.id_sucursal
			and e.id_tipo_de_empleado=te.id_tipo_de_empleado ;

	END$$

CREATE PROCEDURE `SPD_CONSULTA_PRODUCTO_SUCURSAL`( idSucursal int, idProducto bigint)
BEGIN
		select p.id_producto, p.nombre_producto, p.descripcion, cdp.categoria,
			p.precio_compra, p.precio_cliente_frecuente,
			sp.cantidad, sp.stock, sp.created_at, sp.updated_at
		from productos as p,
			sucursales_productos as sp,
			sucursales as s,
			categorias_de_productos as cdp
		where sp.id_sucursal=idSucursal
			and p.id_producto=idProducto
			and sp.id_sucursal=s.id_sucursal
			and p.id_producto=sp.id_producto
			and p.id_categoria_de_producto=cdp.id_categoria_de_producto;

	END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `bitacora`
--

CREATE TABLE IF NOT EXISTS `bitacora` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `created_at` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00',
  `updated_at` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish2_ci AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `categorias_de_productos`
--

CREATE TABLE IF NOT EXISTS `categorias_de_productos` (
  `id_categoria_de_producto` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `categoria` varchar(100) COLLATE utf8_spanish2_ci NOT NULL,
  `habilitado` tinyint(1) NOT NULL DEFAULT '1',
  `created_at` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00',
  `updated_at` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00',
  PRIMARY KEY (`id_categoria_de_producto`),
  UNIQUE KEY `categorias_de_productos_categoria_unique` (`categoria`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COLLATE=utf8_spanish2_ci AUTO_INCREMENT=5 ;

--
-- Volcado de datos para la tabla `categorias_de_productos`
--

INSERT INTO `categorias_de_productos` (`id_categoria_de_producto`, `categoria`, `habilitado`, `created_at`, `updated_at`) VALUES
(1, 'Beauty', 1, '2015-05-09 21:22:30', '2015-05-09 21:22:30'),
(2, 'Complemento', 1, '2015-05-09 21:22:30', '2015-05-09 21:22:30'),
(3, 'Fitness', 1, '2015-05-09 21:22:30', '2015-05-09 21:22:30'),
(4, 'Varios', 1, '2015-05-09 21:22:30', '2015-05-09 21:22:30');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `clientes`
--

CREATE TABLE IF NOT EXISTS `clientes` (
  `id_cliente` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `id_datos_personales` int(10) unsigned NOT NULL,
  `id_tipo_de_cliente` int(10) unsigned NOT NULL,
  `habilitado` tinyint(1) NOT NULL DEFAULT '1',
  `created_at` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00',
  `updated_at` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00',
  PRIMARY KEY (`id_cliente`),
  KEY `clientes_id_datos_personales_foreign` (`id_datos_personales`),
  KEY `clientes_id_tipo_de_cliente_foreign` (`id_tipo_de_cliente`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COLLATE=utf8_spanish2_ci AUTO_INCREMENT=3 ;

--
-- Volcado de datos para la tabla `clientes`
--

INSERT INTO `clientes` (`id_cliente`, `id_datos_personales`, `id_tipo_de_cliente`, `habilitado`, `created_at`, `updated_at`) VALUES
(1, 5, 1, 1, '2015-05-09 21:22:30', '2015-05-09 21:22:30'),
(2, 6, 2, 1, '2015-05-09 21:22:30', '2015-05-09 21:22:30');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `compras`
--

CREATE TABLE IF NOT EXISTS `compras` (
  `id_compra` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `id_sucursal` int(10) unsigned NOT NULL,
  `id_proveedor` int(10) unsigned NOT NULL,
  `id_empleado` int(10) unsigned NOT NULL,
  `numero_de_nota` varchar(20) COLLATE utf8_spanish2_ci DEFAULT NULL,
  `total` decimal(12,2) NOT NULL,
  `fecha` date NOT NULL,
  `detalles` varchar(150) COLLATE utf8_spanish2_ci DEFAULT NULL,
  `habilitado` tinyint(1) NOT NULL DEFAULT '1',
  `created_at` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00',
  `updated_at` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00',
  PRIMARY KEY (`id_compra`),
  KEY `compras_id_sucursal_foreign` (`id_sucursal`),
  KEY `compras_id_proveedor_foreign` (`id_proveedor`),
  KEY `compras_id_empleado_foreign` (`id_empleado`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish2_ci AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `compras_productos`
--

CREATE TABLE IF NOT EXISTS `compras_productos` (
  `id_compras_productos` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `id_compra` int(10) unsigned NOT NULL,
  `id_producto` bigint(20) unsigned NOT NULL,
  `cantidad` smallint(6) NOT NULL,
  `fecha_caducidad` date NOT NULL,
  `precio_unitario` decimal(12,2) NOT NULL,
  `habilitado` tinyint(1) NOT NULL DEFAULT '1',
  `created_at` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00',
  `updated_at` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00',
  PRIMARY KEY (`id_compras_productos`),
  KEY `compras_productos_id_compra_foreign` (`id_compra`),
  KEY `compras_productos_id_producto_foreign` (`id_producto`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish2_ci AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `compras_tipo_de_pago`
--

CREATE TABLE IF NOT EXISTS `compras_tipo_de_pago` (
  `id_compras_tipo_de_pago` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `id_compra` int(10) unsigned NOT NULL,
  `id_tipo_de_pago` int(10) unsigned NOT NULL,
  `importe_pagado` decimal(12,2) NOT NULL,
  `habilitado` tinyint(1) NOT NULL DEFAULT '1',
  `created_at` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00',
  `updated_at` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00',
  PRIMARY KEY (`id_compras_tipo_de_pago`),
  KEY `compras_tipo_de_pago_id_compra_foreign` (`id_compra`),
  KEY `compras_tipo_de_pago_id_tipo_de_pago_foreign` (`id_tipo_de_pago`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish2_ci AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `datos_personales`
--

CREATE TABLE IF NOT EXISTS `datos_personales` (
  `id_datos_personales` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `nombre` varchar(50) COLLATE utf8_spanish2_ci NOT NULL,
  `apellido_paterno` varchar(30) COLLATE utf8_spanish2_ci NOT NULL,
  `apellido_materno` varchar(30) COLLATE utf8_spanish2_ci DEFAULT NULL,
  `fecha_nacimiento` date NOT NULL,
  `genero` tinyint(1) NOT NULL,
  `calle` varchar(50) COLLATE utf8_spanish2_ci DEFAULT NULL,
  `colonia` varchar(50) COLLATE utf8_spanish2_ci DEFAULT NULL,
  `delegacion` varchar(50) COLLATE utf8_spanish2_ci DEFAULT NULL,
  `estado` varchar(50) COLLATE utf8_spanish2_ci DEFAULT NULL,
  `cp` varchar(5) COLLATE utf8_spanish2_ci DEFAULT NULL,
  `telefono` varchar(10) COLLATE utf8_spanish2_ci DEFAULT NULL,
  `email` varchar(45) COLLATE utf8_spanish2_ci DEFAULT NULL,
  `rfc` varchar(13) COLLATE utf8_spanish2_ci DEFAULT NULL,
  `habilitado` tinyint(1) NOT NULL DEFAULT '1',
  `created_at` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00',
  `updated_at` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00',
  PRIMARY KEY (`id_datos_personales`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COLLATE=utf8_spanish2_ci AUTO_INCREMENT=10 ;

--
-- Volcado de datos para la tabla `datos_personales`
--

INSERT INTO `datos_personales` (`id_datos_personales`, `nombre`, `apellido_paterno`, `apellido_materno`, `fecha_nacimiento`, `genero`, `calle`, `colonia`, `delegacion`, `estado`, `cp`, `telefono`, `email`, `rfc`, `habilitado`, `created_at`, `updated_at`) VALUES
(1, 'Federico', 'Boysselle', NULL, '2030-12-13', 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, '2015-05-09 21:22:30', '2015-05-09 21:22:30'),
(2, 'copilco', 'c', NULL, '1978-03-27', 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, '2015-05-09 21:22:30', '2015-05-09 21:22:30'),
(3, 'ajusco', 'a', NULL, '2024-05-01', 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, '2015-05-09 21:22:30', '2015-05-09 21:22:30'),
(4, 'valle', 'v', NULL, '1989-12-05', 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, '2015-05-09 21:22:30', '2015-05-09 21:22:30'),
(5, 'cliente de mostrador', 'c', NULL, '1978-06-08', 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, '2015-05-09 21:22:30', '2015-05-09 21:22:30'),
(6, 'Primer', 'cliente', 'normal', '2043-04-20', 1, 'calle13', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, '2015-05-09 21:22:30', '2015-05-09 21:22:30'),
(7, 'empleado', 'ajusco', 'primero', '1999-10-16', 1, 'calle1', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, '2015-05-09 21:22:30', '2015-05-09 21:22:30'),
(8, 'empleado', 'copilco', 'primero', '1977-07-07', 1, 'calle1', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, '2015-05-09 21:22:30', '2015-05-09 21:22:30'),
(9, 'empleado', 'valle', 'primero', '2011-02-22', 1, 'calle1', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, '2015-05-09 21:22:30', '2015-05-09 21:22:30');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `devoluciones`
--

CREATE TABLE IF NOT EXISTS `devoluciones` (
  `id_devolucion` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `id_empleado` int(10) unsigned NOT NULL,
  `id_sucursal` int(10) unsigned NOT NULL,
  `id_producto_devuelto` bigint(20) unsigned NOT NULL,
  `id_producto_cambio` bigint(20) unsigned NOT NULL,
  `diferencia` decimal(12,2) NOT NULL,
  `concepto` varchar(150) COLLATE utf8_spanish2_ci NOT NULL,
  `habilitado` tinyint(1) NOT NULL DEFAULT '1',
  `created_at` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00',
  `updated_at` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00',
  PRIMARY KEY (`id_devolucion`),
  KEY `devoluciones_id_empleado_foreign` (`id_empleado`),
  KEY `devoluciones_id_sucursal_foreign` (`id_sucursal`),
  KEY `devoluciones_id_producto_devuelto_foreign` (`id_producto_devuelto`),
  KEY `devoluciones_id_producto_cambio_foreign` (`id_producto_cambio`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish2_ci AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `egresos`
--

CREATE TABLE IF NOT EXISTS `egresos` (
  `id_egreso` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `id_empleado` int(10) unsigned NOT NULL,
  `id_sucursal` int(10) unsigned NOT NULL,
  `importe` decimal(12,2) NOT NULL,
  `concepto` varchar(150) COLLATE utf8_spanish2_ci NOT NULL,
  `habilitado` tinyint(1) NOT NULL DEFAULT '1',
  `created_at` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00',
  `updated_at` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00',
  PRIMARY KEY (`id_egreso`),
  KEY `egresos_id_empleado_foreign` (`id_empleado`),
  KEY `egresos_id_sucursal_foreign` (`id_sucursal`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish2_ci AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `empleados`
--

CREATE TABLE IF NOT EXISTS `empleados` (
  `id_empleado` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `id_datos_personales` int(10) unsigned NOT NULL,
  `id_tipo_de_empleado` int(10) unsigned NOT NULL,
  `id_sucursal` int(10) unsigned NOT NULL,
  `habilitado` tinyint(1) NOT NULL DEFAULT '1',
  `created_at` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00',
  `updated_at` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00',
  PRIMARY KEY (`id_empleado`),
  KEY `empleados_id_datos_personales_foreign` (`id_datos_personales`),
  KEY `empleados_id_tipo_de_empleado_foreign` (`id_tipo_de_empleado`),
  KEY `empleados_id_sucursal_foreign` (`id_sucursal`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COLLATE=utf8_spanish2_ci AUTO_INCREMENT=8 ;

--
-- Volcado de datos para la tabla `empleados`
--

INSERT INTO `empleados` (`id_empleado`, `id_datos_personales`, `id_tipo_de_empleado`, `id_sucursal`, `habilitado`, `created_at`, `updated_at`) VALUES
(1, 1, 1, 1, 1, '2015-05-09 21:22:30', '2015-05-09 21:22:30'),
(2, 2, 3, 1, 1, '2015-05-09 21:22:30', '2015-05-09 21:22:30'),
(3, 3, 3, 2, 1, '2015-05-09 21:22:30', '2015-05-09 21:22:30'),
(4, 4, 3, 3, 1, '2015-05-09 21:22:30', '2015-05-09 21:22:30'),
(5, 7, 4, 1, 1, '2015-05-09 21:22:30', '2015-05-09 21:22:30'),
(6, 8, 4, 2, 1, '2015-05-09 21:22:30', '2015-05-09 21:22:30'),
(7, 9, 4, 3, 1, '2015-05-09 21:22:30', '2015-05-09 21:22:30');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `migrations`
--

CREATE TABLE IF NOT EXISTS `migrations` (
  `migration` varchar(255) COLLATE utf8_spanish2_ci NOT NULL,
  `batch` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish2_ci;

--
-- Volcado de datos para la tabla `migrations`
--

INSERT INTO `migrations` (`migration`, `batch`) VALUES
('2015_02_04_034550_Create_Tipos_De_Clientes', 1),
('2015_02_04_034731_Create_Tipos_De_Empleados', 1),
('2015_02_04_035827_Create_Datos_Personales', 1),
('2015_02_04_041822_Create_Tipos_De_Pagos', 1),
('2015_02_04_045236_Create_Proveedores', 1),
('2015_02_04_045741_Create_Sucursales', 1),
('2015_02_04_050020_Create_Empleados', 1),
('2015_02_04_050030_Create_Usuarios', 1),
('2015_02_04_062437_Create_Clientes', 1),
('2015_02_04_062609_Create_Categorias_De_Productos', 1),
('2015_02_04_062754_Create_Productos', 1),
('2015_02_04_063105_Create_Ventas', 1),
('2015_02_04_064656_Create_Compras', 1),
('2015_02_04_065613_Create_Compras_Productos', 1),
('2015_02_04_065956_Create_Ventas_Productos', 1),
('2015_02_04_070445_Create_Compras_Tipo_De_Pago', 1),
('2015_02_04_070724_Create_Ventas_Tipo_De_Pago', 1),
('2015_02_04_072048_Create_Sucursales_Productos', 1),
('2015_02_14_192730_Create_Transferencias', 1),
('2015_02_14_210021_Create_Devoluciones', 1),
('2015_02_17_213919_Create_Egresos', 1),
('2015_02_17_220539_Create_Permisos', 1),
('2015_02_17_220617_Create_Reglas_Del_Negocio', 1),
('2015_02_17_220648_Create_Bitacora', 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `permisos`
--

CREATE TABLE IF NOT EXISTS `permisos` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `created_at` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00',
  `updated_at` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish2_ci AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `productos`
--

CREATE TABLE IF NOT EXISTS `productos` (
  `id_producto` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `id_categoria_de_producto` int(10) unsigned NOT NULL,
  `nombre_producto` varchar(100) COLLATE utf8_spanish2_ci NOT NULL,
  `descripcion` varchar(150) COLLATE utf8_spanish2_ci DEFAULT NULL,
  `precio_compra` decimal(12,2) NOT NULL,
  `precio_cliente_frecuente` decimal(12,2) NOT NULL,
  `habilitado` tinyint(1) NOT NULL DEFAULT '1',
  `created_at` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00',
  `updated_at` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00',
  PRIMARY KEY (`id_producto`),
  KEY `productos_id_categoria_de_producto_foreign` (`id_categoria_de_producto`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COLLATE=utf8_spanish2_ci AUTO_INCREMENT=9133756416280 ;

--
-- Volcado de datos para la tabla `productos`
--

INSERT INTO `productos` (`id_producto`, `id_categoria_de_producto`, `nombre_producto`, `descripcion`, `precio_compra`, `precio_cliente_frecuente`, `habilitado`, `created_at`, `updated_at`) VALUES
(1, 3, 'DIET FREE TABLETAS', 'TABLETAS', 0.00, 300.00, 1, '2015-05-09 21:22:54', '2015-05-09 21:22:54'),
(2, 3, 'LIPO ACTIVE CAPS ', 'CAPSULAS', 0.00, 285.00, 1, '2015-05-09 21:22:54', '2015-05-09 21:22:54'),
(3, 3, 'LIPO ACTIVE ROLL ON ', 'ROLLON', 0.00, 140.00, 1, '2015-05-09 21:22:54', '2015-05-09 21:22:54'),
(5, 3, 'DIET FREE GEL', 'GEL', 0.00, 300.00, 1, '2015-05-09 21:22:54', '2015-05-09 21:22:54'),
(7, 3, 'THERMOACTIVE', 'CAPSULAS', 0.00, 290.00, 1, '2015-05-09 21:22:54', '2015-05-09 21:22:54'),
(8, 3, 'NATURAVIT C 500', 'CAPSULAS', 0.00, 110.00, 1, '2015-05-09 21:22:54', '2015-05-09 21:22:54'),
(9, 3, 'MULTIVITAMINICO', 'CAPSULAS', 0.00, 120.00, 1, '2015-05-09 21:22:54', '2015-05-09 21:22:54'),
(10, 3, 'FREE MOTION', 'CAPSULAS', 0.00, 180.00, 1, '2015-05-09 21:22:54', '2015-05-09 21:22:54'),
(11, 3, 'VITAMIN WOMAN', 'CAPSULAS', 0.00, 199.00, 1, '2015-05-09 21:22:54', '2015-05-09 21:22:54'),
(12, 3, 'HEPATIK GUARD', 'CAPSULAS', 0.00, 190.00, 1, '2015-05-09 21:22:54', '2015-05-09 21:22:54'),
(13, 3, 'VITAMIN BOOSTER', 'CAPSULAS', 0.00, 190.00, 1, '2015-05-09 21:22:54', '2015-05-09 21:22:54'),
(16, 4, 'MUÃ‘EQUERAS', 'MUÃ±EQUERA', 130.00, 169.00, 1, '2015-05-09 21:22:54', '2015-05-09 21:22:54'),
(22, 2, 'SOBRES ASIA BLACK (TERMOGÃ‰NICO)', 'CAPSULAS', 0.00, 20.00, 1, '2015-05-09 21:22:54', '2015-05-09 21:22:54'),
(30, 2, 'LONCHERA TÃ‰RMICA CENDECAR PARA 3', 'NEGRA', 0.00, 799.00, 1, '2015-05-09 21:22:54', '2015-05-09 21:22:54'),
(31, 2, 'LONCHERA TÃ‰RMICA CENDECAR PARA 3', 'VERDE MILITAR', 0.00, 799.00, 1, '2015-05-09 21:22:54', '2015-05-09 21:22:54'),
(32, 2, 'LONCHERA TÃ‰RMICA CENDECAR PARA 3', 'AZUL', 0.00, 799.00, 1, '2015-05-09 21:22:54', '2015-05-09 21:22:54'),
(33, 2, 'LONCHERA  CON LOGO PARA 3', 'NEGRA', 0.00, 799.00, 1, '2015-05-09 21:22:54', '2015-05-09 21:22:54'),
(34, 2, 'LONCHERA  CON LOGO PARA 3', 'ROSA', 0.00, 799.00, 1, '2015-05-09 21:22:54', '2015-05-09 21:22:54'),
(35, 2, 'LONCHERA  CON LOGO PARA 3', 'AZUL', 0.00, 799.00, 1, '2015-05-09 21:22:54', '2015-05-09 21:22:54'),
(36, 2, 'LONCHERA  CON LOGO PARA 3', 'VERDE', 0.00, 799.00, 1, '2015-05-09 21:22:54', '2015-05-09 21:22:54'),
(50, 2, 'ANDRO NOVA', 'NOVA VET', 0.00, 1125.00, 1, '2015-05-09 21:22:54', '2015-05-09 21:22:54'),
(51, 2, 'NANDRO NOVA', '10 ML, 300 MG/ML', 0.00, 750.00, 1, '2015-05-09 21:22:54', '2015-05-09 21:22:54'),
(52, 2, 'STANONOVA 10 ML, 50 MG/ML', 'NOVA VET', 0.00, 562.50, 1, '2015-05-09 21:22:54', '2015-05-09 21:22:54'),
(53, 2, 'TESTO NOVA 250', 'NOVA VET', 0.00, 650.00, 1, '2015-05-09 21:22:54', '2015-05-09 21:22:54'),
(54, 2, 'TREMBO NOVA', 'NOVA VET', 0.00, 1000.00, 1, '2015-05-09 21:22:54', '2015-05-09 21:22:54'),
(55, 2, 'BOLDE NOVA', 'NOVA VET', 0.00, 687.50, 1, '2015-05-09 21:22:54', '2015-05-09 21:22:54'),
(56, 2, 'MASTODEX SCIROXX', '100 ML', 0.00, 929.00, 1, '2015-05-09 21:22:54', '2015-05-09 21:22:54'),
(57, 2, 'OXI', 'ORAL SKRAPPY LABS', 0.00, 1150.00, 1, '2015-05-09 21:22:54', '2015-05-09 21:22:54'),
(58, 2, 'METENO', 'ORAL SKRAPPY LABS', 0.00, 1150.00, 1, '2015-05-09 21:22:54', '2015-05-09 21:22:54'),
(59, 2, 'STANO  ORAL', 'ORAL SKRAPPY LABS', 0.00, 1150.00, 1, '2015-05-09 21:22:54', '2015-05-09 21:22:54'),
(100, 3, 'PROBIOTIC GUARD', 'CAPS', 0.00, 180.00, 1, '2015-05-09 21:22:54', '2015-05-09 21:22:54'),
(101, 2, 'LIPO ACTIVE-L CARNITINA', 'LIQUIDA', 0.00, 225.00, 1, '2015-05-09 21:22:54', '2015-05-09 21:22:54'),
(102, 3, 'HEART GUARD', 'CAPS', 0.00, 190.00, 1, '2015-05-09 21:22:54', '2015-05-09 21:22:54'),
(104, 2, 'LONCHERA TÃ‰RMICA CENDECAR PARA 5', 'MOCHILA', 0.00, 1700.00, 1, '2015-05-09 21:22:54', '2015-05-09 21:22:54'),
(105, 2, 'GENOTROPIN 30 U.I. X 7 AMPOLLETAS', 'CAJA', 0.00, 4299.00, 1, '2015-05-09 21:22:54', '2015-05-09 21:22:54'),
(106, 2, 'GENOTROPIN 30 U.I. 1 AMPOLLETA', 'AMPOLLETA', 0.00, 749.00, 1, '2015-05-09 21:22:54', '2015-05-09 21:22:54'),
(107, 2, 'KIGTROPIN 20 U.I. X 10 AMPOLLETAS', 'CAJA CON 10 AMPOLLETAS ', 0.00, 4299.00, 1, '2015-05-09 21:22:54', '2015-05-09 21:22:54'),
(108, 2, 'GEL  PARA CONGELAR ', 'GEL', 0.00, 49.90, 1, '2015-05-09 21:22:54', '2015-05-09 21:22:54'),
(114, 2, 'LONCHERA TÃ‰RMICA CENDECAR PARA 3', 'ROSA', 0.00, 799.00, 1, '2015-05-09 21:22:54', '2015-05-09 21:22:54'),
(123, 2, 'POWER PLUS', 'JAMAICA', 0.00, 30.00, 1, '2015-05-09 21:22:54', '2015-05-09 21:22:54'),
(145, 2, 'XS 250 ML BEBIDA ENERGETICA', 'UVA', 0.00, 40.00, 1, '2015-05-09 21:22:54', '2015-05-09 21:22:54'),
(150, 2, 'TESTOGAN', 'PROPIONATO 100 ML', 0.00, 702.00, 1, '2015-05-09 21:22:54', '2015-05-09 21:22:54'),
(151, 2, 'ANDROGEN', 'ACETATO,DECANATO,PROPIONATO,CIPIO', 0.00, 897.00, 1, '2015-05-09 21:22:54', '2015-05-09 21:22:54'),
(152, 2, 'STANOBOL ', 'STANO 50 MG', 0.00, 897.00, 1, '2015-05-09 21:22:54', '2015-05-09 21:22:54'),
(153, 2, 'MASTADREN', 'PROPIONATE 100MG', 0.00, 1157.00, 1, '2015-05-09 21:22:54', '2015-05-09 21:22:54'),
(154, 2, 'OXIMETALONA KARACHI', '50 MG', 0.00, 962.00, 1, '2015-05-09 21:22:54', '2015-05-09 21:22:54'),
(155, 2, 'STANOBOL ', '60 TABS', 0.00, 832.00, 1, '2015-05-09 21:22:54', '2015-05-09 21:22:54'),
(200, 2, 'SHAKER SPIDER BOTLE 500ML', 'VASOS', 0.00, 210.00, 1, '2015-05-09 21:22:54', '2015-05-09 21:22:54'),
(516, 2, 'GYMAHOLIC SALDO', 'ASUL', 0.00, 70.00, 1, '2015-05-09 21:22:54', '2015-05-09 21:22:54'),
(741, 2, 'DIANABOL', '25MG', 0.00, 15.00, 1, '2015-05-09 21:22:54', '2015-05-09 21:22:54'),
(852, 2, 'CAFE', 'CHICO', 0.00, 15.00, 1, '2015-05-09 21:22:54', '2015-05-09 21:22:54'),
(963, 2, 'CAFE', 'GRANDE', 0.00, 20.00, 1, '2015-05-09 21:22:54', '2015-05-09 21:22:54'),
(1000, 2, 'PLAYERAS CENDECAR', 'GRANDE ', 0.00, 149.00, 1, '2015-05-09 21:22:54', '2015-05-09 21:22:54'),
(1001, 2, 'PLAYERAS CENDECAR', 'CHICA', 0.00, 149.00, 1, '2015-05-09 21:22:54', '2015-05-09 21:22:54'),
(1002, 2, 'PLAYERA CENDECAR ', 'EXTRAGRANDE', 0.00, 149.00, 1, '2015-05-09 21:22:54', '2015-05-09 21:22:54'),
(1003, 2, 'PLAYERA CENDECAR ', 'MEDIANA', 0.00, 149.00, 1, '2015-05-09 21:22:54', '2015-05-09 21:22:54'),
(1004, 2, 'PLAYERA CENDECAR  PARA MUJER', 'GRANDE', 0.00, 149.00, 1, '2015-05-09 21:22:54', '2015-05-09 21:22:54'),
(1005, 2, 'PLAYERA CENDECAR  PARA MUJER', 'MEDIANA', 0.00, 149.00, 1, '2015-05-09 21:22:54', '2015-05-09 21:22:54'),
(1006, 2, 'PLAYERA CENDECAR  PARA MUJER', 'CHICA', 0.00, 149.00, 1, '2015-05-09 21:22:54', '2015-05-09 21:22:54'),
(1010, 2, 'CONSULTA  NUTRICIONAL', 'CONSULTA', 0.00, 50.00, 1, '2015-05-09 21:22:54', '2015-05-09 21:22:54'),
(1020, 2, 'KIGTROPIN 20 U.I. X 1 AMPOLLETA', 'SUELTA DE 20 UN', 0.00, 449.00, 1, '2015-05-09 21:22:54', '2015-05-09 21:22:54'),
(2000, 2, 'VASOS DYMATIZE', 'VASOS', 0.00, 75.00, 1, '2015-05-09 21:22:54', '2015-05-09 21:22:54'),
(4127, 2, 'ANABOLIC ST', 'STANO ', 0.00, 744.00, 1, '2015-05-09 21:22:54', '2015-05-09 21:22:54'),
(5058, 2, 'LONCHERA  3 TOPERS', 'CAMUFLAGE', 0.00, 799.00, 1, '2015-05-09 21:22:54', '2015-05-09 21:22:54'),
(9654, 3, 'CHIKAHUAK', 'ALEGRIA', 6.50, 10.00, 1, '2015-05-09 21:22:54', '2015-05-09 21:22:54'),
(10001, 2, 'AGUA DESTILADA', 'DESTILADA  5LT', 0.00, 70.00, 1, '2015-05-09 21:22:54', '2015-05-09 21:22:54'),
(10002, 2, 'GYMAHOLIC', 'PLAYERAS   SIN MANGAS', 0.00, 209.00, 1, '2015-05-09 21:22:54', '2015-05-09 21:22:54'),
(10004, 2, 'CHALECO  GYMA HOLIC', 'CHALECO', 0.00, 424.00, 1, '2015-05-09 21:22:54', '2015-05-09 21:22:54'),
(10005, 2, 'TOALLA  GYMAHOLIC', 'TOALLA', 0.00, 119.00, 1, '2015-05-09 21:22:54', '2015-05-09 21:22:54'),
(10006, 2, 'SUDADERA GYMAHOLIK', 'SUDADERA', 0.00, 476.00, 1, '2015-05-09 21:22:54', '2015-05-09 21:22:54'),
(10007, 2, 'VASO ON', 'ON', 0.00, 59.00, 1, '2015-05-09 21:22:54', '2015-05-09 21:22:54'),
(18208, 2, 'BOLDREN BLEN', 'KARACHI', 0.00, 897.00, 1, '2015-05-09 21:22:54', '2015-05-09 21:22:54'),
(22010, 2, 'PARADREN', 'TREMBO KARACHI', 0.00, 1428.70, 1, '2015-05-09 21:22:54', '2015-05-09 21:22:54'),
(25922, 2, 'PRIMOSTON KARACHI', 'PRIMOSTON', 0.00, 1558.80, 1, '2015-05-09 21:22:54', '2015-05-09 21:22:54'),
(74123, 4, 'CONSULTA FEDERICO', 'PRECIO 1', 0.00, 550.00, 1, '2015-05-09 21:22:54', '2015-05-09 21:22:54'),
(96321, 4, 'CONSULTA FEDERICO', 'PRECIO 2', 0.00, 450.00, 1, '2015-05-09 21:22:54', '2015-05-09 21:22:54'),
(852369, 4, 'PAGO RENTA MIGUEL', 'RENTA', 0.00, 1000.00, 1, '2015-05-09 21:22:54', '2015-05-09 21:22:54'),
(1523564, 2, 'PLAYERA AZUL CENDECAR', 'AZUL', 0.00, 150.00, 1, '2015-05-09 21:22:54', '2015-05-09 21:22:54'),
(2154879, 2, 'CLARAS DE HUEVO', 'CLARAS DE HUEVO', 0.00, 199.00, 1, '2015-05-09 21:22:54', '2015-05-09 21:22:54'),
(7456321, 3, 'PAGO RENTA ERICK', 'RENTA', 0.00, 400.00, 1, '2015-05-09 21:22:54', '2015-05-09 21:22:54'),
(8794563, 3, 'PAGO LALO', 'LALO', 0.00, 1100.00, 1, '2015-05-09 21:22:54', '2015-05-09 21:22:54'),
(11102389, 2, 'OXANDROLONA', 'OXA 50TB', 0.00, 644.00, 1, '2015-05-09 21:22:54', '2015-05-09 21:22:54'),
(11102594, 2, 'BRONCOTEROL 50 C. (CELMBUTEROL).', '0.010 MG', 0.00, 629.00, 1, '2015-05-09 21:22:54', '2015-05-09 21:22:54'),
(21547896, 2, 'SOBRES DE NECTAR  PROMO', '12 GR DE PROTEINA', 0.00, 20.00, 1, '2015-05-09 21:22:54', '2015-05-09 21:22:54'),
(89537458, 1, 'PAGO PAQUITO', 'RENTA', 0.00, 4000.00, 1, '2015-05-09 21:22:54', '2015-05-09 21:22:54'),
(751140109, 2, 'GUANTES MUÃ‘EQUERA HARBINGER', 'CHICO', 0.00, 299.00, 1, '2015-05-09 21:22:54', '2015-05-09 21:22:54'),
(751140208, 2, 'GUANTES MUÃ‘EQUERA HARBINGER', 'MEDIANO', 0.00, 459.00, 1, '2015-05-09 21:22:54', '2015-05-09 21:22:54'),
(751140307, 2, 'GUANTES MUÃ‘EQUERA HARBINGER', 'GRANDE', 0.00, 459.00, 1, '2015-05-09 21:22:54', '2015-05-09 21:22:54'),
(1077912001, 2, 'LEAN BODY 80 PACK. SOBRES', 'SOBRES POR CAJA ', 0.00, 2459.00, 1, '2015-05-09 21:22:54', '2015-05-09 21:22:54'),
(1245879358, 2, 'PUSH 10 1.1 LBS MUSCLETECH OXIDO', 'OXIDO SIN CAFEINA', 0.00, 589.00, 1, '2015-05-09 21:22:54', '2015-05-09 21:22:54'),
(2793306532, 2, 'MUTANT WHEY 5 LIBRAS', 'FRESA', 0.00, 799.00, 1, '2015-05-09 21:22:54', '2015-05-09 21:22:54'),
(5487987956, 2, 'OHYEA', 'CHOCOPLATE CARAMELO', 0.00, 40.00, 1, '2015-05-09 21:22:54', '2015-05-09 21:22:54'),
(13602004390, 3, 'MIEL MAPLE 0 CALORIAS PROMESA', 'MIEL', 26.00, 46.20, 1, '2015-05-09 21:22:54', '2015-05-09 21:22:54'),
(23991184719, 2, 'SOMATROPE 50 UNIDADES', 'HC 50 UN', 0.00, 1499.00, 1, '2015-05-09 21:22:54', '2015-05-09 21:22:54'),
(39442030115, 2, 'ANIMAL PAK', '44 PAK', 0.00, 639.00, 1, '2015-05-09 21:22:54', '2015-05-09 21:22:54'),
(39442030283, 2, 'ANIMAL METHOXY STACK 21 PACK.', 'STAK M', 0.00, 764.00, 1, '2015-05-09 21:22:54', '2015-05-09 21:22:54'),
(39442030320, 2, 'ANIMAL TEST 21 PACK', 'PASTILLAS', 0.00, 1289.00, 1, '2015-05-09 21:22:54', '2015-05-09 21:22:54'),
(39442030542, 2, 'ANIMAL PUM', '30 PAK', 0.00, 719.00, 1, '2015-05-09 21:22:54', '2015-05-09 21:22:54'),
(68733994101, 2, 'GOFIT GUANTES  VERDE PARA MUJER', 'MEDIANO', 0.00, 329.00, 1, '2015-05-09 21:22:54', '2015-05-09 21:22:54'),
(85351004228, 2, 'MUTANT MAYAHEM 720 GRAMOS', 'PONCHE DE FRUTAS', 0.00, 499.00, 1, '2015-05-09 21:22:54', '2015-05-09 21:22:54'),
(85351004303, 2, 'STIM-U-TANT', '90 CAPS', 0.00, 469.00, 1, '2015-05-09 21:22:54', '2015-05-09 21:22:54'),
(89094021153, 2, 'ISOPURE ZERO CARB 3 LIBRAS', 'VAINILLA', 0.00, 969.00, 1, '2015-05-09 21:22:54', '2015-05-09 21:22:54'),
(89094021177, 2, 'ISOPURE ZERO CARB 3 LIBRAS', 'CHOCOLATE', 0.00, 969.00, 1, '2015-05-09 21:22:54', '2015-05-09 21:22:54'),
(89094021191, 2, 'ISOPURE ZERO CARB 3 LIBRAS', 'FRESAS CON CREMA ', 0.00, 969.00, 1, '2015-05-09 21:22:54', '2015-05-09 21:22:54'),
(89094021511, 2, 'ISOPURE ZERO CARB 7.5 LIBRAS ', 'VAINILLA', 0.00, 1999.00, 1, '2015-05-09 21:22:54', '2015-05-09 21:22:54'),
(89094021559, 2, 'ISOPURE ZERO CARB 7.5 LIBRAS ', 'FRESA', 0.00, 1999.00, 1, '2015-05-09 21:22:54', '2015-05-09 21:22:54'),
(89094021573, 2, 'ISOPURE ZERO CARB 7.5 LIBRAS ', 'COOKIES', 0.00, 1999.00, 1, '2015-05-09 21:22:54', '2015-05-09 21:22:54'),
(89094021894, 2, 'ISOPURE ZERO CARB 3 LIBRAS', 'MANZANA CON MELON', 0.00, 969.00, 1, '2015-05-09 21:22:54', '2015-05-09 21:22:54'),
(89094021931, 2, 'ISOPURE ', 'PIÃ‘A-NARANJA-PLATANO 3 LIBRAS', 0.00, 969.00, 1, '2015-05-09 21:22:54', '2015-05-09 21:22:54'),
(89094021955, 2, 'ISOPURE ', 'MANGO-DURAZNO 3 LIBRAS', 0.00, 969.00, 1, '2015-05-09 21:22:54', '2015-05-09 21:22:54'),
(89094021979, 2, 'ISOPURE ', 'COOKIES N CREAM 3 LIBRAS', 0.00, 969.00, 1, '2015-05-09 21:22:54', '2015-05-09 21:22:54'),
(89094022273, 2, 'ISOPURE ', 'PLATANO 3 LIBRAS', 0.00, 969.00, 1, '2015-05-09 21:22:54', '2015-05-09 21:22:54'),
(94922163073, 2, 'JACK 3D', 'LIMONADA', 0.00, 499.00, 1, '2015-05-09 21:22:54', '2015-05-09 21:22:54'),
(94922368942, 2, 'JACK3D 250 GRAMOS', 'PONCHE DE FRUTAS', 0.00, 519.00, 1, '2015-05-09 21:22:54', '2015-05-09 21:22:54'),
(120492048714, 2, 'TESTOGEN-XR 240 GRAMOS R. COLEMAN', 'NARANJA  ', 0.00, 769.00, 1, '2015-05-09 21:22:54', '2015-05-09 21:22:54'),
(610764010032, 2, 'ZERO CARB 4.4 LIBRAS', 'VAINILLA', 0.00, 1289.00, 1, '2015-05-09 21:22:54', '2015-05-09 21:22:54'),
(610764010131, 2, 'ZERO CARB 4.4 LIBRAS.', 'CHOCOLATE', 0.00, 1289.00, 1, '2015-05-09 21:22:54', '2015-05-09 21:22:54'),
(610764010186, 2, 'ZERO CARB 4.4 LIBRAS.', 'FRESA', 0.00, 1289.00, 1, '2015-05-09 21:22:54', '2015-05-09 21:22:54'),
(610764010339, 2, 'ZERO CARB 4.4 LIBRAS.', 'GALLETA', 0.00, 1289.00, 1, '2015-05-09 21:22:54', '2015-05-09 21:22:54'),
(610764180070, 2, 'POWER SHOCK', 'PONCHE DE FRUTAS', 0.00, 354.00, 1, '2015-05-09 21:22:54', '2015-05-09 21:22:54'),
(610764381484, 2, 'RED LINE ULTRA HARDCORE 120 CAPS.', 'CAPSULAS', 0.00, 549.00, 1, '2015-05-09 21:22:54', '2015-05-09 21:22:54'),
(610764711960, 2, 'MELTDOWN 120 CÃ¡PSULAS', 'CAPSULAS', 0.00, 549.00, 1, '2015-05-09 21:22:54', '2015-05-09 21:22:54'),
(610764732613, 2, 'ANARCHY COVALEX 214 GRAMOS', 'LIMON', 0.00, 359.00, 1, '2015-05-09 21:22:54', '2015-05-09 21:22:54'),
(610764732743, 2, 'FRICTION 345 GRAMOS VPX', 'FRUTAS EXOTICAS', 0.00, 479.00, 1, '2015-05-09 21:22:54', '2015-05-09 21:22:54'),
(610764732767, 2, 'FRICTION 345 GRAMOS VPX', 'SANDIA', 0.00, 479.00, 1, '2015-05-09 21:22:54', '2015-05-09 21:22:54'),
(610764733009, 2, 'BANG CREATIN', 'BARRRAS SUELTAS', 0.00, 40.00, 1, '2015-05-09 21:22:54', '2015-05-09 21:22:54'),
(610764733054, 2, 'BANG CREATINE BARS VPX 12 PZAS', 'CAJA DE BARRAS ', 0.00, 349.00, 1, '2015-05-09 21:22:54', '2015-05-09 21:22:54'),
(610764733146, 2, 'SOBRES DE PROMOCION', 'SOBRES', 0.00, 0.00, 1, '2015-05-09 21:22:54', '2015-05-09 21:22:54'),
(610764824868, 2, 'STEALTH 5 LIBRAS.', 'CHOCOLATE', 0.00, 669.00, 1, '2015-05-09 21:22:54', '2015-05-09 21:22:54'),
(610764825087, 2, 'SYNGEX 5 LIBRAS', 'CHOCOLATE', 0.00, 829.00, 1, '2015-05-09 21:22:54', '2015-05-09 21:22:54'),
(610764825100, 2, 'SYNGEX 5 LIBRAS', 'VAINILLA', 0.00, 829.00, 1, '2015-05-09 21:22:54', '2015-05-09 21:22:54'),
(610764825124, 2, 'SYNGEX 5 LIBRAS', 'COOKIES', 0.00, 829.00, 1, '2015-05-09 21:22:54', '2015-05-09 21:22:54'),
(610764825278, 2, 'ZERO IMPACT BARS VPX 12 BARRAS', 'BARRAS', 26.25, 40.00, 1, '2015-05-09 21:22:54', '2015-05-09 21:22:54'),
(610764830555, 2, 'ZERO IMPACT BARS VPX 12 BARRAS', 'BARRAS CAJA', 0.00, 359.00, 1, '2015-05-09 21:22:54', '2015-05-09 21:22:54'),
(610764840226, 2, 'SYNTHESIZE 1.42 LBS', 'FRUTAS', 0.00, 599.00, 1, '2015-05-09 21:22:54', '2015-05-09 21:22:54'),
(610764840486, 2, 'NO SHOT GUN ', 'FRUTAS EXOTICAS', 0.00, 609.00, 1, '2015-05-09 21:22:54', '2015-05-09 21:22:54'),
(610764860323, 2, 'NO SHUT GUN', 'UVA', 0.00, 609.00, 1, '2015-05-09 21:22:54', '2015-05-09 21:22:54'),
(610764860347, 2, 'SYNTHESIZE 1.42 LBS', 'UVA', 0.00, 599.00, 1, '2015-05-09 21:22:54', '2015-05-09 21:22:54'),
(610764860514, 2, 'SOBRES SHOT GUN', 'SOBRES', 0.00, 35.00, 1, '2015-05-09 21:22:54', '2015-05-09 21:22:54'),
(610764860729, 2, '12 GAUGE NO SHUT GUN', 'FRUTAS EXOTICAS', 0.00, 609.00, 1, '2015-05-09 21:22:54', '2015-05-09 21:22:54'),
(610764860743, 2, '12 GAUGE NO SHUT GUN', 'UVA ', 0.00, 609.00, 1, '2015-05-09 21:22:54', '2015-05-09 21:22:54'),
(627933065304, 2, 'MUTANT WHEY 5 LIBRAS', 'TRIPLE CHOCOLATE ', 0.00, 799.00, 1, '2015-05-09 21:22:54', '2015-05-09 21:22:54'),
(627933065311, 2, 'MUTANT WHEY 5 LIBRAS', 'VAINILLA', 0.00, 799.00, 1, '2015-05-09 21:22:54', '2015-05-09 21:22:54'),
(631656602692, 2, 'XENADRINE RIPPED', 'CAPSULAS', 441.00, 616.00, 1, '2015-05-09 21:22:54', '2015-05-09 21:22:54'),
(631656603330, 2, 'HYDROXYSTIM MUSCLETECH', '100 CAPS', 0.00, 599.00, 1, '2015-05-09 21:22:54', '2015-05-09 21:22:54'),
(631656603361, 2, 'HYDROXYCUT ELITE ', '100 CAPS', 0.00, 599.00, 1, '2015-05-09 21:22:54', '2015-05-09 21:22:54'),
(631656604504, 2, 'CLA MUSCLETECH PLATINUM ULTRA PURE 90 CAPS', 'CLA 90 CAPS', 0.00, 344.00, 1, '2015-05-09 21:22:54', '2015-05-09 21:22:54'),
(631656604740, 2, '100% CARNITINE PLATINUM 180 CAPS', '180 CAPS ', 0.00, 439.00, 1, '2015-05-09 21:22:54', '2015-05-09 21:22:54'),
(631656623154, 2, 'CREATINA 6000 TABLETAS', 'TABLETAS', 0.00, 469.00, 1, '2015-05-09 21:22:54', '2015-05-09 21:22:54'),
(631656703122, 2, 'NANO VAPOR 1 LB ULTRACONCENTRADO', 'PONCHE DE FRUTAS', 0.00, 659.00, 1, '2015-05-09 21:22:54', '2015-05-09 21:22:54'),
(631656703146, 3, 'NANO VAPOR 1 LB ULTRACONCENTRADO', 'BLUE RASPERRI', 0.00, 691.95, 1, '2015-05-09 21:22:54', '2015-05-09 21:22:54'),
(631656703160, 2, 'MASS-TECH 5 LIBRAS MUSCLETECH', 'VAINILLA', 0.00, 819.00, 1, '2015-05-09 21:22:54', '2015-05-09 21:22:54'),
(631656703214, 2, 'CELL TECH HARD CORE 7 LB.', 'PONCHE DE FRUTAS', 0.00, 850.00, 1, '2015-05-09 21:22:54', '2015-05-09 21:22:54'),
(631656703283, 2, 'NITRO TECH HARD CORE 4 LB', 'CHOCOLATE', 0.00, 1059.00, 1, '2015-05-09 21:22:54', '2015-05-09 21:22:54'),
(631656703290, 2, 'NITRO TECH HARD CORE 4 LB', 'VAINILLA', 0.00, 1059.00, 1, '2015-05-09 21:22:54', '2015-05-09 21:22:54'),
(631656703306, 2, 'NITRO TECH HARD CORE 4 LB', 'FRESA', 0.00, 1059.00, 1, '2015-05-09 21:22:54', '2015-05-09 21:22:54'),
(631656703313, 2, 'NITRO TECH HARD CORE 4 LB', 'COOKIES', 0.00, 1059.00, 1, '2015-05-09 21:22:54', '2015-05-09 21:22:54'),
(631656703412, 2, 'ANOTEST PERFORMANCE SERIES MUSCLETECH', 'PONCHE DE FRUTAS', 0.00, 699.00, 1, '2015-05-09 21:22:54', '2015-05-09 21:22:54'),
(631656703528, 2, 'PHASE 8 MUSCLETECH 5 LIBRAS', 'CHOCOLATE', 0.00, 849.00, 1, '2015-05-09 21:22:54', '2015-05-09 21:22:54'),
(631656703535, 2, 'PHASE 8 MUSCLETECH 5 LIBRAS', 'VAINILLA', 0.00, 849.00, 1, '2015-05-09 21:22:54', '2015-05-09 21:22:54'),
(631656703542, 2, 'PHASE 8 MUSCLETECH 5 LIBRAS', 'FRESA', 0.00, 849.00, 1, '2015-05-09 21:22:54', '2015-05-09 21:22:54'),
(632964301055, 2, 'C4 EXTREME 30 SERVICIOS', 'NARANJA', 0.00, 299.00, 1, '2015-05-09 21:22:54', '2015-05-09 21:22:54'),
(632964301123, 2, 'C4', 'LIMONADA', 0.00, 499.00, 1, '2015-05-09 21:22:54', '2015-05-09 21:22:54'),
(632964301130, 2, 'C4 EXTREME CELLUCOR 60 SERVICIOS', '60 CERVICIOS ', 0.00, 499.00, 1, '2015-05-09 21:22:54', '2015-05-09 21:22:54'),
(632964301147, 2, 'C4 EXTREME CELLUCOR 60 SERVICIOS', '60 CERVICIOS ', 0.00, 499.00, 1, '2015-05-09 21:22:54', '2015-05-09 21:22:54'),
(632964301154, 2, 'C4 EXTREME CELLUCOR 60 SERVICIOS', '60 CERVICIOS ', 0.00, 499.00, 1, '2015-05-09 21:22:54', '2015-05-09 21:22:54'),
(632964301536, 2, 'D4 THERMAL SHOCK CELLUCOR 60 CAPS.', '120 CAPS', 0.00, 834.00, 1, '2015-05-09 21:22:54', '2015-05-09 21:22:54'),
(632964302304, 2, 'NO 3 CHROME CELLUCOR 90 CAPS.', '90 CAPS', 0.00, 590.00, 1, '2015-05-09 21:22:54', '2015-05-09 21:22:54'),
(632964302434, 2, 'SUPER HD CELLUCOR TERMO. 60 CAPS', '60 CAPS', 0.00, 509.00, 1, '2015-05-09 21:22:54', '2015-05-09 21:22:54'),
(646511005112, 2, 'SIZE ON 2.84 LB.', 'NARANJA', 0.00, 699.00, 1, '2015-05-09 21:22:54', '2015-05-09 21:22:54'),
(646511005211, 2, 'SIZE ON 2.84 LB.', 'PONCHE DE FRUTAS', 0.00, 699.00, 1, '2015-05-09 21:22:54', '2015-05-09 21:22:54'),
(646511005235, 2, 'SIZE ON 2.84 LB.', 'LIMON', 0.00, 699.00, 1, '2015-05-09 21:22:54', '2015-05-09 21:22:54'),
(646511005242, 2, 'SIZE ON 2.84 LB.', 'UVA', 0.00, 699.00, 1, '2015-05-09 21:22:54', '2015-05-09 21:22:54'),
(646511006560, 2, 'VIRIDEX 120 CAPS.', 'CAPSULAS', 0.00, 629.00, 1, '2015-05-09 21:22:54', '2015-05-09 21:22:54'),
(646511007000, 2, 'BCAAÂ´S 6000 180 TABS. GASPARI', 'TABLETAS', 0.00, 364.00, 1, '2015-05-09 21:22:54', '2015-05-09 21:22:54'),
(646511007222, 2, 'SUPER PUMP', 'PONCHE', 0.00, 599.00, 1, '2015-05-09 21:22:54', '2015-05-09 21:22:54'),
(646511007239, 2, 'SUPER PUMP', 'NARANJA', 0.00, 599.00, 1, '2015-05-09 21:22:54', '2015-05-09 21:22:54'),
(646511007277, 2, 'SUPER PUMP', 'UVA', 0.00, 599.00, 1, '2015-05-09 21:22:54', '2015-05-09 21:22:54'),
(646511007284, 2, 'SUPER PUMP', 'MANZANA', 0.00, 599.00, 1, '2015-05-09 21:22:54', '2015-05-09 21:22:54'),
(646511008403, 2, 'AMINO LAST', 'FRESA', 0.00, 469.00, 1, '2015-05-09 21:22:54', '2015-05-09 21:22:54'),
(646511008410, 2, 'AMINO LAST', 'LIMON', 0.00, 469.00, 1, '2015-05-09 21:22:54', '2015-05-09 21:22:54'),
(646511008434, 2, 'AMINO LAST', 'SANDIA', 0.00, 469.00, 1, '2015-05-09 21:22:54', '2015-05-09 21:22:54'),
(646511009165, 2, 'REAL MASS 12 LIBRAS GASPARI NUTRITION', 'VAINILLA', 0.00, 879.00, 1, '2015-05-09 21:22:54', '2015-05-09 21:22:54'),
(646511009172, 2, 'REAL MASS 12 LIBRAS GASPARI NUTRITION', 'CHOCOLATE', 0.00, 879.00, 1, '2015-05-09 21:22:54', '2015-05-09 21:22:54'),
(646511016019, 2, 'MYOFUSION', 'VAINILLA', 0.00, 819.00, 1, '2015-05-09 21:22:54', '2015-05-09 21:22:54'),
(646511016026, 2, 'MYOFUSION', 'FRESA', 0.00, 819.00, 1, '2015-05-09 21:22:54', '2015-05-09 21:22:54'),
(646511016033, 2, 'MYOFUSION', 'CHOCOLATE', 0.00, 819.00, 1, '2015-05-09 21:22:54', '2015-05-09 21:22:54'),
(646511020252, 2, 'MYOFUSION', 'GALLETA', 0.00, 819.00, 1, '2015-05-09 21:22:54', '2015-05-09 21:22:54'),
(646511020269, 2, 'MYOFUSION', 'VAINILLA', 0.00, 819.00, 1, '2015-05-09 21:22:54', '2015-05-09 21:22:54'),
(646511020276, 2, 'MYOFUSION', 'FRESA', 0.00, 819.00, 1, '2015-05-09 21:22:54', '2015-05-09 21:22:54'),
(646511020283, 2, 'MYOFUSION', 'CHOCOLATE ', 0.00, 819.00, 1, '2015-05-09 21:22:54', '2015-05-09 21:22:54'),
(646511021112, 2, 'SUPER DRIVE 20 SERV. GASPARI', 'PONCHE', 0.00, 299.00, 1, '2015-05-09 21:22:54', '2015-05-09 21:22:54'),
(646511021129, 2, 'SUPER DRIVE 20 SERV. GASPARI', 'FRESA', 0.00, 299.00, 1, '2015-05-09 21:22:54', '2015-05-09 21:22:54'),
(646511021174, 2, 'SUPER DRIVE 40 SERV. GASPARI', 'NARANJA', 0.00, 499.00, 1, '2015-05-09 21:22:54', '2015-05-09 21:22:54'),
(646511021181, 2, 'SUPER DRIVE 40 SERV. GASPARI', 'LIMON', 0.00, 499.00, 1, '2015-05-09 21:22:54', '2015-05-09 21:22:54'),
(646511022058, 2, 'SUPER PUMP 3.0 ULTRA-CONCENTRADO', 'SANDIA', 0.00, 459.00, 1, '2015-05-09 21:22:54', '2015-05-09 21:22:54'),
(646511022157, 2, 'SUPER PUMP 3.0 ULTRA-CONCENTRADO', 'FRESA KIWI', 0.00, 459.00, 1, '2015-05-09 21:22:54', '2015-05-09 21:22:54'),
(646511022188, 2, 'SUPER PUMP 3.0 ULTRA-CONCENTRADO', 'LIMON', 0.00, 459.00, 1, '2015-05-09 21:22:54', '2015-05-09 21:22:54'),
(652908000011, 2, 'ATP CREATINE SERUM 5.1 OZ', 'CHERRY', 0.00, 499.00, 1, '2015-05-09 21:22:54', '2015-05-09 21:22:54'),
(652908000028, 2, 'ATP CREATINE SERUM 5.1 OZ', 'STRAWBERRY', 0.00, 499.00, 1, '2015-05-09 21:22:54', '2015-05-09 21:22:54'),
(652908000066, 2, 'ATP CREATINE SERUM 5.1 OZ', 'BLUEBERRY', 0.00, 499.00, 1, '2015-05-09 21:22:54', '2015-05-09 21:22:54'),
(652908000073, 2, 'ATP CREATINE SERUM 5.1 OZ', 'RASPBERRY', 0.00, 499.00, 1, '2015-05-09 21:22:54', '2015-05-09 21:22:54'),
(652908660062, 2, 'XTRA CREATINE SERUM WITH GLUTAMINE 5.1 OZ', 'BLUEBERRY', 0.00, 499.00, 1, '2015-05-09 21:22:54', '2015-05-09 21:22:54'),
(652908670061, 2, 'XTRA CREATINE SERUM WITH GLUTAMINE 5.1 OZ', 'RASPBERRY', 0.00, 499.00, 1, '2015-05-09 21:22:54', '2015-05-09 21:22:54'),
(652908680060, 2, 'XTRA CREATINE SERUM WITH GLUTAMINE 5.1 OZ', 'NARANJA', 0.00, 499.00, 1, '2015-05-09 21:22:54', '2015-05-09 21:22:54'),
(666222091273, 2, 'UP YOUR MASS 5 LIBRAS', 'PEANUT BUTTER', 0.00, 554.00, 1, '2015-05-09 21:22:54', '2015-05-09 21:22:54'),
(666222091587, 2, 'ISO-FAST 50 3 LIBRAS', 'CHOCOLATE ', 0.00, 679.00, 1, '2015-05-09 21:22:54', '2015-05-09 21:22:54'),
(666222091594, 2, 'ISO-FAST 50 3 LIBRAS', 'VAINILLA', 0.00, 679.00, 1, '2015-05-09 21:22:54', '2015-05-09 21:22:54'),
(666222731032, 2, 'SOBRES UP YOUR MASS', 'SOBRES', 0.00, 35.00, 1, '2015-05-09 21:22:54', '2015-05-09 21:22:54'),
(666222731100, 2, 'UP YOUR MASS 5 LIBRAS', 'CINANABUN', 0.00, 554.00, 1, '2015-05-09 21:22:54', '2015-05-09 21:22:54'),
(666222732107, 2, 'UP YOUR MASS 5 LIBRAS', 'COOKIES N CREAM', 0.00, 554.00, 1, '2015-05-09 21:22:54', '2015-05-09 21:22:54'),
(672898126003, 2, 'PURE CLA 1250, 180 SOFTGEL', 'CLA', 0.00, 349.00, 1, '2015-05-09 21:22:54', '2015-05-09 21:22:54'),
(672898440055, 2, 'L-CARNITINE POWER 60 CAPS.', '60 CAPS', 0.00, 239.00, 1, '2015-05-09 21:22:54', '2015-05-09 21:22:54'),
(672898440062, 2, 'L-CARNITINE POWER 112 GMS. SAN', '112 GR', 0.00, 294.00, 1, '2015-05-09 21:22:54', '2015-05-09 21:22:54'),
(687339941015, 2, 'GOFIT GUANTES  VERDE PARA MUJER', 'CHICO', 0.00, 329.00, 1, '2015-05-09 21:22:54', '2015-05-09 21:22:54'),
(687339981004, 2, 'GOFIT GUANTES  ROSA CON NEGRO PARA MUJER', 'CHICO', 0.00, 329.00, 1, '2015-05-09 21:22:54', '2015-05-09 21:22:54'),
(687339981011, 2, 'GOFIT GUANTES  ROSA CON NEGRO PARA MUJER', 'MEDIANO', 0.00, 329.00, 1, '2015-05-09 21:22:54', '2015-05-09 21:22:54'),
(687339981110, 2, 'GOFIT GUAANTES NEGORS PRA HOMBRE', 'MEDIANO', 0.00, 329.00, 1, '2015-05-09 21:22:54', '2015-05-09 21:22:54'),
(687339981127, 2, 'GOFIT GUAANTES NEGORS PRA HOMBRE', 'GRANDE', 0.00, 329.00, 1, '2015-05-09 21:22:54', '2015-05-09 21:22:54'),
(687339984012, 2, 'GOFIT GUANTES  ROSAS PARA MUJER', 'CHICO', 0.00, 329.00, 1, '2015-05-09 21:22:54', '2015-05-09 21:22:54'),
(687339984029, 2, 'GOFIT GUANTES  ROSAS PARA MUJER', 'MEDIANO', 0.00, 329.00, 1, '2015-05-09 21:22:54', '2015-05-09 21:22:54'),
(696859258374, 2, 'IRON CRE3 123 GRAMOS CREATINA', 'CREATINA', 0.00, 389.00, 1, '2015-05-09 21:22:54', '2015-05-09 21:22:54'),
(696859258459, 2, 'IRON MASS 5 LIBRAS', 'VAINILLA', 0.00, 784.00, 1, '2015-05-09 21:22:54', '2015-05-09 21:22:54'),
(696859258466, 2, 'IRON MASS 5 LIBRAS', 'CHOCOLATE', 0.00, 784.00, 1, '2015-05-09 21:22:54', '2015-05-09 21:22:54'),
(696859258527, 2, 'IRON PUMP 30 SERVICIOS Ã“XIDO NÃTRICO', 'PONCHE', 0.00, 419.00, 1, '2015-05-09 21:22:54', '2015-05-09 21:22:54'),
(696859258534, 2, 'IRON PUMP 30 SERVICIOS Ã“XIDO NÃTRICO', 'LEMON', 0.00, 419.00, 1, '2015-05-09 21:22:54', '2015-05-09 21:22:54'),
(696859258601, 2, 'IRON WHEY 5 LIBRAS', 'CHOCOLATE', 0.00, 849.00, 1, '2015-05-09 21:22:54', '2015-05-09 21:22:54'),
(696859258602, 2, 'IRON WHEY 5 LIBRAS', 'VAINILLA', 0.00, 849.00, 1, '2015-05-09 21:22:54', '2015-05-09 21:22:54'),
(696859261176, 2, 'BCAAÂ´S 3:1:2 POWER 30 SERV. MUSCLE P.', 'BCAA 215 GR', 0.00, 359.00, 1, '2015-05-09 21:22:54', '2015-05-09 21:22:54'),
(696859261718, 2, 'IRON WHEY ', 'BANANA', 0.00, 849.00, 1, '2015-05-09 21:22:54', '2015-05-09 21:22:54'),
(705016103027, 2, 'SOBRES PROTEÃNA', 'ELITE CHOCOLATE', 0.00, 30.00, 1, '2015-05-09 21:22:54', '2015-05-09 21:22:54'),
(705016110001, 2, 'CREATINA 1 KILO DYMATIZE', 'POLVO', 0.00, 339.00, 1, '2015-05-09 21:22:54', '2015-05-09 21:22:54'),
(705016205004, 2, 'CREATINA 500 G. DYMATIZE', 'POLVO', 0.00, 199.00, 1, '2015-05-09 21:22:54', '2015-05-09 21:22:54'),
(705016210008, 2, 'GLUTAMINA 1000 GR. DYMATIZE', 'POLVO', 0.00, 699.00, 1, '2015-05-09 21:22:54', '2015-05-09 21:22:54'),
(705016260133, 2, 'XPAND XTREME PUMP 280 GRAMOS', 'UVA', 0.00, 289.00, 1, '2015-05-09 21:22:54', '2015-05-09 21:22:54'),
(705016289004, 2, 'XPAND XTREME 2X ', 'PONCHE DE FRUTAS', 0.00, 470.00, 1, '2015-05-09 21:22:54', '2015-05-09 21:22:54'),
(705016289042, 2, 'XPAND 2X', 'RED RASPBERRY', 0.00, 470.00, 1, '2015-05-09 21:22:54', '2015-05-09 21:22:54'),
(705016289066, 2, 'XPAND XTREME 2X ', 'WATERMELON', 0.00, 470.00, 1, '2015-05-09 21:22:54', '2015-05-09 21:22:54'),
(705016289127, 2, 'SOBRES  XPAND XX', 'SOBRES', 0.00, 42.00, 1, '2015-05-09 21:22:54', '2015-05-09 21:22:54'),
(705016289400, 2, 'XPAND XTREME 2X', 'LIMON', 0.00, 470.00, 1, '2015-05-09 21:22:54', '2015-05-09 21:22:54'),
(705016331215, 2, 'SUPER MASS GAINER  12 LBS.', 'VAINILLA', 0.00, 759.00, 1, '2015-05-09 21:22:54', '2015-05-09 21:22:54'),
(705016331222, 2, 'SUPER MASS GAINER  12 LBS.', 'CHOCOLATE', 0.00, 759.00, 1, '2015-05-09 21:22:54', '2015-05-09 21:22:54'),
(705016331239, 2, 'SUPER MASS GAINER  12 LBS.', 'FRESA ', 0.00, 759.00, 1, '2015-05-09 21:22:54', '2015-05-09 21:22:54'),
(705016331246, 2, 'SUPER MASS GAINER 12 LIBRAS', 'COOKIES', 0.00, 759.00, 1, '2015-05-09 21:22:54', '2015-05-09 21:22:54'),
(705016331260, 2, 'SUPER MASS GAINER 6 LB.', 'FRESA', 0.00, 434.00, 1, '2015-05-09 21:22:54', '2015-05-09 21:22:54'),
(705016353194, 2, 'ISO 100', 'PIÃ±A COLADA', 0.00, 1279.00, 1, '2015-05-09 21:22:54', '2015-05-09 21:22:54'),
(705016381401, 2, 'BCAAÂ´S DYMATIZE 400 TABLETAS', 'TABLETAS', 0.00, 469.00, 1, '2015-05-09 21:22:54', '2015-05-09 21:22:54'),
(705016383016, 2, 'BCAAÂ´S COMPLEX 300 GR.', 'POLVO', 0.00, 349.00, 1, '2015-05-09 21:22:54', '2015-05-09 21:22:54'),
(705016384068, 2, 'SUPER AMINO 6000 MG, 500 TABS. DYMAT.', 'AMINOS 500 CAPS', 0.00, 409.00, 1, '2015-05-09 21:22:54', '2015-05-09 21:22:54'),
(705016433018, 2, 'ELITE GOURMET 5 LIBRAS', 'CHOCOLATE', 0.00, 819.00, 1, '2015-05-09 21:22:54', '2015-05-09 21:22:54'),
(705016433032, 2, 'ELITE GOURMET 5 LIBRAS', 'COOKIES & CREAM', 0.00, 819.00, 1, '2015-05-09 21:22:54', '2015-05-09 21:22:54'),
(705016433049, 2, 'ELITE GOURMET 5 LIBRAS', 'CHOCOLATE PENUT', 0.00, 819.00, 1, '2015-05-09 21:22:54', '2015-05-09 21:22:54'),
(705016433094, 2, 'ELITE GOURMET 5 LIBRAS', 'CAPUCHINO', 0.00, 819.00, 1, '2015-05-09 21:22:54', '2015-05-09 21:22:54'),
(705016433315, 2, 'ELITE NATURAL 2 LIBRAS', 'CHOCOLATE', 0.00, 469.00, 1, '2015-05-09 21:22:54', '2015-05-09 21:22:54'),
(705016433339, 2, 'ELITE NATURAL 2 LIBRAS', 'FRESA', 0.00, 469.00, 1, '2015-05-09 21:22:54', '2015-05-09 21:22:54'),
(705016433353, 2, 'ELITE NATURAL 2 LIBRAS', 'VAINILLA', 0.00, 469.00, 1, '2015-05-09 21:22:54', '2015-05-09 21:22:54'),
(705016433452, 2, 'ELITE GOURMET 5 LIBRAS', 'VAINILLA', 0.00, 819.00, 1, '2015-05-09 21:22:54', '2015-05-09 21:22:54'),
(705016471607, 2, 'L-CARNITINA XTREME 500 MG. 60 CAP.', 'CAPSULAS', 0.00, 165.00, 1, '2015-05-09 21:22:54', '2015-05-09 21:22:54'),
(705016473137, 2, 'LIQUID L-CARNITNIA 16 OZ BERRY', 'BERRY', 0.00, 189.00, 1, '2015-05-09 21:22:54', '2015-05-09 21:22:54'),
(705016473168, 2, 'LIQUID L-CARNITNIA 16 OZ BERRY', 'LOMON', 0.00, 189.00, 1, '2015-05-09 21:22:54', '2015-05-09 21:22:54'),
(705016500000, 2, 'ISO 100 5 LIBRAS', 'BANANA', 0.00, 1279.00, 1, '2015-05-09 21:22:54', '2015-05-09 21:22:54'),
(705016500017, 2, 'ISO 100 5 LIBRAS', 'VAINILLA', 0.00, 1279.00, 1, '2015-05-09 21:22:54', '2015-05-09 21:22:54'),
(705016500024, 2, 'ISO 100 5 LIBRAS', 'GOURMETCHOCOLATE', 0.00, 1279.00, 1, '2015-05-09 21:22:54', '2015-05-09 21:22:54'),
(705016500031, 2, 'ISO 100 5 LIBRAS', 'FRESA', 0.00, 1279.00, 1, '2015-05-09 21:22:54', '2015-05-09 21:22:54'),
(705016500079, 2, 'ISO 100 5 LIBRAS', 'CUKIES', 0.00, 1279.00, 1, '2015-05-09 21:22:54', '2015-05-09 21:22:54'),
(705016555529, 2, 'ELITE WHEY PROT.', 'CHOCOLATE', 0.00, 959.00, 1, '2015-05-09 21:22:54', '2015-05-09 21:22:54'),
(705016555536, 2, 'ELITE WHEY PROT.', 'FRESA', 0.00, 959.00, 1, '2015-05-09 21:22:54', '2015-05-09 21:22:54'),
(705016560073, 1, 'ELITE WHEY', 'CHOCOLATE', 0.00, 959.00, 1, '2015-05-09 21:22:54', '2015-05-09 21:22:54'),
(705016791019, 2, 'DYMABURN XTREME 100 CAPS.', 'CAPSULAS', 0.00, 339.00, 1, '2015-05-09 21:22:54', '2015-05-09 21:22:54'),
(705016890040, 2, 'ELITE XT 4.4 LIBRAS', 'BANANA', 0.00, 560.00, 1, '2015-05-09 21:22:54', '2015-05-09 21:22:54'),
(705016890057, 2, 'ELITE XT 4.4 LIBRAS', 'VAINILLA', 0.00, 560.00, 1, '2015-05-09 21:22:54', '2015-05-09 21:22:54'),
(705016890064, 2, 'ELITE XT 4.4 LIBRAS', 'CHOCOLATE', 0.00, 560.00, 1, '2015-05-09 21:22:54', '2015-05-09 21:22:54'),
(705016890071, 2, 'ELITE XT 4.4 LIBRAS', 'FUDGE BROWNIE', 0.00, 560.00, 1, '2015-05-09 21:22:54', '2015-05-09 21:22:54'),
(705016895229, 2, 'ELITE FUSION 7 5.15 LIBRAS', 'FRESA', 0.00, 769.00, 1, '2015-05-09 21:22:54', '2015-05-09 21:22:54'),
(705016895281, 2, 'SOBRES PROTEÃNA', 'SOBRES FUSION 7', 0.00, 30.00, 1, '2015-05-09 21:22:54', '2015-05-09 21:22:54'),
(705016993017, 2, 'ELITE GOURMET BAR 12 PZAS', 'COOKIES &CREAM', 0.00, 389.00, 1, '2015-05-09 21:22:54', '2015-05-09 21:22:54'),
(705016993031, 2, 'ELITE GURMET  BARRAS', 'BARRAS SUELRAS', 0.00, 40.00, 1, '2015-05-09 21:22:54', '2015-05-09 21:22:54'),
(705016993055, 2, 'ELITE GOURMET BAR 12 PZAS', 'BARAS GRANDES ', 0.00, 389.00, 1, '2015-05-09 21:22:54', '2015-05-09 21:22:54'),
(705016993123, 2, 'ELITE GOURMET BAR  CHICA', '6 BARRAS DE CHOCOLATE', 0.00, 119.00, 1, '2015-05-09 21:22:54', '2015-05-09 21:22:54'),
(710779113022, 2, 'LEAN BODY', 'SOBRES', 0.00, 42.00, 1, '2015-05-09 21:22:54', '2015-05-09 21:22:54'),
(710779118478, 2, 'LEAN BODY CINNABUN C/ 12 PZAS', 'BARRAS', 21.00, 40.00, 1, '2015-05-09 21:22:54', '2015-05-09 21:22:54'),
(710779118904, 2, 'SWEET & SALTY BAR 12 PZAS', 'CAJA DE BARRAS', 0.00, 309.00, 1, '2015-05-09 21:22:54', '2015-05-09 21:22:54'),
(710779119000, 2, 'HI - PROTEIN COOKIE ROLL BARS 12 BS.', 'BARRAS  DE BROWNIE', 0.00, 349.00, 1, '2015-05-09 21:22:54', '2015-05-09 21:22:54'),
(710779333451, 2, 'CHARGE X 60 CAPS LABRADA', '60 CAPS', 0.00, 246.00, 1, '2015-05-09 21:22:54', '2015-05-09 21:22:54'),
(710779444614, 2, 'SUPER CHARGE XTREME LABRADA 800 G.', 'UVA', 0.00, 599.00, 1, '2015-05-09 21:22:54', '2015-05-09 21:22:54'),
(710779444621, 2, 'SUPER CHARGE XTREME LABRADA 800 G.', 'NARANJA', 0.00, 599.00, 1, '2015-05-09 21:22:54', '2015-05-09 21:22:54'),
(710779444638, 2, 'SUPER CHARGE XTREME LABRADA 800 G.', 'PONCHE DE FRUTAS', 0.00, 599.00, 1, '2015-05-09 21:22:54', '2015-05-09 21:22:54'),
(710779444676, 2, 'SUPER CHARGE XTREME LABRADA 800 G.', 'BLUE RASPBERRY', 0.00, 599.00, 1, '2015-05-09 21:22:54', '2015-05-09 21:22:54'),
(710779444805, 2, 'LEAN BODY CINNABUN C/ 12 PZAS', 'BARRAS CAJA', 0.00, 388.00, 1, '2015-05-09 21:22:54', '2015-05-09 21:22:54'),
(732907051006, 2, 'PROTAN 16 OZ', 'SPRAY', 0.00, 519.00, 1, '2015-05-09 21:22:54', '2015-05-09 21:22:54'),
(732907051273, 2, 'PROTAN STAGE FITNESS CREMA', 'CREMA', 0.00, 259.00, 1, '2015-05-09 21:22:54', '2015-05-09 21:22:54'),
(732907100186, 2, 'PROTAN 8 OZ', 'SPRAY', 0.00, 259.00, 1, '2015-05-09 21:22:54', '2015-05-09 21:22:54'),
(732907100940, 2, 'HOT STUFF 4 OZ VASODILATATION ', 'VASO DILATADOR', 0.00, 169.00, 1, '2015-05-09 21:22:54', '2015-05-09 21:22:54'),
(736211053879, 2, 'ARMOR-V 180 CAPS. MUSCLE PHARM', '180 CAPS', 0.00, 419.00, 1, '2015-05-09 21:22:54', '2015-05-09 21:22:54'),
(748927023800, 2, 'SERIOUS MASS 12 LIBRAS', 'CHOCOLATE', 0.00, 1050.00, 1, '2015-05-09 21:22:54', '2015-05-09 21:22:54'),
(748927023824, 2, 'SERIOUS MASS 12 LIBRAS', 'VAINILLA', 0.00, 1050.00, 1, '2015-05-09 21:22:54', '2015-05-09 21:22:54'),
(748927026238, 2, '100% WHEY PROTEIN GOLD ESTÃNDAR 5 LB', 'MOCA CAPUCHINO', 0.00, 1029.00, 1, '2015-05-09 21:22:54', '2015-05-09 21:22:54'),
(748927028669, 2, '100% WHEY PROTEIN GOLD ESTÃNDAR 5 LB', 'CHOCOLATE', 0.00, 1029.00, 1, '2015-05-09 21:22:54', '2015-05-09 21:22:54'),
(748927028683, 2, '100% WHEY PROTEIN GOLD ESTÃNDAR 5 LB', 'GALLETA', 0.00, 1029.00, 1, '2015-05-09 21:22:54', '2015-05-09 21:22:54'),
(748927028690, 2, '100% GOLD STANDAR', 'FRESA', 0.00, 1029.00, 1, '2015-05-09 21:22:54', '2015-05-09 21:22:54'),
(748927028706, 2, '100% WHEY PROTEIN GOLD ESTÃNDAR 5 LB', 'VAINILLA', 0.00, 1029.00, 1, '2015-05-09 21:22:54', '2015-05-09 21:22:54'),
(749826125602, 2, 'PURE 31 PROTEIN', 'BARAS SUELTAS ', 0.00, 40.00, 1, '2015-05-09 21:22:54', '2015-05-09 21:22:54'),
(773094904416, 2, 'HC SAISEN', 'HC', 0.00, 200.00, 1, '2015-05-09 21:22:54', '2015-05-09 21:22:54'),
(786560153126, 2, 'BIG 100 COLOSAL', 'BARRAS SUELTAS ', 0.00, 40.00, 1, '2015-05-09 21:22:54', '2015-05-09 21:22:54'),
(786560153133, 2, 'MET-RX BIG 100 COLOSSAL 12 BARRAS', 'BARRAS', 24.75, 33.25, 1, '2015-05-09 21:22:54', '2015-05-09 21:22:54'),
(786560502405, 2, 'PROTEIN PLUS BAR 12 PIEZAS', 'NATURALL', 0.00, 379.00, 1, '2015-05-09 21:22:54', '2015-05-09 21:22:54'),
(788434110440, 2, 'OH YEAH BAR CAJA CON 12 BARRAS', 'CHOCOLATE CARAMEL CANDIES', 0.00, 449.00, 1, '2015-05-09 21:22:54', '2015-05-09 21:22:54'),
(788434113571, 2, 'OH YEAH BAR CAJA CON 12 BARRAS', 'PENAUT BUTER CARAMELO', 0.00, 449.00, 1, '2015-05-09 21:22:54', '2015-05-09 21:22:54'),
(788434113632, 2, 'OH YEAH BAR CAJA CON 12 BARRAS', 'PENAUT BUTER', 0.00, 449.00, 1, '2015-05-09 21:22:54', '2015-05-09 21:22:54'),
(788434114080, 2, 'OH YEAH BAR CAJA CON 12 BARRAS', 'CARAMEL VAINILLA', 0.00, 449.00, 1, '2015-05-09 21:22:54', '2015-05-09 21:22:54'),
(788434114172, 2, 'OH YEAH BAR CAJA CON 12 BARRAS', 'CARAMEL VAINILLA', 0.00, 449.00, 1, '2015-05-09 21:22:54', '2015-05-09 21:22:54'),
(788434114417, 2, 'OH YEAH BAR CAJA CON 12 BARRAS', 'ALMOD FUDDGE BROUNI', 0.00, 449.00, 1, '2015-05-09 21:22:54', '2015-05-09 21:22:54'),
(788434114646, 2, 'OH YEAH BAR CAJA CON 12 BARRAS', 'KOKIS CARAMEL', 0.00, 449.00, 1, '2015-05-09 21:22:54', '2015-05-09 21:22:54'),
(810150020502, 2, 'BIG-T 28 CAPS. CUTLER, PRO-HORMONAL', 'PREORMONAL', 0.00, 409.00, 1, '2015-05-09 21:22:54', '2015-05-09 21:22:54'),
(810150020564, 2, 'LEGEND 28 SERV. CUTLER PRE-ENTRENO', 'UVA', 0.00, 469.00, 1, '2015-05-09 21:22:54', '2015-05-09 21:22:54'),
(810150020618, 2, 'DRY 28 CAPS. CUTLER, PRO-HORMONAL', 'PREORMONAL', 0.00, 419.00, 1, '2015-05-09 21:22:54', '2015-05-09 21:22:54'),
(810150020625, 2, 'AMINO PUMP CUTLER NUTRITION', 'PONCHE DE FRUTAS', 0.00, 375.00, 1, '2015-05-09 21:22:54', '2015-05-09 21:22:54'),
(810150020632, 2, 'AMINO PUMP CUTLER NUTRITION', 'BLUE BERRI', 0.00, 375.00, 1, '2015-05-09 21:22:54', '2015-05-09 21:22:54'),
(810150020687, 2, 'PURE MUSCLE MASS 5.8 LIBRAS CUTLER', 'CUTLER MASS', 0.00, 649.00, 1, '2015-05-09 21:22:54', '2015-05-09 21:22:54'),
(810150020694, 2, 'TOTAL PROTEIN 5 LBS CUTLER NUTRITION', 'VAINILLA', 0.00, 819.00, 1, '2015-05-09 21:22:54', '2015-05-09 21:22:54'),
(810150020700, 2, 'TOTAL PROTEIN 5 LBS. CUTLER NUTRITION', 'CHOCOLATE', 0.00, 819.00, 1, '2015-05-09 21:22:54', '2015-05-09 21:22:54'),
(810150020731, 2, 'KING 90 CAPS, CUTLER, ANABOLIZANTE', 'ANABOLIZANTE', 0.00, 584.00, 1, '2015-05-09 21:22:54', '2015-05-09 21:22:54'),
(811662020004, 2, 'MUTANT MASS 15 LIBRAS', 'VAINILLA', 0.00, 1055.00, 1, '2015-05-09 21:22:54', '2015-05-09 21:22:54'),
(811662020011, 2, 'MUTANT MASS 15 LIBRAS', 'CHOCOLATE', 0.00, 1055.00, 1, '2015-05-09 21:22:54', '2015-05-09 21:22:54'),
(811662020035, 2, 'MUTANT MASS 15 LIBRAS', 'KUKIES', 0.00, 1055.00, 1, '2015-05-09 21:22:54', '2015-05-09 21:22:54'),
(834266002177, 2, 'CELL MASS DE 50 SERVICIOS', 'GRAPE', 0.00, 599.00, 1, '2015-05-09 21:22:54', '2015-05-09 21:22:54'),
(834266002221, 2, 'CELL MASS DE 50 SERVICIOS', 'ARCTC BERRY', 0.00, 599.00, 1, '2015-05-09 21:22:54', '2015-05-09 21:22:54'),
(834266003266, 2, 'AMINO-X BSN 30 SERVICIOS', 'SANDIA', 0.00, 429.00, 1, '2015-05-09 21:22:54', '2015-05-09 21:22:54'),
(834266003303, 2, 'AMINO-X 30 SERVICIOS BSN', 'PONCHE DE FRUTAS', 0.00, 429.00, 1, '2015-05-09 21:22:54', '2015-05-09 21:22:54'),
(834266003389, 2, 'AMINO-X 30 SERVICIOS BSN', 'BLUE RAZ', 0.00, 429.00, 1, '2015-05-09 21:22:54', '2015-05-09 21:22:54'),
(834266005031, 2, 'NITRIX 180 TABLETAS', 'TABLETAS ', 0.00, 612.00, 1, '2015-05-09 21:22:54', '2015-05-09 21:22:54'),
(834266006502, 2, 'TRUE MASS BSN', 'FRESA', 0.00, 899.00, 1, '2015-05-09 21:22:54', '2015-05-09 21:22:54'),
(834266006557, 2, 'TRUE MASS BSN', 'CHOCOLATE', 0.00, 899.00, 1, '2015-05-09 21:22:54', '2015-05-09 21:22:54'),
(834266006601, 2, 'TRUE MASS BSN', 'VAINILLA', 0.00, 899.00, 1, '2015-05-09 21:22:54', '2015-05-09 21:22:54'),
(834266006656, 2, 'TRUE MASS BSN', 'COOKIES', 0.00, 899.00, 1, '2015-05-09 21:22:54', '2015-05-09 21:22:54'),
(834266007301, 2, 'SYNTA-6 BSN', 'COOKIES', 0.00, 1009.00, 1, '2015-05-09 21:22:54', '2015-05-09 21:22:54'),
(834266009282, 2, 'NO XPLODE 2.25 LBS, 50 SERVICIOS', 'MANZANA VERDE', 0.00, 759.00, 1, '2015-05-09 21:22:54', '2015-05-09 21:22:54'),
(834266009305, 2, 'NO XPLODE 2.25 LBS, 50 SERVICIOS', 'PONCHE DE FRUTAS', 0.00, 759.00, 1, '2015-05-09 21:22:54', '2015-05-09 21:22:54'),
(834266009343, 2, 'NO XPLODE 2.25 LBS, 50 SERVICIOS', 'NARANGA', 0.00, 759.00, 1, '2015-05-09 21:22:54', '2015-05-09 21:22:54'),
(834266009367, 2, 'NO XPLODE 2.25 LBS + 25% FREE', 'GRAPE', 0.00, 759.00, 1, '2015-05-09 21:22:54', '2015-05-09 21:22:54'),
(834266009381, 2, 'NO XPLODE 2.25 LBS, 50 SERVICIOS', 'BLU BERRI', 0.00, 759.00, 1, '2015-05-09 21:22:54', '2015-05-09 21:22:54'),
(834266009404, 2, 'NO XPLODE 2.25 LBS, 50 SERVICIOS', 'LIMA LIMON', 0.00, 759.00, 1, '2015-05-09 21:22:54', '2015-05-09 21:22:54'),
(834266009466, 2, 'NO XPLODE 2.25 LBS + 25% FREE', 'LIMON', 0.00, 759.00, 1, '2015-05-09 21:22:54', '2015-05-09 21:22:54'),
(834266063383, 2, 'AMINO-X 70 SERV. BSN', 'GRANDE', 0.00, 679.00, 1, '2015-05-09 21:22:54', '2015-05-09 21:22:54'),
(847534000003, 2, 'GRANADAS TERMOGÃ‰NICO 100 CÃPSULAS', '100 TABS', 0.00, 644.00, 1, '2015-05-09 21:22:54', '2015-05-09 21:22:54'),
(851780002230, 2, 'A-HD 250 MG 28 CAPS', 'CAPSULAS', 0.00, 449.00, 1, '2015-05-09 21:22:54', '2015-05-09 21:22:54'),
(851780003763, 2, '1.M.R. BPI PRE-ENTRENO ULTRACONCENTRADO ', 'LIMONADA', 0.00, 524.00, 1, '2015-05-09 21:22:54', '2015-05-09 21:22:54'),
(851780003800, 2, '1.M.R. BPI PRE-ENTRENO ULTRACONCENTRADO ', 'LIMONADA', 0.00, 524.00, 1, '2015-05-09 21:22:54', '2015-05-09 21:22:54'),
(851780003848, 2, '1.M.R. BPI PRE-ENTRENO ULTRACONCENTRADO', 'NARANJA', 0.00, 524.00, 1, '2015-05-09 21:22:54', '2015-05-09 21:22:54'),
(852435000021, 2, 'DREAM TAN CREMA ', 'CREMA', 0.00, 324.00, 1, '2015-05-09 21:22:54', '2015-05-09 21:22:54'),
(853237000127, 2, 'VITRIX 180 CAPS.', 'CAPSULAS', 0.00, 699.00, 1, '2015-05-09 21:22:54', '2015-05-09 21:22:54'),
(853237000295, 2, 'ANABOL 5 NUTREX 120 CAPS. PRO-HORMON', '120 CAPS', 0.00, 519.00, 1, '2015-05-09 21:22:54', '2015-05-09 21:22:54'),
(853237000325, 2, 'LIPO 6 XTREME', '120 CAPS', 0.00, 489.00, 1, '2015-05-09 21:22:54', '2015-05-09 21:22:54'),
(853237000486, 2, 'LIPO 6 WHITE LABEL 120 LIQUI-CAPS.', '120 LIQUID CAPS ', 0.00, 469.00, 1, '2015-05-09 21:22:54', '2015-05-09 21:22:54'),
(853237000516, 2, 'HEMO RAGE ULTRACONCENTRADO', 'LIMON', 0.00, 459.00, 1, '2015-05-09 21:22:54', '2015-05-09 21:22:54'),
(853237000615, 2, 'BCAAÂ´S DRIVE NUTREX 200 TABS.', '200 TABS', 0.00, 379.00, 1, '2015-05-09 21:22:54', '2015-05-09 21:22:54'),
(853237000707, 2, 'VITRIDEX', '90 CAPS', 0.00, 449.00, 1, '2015-05-09 21:22:54', '2015-05-09 21:22:54'),
(853237000714, 2, 'LIPO 6 ULTRA-CONCENTRADO 60 CAPS.', '60 CAPS', 0.00, 519.00, 1, '2015-05-09 21:22:54', '2015-05-09 21:22:54'),
(853237000721, 2, 'LIPO 6 ULTRA-CONCENTRADO FOR HER 60 C	', '60 CAPS', 0.00, 429.00, 1, '2015-05-09 21:22:54', '2015-05-09 21:22:54'),
(853237000752, 2, 'LIPO 6 UNLIMITED 120 LIQUI-CAPS.', '120 LIQUID', 0.00, 574.00, 1, '2015-05-09 21:22:54', '2015-05-09 21:22:54'),
(853237000806, 2, 'LIPO 6 120 CAPS', 'CAPSULAS', 0.00, 425.00, 1, '2015-05-09 21:22:54', '2015-05-09 21:22:54'),
(853237001193, 2, 'LIPO 6 BLACK 120 CÃPSULAS', '120 CAPS', 0.00, 579.00, 1, '2015-05-09 21:22:54', '2015-05-09 21:22:54'),
(853237001322, 2, 'HEMO RAGE 2 LIBRAS', 'SUCKER PUNCH', 0.00, 599.00, 1, '2015-05-09 21:22:54', '2015-05-09 21:22:54'),
(853237001339, 2, 'HEMO RAGE 2 LIBRAS', 'GASHIN GRAPE', 0.00, 599.00, 1, '2015-05-09 21:22:54', '2015-05-09 21:22:54'),
(853237001377, 2, 'HEMO RAGE ULTRACONCENTRADO', 'NARANJA', 0.00, 459.00, 1, '2015-05-09 21:22:54', '2015-05-09 21:22:54'),
(853237001445, 2, 'HEMO RAGE 2 LIBRAS', 'MELON', 0.00, 599.00, 1, '2015-05-09 21:22:54', '2015-05-09 21:22:54'),
(853237001667, 2, 'MUSCLE INFUSION BLACK 5 LIBRAS', 'CHOCOLATE', 0.00, 759.00, 1, '2015-05-09 21:22:54', '2015-05-09 21:22:54'),
(853237001674, 2, 'MUSCLE INFUSION BLACK 5 LIBRAS', 'VAINIYA', 0.00, 759.00, 1, '2015-05-09 21:22:54', '2015-05-09 21:22:54'),
(853237001681, 2, 'MUSCLE INFUSION BLACK 5 LIBRAS', 'COOKIES', 0.00, 759.00, 1, '2015-05-09 21:22:54', '2015-05-09 21:22:54'),
(853237001803, 2, 'T - UP BLACK 150 CÃ¡PSULAS', 'CAPSULAS', 0.00, 559.00, 1, '2015-05-09 21:22:54', '2015-05-09 21:22:54'),
(856036003122, 2, 'HARDECORE MASS PHASE 12 LIBRAS', 'CHOCOLATE', 0.00, 599.00, 1, '2015-05-09 21:22:54', '2015-05-09 21:22:54'),
(856036003139, 2, 'HARD COREMAS 10 LB', 'VAINILLA', 0.00, 599.00, 1, '2015-05-09 21:22:54', '2015-05-09 21:22:54'),
(856036003146, 2, 'HARD COREMAS 10 LB', 'FRESA', 0.00, 599.00, 1, '2015-05-09 21:22:54', '2015-05-09 21:22:54'),
(857084000569, 2, 'LIPODRENE', 'PASTILLAS', 0.00, 399.00, 1, '2015-05-09 21:22:54', '2015-05-09 21:22:54'),
(857084000576, 2, 'BLACK WIDOW 100 CAPSULAS', 'CAPSULAS', 0.00, 375.00, 1, '2015-05-09 21:22:54', '2015-05-09 21:22:54'),
(857084000583, 2, 'STIMIREX', 'PASTILLAS', 0.00, 375.00, 1, '2015-05-09 21:22:54', '2015-05-09 21:22:54'),
(857084000767, 2, 'DIANABOL HI-TECH 90 CAPS. PROHORMONAL', 'PASTILLAS', 0.00, 649.00, 1, '2015-05-09 21:22:54', '2015-05-09 21:22:54'),
(857084000934, 2, 'REY ESCORPION', 'CAPSULAS', 0.00, 399.00, 1, '2015-05-09 21:22:54', '2015-05-09 21:22:54'),
(857084000935, 2, 'YELLOW SCORPION (EPHEDRA EXTRACT) 90 TABS.', '90 CAPS', 0.00, 399.00, 1, '2015-05-09 21:22:54', '2015-05-09 21:22:54'),
(857487000333, 2, 'BULL NOX 637 GRAMOS BETANCOURT', 'PONCHE DE FRUTAS', 0.00, 519.00, 1, '2015-05-09 21:22:54', '2015-05-09 21:22:54'),
(857487000418, 2, 'BULL NOX 637 GRAMOS BETANCOURT', 'NARANJA', 0.00, 519.00, 1, '2015-05-09 21:22:54', '2015-05-09 21:22:54'),
(857487000630, 2, 'BULL NOX 637 GRAMOS BETANCOURT', 'SANDIA', 0.00, 519.00, 1, '2015-05-09 21:22:54', '2015-05-09 21:22:54'),
(857487000654, 2, 'BULL NOX 637 GRAMOS BETANCOURT', 'BLU BERRI', 0.00, 519.00, 1, '2015-05-09 21:22:54', '2015-05-09 21:22:54'),
(857487000753, 2, 'BIG BLEND PROTEIN BETANCOURT', 'VAINILLA', 0.00, 729.00, 1, '2015-05-09 21:22:54', '2015-05-09 21:22:54'),
(857487000807, 2, 'BULL NOX 637 GRAMOS BETANCOURT', 'UVA', 0.00, 519.00, 1, '2015-05-09 21:22:54', '2015-05-09 21:22:54'),
(857487000975, 2, 'RIPPED JUICE CONCENTRATED LIQUID BETANCOURT', 'PONCHE DEFRUTAS', 0.00, 399.00, 1, '2015-05-09 21:22:54', '2015-05-09 21:22:54'),
(857487003211, 2, 'BIG BLEND PROTEIN BETANCOURT', 'CHOCOLATE', 0.00, 729.00, 1, '2015-05-09 21:22:54', '2015-05-09 21:22:54'),
(857487003273, 2, 'D-STUNNER PRE WORKOUT BETANCOURT', 'PONCHE', 0.00, 379.00, 1, '2015-05-09 21:22:54', '2015-05-09 21:22:54'),
(857487003280, 2, 'CREATINE MICRONIZED 526 GMS BETANCOURT', 'POLVO', 0.00, 189.00, 1, '2015-05-09 21:22:54', '2015-05-09 21:22:54'),
(857487003334, 2, 'GLUTAMINA MICRONIZED 526 GMS BETANCOURT', 'POLVO', 0.00, 434.00, 1, '2015-05-09 21:22:54', '2015-05-09 21:22:54'),
(857487003440, 2, 'D-STUNNER PRE WORKOUT BETANCOURT', 'BLU', 0.00, 379.00, 1, '2015-05-09 21:22:54', '2015-05-09 21:22:54'),
(857487003457, 2, 'D-STUNNER PRE WORKOUT BETANCOURT', 'UVA', 0.00, 379.00, 1, '2015-05-09 21:22:54', '2015-05-09 21:22:54'),
(857487003778, 2, 'D-STUNNER', 'PONCHE DE FRUTAS', 0.00, 379.00, 1, '2015-05-09 21:22:54', '2015-05-09 21:22:54'),
(857487003808, 2, 'D- STUNER', 'SANDIA', 0.00, 379.00, 1, '2015-05-09 21:22:54', '2015-05-09 21:22:54'),
(859163680013, 2, 'SUPERTEINT', 'PEANUT BUTTER', 0.00, 829.00, 1, '2015-05-09 21:22:54', '2015-05-09 21:22:54'),
(859613000071, 2, 'TESTROL 60 TABS GAT PRO-HORMONAL', '60CAPS', 0.00, 399.00, 1, '2015-05-09 21:22:54', '2015-05-09 21:22:54'),
(859613000224, 2, 'BCAA GAT', 'GAT', 0.00, 299.00, 1, '2015-05-09 21:22:54', '2015-05-09 21:22:54'),
(859613000408, 2, 'GLUTAMINA GAT', 'GAT', 0.00, 369.00, 1, '2015-05-09 21:22:54', '2015-05-09 21:22:54'),
(859613244628, 2, 'CHINA WHITE', 'PASTILLAS', 0.00, 409.00, 1, '2015-05-09 21:22:54', '2015-05-09 21:22:54'),
(859613252258, 2, 'BLACK SPIDER 100 CAPSULAS', 'CAPSULAS', 0.00, 409.00, 1, '2015-05-09 21:22:54', '2015-05-09 21:22:54'),
(859613273291, 2, 'CREATINA DE GAT', '1 KL', 0.00, 329.00, 1, '2015-05-09 21:22:54', '2015-05-09 21:22:54'),
(859613274229, 2, 'ASIA BLACK', '100 PASTILLAS', 0.00, 409.00, 1, '2015-05-09 21:22:54', '2015-05-09 21:22:54'),
(859613538321, 2, 'JET MASS 1.38LB', 'TROPICAL ICE', 0.00, 509.00, 1, '2015-05-09 21:22:54', '2015-05-09 21:22:54'),
(859613638472, 2, 'METILDRENE EPH', 'HPH', 0.00, 439.00, 1, '2015-05-09 21:22:54', '2015-05-09 21:22:54'),
(859613638496, 2, 'METHILDRENE  TERMO', 'CAPSULAS', 0.00, 434.00, 1, '2015-05-09 21:22:54', '2015-05-09 21:22:54'),
(859613641007, 2, 'GAT MUSCLE MARTINI 750 GR. 62 SERV.', 'FRESA QUIWI', 0.00, 532.00, 1, '2015-05-09 21:22:54', '2015-05-09 21:22:54'),
(859613641008, 2, 'GAT MUSCLE MARTINI 750 GR. 62 SERV.', 'SANDIA', 0.00, 532.00, 1, '2015-05-09 21:22:54', '2015-05-09 21:22:54'),
(859613641045, 2, 'GAT MUSCLE MARTINI 750 GR. 62 SERV.', 'DURASNO', 0.00, 532.00, 1, '2015-05-09 21:22:54', '2015-05-09 21:22:54'),
(859613641069, 2, 'GAT MUSCLE MARTINI 750 GR. 62 SERV.', 'MANZANA', 0.00, 532.00, 1, '2015-05-09 21:22:54', '2015-05-09 21:22:54'),
(859613641120, 2, 'GAT MUSCLE MARTINI 750 GR. 62 SERV.', 'NARANJA', 0.00, 532.00, 1, '2015-05-09 21:22:54', '2015-05-09 21:22:54'),
(859613647009, 2, 'NITRAFLEX GAT', 'BLUE BERRY', 0.00, 499.00, 1, '2015-05-09 21:22:54', '2015-05-09 21:22:54'),
(859613647047, 2, 'NITRAFLEX GAT', 'NARANJA', 0.00, 499.00, 1, '2015-05-09 21:22:54', '2015-05-09 21:22:54'),
(859613647085, 2, 'NITRAFLEX GAT', 'BLUERAS BERRI', 0.00, 499.00, 1, '2015-05-09 21:22:54', '2015-05-09 21:22:54'),
(859613647122, 2, 'NITRAFLEX GAT', 'PIÃ‘A COLADA', 0.00, 499.00, 1, '2015-05-09 21:22:54', '2015-05-09 21:22:54'),
(859613648723, 2, 'NITRAFLEX GAT', 'OXIDO NITRICO', 0.00, 499.00, 1, '2015-05-09 21:22:54', '2015-05-09 21:22:54'),
(859613648761, 2, 'GAT MUSCLE MARTINI 365 GR. RECOUP', 'SANDIA', 0.00, 399.00, 1, '2015-05-09 21:22:54', '2015-05-09 21:22:54'),
(859613648778, 2, 'GAT MUSCLE MARTINI 365 GR. RECOUP', 'BERRI', 0.00, 399.00, 1, '2015-05-09 21:22:54', '2015-05-09 21:22:54'),
(859613648785, 2, 'GAT MUSCLE MARTINI 365 GR. RECOUP', 'MANGO', 0.00, 399.00, 1, '2015-05-09 21:22:54', '2015-05-09 21:22:54'),
(859613648907, 2, 'NITRAFLEX GAT 300 GR. OXIDO NITRICO', 'PONCHE DE FRUTAS', 0.00, 499.00, 1, '2015-05-09 21:22:54', '2015-05-09 21:22:54'),
(859613648914, 2, 'NITRAFLEX GAT 300 GR. OXIDO NITRICO', 'SANDIA', 0.00, 499.00, 1, '2015-05-09 21:22:54', '2015-05-09 21:22:54'),
(859613648990, 2, 'SUPERTEIN 5 LIBRAS', 'CHOCOLATE', 0.00, 829.00, 1, '2015-05-09 21:22:54', '2015-05-09 21:22:54'),
(859613649072, 2, 'NITRAFLEX GAT 300 GR. OXIDO NITRICO', 'PIÃ‘A', 0.00, 499.00, 1, '2015-05-09 21:22:54', '2015-05-09 21:22:54');
INSERT INTO `productos` (`id_producto`, `id_categoria_de_producto`, `nombre_producto`, `descripcion`, `precio_compra`, `precio_cliente_frecuente`, `habilitado`, `created_at`, `updated_at`) VALUES
(859613777775, 2, 'TESTAGEN GAT 120 TABSPRO-HORMONAL', '120 TABS', 0.00, 399.00, 1, '2015-05-09 21:22:54', '2015-05-09 21:22:54'),
(859613777829, 2, 'JETFUSE NOX 2.35 LB', 'BLUE RAS PERRI', 0.00, 509.00, 1, '2015-05-09 21:22:54', '2015-05-09 21:22:54'),
(891597002306, 2, 'METHYL ARIMATEST 180 TABLETAS', 'CAJA', 0.00, 739.00, 1, '2015-05-09 21:22:54', '2015-05-09 21:22:54'),
(891597002542, 2, 'CARNIVOR 4 LIBRAS', 'CHOCOLATE', 0.00, 834.00, 1, '2015-05-09 21:22:54', '2015-05-09 21:22:54'),
(891597002634, 2, 'CARNIVOR 4 LIBRAS', 'VAINILLA', 0.00, 834.00, 1, '2015-05-09 21:22:54', '2015-05-09 21:22:54'),
(891597002641, 2, 'CARNIVOR MASS 6 LIBRAS (GANADOR)', 'CHOCOLATE ', 0.00, 799.00, 1, '2015-05-09 21:22:54', '2015-05-09 21:22:54'),
(891597002658, 2, 'CARNIVOR MASS 6 LIBRAS (GANADOR)', 'CARAMELO ', 0.00, 799.00, 1, '2015-05-09 21:22:54', '2015-05-09 21:22:54'),
(891597002672, 2, 'CARNIVOR CARAMELO', 'CARAMELO', 0.00, 819.00, 1, '2015-05-09 21:22:54', '2015-05-09 21:22:54'),
(891597002849, 2, 'NO-BULL SUPER CONCENTRATED 200 GR.89159700283', 'LIMON', 0.00, 564.00, 1, '2015-05-09 21:22:54', '2015-05-09 21:22:54'),
(891597003549, 2, 'BARRAS DE CARNIVOR ', 'BARRAS', 0.00, 40.00, 1, '2015-05-09 21:22:54', '2015-05-09 21:22:54'),
(891597003663, 2, 'CARNIVOR 8 LIBRAS', 'CHOCOLATE', 0.00, 1399.00, 1, '2015-05-09 21:22:54', '2015-05-09 21:22:54'),
(891597003679, 2, 'CARNIVOR MASS 10 LIBRAS (GANADOR)', 'CHOCOLATE ', 0.00, 1159.00, 1, '2015-05-09 21:22:54', '2015-05-09 21:22:54'),
(891597003747, 2, 'CARNIVOR MASS 10 LIBRAS (GANADOR)', 'VAINILLA CARAMELO', 0.00, 1159.00, 1, '2015-05-09 21:22:54', '2015-05-09 21:22:54'),
(891597003754, 2, 'CARNIVOR 8 LIBRAS', 'VAINILLA', 0.00, 1399.00, 1, '2015-05-09 21:22:54', '2015-05-09 21:22:54'),
(893912123512, 2, 'NECTAR 2 LB', 'CEREZA', 0.00, 619.00, 1, '2015-05-09 21:22:54', '2015-05-09 21:22:54'),
(893912123567, 2, 'GLU FM 500 GR.', 'POLVO', 0.00, 365.00, 1, '2015-05-09 21:22:54', '2015-05-09 21:22:54'),
(893912123871, 2, 'NECTAR 2 LB ', 'CAPUCHINO', 0.00, 619.00, 1, '2015-05-09 21:22:54', '2015-05-09 21:22:54'),
(893912123963, 2, 'NECTAR 2 LB ', 'VAINILLA', 0.00, 619.00, 1, '2015-05-09 21:22:54', '2015-05-09 21:22:54'),
(893912123970, 2, 'NECTAR 2 LB ', 'CHOCOLATE', 0.00, 619.00, 1, '2015-05-09 21:22:54', '2015-05-09 21:22:54'),
(893912124205, 2, 'SOBRE NECTAR', 'CAPUCHINO', 0.00, 30.00, 1, '2015-05-09 21:22:54', '2015-05-09 21:22:54'),
(893912124206, 2, 'SOBRES NECTAR', 'SOBRES', 0.00, 30.00, 1, '2015-05-09 21:22:54', '2015-05-09 21:22:54'),
(893912124236, 2, 'NÃ‰CTAR MEDICAL 1 LB UNFLAVORED', 'MEDICAL 1 LB', 0.00, 329.00, 1, '2015-05-09 21:22:54', '2015-05-09 21:22:54'),
(893912124397, 2, 'NECTAR 2 LB', 'MUS DE FRESA', 0.00, 619.00, 1, '2015-05-09 21:22:54', '2015-05-09 21:22:54'),
(893912124526, 2, 'SOBRES GRABN GO ', 'MUS DE FRESA', 0.00, 369.00, 1, '2015-05-09 21:22:54', '2015-05-09 21:22:54'),
(893912124793, 2, 'SOBRES NECTAR GRABN GO', 'MANZANA 12 PIEZAS', 0.00, 374.00, 1, '2015-05-09 21:22:54', '2015-05-09 21:22:54'),
(893912124861, 2, 'SOBRES NECTAR GRABN GO', 'FRESA 12 PIEZAS', 0.00, 374.00, 1, '2015-05-09 21:22:54', '2015-05-09 21:22:54'),
(893912124885, 2, 'SOBRES NÃ‰CTAR GRAB & GO 12 PZAS', 'CAPUCHINO', 0.00, 369.00, 1, '2015-05-09 21:22:54', '2015-05-09 21:22:54'),
(893912124892, 2, 'SOBRS NECTAR GRABN GO', 'CHOCOLATE 12 PIEZAS', 0.00, 374.00, 1, '2015-05-09 21:22:54', '2015-05-09 21:22:54'),
(893912124915, 2, 'SOBRES NECTAR GRABN GO', 'VAINILLA 12 PIEZAS', 0.00, 374.00, 1, '2015-05-09 21:22:54', '2015-05-09 21:22:54'),
(1838593595024, 2, 'ANIMAL GAINER 12 LIBRAS', 'VAINILLA', 0.00, 699.00, 1, '2015-05-09 21:22:54', '2015-05-09 21:22:54'),
(1838593595025, 2, 'ANIMAL GAINER 12 LIBRAS', 'MOCA', 0.00, 699.00, 1, '2015-05-09 21:22:54', '2015-05-09 21:22:54'),
(1838593595026, 2, 'ANIMAL GAINER 12 LIBRAS', 'CHOCOLATE', 0.00, 699.00, 1, '2015-05-09 21:22:54', '2015-05-09 21:22:54'),
(4588759366178, 2, 'NORDITROPIN HORMONA DE CREC. 40 U.I.', '40 UI', 0.00, 611.15, 1, '2015-05-09 21:22:54', '2015-05-09 21:22:54'),
(4589058901232, 2, 'TITAN GAINER 8 LIBRAS', 'VAINILLA', 0.00, 579.00, 1, '2015-05-09 21:22:54', '2015-05-09 21:22:54'),
(4589058901249, 2, 'TITAN GAINER 8 LIBRAS', 'FRESA', 0.00, 579.00, 1, '2015-05-09 21:22:54', '2015-05-09 21:22:54'),
(4589058901256, 2, 'TITAN GAINER 8 LIBRAS', 'CHOCOLATE ', 0.00, 579.00, 1, '2015-05-09 21:22:54', '2015-05-09 21:22:54'),
(5458722923799, 2, 'DYNATROPE H.C. DE 36 UNIDADES', 'HC  36 UNIDADES', 0.00, 999.00, 1, '2015-05-09 21:22:54', '2015-05-09 21:22:54'),
(5783920138903, 2, 'GLUTAMINA 500 GRAMOS HUMAN', 'HUMAN', 0.00, 389.00, 1, '2015-05-09 21:22:54', '2015-05-09 21:22:54'),
(7501055304721, 2, 'CIEL AGUA 1 1/2', 'LITRO  Y MEDIO', 0.00, 15.00, 1, '2015-05-09 21:22:54', '2015-05-09 21:22:54'),
(7501055308675, 2, 'CIEL AGUA', 'CIEL 1 LT', 0.00, 10.00, 1, '2015-05-09 21:22:54', '2015-05-09 21:22:54'),
(7501055309665, 2, 'COCA COLA', '250GR', 0.00, 10.00, 1, '2015-05-09 21:22:54', '2015-05-09 21:22:54'),
(7501055319053, 2, 'CIEL AGUA 1 LITRO SABOR', 'MANDARINA', 0.00, 15.00, 1, '2015-05-09 21:22:54', '2015-05-09 21:22:54'),
(7501055329267, 2, 'POWERADE', 'MORA ', 0.00, 0.00, 1, '2015-05-09 21:22:54', '2015-05-09 21:22:54'),
(7501055329298, 2, 'POWERADE', 'PONCHE DE FRUTAS', 0.00, 19.00, 1, '2015-05-09 21:22:54', '2015-05-09 21:22:54'),
(7501055342716, 1, 'JUGO VALLE', 'GUAYABA', 0.00, 10.00, 1, '2015-05-09 21:22:54', '2015-05-09 21:22:54'),
(7501125133343, 2, 'XERENDIP HC ', 'HC 4 UI', 0.00, 199.00, 1, '2015-05-09 21:22:54', '2015-05-09 21:22:54'),
(7501166515603, 2, 'TOPER CENDECAR', 'TOPER', 0.00, 54.90, 1, '2015-05-09 21:22:54', '2015-05-09 21:22:54'),
(7501250835167, 2, 'YELIT HC', 'HC 4UI', 0.00, 279.00, 1, '2015-05-09 21:22:54', '2015-05-09 21:22:54'),
(7501639304772, 2, 'ALIMENTO DE SOYA 236 ML', 'DURASNO', 0.00, 9.90, 1, '2015-05-09 21:22:54', '2015-05-09 21:22:54'),
(7501639305700, 2, 'ALIMENTO DE SOYA 236 ML', 'FRESA', 0.00, 9.90, 1, '2015-05-09 21:22:54', '2015-05-09 21:22:54'),
(7501639306059, 2, 'HUMAN EXCELLENT WHEY PROTEIN 5 LBS', 'CHOCOLATE', 0.00, 829.00, 1, '2015-05-09 21:22:54', '2015-05-09 21:22:54'),
(7501639306066, 2, 'HUMAN EXCELLENT WHEY PROTEIN', 'VAINILLA', 0.00, 829.00, 1, '2015-05-09 21:22:54', '2015-05-09 21:22:54'),
(7502042201009, 2, 'PASTA SPORTIVO', 'PASTA  ALTA EN PROTEINA', 0.00, 75.00, 1, '2015-05-09 21:22:54', '2015-05-09 21:22:54'),
(7502042201016, 2, 'ARROZ VAPORIZADO SPORTIVO 2 KILOS', '2 KILOS', 0.00, 89.00, 1, '2015-05-09 21:22:54', '2015-05-09 21:22:54'),
(7502042201026, 2, 'HARINA PARA HOT CAKES SPORTIVO 2 KG.', 'HARINA PARA HOT KAKES 2 KLOS', 0.00, 121.00, 1, '2015-05-09 21:22:54', '2015-05-09 21:22:54'),
(7502042201047, 2, 'AVENA SPORTIVO 1.5 KILOS', '1.5  AVENA', 0.00, 85.00, 1, '2015-05-09 21:22:54', '2015-05-09 21:22:54'),
(7502213141172, 2, 'PROTOPHIN 4 UNIDADES H.C.', '4 UI', 0.00, 219.00, 1, '2015-05-09 21:22:54', '2015-05-09 21:22:54'),
(7502213141173, 2, 'PROTOPHIN 16 UNIDADES H.C.', '16 UI', 0.00, 649.00, 1, '2015-05-09 21:22:54', '2015-05-09 21:22:54'),
(7503005387137, 2, 'RED INFERNUS', 'CAPS', 0.00, 359.00, 1, '2015-05-09 21:22:54', '2015-05-09 21:22:54'),
(7503013595448, 2, 'FORZAWHEY 5 LIBRAS WHEY PROTEIN', 'CHOCOLATE', 0.00, 849.00, 1, '2015-05-09 21:22:54', '2015-05-09 21:22:54'),
(7503016015004, 2, 'BARRINOLA', 'NUEZ', 0.00, 7.00, 1, '2015-05-09 21:22:54', '2015-05-09 21:22:54'),
(7503016015028, 2, 'BARRINOLA ', 'CHOCOLATE', 0.00, 7.00, 1, '2015-05-09 21:22:54', '2015-05-09 21:22:54'),
(7503016015035, 2, 'BARRINOLA ', 'CAFE', 5.00, 7.00, 1, '2015-05-09 21:22:54', '2015-05-09 21:22:54'),
(7503016015042, 2, 'BARRINOLA', 'ARANDANO', 0.00, 7.00, 1, '2015-05-09 21:22:54', '2015-05-09 21:22:54'),
(7503016015189, 2, 'BARRINOLA', 'MIEL DE AGAVE', 0.00, 7.00, 1, '2015-05-09 21:22:54', '2015-05-09 21:22:54'),
(7504008531106, 2, ' WHEY PROTEIN 4.4 LIBRAS', 'FRESA', 0.00, 649.00, 1, '2015-05-09 21:22:54', '2015-05-09 21:22:54'),
(7504008531107, 2, ' WHEY PROTEIN 4.4 LIBRAS', 'VAINILLA', 0.00, 649.00, 1, '2015-05-09 21:22:54', '2015-05-09 21:22:54'),
(8557487003310, 2, 'BCAAÂ´S 2:1:1 RATIO 300 CAPS. BETANCOURT', 'TABLETAS', 0.00, 339.00, 1, '2015-05-09 21:22:54', '2015-05-09 21:22:54'),
(8852086710005, 2, 'ANABOL 1000 TABS (DIANABOL)', '1000 TABLETAS', 0.00, 2900.00, 1, '2015-05-09 21:22:54', '2015-05-09 21:22:54'),
(8852086710006, 2, 'ANABOL (DIANABOL) POR TABLETA', 'TABLETAS SUELTAS', 0.00, 5.00, 1, '2015-05-09 21:22:54', '2015-05-09 21:22:54'),
(9133756416279, 2, 'DYNALAN - R3 FACTOR DE CRECIMIENTO', 'FACTOR DE CRECIMIENTO', 0.00, 999.90, 1, '2015-05-09 21:22:54', '2015-05-09 21:22:54');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `proveedores`
--

CREATE TABLE IF NOT EXISTS `proveedores` (
  `id_proveedor` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `nombre` varchar(50) COLLATE utf8_spanish2_ci NOT NULL,
  `direccion` varchar(100) COLLATE utf8_spanish2_ci NOT NULL,
  `rfc` varchar(13) COLLATE utf8_spanish2_ci NOT NULL,
  `telefono` varchar(15) COLLATE utf8_spanish2_ci NOT NULL,
  `email` varchar(45) COLLATE utf8_spanish2_ci DEFAULT NULL,
  `pagina_web` varchar(100) COLLATE utf8_spanish2_ci DEFAULT NULL,
  `habilitado` tinyint(1) NOT NULL DEFAULT '1',
  `created_at` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00',
  `updated_at` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00',
  PRIMARY KEY (`id_proveedor`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COLLATE=utf8_spanish2_ci AUTO_INCREMENT=6 ;

--
-- Volcado de datos para la tabla `proveedores`
--

INSERT INTO `proveedores` (`id_proveedor`, `nombre`, `direccion`, `rfc`, `telefono`, `email`, `pagina_web`, `habilitado`, `created_at`, `updated_at`) VALUES
(1, 'Compra directa', 'compra directa', '123456789', '123456789', 'compradirecta@compradirecta.com', NULL, 1, '2015-05-09 21:22:30', '2015-05-09 21:22:30'),
(2, 'Genesis', 'Hidalgo 895', '0987654321123', '1231231231', 'gen@hola.com', NULL, 1, '2015-05-09 21:22:30', '2015-05-09 21:22:30'),
(3, 'GNC', 'Mexico 86', '12345', '5654441234', 'gnc@gnc.com', NULL, 1, '2015-05-09 21:22:30', '2015-05-09 21:22:30'),
(4, 'VPX', 'Morelos 656', '12345', '5560441234', 'vpx@hola.com', NULL, 1, '2015-05-09 21:22:30', '2015-05-09 21:22:30'),
(5, 'Muscle', 'Universidad 1246', '1234567890123', '5560441234', 'muscle@hola.com', NULL, 1, '2015-05-09 21:22:30', '2015-05-09 21:22:30');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `reglas_del_negocio`
--

CREATE TABLE IF NOT EXISTS `reglas_del_negocio` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `regla` varchar(100) COLLATE utf8_spanish2_ci NOT NULL,
  `minimo` decimal(12,2) NOT NULL,
  `maximo` decimal(12,2) NOT NULL,
  `descuento` decimal(4,2) NOT NULL,
  `descripcion` text COLLATE utf8_spanish2_ci NOT NULL,
  `habilitado` tinyint(1) NOT NULL DEFAULT '1',
  `created_at` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00',
  `updated_at` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COLLATE=utf8_spanish2_ci AUTO_INCREMENT=13 ;

--
-- Volcado de datos para la tabla `reglas_del_negocio`
--

INSERT INTO `reglas_del_negocio` (`id`, `regla`, `minimo`, `maximo`, `descuento`, `descripcion`, `habilitado`, `created_at`, `updated_at`) VALUES
(1, 'frecuente', 1.00, 1000.00, 1.00, 'En la compra de 2 o mas productos\n                        y hasta $1000 aplica precio de cliente frecuente', 1, '2015-05-09 21:22:30', '2015-05-09 21:22:30'),
(2, 'publico', 1.00, 1.00, 1.05, 'En la compra de 1 solo producto\n                        aplica precio publico, %5 mas del precio de\n                        cliente frecuente', 1, '2015-05-09 21:22:30', '2015-05-09 21:22:30'),
(3, 'distribuidor', 1001.00, 5000.00, 0.95, 'En la compra de $1000 a $5000 \n                        aplica precio distribuidor, %5 de descuento', 1, '2015-05-09 21:22:30', '2015-05-09 21:22:30'),
(4, 'mayorista1', 5001.00, 10000.00, 0.92, 'En la compra de $5000 a $10000 \n                        aplica precio mayorista1, %8 de descuento', 1, '2015-05-09 21:22:30', '2015-05-09 21:22:30'),
(5, 'mayorista2', 10001.00, 100000.00, 0.85, 'En la compra de $10000 a $100000 \n                        aplica precio mayorista2, %15 de descuento', 1, '2015-05-09 21:22:30', '2015-05-09 21:22:30'),
(6, 'mayorista3', 100001.00, 9999999999.00, 0.81, 'En la compra de mas de $100000 \n                        aplica precio mayorista3, %19.25 de descuento', 1, '2015-05-09 21:22:30', '2015-05-09 21:22:30'),
(7, 'frecuente fitness', 2.00, 9.00, 0.90, 'De 2 a 9 piezas en los productos \n                         fitness se hace un 10% de descuento', 1, '2015-05-09 21:22:30', '2015-05-09 21:22:30'),
(8, 'publico fitness', 1.00, 1.00, 1.00, '1 pieza en los productos \n                         fitness no se hace descuento', 1, '2015-05-09 21:22:30', '2015-05-09 21:22:30'),
(9, 'distribuidor fitness', 10.00, 19.00, 0.85, 'De 10 a 19 piezas en los productos \n                         fitness se hace un 15% de descuento', 1, '2015-05-09 21:22:30', '2015-05-09 21:22:30'),
(10, 'mayorista1 fitness', 20.00, 29.00, 0.80, 'De 20 a 29 piezas en los productos \n                         fitness se hace un 20% de descuento', 1, '2015-05-09 21:22:30', '2015-05-09 21:22:30'),
(11, 'mayorista2 fitness', 30.00, 50.00, 0.70, 'De 30 a 50 piezas en los productos \n                         fitness se hace un 30% de descuento', 1, '2015-05-09 21:22:30', '2015-05-09 21:22:30'),
(12, 'mayorista3 fitness', 50.00, 9999999999.00, 0.60, 'Mas de 50 piezas en los productos \n                         fitness se hace un 40% de descuento', 1, '2015-05-09 21:22:30', '2015-05-09 21:22:30');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `sucursales`
--

CREATE TABLE IF NOT EXISTS `sucursales` (
  `id_sucursal` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `nombre_sucursal` varchar(50) COLLATE utf8_spanish2_ci NOT NULL,
  `direccion` varchar(100) COLLATE utf8_spanish2_ci NOT NULL,
  `telefono` varchar(10) COLLATE utf8_spanish2_ci NOT NULL,
  `email` varchar(45) COLLATE utf8_spanish2_ci NOT NULL,
  `habilitado` tinyint(1) NOT NULL DEFAULT '1',
  `created_at` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00',
  `updated_at` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00',
  PRIMARY KEY (`id_sucursal`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COLLATE=utf8_spanish2_ci AUTO_INCREMENT=4 ;

--
-- Volcado de datos para la tabla `sucursales`
--

INSERT INTO `sucursales` (`id_sucursal`, `nombre_sucursal`, `direccion`, `telefono`, `email`, `habilitado`, `created_at`, `updated_at`) VALUES
(1, 'Copilco', 'Hidalgo 895', '1231231231', 'gen@hola.com', 1, '2015-05-09 21:22:30', '2015-05-09 21:22:30'),
(2, 'Ajusco', 'Mexico 86', '5654441234', 'dsa@hola.com', 1, '2015-05-09 21:22:30', '2015-05-09 21:22:30'),
(3, 'Del Valle', 'Morelos 656', '5560441234', 'asd@hola.com', 1, '2015-05-09 21:22:30', '2015-05-09 21:22:30');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `sucursales_productos`
--

CREATE TABLE IF NOT EXISTS `sucursales_productos` (
  `id_sucursales_productos` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `id_sucursal` int(10) unsigned NOT NULL,
  `id_producto` bigint(20) unsigned NOT NULL,
  `cantidad` smallint(6) NOT NULL,
  `stock` tinyint(4) NOT NULL,
  `habilitado` tinyint(1) NOT NULL DEFAULT '1',
  `created_at` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00',
  `updated_at` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00',
  PRIMARY KEY (`id_sucursales_productos`),
  KEY `sucursales_productos_id_sucursal_foreign` (`id_sucursal`),
  KEY `sucursales_productos_id_producto_foreign` (`id_producto`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COLLATE=utf8_spanish2_ci AUTO_INCREMENT=39133756416280 ;

--
-- Volcado de datos para la tabla `sucursales_productos`
--

INSERT INTO `sucursales_productos` (`id_sucursales_productos`, `id_sucursal`, `id_producto`, `cantidad`, `stock`, `habilitado`, `created_at`, `updated_at`) VALUES
(1001, 1, 1, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(1002, 1, 2, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(1003, 1, 3, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(1005, 1, 5, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(1007, 1, 7, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(1008, 1, 8, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(1009, 1, 9, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(1123, 1, 123, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(1741, 1, 741, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(1852, 1, 852, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(1963, 1, 963, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(2001, 2, 1, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(2002, 2, 2, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(2003, 2, 3, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(2005, 2, 5, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(2007, 2, 7, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(2008, 2, 8, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(2009, 2, 9, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(2123, 2, 123, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(2741, 2, 741, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(2852, 2, 852, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(2963, 2, 963, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(3001, 3, 1, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(3002, 3, 2, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(3003, 3, 3, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(3005, 3, 5, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(3007, 3, 7, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(3008, 3, 8, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(3009, 3, 9, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(3123, 3, 123, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(3741, 3, 741, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(3852, 3, 852, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(3963, 3, 963, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(10010, 1, 10, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(10011, 1, 11, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(10012, 1, 12, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(10013, 1, 13, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(10016, 1, 16, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(10022, 1, 22, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(10030, 1, 30, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(10031, 1, 31, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(10032, 1, 32, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(10033, 1, 33, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(10034, 1, 34, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(10035, 1, 35, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(10036, 1, 36, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(10050, 1, 50, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(10051, 1, 51, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(10052, 1, 52, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(10053, 1, 53, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(10054, 1, 54, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(10055, 1, 55, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(10056, 1, 56, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(10057, 1, 57, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(10058, 1, 58, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(10059, 1, 59, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(10516, 1, 516, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(14127, 1, 4127, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(19654, 1, 9654, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(20010, 2, 10, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(20011, 2, 11, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(20012, 2, 12, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(20013, 2, 13, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(20016, 2, 16, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(20022, 2, 22, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(20030, 2, 30, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(20031, 2, 31, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(20032, 2, 32, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(20033, 2, 33, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(20034, 2, 34, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(20035, 2, 35, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(20036, 2, 36, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(20050, 2, 50, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(20051, 2, 51, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(20052, 2, 52, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(20053, 2, 53, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(20054, 2, 54, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(20055, 2, 55, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(20056, 2, 56, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(20057, 2, 57, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(20058, 2, 58, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(20059, 2, 59, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(20516, 2, 516, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(24127, 2, 4127, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(29654, 2, 9654, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(30010, 3, 10, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(30011, 3, 11, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(30012, 3, 12, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(30013, 3, 13, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(30016, 3, 16, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(30022, 3, 22, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(30030, 3, 30, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(30031, 3, 31, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(30032, 3, 32, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(30033, 3, 33, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(30034, 3, 34, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(30035, 3, 35, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(30036, 3, 36, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(30050, 3, 50, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(30051, 3, 51, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(30052, 3, 52, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(30053, 3, 53, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(30054, 3, 54, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(30055, 3, 55, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(30056, 3, 56, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(30057, 3, 57, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(30058, 3, 58, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(30059, 3, 59, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(30516, 3, 516, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(34127, 3, 4127, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(39654, 3, 9654, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(100100, 1, 100, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(100101, 1, 101, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(100102, 1, 102, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(100104, 1, 104, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(100105, 1, 105, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(100106, 1, 106, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(100107, 1, 107, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(100108, 1, 108, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(100114, 1, 114, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(100145, 1, 145, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(100150, 1, 150, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(100151, 1, 151, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(100152, 1, 152, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(100153, 1, 153, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(100154, 1, 154, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(100155, 1, 155, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(100200, 1, 200, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(110001, 1, 10001, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(118208, 1, 18208, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(122010, 1, 22010, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(125922, 1, 25922, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(174123, 1, 74123, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(196321, 1, 96321, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(200100, 2, 100, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(200101, 2, 101, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(200102, 2, 102, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(200104, 2, 104, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(200105, 2, 105, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(200106, 2, 106, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(200107, 2, 107, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(200108, 2, 108, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(200114, 2, 114, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(200145, 2, 145, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(200150, 2, 150, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(200151, 2, 151, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(200152, 2, 152, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(200153, 2, 153, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(200154, 2, 154, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(200155, 2, 155, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(200200, 2, 200, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(210001, 2, 10001, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(218208, 2, 18208, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(222010, 2, 22010, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(225922, 2, 25922, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(274123, 2, 74123, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(296321, 2, 96321, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(300100, 3, 100, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(300101, 3, 101, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(300102, 3, 102, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(300104, 3, 104, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(300105, 3, 105, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(300106, 3, 106, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(300107, 3, 107, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(300108, 3, 108, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(300114, 3, 114, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(300145, 3, 145, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(300150, 3, 150, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(300151, 3, 151, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(300152, 3, 152, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(300153, 3, 153, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(300154, 3, 154, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(300155, 3, 155, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(300200, 3, 200, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(310001, 3, 10001, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(318208, 3, 18208, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(322010, 3, 22010, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(325922, 3, 25922, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(374123, 3, 74123, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(396321, 3, 96321, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(1001000, 1, 1000, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(1001001, 1, 1001, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(1001002, 1, 1002, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(1001003, 1, 1003, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(1001004, 1, 1004, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(1001005, 1, 1005, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(1001006, 1, 1006, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(1001010, 1, 1010, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(1001020, 1, 1020, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(1002000, 1, 2000, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(1005058, 1, 5058, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(1852369, 1, 852369, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(2001000, 2, 1000, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(2001001, 2, 1001, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(2001002, 2, 1002, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(2001003, 2, 1003, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(2001004, 2, 1004, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(2001005, 2, 1005, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(2001006, 2, 1006, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(2001010, 2, 1010, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(2001020, 2, 1020, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(2002000, 2, 2000, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(2005058, 2, 5058, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(2852369, 2, 852369, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(3001000, 3, 1000, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(3001001, 3, 1001, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(3001002, 3, 1002, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(3001003, 3, 1003, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(3001004, 3, 1004, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(3001005, 3, 1005, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(3001006, 3, 1006, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(3001010, 3, 1010, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(3001020, 3, 1020, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(3002000, 3, 2000, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(3005058, 3, 5058, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(3852369, 3, 852369, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(10010002, 1, 10002, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(10010004, 1, 10004, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(10010005, 1, 10005, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(10010006, 1, 10006, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(10010007, 1, 10007, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(12154879, 1, 2154879, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(17456321, 1, 7456321, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(18794563, 1, 8794563, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(20010002, 2, 10002, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(20010004, 2, 10004, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(20010005, 2, 10005, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(20010006, 2, 10006, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(20010007, 2, 10007, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(22154879, 2, 2154879, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(27456321, 2, 7456321, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(28794563, 2, 8794563, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(30010002, 3, 10002, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(30010004, 3, 10004, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(30010005, 3, 10005, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(30010006, 3, 10006, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(30010007, 3, 10007, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(32154879, 3, 2154879, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(37456321, 3, 7456321, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(38794563, 3, 8794563, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(101523564, 1, 1523564, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(111102389, 1, 11102389, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(111102594, 1, 11102594, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(121547896, 1, 21547896, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(189537458, 1, 89537458, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(201523564, 2, 1523564, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(211102389, 2, 11102389, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(211102594, 2, 11102594, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(221547896, 2, 21547896, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(289537458, 2, 89537458, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(301523564, 3, 1523564, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(311102389, 3, 11102389, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(311102594, 3, 11102594, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(321547896, 3, 21547896, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(389537458, 3, 89537458, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(11077912001, 1, 1077912001, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(12793306532, 1, 2793306532, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(15487987956, 1, 5487987956, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(21077912001, 2, 1077912001, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(22793306532, 2, 2793306532, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(25487987956, 2, 5487987956, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(31077912001, 3, 1077912001, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(32793306532, 3, 2793306532, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(35487987956, 3, 5487987956, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(168733994101, 1, 68733994101, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(268733994101, 2, 68733994101, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(368733994101, 3, 68733994101, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(1000751140109, 1, 751140109, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(1000751140208, 1, 751140208, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(1000751140307, 1, 751140307, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(1001245879358, 1, 1245879358, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(1013602004390, 1, 13602004390, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(1023991184719, 1, 23991184719, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(1039442030115, 1, 39442030115, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(1039442030283, 1, 39442030283, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(1039442030320, 1, 39442030320, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(1039442030542, 1, 39442030542, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(1085351004228, 1, 85351004228, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(1085351004303, 1, 85351004303, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(1089094021153, 1, 89094021153, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(1089094021177, 1, 89094021177, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(1089094021191, 1, 89094021191, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(1089094021511, 1, 89094021511, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(1089094021559, 1, 89094021559, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(1089094021573, 1, 89094021573, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(1089094021894, 1, 89094021894, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(1089094021931, 1, 89094021931, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(1089094021955, 1, 89094021955, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(1089094021979, 1, 89094021979, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(1089094022273, 1, 89094022273, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(1094922163073, 1, 94922163073, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(1094922368942, 1, 94922368942, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(1120492048714, 1, 120492048714, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(1610764010032, 1, 610764010032, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(1610764010131, 1, 610764010131, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(1610764010186, 1, 610764010186, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(1610764010339, 1, 610764010339, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(1610764180070, 1, 610764180070, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(1610764381484, 1, 610764381484, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(1610764711960, 1, 610764711960, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(1610764732613, 1, 610764732613, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(1610764732743, 1, 610764732743, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(1610764732767, 1, 610764732767, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(1610764733009, 1, 610764733009, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(1610764733054, 1, 610764733054, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(1610764733146, 1, 610764733146, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(1610764824868, 1, 610764824868, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(1610764825087, 1, 610764825087, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(1610764825100, 1, 610764825100, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(1610764825124, 1, 610764825124, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(1610764825278, 1, 610764825278, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(1610764830555, 1, 610764830555, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(1610764840226, 1, 610764840226, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(1610764840486, 1, 610764840486, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(1610764860323, 1, 610764860323, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(1610764860347, 1, 610764860347, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(1610764860514, 1, 610764860514, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(1610764860729, 1, 610764860729, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(1610764860743, 1, 610764860743, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(1627933065304, 1, 627933065304, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(1627933065311, 1, 627933065311, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(1631656602692, 1, 631656602692, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(1631656603330, 1, 631656603330, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(1631656603361, 1, 631656603361, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(1631656604504, 1, 631656604504, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(1631656604740, 1, 631656604740, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(1631656623154, 1, 631656623154, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(1631656703122, 1, 631656703122, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(1631656703146, 1, 631656703146, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(1631656703160, 1, 631656703160, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(1631656703214, 1, 631656703214, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(1631656703283, 1, 631656703283, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(1631656703290, 1, 631656703290, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(1631656703306, 1, 631656703306, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(1631656703313, 1, 631656703313, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(1631656703412, 1, 631656703412, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(1631656703528, 1, 631656703528, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(1631656703535, 1, 631656703535, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(1631656703542, 1, 631656703542, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(1632964301055, 1, 632964301055, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(1632964301123, 1, 632964301123, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(1632964301130, 1, 632964301130, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(1632964301147, 1, 632964301147, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(1632964301154, 1, 632964301154, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(1632964301536, 1, 632964301536, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(1632964302304, 1, 632964302304, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(1632964302434, 1, 632964302434, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(1646511005112, 1, 646511005112, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(1646511005211, 1, 646511005211, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(1646511005235, 1, 646511005235, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(1646511005242, 1, 646511005242, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(1646511006560, 1, 646511006560, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(1646511007000, 1, 646511007000, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(1646511007222, 1, 646511007222, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(1646511007239, 1, 646511007239, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(1646511007277, 1, 646511007277, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(1646511007284, 1, 646511007284, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(1646511008403, 1, 646511008403, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(1646511008410, 1, 646511008410, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(1646511008434, 1, 646511008434, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(1646511009165, 1, 646511009165, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(1646511009172, 1, 646511009172, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(1646511016019, 1, 646511016019, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(1646511016026, 1, 646511016026, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(1646511016033, 1, 646511016033, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(1646511020252, 1, 646511020252, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(1646511020269, 1, 646511020269, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(1646511020276, 1, 646511020276, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(1646511020283, 1, 646511020283, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(1646511021112, 1, 646511021112, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(1646511021129, 1, 646511021129, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(1646511021174, 1, 646511021174, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(1646511021181, 1, 646511021181, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(1646511022058, 1, 646511022058, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(1646511022157, 1, 646511022157, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(1646511022188, 1, 646511022188, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(1652908000011, 1, 652908000011, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(1652908000028, 1, 652908000028, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(1652908000066, 1, 652908000066, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(1652908000073, 1, 652908000073, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(1652908660062, 1, 652908660062, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(1652908670061, 1, 652908670061, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(1652908680060, 1, 652908680060, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(1666222091273, 1, 666222091273, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(1666222091587, 1, 666222091587, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(1666222091594, 1, 666222091594, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(1666222731032, 1, 666222731032, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(1666222731100, 1, 666222731100, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(1666222732107, 1, 666222732107, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(1672898126003, 1, 672898126003, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(1672898440055, 1, 672898440055, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(1672898440062, 1, 672898440062, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(1687339941015, 1, 687339941015, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(1687339981004, 1, 687339981004, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(1687339981011, 1, 687339981011, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(1687339981110, 1, 687339981110, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(1687339981127, 1, 687339981127, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(1687339984012, 1, 687339984012, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(1687339984029, 1, 687339984029, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(1696859258374, 1, 696859258374, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(1696859258459, 1, 696859258459, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(1696859258466, 1, 696859258466, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(1696859258527, 1, 696859258527, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(1696859258534, 1, 696859258534, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(1696859258601, 1, 696859258601, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(1696859258602, 1, 696859258602, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(1696859261176, 1, 696859261176, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(1696859261718, 1, 696859261718, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(1705016103027, 1, 705016103027, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(1705016110001, 1, 705016110001, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(1705016205004, 1, 705016205004, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(1705016210008, 1, 705016210008, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(1705016260133, 1, 705016260133, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(1705016289004, 1, 705016289004, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(1705016289042, 1, 705016289042, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(1705016289066, 1, 705016289066, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(1705016289127, 1, 705016289127, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(1705016289400, 1, 705016289400, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(1705016331215, 1, 705016331215, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(1705016331222, 1, 705016331222, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(1705016331239, 1, 705016331239, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(1705016331246, 1, 705016331246, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(1705016331260, 1, 705016331260, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(1705016353194, 1, 705016353194, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(1705016381401, 1, 705016381401, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(1705016383016, 1, 705016383016, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(1705016384068, 1, 705016384068, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(1705016433018, 1, 705016433018, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(1705016433032, 1, 705016433032, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(1705016433049, 1, 705016433049, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(1705016433094, 1, 705016433094, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(1705016433315, 1, 705016433315, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(1705016433339, 1, 705016433339, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(1705016433353, 1, 705016433353, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(1705016433452, 1, 705016433452, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(1705016471607, 1, 705016471607, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(1705016473137, 1, 705016473137, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(1705016473168, 1, 705016473168, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(1705016500000, 1, 705016500000, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(1705016500017, 1, 705016500017, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(1705016500024, 1, 705016500024, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(1705016500031, 1, 705016500031, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(1705016500079, 1, 705016500079, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(1705016555529, 1, 705016555529, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(1705016555536, 1, 705016555536, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(1705016560073, 1, 705016560073, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(1705016791019, 1, 705016791019, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(1705016890040, 1, 705016890040, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(1705016890057, 1, 705016890057, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(1705016890064, 1, 705016890064, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(1705016890071, 1, 705016890071, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(1705016895229, 1, 705016895229, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(1705016895281, 1, 705016895281, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(1705016993017, 1, 705016993017, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(1705016993031, 1, 705016993031, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(1705016993055, 1, 705016993055, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(1705016993123, 1, 705016993123, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(1710779113022, 1, 710779113022, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(1710779118478, 1, 710779118478, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(1710779118904, 1, 710779118904, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(1710779119000, 1, 710779119000, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(1710779333451, 1, 710779333451, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(1710779444614, 1, 710779444614, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(1710779444621, 1, 710779444621, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(1710779444638, 1, 710779444638, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(1710779444676, 1, 710779444676, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(1710779444805, 1, 710779444805, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(1732907051006, 1, 732907051006, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(1732907051273, 1, 732907051273, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(1732907100186, 1, 732907100186, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(1732907100940, 1, 732907100940, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(1736211053879, 1, 736211053879, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(1748927023800, 1, 748927023800, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(1748927023824, 1, 748927023824, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(1748927026238, 1, 748927026238, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(1748927028669, 1, 748927028669, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(1748927028683, 1, 748927028683, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(1748927028690, 1, 748927028690, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(1748927028706, 1, 748927028706, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(1749826125602, 1, 749826125602, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(1773094904416, 1, 773094904416, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(1786560153126, 1, 786560153126, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(1786560153133, 1, 786560153133, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(1786560502405, 1, 786560502405, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(1788434110440, 1, 788434110440, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(1788434113571, 1, 788434113571, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(1788434113632, 1, 788434113632, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(1788434114080, 1, 788434114080, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(1788434114172, 1, 788434114172, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(1788434114417, 1, 788434114417, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(1788434114646, 1, 788434114646, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(1810150020502, 1, 810150020502, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(1810150020564, 1, 810150020564, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(1810150020618, 1, 810150020618, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(1810150020625, 1, 810150020625, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(1810150020632, 1, 810150020632, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(1810150020687, 1, 810150020687, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(1810150020694, 1, 810150020694, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(1810150020700, 1, 810150020700, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(1810150020731, 1, 810150020731, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(1811662020004, 1, 811662020004, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(1811662020011, 1, 811662020011, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(1811662020035, 1, 811662020035, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(1834266002177, 1, 834266002177, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(1834266002221, 1, 834266002221, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(1834266003266, 1, 834266003266, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(1834266003303, 1, 834266003303, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(1834266003389, 1, 834266003389, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(1834266005031, 1, 834266005031, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(1834266006502, 1, 834266006502, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(1834266006557, 1, 834266006557, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(1834266006601, 1, 834266006601, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(1834266006656, 1, 834266006656, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(1834266007301, 1, 834266007301, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(1834266009282, 1, 834266009282, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(1834266009305, 1, 834266009305, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(1834266009343, 1, 834266009343, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(1834266009367, 1, 834266009367, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(1834266009381, 1, 834266009381, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(1834266009404, 1, 834266009404, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(1834266009466, 1, 834266009466, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(1834266063383, 1, 834266063383, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(1847534000003, 1, 847534000003, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(1851780002230, 1, 851780002230, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(1851780003763, 1, 851780003763, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(1851780003800, 1, 851780003800, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(1851780003848, 1, 851780003848, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(1852435000021, 1, 852435000021, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(1853237000127, 1, 853237000127, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(1853237000295, 1, 853237000295, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(1853237000325, 1, 853237000325, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(1853237000486, 1, 853237000486, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(1853237000516, 1, 853237000516, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(1853237000615, 1, 853237000615, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(1853237000707, 1, 853237000707, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(1853237000714, 1, 853237000714, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(1853237000721, 1, 853237000721, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(1853237000752, 1, 853237000752, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(1853237000806, 1, 853237000806, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(1853237001193, 1, 853237001193, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(1853237001322, 1, 853237001322, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(1853237001339, 1, 853237001339, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(1853237001377, 1, 853237001377, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(1853237001445, 1, 853237001445, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(1853237001667, 1, 853237001667, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(1853237001674, 1, 853237001674, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(1853237001681, 1, 853237001681, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(1853237001803, 1, 853237001803, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(1856036003122, 1, 856036003122, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(1856036003139, 1, 856036003139, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(1856036003146, 1, 856036003146, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(1857084000569, 1, 857084000569, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(1857084000576, 1, 857084000576, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(1857084000583, 1, 857084000583, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(1857084000767, 1, 857084000767, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(1857084000934, 1, 857084000934, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(1857084000935, 1, 857084000935, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(1857487000333, 1, 857487000333, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(1857487000418, 1, 857487000418, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(1857487000630, 1, 857487000630, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(1857487000654, 1, 857487000654, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(1857487000753, 1, 857487000753, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(1857487000807, 1, 857487000807, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(1857487000975, 1, 857487000975, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(1857487003211, 1, 857487003211, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(1857487003273, 1, 857487003273, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(1857487003280, 1, 857487003280, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(1857487003334, 1, 857487003334, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(1857487003440, 1, 857487003440, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(1857487003457, 1, 857487003457, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(1857487003778, 1, 857487003778, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(1857487003808, 1, 857487003808, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(1859163680013, 1, 859163680013, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(1859613000071, 1, 859613000071, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(1859613000224, 1, 859613000224, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(1859613000408, 1, 859613000408, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(1859613244628, 1, 859613244628, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(1859613252258, 1, 859613252258, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(1859613273291, 1, 859613273291, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(1859613274229, 1, 859613274229, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(1859613538321, 1, 859613538321, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(1859613638472, 1, 859613638472, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(1859613638496, 1, 859613638496, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(1859613641007, 1, 859613641007, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(1859613641008, 1, 859613641008, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(1859613641045, 1, 859613641045, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(1859613641069, 1, 859613641069, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(1859613641120, 1, 859613641120, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(1859613647009, 1, 859613647009, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(1859613647047, 1, 859613647047, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(1859613647085, 1, 859613647085, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(1859613647122, 1, 859613647122, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(1859613648723, 1, 859613648723, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(1859613648761, 1, 859613648761, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(1859613648778, 1, 859613648778, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(1859613648785, 1, 859613648785, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(1859613648907, 1, 859613648907, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(1859613648914, 1, 859613648914, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(1859613648990, 1, 859613648990, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(1859613649072, 1, 859613649072, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(1859613777775, 1, 859613777775, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(1859613777829, 1, 859613777829, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(1891597002306, 1, 891597002306, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(1891597002542, 1, 891597002542, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(1891597002634, 1, 891597002634, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(1891597002641, 1, 891597002641, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(1891597002658, 1, 891597002658, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(1891597002672, 1, 891597002672, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(1891597002849, 1, 891597002849, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(1891597003549, 1, 891597003549, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(1891597003663, 1, 891597003663, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(1891597003679, 1, 891597003679, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(1891597003747, 1, 891597003747, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(1891597003754, 1, 891597003754, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(1893912123512, 1, 893912123512, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(1893912123567, 1, 893912123567, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(1893912123871, 1, 893912123871, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(1893912123963, 1, 893912123963, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(1893912123970, 1, 893912123970, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55');
INSERT INTO `sucursales_productos` (`id_sucursales_productos`, `id_sucursal`, `id_producto`, `cantidad`, `stock`, `habilitado`, `created_at`, `updated_at`) VALUES
(1893912124205, 1, 893912124205, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(1893912124206, 1, 893912124206, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(1893912124236, 1, 893912124236, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(1893912124397, 1, 893912124397, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(1893912124526, 1, 893912124526, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(1893912124793, 1, 893912124793, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(1893912124861, 1, 893912124861, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(1893912124885, 1, 893912124885, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(1893912124892, 1, 893912124892, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(1893912124915, 1, 893912124915, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(2000751140109, 2, 751140109, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(2000751140208, 2, 751140208, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(2000751140307, 2, 751140307, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(2001245879358, 2, 1245879358, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(2013602004390, 2, 13602004390, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(2023991184719, 2, 23991184719, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(2039442030115, 2, 39442030115, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(2039442030283, 2, 39442030283, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(2039442030320, 2, 39442030320, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(2039442030542, 2, 39442030542, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(2085351004228, 2, 85351004228, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(2085351004303, 2, 85351004303, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(2089094021153, 2, 89094021153, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(2089094021177, 2, 89094021177, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(2089094021191, 2, 89094021191, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(2089094021511, 2, 89094021511, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(2089094021559, 2, 89094021559, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(2089094021573, 2, 89094021573, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(2089094021894, 2, 89094021894, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(2089094021931, 2, 89094021931, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(2089094021955, 2, 89094021955, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(2089094021979, 2, 89094021979, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(2089094022273, 2, 89094022273, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(2094922163073, 2, 94922163073, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(2094922368942, 2, 94922368942, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(2120492048714, 2, 120492048714, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(2610764010032, 2, 610764010032, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(2610764010131, 2, 610764010131, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(2610764010186, 2, 610764010186, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(2610764010339, 2, 610764010339, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(2610764180070, 2, 610764180070, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(2610764381484, 2, 610764381484, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(2610764711960, 2, 610764711960, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(2610764732613, 2, 610764732613, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(2610764732743, 2, 610764732743, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(2610764732767, 2, 610764732767, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(2610764733009, 2, 610764733009, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(2610764733054, 2, 610764733054, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(2610764733146, 2, 610764733146, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(2610764824868, 2, 610764824868, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(2610764825087, 2, 610764825087, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(2610764825100, 2, 610764825100, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(2610764825124, 2, 610764825124, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(2610764825278, 2, 610764825278, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(2610764830555, 2, 610764830555, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(2610764840226, 2, 610764840226, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(2610764840486, 2, 610764840486, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(2610764860323, 2, 610764860323, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(2610764860347, 2, 610764860347, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(2610764860514, 2, 610764860514, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(2610764860729, 2, 610764860729, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(2610764860743, 2, 610764860743, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(2627933065304, 2, 627933065304, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(2627933065311, 2, 627933065311, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(2631656602692, 2, 631656602692, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(2631656603330, 2, 631656603330, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(2631656603361, 2, 631656603361, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(2631656604504, 2, 631656604504, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(2631656604740, 2, 631656604740, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(2631656623154, 2, 631656623154, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(2631656703122, 2, 631656703122, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(2631656703146, 2, 631656703146, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(2631656703160, 2, 631656703160, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(2631656703214, 2, 631656703214, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(2631656703283, 2, 631656703283, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(2631656703290, 2, 631656703290, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(2631656703306, 2, 631656703306, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(2631656703313, 2, 631656703313, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(2631656703412, 2, 631656703412, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(2631656703528, 2, 631656703528, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(2631656703535, 2, 631656703535, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(2631656703542, 2, 631656703542, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(2632964301055, 2, 632964301055, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(2632964301123, 2, 632964301123, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(2632964301130, 2, 632964301130, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(2632964301147, 2, 632964301147, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(2632964301154, 2, 632964301154, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(2632964301536, 2, 632964301536, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(2632964302304, 2, 632964302304, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(2632964302434, 2, 632964302434, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(2646511005112, 2, 646511005112, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(2646511005211, 2, 646511005211, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(2646511005235, 2, 646511005235, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(2646511005242, 2, 646511005242, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(2646511006560, 2, 646511006560, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(2646511007000, 2, 646511007000, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(2646511007222, 2, 646511007222, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(2646511007239, 2, 646511007239, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(2646511007277, 2, 646511007277, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(2646511007284, 2, 646511007284, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(2646511008403, 2, 646511008403, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(2646511008410, 2, 646511008410, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(2646511008434, 2, 646511008434, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(2646511009165, 2, 646511009165, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(2646511009172, 2, 646511009172, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(2646511016019, 2, 646511016019, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(2646511016026, 2, 646511016026, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(2646511016033, 2, 646511016033, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(2646511020252, 2, 646511020252, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(2646511020269, 2, 646511020269, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(2646511020276, 2, 646511020276, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(2646511020283, 2, 646511020283, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(2646511021112, 2, 646511021112, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(2646511021129, 2, 646511021129, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(2646511021174, 2, 646511021174, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(2646511021181, 2, 646511021181, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(2646511022058, 2, 646511022058, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(2646511022157, 2, 646511022157, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(2646511022188, 2, 646511022188, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(2652908000011, 2, 652908000011, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(2652908000028, 2, 652908000028, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(2652908000066, 2, 652908000066, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(2652908000073, 2, 652908000073, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(2652908660062, 2, 652908660062, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(2652908670061, 2, 652908670061, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(2652908680060, 2, 652908680060, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(2666222091273, 2, 666222091273, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(2666222091587, 2, 666222091587, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(2666222091594, 2, 666222091594, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(2666222731032, 2, 666222731032, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(2666222731100, 2, 666222731100, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(2666222732107, 2, 666222732107, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(2672898126003, 2, 672898126003, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(2672898440055, 2, 672898440055, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(2672898440062, 2, 672898440062, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(2687339941015, 2, 687339941015, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(2687339981004, 2, 687339981004, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(2687339981011, 2, 687339981011, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(2687339981110, 2, 687339981110, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(2687339981127, 2, 687339981127, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(2687339984012, 2, 687339984012, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(2687339984029, 2, 687339984029, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(2696859258374, 2, 696859258374, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(2696859258459, 2, 696859258459, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(2696859258466, 2, 696859258466, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(2696859258527, 2, 696859258527, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(2696859258534, 2, 696859258534, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(2696859258601, 2, 696859258601, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(2696859258602, 2, 696859258602, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(2696859261176, 2, 696859261176, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(2696859261718, 2, 696859261718, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(2705016103027, 2, 705016103027, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(2705016110001, 2, 705016110001, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(2705016205004, 2, 705016205004, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(2705016210008, 2, 705016210008, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(2705016260133, 2, 705016260133, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(2705016289004, 2, 705016289004, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(2705016289042, 2, 705016289042, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(2705016289066, 2, 705016289066, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(2705016289127, 2, 705016289127, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(2705016289400, 2, 705016289400, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(2705016331215, 2, 705016331215, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(2705016331222, 2, 705016331222, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(2705016331239, 2, 705016331239, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(2705016331246, 2, 705016331246, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(2705016331260, 2, 705016331260, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(2705016353194, 2, 705016353194, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(2705016381401, 2, 705016381401, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(2705016383016, 2, 705016383016, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(2705016384068, 2, 705016384068, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(2705016433018, 2, 705016433018, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(2705016433032, 2, 705016433032, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(2705016433049, 2, 705016433049, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(2705016433094, 2, 705016433094, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(2705016433315, 2, 705016433315, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(2705016433339, 2, 705016433339, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(2705016433353, 2, 705016433353, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(2705016433452, 2, 705016433452, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(2705016471607, 2, 705016471607, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(2705016473137, 2, 705016473137, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(2705016473168, 2, 705016473168, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(2705016500000, 2, 705016500000, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(2705016500017, 2, 705016500017, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(2705016500024, 2, 705016500024, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(2705016500031, 2, 705016500031, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(2705016500079, 2, 705016500079, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(2705016555529, 2, 705016555529, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(2705016555536, 2, 705016555536, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(2705016560073, 2, 705016560073, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(2705016791019, 2, 705016791019, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(2705016890040, 2, 705016890040, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(2705016890057, 2, 705016890057, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(2705016890064, 2, 705016890064, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(2705016890071, 2, 705016890071, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(2705016895229, 2, 705016895229, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(2705016895281, 2, 705016895281, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(2705016993017, 2, 705016993017, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(2705016993031, 2, 705016993031, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(2705016993055, 2, 705016993055, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(2705016993123, 2, 705016993123, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(2710779113022, 2, 710779113022, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(2710779118478, 2, 710779118478, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(2710779118904, 2, 710779118904, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(2710779119000, 2, 710779119000, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(2710779333451, 2, 710779333451, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(2710779444614, 2, 710779444614, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(2710779444621, 2, 710779444621, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(2710779444638, 2, 710779444638, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(2710779444676, 2, 710779444676, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(2710779444805, 2, 710779444805, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(2732907051006, 2, 732907051006, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(2732907051273, 2, 732907051273, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(2732907100186, 2, 732907100186, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(2732907100940, 2, 732907100940, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(2736211053879, 2, 736211053879, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(2748927023800, 2, 748927023800, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(2748927023824, 2, 748927023824, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(2748927026238, 2, 748927026238, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(2748927028669, 2, 748927028669, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(2748927028683, 2, 748927028683, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(2748927028690, 2, 748927028690, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(2748927028706, 2, 748927028706, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(2749826125602, 2, 749826125602, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(2773094904416, 2, 773094904416, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(2786560153126, 2, 786560153126, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(2786560153133, 2, 786560153133, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(2786560502405, 2, 786560502405, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(2788434110440, 2, 788434110440, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(2788434113571, 2, 788434113571, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(2788434113632, 2, 788434113632, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(2788434114080, 2, 788434114080, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(2788434114172, 2, 788434114172, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(2788434114417, 2, 788434114417, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(2788434114646, 2, 788434114646, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(2810150020502, 2, 810150020502, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(2810150020564, 2, 810150020564, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(2810150020618, 2, 810150020618, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(2810150020625, 2, 810150020625, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(2810150020632, 2, 810150020632, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(2810150020687, 2, 810150020687, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(2810150020694, 2, 810150020694, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(2810150020700, 2, 810150020700, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(2810150020731, 2, 810150020731, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(2811662020004, 2, 811662020004, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(2811662020011, 2, 811662020011, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(2811662020035, 2, 811662020035, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(2834266002177, 2, 834266002177, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(2834266002221, 2, 834266002221, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(2834266003266, 2, 834266003266, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(2834266003303, 2, 834266003303, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(2834266003389, 2, 834266003389, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(2834266005031, 2, 834266005031, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(2834266006502, 2, 834266006502, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(2834266006557, 2, 834266006557, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(2834266006601, 2, 834266006601, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(2834266006656, 2, 834266006656, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(2834266007301, 2, 834266007301, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(2834266009282, 2, 834266009282, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(2834266009305, 2, 834266009305, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(2834266009343, 2, 834266009343, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(2834266009367, 2, 834266009367, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(2834266009381, 2, 834266009381, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(2834266009404, 2, 834266009404, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(2834266009466, 2, 834266009466, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(2834266063383, 2, 834266063383, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(2847534000003, 2, 847534000003, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(2851780002230, 2, 851780002230, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(2851780003763, 2, 851780003763, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(2851780003800, 2, 851780003800, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(2851780003848, 2, 851780003848, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(2852435000021, 2, 852435000021, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(2853237000127, 2, 853237000127, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(2853237000295, 2, 853237000295, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(2853237000325, 2, 853237000325, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(2853237000486, 2, 853237000486, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(2853237000516, 2, 853237000516, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(2853237000615, 2, 853237000615, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(2853237000707, 2, 853237000707, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(2853237000714, 2, 853237000714, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(2853237000721, 2, 853237000721, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(2853237000752, 2, 853237000752, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(2853237000806, 2, 853237000806, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(2853237001193, 2, 853237001193, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(2853237001322, 2, 853237001322, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(2853237001339, 2, 853237001339, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(2853237001377, 2, 853237001377, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(2853237001445, 2, 853237001445, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(2853237001667, 2, 853237001667, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(2853237001674, 2, 853237001674, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(2853237001681, 2, 853237001681, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(2853237001803, 2, 853237001803, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(2856036003122, 2, 856036003122, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(2856036003139, 2, 856036003139, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(2856036003146, 2, 856036003146, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(2857084000569, 2, 857084000569, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(2857084000576, 2, 857084000576, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(2857084000583, 2, 857084000583, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(2857084000767, 2, 857084000767, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(2857084000934, 2, 857084000934, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(2857084000935, 2, 857084000935, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(2857487000333, 2, 857487000333, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(2857487000418, 2, 857487000418, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(2857487000630, 2, 857487000630, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(2857487000654, 2, 857487000654, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(2857487000753, 2, 857487000753, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(2857487000807, 2, 857487000807, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(2857487000975, 2, 857487000975, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(2857487003211, 2, 857487003211, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(2857487003273, 2, 857487003273, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(2857487003280, 2, 857487003280, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(2857487003334, 2, 857487003334, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(2857487003440, 2, 857487003440, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(2857487003457, 2, 857487003457, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(2857487003778, 2, 857487003778, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(2857487003808, 2, 857487003808, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(2859163680013, 2, 859163680013, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(2859613000071, 2, 859613000071, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(2859613000224, 2, 859613000224, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(2859613000408, 2, 859613000408, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(2859613244628, 2, 859613244628, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(2859613252258, 2, 859613252258, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(2859613273291, 2, 859613273291, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(2859613274229, 2, 859613274229, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(2859613538321, 2, 859613538321, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(2859613638472, 2, 859613638472, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(2859613638496, 2, 859613638496, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(2859613641007, 2, 859613641007, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(2859613641008, 2, 859613641008, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(2859613641045, 2, 859613641045, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(2859613641069, 2, 859613641069, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(2859613641120, 2, 859613641120, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(2859613647009, 2, 859613647009, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(2859613647047, 2, 859613647047, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(2859613647085, 2, 859613647085, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(2859613647122, 2, 859613647122, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(2859613648723, 2, 859613648723, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(2859613648761, 2, 859613648761, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(2859613648778, 2, 859613648778, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(2859613648785, 2, 859613648785, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(2859613648907, 2, 859613648907, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(2859613648914, 2, 859613648914, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(2859613648990, 2, 859613648990, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(2859613649072, 2, 859613649072, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(2859613777775, 2, 859613777775, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(2859613777829, 2, 859613777829, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(2891597002306, 2, 891597002306, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(2891597002542, 2, 891597002542, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(2891597002634, 2, 891597002634, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(2891597002641, 2, 891597002641, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(2891597002658, 2, 891597002658, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(2891597002672, 2, 891597002672, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(2891597002849, 2, 891597002849, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(2891597003549, 2, 891597003549, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(2891597003663, 2, 891597003663, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(2891597003679, 2, 891597003679, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(2891597003747, 2, 891597003747, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(2891597003754, 2, 891597003754, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(2893912123512, 2, 893912123512, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(2893912123567, 2, 893912123567, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(2893912123871, 2, 893912123871, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(2893912123963, 2, 893912123963, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(2893912123970, 2, 893912123970, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(2893912124205, 2, 893912124205, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(2893912124206, 2, 893912124206, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(2893912124236, 2, 893912124236, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(2893912124397, 2, 893912124397, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(2893912124526, 2, 893912124526, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(2893912124793, 2, 893912124793, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(2893912124861, 2, 893912124861, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(2893912124885, 2, 893912124885, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(2893912124892, 2, 893912124892, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(2893912124915, 2, 893912124915, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(3000751140109, 3, 751140109, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(3000751140208, 3, 751140208, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(3000751140307, 3, 751140307, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(3001245879358, 3, 1245879358, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(3013602004390, 3, 13602004390, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(3023991184719, 3, 23991184719, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(3039442030115, 3, 39442030115, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(3039442030283, 3, 39442030283, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(3039442030320, 3, 39442030320, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(3039442030542, 3, 39442030542, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(3085351004228, 3, 85351004228, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(3085351004303, 3, 85351004303, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(3089094021153, 3, 89094021153, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(3089094021177, 3, 89094021177, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(3089094021191, 3, 89094021191, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(3089094021511, 3, 89094021511, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(3089094021559, 3, 89094021559, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(3089094021573, 3, 89094021573, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(3089094021894, 3, 89094021894, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(3089094021931, 3, 89094021931, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(3089094021955, 3, 89094021955, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(3089094021979, 3, 89094021979, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(3089094022273, 3, 89094022273, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(3094922163073, 3, 94922163073, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(3094922368942, 3, 94922368942, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(3120492048714, 3, 120492048714, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(3610764010032, 3, 610764010032, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(3610764010131, 3, 610764010131, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(3610764010186, 3, 610764010186, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(3610764010339, 3, 610764010339, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(3610764180070, 3, 610764180070, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(3610764381484, 3, 610764381484, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(3610764711960, 3, 610764711960, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(3610764732613, 3, 610764732613, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(3610764732743, 3, 610764732743, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(3610764732767, 3, 610764732767, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(3610764733009, 3, 610764733009, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(3610764733054, 3, 610764733054, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(3610764733146, 3, 610764733146, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(3610764824868, 3, 610764824868, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(3610764825087, 3, 610764825087, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(3610764825100, 3, 610764825100, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(3610764825124, 3, 610764825124, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(3610764825278, 3, 610764825278, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(3610764830555, 3, 610764830555, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(3610764840226, 3, 610764840226, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(3610764840486, 3, 610764840486, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(3610764860323, 3, 610764860323, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(3610764860347, 3, 610764860347, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(3610764860514, 3, 610764860514, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(3610764860729, 3, 610764860729, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(3610764860743, 3, 610764860743, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(3627933065304, 3, 627933065304, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(3627933065311, 3, 627933065311, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(3631656602692, 3, 631656602692, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(3631656603330, 3, 631656603330, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(3631656603361, 3, 631656603361, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(3631656604504, 3, 631656604504, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(3631656604740, 3, 631656604740, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(3631656623154, 3, 631656623154, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(3631656703122, 3, 631656703122, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(3631656703146, 3, 631656703146, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(3631656703160, 3, 631656703160, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(3631656703214, 3, 631656703214, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(3631656703283, 3, 631656703283, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(3631656703290, 3, 631656703290, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(3631656703306, 3, 631656703306, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(3631656703313, 3, 631656703313, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(3631656703412, 3, 631656703412, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(3631656703528, 3, 631656703528, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(3631656703535, 3, 631656703535, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(3631656703542, 3, 631656703542, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(3632964301055, 3, 632964301055, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(3632964301123, 3, 632964301123, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(3632964301130, 3, 632964301130, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(3632964301147, 3, 632964301147, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(3632964301154, 3, 632964301154, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(3632964301536, 3, 632964301536, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(3632964302304, 3, 632964302304, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(3632964302434, 3, 632964302434, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(3646511005112, 3, 646511005112, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(3646511005211, 3, 646511005211, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(3646511005235, 3, 646511005235, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(3646511005242, 3, 646511005242, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(3646511006560, 3, 646511006560, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(3646511007000, 3, 646511007000, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(3646511007222, 3, 646511007222, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(3646511007239, 3, 646511007239, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(3646511007277, 3, 646511007277, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(3646511007284, 3, 646511007284, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(3646511008403, 3, 646511008403, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(3646511008410, 3, 646511008410, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(3646511008434, 3, 646511008434, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(3646511009165, 3, 646511009165, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(3646511009172, 3, 646511009172, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(3646511016019, 3, 646511016019, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(3646511016026, 3, 646511016026, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(3646511016033, 3, 646511016033, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(3646511020252, 3, 646511020252, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(3646511020269, 3, 646511020269, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(3646511020276, 3, 646511020276, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(3646511020283, 3, 646511020283, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(3646511021112, 3, 646511021112, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(3646511021129, 3, 646511021129, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(3646511021174, 3, 646511021174, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(3646511021181, 3, 646511021181, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(3646511022058, 3, 646511022058, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(3646511022157, 3, 646511022157, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(3646511022188, 3, 646511022188, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(3652908000011, 3, 652908000011, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(3652908000028, 3, 652908000028, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(3652908000066, 3, 652908000066, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(3652908000073, 3, 652908000073, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(3652908660062, 3, 652908660062, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(3652908670061, 3, 652908670061, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(3652908680060, 3, 652908680060, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(3666222091273, 3, 666222091273, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(3666222091587, 3, 666222091587, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(3666222091594, 3, 666222091594, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(3666222731032, 3, 666222731032, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(3666222731100, 3, 666222731100, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(3666222732107, 3, 666222732107, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(3672898126003, 3, 672898126003, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(3672898440055, 3, 672898440055, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(3672898440062, 3, 672898440062, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(3687339941015, 3, 687339941015, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(3687339981004, 3, 687339981004, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(3687339981011, 3, 687339981011, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(3687339981110, 3, 687339981110, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(3687339981127, 3, 687339981127, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(3687339984012, 3, 687339984012, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(3687339984029, 3, 687339984029, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(3696859258374, 3, 696859258374, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(3696859258459, 3, 696859258459, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(3696859258466, 3, 696859258466, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(3696859258527, 3, 696859258527, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(3696859258534, 3, 696859258534, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(3696859258601, 3, 696859258601, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(3696859258602, 3, 696859258602, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(3696859261176, 3, 696859261176, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(3696859261718, 3, 696859261718, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(3705016103027, 3, 705016103027, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(3705016110001, 3, 705016110001, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(3705016205004, 3, 705016205004, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(3705016210008, 3, 705016210008, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(3705016260133, 3, 705016260133, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(3705016289004, 3, 705016289004, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(3705016289042, 3, 705016289042, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(3705016289066, 3, 705016289066, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(3705016289127, 3, 705016289127, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(3705016289400, 3, 705016289400, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(3705016331215, 3, 705016331215, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(3705016331222, 3, 705016331222, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(3705016331239, 3, 705016331239, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(3705016331246, 3, 705016331246, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(3705016331260, 3, 705016331260, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(3705016353194, 3, 705016353194, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(3705016381401, 3, 705016381401, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(3705016383016, 3, 705016383016, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(3705016384068, 3, 705016384068, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(3705016433018, 3, 705016433018, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(3705016433032, 3, 705016433032, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(3705016433049, 3, 705016433049, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(3705016433094, 3, 705016433094, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(3705016433315, 3, 705016433315, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(3705016433339, 3, 705016433339, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(3705016433353, 3, 705016433353, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(3705016433452, 3, 705016433452, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(3705016471607, 3, 705016471607, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(3705016473137, 3, 705016473137, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(3705016473168, 3, 705016473168, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(3705016500000, 3, 705016500000, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(3705016500017, 3, 705016500017, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(3705016500024, 3, 705016500024, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(3705016500031, 3, 705016500031, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(3705016500079, 3, 705016500079, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(3705016555529, 3, 705016555529, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(3705016555536, 3, 705016555536, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(3705016560073, 3, 705016560073, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(3705016791019, 3, 705016791019, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(3705016890040, 3, 705016890040, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(3705016890057, 3, 705016890057, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(3705016890064, 3, 705016890064, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(3705016890071, 3, 705016890071, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(3705016895229, 3, 705016895229, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(3705016895281, 3, 705016895281, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(3705016993017, 3, 705016993017, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(3705016993031, 3, 705016993031, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(3705016993055, 3, 705016993055, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(3705016993123, 3, 705016993123, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(3710779113022, 3, 710779113022, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(3710779118478, 3, 710779118478, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(3710779118904, 3, 710779118904, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(3710779119000, 3, 710779119000, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(3710779333451, 3, 710779333451, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(3710779444614, 3, 710779444614, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(3710779444621, 3, 710779444621, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(3710779444638, 3, 710779444638, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(3710779444676, 3, 710779444676, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(3710779444805, 3, 710779444805, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(3732907051006, 3, 732907051006, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55');
INSERT INTO `sucursales_productos` (`id_sucursales_productos`, `id_sucursal`, `id_producto`, `cantidad`, `stock`, `habilitado`, `created_at`, `updated_at`) VALUES
(3732907051273, 3, 732907051273, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(3732907100186, 3, 732907100186, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(3732907100940, 3, 732907100940, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(3736211053879, 3, 736211053879, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(3748927023800, 3, 748927023800, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(3748927023824, 3, 748927023824, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(3748927026238, 3, 748927026238, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(3748927028669, 3, 748927028669, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(3748927028683, 3, 748927028683, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(3748927028690, 3, 748927028690, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(3748927028706, 3, 748927028706, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(3749826125602, 3, 749826125602, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(3773094904416, 3, 773094904416, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(3786560153126, 3, 786560153126, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(3786560153133, 3, 786560153133, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(3786560502405, 3, 786560502405, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(3788434110440, 3, 788434110440, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(3788434113571, 3, 788434113571, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(3788434113632, 3, 788434113632, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(3788434114080, 3, 788434114080, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(3788434114172, 3, 788434114172, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(3788434114417, 3, 788434114417, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(3788434114646, 3, 788434114646, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(3810150020502, 3, 810150020502, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(3810150020564, 3, 810150020564, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(3810150020618, 3, 810150020618, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(3810150020625, 3, 810150020625, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(3810150020632, 3, 810150020632, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(3810150020687, 3, 810150020687, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(3810150020694, 3, 810150020694, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(3810150020700, 3, 810150020700, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(3810150020731, 3, 810150020731, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(3811662020004, 3, 811662020004, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(3811662020011, 3, 811662020011, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(3811662020035, 3, 811662020035, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(3834266002177, 3, 834266002177, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(3834266002221, 3, 834266002221, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(3834266003266, 3, 834266003266, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(3834266003303, 3, 834266003303, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(3834266003389, 3, 834266003389, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(3834266005031, 3, 834266005031, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(3834266006502, 3, 834266006502, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(3834266006557, 3, 834266006557, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(3834266006601, 3, 834266006601, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(3834266006656, 3, 834266006656, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(3834266007301, 3, 834266007301, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(3834266009282, 3, 834266009282, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(3834266009305, 3, 834266009305, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(3834266009343, 3, 834266009343, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(3834266009367, 3, 834266009367, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(3834266009381, 3, 834266009381, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(3834266009404, 3, 834266009404, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(3834266009466, 3, 834266009466, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(3834266063383, 3, 834266063383, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(3847534000003, 3, 847534000003, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(3851780002230, 3, 851780002230, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(3851780003763, 3, 851780003763, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(3851780003800, 3, 851780003800, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(3851780003848, 3, 851780003848, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(3852435000021, 3, 852435000021, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(3853237000127, 3, 853237000127, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(3853237000295, 3, 853237000295, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(3853237000325, 3, 853237000325, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(3853237000486, 3, 853237000486, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(3853237000516, 3, 853237000516, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(3853237000615, 3, 853237000615, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(3853237000707, 3, 853237000707, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(3853237000714, 3, 853237000714, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(3853237000721, 3, 853237000721, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(3853237000752, 3, 853237000752, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(3853237000806, 3, 853237000806, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(3853237001193, 3, 853237001193, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(3853237001322, 3, 853237001322, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(3853237001339, 3, 853237001339, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(3853237001377, 3, 853237001377, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(3853237001445, 3, 853237001445, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(3853237001667, 3, 853237001667, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(3853237001674, 3, 853237001674, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(3853237001681, 3, 853237001681, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(3853237001803, 3, 853237001803, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(3856036003122, 3, 856036003122, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(3856036003139, 3, 856036003139, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(3856036003146, 3, 856036003146, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(3857084000569, 3, 857084000569, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(3857084000576, 3, 857084000576, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(3857084000583, 3, 857084000583, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(3857084000767, 3, 857084000767, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(3857084000934, 3, 857084000934, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(3857084000935, 3, 857084000935, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(3857487000333, 3, 857487000333, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(3857487000418, 3, 857487000418, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(3857487000630, 3, 857487000630, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(3857487000654, 3, 857487000654, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(3857487000753, 3, 857487000753, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(3857487000807, 3, 857487000807, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(3857487000975, 3, 857487000975, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(3857487003211, 3, 857487003211, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(3857487003273, 3, 857487003273, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(3857487003280, 3, 857487003280, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(3857487003334, 3, 857487003334, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(3857487003440, 3, 857487003440, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(3857487003457, 3, 857487003457, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(3857487003778, 3, 857487003778, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(3857487003808, 3, 857487003808, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(3859163680013, 3, 859163680013, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(3859613000071, 3, 859613000071, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(3859613000224, 3, 859613000224, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(3859613000408, 3, 859613000408, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(3859613244628, 3, 859613244628, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(3859613252258, 3, 859613252258, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(3859613273291, 3, 859613273291, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(3859613274229, 3, 859613274229, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(3859613538321, 3, 859613538321, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(3859613638472, 3, 859613638472, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(3859613638496, 3, 859613638496, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(3859613641007, 3, 859613641007, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(3859613641008, 3, 859613641008, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(3859613641045, 3, 859613641045, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(3859613641069, 3, 859613641069, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(3859613641120, 3, 859613641120, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(3859613647009, 3, 859613647009, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(3859613647047, 3, 859613647047, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(3859613647085, 3, 859613647085, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(3859613647122, 3, 859613647122, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(3859613648723, 3, 859613648723, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(3859613648761, 3, 859613648761, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(3859613648778, 3, 859613648778, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(3859613648785, 3, 859613648785, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(3859613648907, 3, 859613648907, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(3859613648914, 3, 859613648914, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(3859613648990, 3, 859613648990, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(3859613649072, 3, 859613649072, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(3859613777775, 3, 859613777775, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(3859613777829, 3, 859613777829, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(3891597002306, 3, 891597002306, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(3891597002542, 3, 891597002542, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(3891597002634, 3, 891597002634, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(3891597002641, 3, 891597002641, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(3891597002658, 3, 891597002658, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(3891597002672, 3, 891597002672, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(3891597002849, 3, 891597002849, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(3891597003549, 3, 891597003549, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(3891597003663, 3, 891597003663, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(3891597003679, 3, 891597003679, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(3891597003747, 3, 891597003747, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(3891597003754, 3, 891597003754, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(3893912123512, 3, 893912123512, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(3893912123567, 3, 893912123567, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(3893912123871, 3, 893912123871, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(3893912123963, 3, 893912123963, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(3893912123970, 3, 893912123970, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(3893912124205, 3, 893912124205, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(3893912124206, 3, 893912124206, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(3893912124236, 3, 893912124236, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(3893912124397, 3, 893912124397, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(3893912124526, 3, 893912124526, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(3893912124793, 3, 893912124793, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(3893912124861, 3, 893912124861, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(3893912124885, 3, 893912124885, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(3893912124892, 3, 893912124892, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(3893912124915, 3, 893912124915, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(11838593595024, 1, 1838593595024, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(11838593595025, 1, 1838593595025, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(11838593595026, 1, 1838593595026, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(14588759366178, 1, 4588759366178, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(14589058901232, 1, 4589058901232, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(14589058901249, 1, 4589058901249, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(14589058901256, 1, 4589058901256, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(15458722923799, 1, 5458722923799, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(15783920138903, 1, 5783920138903, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(17501055304721, 1, 7501055304721, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(17501055308675, 1, 7501055308675, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(17501055309665, 1, 7501055309665, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(17501055319053, 1, 7501055319053, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(17501055329267, 1, 7501055329267, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(17501055329298, 1, 7501055329298, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(17501055342716, 1, 7501055342716, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(17501125133343, 1, 7501125133343, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(17501166515603, 1, 7501166515603, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(17501250835167, 1, 7501250835167, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(17501639304772, 1, 7501639304772, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(17501639305700, 1, 7501639305700, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(17501639306059, 1, 7501639306059, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(17501639306066, 1, 7501639306066, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(17502042201009, 1, 7502042201009, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(17502042201016, 1, 7502042201016, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(17502042201026, 1, 7502042201026, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(17502042201047, 1, 7502042201047, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(17502213141172, 1, 7502213141172, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(17502213141173, 1, 7502213141173, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(17503005387137, 1, 7503005387137, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(17503013595448, 1, 7503013595448, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(17503016015004, 1, 7503016015004, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(17503016015028, 1, 7503016015028, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(17503016015035, 1, 7503016015035, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(17503016015042, 1, 7503016015042, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(17503016015189, 1, 7503016015189, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(17504008531106, 1, 7504008531106, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(17504008531107, 1, 7504008531107, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(18557487003310, 1, 8557487003310, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(18852086710005, 1, 8852086710005, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(18852086710006, 1, 8852086710006, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(19133756416279, 1, 9133756416279, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(21838593595024, 2, 1838593595024, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(21838593595025, 2, 1838593595025, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(21838593595026, 2, 1838593595026, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(24588759366178, 2, 4588759366178, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(24589058901232, 2, 4589058901232, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(24589058901249, 2, 4589058901249, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(24589058901256, 2, 4589058901256, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(25458722923799, 2, 5458722923799, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(25783920138903, 2, 5783920138903, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(27501055304721, 2, 7501055304721, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(27501055308675, 2, 7501055308675, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(27501055309665, 2, 7501055309665, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(27501055319053, 2, 7501055319053, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(27501055329267, 2, 7501055329267, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(27501055329298, 2, 7501055329298, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(27501055342716, 2, 7501055342716, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(27501125133343, 2, 7501125133343, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(27501166515603, 2, 7501166515603, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(27501250835167, 2, 7501250835167, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(27501639304772, 2, 7501639304772, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(27501639305700, 2, 7501639305700, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(27501639306059, 2, 7501639306059, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(27501639306066, 2, 7501639306066, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(27502042201009, 2, 7502042201009, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(27502042201016, 2, 7502042201016, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(27502042201026, 2, 7502042201026, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(27502042201047, 2, 7502042201047, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(27502213141172, 2, 7502213141172, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(27502213141173, 2, 7502213141173, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(27503005387137, 2, 7503005387137, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(27503013595448, 2, 7503013595448, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(27503016015004, 2, 7503016015004, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(27503016015028, 2, 7503016015028, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(27503016015035, 2, 7503016015035, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(27503016015042, 2, 7503016015042, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(27503016015189, 2, 7503016015189, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(27504008531106, 2, 7504008531106, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(27504008531107, 2, 7504008531107, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(28557487003310, 2, 8557487003310, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(28852086710005, 2, 8852086710005, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(28852086710006, 2, 8852086710006, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(29133756416279, 2, 9133756416279, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(31838593595024, 3, 1838593595024, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(31838593595025, 3, 1838593595025, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(31838593595026, 3, 1838593595026, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(34588759366178, 3, 4588759366178, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(34589058901232, 3, 4589058901232, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(34589058901249, 3, 4589058901249, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(34589058901256, 3, 4589058901256, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(35458722923799, 3, 5458722923799, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(35783920138903, 3, 5783920138903, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(37501055304721, 3, 7501055304721, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(37501055308675, 3, 7501055308675, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(37501055309665, 3, 7501055309665, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(37501055319053, 3, 7501055319053, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(37501055329267, 3, 7501055329267, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(37501055329298, 3, 7501055329298, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(37501055342716, 3, 7501055342716, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(37501125133343, 3, 7501125133343, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(37501166515603, 3, 7501166515603, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(37501250835167, 3, 7501250835167, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(37501639304772, 3, 7501639304772, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(37501639305700, 3, 7501639305700, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(37501639306059, 3, 7501639306059, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(37501639306066, 3, 7501639306066, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(37502042201009, 3, 7502042201009, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(37502042201016, 3, 7502042201016, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(37502042201026, 3, 7502042201026, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(37502042201047, 3, 7502042201047, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(37502213141172, 3, 7502213141172, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(37502213141173, 3, 7502213141173, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(37503005387137, 3, 7503005387137, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(37503013595448, 3, 7503013595448, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(37503016015004, 3, 7503016015004, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(37503016015028, 3, 7503016015028, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(37503016015035, 3, 7503016015035, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(37503016015042, 3, 7503016015042, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(37503016015189, 3, 7503016015189, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(37504008531106, 3, 7504008531106, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(37504008531107, 3, 7504008531107, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(38557487003310, 3, 8557487003310, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(38852086710005, 3, 8852086710005, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(38852086710006, 3, 8852086710006, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55'),
(39133756416279, 3, 9133756416279, 0, 0, 1, '2015-05-09 21:22:55', '2015-05-09 21:22:55');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tipos_de_clientes`
--

CREATE TABLE IF NOT EXISTS `tipos_de_clientes` (
  `id_tipo_de_cliente` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `tipo_de_cliente` varchar(30) COLLATE utf8_spanish2_ci NOT NULL,
  `descripcion` varchar(150) COLLATE utf8_spanish2_ci DEFAULT NULL,
  `habilitado` tinyint(1) NOT NULL DEFAULT '1',
  `created_at` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00',
  `updated_at` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00',
  PRIMARY KEY (`id_tipo_de_cliente`),
  UNIQUE KEY `tipos_de_clientes_tipo_de_cliente_unique` (`tipo_de_cliente`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COLLATE=utf8_spanish2_ci AUTO_INCREMENT=5 ;

--
-- Volcado de datos para la tabla `tipos_de_clientes`
--

INSERT INTO `tipos_de_clientes` (`id_tipo_de_cliente`, `tipo_de_cliente`, `descripcion`, `habilitado`, `created_at`, `updated_at`) VALUES
(1, 'cliente de mostrador', 'cliente no registrado en el sistema', 1, '2015-05-09 21:22:30', '2015-05-09 21:22:30'),
(2, 'normal', NULL, 1, '2015-05-09 21:22:30', '2015-05-09 21:22:30'),
(3, 'tienda', NULL, 1, '2015-05-09 21:22:30', '2015-05-09 21:22:30'),
(4, 'distribuidor', 'cliente que vende mucho', 1, '2015-05-09 21:22:30', '2015-05-09 21:22:30');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tipos_de_empleados`
--

CREATE TABLE IF NOT EXISTS `tipos_de_empleados` (
  `id_tipo_de_empleado` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `tipo_de_empleado` varchar(30) COLLATE utf8_spanish2_ci NOT NULL,
  `descripcion` varchar(150) COLLATE utf8_spanish2_ci DEFAULT NULL,
  `habilitado` tinyint(1) NOT NULL DEFAULT '1',
  `created_at` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00',
  `updated_at` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00',
  PRIMARY KEY (`id_tipo_de_empleado`),
  UNIQUE KEY `tipos_de_empleados_tipo_de_empleado_unique` (`tipo_de_empleado`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COLLATE=utf8_spanish2_ci AUTO_INCREMENT=5 ;

--
-- Volcado de datos para la tabla `tipos_de_empleados`
--

INSERT INTO `tipos_de_empleados` (`id_tipo_de_empleado`, `tipo_de_empleado`, `descripcion`, `habilitado`, `created_at`, `updated_at`) VALUES
(1, 'administrador', 'administra todo el sistema y sucursales', 1, '2015-05-09 21:22:30', '2015-05-09 21:22:30'),
(2, 'gerente general', 'administra varias sucursales', 1, '2015-05-09 21:22:30', '2015-05-09 21:22:30'),
(3, 'gerente de sucursal', 'arministra una sucursal', 1, '2015-05-09 21:22:30', '2015-05-09 21:22:30'),
(4, 'vendedor', 'ventas, devoluciones, inventario', 1, '2015-05-09 21:22:30', '2015-05-09 21:22:30');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tipos_de_pagos`
--

CREATE TABLE IF NOT EXISTS `tipos_de_pagos` (
  `id_tipo_de_pago` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `tipo_de_pago` varchar(50) COLLATE utf8_spanish2_ci NOT NULL,
  `habilitado` tinyint(1) NOT NULL DEFAULT '1',
  `created_at` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00',
  `updated_at` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00',
  PRIMARY KEY (`id_tipo_de_pago`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COLLATE=utf8_spanish2_ci AUTO_INCREMENT=5 ;

--
-- Volcado de datos para la tabla `tipos_de_pagos`
--

INSERT INTO `tipos_de_pagos` (`id_tipo_de_pago`, `tipo_de_pago`, `habilitado`, `created_at`, `updated_at`) VALUES
(1, 'Efectivo', 1, '2015-05-09 21:22:30', '2015-05-09 21:22:30'),
(2, 'Tarjeta', 1, '2015-05-09 21:22:30', '2015-05-09 21:22:30'),
(3, 'Deposito', 1, '2015-05-09 21:22:30', '2015-05-09 21:22:30'),
(4, 'Cheque', 1, '2015-05-09 21:22:30', '2015-05-09 21:22:30');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `transferencias`
--

CREATE TABLE IF NOT EXISTS `transferencias` (
  `id_transferencia` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `id_empleado` int(10) unsigned NOT NULL,
  `id_sucursal_origen` int(10) unsigned NOT NULL,
  `id_sucursal_destino` int(10) unsigned NOT NULL,
  `id_producto` bigint(20) unsigned NOT NULL,
  `cantidad` smallint(6) NOT NULL,
  `habilitado` tinyint(1) NOT NULL DEFAULT '1',
  `created_at` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00',
  `updated_at` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00',
  PRIMARY KEY (`id_transferencia`),
  KEY `transferencias_id_empleado_foreign` (`id_empleado`),
  KEY `transferencias_id_sucursal_origen_foreign` (`id_sucursal_origen`),
  KEY `transferencias_id_sucursal_destino_foreign` (`id_sucursal_destino`),
  KEY `transferencias_id_producto_foreign` (`id_producto`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish2_ci AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `usuarios`
--

CREATE TABLE IF NOT EXISTS `usuarios` (
  `id_usuario` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `username` varchar(50) COLLATE utf8_spanish2_ci NOT NULL,
  `password` varchar(60) COLLATE utf8_spanish2_ci NOT NULL,
  `id_empleado` int(10) unsigned NOT NULL,
  `habilitado` tinyint(1) NOT NULL DEFAULT '1',
  `remember_token` varchar(100) COLLATE utf8_spanish2_ci DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00',
  `updated_at` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00',
  PRIMARY KEY (`id_usuario`),
  UNIQUE KEY `usuarios_username_unique` (`username`),
  KEY `usuarios_id_empleado_foreign` (`id_empleado`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COLLATE=utf8_spanish2_ci AUTO_INCREMENT=8 ;

--
-- Volcado de datos para la tabla `usuarios`
--

INSERT INTO `usuarios` (`id_usuario`, `username`, `password`, `id_empleado`, `habilitado`, `remember_token`, `created_at`, `updated_at`) VALUES
(1, 'superadmin', '$2y$10$RcafAQR5H68STcSnxrGXW.nyTM4Rg5RA/8HoNDI2cKVsgBe6sjWhq', 1, 1, NULL, '2015-05-09 21:22:30', '2015-05-09 21:22:30'),
(2, 'copilco', '$2y$10$ih89u.9vnQ0MoPCLBNxt0uuHFXKZw2aHktd.W.Y0aWU57RsDitByq', 2, 1, NULL, '2015-05-09 21:22:30', '2015-05-09 21:22:30'),
(3, 'ajusco', '$2y$10$5CwrNflkavpcnK.lmgBMP.MmhKxpt0OTOk5IQae.RCG5Em.ObQNQW', 3, 1, NULL, '2015-05-09 21:22:30', '2015-05-09 21:22:30'),
(4, 'valle', '$2y$10$S9SXxVT7wCVmouykSfbjNOdv8/6SyEb4Px8mqBO5Qard634miFU.K', 4, 1, NULL, '2015-05-09 21:22:30', '2015-05-09 21:22:30'),
(5, 'ajuscoe', '$2y$10$z1iDBvCoJ/h8W1dUbzkYkuoeGdSa8.TlNuW0rzhOLhoSKwN3oDGiG', 5, 1, NULL, '2015-05-09 21:22:30', '2015-05-09 21:22:30'),
(6, 'copilcoe', '$2y$10$FZtyIbR54G5pi4HoO2JWGuS2Bk6kdYiWK5ljGTofiJGKjRKBIKKWy', 6, 1, NULL, '2015-05-09 21:22:30', '2015-05-09 21:22:30'),
(7, 'vallee', '$2y$10$RloPgfmVqJFlkLonboDYOuyw0SYx2ICgjRDbgNzCxxz0cJiItrreS', 7, 1, NULL, '2015-05-09 21:22:30', '2015-05-09 21:22:30');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `ventas`
--

CREATE TABLE IF NOT EXISTS `ventas` (
  `id_venta` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `id_cliente` int(10) unsigned NOT NULL,
  `id_empleado` int(10) unsigned NOT NULL,
  `id_sucursal` int(10) unsigned NOT NULL,
  `total` decimal(12,2) NOT NULL,
  `detalles` varchar(150) COLLATE utf8_spanish2_ci DEFAULT NULL,
  `habilitado` tinyint(1) NOT NULL DEFAULT '1',
  `created_at` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00',
  `updated_at` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00',
  PRIMARY KEY (`id_venta`),
  KEY `ventas_id_cliente_foreign` (`id_cliente`),
  KEY `ventas_id_empleado_foreign` (`id_empleado`),
  KEY `ventas_id_sucursal_foreign` (`id_sucursal`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish2_ci AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `ventas_productos`
--

CREATE TABLE IF NOT EXISTS `ventas_productos` (
  `id_ventas_productos` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `id_venta` int(10) unsigned NOT NULL,
  `id_producto` bigint(20) unsigned NOT NULL,
  `cantidad` smallint(6) NOT NULL,
  `precio_unitario` decimal(12,2) NOT NULL,
  `habilitado` tinyint(1) NOT NULL DEFAULT '1',
  `created_at` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00',
  `updated_at` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00',
  PRIMARY KEY (`id_ventas_productos`),
  KEY `ventas_productos_id_venta_foreign` (`id_venta`),
  KEY `ventas_productos_id_producto_foreign` (`id_producto`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish2_ci AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `ventas_tipo_de_pago`
--

CREATE TABLE IF NOT EXISTS `ventas_tipo_de_pago` (
  `id_ventas_tipo_de_pago` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `id_venta` int(10) unsigned NOT NULL,
  `id_tipo_de_pago` int(10) unsigned NOT NULL,
  `importe_pagado` decimal(12,2) NOT NULL,
  `habilitado` tinyint(1) NOT NULL DEFAULT '1',
  `created_at` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00',
  `updated_at` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00',
  PRIMARY KEY (`id_ventas_tipo_de_pago`),
  KEY `ventas_tipo_de_pago_id_venta_foreign` (`id_venta`),
  KEY `ventas_tipo_de_pago_id_tipo_de_pago_foreign` (`id_tipo_de_pago`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish2_ci AUTO_INCREMENT=1 ;

--
-- Restricciones para tablas volcadas
--

--
-- Filtros para la tabla `clientes`
--
ALTER TABLE `clientes`
  ADD CONSTRAINT `clientes_id_tipo_de_cliente_foreign` FOREIGN KEY (`id_tipo_de_cliente`) REFERENCES `tipos_de_clientes` (`id_tipo_de_cliente`),
  ADD CONSTRAINT `clientes_id_datos_personales_foreign` FOREIGN KEY (`id_datos_personales`) REFERENCES `datos_personales` (`id_datos_personales`);

--
-- Filtros para la tabla `compras`
--
ALTER TABLE `compras`
  ADD CONSTRAINT `compras_id_empleado_foreign` FOREIGN KEY (`id_empleado`) REFERENCES `empleados` (`id_empleado`),
  ADD CONSTRAINT `compras_id_proveedor_foreign` FOREIGN KEY (`id_proveedor`) REFERENCES `proveedores` (`id_proveedor`),
  ADD CONSTRAINT `compras_id_sucursal_foreign` FOREIGN KEY (`id_sucursal`) REFERENCES `sucursales` (`id_sucursal`);

--
-- Filtros para la tabla `compras_productos`
--
ALTER TABLE `compras_productos`
  ADD CONSTRAINT `compras_productos_id_producto_foreign` FOREIGN KEY (`id_producto`) REFERENCES `productos` (`id_producto`),
  ADD CONSTRAINT `compras_productos_id_compra_foreign` FOREIGN KEY (`id_compra`) REFERENCES `compras` (`id_compra`);

--
-- Filtros para la tabla `compras_tipo_de_pago`
--
ALTER TABLE `compras_tipo_de_pago`
  ADD CONSTRAINT `compras_tipo_de_pago_id_tipo_de_pago_foreign` FOREIGN KEY (`id_tipo_de_pago`) REFERENCES `tipos_de_pagos` (`id_tipo_de_pago`),
  ADD CONSTRAINT `compras_tipo_de_pago_id_compra_foreign` FOREIGN KEY (`id_compra`) REFERENCES `compras` (`id_compra`);

--
-- Filtros para la tabla `devoluciones`
--
ALTER TABLE `devoluciones`
  ADD CONSTRAINT `devoluciones_id_producto_cambio_foreign` FOREIGN KEY (`id_producto_cambio`) REFERENCES `sucursales_productos` (`id_producto`),
  ADD CONSTRAINT `devoluciones_id_empleado_foreign` FOREIGN KEY (`id_empleado`) REFERENCES `empleados` (`id_empleado`),
  ADD CONSTRAINT `devoluciones_id_producto_devuelto_foreign` FOREIGN KEY (`id_producto_devuelto`) REFERENCES `sucursales_productos` (`id_producto`),
  ADD CONSTRAINT `devoluciones_id_sucursal_foreign` FOREIGN KEY (`id_sucursal`) REFERENCES `sucursales_productos` (`id_sucursal`);

--
-- Filtros para la tabla `egresos`
--
ALTER TABLE `egresos`
  ADD CONSTRAINT `egresos_id_sucursal_foreign` FOREIGN KEY (`id_sucursal`) REFERENCES `sucursales` (`id_sucursal`),
  ADD CONSTRAINT `egresos_id_empleado_foreign` FOREIGN KEY (`id_empleado`) REFERENCES `empleados` (`id_empleado`);

--
-- Filtros para la tabla `empleados`
--
ALTER TABLE `empleados`
  ADD CONSTRAINT `empleados_id_sucursal_foreign` FOREIGN KEY (`id_sucursal`) REFERENCES `sucursales` (`id_sucursal`),
  ADD CONSTRAINT `empleados_id_datos_personales_foreign` FOREIGN KEY (`id_datos_personales`) REFERENCES `datos_personales` (`id_datos_personales`),
  ADD CONSTRAINT `empleados_id_tipo_de_empleado_foreign` FOREIGN KEY (`id_tipo_de_empleado`) REFERENCES `tipos_de_empleados` (`id_tipo_de_empleado`);

--
-- Filtros para la tabla `productos`
--
ALTER TABLE `productos`
  ADD CONSTRAINT `productos_id_categoria_de_producto_foreign` FOREIGN KEY (`id_categoria_de_producto`) REFERENCES `categorias_de_productos` (`id_categoria_de_producto`);

--
-- Filtros para la tabla `sucursales_productos`
--
ALTER TABLE `sucursales_productos`
  ADD CONSTRAINT `sucursales_productos_id_producto_foreign` FOREIGN KEY (`id_producto`) REFERENCES `productos` (`id_producto`),
  ADD CONSTRAINT `sucursales_productos_id_sucursal_foreign` FOREIGN KEY (`id_sucursal`) REFERENCES `sucursales` (`id_sucursal`);

--
-- Filtros para la tabla `transferencias`
--
ALTER TABLE `transferencias`
  ADD CONSTRAINT `transferencias_id_producto_foreign` FOREIGN KEY (`id_producto`) REFERENCES `productos` (`id_producto`),
  ADD CONSTRAINT `transferencias_id_empleado_foreign` FOREIGN KEY (`id_empleado`) REFERENCES `empleados` (`id_empleado`),
  ADD CONSTRAINT `transferencias_id_sucursal_destino_foreign` FOREIGN KEY (`id_sucursal_destino`) REFERENCES `sucursales` (`id_sucursal`),
  ADD CONSTRAINT `transferencias_id_sucursal_origen_foreign` FOREIGN KEY (`id_sucursal_origen`) REFERENCES `sucursales` (`id_sucursal`);

--
-- Filtros para la tabla `usuarios`
--
ALTER TABLE `usuarios`
  ADD CONSTRAINT `usuarios_id_empleado_foreign` FOREIGN KEY (`id_empleado`) REFERENCES `empleados` (`id_empleado`);

--
-- Filtros para la tabla `ventas`
--
ALTER TABLE `ventas`
  ADD CONSTRAINT `ventas_id_sucursal_foreign` FOREIGN KEY (`id_sucursal`) REFERENCES `sucursales` (`id_sucursal`),
  ADD CONSTRAINT `ventas_id_cliente_foreign` FOREIGN KEY (`id_cliente`) REFERENCES `clientes` (`id_cliente`),
  ADD CONSTRAINT `ventas_id_empleado_foreign` FOREIGN KEY (`id_empleado`) REFERENCES `empleados` (`id_empleado`);

--
-- Filtros para la tabla `ventas_productos`
--
ALTER TABLE `ventas_productos`
  ADD CONSTRAINT `ventas_productos_id_producto_foreign` FOREIGN KEY (`id_producto`) REFERENCES `productos` (`id_producto`),
  ADD CONSTRAINT `ventas_productos_id_venta_foreign` FOREIGN KEY (`id_venta`) REFERENCES `ventas` (`id_venta`);

--
-- Filtros para la tabla `ventas_tipo_de_pago`
--
ALTER TABLE `ventas_tipo_de_pago`
  ADD CONSTRAINT `ventas_tipo_de_pago_id_tipo_de_pago_foreign` FOREIGN KEY (`id_tipo_de_pago`) REFERENCES `tipos_de_pagos` (`id_tipo_de_pago`),
  ADD CONSTRAINT `ventas_tipo_de_pago_id_venta_foreign` FOREIGN KEY (`id_venta`) REFERENCES `ventas` (`id_venta`);


