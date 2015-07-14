<?php

class VentasProductos extends Eloquent{
	
	//protected $table = 'productos';
	protected $table = 'ventas_productos';
	protected $primaryKey = 'id_ventas_productos';

	public static function soloHabilitados()
    {
        return Venta::where('habilitado', '=', true)->get();
    }

//JSON corte de caja
	public static function json($accion, $id){

		switch ($accion) {
			case 'todos':
				$ventas = VentasProductos::all();
				return  Response::json($ventas->toArray());
				break;
			
			case 'corte':
				$ventas = VentasProductos::where('id_empleado',$id)
						->where('habilitado',false)->get();
				return  Response::json($ventas->toArray());
				break;
			
			case 'venta':
				$venta = VentasProductos::where('id_venta',$id)
						->get();
				return  Response::json($venta);
				break;
			
			case 'ticket':
				$sql = 'SELECT vp.cantidad, vp.precio_unitario, 
							vp.id_venta,
							p.nombre_producto, p.descripcion
						 FROM ventas_productos as vp, 
						 	productos as p
						 WHERE vp.id_venta='.$id.'
						 	and vp.id_producto=p.id_producto';
				$ticket = DB::select($sql); 
				return  Response::json($ticket);
				break;
			
			case 'empleado':
				$ventas = VentasProductos::where('id_empleado',$id)->get();
				return  Response::json($ventas->toArray());
				break;
			
			case 'empleadoFecha':
				$fecha = explode('_', $id);
				$id = $fecha[2];
				//para que busque hasta el utimo dia, hasta la ultima hora
				$fecha[1] = $fecha[1].' 23:59:59';
				$sql = 'SELECT v.id_empleado,  v.id_sucursal, 
							vp.id_venta, vp.id_producto, vp.cantidad, 
							vp.precio_unitario, vp.created_at, 
							p.nombre_producto, p.descripcion 
						FROM ventas_productos as vp, productos as p,
							ventas as v
						WHERE vp.id_venta=v.id_venta AND
							v.id_empleado='.$id.' AND
							vp.created_at BETWEEN "'.$fecha[0].'" AND "'.
													$fecha[1].'" AND '.
								'p.id_producto=vp.id_producto';
				$ventas = DB::select($sql); 
				return  Response::json($ventas);
				break;
			
			case 'sucursal':
				$ventas = VentasProductos::where('id_sucursal',$id)->get();
				return  Response::json($ventas->toArray());
				break;
			
			case 'sucursalFecha':
				$fecha = explode('_', $id);
				$id = $fecha[2];
				//para que busque hasta el utimo dia, hasta la ultima hora
				$fecha[1] = $fecha[1].' 23:59:59';
				$sql = 'SELECT v.id_empleado,  v.id_sucursal, 
							vp.id_venta, vp.id_producto, vp.cantidad, 
							vp.precio_unitario, vp.created_at, 
							p.nombre_producto, p.descripcion 
						FROM ventas_productos as vp, productos as p,
							ventas as v
						WHERE vp.id_venta=v.id_venta AND
							v.id_sucursal='.$id.' AND
							vp.created_at BETWEEN "'.$fecha[0].'" AND "'.
													$fecha[1].'" AND '.
								'p.id_producto=vp.id_producto';
				$ventas = DB::select($sql); 
				return  Response::json($ventas);
				break;
			
			case 'fecha':
				$fecha = explode('_', $id);
				//para que busque hasta el utimo dia, hasta la ultima hora
				$fecha[1] = $fecha[1].' 23:59:59';
				$sql = 'SELECT v.id_empleado, v.id_sucursal, 
							vp.id_venta, vp.id_producto, vp.cantidad, 
							vp.precio_unitario, vp.created_at, 
							p.nombre_producto, p.descripcion 
						FROM ventas_productos as vp, productos as p,
							ventas as v
						WHERE vp.id_venta=v.id_venta AND
							vp.created_at BETWEEN "'.$fecha[0].'" AND "'.
													$fecha[1].'" AND '.
							'p.id_producto=vp.id_producto';
				$ventas = DB::select($sql); 
				return  Response::json($ventas);
				break;
			
			case 'importeFecha':
				$fecha = explode('_', $id);
				//para que busque hasta el utimo dia, hasta la ultima hora
				$fecha[1] = $fecha[1].' 23:59:59';
				$sql = 'select v.id_venta, v.id_empleado, 
							vtp.id_tipo_de_pago, sum(vtp.importe_pagado)
									as importe,
							tp.tipo_de_pago
						from ventas as v, 
							ventas_tipo_de_pago as vtp,
							tipos_de_pagos as tp
						where v.id_venta=vtp.id_venta 
							and vtp.id_tipo_de_pago=tp.id_tipo_de_pago
							and v.created_at BETWEEN "'.$fecha[0].'" AND "'.
													$fecha[1].'"
						group by vtp.id_tipo_de_pago';
				$importes = DB::select($sql); 
				return  Response::json($importes);
				break;
			
			case 'importeSucursalFecha':
				$fecha = explode('_', $id);
				$id = $fecha[2];
				//para que busque hasta el utimo dia, hasta la ultima hora
				$fecha[1] = $fecha[1].' 23:59:59';
				$sql = 'select v.id_venta, v.id_empleado, 
							vtp.id_tipo_de_pago, sum(vtp.importe_pagado)
									as importe,
							tp.tipo_de_pago
						from ventas as v, 
							ventas_tipo_de_pago as vtp,
							tipos_de_pagos as tp
						where v.id_sucursal='.$id.'
							and v.id_venta=vtp.id_venta 
							and vtp.id_tipo_de_pago=tp.id_tipo_de_pago
							and v.created_at BETWEEN "'.$fecha[0].'" AND "'.
													$fecha[1].'"
						group by vtp.id_tipo_de_pago';
				$importes = DB::select($sql); 
				return  Response::json($importes);
				break;
			
			case 'importeEmpleadoFecha':
				$fecha = explode('_', $id);
				$id = $fecha[2];
				//para que busque hasta el utimo dia, hasta la ultima hora
				$fecha[1] = $fecha[1].' 23:59:59';
				$sql = 'select v.id_venta, v.id_empleado, 
							vtp.id_tipo_de_pago, sum(vtp.importe_pagado)
									as importe,
							tp.tipo_de_pago
						from ventas as v, 
							ventas_tipo_de_pago as vtp,
							tipos_de_pagos as tp
						where v.id_empleado='.$id.'
							and v.id_venta=vtp.id_venta 
							and vtp.id_tipo_de_pago=tp.id_tipo_de_pago
							and v.created_at BETWEEN "'.
									$fecha[0].'" AND "'.
									$fecha[1].'"
						group by vtp.id_tipo_de_pago';
				$importes = DB::select($sql); 
				return  Response::json($importes);
				break;
			
			default:
				return  Response::json(['error']);
				break;
		}
	}

}
