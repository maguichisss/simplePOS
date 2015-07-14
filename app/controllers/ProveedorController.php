<?php

class ProveedorController extends BaseController {

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

		$proveedores = Proveedor::all();
		//make recibe la direccion de la CARPETA donde esta el index
		return View::make('proveedor.index')
						->with('proveedores', $proveedores);
	}


	/**
	 * Show the form for creating a new resource.
	 *
	 * @return Response
	 */
	public function create()
	{
		//redirige a la CARPETA donde esta la vista 
		return View::make('proveedor.create');
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
		$proveedor = new Proveedor;
		$proveedor->nombre = $input['nombre'];
		$proveedor->direccion = $input['direccion'];
		$proveedor->rfc = $input['rfc'];
		$proveedor->telefono = $input['telefono'];
		$proveedor->email = $input['email'];
		$proveedor->pagina_web = $input['web'];
		//si se guarda correctamente envia mensaje correcto
		//si no mostrara un mensaje de error 
		if($proveedor->save()){
			//crea una sesion temporal para mostrar un mensaje
			Session::flash('message', 'Guardado correctamente');
			Session::flash('class', 'success');
		}else{
			Session::flash('message', 'Ha ocurrido un error!');
			Session::flash('class', 'danger');
		}
		//redirige a la URL
		return Redirect::to('proveedores');

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
		//manda a la pagina para EDITAR una tupla en la base
		$proveedor = Proveedor::find($id);

		if($proveedor){
			return View::make('proveedor.edit')
							->with('proveedor',$proveedor);

		}else{
			Session::flash('message', 'No se encontro el tipo de cliente!');
			Session::flash('class', 'danger');
		}
		//redirige a la URL 
		return Redirect::to('proveedores');
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
		$proveedor = Proveedor::find($id);
		$proveedor->nombre = $input['nombre'];
		$proveedor->direccion = $input['direccion'];
		$proveedor->rfc = $input['rfc'];
		$proveedor->telefono = $input['telefono'];
		$proveedor->email = $input['email'];
		$proveedor->pagina_web = $input['web'];
		$proveedor->habilitado = $input['habilitado'];
		
		if($proveedor->save()){
			Session::flash('message', 'Actualizado correctamente');
			Session::flash('class', 'success');

		}else{
			Session::flash('message', 'Ha ocurrido un error!');
			Session::flash('class', 'danger');

		}
		//redirige a la URL
		return Redirect::to('proveedores');
	}


	/**
	 * Remove the specified resource from storage.
	 *
	 * @param  int  $id
	 * @return Response
	 */
	public function destroy($id)
	{
		$proveedor = Proveedor::find($id);

		try {

		    $proveedor->delete();
			Session::flash('message', 'Eliminado correctamente');
			Session::flash('class', 'danger');
			return Redirect::to('proveedores');

		}catch(Exception $e){
			$mensaje = 'Este proovedor esta siendo utilizado!<br/>
						Primero debes eliminar las compras relacionadas
						con el proveedor:'.$proveedor->nombre;
		    Session::flash('message', $mensaje);
			Session::flash('class', 'danger');
			return Redirect::to('proveedores');
		}

	}

//DESHABILITA--cambia el atributo 'habilitado'a FALSE
	public function delete($id)
	{
		$proveedor = Proveedor::find($id);
		$proveedor->habilitado = false;
		if($proveedor->save()){
			Session::flash('message', '*Eliminado correctamente');
			Session::flash('class', 'danger');

		}else{
			Session::flash('message', 'Ha ocurrido un error!');
			Session::flash('class', 'danger');

		}

		return Redirect::to('proveedores');
	}
//HABILITA--cambia el atributo 'habilitado'a TRUE
	public function habilitar($id)
	{
		$proveedor = Proveedor::find($id);
		$proveedor->habilitado = true;
		if($proveedor->save()){
			Session::flash('message', 'Habilitado correctamente');
			Session::flash('class', 'success');

		}else{
			Session::flash('message', 'Ha ocurrido un error!');
			Session::flash('class', 'danger');

		}

		return Redirect::to('proveedores');
	}

//JSON proveedores
	public function json($id){


		if ($id=='todos') {
			$proveedores = Proveedor::all();
			//Response::json($proveedores->toArray());
			return  $proveedores->toJson(); 

		}elseif (is_numeric($id)) {
			$proveedor = Proveedor::find($id);
			return  $proveedor;

		}
	}


}
