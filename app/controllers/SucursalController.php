<?php


class SucursalController extends BaseController {

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

		$sucursales = Sucursal::all();
		//make recibe la direccion de la CARPETA donde esta el index
		return View::make('sucursal.index')
						->with('sucursales', $sucursales);
	}


	/**
	 * Show the form for creating a new resource.
	 *
	 * @return Response
	 */
	public function create()
	{
		//redirige a la CARPETA donde esta la vista 
		return View::make('sucursal.create');
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
		$sucursal = new Sucursal;
		$sucursal->nombre_sucursal = $input['nombre'];
		$sucursal->direccion = $input['direccion'];
		$sucursal->telefono = $input['telefono'];
		$sucursal->email = $input['email'];
		//si se guarda correctamente envia mensaje correcto
		//si no mostrara un mensaje de error 
		
		try {
		//Mensaje exitoso
			$sucursal->save();
			Session::flash('message', 'Guardado correctamente');
			Session::flash('class', 'success');
			return Redirect::to('sucursales');

		} catch (Exception $e) {
		//mensaje error
			Session::flash('message', 'Ha ocurrido un error!');
			Session::flash('class', 'danger');
			return Redirect::to('sucursales');

		}
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
		$sucursal = Sucursal::find($id);

		if($sucursal){
			return View::make('sucursal.edit')
							->with('sucursal',$sucursal);

		}else{
			Session::flash('message', 'No se encontro el tipo de cliente!');
			Session::flash('class', 'danger');
		}
		//redirige a la URL 
		return Redirect::to('sucursales');
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
		$sucursal = Sucursal::find($id);
		$sucursal->nombre_sucursal = $input['nombre'];
		$sucursal->direccion = $input['direccion'];
		$sucursal->telefono = $input['telefono'];
		$sucursal->email = $input['email'];
		$sucursal->habilitado = $input['habilitado'];
		
		if($sucursal->save()){
			Session::flash('message', 'Actualizado correctamente');
			Session::flash('class', 'success');

		}else{
			Session::flash('message', 'Ha ocurrido un error!');
			Session::flash('class', 'danger');

		}
		//redirige a la URL
		return Redirect::to('sucursales');
	}


	/**
	 * Remove the specified resource from storage.
	 *
	 * @param  int  $id
	 * @return Response
	 */
	public function destroy($id)
	{
		$sucursal = Sucursal::find($id);

		try {

		    $sucursal->delete();
			Session::flash('message', 'Eliminado correctamente');
			Session::flash('class', 'danger');
			return Redirect::to('sucursales');

		}catch(Exception $e){
			$mensaje = 'Este tipo de sucursal esta siendo utilizado!<br/>
						Primero debes eliminar todos los registros que 
						tengan la sucursal: '.$sucursal->nombre_sucursal;
		    Session::flash('message', $mensaje);
			Session::flash('class', 'danger');
			return Redirect::to('sucursales');
		}

	}


	public function delete($id)
	{
		$sucursal = Sucursal::find($id);
		$sucursal->habilitado = false;
		if($sucursal->save()){
			Session::flash('message', '*Eliminado correctamente');
			Session::flash('class', 'danger');

		}else{
			Session::flash('message', 'Ha ocurrido un error!');
			Session::flash('class', 'danger');

		}

		return Redirect::to('sucursales');
	}

	public function habilitar($id)
	{
		$sucursal = Sucursal::find($id);
		$sucursal->habilitado = true;
		if($sucursal->save()){
			Session::flash('message', 'Habilitado correctamente');
			Session::flash('class', 'success');

		}else{
			Session::flash('message', 'Ha ocurrido un error!');
			Session::flash('class', 'danger');

		}

		return Redirect::to('sucursales');
	}

//JSON Sucursales
	public function json($id){

		if ($id=='todos') {
			$sucursales = Sucursal::all();
			return  Response::json($sucursales->toArray());

		}elseif (is_numeric($id)) {
			$sucursal = Sucursal::find($id);
			return  Response::json($sucursal->toArray());

		}
	}
//Autocompletar
	public function autocompletar(){

		$str = '%'.Input::get('term').'%';
		$sucursales = DB::table('sucursales')
						->where('nombre_sucursal', 'LIKE', $str)
						->take(5)->get(); 
		$resultado = array();
		foreach ($sucursales as $sucursal)
			$resultado[] = [ 	'id' => $sucursal->id_sucursal, 
							'value' => $sucursal->nombre_sucursal,
							'direccion'=>$sucursal->direccion,
							'telefono' => $sucursal->telefono,
							'email' => $sucursal->email ];


		return Response::json($resultado);

		/*
		$products = Product::where('published', true)
			->orWhere('name','like','%'.$query.'%')
			->orderBy('name','asc')
			->take(5)
			->get(array('slug','name','icon'))->toArray();
		*/

	}

}
