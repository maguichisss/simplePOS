<?php

class TransferenciaController extends BaseController {

	public function __construct()
    {
    	//llama al filtro auth en filters.php
        $this->beforeFilter('salteVendedor');
    }
    /**
	 * Display a listing of the resource.
	 *
	 * @return Response
	 */
	public function index()
	{
		if(Session::get('tipo') == 'ADMINISTRADOR' || 
			Session::get('tipo') == 'GERENTE GENERAL'){
			$origen = $sucursales = DB::table('sucursales')
		        ->lists('nombre_sucursal', 'id_sucursal');
		}else{
			$sucursales = DB::table('sucursales')
		        ->where('id_sucursal','<>', Session::get('idSucursal'))
		        ->lists('nombre_sucursal', 'id_sucursal');
		    $origen[Session::get('idSucursal')]=Session::get('sucursal');
		}
		$trans = Transferencia::orderBy('created_at')->take(30)->get();
		//echo "<pre>".print_r($trans,true)."</pre>";
		$transferencias=array();
		foreach ($trans as $i => $transferencia) {
			$sucursalOrigen=Sucursal::find(
				$transferencia->id_sucursal_origen);
			$sucursalDestino=Sucursal::find(
				$transferencia->id_sucursal_destino);
			$empleado = DB::select(
				'call SPD_CONSULTA_EMPLEADO(?)',
				array($transferencia->id_empleado));
		/*	el procedimiento devuelve: 
			id_empleado, nombre, apellido_paterno, id_sucursal, 
			nombre_sucursal, username, tipo_de_empleado, habilitado
		*/
			$transferencias[]=array(
				'id'=>$transferencia->id_transferencia,
				'empleado'=>$empleado[0]->nombre.' '.
							$empleado[0]->apellido_paterno.' | '.
							$empleado[0]->username.' ',
				'sucursalOrigen'=>$sucursalOrigen->nombre_sucursal,
				'sucursalDestino'=>$sucursalDestino->nombre_sucursal,
				'idProducto'=>$transferencia->id_producto,
				'cantidad'=>$transferencia->cantidad,
				'fecha'=>$transferencia->created_at);
		}

		return View::make('transferencia.index')
			->with('origen', $origen)
			->with('sucursales', $sucursales)
			->with('transferencias', $transferencias);
		
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
	//obtenemos datos de la transferencia
		$date = new DateTime;
		$cantidadSolicitada = Input::get('cantidadSolicitada');
		$cantidadDisponible = Input::get('cantidadDisponible');
		$idSucursalOrigen = Input::get('sucursalOrigen');
		$idProducto = Input::get('idProducto');
		$idSucursalDestino = Input::get('sucursalDestino');
		//checamos si no piden mas productos de los disponibles
		if($cantidadSolicitada > $cantidadDisponible){
			Session::flash('message', 
				'No puedes transferir mas producto del disponible!');
			Session::flash('class', 'danger');
			return Redirect::to('transferencias');
		}

		$datosTransferencia = array(
				'id_empleado'=>Session::get('idEmpleado'),
				'id_sucursal_origen'=> $idSucursalOrigen,
				'id_sucursal_destino'=>$idSucursalDestino,
				'id_producto'=> $idProducto,
				'cantidad'=>$cantidadSolicitada,
				'created_at' => $date,
				'updated_at' => $date);
	// Start transaction!
		DB::beginTransaction();

		try {
			
			DB::table('transferencias')
						->insert($datosTransferencia);
			//si el prodcuto a transferir no existe rollback y error
	        if(!SucursalesProductos::find(
	        		$idSucursalDestino.$idProducto)){
	        	// Rollback y redirige con mensaje especificando error
			    DB::rollback();
			    Session::flash('message', 
			    	'No tienen registrado este producto en sucursal 
			    	de destino, primero deben registrarlo!');
				Session::flash('class', 'danger');
				return Redirect::to('transferencias');
	        }
	        DB::table('sucursales_productos')
	            ->where('id_sucursales_productos',
	            					$idSucursalDestino.$idProducto)
	            ->increment('cantidad',$cantidadSolicitada);
			
			DB::table('sucursales_productos')
	            ->where('id_sucursales_productos',
	            					$idSucursalOrigen.$idProducto)
	            ->decrement('cantidad',$cantidadSolicitada);
			
			//return '<pre>'.print_r(Input::all(),true).'</pre>';
		
		} catch (Exception $e) {
			// Rollback y redirige con mensaje especificando error
		    DB::rollback();
		    Session::flash('message', 
		    	'Ha ocurrido un error al hacer la transferencia!');
			Session::flash('class', 'danger');
			return Redirect::to('transferencias');
		}
	// Commit the queries!
		DB::commit();
	//mensaje exitoso y redirige
		Session::flash('message', 
					'Transferencia registrada correctamente');
		Session::flash('class', 'success');
		return Redirect::to('transferencias');


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


}
