<?php

class ClienteController extends BaseController {

	/**
	 * Display a listing of the resource.
	 *
	 * @return Response
	 */
	public function index()
	{
		$clientes = DB::select('call SPD_CONSULTAR_CLIENTES');
		/*	el procedimiento devuelve: 
			id_cliente, nombre, apellido_paterno, apellido_materno, 
			fecha_nacimiento, genero, direccion, cp, 
			telefono, email, rfc, tipo_de_cliente
		*/	
		return View::make('cliente.index')
						->with('clientes', $clientes);
	}


	/**
	 * Show the form for creating a new resource.
	 *
	 * @return Response
	 */
	public function create()
	{
		/*
		$tipos_de_clientes = TipoDeCliente::all()->skip(1)
					->lists('tipo_de_cliente','id_tipo_de_cliente');
		*/
		$tiposDeClientes=DB::table('tipos_de_clientes')
			->where('id_tipo_de_cliente', '<>', '1')
			->lists('tipo_de_cliente','id_tipo_de_cliente');

		return View::make('cliente.create')
						->with('tiposDeClientes', $tiposDeClientes);
	}


	/**
	 * Store a newly created resource in storage.
	 *
	 * @return Response
	 */
	public function store()
	{
	//crea un NUEVO objeto y lo almacena en la base
		$input = Input::all();
		$date = new DateTime;

		$datosPersonales=array(	
			'nombre'=> $input['nombre'],
			'apellido_paterno'=> $input['apellidoP'],
			'apellido_materno'=> $input['apellidoM'],
			'fecha_nacimiento'=> $input['nacimiento'],
			'genero'=> $input['genero'],
			'calle'=> $input['calle'],
			'colonia'=> $input['colonia'],
			'delegacion'=> $input['delegacion'],
			'estado'=> $input['estado'],
			'cp'=> $input['cp'],
			'telefono'=> $input['telefono'],
			'email'=> $input['email'],
			'rfc'=> $input['rfc'],
			'created_at' => $date,
			'updated_at' => $date );

		$idTipoCliente = $input['tipo'];

	// Start transaction!
		DB::beginTransaction();
		
		try {
		//insertamos datos personales y obetenemos el ID
			DB::table('datos_personales')
					->insert($datosPersonales);
			$idD=DB::getPdo()->lastInsertId();
		//insertamos y obetenemos el ID del EMPLEADO
			DB::table('clientes')
					->insert(array(	'id_datos_personales'=>$idD, 
									'id_tipo_de_cliente'=>$idTipoCliente,
									'created_at' => $date,
									'updated_at' => $date ));
		
		} catch (Exception $e) {
		//mensaje error
			DB::rollback();
			Session::flash('message', 'Ha ocurrido un error
					mientras se agregaba al cliente!');
			Session::flash('class', 'danger');
			return Redirect::to('clientes');
		}

	//Comit a los querys y mensaje exitoso
		DB::commit();
		Session::flash('message', 'Cliente agregado correctamente');
		Session::flash('class', 'success');
		return Redirect::to('clientes');

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
		$tiposDeClientes=DB::table('tipos_de_clientes')
							->where('id_tipo_de_cliente', '<>', '1')
							->lists('tipo_de_cliente','id_tipo_de_cliente');
		$cliente = DB::select(
					'call SPD_CONSULTA_CLIENTE(?)',array($id));
		/*	el procedimiento devuelve: 
			id_cliente, nombre, apellido_paterno, apellido_materno, 
			fecha_nacimiento, genero, direccion, cp, 
			telefono, email, rfc, tipo_de_cliente
		*/	
		return View::make('cliente.edit')
						->with('cliente', $cliente[0])
						->with('tiposDeClientes', $tiposDeClientes);
	}


	/**
	 * Update the specified resource in storage.
	 *
	 * @param  int  $id
	 * @return Response
	 */
	public function update($id)
	{
	//ACTUALIZA un objeto y lo almacena en la base
	//definimos variables que utilizamos en los querys
		$input = Input::all();
		
		$datosPersonales=array(	
			'nombre'=> $input['nombre'],
			'apellido_paterno'=> $input['apellidoP'],
			'apellido_materno'=> $input['apellidoM'],
			'fecha_nacimiento'=> $input['nacimiento'],
			'genero'=> $input['genero'],
			'calle'=> $input['calle'],
			'colonia'=> $input['colonia'],
			'delegacion'=> $input['delegacion'],
			'estado'=> $input['estado'],
			'cp'=> $input['cp'],
			'telefono'=> $input['telefono'],
			'email'=> $input['email'],
			'rfc'=> $input['rfc']);

		$idDatos=DB::table('clientes')
					->where('id_cliente','=',$id)
					->pluck('id_datos_personales');
		$datosCliente=array('id_tipo_de_cliente'=>$input['tipo']);

	// Start transaction!
		DB::beginTransaction();

		try {
		// Actualizamos los datos del cliente
			DatosPersonales::where('id_datos_personales','=',$idDatos)
				->update($datosPersonales);
		} catch(Exception $e) {
		// Rollback y redirige con mensaje especificando error
		    DB::rollback();
		    Session::flash('message', 
		    	'Ha ocurrido un error insertando los datos del cliente!');
			Session::flash('class', 'danger');
			return Redirect::to('clientes');
		}

		try {
		// Actualizamos el tipo de cliente
			Cliente::where('id_cliente','=',$id)
				->update($datosCliente);		
		} catch(Exception $e) {
		// Rollback y redirige con mensaje especificando error
		    DB::rollback();
		    $mensaje='Ha ocurrido un error 
		    			mientras se modificaba el cliente!';
		    Session::flash('message', $mensaje);
			Session::flash('class', 'danger');
			return Redirect::to('clientes');
		}

	// Commit the queries!
		DB::commit();
	//mensaje exitoso y redirige
		Session::flash('message', 'Modificado correctamente');
		Session::flash('class', 'success');
		return Redirect::to('clientes');

	}


	/**
	 * Remove the specified resource from storage.
	 *
	 * @param  int  $id
	 * @return Response
	 */
	public function destroy($id)
	{
	//Elimina un cliente
		$idDatos=DB::table('clientes')
					->where('id_cliente','=',$id)
					->pluck('id_datos_personales');
	
	//Empieza la transaccion
		DB::beginTransaction();

		try {
		//Eliminamos los registros en las tablas
			Cliente::destroy($id);	
			DatosPersonales::destroy($idDatos);
		//mensaje exitoso
			Session::flash('message', 'Eliminado correctamente');
			Session::flash('class', 'success');
			
		} catch (Exception $e) {
		//mensaje error
			DB::rollback();
			$mensaje='Ha ocurrido un error al eliminar al cliente! Es posible
				que este cliente haya realizado compras, es necesario
				borrar estos registros antes de eliminarlo';
		    Session::flash('message', $mensaje);
			Session::flash('class', 'danger');
			return Redirect::to('clientes');
		}
	//Comit a los querys
		DB::commit();
		return Redirect::to('clientes');

	}

//Autocompletar
	public function autocompletar(){
		$term = Input::get('term');

		$query="select c.id_cliente,
			dp.* , 
			tc.tipo_de_cliente
		from datos_personales as dp,
			clientes as c, 
			tipos_de_clientes as tc
		where c.id_cliente <> 1
			and c.id_datos_personales=dp.id_datos_personales
			and c.id_tipo_de_cliente=tc.id_tipo_de_cliente
			and (c.id_cliente like '%$term%' 
				or dp.nombre like '%$term%' 
				or dp.apellido_paterno like '%$term%') limit 5";
		$clientes = DB::select($query); 
		//return '<pre>'.print_r($clientes,true);
		$resultado = array();
		foreach ($clientes as $cliente)
			$resultado[] = ['id' => $cliente->id_cliente, 
							'value' => $cliente->id_cliente.'|'.
									$cliente->nombre.'|'.
									$cliente->apellido_paterno,
							'tipo_de_cliente'=>$cliente->tipo_de_cliente
							];
		return Response::json($resultado);

	}


}
