<?php

class ProductoController extends BaseController {

	/**
	 * Display a listing of the resource.
	 *
	 * @return Response
	 */
	public function index()
	{
		// Para mostrar 5 items por pagina
		$productos =Producto::orderBy('nombre_producto', 'asc')->get();
		
		foreach ($productos as $i => $producto) {
			$categoria = DB::table('categorias_de_productos')
	            ->where('id_categoria_de_producto',
	            					$producto->id_categoria_de_producto)
	            ->lists('categoria');
	        //cambiamos el id al nombre de la categoria
	        $producto->id_categoria_de_producto=$categoria[0];

		}

		//make recibe la direccion donde esta el index
		return View::make('producto.index')
						->with('productos', 
								$productos);
	}


	/**
	 * Show the form for creating a new resource.
	 *
	 * @return Response
	 */
	public function create()
	{
		if ($vendedor=$this->salteVendedor())
			return Redirect::to('inicio');
		//redirige a la vista create.blade.php
		$categorias = CategoriaDeProducto::all()
						->lists('categoria','id_categoria_de_producto');
		return View::make('producto.create')->with('categorias', $categorias);
	}


	/**
	 * Store a newly created resource in storage.
	 *
	 * @return Response
	 */
	public function store()
	{
		if ($vendedor=$this->salteVendedor())
			return Redirect::to('inicio');
		//validamos los datos que introdujo el usuario
		$datos = array(
			'codigo' => Input::get( 'codigo' )	);
		$reglas = array(
			'codigo' => 'required|unique:productos,id_producto' );
		$mensajes = array(
			'required' => 'El codigo es obligatorio',
			'unique' => 'El codigo de producto ya esta registrado' );

		$validacion = Validator::make($datos, $reglas, $mensajes);
		//si la validacion que el codigo sea unico falla, manda error
		if ( $validacion->fails() ) {
		    $errors = $validacion->messages();
		    Session::flash('message', $errors->first());
			Session::flash('class', 'danger');
			return Redirect::to('productos');
		}
		$date = new DateTime;
		//obtenemos datos del producto
		$product = array(
			'id_producto' => Input::get('codigo'),
			'nombre_producto' => Input::get('productouuu'),
			'descripcion' => Input::get('descripcionnn'),
			'id_categoria_de_producto' => Input::get('categoria'),
			'precio_compra'=> Input::get('precioCompra'),
			'precio_cliente_frecuente'=> Input::get('precioCliente'),
			'created_at' => $date,
			'updated_at' => $date	);
		
		$sucursales = Sucursal::all();
		$sucursalesProductos = array();
		//obtenemos datos para sucursales_productos
		foreach ($sucursales as $i => $sucursal) {	
				$sucursalesProductos[] = array(
					'id_sucursales_productos'=>
							$sucursal->id_sucursal.Input::get('codigo'),
					'id_sucursal' =>$sucursal->id_sucursal,
					'id_producto'=>Input::get('codigo'),
					'created_at' => $date,
					'updated_at' => $date 	);
		}	
	// Start transaction!
		DB::beginTransaction();
	//agregar Producto en el catalogo y en cada sucursal
		try {
			//$producto->save();
			DB::table('productos')
				->insert($product);
			DB::table('sucursales_productos')
				->insert($sucursalesProductos);
			
		} catch (Exception $e) {
			Session::flash('message', 'Ha ocurrido un al registrar el producto!');
			Session::flash('class', 'danger');
			return Redirect::to('productos');	
		}
	// Commit the queries!
		DB::commit();
	//mensaje exitoso y redirige
		Session::flash('message', 'Porducto guardado correctamente');
		Session::flash('class', 'success');
		//redirige a producto
		return Redirect::to('productos');

	}


	/**
	 * Display the specified resource.
	 *
	 * @param  int  $id
	 * @return Response
	 */
	public function show($id)
	{
		if ($vendedor=$this->salteVendedor())
			return Redirect::to('inicio');
		//este metodo busca un producto 
		$producto = Producto::find($id);
		$categoria = CategoriaDeProducto::find
						( $producto->id_categoria_de_producto );
		if($producto){
			//si el producto exite envia sus datos a la vista show.blade.php
			return View::make('producto.show')
							->with('producto',$producto)
							->with('categoria',$categoria->categoria);
		}else{
			Session::flash('message', 'No se encontro el producto!');
			Session::flash('class', 'danger');
		}
		//si no, redirige a producto y mostrara un mensaje de error
		return Redirect::to('productos');
	}


	/**
	 * Show the form for editing the specified resource.
	 *
	 * @param  int  $id
	 * @return Response
	 */
	public function edit($id)
	{
		if ($vendedor=$this->salteVendedor())
			return Redirect::to('inicio');
		//este metodo busca un producto y redirige a la vista edit para editarlo
		$producto = Producto::find($id);
		$categorias = CategoriaDeProducto::all()
						->lists('categoria','id_categoria_de_producto');
		if($producto){
			//si el producto exite envia sus datos a la vista edit.blade.php
			return View::make('producto.edit')
							->with('producto',$producto)
							->with('categorias',$categorias);
		}else{
			Session::flash('message', 'No se encontro el producto!');
			Session::flash('class', 'danger');
		}
		//si no, redirige a producto y mostrara un mensaje de error
		return Redirect::to('productos');
	}


	/**
	 * Update the specified resource in storage.
	 *
	 * @param  int  $id
	 * @return Response
	 */
	public function update($id)
	{
		if ($vendedor=$this->salteVendedor())
			return Redirect::to('inicio');
		//recice los datos enviados de edit.blade.php y busca el producto
		//para actualizarlo
		$input = Input::all();
		$producto = Producto::find($id);
		$producto->nombre_producto = $input['productouuu'];
		$producto->descripcion = $input['descripcionnn'];
		$producto->id_categoria_de_producto = $input['categoria'];
		$producto->precio_compra = $input['precioCompra'];
		$producto->precio_cliente_frecuente = $input['precioCliente'];

		if($producto->save()){
			Session::flash('message', 'Actualizado correctamente');
			Session::flash('class', 'success');

		}else{
			Session::flash('message', 'Ha ocurrido un error!');
			Session::flash('class', 'danger');

		}
		//redirige a producto.index
		return Redirect::to('productos');
	}


	/**
	 * Remove the specified resource from storage.
	 *
	 * @param  int  $id
	 * @return Response
	 */
	public function destroy($id)
	{
		if ($vendedor=$this->salteVendedor())
			return Redirect::to('inicio');
		$producto = Producto::find($id);
		$sucursales = Sucursal::all();
		$idSucursalesProductos = array();
		//obtenemos datos para sucursales_productos
		foreach ($sucursales as $i => $sucursal) {	
				$idSucursalesProductos[] = 
							$sucursal->id_sucursal.$id;
		}	
		//return "<pre>".print_r($sucursales,true)."</pre>";
	// Start transaction!
		DB::beginTransaction();
	//eliminar el Producto en cada sucursal y del catalogo
		try {
			for ($i=0; $i < count($idSucursalesProductos); $i++) { 
				$sucProd = SucursalesProductos::find($idSucursalesProductos[$i]);
				if($sucProd)
					$sucProd->delete();
			}
			$producto->delete();

		} catch (Exception $e) {
			Session::flash('message', 
				'Ha ocurrido un error al eliminar el producto!');
			Session::flash('class', 'danger');
			return Redirect::to('productos');	
		}
	// Commit the queries!
		DB::commit();
	//mensaje exitoso y redirige
		Session::flash('message', 'Eliminado correctamente');
		Session::flash('class', 'success');
		//redirige a producto
		return Redirect::to('productos');

	}

//DESHABILITA--cambia el atributo 'habilitado'a FALSE
	public function delete($id)
	{
		$producto = Producto::find($id);
		$producto->habilitado = false;
		if($producto->save()){
			Session::flash('message', '*Eliminado correctamente');
			Session::flash('class', 'danger');

		}else{
			Session::flash('message', 'Ha ocurrido un error!');
			Session::flash('class', 'danger');

		}

		return Redirect::to('productos');
	}
//HABILITA--cambia el atributo 'habilitado'a TRUE
	public function habilitar($id)
	{
		$producto = Producto::find($id);
		$producto->habilitado = true;
		if($producto->save()){
			Session::flash('message', 'Habilitado correctamente');
			Session::flash('class', 'success');

		}else{
			Session::flash('message', 'Ha ocurrido un error!');
			Session::flash('class', 'danger');

		}

		return Redirect::to('productos');
	}
//JSON Productos
	public function json($id){

		if ($id=='todos') {
			$productos = Producto::all();
			return  Response::json($productos->toArray());

		}elseif (is_numeric($id)) {
			$producto = Producto::find($id);
			return  Response::json($producto);

		}
	}
//Autocompletar
	public function autocompletar(){

		if (isset($_GET['sucursalO']))
			$idSucursal = $_GET['sucursalO'];
		else
			$idSucursal = Session::get('idSucursal');

		$query="select p.*, sp.cantidad, sp.stock, 
					p.precio_cliente_frecuente, 
					p.precio_compra, sp.id_sucursal
				from productos as p, sucursales_productos as sp
				where sp.id_sucursal=".$idSucursal." 
					and sp.id_producto=p.id_producto
					and (p.nombre_producto like '%".Input::get('term')."%' 
					or p.id_producto 
					like '%".Input::get('term')."%') 
				limit 5";
		$productos = DB::select($query); 
		//return '<pre>'.print_r($productos,true);
		$resultado = array();
		foreach ($productos as $producto)
			$resultado[] = ['id' => $producto->id_producto, 
							'value' => $producto->id_producto.'|'.
									$producto->nombre_producto.'|'.
									$producto->descripcion,
							'producto'=>$producto->nombre_producto,
							'descripcion'=>$producto->descripcion,
							'idCateProducto'=>$producto->id_categoria_de_producto,
							'cantidad'=>$producto->cantidad,
							'stock'=>$producto->stock,
							'precioCompra'=>$producto->precio_compra,
							'precioVenta'=>$producto->precio_cliente_frecuente 
							];


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
