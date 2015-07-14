<?php

class Venta extends Eloquent{
	
	//protected $table = 'productos';
	protected $table = 'ventas';
	protected $primaryKey = 'id_venta';

	public static function soloHabilitados()
    {
        return Venta::where('habilitado', '=', true)->get();
    }

//JSON corte de caja
	public static function json($accion, $id){

		switch ($accion) {
			case 'todos':
				$ventas = Venta::all();
				return  Response::json($ventas->toArray());
				break;
			
			case 'corte':
				$ventas = Venta::where('id_empleado',$id)
						->where('habilitado',false)->get();
				return  Response::json($ventas->toArray());
				break;
			
			case 'venta':
				$venta = Venta::find($id);
				return  Response::json($venta);
				break;
			
			case 'detallesVenta':
				$detallesVenta = 
					VentasProductos::where('id_venta',$id)->get();
				return  Response::json($detallesVenta->toArray());
				break;
			
			case 'empleado':
				$ventas = Venta::where('id_empleado',$id)->get();
				return  Response::json($ventas->toArray());
				break;
			
			case 'empleadoFecha':
				$fecha = explode('_', $id);
				$id = $fecha[2];
				//para que busque hasta el utimo dia, hasta la ultima hora
				$fecha[1] = $fecha[1].' 23:59:59';
				array_pop($fecha);
				$ventas = Venta::where('id_empleado',$id)->
							whereBetween('created_at', $fecha)->get();
				return  Response::json($ventas->toArray());
				break;
			
			case 'sucursal':
				$ventas = Venta::where('id_sucursal',$id)->get();
				return  Response::json($ventas->toArray());
				break;
			
			case 'sucursalFecha':
				$fecha = explode('_', $id);
				$id = $fecha[2];
				//para que busque hasta el utimo dia, hasta la ultima hora
				$fecha[1] = $fecha[1].' 23:59:59';
				array_pop($fecha);
				$ventas = Venta::where('id_sucursal',$id)->
							whereBetween('created_at', $fecha)->get();
				return  Response::json($ventas->toArray());
				break;
			
			case 'fecha':
				$fecha = explode('_', $id);
				//para que busque hasta el utimo dia, hasta la ultima hora
				$fecha[1] = $fecha[1].' 23:59:59';
				$ventas = 
					Venta::whereBetween('created_at', $fecha)->get();
				return  Response::json($ventas);
				break;
			
			default:
				return  Response::json(['error']);
				break;
		}
	}

}
