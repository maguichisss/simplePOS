<?php

class ComprasProductos extends Eloquent{
	
	//protected $table = 'productos';
	protected $table = 'compras_productos';
	protected $primaryKey = 'id_compras_productos';

	public static function soloHabilitados()
    {
        return Venta::where('habilitado', '=', true)->get();
    }

//JSON corte de caja
	public static function json($accion, $id){

		switch ($accion) {
			case 'todos':
				$compras = ComprasProductos::all();
				return  Response::json($compras->toArray());
				break;
			
			case 'corte':
				$compras = ComprasProductos::where('id_empleado',$id)
						->where('habilitado',false)->get();
				return  Response::json($compras->toArray());
				break;
			
			case 'venta':
				$venta = ComprasProductos::find($id);
				return  Response::json($venta);
				break;
			
			case 'empleado':
				$compras = ComprasProductos::where('id_empleado',$id)->get();
				return  Response::json($compras->toArray());
				break;
			
			case 'empleadoFecha':
				$fecha = explode('_', $id);
				$id = $fecha[2];
				//para que busque hasta el utimo dia, hasta la ultima hora
				$fecha[1] = $fecha[1].' 23:59:59';
				$sql = 'SELECT c.id_empleado,  c.id_sucursal, c.total,
							cp.id_compra, cp.id_producto, cp.cantidad, 
							cp.precio_unitario, cp.created_at, 
							p.nombre_producto, p.descripcion 
						FROM compras_productos as cp, productos as p,
							compras as c
						WHERE cp.id_compra=c.id_compra AND
							c.id_empleado='.$id.' AND
							cp.created_at BETWEEN "'.$fecha[0].'" AND "'.
													$fecha[1].'" AND '.
								'p.id_producto=cp.id_producto';
				$compras = DB::select($sql); 
				return  Response::json($compras);
				break;
			
			case 'sucursal':
				$compras = ComprasProductos::where('id_sucursal',$id)->get();
				return  Response::json($compras->toArray());
				break;
			
			case 'sucursalFecha':
				$fecha = explode('_', $id);
				$id = $fecha[2];
				//para que busque hasta el utimo dia, hasta la ultima hora
				$fecha[1] = $fecha[1].' 23:59:59';
				$sql = 'SELECT c.id_empleado,  c.id_sucursal, c.total,
							cp.id_compra, cp.id_producto, cp.cantidad, 
							cp.precio_unitario, cp.created_at, 
							p.nombre_producto, p.descripcion 
						FROM compras_productos as cp, productos as p,
							compras as c
						WHERE cp.id_compra=c.id_compra AND
							c.id_sucursal='.$id.' AND
							cp.created_at BETWEEN "'.$fecha[0].'" AND "'.
													$fecha[1].'" AND '.
								'p.id_producto=cp.id_producto';
				$compras = DB::select($sql); 
				return  Response::json($compras);
				break;
			
			case 'fecha':
				$fecha = explode('_', $id);
				//para que busque hasta el utimo dia, hasta la ultima hora
				$fecha[1] = $fecha[1].' 23:59:59';
				$sql = 'SELECT c.id_empleado, c.id_sucursal, c.total,
							cp.id_compra, cp.id_producto, cp.cantidad, 
							cp.precio_unitario, cp.created_at, 
							p.nombre_producto, p.descripcion 
						FROM compras_productos as cp, productos as p,
							compras as c
						WHERE cp.id_compra=c.id_compra AND
							cp.created_at BETWEEN "'.$fecha[0].'" AND "'.
													$fecha[1].'" AND '.
							'p.id_producto=cp.id_producto';
				$compras = DB::select($sql); 
				return  Response::json($compras);
				break;
			
			default:
				return  Response::json(['error']);
				break;
		}
	}

}
