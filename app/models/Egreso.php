<?php

class Egreso extends Eloquent{
	
	//protected $table = 'productos';
	protected $table = 'egresos';
	protected $primaryKey = 'id_egreso';

	public static function soloHabilitados()
    {
        return Egreso::where('habilitado', '=', true)->get();
    }

//JSON corte de caja
	public static function json($accion, $id){

		switch ($accion) {
			case 'todos':
				$ventas = Egreso::all();
				return  Response::json($ventas->toArray());
				break;
			
			case 'egreso':
				$venta = Egreso::find($id);
				return  Response::json($venta);
				break;
			
			case 'empleado':
				$ventas = Egreso::where('id_empleado',$id)->get();
				return  Response::json($ventas->toArray());
				break;
			
			case 'empleadoFecha':
				$fecha = explode('_', $id);
				$id = $fecha[2];
				//para que busque hasta el utimo dia, hasta la ultima hora
				$fecha[1] = $fecha[1].' 23:59:59';
				array_pop($fecha);
				$ventas = Egreso::where('id_empleado',$id)->
							whereBetween('created_at', $fecha)->get();
				return  Response::json($ventas->toArray());
				break;
			
			case 'sucursal':
				$ventas = Egreso::where('id_sucursal',$id)->get();
				return  Response::json($ventas->toArray());
				break;
			
			case 'sucursalFecha':
				$fecha = explode('_', $id);
				$id = $fecha[2];
				//para que busque hasta el utimo dia, hasta la ultima hora
				$fecha[1] = $fecha[1].' 23:59:59';
				array_pop($fecha);
				$ventas = Egreso::where('id_sucursal',$id)->
							whereBetween('created_at', $fecha)->get();
				return  Response::json($ventas->toArray());
				break;
			
			case 'fecha':
				$fecha = explode('_', $id);
				//para que busque hasta el utimo dia, hasta la ultima hora
				$fecha[1] = $fecha[1].' 23:59:59';
				$ventas = 
					Egreso::whereBetween('created_at', $fecha)->get();
				return  Response::json($ventas);
				break;
			
			default:
				return  Response::json(['error']);
				break;
		}
	}

}
