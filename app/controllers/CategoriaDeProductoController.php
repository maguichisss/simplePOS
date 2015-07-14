<?php

class CategoriaDeProductoController extends BaseController {

	/**
	 * Display a listing of the resource.
	 *
	 * @return Response
	 */
	public function index()
	{
		if ($gerenteSucursal=$this->salteGerenteSucursal())
			return Redirect::to('inicio');
		//$categorias = CategoriaDeProducto::habilitado();
		$categorias = CategoriaDeProducto::all();
		//$categorias = CategoriaDeProducto::whereHabilitado(false)->get();
		//make recibe la direccion donde esta el index
		return View::make('categoriaDeProducto.index')
						->with('categorias', $categorias);
	}


	/**
	 * Show the form for creating a new resource.
	 *
	 * @return Response
	 */
	public function create()
	{
		if ($gerenteSucursal=$this->salteGerenteSucursal())
			return Redirect::to('inicio');
		//redirige a la vista create.blade.php
		return View::make('categoriaDeProducto.create');
	}


	/**
	 * Store a newly created resource in storage.
	 *
	 * @return Response
	 */
	public function store()
	{
		if ($gerenteSucursal=$this->salteGerenteSucursal())
			return Redirect::to('inicio');
		//creamos objeto categoria y le guardamos lo que trajo 
		//el formulario de la pagina create 
		$categoria = new CategoriaDeProducto;
		$categoria->categoria = Input::get('categoria');
		//si se guarda correctamente envia mensaje correcto con estilo success
		//si no mostrara un mensaje de error 
		
		try {
		//mensaje exitoso
			$categoria->save();
			Session::flash('message', 'Guardado correctamente');
			Session::flash('class', 'success');
			return Redirect::to('categoriasDeProductos');

		} catch (Exception $e) {
		//mensaje error
			Session::flash('message', 'Ha ocurrido un error!');
			Session::flash('class', 'danger');
			return Redirect::to('categoriasDeProductos');			
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

	}


	/**
	 * Show the form for editing the specified resource.
	 *
	 * @param  int  $id
	 * @return Response
	 */
	public function edit($id)
	{
		if ($gerenteSucursal=$this->salteGerenteSucursal())
			return Redirect::to('inicio');
		//este metodo busca un categoria y redirige a la vista edit para editarlo
		try {

			$categoria = CategoriaDeProducto::find($id);

			if($categoria){
				//si el categoria exite envia sus datos a la vista edit.blade.php
				return View::make('categoriaDeProducto.edit')
								->with('categoria',$categoria);
			}else{
				Session::flash('message', 'No se encontro la categoria!');
				Session::flash('class', 'danger');
			}
			//si no, redirige a categoria y mostrara un mensaje de error
			return Redirect::to('categoriaDeProducto');



		} catch (Exception $e) {
			Session::flash('message', 'No se encontro la categoria!');
			Session::flash('class', 'danger');
			return Redirect::to('categoriaDeProducto');
		}

	}


	/**
	 * Update the specified resource in storage.
	 *
	 * @param  int  $id
	 * @return Response
	 */
	public function update($id)
	{
		if ($gerenteSucursal=$this->salteGerenteSucursal())
			return Redirect::to('inicio');
		$input = Input::all();
		$categoria = CategoriaDeProducto::find($id);
		$categoria->categoria = $input['categoria'];
		$categoria->habilitado = $input['habilitado'];
		
		try {

		    if($categoria->save()){
				Session::flash('message', 'Actualizado correctamente');
				Session::flash('class', 'success');

			}else{
				Session::flash('message', 'Ha ocurrido un error!');
				Session::flash('class', 'danger');

			}
			//redirige a categoriaDeProducto.index
			return Redirect::to('categoriasDeProductos');

		}catch(Exception $e){
			$mensaje = 'Esta categoria esta siendo utilizada!<br/>
						Primero debes eliminar los productos que 
						tengan la categoria "'.$categoria->categoria.'"';
		    Session::flash('message', $mensaje);
			Session::flash('class', 'danger');
			return Redirect::to('categoriasDeProductos');
		}
	}


	/**
	 * Remove the specified resource from storage.
	 *
	 * @param  int  $id
	 * @return Response
	 */
	public function destroy($id)
	{
		if ($gerenteSucursal=$this->salteGerenteSucursal())
			return Redirect::to('inicio');
		$categoria = CategoriaDeProducto::find($id);

		try {

		    $categoria->delete();
			Session::flash('message', 'Eliminado correctamente');
			Session::flash('class', 'warning');
			return Redirect::to('categoriasDeProductos');

		}catch(Exception $e){
			$mensaje = 'Esta categoria esta siendo utilizada!<br/>
						Primero debes eliminar los productos que 
						tengan la categoria "'.$categoria->categoria.'"';
		    Session::flash('message', $mensaje);
			Session::flash('class', 'danger');
			return Redirect::to('categoriasDeProductos');
		}

	}

	public function delete($id)
	{
		$categoria = CategoriaDeProducto::find($id);
		$categoria->habilitado = false;
		if($categoria->save()){
			Session::flash('message', '*Eliminado correctamente');
			Session::flash('class', 'warning');

		}else{
			Session::flash('message', 'Ha ocurrido un error!');
			Session::flash('class', 'danger');

		}

		return Redirect::to('categoriasDeProductos');
	}

	public function habilitar($id)
	{
		$categoria = CategoriaDeProducto::find($id);
		$categoria->habilitado = true;
		if($categoria->save()){
			Session::flash('message', 'Habilitado correctamente');
			Session::flash('class', 'success');

		}else{
			Session::flash('message', 'Ha ocurrido un error!');
			Session::flash('class', 'danger');

		}

		return Redirect::to('categoriasDeProductos');
	}


//JSON Sucursales
	public function json($id){

		if ($id=='todos') {
			$categoriasDeProductos = CategoriaDeProducto::all();
			return  Response::json($categoriasDeProductos->toArray());

		}elseif (is_numeric($id)) {
			$categoriaDeProducto = CategoriaDeProducto::find($id);
			return  Response::json($categoriaDeProducto->toArray());

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
