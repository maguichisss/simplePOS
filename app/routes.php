<?php

/*
|--------------------------------------------------------------------------
| Application Routes
|--------------------------------------------------------------------------
|
| Here is where you can register all of the routes for an application.
| It's a breeze. Simply tell Laravel the URIs it should respond to
| and give it the Closure to execute when that URI is requested.
|
*/

//rutas para login y logout 
	Route::resource('/', 'LoginController', 
		array('only' => array('index', 'store')));

	Route::resource('login', 'LoginController', 
		array('only' => array('index', 'store')));

	Route::get('logout', function(){
		Auth::logout();
		return Redirect::to('login');
	});

Route::get('inicio', array('before' => 'auth', function(){
	return View::make('inicio');
}));

//Rutas de productos
	Route::resource('productos', 'ProductoController');
	Route::get('productos.json/{id?}',
				'ProductoController@json');
	Route::get('productos.auto',
				'ProductoController@autocompletar');
//Rutas de categoriasDeProductos
	Route::resource('categoriasDeProductos', 'CategoriaDeProductoController');
	Route::get('categoriasDeProductos.json/{id?}',
				'CategoriaDeProductoController@json');
	Route::get('categoriasDeProductos.auto',
				'CategoriaDeProductoController@autocompletar');
//Rutas de tiposDePagos
	Route::resource('tiposDePagos', 'TipoDePagoController');
//Rutas de tiposDeClientes
	Route::resource('tiposDeClientes', 'TipoDeClienteController');
//Rutas de tiposDeEmpleados
	Route::resource('tiposDeEmpleados', 'TipoDeEmpleadoController');
//Rutas de empleados
	Route::resource('empleados', 'EmpleadoController');
	Route::get('empleados.json/{accion}/{id?}',
				'EmpleadoController@json');
	Route::post('empleados/delete/{id}', 
				'EmpleadoController@delete');
	Route::post('empleados/habilitar/{id}', 
			'EmpleadoController@habilitar');
//Rutas de clientes
	Route::resource('clientes', 'ClienteController');
	Route::get('clientes.auto',
				'ClienteController@autocompletar');
//Rutas de sucursales
	Route::resource('sucursales', 'SucursalController');
	Route::get('sucursales.json/{id?}',
				'SucursalController@json');
	Route::get('sucursales.auto',
				'SucursalController@autocompletar');
//Rutas de proveedores
	Route::resource('proveedores', 'ProveedorController');
	Route::get('proveedores.json/{id?}',
				'ProveedorController@json');
	Route::get('proveedores.auto/{str?}',
				'ProveedorController@autocompletar');
//Rutas de compras
	Route::resource('compras', 'CompraController');
//Rutas de transferencias
	Route::resource('transferencias', 'TransferenciaController');
//Rutas de egresos
	Route::resource('egresos', 'EgresoController');
//Rutas de sucursalesProductos
	Route::resource('sucursalesProductos', 'SucursalProductoController');
//Rutas de ventas
	Route::resource('ventas', 'VentaController');
	Route::get('ventas.json/{accion}/{id?}',
				'VentaController@json');
//Rutas de devoluciones
	Route::resource('devoluciones', 'DevolucionController');
	Route::get('devoluciones.json/{accion}/{id?}',
				'DevolucionController@json');
//Rutas de corte de Caja
	Route::resource('corteDeCaja', 'CorteDeCajaController');
	Route::get('corteDeCaja.json/{accion}/{id?}',
				'CorteDeCajaController@json');
//reportes
	Route::resource('reportes', 'ReporteController');

//HTTP NOT FOUND
	App::missing(function($exception)
	{
		Session::flash('message', 'Ha ocurrido un error!');
		Session::flash('class', 'danger');
	    // shows an error page (app/views/error.blade.php)
	    // returns a page not found error
	    // return Response::view('error', array(), 404);
	    return Redirect::to('inicio');
	});

//entrado a la uri registrar, inserta un nuevo usuario a la base de datos
//para esto debes tener un modelo User y un UserController
//registrar
	Route::get('registrar', function()
	{
		$user = new User;

		$user->username = 'superadmin1';
		$user->password = Hash::make('123');
		
		if($x=$user->save())
			return 'El usuario fue agregado con el id: '.
					DB::getPdo()->lastInsertId().'___<br/>'.
					$x.'___<br/>';
		else
			return 'Ocurrio un error al insertar el usuario';

	});

//pruebas
	Route::get('/pruebas', function(){

		$html = '<html><body>';
	    $html.= '<p style="color:red">Generando un sencillo pdf ';
	    $html.= 'de forma realmente sencilla.</p>';
	    $html.= '</body></html>';
	    //return PDF::url('http://google.com');
	    return PDF::load($html, 'letter', 'portrait')->show();
	//To turn a timestamp into a string, you can use date(), ie:
	//	$string = date("Y-m-d", mt_rand(162055681,1262055681*2) );

		return View::make('master.pruebas');





	});


