<?php

class SucursalProductoController extends BaseController {

	/**
	 * Display a listing of the resource.
	 *
	 * @return Response
	 */
	public function index()
	{
		if(Session::get('tipo') == 'ADMINISTRADOR' || 
			Session::get('tipo') == 'GERENTE GENERAL'){
			$productos = DB::select(
					'call SPD_CONSULTAR_PRODUCTOS_SUCURSALES()');
		}else{
			$productos = DB::select(
					'call SPD_CONSULTAR_PRODUCTOS_SUCURSAL(?)',
					array( Session::get('idSucursal')));
		 }
		/* este procedimiento devuelve:
		id_producto, nombre_producto, descripcion, categoria,
		cantidad, stock, precio_compra, precio_venta, created_at, updated_at
		*/
		$query="select regla, descuento from reglas_del_negocio";
		$reglas = DB::select($query);
		//return '<pre>'.print_r($reglas,true).'</pre>';
		return View::make('sucursalProducto.index')
						->with('productos', $productos)
						->with('reglas', $reglas);
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
		$categorias = CategoriaDeProducto::all()
						->lists('categoria','id_categoria_de_producto');
		return View::make('sucursalProducto.create')
						->with('categorias', $categorias);
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
		$date = new DateTime;
		$idSucursal = Session::get('idSucursal');
	//obtenemos datos de los nuevos productos que se agregaran al catalog
		$codigoN = Input::get('codigoN');
		$productoN = Input::get('productoN');
		$descripcionN = Input::get('descripcionN');
		$categoriaN = Input::get('categoriaN');

		$numeroDeProductosN = count($codigoN);
		$datosProductoN = array();
		$datosSucursalesProductosN = array();

		$sucursales = Sucursal::all();
		$idSucursales = array();
	//obtenemos datos para sucursales_productos
		$stockN = Input::get('stockN');
		$precioCompraN = Input::get('precioCompraN');
		$precioVentaN = Input::get('precioVentaN');

		foreach ($sucursales as $i => $sucursal) {	
				$idSucursales[] = 
							$sucursal->id_sucursal;
		}	

		for ($i=0; $i < $numeroDeProductosN; $i++) { 
			$datosProductoN[] = array(
					'id_producto'=>$codigoN[$i],
					'nombre_producto'=> $productoN[$i],
					'descripcion'=> $descripcionN[$i],
					'id_categoria_de_producto'=>$categoriaN[$i],
					'precio_compra'=>$precioCompraN[$i],
					'precio_cliente_frecuente'=>$precioVentaN[$i],
					'created_at' => $date,
					'updated_at' => $date);
			$datosSucursalesProductosN[$i]=array();
			for ($j=0; $j < count($idSucursales); $j++) { 
				//cuando la sucursal es la del empleado
				if($idSucursales[$j] == $idSucursal){
					$datosSucursalesProductosN[$i][] = array(
						'id_sucursales_productos'=>$idSucursales[$j].$codigoN[$i],
						'id_sucursal'=> $idSucursales[$j],
						'id_producto'=>$codigoN[$i],
						'stock'=>$stockN[$i],
						'created_at' => $date,
						'updated_at' => $date);
				}
				else{
					$datosSucursalesProductosN[$i][] = array(
						'id_sucursales_productos'=>$idSucursales[$j].$codigoN[$i],
						'id_sucursal'=> $idSucursales[$j],
						'id_producto'=>$codigoN[$i],
						'created_at' => $date,
						'updated_at' => $date);
				}
			}
		}
	// Start transaction!
		DB::beginTransaction();

	//agregar Productos Nuevos y sucursales productos 
	 //cantidad=stock=precios=0
		try {
			$datos=array();
		//insertamos datos de los nuevos productos y en sucursales_productos
		//dejamos cantidad stock y precios en ceros para actualizar despues
			for ($i=0; $i < $numeroDeProductosN; $i++){
			//si el producto NO se encuentra en la tabla productos lo agrega
				if(!Producto::find($codigoN[$i])){
					DB::table('productos')
						->insert($datosProductoN[$i]);
						$datos[]=$datosProductoN[$i];
				}
			 //si el producto ya esta registrado manda mensaje
				else{
					DB::rollback();
				    Session::flash('message', 
				    	'Algun producto ya esta registrado con el mismo codigo!
				    	 No se agrego ningun producto :\'(');
					Session::flash('class', 'danger');
					return Redirect::to('sucursalesProductos');
				}
				for ($j=0; $j < count($idSucursales); $j++) { 
					$idSucPro = $idSucursales[$j].$codigoN[$i];
				//si NO existe el producto en la sucursal lo agrega
					if(!SucursalesProductos::find($idSucPro)){
						DB::table('sucursales_productos')
							->insert($datosSucursalesProductosN[$i][$j]);
					}else{
				//si ya existe en la sucursal manda mensaje
						DB::rollback();
					    Session::flash('message', 
					    	'Algun producto en la sucursal 
					    	ya esta registrado con el mismo codigo!
					    	 No se agrego ningun producto :\'(');
						Session::flash('class', 'danger');
						return Redirect::to('sucursalesProductos');
					}
				}
			}
				
		} catch(Exception $e) {
		// Rollback y redirige con mensaje especificando error
		    DB::rollback();
		    Session::flash('message', 
		    	'Ha ocurrido un error insertando los nuevos productos!');
			Session::flash('class', 'danger');
			return Redirect::to('sucursalesProductos');
		}
		
	// Commit the queries!
		DB::commit();
	//mensaje exitoso y redirige
		Session::flash('message', 'Productos agregados correctamente');
		Session::flash('class', 'success');
		return Redirect::to('sucursalesProductos');

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
		if ($vendedor=$this->salteVendedor())
			return Redirect::to('inicio');

		$producto = SucursalesProductos::find($id);
		/* este procedimiento devuelve:
		id_producto, nombre_producto, descripcion, categoria,
		cantidad, stock, precio_compra, precio_venta, created_at, updated_at
		*/
		return View::make('sucursalProducto.edit')
						->with('producto', $producto);
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
		$input = Input::all();
		$producto = SucursalesProductos::find($id);
		//return '<pre>'.print_r($producto, true).'</pre>';

		$producto->stock = $input['stock'];
		
		if($producto->save()){
			Session::flash('message', 'Actualizado correctamente');
			Session::flash('class', 'success');

		}else{
			Session::flash('message', 'Ha ocurrido un error!');
			Session::flash('class', 'danger');

		}

		return Redirect::to('sucursalesProductos');
		
	}

//borrar no esta disponible
	public function destroy($id)
	{
		return Redirect::to('sucursalesProductos');
		$producto = Producto::find($id);

	// Start transaction!
		DB::beginTransaction();
	//eliminar el Producto en cada sucursal y del catalogo
		try {
			DB::table('sucursales_productos')
				->where('id_producto', '=', $id)->delete();
			$producto->delete();

		} catch (Exception $e) {
			Session::flash('message', 'Ha ocurrido un al eliminar el producto!');
			Session::flash('class', 'danger');
			return Redirect::to('productos');	
		}
	// Commit the queries!
		DB::commit();
	//mensaje exitoso y redirige
		Session::flash('message', 'Eliminado correctamente');
		Session::flash('class', 'success');
		return Redirect::to('sucursalesProductos');
	}


}
