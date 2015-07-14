<?php

class VentaController extends BaseController {

	/**
	 * Display a listing of the resource.
	 *
	 * @return Response
	 */
	public function index()
	{
		$tiposDePago = TipoDePago::all()
						->lists('tipo_de_pago','id_tipo_de_pago');
		$negocio = DB::table('reglas_del_negocio')->get();
		$reglas=array();
		$reglasFitness=array();
		for ($i=0; $i < 6 ; $i++) { 
			$reglas[]=$negocio[$i];
			$reglasFitness[]=$negocio[$i+6];
		}

		return View::make('venta.index')
				->with('tiposDePago', $tiposDePago)
				->with('reglas', $reglas)
				->with('reglasFitness', $reglasFitness);
	}


	/**
	 * Show the form for creating a new resource.
	 *
	 * @return Response
	 */
	public function create()
	{
		//
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
		$detallesVenta = Input::get('detallesVenta');
		//si idCliente esta vacio le asiganmos 1
		if (($idCliente = Input::get('idCliente')) == '')
			$idCliente = '1';
		$idEmpleado = Session::get('idEmpleado');
		$idSucursal = Session::get('idSucursal');
		$idDatos = Session::get('idDatos');
		$idTipo = Session::get('idTipo');	//tipo de empleado
	//datos ventas productos		
		$codigos = Input::get('codigo');
		$cantidades = Input::get('cantidad');
		
		//return '<pre>'.print_r(Input::all(),true).'</pre>';

		$preciosProductos=array();
		$subtotales=array();
		$cantidadProductosDisponibles=array();
		$idSucursalesProductos=array();
		$totalOtros=0;
		$totalFitness=0;
		$cantidadOtros=0;
		$cantidadFitness=0;
		$categoria=array();
		for ($i=0; $i < count($codigos); $i++) { 
			//comporbamos que todavia haya producto disponible
			$cantidadProductosDisponibles[] = 
					DB::table('sucursales_productos')
			            ->where('id_sucursales_productos', 
			            			$idSucursal.$codigos[$i])
			            ->lists('cantidad')[0];
				//si no, mandamos un mensaje de error
			if ($cantidades[$i] > $cantidadProductosDisponibles[$i]){
				Session::flash('message', 
		    		'No hay suficientes productos disponibles! ID='.
		    		$codigos[$i]);
				Session::flash('class', 'danger');
				return Redirect::to('ventas');
			}
			$callProcedure = 'call SPD_CONSULTA_PRODUCTO_SUCURSAL('.
				$idSucursal.','.$codigos[$i].')';
			$producto = DB::select($callProcedure)[0];
			/*	este procedimiento devuelve:
				id_producto, nombre_producto, descripcion, categoria,
				cantidad, stock, precio_compra, precio_venta, 
				created_at, updated_at */
			//sumamos el total de productos fitness y otros
			$precio=$producto->precio_cliente_frecuente;
			$subtotal=$precio*$cantidades[$i];
			$preciosProductos[]=$precio;
			//calculamos el total de la venta
			$subtotales[] = $preciosProductos[$i] * $cantidades[$i];
			$categoria[] = strtoupper($producto->categoria);
			if($categoria[$i] == 'FITNESS'){
				$totalFitness += $subtotal;
				$cantidadFitness+=$cantidades[$i];
			}else{
				$totalOtros += $subtotal;
				$cantidadOtros+=$cantidades[$i];
			}

			//guardamos los ids sucursales_productos
			$idSucursalesProductos[] = $idSucursal.$codigos[$i];
		}
		$reglas = ReglasNegocio::all();
		$total = $totalOtros + $totalFitness;
		$totalProductos = $cantidadOtros + $cantidadFitness;
		$descuentoF=1;
		$descuentoO=1;
		if ($totalProductos==1) {
			if ($categoria[0] == 'FITNESS'){
				$descuentoF = $reglas[7]->descuento;
			}else{
				$descuentoO = $reglas[1]->descuento;
			}
		}else{
			
			$reglaMin=array();
			$reglaMax=array();
			$reglaMinF=array();
			$reglaMaxF=array();
			for ($i=0; $i < count($reglas)/2 ; $i++) { 
				$reglaMin[]=$reglas[$i]->minimo;
				$reglaMax[]=$reglas[$i]->maximo;
				$reglaMinF[]=$reglas[$i+6]->minimo;
				$reglaMaxF[]=$reglas[$i+6]->maximo;
				if ($cantidadFitness>=$reglaMinF[$i] && 
						$cantidadFitness<=$reglaMaxF[$i]) {
					$descuentoF = $reglas[$i+6]->descuento;
				}
				if ($total>=$reglaMin[$i] && $total<$reglaMax[$i]) {
					$descuentoO = $reglas[$i]->descuento;
				}
				
			}
		}
		$totalOtros *= $descuentoO;
		$totalFitness *= $descuentoF;
		$total = $totalOtros + $totalFitness;
		
		$datosVenta = array(
					'id_cliente'=>$idCliente,
					'id_empleado'=>$idEmpleado,
					'id_sucursal'=>$idSucursal,
					'total'=>$total,
					'detalles'=>$detallesVenta,
					'created_at' => $date,
					'updated_at' => $date);		
	// Start transaction!
		DB::beginTransaction();
	//agregar venta
		try {
		//insertamos compra y obetenemos el ID
			DB::table('ventas')
					->insert($datosVenta);
			$idVenta=DB::getPdo()->lastInsertId();
		//obtenemos los tipos de pago y su importe para agregarlos 
		//a ventas_tipo_de_pago
			$cantidadTipoPago = Input::get('cantidadTipoPago');
			foreach ($cantidadTipoPago as $idTipo => $importe) {
				if($importe > 0){
					//obtiene el importe, el tipo de pago y 
						//agrega inmediatamente
					$datosTipoPago = array(
						'id_venta'=>$idVenta,
						'id_tipo_de_pago' =>$idTipo,
						'importe_pagado'=>$importe,
						'created_at' => $date,
						'updated_at' => $date);
					
					DB::table('ventas_tipo_de_pago')
						->insert($datosTipoPago);
				}
			}
		} catch(Exception $e) {
		// Rollback y redirige con mensaje especificando error
		    DB::rollback();
		    Session::flash('message', 
		    	'Ha ocurrido un error insertando los datos de la venta!');
			Session::flash('class', 'danger');
			return Redirect::to('ventas');
		}
	//datos ventas_productos
		$datosVentasProductos=array();
		for ($i=0; $i < count($codigos); $i++) {
			if($categoria[$i] == 'FITNESS')
				$precioDescuento=$preciosProductos[$i]*$descuentoF;
			else
				$precioDescuento=$preciosProductos[$i]*$descuentoO;

			$datosVentasProductos[]=array(
				'id_venta'=>$idVenta,
				'id_producto'=>$codigos[$i],
				'cantidad'=>$cantidades[$i],
				'precio_unitario'=>$precioDescuento,
				'created_at' => $date,
				'updated_at' => $date);
		}
	//agrega ventas productos(detalles de ventas)
		try {

			for ($i=0; $i < count($datosVentasProductos); $i++) 
				DB::table('ventas_productos')
					->insert($datosVentasProductos[$i]);

		} catch(Exception $e) {
		// Rollback y redirige con mensaje especificando error
		    DB::rollback();
		    Session::flash('message', 
		    	'Ha ocurrido un error insertando los detalles de la venta!');
			Session::flash('class', 'danger');
			return Redirect::to('ventas');
		}
	//actualizar sucursales productos
		try {

			for ($i=0; $i < count($codigos); $i++) 
				DB::table('sucursales_productos')
		            ->where('id_sucursales_productos', $idSucursalesProductos[$i])
		            ->decrement('cantidad', $cantidades[$i]);
		
		} catch(Exception $e) {
		// Rollback y redirige con mensaje especificando error
		    DB::rollback();
		    Session::flash('message', 
		    	'Ha ocurrido un error actualizando los 
		    	productos en la sucursal!');
			Session::flash('class', 'danger');
			return Redirect::to('ventas');
		}
	// Commit the queries!
		DB::commit();
	//iniciamos PDF
		$productos = json_decode(VentasProductos::json('ticket',$idVenta)
					->getContent());
		$p=count($productos)+35;
		//return '<pre>'.print_r($productos,true).'</pre>';
		$pdf = new PDF('P','mm', array(35, $p) );
		$pdf->setTicket(true);
		$pdf->setFolio($idVenta);
		$pdf->AddPage();
		$pdf->SetFillColor(240,240,255);
		$pdf->Ln(2);
	//PRODUCTOS
		$tableName='DETALLES';
		$totalProductos=0;
		$filas=array();
		$ancho=array(3, 20, 10);
		$tableHeaders=array(
				array($ancho[0],' # ', ''),
				array($ancho[1],'Nombre', 'C'),
				array($ancho[2],'Importe', 'R')
			);
        $posicion=array('C', '', 'R');
        foreach ($productos as $i => $producto) {
			$subtotal=$producto->cantidad*$producto->precio_unitario;
			$filas[]=array(
					$producto->cantidad,
					substr($producto->nombre_producto,0,40).' '.
						substr($producto->descripcion,0,30),
					'$'.$subtotal
				);
		    $totalProductos+=$subtotal;
		}

		if (isset($i)) {
			$this->headerTabla($tableName, $tableHeaders, $pdf);
	        $this->bodyTabla($filas, $ancho, $posicion, $pdf);
			$pdf->SetFillColor(230,230,230);
			$this->footerTabla('productos', $totalProductos, $i, $pdf);

		}else{
			Session::flash('message', 
		    	'Ha ocurrido un error en la impresion del ticket');
			Session::flash('class', 'danger');
			return Redirect::to('ventas');
		}
		$pdf->Ln(5);
		
	//imprimimos el PDF
        $pdf->Output();
        exit;

		//return PDF::load($html.$css, 'letter', 'portrait')->show();	
		/*
		Session::flash('message', 'Venta registrada correctamente');
		Session::flash('class', 'success');
		return Redirect::to('ventas');
		return 	'venta: '.$idVenta.
				'<br>cantidadOtros: '.$cantidadOtros.
				'<br>cantidadFitness: '.$cantidadFitness.
				'<br>descuentoO: '.$descuentoO.
				'<br>descuentoF: '.$descuentoF.
				'<br>totalOtros: '.$totalOtros.
				'<br>totalFitness: '.$totalFitness.
				'<br>total: '.$total.
				'<pre>'.print_r($datosVenta,true).
				'<pre>'.print_r($reglas,true).
				'<pre>'.print_r($idSucursalesProductos,true).
				'<pre>'.print_r(Input::all(),true);
		*/

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
//Funciones par hacer las tablas
	public function bodyTabla($filas, $ancho, $posicion, $pdf){
		foreach ($filas as $i => $fila) {
			if(($i%2)==0){
		        $pdf->SetFillColor(255,255,255);
		    }else{
		        $pdf->SetFillColor(250,250,250);
		    }
		    foreach ($fila as $j => $columna)
		    	$pdf->Cell($ancho[$j],1,$fila[$j],0,0,$posicion[$j],true);
		    $pdf->Ln();
		}
	}

	public function footerTabla($tabla, $ntotal, $i, $pdf){
		$pdf->Cell(33,2,'___________',0,0,'R');
		$pdf->Ln();
		$pdf->Cell(26,2,'Total :',0,0,'R',true);
		$pdf->SetFont('Arial','B',3);
		$pdf->Cell(7,2,'$'.
			number_format($ntotal,2),0,0,'R',true);
		$pdf->SetFont('Arial','B',2);
	}

	public function headerTabla($tableName, $tableHeaders, $pdf){
		$pdf->SetFillColor(255,255,255);
		$pdf->Cell(19,3,$tableName,0,0,'R',true);
		$pdf->Ln();
		$pdf->SetFillColor(240,240,240);
		foreach ($tableHeaders as $i => $th) {
			$pdf->Cell($th[0],1,$th[1],0,0,$th[2],true);	
		}
		$pdf->Ln();
	}
//JSON ventas
	public function json($accion, $id){

		switch ($accion) {
			case 'todos':
				$ventas = Venta::all();
				return  Response::json($ventas->toArray());
				break;
			
			case 'corte':
				$ventas = DB::select(
					'call SPD_CONSULTAR_VENTAS_PARACORTE');
				return  Response::json($ventas);
				break;
			
			case 'corteSucursal':
				$ventas = DB::select(
					'call SPD_CONSULTAR_VENTAS_SUCURSAL_PARACORTE
					(?)',array($id));
				return  Response::json($ventas);
				break;
			
			case 'corteEmpleado':
				$ventas = DB::select(
					'call SPD_CONSULTAR_VENTAS_EMPLEADO_PARACORTE
					(?)',array($id));
				return  Response::json($ventas);
				break;
			
			case 'ventaSucursal':
				$venta = Venta::find($id);
				return  Response::json($venta);
				break;
			
			case 'detallesVenta':
				$detallesVenta = VentasProductos::where('id_venta',$id)->get();
				return  Response::json($detallesVenta->toArray());
				break;
			
			case 'empleado':
				$ventas = Venta::where('id_empleado',$id)->get();
				return  Response::json($ventas->toArray());
				break;
			
			case 'sucursal':
				$ventas = Venta::where('id_sucursal',$id)->get();
				return  Response::json($ventas->toArray());
				break;
			
			case 'fecha':
				$fecha = explode('_', $id);
				//para que busque hasta el utimo dia, hasta la ultima hora
				$fecha[1] = $fecha[1].' 23:59:59';
				$ventas = Venta::whereBetween('created_at', $fecha)->get();
				return  Response::json($ventas);
				break;
			
			default:
				return  Response::json(['error']);
				break;
		}
	}

}
