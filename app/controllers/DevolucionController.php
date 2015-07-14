<?php

class DevolucionController extends BaseController {

	/**
	 * Display a listing of the resource.
	 *
	 * @return Response
	 */
	public function index()
	{
		return View::make('devolucion.index');
	}


	/**
	 * Show the form for creating a new resource.
	 *
	 * @return Response
	 */
	public function create()
	{
		//
	}


	/**
	 * Store a newly created resource in storage.
	 *
	 * @return Response
	 */
	public function store()
	{
	//validamos los datos que introdujo el usuario
		$datos = Input::all();
		$reglas = array(
			'idProductoDevuelto' => 'required',
			'idProductoCambio' => 'required' );
		$validacion = Validator::make($datos, $reglas);
		//si la validacion falla, manda error
		if ( $validacion->fails() ) {
		    Session::flash('message', 
	    	'Debes elegir los productos para hacer el cambio!');
			Session::flash('class', 'danger');
			return Redirect::to('devoluciones');
		}
	//obtenemos los datos necesarios para la devolucion
		$date = new DateTime;
		$idProductoD = Input::get('idProductoDevuelto');
		$idProductoC = Input::get('idProductoCambio');
		$concepto = Input::get('concepto', null);
		$idEmpleado = Session::get('idEmpleado');
		$idSucursal = Session::get('idSucursal');
		$precioProductoD = DB::table('productos')
			            ->where('id_producto', $idProductoD)
			            ->lists('precio_cliente_frecuente')[0];
		$precioProductoC = DB::table('productos')
			            ->where('id_producto', $idProductoC)
			            ->lists('precio_cliente_frecuente')[0];
		$diferencia = $precioProductoC - $precioProductoD;
		if ($diferencia < 0) {
			Session::flash('message', 
	    	'La diferencia no puede ser negativa');
			Session::flash('class', 'danger');
			return Redirect::to('devoluciones');
		}elseif($diferencia > 0){
			//si la diferencia > 0 la devolucion es false, para cobrarla en 
			//el corte de caja
			$habilitado = false;
		}else{
			//si la diferencia es 0 no se agrega al corte de caja
			$habilitado = true;
		}
	//datos devolucion
		$datosDevolucion = array(
					'id_sucursal'=>$idSucursal,
					'id_empleado'=>$idEmpleado,
					'id_producto_devuelto'=>$idProductoD,
					'id_producto_cambio'=>$idProductoC,
					'diferencia'=>$diferencia,
					'concepto'=>$concepto,
					'habilitado'=>$habilitado,
					'created_at' => $date,
					'updated_at' => $date);
	// Start transaction!
		DB::beginTransaction();
	//agregar devolucion
		try {

			DB::table('devoluciones')
					->insert($datosDevolucion);

		} catch(Exception $e) {
		// Rollback y redirige con mensaje especificando error
		    DB::rollback();
		    Session::flash('message', 
		    	'Ha ocurrido un error realizando la devolucion!');
			Session::flash('class', 'danger');
			return Redirect::to('devoluciones');
		}
	//actualizar sucursales productos
		try {

			DB::table('sucursales_productos')
	            ->where('id_sucursales_productos', $idSucursal.$idProductoC)
	            ->decrement('cantidad', 1);
	        DB::table('sucursales_productos')
	            ->where('id_sucursales_productos', $idSucursal.$idProductoD)
	            ->increment('cantidad', 1);
		
		} catch(Exception $e) {
		// Rollback y redirige con mensaje especificando error
		    DB::rollback();
		    Session::flash('message', 
		    	'Ha ocurrido un error actualizando los 
		    	productos en la sucursal al realizar la devolucion!');
			Session::flash('class', 'danger');
			return Redirect::to('devoluciones');
		}
	// Commit the queries!
		DB::commit();
	//mensaje exitoso y redirige
		Session::flash('message', 'Devolucion registrada correctamente');
		Session::flash('class', 'success');
		return Redirect::to('devoluciones');

	}


	/**
	 * Display the specified resource.
	 *
	 * @param  int  $id
	 * @return Response
	 */
	public function show($id)
	{
		//
	}


	/**
	 * Show the form for editing the specified resource.
	 *
	 * @param  int  $id
	 * @return Response
	 */
	public function edit($id)
	{
		//
	}


	/**
	 * Update the specified resource in storage.
	 *
	 * @param  int  $id
	 * @return Response
	 */
	public function update($id)
	{
		//
	}


	/**
	 * Remove the specified resource from storage.
	 *
	 * @param  int  $id
	 * @return Response
	 */
	public function destroy($id)
	{
		//
	}

//JSON devoluciones
	public function json($accion, $id){

		switch ($accion) {
			case 'todos':
				$devoluciones = Devolucion::all();
				return  Response::json($devoluciones->toArray());
				break;
			
			case 'corte':
				$devoluciones = DB::select(
					'call SPD_CONSULTAR_DEVOLUCIONES_PARACORTE');
				return  Response::json($devoluciones);
				break;
			
			case 'corteSucursal':
				$devoluciones = DB::select(
					'call SPD_CONSULTAR_DEVOLUCIONES_SUCURSAL_PARACORTE
					(?)',array($id));
				return  Response::json($devoluciones);
				break;
			
			case 'corteEmpleado':
				$devoluciones = DB::select(
					'call SPD_CONSULTAR_DEVOLUCIONES_EMPLEADO_PARACORTE
					(?)',array($id));
				return  Response::json($devoluciones);
				break;
			
			case 'devolucion':
				$devolucion = Devolucion::find($id);
				return  Response::json($devolucion);
				break;
			
			case 'empleado':
				$devoluciones = Devolucion::where('id_empleado',$id)
					->get();
				return  Response::json($devoluciones->toArray());
				break;
			
			case 'sucursal':
				$devoluciones = Devolucion::where('id_sucursal',$id)
					->get();
				return  Response::json($devoluciones->toArray());
				break;
			
			case 'fecha':
				$fecha = explode('_', $id);
				//para que busque hasta el utimo dia, hasta la ultima hora
				$fecha[1] = $fecha[1].' 23:59:59';
				$devoluciones = Devolucion::whereBetween('created_at',
					$fecha)->get();
				return  Response::json($devoluciones);
				break;
			
			default:
				return  Response::json(['error']);
				break;
		}
	}


}
