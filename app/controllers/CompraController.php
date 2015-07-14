<?php

class CompraController extends BaseController {

	public function __construct()
    {
    	//llama al filtro auth en filters.php
        $this->beforeFilter('salteVendedor');
    }
    /**
	 * Display a listing of the resource.
	 *
	 * @return Response
	 */
	public function index()
	{
		$proveedores = Proveedor::all()->lists('nombre','id_proveedor');
		$tiposDePago = TipoDePago::all()
						->lists('tipo_de_pago','id_tipo_de_pago');


		return View::make('compra.index')
						->with('proveedores', $proveedores)
						->with('tiposDePago', $tiposDePago);
	}


	/**
	 * Show the form for creating a new resource.
	 *
	 * @return Response
	 */
	public function create()
	{
		//nadaaaaa
	}


	/**
	 * Store a newly created resource in storage.
	 *
	 * @return Response
	 */
	public function store()
	{

		$date = new DateTime;
	//obetenemos los ids y datos necesarios para registrar una compra
		$factura = Input::get('facturaCompra');
		$totalCompra = 0;
		$fechaCompra = Input::get('fechaCompra');
		$detallesCompra = Input::get('detallesCompra');
		$idProvedor = Input::get('cmbProveedores');
		$idEmpleado = Session::get('idEmpleado');
		$idDatos = Session::get('idDatos');
		$idTipo = Session::get('idTipo');	//tipo de empleado
		$idSucursal = Session::get('idSucursal');

		$codigoC = Input::get('codigoC');
		$caducidadC = Input::get('caducidadC');
		$cantidadC = Input::get('cantidadC');
		$precioCompraC = Input::get('precioCompraC');

		for ($i=0; $i < count($codigoC); $i++)
			$totalCompra += $precioCompraC[$i] * $cantidadC[$i];

		$datosCompra=array(
					'id_sucursal' => $idSucursal,
					'id_proveedor' => $idProvedor,
					'id_empleado' => $idEmpleado,
					'numero_de_nota' => $factura,
					'total' => $totalCompra, 
					'fecha' => $fechaCompra, 
					'detalles' => $detallesCompra,
					'created_at' => $date,
					'updated_at' => $date);

	// Start transaction!
		DB::beginTransaction();
	//agregar Compra
		try {
			DB::table('compras')
					->insert($datosCompra);
			$idCompra=DB::getPdo()->lastInsertId();
		//insertamos compra y obetenemos el ID
		//obtenemos los tipos de pago y su importe para agregarlos 
		//a compras_tipo_de_pago
					
			$cantidadTipoPago = Input::get('cantidadTipoPago');
			foreach ($cantidadTipoPago as $idTipo => $importe) {
				if($importe==true){
					//obtiene el importe del tipo de pago y lo agrega
					$datosTipoPago = array(
						'id_compra'=>$idCompra,
						'id_tipo_de_pago' =>$idTipo,
						'importe_pagado'=>$importe,
						'created_at' => $date,
						'updated_at' => $date);
					
					DB::table('compras_tipo_de_pago')
						->insert($datosTipoPago);
				}
			}	
		} catch(Exception $e) {
		// Rollback y redirige con mensaje especificando error
		    DB::rollback();
		    Session::flash('message', 
		    	'Ha ocurrido un error insertando los datos de la compra!');
			Session::flash('class', 'danger');
			return Redirect::to('compras');
		}

	//datos compras productos		
		//$codigoC
		//$cantidadC
		//$caducidadC
		//$precioCompraC

		$datosComprasProductosC=array();
		for ($i=0; $i < count($codigoC); $i++) { 
			$datosComprasProductosC[]=array(
				'id_compra'=>$idCompra,
				'id_producto'=>$codigoC[$i],
				'cantidad'=>$cantidadC[$i],
				'fecha_caducidad'=>$caducidadC[$i],
				'precio_unitario'=>$precioCompraC[$i],
				'created_at' => $date,
				'updated_at' => $date);

		}
		//return '<pre>'.print_r($datosComprasProductosC,true);
	//agrega compras productos(detalles de compra)
		try {

			for ($i=0; $i < count($datosComprasProductosC); $i++) 
				DB::table('compras_productos')
					->insert($datosComprasProductosC[$i]);
		
		
		} catch(Exception $e) {
		// Rollback y redirige con mensaje especificando error
		    DB::rollback();
		    Session::flash('message', 
		    	'Ha ocurrido un error insertando los detalles de la compra!');
			Session::flash('class', 'danger');
			return Redirect::to('compras');
		}
	//datos sucursales productos
		$stockC = Input::get('stockC');
		$precioVentaC = Input::get('precioVentaC');

		$datosSucursalesProductosC=array();
		for ($i=0; $i < count($codigoC); $i++) { 
			$datosSucursalesProductosC[]=
		'update sucursales_productos set cantidad=cantidad+'.$cantidadC[$i].
			', stock='.$stockC[$i].
			' where id_sucursal='.$idSucursal.
			' and id_producto='.$codigoC[$i];
		}
	//actualizar sucursales productos
		try {

			for ($i=0; $i < count($datosSucursalesProductosC); $i++) 
				DB::update($datosSucursalesProductosC[$i]);
		
		} catch(Exception $e) {
		// Rollback y redirige con mensaje especificando error
		    DB::rollback();
		    Session::flash('message', 
		    	'Ha ocurrido un error agregando los 
		    	productos a la sucursal!');
			Session::flash('class', 'danger');
			return Redirect::to('compras');
		}
	// Commit the queries!
		DB::commit();
	//mensaje exitoso y redirige
		Session::flash('message', 'Compra registrada correctamente');
		Session::flash('class', 'success');
		return Redirect::to('compras');




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
		//
	}


	/**
	 * Update the specified resource in storage.
	 *
	 * @param  int  $id
	 * @return Response
	 */
	public function update($id)
	{
		//
	}


	/**
	 * Remove the specified resource from storage.
	 *
	 * @param  int  $id
	 * @return Response
	 */
	public function destroy($id)
	{
		//
	}

}
