<?php

class EmpleadoController extends BaseController {

	public function __construct()
    {
    	$this->beforeFilter('salteVendedor');
    }
    /**
	 * Display a listing of the resource.
	 *
	 * @return Response
	 */
	public function index()
	{
		$tipo=Session::get('tipo');
		$idSucursal=Session::get('idSucursal');
		if ($tipo == 'GERENTE DE SUCURSAL')
			$empleados = DB::select(
				'call SPD_CONSULTA_EMPLEADOS_SUCURSAL(?)',
					array($idSucursal));
		else			
			$empleados = DB::select('call SPD_CONSULTAR_EMPLEADOS');
		/*	el procedimiento devuelve: 
			id_empleado, nombre, apellido_paterno, id_sucursal, 
			nombre_sucursal, username, tipo_de_empleado, habilitado
		*/	
		return View::make('empleado.index')
						->with('empleados', $empleados);

	}


	/**
	 * Show the form for creating a new resource.
	 *
	 * @return Response
	 */
	public function create()
	{
		$tipo=Session::get('tipo');
		$idSucursal=Session::get('idSucursal');
		if ($tipo == 'GERENTE DE SUCURSAL'){
			$sucursal = Sucursal::
						where('id_sucursal',$idSucursal)
						->select('nombre_sucursal','id_sucursal')
						->get()[0];
			$tipEmp = TipoDeEmpleado::
					select('tipo_de_empleado','id_tipo_de_empleado')
					->skip(3)->take(20)->get();
			$sucursales[$sucursal->id_sucursal]=
				$sucursal->nombre_sucursal;
			foreach ($tipEmp as $i => $tipo) {
				$tipos_de_empleados[$tipo->id_tipo_de_empleado]=
					$tipo->tipo_de_empleado;
			}
		}else if ($tipo == 'GERENTE GENERAL'){
			$sucursales = Sucursal::all()
					->lists('nombre_sucursal','id_sucursal');
			$tipEmp = TipoDeEmpleado::
					select('tipo_de_empleado','id_tipo_de_empleado')
					->skip(2)->take(20)
					->orderBy('id_tipo_de_empleado')->get();
			foreach ($tipEmp as $i => $tipo) {
				$tipos_de_empleados[$tipo->id_tipo_de_empleado]=
					$tipo->tipo_de_empleado;
			}
		}else{
			$sucursales = Sucursal::all()
					->lists('nombre_sucursal','id_sucursal');
			$tipos_de_empleados = TipoDeEmpleado::all()
					->lists('tipo_de_empleado','id_tipo_de_empleado');
		}
		
		return View::make('empleado.create')
					->with('sucursales', $sucursales)
					->with('tipos_de_empleados', $tipos_de_empleados);
	}


	/**
	 * Store a newly created resource in storage.
	 *
	 * @return Response
	 */
	public function store()
	{
		$input = Input::all();
		//validamos el usuario del nuevo empleado
		$datos = array(
			'usuario' => $input['usuario']	);
		$reglas = array(
			'usuario' => 'required|unique:usuarios,username' );
		$mensajes = array(
		'required' => 'El usuario es obligatorio',
		'unique'=>'El usuario '.$input['usuario'].' ya esta registrado');

		$validacion = Validator::make($datos, $reglas, $mensajes);
		//si la validacion que el codigo sea unico falla, manda error
		if ( $validacion->fails() ) {
		    $errors = $validacion->messages();
		    Session::flash('message', $errors->first());
			Session::flash('class', 'danger');
			return Redirect::to('empleados');
		}
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

		$idSucursal = $input['sucursal'];
		$idTipoEmpleado = $input['tipo'];

	// Start transaction!
		DB::beginTransaction();
		
		try {
		//insertamos datos personales y obetenemos el ID
			DB::table('datos_personales')
					->insert($datosPersonales);
			$idD=DB::getPdo()->lastInsertId();
		//insertamos y obetenemos el ID del EMPLEADO
			DB::table('empleados')
				->insert(array(	'id_datos_personales'=>$idD, 
								'id_tipo_de_empleado'=>$idTipoEmpleado,
								'id_sucursal'=>$idSucursal,
								'created_at' => $date,
								'updated_at' => $date ));
			$idE=DB::getPdo()->lastInsertId();
		//insertamos usuario y obetenemos el ID USUARIO
			$datosUsuario = array(	
			'username' => $input['usuario'],
			'password' => Hash::make($input['password']),
			'id_empleado' => $idE,
			'created_at' => $date,
			'updated_at' => $date );

			DB::table('usuarios')
					->insert($datosUsuario);

		} catch (Exception $e) {
		//mensaje error
			DB::rollback();
			Session::flash('message', 'Ha ocurrido un error 
				al agregar al empleado!');
			Session::flash('class', 'danger');
			return Redirect::to('empleados');
		
		}
	//Commit a los querys y mensaje exitoso
		DB::commit();
		Session::flash('message', 'Guardado correctamente');
		Session::flash('class', 'success');
		return Redirect::to('empleados');

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
		$tipo=Session::get('tipo');
		$idSucursal=Session::get('idSucursal');
		if ($tipo == 'GERENTE DE SUCURSAL'){
			$sucursal = Sucursal::
						where('id_sucursal',$idSucursal)
						->select('nombre_sucursal','id_sucursal')
						->get()[0];
			$tipEmp = TipoDeEmpleado::
					select('tipo_de_empleado','id_tipo_de_empleado')
					->skip(3)->take(20)->get();
			$sucursales[$sucursal->id_sucursal]=
				$sucursal->nombre_sucursal;
			foreach ($tipEmp as $i => $tipo) {
				$tipos_de_empleados[$tipo->id_tipo_de_empleado]=
					$tipo->tipo_de_empleado;
			}
		}else if ($tipo == 'GERENTE GENERAL'){
			$sucursales = Sucursal::all()
					->lists('nombre_sucursal','id_sucursal');
			$tipEmp = TipoDeEmpleado::
					select('tipo_de_empleado','id_tipo_de_empleado')
					->skip(2)->take(20)
					->orderBy('id_tipo_de_empleado')->get();
			foreach ($tipEmp as $i => $tipo) {
				$tipos_de_empleados[$tipo->id_tipo_de_empleado]=
					$tipo->tipo_de_empleado;
			}
		}else{
			$sucursales = Sucursal::all()
					->lists('nombre_sucursal','id_sucursal');
			$tipos_de_empleados = TipoDeEmpleado::all()
					->lists('tipo_de_empleado','id_tipo_de_empleado');
		}
		
		$empleado = DB::select(
				'call SPD_CONSULTA_EMPLEADO(?)',array($id));
		/*	el procedimiento devuelve: 
			id_empleado, nombre, apellido_paterno, id_sucursal, 
			nombre_sucursal, username, tipo_de_empleado, habilitado
		*/
		return View::make('empleado.edit')
				->with('empleado', $empleado)
				->with('sucursales', $sucursales)
				->with('tipos_de_empleados', $tipos_de_empleados);
		
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
	//definimos variables que utilizaremos en los querys
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
		//si no modifico la contraseña, solo modifica el usuario
		if($input['password'] == ''){
			$datosUsuario = array(	
				'username' => $input['usuario']);
		}else{
			$datosUsuario = array(	
				'username' => $input['usuario'],
				'password' => Hash::make($input['password']));
		}

		$idDatos=DB::table('empleados')
					->where('id_empleado','=',$id)
					->pluck('id_datos_personales');
		
		$usuario=DB::table('usuarios')
					->where('id_empleado','=',$id)
					->get();

		$idUsuario=$usuario[0]->id_usuario;

	// Start transaction!
		DB::beginTransaction();

		try {
		// Validate, then create if valid
			Empleado::where('id_empleado','=',$id)
				->update(array(
					'id_tipo_de_empleado'=>$input['tipo'],
					'id_sucursal'=>$input['sucursal']));
		} catch(Exception $e) {
		// Rollback y redirige con mensaje especificando error
		    DB::rollback();
		    Session::flash('message', 
		    	'Ha ocurrido un error insertando el empleado!');
			Session::flash('class', 'danger');
			return Redirect::to('empleados');
		}

		try {
		// Validate, then create if valid
			DatosPersonales::where('id_datos_personales','=',$idDatos)
				->update($datosPersonales);
		} catch(Exception $e) {
		// Rollback y redirige con mensaje especificando error
		    DB::rollback();
		    Session::flash('message', 
		    'Ha ocurrido un error insertando los datos del empleado!');
			Session::flash('class', 'danger');
			return Redirect::to('empleados');
		}

		try {
		// Validate, then create if valid
			User::where('id_usuario','=',$idUsuario)
				->update($datosUsuario);		
		} catch(Exception $e) {
		// Rollback y redirige con mensaje especificando error
		    DB::rollback();
		    $mensaje='Ha ocurrido un error insertando el usuario! 
		    		Ya hay un usuario con ese nombre?';
		    Session::flash('message', $mensaje);
			Session::flash('class', 'danger');
			return Redirect::to('empleados');
		}

	// Commit the queries!
		DB::commit();
	//mensaje exitoso y redirige
		Session::flash('message', 'Modificado correctamente');
		Session::flash('class', 'success');
		return Redirect::to('empleados');

	}


	/**
	 * Remove the specified resource from storage.
	 *
	 * @param  int  $id
	 * @return Response
	 */
	public function destroy($id)
	{
	//ELIMITA un empleado de la base de datos
		$idDatos=DB::table('empleados')
					->where('id_empleado','=',$id)
					->pluck('id_datos_personales');

		$usuario=DB::table('usuarios')
					->where('id_empleado','=',$id)
					->get();

		$idUsuario=$usuario[0]->id_usuario;
		
	//Empieza la transaccion
		DB::beginTransaction();

		try {
		//Eliminamos los registros en las tablas
			User::destroy($idUsuario);
			Empleado::destroy($id);	
			DatosPersonales::destroy($idDatos);
		//mensaje exitoso
			Session::flash('message', 'Eliminado correctamente');
			Session::flash('class', 'success');
			
		} catch (Exception $e) {
		//mensaje error
			DB::rollback();
			$mensaje='Ha ocurrido un error al eliminar al empleado! 
			Es posible que este empleado haya realizado compras o ventas, 
			es necesario borrar estos registros antes de eliminar 
			este usuario';
		    Session::flash('message', $mensaje);
			Session::flash('class', 'danger');
			return Redirect::to('empleados');
		}
	//Comit a los querys
		DB::commit();
		return Redirect::to('empleados');

	}

	public function delete($id)
	{
	//DESHABILITA un empleado
	//definimos variables que utilizamos en los querys
		$idDatos=DB::table('empleados')
					->where('id_empleado','=',$id)
					->pluck('id_datos_personales');
		
		$usuario=DB::table('usuarios')
					->where('id_empleado','=',$id)
					->get();

		$idUsuario=$usuario[0]->id_usuario;

	// Start transaction!
		DB::beginTransaction();

		try {
		// Validate, then create if valid
			Empleado::where('id_empleado','=',$id)
				->update(array(
					'habilitado'=>false));
			DatosPersonales::where('id_datos_personales','=',$idDatos)
				->update(array(
					'habilitado'=>false));
			User::where('id_usuario','=',$idUsuario)
				->update(array(
					'habilitado'=>false));		

		} catch(Exception $e) {
		// Rollback y redirige con mensaje especificando error
		    DB::rollback();
		    $mensaje='Ha ocurrido un error al deshabilitar al empleado!';
		    Session::flash('message', $mensaje);
			Session::flash('class', 'danger');
			return Redirect::to('empleados');
		}

	// Commit the queries!
		DB::commit();
	//mensaje exitoso y redirige
		Session::flash('message', 'Deshabilitado correctamente');
		Session::flash('class', 'success');
		return Redirect::to('empleados');

	}

	public function habilitar($id)
	{
	//	return $this->permisos();
	//HABILITA un empleado
	//definimos variables que utilizamos en los querys
		$idDatos=DB::table('empleados')
					->where('id_empleado','=',$id)
					->pluck('id_datos_personales');
		
		$usuario=DB::table('usuarios')
					->where('id_empleado','=',$id)
					->get();

		$idUsuario=$usuario[0]->id_usuario;

	// Start transaction!
		DB::beginTransaction();

		try {
		// Validate, then create if valid
			Empleado::where('id_empleado','=',$id)
				->update(array(
					'habilitado'=>true));
			DatosPersonales::where('id_datos_personales','=',$idDatos)
				->update(array(
					'habilitado'=>true));
			User::where('id_usuario','=',$idUsuario)
				->update(array(
					'habilitado'=>true));		

		} catch(Exception $e) {
		// Rollback y redirige con mensaje especificando error
		    DB::rollback();
		    $mensaje='Ha ocurrido un error al deshabilitar al empleado!';
		    Session::flash('message', $mensaje);
			Session::flash('class', 'danger');
			return Redirect::to('empleados');
		}

	// Commit the queries!
		DB::commit();
	//mensaje exitoso y redirige
		Session::flash('message', 'Habilitado correctamente');
		Session::flash('class', 'success');
		return Redirect::to('empleados');

	}

//JSON empleados
	public function json($accion, $id){

		switch ($accion) {
			case 'todos':
				$empleados = Empleado::all();
				return  Response::json($empleados->toArray());
				break;
			
			case 'corteV':
				$ventas = Venta::where('id_empleado',$id)
						->where('habilitado',false)->get();
				return  Response::json($ventas->toArray());
				break;
			
			case 'empleado':
				$empleado = DB::select(
					'call SPD_CONSULTA_EMPLEADO(?)',array($id));
				return  Response::json($empleado);
				break;
			
			case 'corteD':
				$devoluciones = Devolucion::where('id_empleado',$id)
						->where('habilitado',false)->get();
				return  Response::json($devoluciones->toArray());
				break;
			
			case 'ventas':
				$ventas = Venta::where('id_empleado',$id)->get();
				return  Response::json($ventas->toArray());
				break;
			
			case 'devoluciones':
				$devoluciones = Devolucion::where('id_empleado',$id)
					->get();
				return  Response::json($devoluciones->toArray());
				break;
			
			default:
				return  Response::json(['error']);
				break;
		}
	}

	public function permisos(){
	//obtenemos el id del tipo de empleado y el tipo de empleado
		$idTipo=Session::get('idTipo');
		$tipo=Session::get('tipo');
//Se puede fitrar por el idTipo y por el tipo, en este caso lo haremos
//con el tipo, y regresara un array con las acciones que puede realizar
		switch ($tipo) {
			case 'ADMINISTRADOR':
				return 'Aministradooooor!!!';
				break;
			
			case 'GERENTE GENERAL':
				return 'Gerente General!!!';
				break;
			
			case 'GERENTE SUCURSAL':
				return 'Gerente Sucursal!!!';
				break;
			
			case 'VENDEDOR':
				return 'Vendedor!!!';
				break;
			
			default:
				return 'ERROR!!!';
				break;
		}

	}


}
