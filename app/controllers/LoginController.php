<?php

class LoginController extends BaseController {

	public function __construct()
    {
    	//llama al filtro auth en filters.php
        $this->beforeFilter('loged');
    }
    /**
	 * Display a listing of the resource.
	 *
	 * @return Response
	 */
	public function index()
	{
		return View::make('login');
	}

	/**
	 * Store a newly created resource in storage.
	 *
	 * @return Response
	 */
	public function store()
	{
		//columnas en la tabla de la base que usaremos para autenticar
		$datosUsuario = array(
			'username' => Input::get('username'),
			'password' => Input::get('password')		
		);
		//comprobamos las credenciales del usuario/empleado
		$autenticado=Auth::attempt($datosUsuario);

		//logeo correcto
		if ($autenticado){
		//Obtenemos id usuario/empleado, sucursal y si esta habilitado
			$id=Auth::id();
			$idEmpleado=Auth::user()->id_empleado;

			$empleado=DB::table('empleados')
							->where('id_empleado','=',$idEmpleado)
							->get();

	  		$habilitado=$empleado[0]->habilitado;
	  		$idDatos=$empleado[0]->id_datos_personales;
	  		$idTipo=$empleado[0]->id_tipo_de_empleado;
			$idSucursal=$empleado[0]->id_sucursal;

	  	//si el usuario esta deshabilitado redirigimos al login
	  		if ($habilitado=='0') {
				Auth::logout();
				Session::flash('message', 'Tu usuario esta deshabilitado!');
				Session::flash('class', 'danger');
				return Redirect::to('login');
	  		}

	  	//Obtenemos nombre y tipo del usuario/empleado
  			$nombreEmpleado=DB::table('datos_personales')
								->where('id_datos_personales','=',$idDatos)
								->pluck('nombre');
			$tipo=DB::table('tipos_de_empleados')
								->where('id_tipo_de_empleado','=',$idTipo)
								->pluck('tipo_de_empleado');
		//Obtenemos nombre y id de la sucursal del usuario/empleado
			$sucursal=DB::table('sucursales')
								->where('id_sucursal','=',$idSucursal)
								->pluck('nombre_sucursal');

			$tipo=strtoupper($tipo);
			$sucursal=strtoupper($sucursal);
			Session::put('idUsuario',$id);
			Session::put('usuario',strtoupper(Auth::user()->username));
			Session::put('idEmpleado',$idEmpleado);
			Session::put('idDatos',$idDatos);
			Session::put('nombre',$nombreEmpleado);
			Session::put('idTipo',$idTipo);
			Session::put('tipo',$tipo);
			Session::put('idSucursal',$idSucursal);
			Session::put('sucursal',$sucursal);

			return Redirect::to('inicio');
					





		}else{
		//logeo incorrecto
			Session::flash('message', 'Usuario o contraseña incorrectos!');
			Session::flash('class', 'danger');
			//redirige a login
			return Redirect::to('login');
		}

	}








}
