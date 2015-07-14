<?php

class TipoDePagoController extends BaseController {

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

		//$tipoDePago = TipoDePago::habilitado();
		$tiposDePagos = TipoDePago::all();
		//make recibe la direccion donde esta el index
		return View::make('tipoDePago.index')
						->with('tiposDePagos', $tiposDePagos);
	}


	/**
	 * Show the form for creating a new resource.
	 *
	 * @return Response
	 */
	public function create()
	{
		//redirige a la vista create.blade.php
		return View::make('tipoDePago.create');
	}


	/**
	 * Store a newly created resource in storage.
	 *
	 * @return Response
	 */
	public function store()
	{
		//crea un NUEVO objeto y lo almacena en la base
		//el formulario de la pagina create 
		$tipoDePago = new TipoDePago;
		$tipoDePago->tipo_de_pago = Input::get('tipoDePago');
		//si se guarda correctamente envia mensaje correcto con estilo success
		//si no mostrara un mensaje de error 
		if($tipoDePago->save()){
			//crea una sesion temporal para mostrar un mensaje
			Session::flash('message', 'Guardado correctamente');
			Session::flash('class', 'success');
		}else{
			Session::flash('message', 'Ha ocurrido un error!');
			Session::flash('class', 'danger');
		}
		//redirige a la url tiposDePagos
		return Redirect::to('tiposDePagos');

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
		$tipoDePago = TipoDePago::find($id);

		if($tipoDePago){
			return View::make('tipoDePago.edit')
							->with('tipoDePago',$tipoDePago);
		}else{
			Session::flash('message', 'No se encontro el tipo de pago!');
			Session::flash('class', 'danger');
		}
		//redirige a la URL tiposDePagos
		return Redirect::to('tiposDePagos');

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
		$tipoDePago = TipoDePago::find($id);
		$tipoDePago->tipo_de_pago = $input['tipoDePago'];
		$tipoDePago->habilitado = $input['habilitado'];
		
		if($tipoDePago->save()){
			Session::flash('message', 'Actualizado correctamente');
			Session::flash('class', 'success');

		}else{
			Session::flash('message', 'Ha ocurrido un error!');
			Session::flash('class', 'danger');

		}
		//redirige a la URL tiposDePagos
		return Redirect::to('tiposDePagos');

	}


	/**
	 * Remove the specified resource from storage.
	 *
	 * @param  int  $id
	 * @return Response
	 */
	public function destroy($id)
	{
		$tipoDePago = TipoDePago::find($id);

		try {

		    $tipoDePago->delete();
			Session::flash('message', 'Eliminado correctamente');
			Session::flash('class', 'danger');
			return Redirect::to('tiposDePagos');

		}catch(Exception $e){
			$mensaje = 'Este tipo de pago esta siendo utilizado!<br/>
						Primero debes eliminar las ventas y compras que 
						tengan el tipo de pago:'.$tipoDePago->tipo_de_pago;
		    Session::flash('message', $mensaje);
			Session::flash('class', 'danger');
			return Redirect::to('tiposDePagos');
		}

	}


	public function delete($id)
	{
		$tipoDePago = TipoDePago::find($id);
		$tipoDePago->habilitado = false;
		if($tipoDePago->save()){
			Session::flash('message', '*Eliminado correctamente');
			Session::flash('class', 'danger');

		}else{
			Session::flash('message', 'Ha ocurrido un error!');
			Session::flash('class', 'danger');

		}

		return Redirect::to('tiposDePagos');
	}

	public function habilitar($id)
	{
		$tipoDePago = TipoDePago::find($id);
		$tipoDePago->habilitado = true;
		if($tipoDePago->save()){
			Session::flash('message', 'Habilitado correctamente');
			Session::flash('class', 'success');

		}else{
			Session::flash('message', 'Ha ocurrido un error!');
			Session::flash('class', 'danger');

		}

		return Redirect::to('tiposDePagos');
	}


}
