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

CREATE PROCEDURE `SPD_CONSULTAR_IMPORTES_VENTAS`(id int)
BEGIN
		select v.id_venta, 
			vtp.id_tipo_de_pago, vtp.importe_pagado,
			tp.tipo_de_pago
		from ventas as v, 
			ventas_tipo_de_pago as vtp,
			tipos_de_pagos as tp
		where v.id_venta=id
			and v.id_venta=vtp.id_venta 
			and vtp.id_tipo_de_pago=tp.id_tipo_de_pago;
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
(1, 'Beauty', 1, '2015-05-12 05:00:35', '2015-05-12 05:00:35'),
(2, 'Complemento', 1, '2015-05-12 05:00:35', '2015-05-12 05:00:35'),
(3, 'Fitness', 1, '2015-05-12 05:00:35', '2015-05-12 05:00:35'),
(4, 'Varios', 1, '2015-05-12 05:00:35', '2015-05-12 05:00:35');

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
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COLLATE=utf8_spanish2_ci AUTO_INCREMENT=6 ;

--
-- Volcado de datos para la tabla `clientes`
--

INSERT INTO `clientes` (`id_cliente`, `id_datos_personales`, `id_tipo_de_cliente`, `habilitado`, `created_at`, `updated_at`) VALUES
(1, 5, 1, 1, '2015-05-12 05:00:35', '2015-05-12 05:00:35'),
(2, 6, 2, 1, '2015-05-12 05:00:35', '2015-05-21 23:40:52'),
(3, 12, 3, 1, '2015-05-21 23:41:29', '2015-05-21 23:41:29'),
(4, 13, 4, 1, '2015-05-21 23:41:55', '2015-05-21 23:41:55'),
(5, 14, 5, 1, '2015-05-21 23:42:23', '2015-05-21 23:42:23');

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
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COLLATE=utf8_spanish2_ci AUTO_INCREMENT=4 ;

--
-- Volcado de datos para la tabla `compras`
--

INSERT INTO `compras` (`id_compra`, `id_sucursal`, `id_proveedor`, `id_empleado`, `numero_de_nota`, `total`, `fecha`, `detalles`, `habilitado`, `created_at`, `updated_at`) VALUES
(3, 1, 2, 1, '', 116866.00, '2015-07-14', ' ', 1, '2015-07-14 17:55:44', '2015-07-14 17:55:44');

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
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COLLATE=utf8_spanish2_ci AUTO_INCREMENT=2 ;

--
-- Volcado de datos para la tabla `compras_productos`
--

INSERT INTO `compras_productos` (`id_compras_productos`, `id_compra`, `id_producto`, `cantidad`, `fecha_caducidad`, `precio_unitario`, `habilitado`, `created_at`, `updated_at`) VALUES
(1, 3, 1, 142, '2015-10-06', 823.00, 1, '2015-07-14 17:55:44', '2015-07-14 17:55:44');

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
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COLLATE=utf8_spanish2_ci AUTO_INCREMENT=15 ;

--
-- Volcado de datos para la tabla `datos_personales`
--

INSERT INTO `datos_personales` (`id_datos_personales`, `nombre`, `apellido_paterno`, `apellido_materno`, `fecha_nacimiento`, `genero`, `calle`, `colonia`, `delegacion`, `estado`, `cp`, `telefono`, `email`, `rfc`, `habilitado`, `created_at`, `updated_at`) VALUES
(1, 'Mauricio', 'Garces', '', '1979-07-02', 0, '', '', '', '', '', '', '', '', 1, '2015-05-12 05:00:35', '2015-07-14 17:58:40'),
(2, 'copilco', 'c', NULL, '1987-02-24', 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, '2015-05-12 05:00:35', '2015-05-12 05:00:35'),
(3, 'ajusco', 'a', NULL, '1975-06-08', 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, '2015-05-12 05:00:35', '2015-05-12 05:00:35'),
(4, 'valle', 'v', NULL, '2031-07-08', 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, '2015-05-12 05:00:35', '2015-05-12 05:00:35'),
(5, 'cliente de mostrador', 'c', NULL, '2007-07-08', 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, '2015-05-12 05:00:35', '2015-05-12 05:00:35'),
(6, 'Normal', 'cliente', 'normal', '2016-06-04', 1, 'calle13', '', '', '', '', '', '', '', 1, '2015-05-12 05:00:35', '2015-05-21 23:40:52'),
(7, 'empleado', 'ajusco', 'primero', '2025-12-24', 1, 'calle1', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, '2015-05-12 05:00:35', '2015-05-12 05:00:35'),
(8, 'empleado', 'copilco', 'primero', '1976-01-11', 1, 'calle1', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, '2015-05-12 05:00:35', '2015-05-12 05:00:35'),
(9, 'empleado', 'valle', 'primero', '2001-09-30', 1, 'calle1', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, '2015-05-12 05:00:35', '2015-05-12 05:00:35'),
(10, 'Mauricio', 'G', 'B', '1989-12-25', 0, '', '', '', '', '', '', '', '', 1, '2015-05-12 16:17:37', '2015-05-12 16:17:37'),
(11, 'otro', 'asd', '', '2015-05-12', 0, '', '', '', '', '', '', '', '', 1, '2015-05-12 16:21:07', '2015-05-12 16:21:17'),
(12, 'Cliente', 'Tienda', '', '1985-10-24', 1, '', '', '', '', '', '', '', '', 1, '2015-05-21 23:41:29', '2015-05-21 23:41:29'),
(13, 'Cliente', 'Distribuidor', '', '1984-04-06', 0, '', '', '', '', '', '', '', '', 1, '2015-05-21 23:41:55', '2015-05-21 23:41:55'),
(14, 'Cliente', 'Revendedor', '', '1988-10-25', 1, '', '', '', '', '', '', '', '', 1, '2015-05-21 23:42:23', '2015-05-21 23:42:23');

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
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COLLATE=utf8_spanish2_ci AUTO_INCREMENT=3 ;

--
-- Volcado de datos para la tabla `egresos`
--

INSERT INTO `egresos` (`id_egreso`, `id_empleado`, `id_sucursal`, `importe`, `concepto`, `habilitado`, `created_at`, `updated_at`) VALUES
(1, 1, 1, 0.00, 'nada', 1, '2015-07-14 17:57:45', '2015-07-14 17:57:45'),
(2, 1, 1, 22.00, 'no acepta negativos?', 1, '2015-07-14 17:58:12', '2015-07-14 17:58:12');

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
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COLLATE=utf8_spanish2_ci AUTO_INCREMENT=10 ;

--
-- Volcado de datos para la tabla `empleados`
--

INSERT INTO `empleados` (`id_empleado`, `id_datos_personales`, `id_tipo_de_empleado`, `id_sucursal`, `habilitado`, `created_at`, `updated_at`) VALUES
(1, 1, 1, 1, 1, '2015-05-12 05:00:35', '2015-07-14 17:58:40'),
(2, 2, 3, 1, 1, '2015-05-12 05:00:35', '2015-05-12 05:00:35'),
(3, 3, 3, 2, 1, '2015-05-12 05:00:35', '2015-05-12 05:00:35'),
(4, 4, 3, 3, 1, '2015-05-12 05:00:35', '2015-05-12 05:00:35'),
(5, 7, 4, 1, 1, '2015-05-12 05:00:35', '2015-05-12 05:00:35'),
(6, 8, 4, 2, 1, '2015-05-12 05:00:35', '2015-05-12 05:00:35'),
(7, 9, 4, 3, 1, '2015-05-12 05:00:35', '2015-05-12 05:00:35'),
(8, 10, 2, 1, 1, '2015-05-12 16:17:37', '2015-05-12 16:17:37'),
(9, 11, 4, 3, 1, '2015-05-12 16:21:07', '2015-05-12 16:21:17');

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
(1, 3, 'algo', 'el codigo es 001', 823.00, 876.00, 1, '2015-07-14 17:53:30', '2015-07-14 17:53:30'),
(646511016033, 2, 'MYOFUSION', 'CHOCOLATE', 819.00, 819.00, 1, '2015-07-14 17:50:46', '2015-07-14 17:50:46'),
(7501055319053, 4, 'CIEL AGUA 1L', 'sabor mandarina', 15.00, 15.00, 1, '2015-07-14 17:51:58', '2015-07-14 17:56:13'),
(7503016015035, 3, 'BARRINOLA', 'cafe', 7.00, 7.00, 1, '2015-07-14 17:52:32', '2015-07-14 17:52:32');

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
(1, 'Compra directa', 'compra directa', '123456789', '123456789', 'compradirecta@compradirecta.com', NULL, 1, '2015-05-12 05:00:35', '2015-05-12 05:00:35'),
(2, 'Genesis', 'Hidalgo 895', '0987654321123', '1231231231', 'gen@hola.com', NULL, 1, '2015-05-12 05:00:35', '2015-05-12 05:00:35'),
(3, 'GNC', 'Mexico 86', '12345', '5654441234', 'gnc@gnc.com', NULL, 1, '2015-05-12 05:00:35', '2015-05-12 05:00:35'),
(4, 'VPX', 'Morelos 656', '12345', '5560441234', 'vpx@hola.com', NULL, 1, '2015-05-12 05:00:35', '2015-05-12 05:00:35'),
(5, 'Muscle', 'Universidad 1246', '1234567890123', '5560441234', 'muscle@hola.com', NULL, 1, '2015-05-12 05:00:35', '2015-05-12 05:00:35');

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
(1, 'frecuente', 1.00, 1000.00, 1.00, 'En la compra de 2 o mas productos\n                        y hasta $1000 aplica precio de cliente frecuente', 1, '2015-05-12 05:00:35', '2015-05-12 05:00:35'),
(2, 'publico', 1.00, 1.00, 1.05, 'En la compra de 1 solo producto\n                        aplica precio publico, %5 mas del precio de\n                        cliente frecuente', 1, '2015-05-12 05:00:35', '2015-05-12 05:00:35'),
(3, 'distribuidor', 1001.00, 5000.00, 0.95, 'En la compra de $1000 a $5000 \n                        aplica precio distribuidor, %5 de descuento', 1, '2015-05-12 05:00:35', '2015-05-12 05:00:35'),
(4, 'mayorista1', 5001.00, 10000.00, 0.92, 'En la compra de $5000 a $10000 \n                        aplica precio mayorista1, %8 de descuento', 1, '2015-05-12 05:00:35', '2015-05-12 05:00:35'),
(5, 'mayorista2', 10001.00, 100000.00, 0.85, 'En la compra de $10000 a $100000 \n                        aplica precio mayorista2, %15 de descuento', 1, '2015-05-12 05:00:35', '2015-05-12 05:00:35'),
(6, 'mayorista3', 100001.00, 9999999999.00, 0.81, 'En la compra de mas de $100000 \n                        aplica precio mayorista3, %19.25 de descuento', 1, '2015-05-12 05:00:35', '2015-05-12 05:00:35'),
(7, 'frecuente fitness', 2.00, 9.00, 0.90, 'De 2 a 9 piezas en los productos \n                         fitness se hace un 10% de descuento', 1, '2015-05-12 05:00:35', '2015-05-12 05:00:35'),
(8, 'publico fitness', 1.00, 1.00, 1.00, '1 pieza en los productos \n                         fitness no se hace descuento', 1, '2015-05-12 05:00:35', '2015-05-12 05:00:35'),
(9, 'distribuidor fitness', 10.00, 19.00, 0.85, 'De 10 a 19 piezas en los productos \n                         fitness se hace un 15% de descuento', 1, '2015-05-12 05:00:35', '2015-05-12 05:00:35'),
(10, 'mayorista1 fitness', 20.00, 29.00, 0.80, 'De 20 a 29 piezas en los productos \n                         fitness se hace un 20% de descuento', 1, '2015-05-12 05:00:35', '2015-05-12 05:00:35'),
(11, 'mayorista2 fitness', 30.00, 50.00, 0.70, 'De 30 a 50 piezas en los productos \n                         fitness se hace un 30% de descuento', 1, '2015-05-12 05:00:35', '2015-05-12 05:00:35'),
(12, 'mayorista3 fitness', 50.00, 9999999999.00, 0.60, 'Mas de 50 piezas en los productos \n                         fitness se hace un 40% de descuento', 1, '2015-05-12 05:00:35', '2015-05-12 05:00:35');

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
(1, 'Copilco', 'Hidalgo 895', '1231231231', 'gen@hola.com', 1, '2015-05-12 05:00:35', '2015-05-12 05:00:35'),
(2, 'Ajusco', 'Mexico 86', '5654441234', 'dsa@hola.com', 1, '2015-05-12 05:00:35', '2015-05-12 05:00:35'),
(3, 'Del Valle', 'Morelos 656', '5560441234', 'asd@hola.com', 1, '2015-05-12 05:00:35', '2015-05-12 05:00:35');

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
(1001, 1, 1, 142, 20, 1, '2015-07-14 17:53:30', '2015-07-14 17:53:30'),
(2001, 2, 1, 0, 0, 1, '2015-07-14 17:53:30', '2015-07-14 17:53:30'),
(3001, 3, 1, 0, 0, 1, '2015-07-14 17:53:30', '2015-07-14 17:53:30'),
(1646511016033, 1, 646511016033, 0, 0, 1, '2015-07-14 17:50:46', '2015-07-14 17:50:46'),
(2646511016033, 2, 646511016033, 0, 0, 1, '2015-07-14 17:50:46', '2015-07-14 17:50:46'),
(3646511016033, 3, 646511016033, 0, 0, 1, '2015-07-14 17:50:46', '2015-07-14 17:50:46'),
(17501055319053, 1, 7501055319053, 0, 0, 1, '2015-07-14 17:51:58', '2015-07-14 17:51:58'),
(17503016015035, 1, 7503016015035, 0, 0, 1, '2015-07-14 17:52:32', '2015-07-14 17:52:32'),
(27501055319053, 2, 7501055319053, 0, 0, 1, '2015-07-14 17:51:58', '2015-07-14 17:51:58'),
(27503016015035, 2, 7503016015035, 0, 0, 1, '2015-07-14 17:52:32', '2015-07-14 17:52:32'),
(37501055319053, 3, 7501055319053, 0, 0, 1, '2015-07-14 17:51:58', '2015-07-14 17:51:58'),
(37503016015035, 3, 7503016015035, 0, 0, 1, '2015-07-14 17:52:32', '2015-07-14 17:52:32');

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
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COLLATE=utf8_spanish2_ci AUTO_INCREMENT=6 ;

--
-- Volcado de datos para la tabla `tipos_de_clientes`
--

INSERT INTO `tipos_de_clientes` (`id_tipo_de_cliente`, `tipo_de_cliente`, `descripcion`, `habilitado`, `created_at`, `updated_at`) VALUES
(1, 'cliente de mostrador', 'cliente no registrado en el sistema', 1, '2015-05-12 05:00:35', '2015-05-12 05:00:35'),
(2, 'Normal', 'Sin descuento', 1, '2015-05-12 05:00:35', '2015-05-21 23:39:39'),
(3, 'Tienda', 'Descuento Mayoreo 3', 1, '2015-05-12 05:00:35', '2015-05-21 23:39:20'),
(4, 'Distribuidor', 'Descuento Mayoreo 2', 1, '2015-05-12 05:00:35', '2015-05-21 23:40:05'),
(5, 'Revendedor', 'Descuento Mayoreo 1', 1, '2015-05-21 23:40:26', '2015-05-21 23:40:26');

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
(1, 'administrador', 'administra todo el sistema y sucursales', 1, '2015-05-12 05:00:35', '2015-05-12 05:00:35'),
(2, 'gerente general', 'administra varias sucursales', 1, '2015-05-12 05:00:35', '2015-05-12 05:00:35'),
(3, 'gerente de sucursal', 'arministra una sucursal', 1, '2015-05-12 05:00:35', '2015-05-12 05:00:35'),
(4, 'vendedor', 'ventas, devoluciones, inventario', 1, '2015-05-12 05:00:35', '2015-05-12 05:00:35');

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
(1, 'Efectivo', 1, '2015-05-12 05:00:35', '2015-05-12 05:00:35'),
(2, 'Tarjeta', 1, '2015-05-12 05:00:35', '2015-05-12 05:00:35'),
(3, 'Deposito', 1, '2015-05-12 05:00:35', '2015-05-12 05:00:35'),
(4, 'Cheque', 1, '2015-05-12 05:00:35', '2015-05-12 05:00:35');

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
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COLLATE=utf8_spanish2_ci AUTO_INCREMENT=2 ;

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
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COLLATE=utf8_spanish2_ci AUTO_INCREMENT=10 ;

--
-- Volcado de datos para la tabla `usuarios`
--

INSERT INTO `usuarios` (`id_usuario`, `username`, `password`, `id_empleado`, `habilitado`, `remember_token`, `created_at`, `updated_at`) VALUES
(1, 'superadmin', '$2y$10$8tqFAoXna/.EaRKjjyrXlOqcOSSPcQqJNrRZvII3JhaNeXOlxgqWe', 1, 1, 'H7tuiJ8CeGy3SrtsRxPCKDS7xRNJXsmVdIMbyDpK2Ot5viFOEfxsmkrLWEx8', '2015-05-12 05:00:35', '2015-07-14 17:58:51'),
(2, 'copilco', '$2y$10$R6sNxi2uYPdgbalgUfEr2e3QpLA66IgvkTbA.ukCNvc.po2.rHo2O', 2, 1, NULL, '2015-05-12 05:00:35', '2015-05-12 05:00:35'),
(3, 'ajusco', '$2y$10$dciK2v.sSVGoGRassXPnj.RMdTs4fijuUD9tzqjwY1ziHM/tPHpse', 3, 1, NULL, '2015-05-12 05:00:35', '2015-05-12 05:00:35'),
(4, 'valle', '$2y$10$IKKfBY46McAcYB/1KFUrl.NrX.hOar8RCNH1s7hLc4MeKzPHH.9Me', 4, 1, NULL, '2015-05-12 05:00:35', '2015-05-12 05:00:35'),
(5, 'ajuscoe', '$2y$10$IMEjZ0p6qnUR2aC4IbdUNezyFfaCyHBbyCb.G6wSua.37jSw0PWiW', 5, 1, NULL, '2015-05-12 05:00:35', '2015-05-12 05:00:35'),
(6, 'copilcoe', '$2y$10$39xg5r0QSoNekScizrbmJeWhZKd0.dc2PcDTHhEFJxc/CtpRmGubK', 6, 1, NULL, '2015-05-12 05:00:35', '2015-05-12 05:00:35'),
(7, 'vallee', '$2y$10$wjmlO7gTH0JmRMcHJ7pGqe4KqFyLQd.zHOLqK1aKdhgyoiIWvtLPu', 7, 1, NULL, '2015-05-12 05:00:35', '2015-05-12 05:00:35'),
(8, 'mau', '$2y$10$E7iFgaGWxSIWKYC.qwaNyekH.v5oVWMLwmxnubJ.HB5vCtu5Nm7HK', 8, 1, NULL, '2015-05-12 16:17:37', '2015-05-12 16:17:37'),
(9, 'x', '$2y$10$GIrz69mLdW0NTjnQLcEOSepIuPgTIr0qUkU2kzzIVfQbV4xd0WQ/K', 9, 1, NULL, '2015-05-12 16:21:07', '2015-05-12 16:21:17');

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
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COLLATE=utf8_spanish2_ci AUTO_INCREMENT=5 ;

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
  ADD CONSTRAINT `clientes_id_datos_personales_foreign` FOREIGN KEY (`id_datos_personales`) REFERENCES `datos_personales` (`id_datos_personales`),
  ADD CONSTRAINT `clientes_id_tipo_de_cliente_foreign` FOREIGN KEY (`id_tipo_de_cliente`) REFERENCES `tipos_de_clientes` (`id_tipo_de_cliente`);

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
  ADD CONSTRAINT `compras_productos_id_compra_foreign` FOREIGN KEY (`id_compra`) REFERENCES `compras` (`id_compra`),
  ADD CONSTRAINT `compras_productos_id_producto_foreign` FOREIGN KEY (`id_producto`) REFERENCES `productos` (`id_producto`);

--
-- Filtros para la tabla `compras_tipo_de_pago`
--
ALTER TABLE `compras_tipo_de_pago`
  ADD CONSTRAINT `compras_tipo_de_pago_id_compra_foreign` FOREIGN KEY (`id_compra`) REFERENCES `compras` (`id_compra`),
  ADD CONSTRAINT `compras_tipo_de_pago_id_tipo_de_pago_foreign` FOREIGN KEY (`id_tipo_de_pago`) REFERENCES `tipos_de_pagos` (`id_tipo_de_pago`);

--
-- Filtros para la tabla `devoluciones`
--
ALTER TABLE `devoluciones`
  ADD CONSTRAINT `devoluciones_id_empleado_foreign` FOREIGN KEY (`id_empleado`) REFERENCES `empleados` (`id_empleado`),
  ADD CONSTRAINT `devoluciones_id_producto_cambio_foreign` FOREIGN KEY (`id_producto_cambio`) REFERENCES `sucursales_productos` (`id_producto`),
  ADD CONSTRAINT `devoluciones_id_producto_devuelto_foreign` FOREIGN KEY (`id_producto_devuelto`) REFERENCES `sucursales_productos` (`id_producto`),
  ADD CONSTRAINT `devoluciones_id_sucursal_foreign` FOREIGN KEY (`id_sucursal`) REFERENCES `sucursales_productos` (`id_sucursal`);

--
-- Filtros para la tabla `egresos`
--
ALTER TABLE `egresos`
  ADD CONSTRAINT `egresos_id_empleado_foreign` FOREIGN KEY (`id_empleado`) REFERENCES `empleados` (`id_empleado`),
  ADD CONSTRAINT `egresos_id_sucursal_foreign` FOREIGN KEY (`id_sucursal`) REFERENCES `sucursales` (`id_sucursal`);

--
-- Filtros para la tabla `empleados`
--
ALTER TABLE `empleados`
  ADD CONSTRAINT `empleados_id_datos_personales_foreign` FOREIGN KEY (`id_datos_personales`) REFERENCES `datos_personales` (`id_datos_personales`),
  ADD CONSTRAINT `empleados_id_sucursal_foreign` FOREIGN KEY (`id_sucursal`) REFERENCES `sucursales` (`id_sucursal`),
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
  ADD CONSTRAINT `transferencias_id_empleado_foreign` FOREIGN KEY (`id_empleado`) REFERENCES `empleados` (`id_empleado`),
  ADD CONSTRAINT `transferencias_id_producto_foreign` FOREIGN KEY (`id_producto`) REFERENCES `productos` (`id_producto`),
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
  ADD CONSTRAINT `ventas_id_cliente_foreign` FOREIGN KEY (`id_cliente`) REFERENCES `clientes` (`id_cliente`),
  ADD CONSTRAINT `ventas_id_empleado_foreign` FOREIGN KEY (`id_empleado`) REFERENCES `empleados` (`id_empleado`),
  ADD CONSTRAINT `ventas_id_sucursal_foreign` FOREIGN KEY (`id_sucursal`) REFERENCES `sucursales` (`id_sucursal`);

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


