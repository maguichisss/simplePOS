<?php

class TipoDeClienteController extends BaseController {

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
		//$tipoDeCliente = TipoDeCliente::habilitado();
		$tiposDeClientes = TipoDeCliente::all();
		//unset($tiposDeClientes[0]);
		//make recibe la direccion donde esta el index
		return View::make('tipoDeCliente.index')
						->with('tiposDeClientes', $tiposDeClientes);
	}


	/**
	 * Show the form for creating a new resource.
	 *
	 * @return Response
	 */
	public function create()
	{
		//redirige a la vista create.blade.php
		return View::make('tipoDeCliente.create');
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
		$tipoDeCliente = new TipoDeCliente;
		$tipoDeCliente->tipo_de_cliente = $input['tipoDeCliente'];
		$tipoDeCliente->descripcion = $input['descripcion'];
		//si se guarda correctamente envia mensaje correcto
		//si no mostrara un mensaje de error 
		if($tipoDeCliente->save()){
			//crea una sesion temporal para mostrar un mensaje
			Session::flash('message', 'Guardado correctamente');
			Session::flash('class', 'success');
		}else{
			Session::flash('message', 'Ha ocurrido un error!');
			Session::flash('class', 'danger');
		}
		//redirige a la URL tiposDeClientes
		return Redirect::to('tiposDeClientes');

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
		$tipoDeCliente = TipoDeCliente::find($id);

		if($tipoDeCliente){
			return View::make('tipoDeCliente.edit')
							->with('tipoDeCliente',$tipoDeCliente);

		}else{
			Session::flash('message', 'No se encontro el tipo de cliente!');
			Session::flash('class', 'danger');
		}
		//redirige a la URL tiposDeClientes
		return Redirect::to('tiposDeClientes');

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
		$tipoDeCliente = TipoDeCliente::find($id);
		$tipoDeCliente->tipo_de_cliente = $input['tipoDeCliente'];
		$tipoDeCliente->descripcion = $input['descripcion'];
		$tipoDeCliente->habilitado = $input['habilitado'];
		
		if($tipoDeCliente->save()){
			Session::flash('message', 'Actualizado correctamente');
			Session::flash('class', 'success');

		}else{
			Session::flash('message', 'Ha ocurrido un error!');
			Session::flash('class', 'danger');

		}
		//redirige a la URL tiposDeClientes
		return Redirect::to('tiposDeClientes');

	}


	/**
	 * Remove the specified resource from storage.
	 *
	 * @param  int  $id
	 * @return Response
	 */
	public function destroy($id)
	{
		$tipoDeCliente = TipoDeCliente::find($id);

		try {

		    $tipoDeCliente->delete();
			Session::flash('message', 'Eliminado correctamente');
			Session::flash('class', 'danger');
			return Redirect::to('tiposDeClientes');

		}catch(Exception $e){
			$mensaje = 'Este tipo de cliente esta siendo utilizado!<br/>
						Primero debes eliminar los clientes que 
						tengan el tipo de cliente:'.$tipoDeCliente->tipo_de_cliente;
		    Session::flash('message', $mensaje);
			Session::flash('class', 'danger');
			return Redirect::to('tiposDeClientes');
		}

	}


	public function delete($id)
	{
		$tipoDeCliente = TipoDeCliente::find($id);
		$tipoDeCliente->habilitado = false;
		if($tipoDeCliente->save()){
			Session::flash('message', '*Eliminado correctamente');
			Session::flash('class', 'danger');

		}else{
			Session::flash('message', 'Ha ocurrido un error!');
			Session::flash('class', 'danger');

		}

		return Redirect::to('tiposDeClientes');
	}

	public function habilitar($id)
	{
		$tipoDeCliente = TipoDeCliente::find($id);
		$tipoDeCliente->habilitado = true;
		if($tipoDeCliente->save()){
			Session::flash('message', 'Habilitado correctamente');
			Session::flash('class', 'success');

		}else{
			Session::flash('message', 'Ha ocurrido un error!');
			Session::flash('class', 'danger');

		}

		return Redirect::to('tiposDeClientes');
	}


}
