delimiter //
DROP PROCEDURE IF EXISTS PRUEBA //
CREATE PROCEDURE PRUEBA()
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
END
//
delimiter ;


delimiter //
DROP PROCEDURE IF EXISTS PRUEBA //
CREATE PROCEDURE PRUEBA()
BEGIN
	declare i INT default 1;
	SET i = 1;
	WHILE i <= 3 DO
		SELECT 	count(*),CONCAT(i, a.idArticulo) as id_sucursal_producto, 
			i as id_sucursal, 
			a.idArticulo as id_producto, 
			0 as cantidad,
			0 as stock,
			ad.precio_compra as precio_compra,
			a.precio_venta2 as precio_cliente_frecuente,
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
END
//
delimiter ;
