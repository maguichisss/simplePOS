--PROCEDURES EMPLEADOS
	--consulta todos los empleados
	delimiter //
	DROP PROCEDURE IF EXISTS SPD_CONSULTAR_EMPLEADOS //
	CREATE PROCEDURE SPD_CONSULTAR_EMPLEADOS()
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

	END
	//
	delimiter ;

	--consulta los empleados de una sucursal
	delimiter //
	DROP PROCEDURE IF EXISTS SPD_CONSULTA_EMPLEADOS_SUCURSAL //
	CREATE PROCEDURE SPD_CONSULTA_EMPLEADOS_SUCURSAL( id int)
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

	END
	//
	delimiter ;

	--consulta un empleado
	delimiter //
	DROP PROCEDURE IF EXISTS SPD_CONSULTA_EMPLEADO //
	CREATE PROCEDURE SPD_CONSULTA_EMPLEADO( id int)
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

	END
	//
	delimiter ;

--PROCEDURES PRODUCTOS
	--consulta todos los productos de todas las sucursales
	delimiter //
	DROP PROCEDURE IF EXISTS SPD_CONSULTAR_PRODUCTOS_SUCURSALES //
	CREATE PROCEDURE SPD_CONSULTAR_PRODUCTOS_SUCURSALES()
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
			and p.id_categoria_de_producto=cdp.id_categoria_de_producto
		order by p.nombre_producto ;

	END
	//
	delimiter ;
	
	--consulta todos los productos de una sucursal
	delimiter //
	DROP PROCEDURE IF EXISTS SPD_CONSULTAR_PRODUCTOS_SUCURSAL //
	CREATE PROCEDURE SPD_CONSULTAR_PRODUCTOS_SUCURSAL( idSucursal int)
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
	END
	//
	delimiter ;

	--consulta un producto de una sucursal
	delimiter //
	DROP PROCEDURE IF EXISTS SPD_CONSULTA_PRODUCTO_SUCURSAL //
	CREATE PROCEDURE SPD_CONSULTA_PRODUCTO_SUCURSAL( idSucursal int, idProducto bigint)
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

	END
	//
	delimiter ;

--PROCEDURES CLIENTES
	delimiter //
	DROP PROCEDURE IF EXISTS SPD_CONSULTAR_CLIENTES //
	CREATE PROCEDURE SPD_CONSULTAR_CLIENTES()
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
	END
	//
	delimiter ;



	delimiter //
	DROP PROCEDURE IF EXISTS SPD_CONSULTA_CLIENTE //
	CREATE PROCEDURE SPD_CONSULTA_CLIENTE( id int)
	BEGIN
		select c.id_cliente,
			c.id_tipo_de_cliente,
			dp.*
		from datos_personales as dp,
			clientes as c
		where c.id_cliente=id
			and c.id_datos_personales=dp.id_datos_personales;
	END
	//
	delimiter ;


	delimiter //
	DROP PROCEDURE IF EXISTS SPD_CONSULTAR_CLIENTES_LIKE //
	CREATE PROCEDURE SPD_CONSULTAR_CLIENTES_LIKE( term VARCHAR)
	BEGIN
		select c.id_cliente,
			dp.* , 
			tc.tipo_de_cliente
		from datos_personales as dp,
			clientes as c, 
			tipos_de_clientes as tc
		where c.id_cliente <> 1
			and c.id_datos_personales=dp.id_datos_personales
			and c.id_tipo_de_cliente=tc.id_tipo_de_cliente
			and (c.id_cliente like '%'term'%' 
				or dp.nombre like '%'term'%' 
				or dp.apellido_paterno like '%'term'%');
	END
	//
	delimiter ;

--PROCEDURES VENTAS
	--consulta TODAS las ventas con su nombre de empleado
	delimiter //
	DROP PROCEDURE IF EXISTS SPD_CONSULTAR_VENTAS //
	CREATE PROCEDURE SPD_CONSULTAR_VENTAS()
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
	END
	//
	delimiter ;

	--consulta TODAS las ventas de una sucursal si la venta esta deshabilitada
	delimiter //
	DROP PROCEDURE IF EXISTS SPD_CONSULTAR_VENTAS_SUCURSAL_PARACORTE //
	CREATE PROCEDURE SPD_CONSULTAR_VENTAS_SUCURSAL_PARACORTE(id int)
	BEGIN
		select v.*,
			dp.nombre, dp.apellido_paterno
		from datos_personales as dp,
			ventas as v, 
			empleados as e
		where v.id_sucursal=id
			and v.id_empleado=e.id_empleado
			and e.id_datos_personales=dp.id_datos_personales;
	END
	//
	delimiter ;

	--consulta TODAS las ventas con su empleado si la venta esta deshabilitada
	delimiter //
	DROP PROCEDURE IF EXISTS SPD_CONSULTAR_VENTAS_PARACORTE //
	CREATE PROCEDURE SPD_CONSULTAR_VENTAS_PARACORTE()
	BEGIN
		select v.*,
			dp.nombre, dp.apellido_paterno
		from datos_personales as dp,
			ventas as v, 
			empleados as e
		where v.id_empleado=e.id_empleado
			and e.id_datos_personales=dp.id_datos_personales;
	END
	//
	delimiter ;

	--consulta TODAS las ventas de un empleado
	delimiter //
	DROP PROCEDURE IF EXISTS SPD_CONSULTAR_VENTAS_EMPLEADO_PARACORTE //
	CREATE PROCEDURE SPD_CONSULTAR_VENTAS_EMPLEADO_PARACORTE(id int)
	BEGIN
		select v.*,
			dp.nombre, dp.apellido_paterno
		from datos_personales as dp,
			ventas as v, 
			empleados as e
		where e.id_empleado=id
			and v.id_empleado=e.id_empleado
			and e.id_datos_personales=dp.id_datos_personales;
	END
	//
	delimiter ;


	--consulta TIPOS DE PAGO y CANTIDADES de la venta
	delimiter //
	DROP PROCEDURE IF EXISTS SPD_CONSULTAR_VENTAS_EMPLEADO_PARACORTE //
	CREATE PROCEDURE SPD_CONSULTAR_IMPORTES_VENTAS(id int)
	BEGIN
		select v.id_venta, v.id_empleado, 
			vtp.id_tipo_de_pago, sum(vtp.importe_pagado),
			tp.tipo_de_pago
		from ventas as v, 
			ventas_tipo_de_pago as vtp,
			tipos_de_pagos as tp
		where v.id_empleado=id
			and v.id_venta=vtp.id_venta 
			and vtp.id_tipo_de_pago=tp.id_tipo_de_pago
		group by vtp.id_tipo_de_pago;
	END
	//
	delimiter ;



--PROCEDURES DEVOLUCIONES
	--consulta TODAS las devoluciones con su nombre de empleado
	delimiter //
	DROP PROCEDURE IF EXISTS SPD_CONSULTAR_DEVOLUCIONES //
	CREATE PROCEDURE SPD_CONSULTAR_DEVOLUCIONES()
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
	END
	//
	delimiter ;

	--consulta TODAS las devoluciones
	delimiter //
	DROP PROCEDURE IF EXISTS SPD_CONSULTAR_DEVOLUCIONES_PARACORTE //
	CREATE PROCEDURE SPD_CONSULTAR_DEVOLUCIONES_PARACORTE()
	BEGIN
		select d.*,
			dp.nombre, dp.apellido_paterno
		from datos_personales as dp,
			devoluciones as d, 
			empleados as e
		where d.id_empleado=e.id_empleado
			and e.id_datos_personales=dp.id_datos_personales;
	END
	//
	delimiter ;

	--consulta TODAS las devoluciones de una sucursal
	delimiter //
	DROP PROCEDURE IF EXISTS SPD_CONSULTAR_DEVOLUCIONES_SUCURSAL_PARACORTE //
	CREATE PROCEDURE SPD_CONSULTAR_DEVOLUCIONES_SUCURSAL_PARACORTE(id int)
	BEGIN
		select d.*,
			dp.nombre, dp.apellido_paterno
		from datos_personales as dp,
			devoluciones as d, 
			empleados as e
		where d.id_sucursal=id
			and d.id_empleado=e.id_empleado
			and e.id_datos_personales=dp.id_datos_personales;
	END
	//
	delimiter ;

	--consulta TODAS las devoluciones de un empleado
	delimiter //
	DROP PROCEDURE IF EXISTS SPD_CONSULTAR_DEVOLUCIONES_EMPLEADO_PARACORTE //
	CREATE PROCEDURE SPD_CONSULTAR_DEVOLUCIONES_EMPLEADO_PARACORTE(id int)
	BEGIN
		select d.*,
			dp.nombre, dp.apellido_paterno
		from datos_personales as dp,
			devoluciones as d, 
			empleados as e
		where id=e.id_empleado
			and d.id_empleado=e.id_empleado
			and e.id_datos_personales=dp.id_datos_personales;
	END
	//
	delimiter ;



--OTRAS PRUEBAS Y ALGUNOS QUE NO FUNCIONARON 

	SELECT vp.cantidad, vp.precio_unitario, vp.id_venta,
			p.nombre_producto, p.descripcion
		 FROM ventas_productos as vp, 
		 	productos as p
		 WHERE vp.id_producto=p.id_producto;


	delimiter //
	DROP PROCEDURE IF EXISTS SPD_MODIFICA_EMPLEADO //
	CREATE PROCEDURE SPD_MODIFICA_EMPLEADO(

		in vidEmpleado INT, 
		in vidSucursal INT, 
		in vidTipoEmpleado INT, 
		in vnombre VARCHAR(50), 
		in vapellidoP VARCHAR(30), 
		in vapellidoM VARCHAR(30), 
		in vnacimiento DATE, 
		in vgenero BOOLEAN, 
		in vdireccion VARCHAR(100), 
		in vcp VARCHAR(5), 
		in vtelefono VARCHAR(10), 
		in vemail VARCHAR(45), 
		in vrfc VARCHAR(13),  
		in vusuario VARCHAR(50), 
		in vpassword VARCHAR(60), 
		out result VARCHAR(50))
	BEGIN
		DECLARE vidDatosPersonales INT;
		DECLARE vidUsuario INT;
		DECLARE EXIT HANDLER FOR 1062 SELECT 'Usuario duplicado' INTO result;
		SET result = false;

		IF vidEmpleado = '' THEN SET vidEmpleado = NULL; END IF;
		IF vidSucursal = '' THEN SET vidSucursal = NULL; END IF;
		IF vidTipoEmpleado = '' THEN SET vidTipoEmpleado = NULL; END IF;
		IF vnombre = '' THEN SET vnombre = NULL; END IF;
		IF vapellidoP = '' THEN SET vapellidoP = NULL; END IF;
		IF vapellidoM = '' THEN SET vapellidoM = NULL; END IF;
		IF vnacimiento = '' THEN SET vnacimiento = NULL; END IF;
		IF vgenero = '' THEN SET vgenero = NULL; END IF;
		IF vdireccion = '' THEN SET vdireccion = NULL; END IF;
		IF vcp = '' THEN SET vcp = NULL; END IF;
		IF vtelefono = '' THEN SET vtelefono = NULL; END IF;
		IF vemail = '' THEN SET vemail = NULL; END IF;
		IF vrfc = '' THEN SET vrfc = NULL; END IF;
		IF vusuario = '' THEN SET vusuario = NULL; END IF;
		IF vpassword = '' THEN SET vpassword = NULL; END IF;


		SELECT id_datos_personales INTO vidDatosPersonales
		FROM empleados WHERE id_empleado=vidEmpleado;

		SELECT id_usuario INTO vidUsuario
		FROM usuarios_empleados WHERE id_empleado=vidEmpleado;

		IF vidEmpleado is null THEN 
			SELECT 'Introduce id empleado' INTO result;
		ELSEIF vidDatosPersonales is null THEN 
			SELECT SET result = 'No hay datos del empleado' INTO result;
		ELSEIF vidUsuario is NULL THEN
			SELECT SET result = 'No hay usuario del empleado' INTO result;
		ELSE

			UPDATE usuarios
			SET username=vusuario, password=vpassword
			WHERE id_usuario=vidUsuario;

			UPDATE datos_personales
			SET nombre=vnombre, apellido_paterno=vapellidoP, apellido_materno=vapellidoM,
				fecha_nacimiento=vnacimiento, genero=vgenero, direccion=vdireccion,
				cp=vcp, telefono=vtelefono, email=vemail, rfc=vrfc, updated_at=now()
			WHERE id_datos_personales=vidDatosPersonales;

			UPDATE empleados
			SET id_tipo_de_empleado=vidTipoEmpleado
			WHERE id_empleado=vidEmpleado;

			UPDATE empleados_sucursales
			SET id_sucursal=vidSucursal
			WHERE id_empleado=vidEmpleado;

			SET result = '1';

		END IF;

	END
	//
	delimiter ;

	CALL SPD_MODIFICA_EMPLEADO(40, @value);
	select @value;














	delimiter //

	CREATE PROCEDURE SPD_INSERTAR_EMPLEADO
	(
		@nombre VARCHAR(50),
		@apellido_paterno VARCHAR(30),
		@apellido_materno VARCHAR(30),
		@fechaNacimiento DATE,
		@genero BOOLEAN,
		@direccion VARCHAR(100),
		@cp VARCHAR(5),
		@telefono VARCHAR(10),
		@email VARCHAR(45),
		@rfc VARCHAR(13),
		@nombre VARCHAR(50),
		@nombre VARCHAR(50),
		@id_tipo_de_empleado INT,
		@id_sucursal INT,

	)
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
			empleados_sucursales as es, 
			usuarios as u, 
			usuarios_empleados as ue,
			tipos_de_empleados as te
		where e.id_datos_personales=dp.id_datos_personales
			and u.id_usuario=ue.id_usuario
			and ue.id_empleado=e.id_empleado
			and e.id_empleado=es.id_empleado
			and es.id_sucursal=s.id_sucursal
			and e.id_tipo_de_empleado=te.id_tipo_de_empleado ;

	END

	delimiter ;


	CREATE PROCEDURE SPD_CONSULTA_EMPLEADOS_SUCURSAL_USUARIO
	(
	 @pdFechaInicio DATE,
	 @pdFechaFin DATE
	)
	AS
	BEGIN
		IF @pdFechaInicio IS NULL
			BEGIN
				SELECT 'LA FECHA DE INICIO NO PUEDE SER NULA'
			END
		ELSE IF @pdFechaFin IS NULL
			BEGIN
				SELECT 'LA FECHA FINAL NO PUEDE SER NULA'
			END
		ELSE
			BEGIN
				SELECT TDP.NID_DATOS_PERSONALES AS IdPersonal, TDP.CNOMBRE as Nombre
					FROM TBL_DATOS_PERSONALES AS TDP 
					LEFT OUTER JOIN TBL_USUARIOS AS TU
					ON TDP.NID_DATOS_PERSONALES = TU.NID_DATOS_PERSONALES 
					WHERE TU.NID_DATOS_PERSONALES IS NULL AND (TDP.DFECHA_NACIMIENTO BETWEEN @pdFechaInicio AND @pdFechaFin AND
					TDP.BHABILITADO=1)
			END
		RETURN
	END