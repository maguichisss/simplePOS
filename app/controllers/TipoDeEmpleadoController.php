<?php

class TipoDeEmpleadoController extends BaseController {

	public function __construct()
    {
    	//llama al filtro auth en filters.php
        $this->beforeFilter('salteGerenteSucursal');
    }
    /**
	 * Display a listing of the resource.
	 *
	 * @return Response
	 */
	public function index()
	{

		//$tipoDeEmpleado = TipoDeEmpleado::habilitado();
		$tiposDeEmpleados = TipoDeEmpleado::all();
		unset($tiposDeEmpleados[0]);
		//make recibe la direccion donde esta el index
		return View::make('tipoDeEmpleado.index')
						->with('tiposDeEmpleados', $tiposDeEmpleados);
	}


	/**
	 * Show the form for creating a new resource.
	 *
	 * @return Response
	 */
	public function create()
	{
		//redirige a la vista create.blade.php
		return View::make('tipoDeEmpleado.create');
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
		$tipoDeEmpleado = new TipoDeEmpleado;
		$tipoDeEmpleado->tipo_de_empleado = $input['tipo'];
		$tipoDeEmpleado->descripcion = $input['descripcion'];
		//si se guarda correctamente envia mensaje correcto
		//si no mostrara un mensaje de error 
		if($tipoDeEmpleado->save()){
			//crea una sesion temporal para mostrar un mensaje
			Session::flash('message', 'Guardado correctamente');
			Session::flash('class', 'success');
		}else{
			Session::flash('message', 'Ha ocurrido un error!');
			Session::flash('class', 'danger');
		}
		//redirige a la URL tiposDeEmpleados
		return Redirect::to('tiposDeEmpleados');

	}


	/**
	 * Display the specified resource.
	 *
	 * @param  int  $id
	 * @return Response
	 */
	public function show($id)
	{

	}


	/**
	 * Show the form for editing the specified resource.
	 *
	 * @param  int  $id
	 * @return Response
	 */
	public function edit($id)
	{
		$tipoDeEmpleado = TipoDeEmpleado::find($id);

		if($tipoDeEmpleado){
			return View::make('tipoDeEmpleado.edit')
							->with('tipoDeEmpleado',$tipoDeEmpleado);

		}else{
			Session::flash('message', 'No se encontro el tipo de cliente!');
			Session::flash('class', 'danger');
		}
		//redirige a la URL tiposDeEmpleados
		return Redirect::to('tiposDeEmpleados');

	}


	/**
	 * Update the specified resource in storage.
	 *
	 * @param  int  $id
	 * @return Response
	 */
	public function update($id)
	{
		//ACTUALIZA un registro en la base de datos
		$input = Input::all();
		$tipoDeEmpleado = TipoDeEmpleado::find($id);
		$tipoDeEmpleado->tipo_de_empleado = $input['tipo'];
		$tipoDeEmpleado->descripcion = $input['descripcion'];
		$tipoDeEmpleado->habilitado = $input['habilitado'];
		
		if($tipoDeEmpleado->save()){
			Session::flash('message', 'Actualizado correctamente');
			Session::flash('class', 'success');

		}else{
			Session::flash('message', 'Ha ocurrido un error!');
			Session::flash('class', 'danger');

		}
		//redirige a la URL tiposDeEmpleados
		return Redirect::to('tiposDeEmpleados');

	}


	/**
	 * Remove the specified resource from storage.
	 *
	 * @param  int  $id
	 * @return Response
	 */
	public function destroy($id)
	{
		$tipoDeEmpleado = TipoDeEmpleado::find($id);

		try {

		    $tipoDeEmpleado->delete();
			Session::flash('message', 'Eliminado correctamente');
			Session::flash('class', 'danger');
			return Redirect::to('tiposDeEmpleados');

		}catch(Exception $e){
			$mensaje = 'Este tipo de empleado esta siendo utilizado!<br/>
						Primero debes eliminar los empleados que 
						sean el tipo:'.$tipoDeEmpleado->tipo_de_cliente;
		    Session::flash('message', $mensaje);
			Session::flash('class', 'danger');
			return Redirect::to('tiposDeEmpleados');
		}

	}


	public function delete($id)
	{
		$tipoDeEmpleado = TipoDeEmpleado::find($id);
		$tipoDeEmpleado->habilitado = false;
		if($tipoDeEmpleado->save()){
			Session::flash('message', '*Eliminado correctamente');
			Session::flash('class', 'danger');

		}else{
			Session::flash('message', 'Ha ocurrido un error!');
			Session::flash('class', 'danger');

		}

		return Redirect::to('tiposDeEmpleados');
	}

	public function habilitar($id)
	{
		$tipoDeEmpleado = TipoDeEmpleado::find($id);
		$tipoDeEmpleado->habilitado = true;
		if($tipoDeEmpleado->save()){
			Session::flash('message', 'Habilitado correctamente');
			Session::flash('class', 'success');

		}else{
			Session::flash('message', 'Ha ocurrido un error!');
			Session::flash('class', 'danger');

		}

		return Redirect::to('tiposDeEmpleados');
	}


}
