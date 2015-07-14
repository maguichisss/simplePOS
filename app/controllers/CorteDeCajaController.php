<?php

class CorteDeCajaController extends BaseController {

	/**
	 * Display a listing of the resource.
	 *
	 * @return Response
	 */
	public function index()
	{
		$tipo=Session::get('tipo');
		$idSucursal=Session::get('idSucursal');
		$idEmpleado=Session::get('idEmpleado');
		if ($tipo == 'VENDEDOR'){
			$emp = DB::select('call SPD_CONSULTA_EMPLEADO(?)'
								,array($idEmpleado));
			$sucursal = Sucursal::
						where('id_sucursal',$idSucursal)
						->select('nombre_sucursal','id_sucursal')
						->get()[0];
			$sucursales[$sucursal->id_sucursal]=
				$sucursal->nombre_sucursal;
			$empleados = array();
			foreach ($emp as $id => $empleado) {
				$empleados[$empleado->id_empleado]=
								$empleado->username.'|'.
								$empleado->nombre.' '.
								$empleado->apellido_paterno;
			}
			/*
			$ventas = DB::select(
						'call SPD_CONSULTAR_VENTAS_EMPLEADO_PARACORTE(?)',
						array($idEmpleado));
			$devoluciones = 
				DB::select(
				'call SPD_CONSULTAR_DEVOLUCIONES_EMPLEADO_PARACORTE(?)',
				array($idEmpleado));
			*/
		}else if($tipo == 'GERENTE DE SUCURSAL'){
			$emp = DB::select('call SPD_CONSULTA_EMPLEADOS_SUCURSAL(?)'
								,array($idSucursal));
			$sucursal = Sucursal::
						where('id_sucursal',$idSucursal)
						->select('nombre_sucursal','id_sucursal')
						->get()[0];
			$sucursales[$sucursal->id_sucursal]=
				$sucursal->nombre_sucursal;
			$empleados = array();
			$empleados[] = 'Todos...' ;
			foreach ($emp as $id => $empleado) {
				$empleados[$empleado->id_empleado]=
								$empleado->username.'|'.
								$empleado->nombre.' '.
								$empleado->apellido_paterno;
			}
			/*
			$ventas = DB::select(
						'call SPD_CONSULTAR_VENTAS_SUCURSAL_PARACORTE(?)',
						array($idSucursal));
			$devoluciones = 
				DB::select(
				'call SPD_CONSULTAR_DEVOLUCIONES_SUCURSAL_PARACORTE(?)',
				array($idSucursal));
			*/
		}else{
			$emp = DB::select('call SPD_CONSULTAR_EMPLEADOS');
			$sucursales = Sucursal::all()
						->lists('nombre_sucursal','id_sucursal');
			$empleados = array();
			$empleados[] = 'Todos...' ;
			foreach ($emp as $id => $empleado) {
				$empleados[$empleado->id_empleado]=
								$empleado->username.'|'.
								$empleado->nombre.' '.
								$empleado->apellido_paterno;
			}
			/*
			$ventas = DB::select('call SPD_CONSULTAR_VENTAS_PARACORTE');
			$devoluciones = 
				DB::select('call SPD_CONSULTAR_DEVOLUCIONES_PARACORTE');
			array_unshift($empleados, 'Todos...');
			*/
			$x=$sucursales;
			$y=$empleados;
			array_unshift($sucursales, 'Todos...');
		}
		/*
		return '<pre>'.print_r($x,true).print_r($sucursales,true)
					.print_r($y,true).print_r($empleados,true);
		*/
		return View::make('corteDeCaja.index')
					//->with('ventas', $ventas)
					//->with('devoluciones', $devoluciones)
					->with('empleados', $empleados)
					->with('sucursales', $sucursales);
		
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
		$idEmpleado = Input::get('cmbEmpleados');
		$idSucursal = Input::get('cmbSucursales');
		$fechaInicio = Input::get('fechaInicio');
		$fechaFin = Input::get('fechaFin');
	//obtenemos DEVOLUCIONES, PRODUCTOS, EGRESOS
		if ($idSucursal == false && $idEmpleado == false) {
			//corte de TODO
			$devoluciones = 
				json_decode(
					Devolucion::json('fecha',$fechaInicio.'_'.$fechaFin)
						->getContent());
			$productos = 
				json_decode(
					VentasProductos::json('fecha',
								$fechaInicio.'_'.$fechaFin)
						->getContent());
			$importes = 
				json_decode(
					VentasProductos::json('importeFecha', 
								$fechaInicio.'_'.$fechaFin)
						->getContent());
			$egresos = 
				json_decode(
					Egreso::json('fecha', $fechaInicio.'_'.$fechaFin)
						->getContent());
			$empleados = DB::select('call SPD_CONSULTAR_EMPLEADOS');
			$sucursales = Sucursal::all();

		}elseif ($idSucursal != false && $idEmpleado == false) {
			//corte en UNA sucursal
			$sucursal = Sucursal::find($idSucursal);
			$devoluciones = 
				json_decode(
					Devolucion::json('sucursalFecha',
								$fechaInicio.'_'.$fechaFin.'_'.$idSucursal)
						->getContent());
			$productos = 
				json_decode(
					VentasProductos::json('sucursalFecha',
								$fechaInicio.'_'.$fechaFin.'_'.$idSucursal)
						->getContent());
			$importes = 
			json_decode(
				VentasProductos::json('importeSucursalFecha', 
							$fechaInicio.'_'.$fechaFin.'_'.$idSucursal)
					->getContent());
			$egresos = 
				json_decode(
					Egreso::json('sucursalFecha',
							$fechaInicio.'_'.$fechaFin.'_'.$idSucursal)
						->getContent());
			$empleados = DB::select(
								'call SPD_CONSULTA_EMPLEADOS_SUCURSAL(?)',
								array($idSucursal));
		}else{
			//corte de UN empleado
			$empleado = DB::select('call SPD_CONSULTA_EMPLEADO(?)'
								,array($idEmpleado));
			$devoluciones = 
				json_decode(
					Devolucion::json('empleadoFecha',
								$fechaInicio.'_'.$fechaFin.'_'.$idEmpleado)
						->getContent());
			$productos = 
				json_decode(
					VentasProductos::json('empleadoFecha',
								$fechaInicio.'_'.$fechaFin.'_'.$idEmpleado)
						->getContent());
			$importes = 
			json_decode(
				VentasProductos::json('importeEmpleadoFecha', 
							$fechaInicio.'_'.$fechaFin.'_'.$idEmpleado)
					->getContent());
			$egresos = 
				json_decode(
					Egreso::json('empleadoFecha',
							$fechaInicio.'_'.$fechaFin.'_'.$idEmpleado)
						->getContent());
		}
		/*
		echo '<pre>'.print_r($devoluciones, true).'</pre>';
		echo '<pre>'.print_r($productos, true).'</pre>';
		echo '<pre>'.print_r($importes, true).'</pre>';
		echo '<pre>'.print_r($egresos, true).'</pre>';
		*/
	//iniciamos el PDF
		$pdf = new PDF('P','mm','letter');
		$pdf->setFechas($fechaInicio, $fechaFin);
		$pdf->AliasNbPages();
        $pdf->AddPage();
	//PRODUCTOS
		$tableName='PRODUCTOS VENDIDOS';
		$totalProductos=0;
		$filas=array();
		//muestra los nombres de las sucursales y empleados de TODO
		if (isset($sucursales)) {
	        $ancho=array(20,20,20,20,30,35,10,20,20);
			$tableHeaders=array(
					array($ancho[0],'No. DE VENTA', ''),
					array($ancho[1],'EMPLEADO', ''),
					array($ancho[2],'SUCURSAL', ''),
					array($ancho[3],'CODIGO DE ARTICULO', ''),
					array($ancho[4],'NOMBRE DEL ARTICULO', ''),
					array($ancho[5],'DESCRIPCION', ''),
					array($ancho[6],'CANTIDAD', 'C'),
					array($ancho[7],'IMPORTE', 'C'),
					array($ancho[8],'FECHA', 'C')
				);
	        $posicion=array('', '', '', '', '', '', 'C', 'R', 'R');
	        foreach ($productos as $i => $producto) {
				foreach ($empleados as $j => $emp)
					if ($emp->id_empleado==$producto->id_empleado) 
						$empleado=$emp->nombre.' '.$emp->apellido_paterno;
				foreach ($sucursales as $j => $suc)
					if ($suc->id_sucursal==$producto->id_sucursal) 
						$sucursal=$suc->nombre_sucursal;
				
				$subtotal=$producto->cantidad*$producto->precio_unitario;
				$filas[]=array(
						$producto->id_venta,
						$empleado,
						$sucursal,
						$producto->id_producto,
						$producto->nombre_producto,
						substr($producto->descripcion,0,65),
						$producto->cantidad,
						'$'.$subtotal,
						$producto->created_at
					);
			    $totalProductos+=$subtotal;
			}
		}
		//muestra los nombres de los empleados de UNA sucursal
        elseif (isset($empleados)) {
        	$ancho=array(20,20,20,40,45,10,20,20);
			$tableHeaders=array(
					array($ancho[0],'No. DE VENTA', ''),
					array($ancho[1],'EMPLEADO', ''),
					array($ancho[2],'CODIGO DE ARTICULO', ''),
					array($ancho[3],'NOMBRE DEL ARTICULO', ''),
					array($ancho[4],'DESCRIPCION', ''),
					array($ancho[5],'CANTIDAD', 'C'),
					array($ancho[6],'IMPORTE', 'C'),
					array($ancho[7],'FECHA', 'C')
				);
	        $posicion=array('', '','', '', '', 'C', 'R', 'R');
	        foreach ($productos as $i => $producto) {
				foreach ($empleados as $j => $emp)
					if ($emp->id_empleado==$producto->id_empleado) 
						$empleado=$emp->nombre.' '.$emp->apellido_paterno;
				$subtotal=$producto->cantidad*$producto->precio_unitario;
				$filas[]=array(
						$producto->id_venta,
						$empleado,
						$producto->id_producto,
						$producto->nombre_producto,
						substr($producto->descripcion,0,65),
						$producto->cantidad,
						'$'.$subtotal,
						$producto->created_at
					);
			    $totalProductos+=$subtotal;
			}
        }
        //NO muestra empleados NI sucursales (corte de UN empleado)
        else{
        	$ancho=array(20,20,50,55,10,20,20);
			$tableHeaders=array(
					array(20,'No. DE VENTA', ''),
					array(20,'CODIGO DE ARTICULO', ''),
					array(40,'NOMBRE DEL ARTICULO', ''),
					array(65,'DESCRIPCION', ''),
					array(10,'CANTIDAD', 'C'),
					array(20,'IMPORTE', 'C'),
					array(20,'FECHA', 'C')
				);
	        $posicion=array('', '', '', '', 'C', 'R', 'R');
	        foreach ($productos as $i => $producto) {
				$subtotal=$producto->cantidad*$producto->precio_unitario;
				$filas[]=array(
						$producto->id_venta,
						$producto->id_producto,
						$producto->nombre_producto,
						substr($producto->descripcion,0,65),
						$producto->cantidad,
						'$'.$subtotal,
						$producto->created_at
					);
			    $totalProductos+=$subtotal;
			}
        }

		if (isset($i)) {
			$this->headerTabla($tableName, $tableHeaders, $pdf);
	        $this->bodyTabla($filas, $ancho, $posicion, $pdf);
			$pdf->SetFillColor(230,230,230);
			$this->footerTabla('productos', $totalProductos, $i, $pdf);

		}else{
			$pdf->SetFillColor(230,230,230);
			$pdf->Cell(195,3,'No hay productos registrados',0,0,'C',true);
		}
		$pdf->Ln(5);
		$i=null;
	//EGRESOS
		$tableName='EGRESOS';
		$totalEgresos=0;
		$filas=array();
		//muestra los nombres de las sucursales y empleados de TODO
		if (isset($sucursales)) {
	        $ancho=array(20,20,20,95,20,20);
			$tableHeaders=array(
					array(20,'No. EGRESO', ''),
					array(20,'EMPLEADO', ''),
					array(20,'SUCURSAL', ''),
					array(95,'CONCEPTO', ''),
					array(20,'IMPORTE', 'C'),
					array(20,'FECHA', 'C')
				);
	        $posicion=array('', '', '', '', 'R', 'R');
			foreach ($egresos as $i => $egreso) {
				$empleado = DB::select(
					'call SPD_CONSULTA_EMPLEADO(?)',
						array($egreso->id_empleado));
				$empleado = $empleado[0]->nombre.' '.
							$empleado[0]->apellido_paterno;
				foreach ($sucursales as $j => $suc)
					if ($suc->id_sucursal==$producto->id_sucursal) 
						$sucursal=$suc->nombre_sucursal;
				

				$filas[]=array(
						$egreso->id_egreso,
						$empleado,
						$sucursal,
						$egreso->concepto,
						'$'.$egreso->importe,
						$egreso->created_at
					);
			    $totalEgresos+=$egreso->importe;
			}
		}
		//muestra los nombres de los empleados de UNA sucursal
        elseif (isset($empleados)) {
        	$ancho=array(20,60,75,20,20);
			$tableHeaders=array(
					array($ancho[0],'No. EGRESO', ''),
					array($ancho[1],'EMPLEADO', ''),
					array($ancho[2],'CONCEPTO', ''),
					array($ancho[3],'IMPORTE', 'C'),
					array($ancho[4],'FECHA', 'C')
				);
	        $posicion=array('', '', '', 'R', 'R');
			foreach ($egresos as $i => $egreso) {
				$empleado = DB::select(
					'call SPD_CONSULTA_EMPLEADO(?)',
						array($egreso->id_empleado));
				$empleado = $empleado[0]->nombre.' '.
							$empleado[0]->apellido_paterno;

				$filas[]=array(
						$egreso->id_egreso,
						$empleado,
						$egreso->concepto,
						'$'.$egreso->importe,
						$egreso->created_at
					);
			    $totalEgresos+=$egreso->importe;
			}
        }
        //NO muestra empleados NI sucursales (corte de UN empleado)
        else{
        	$ancho=array(20,60,75,20,20);
			$tableHeaders=array(
					array($ancho[0],'No. EGRESO', ''),
					array($ancho[1],'EMPLEADO', ''),
					array($ancho[2],'CONCEPTO', ''),
					array($ancho[3],'IMPORTE', 'C'),
					array($ancho[4],'FECHA', 'C')
				);
	        $posicion=array('', '', '', 'R', 'R');
			foreach ($egresos as $i => $egreso) {
				$empleado = DB::select(
					'call SPD_CONSULTA_EMPLEADO(?)',
						array($egreso->id_empleado));
				$empleado = $empleado[0]->nombre.' '.
							$empleado[0]->apellido_paterno;

				$filas[]=array(
						$egreso->id_egreso,
						$empleado,
						$egreso->concepto,
						'$'.$egreso->importe,
						$egreso->created_at
					);
			    $totalEgresos+=$egreso->importe;
			}
        }

		if (isset($i)) {
			$this->headerTabla($tableName, $tableHeaders, $pdf);
	        $this->bodyTabla($filas, $ancho, $posicion, $pdf);
			$pdf->SetFillColor(230,230,230);
			$this->footerTabla('egresos', $totalEgresos, $i, $pdf);
		}else{
			$pdf->SetFillColor(230,230,230);
			$pdf->Cell(195,3,'No hay egresos registrados',0,0,'C',true);
		}
		$pdf->Ln(5); 
	//DEVOLUCIONES
		$tableName='DEVOLUCIONES';
		$totalDevoluciones=0;
		$filas=array();
		//muestra los nombres de las sucursales y empleados de TODO
		if (isset($sucursales)) {
	        $ancho=array(20,20,20,20,20,55,20,20);
			$tableHeaders=array(
					array($ancho[0],'No. DE DEVOLUCION', ''),
					array($ancho[1],'EMPLEADO', ''),
					array($ancho[2],'SUCURSAL', ''),
					array($ancho[3],'ID PRODUCTO DEVUELTO', ''),
					array($ancho[4],'ID PRODUCTO CAMBIO', ''),
					array($ancho[5],'CONCEPTO', 'C'),
					array($ancho[6],'DIFERENCIA', 'C'),
					array($ancho[7],'FECHA', 'C')
				);
		   	$posicion=array('', '', '', '', '', '', 'R', 'R');
			foreach ($devoluciones as $i => $devolucion) {
				foreach ($empleados as $j => $emp)
					if ($emp->id_empleado==$devolucion->id_empleado) 
						$empleado=$emp->nombre.' '.$emp->apellido_paterno;
				foreach ($sucursales as $j => $suc)
					if ($suc->id_sucursal==$devolucion->id_sucursal) 
						$sucursal=$suc->nombre_sucursal;
				
				$filas[]=array(
						$devolucion->id_devolucion,
						$empleado,
						$sucursal,
						$devolucion->id_producto_devuelto,
						$devolucion->id_producto_cambio,
						$devolucion->concepto,
						'$'.$devolucion->diferencia,
						$devolucion->created_at
					);
			    $totalDevoluciones += $devolucion->diferencia;
			}
		}
		//muestra los nombres de los empleados de UNA sucursal
        elseif (isset($empleados)) {
        	$ancho=array(20,20,20,20,75,20,20);
			$tableHeaders=array(
					array($ancho[0],'No. DE DEVOLUCION', ''),
					array($ancho[1],'EMPLEADO', ''),
					array($ancho[2],'ID PRODUCTO DEVUELTO', ''),
					array($ancho[3],'ID PRODUCTO CAMBIO', ''),
					array($ancho[4],'CONCEPTO', 'C'),
					array($ancho[5],'DIFERENCIA', 'C'),
					array($ancho[6],'FECHA', 'C')
				);
		   	$posicion=array('', '', '', '', '', 'R', 'R');
			foreach ($devoluciones as $i => $devolucion) {
				foreach ($empleados as $j => $emp)
					if ($emp->id_empleado==$devolucion->id_empleado) 
						$empleado=$emp->nombre.' '.$emp->apellido_paterno;
				
				$filas[]=array(
						$devolucion->id_devolucion,
						$empleado,
						$devolucion->id_producto_devuelto,
						$devolucion->id_producto_cambio,
						$devolucion->concepto,
						'$'.$devolucion->diferencia,
						$devolucion->created_at
					);
			    $totalDevoluciones += $devolucion->diferencia;
			}
        }
        //NO muestra empleados NI sucursales (corte de UN empleado)
        else{
        	$ancho=array(20,20,20,95,20,20);
			$tableHeaders=array(
					array($ancho[0],'No. DE DEVOLUCION', ''),
					array($ancho[1],'ID PRODUCTO DEVUELTO', ''),
					array($ancho[2],'ID PRODUCTO CAMBIO', ''),
					array($ancho[3],'CONCEPTO', 'C'),
					array($ancho[4],'DIFERENCIA', 'C'),
					array($ancho[5],'FECHA', 'C')
				);
		   	$posicion=array('', '', '', '', 'R', 'R');
			foreach ($devoluciones as $i => $devolucion) {
				$filas[]=array(
						$devolucion->id_devolucion,
						$devolucion->id_producto_devuelto,
						$devolucion->id_producto_cambio,
						$devolucion->concepto,
						'$'.$devolucion->diferencia,
						$devolucion->created_at
					);
			    $totalDevoluciones += $devolucion->diferencia;
			}
        }

		if (isset($i)) {
			$this->headerTabla($tableName, $tableHeaders, $pdf);
			$this->bodyTabla($filas, $ancho, $posicion, $pdf);
			$pdf->SetFillColor(230,230,230);
			$this->footerTabla('devoluciones', 
								$totalDevoluciones, $i, $pdf);
		}else{
			$pdf->SetFillColor(230,230,230);
			$pdf->Cell(195,3,
				'No hay devoluciones registradas',0,0,'C',true);
		}
		$pdf->Ln(5);
		$i=null;
	//TOTAL sumando devoluciones y restando egresos
		$totalP=0;
		foreach ($importes as $i => $importe) {
			$signo=' ';
			if ($i==0){
				$signo='+';
				$totalP+=$importe->importe;
			}
			$pdf->Ln(2);
			$pdf->Cell(20,3,$importe->tipo_de_pago.':',0,0,'',true);
			$pdf->Cell(5,3,$signo,0,0,'R',true);
			$pdf->Cell(15,3,$importe->importe,0,0,'R',true);
			$pdf->Cell(155,3,'',0,0,'',true);
		}
		$pdf->Ln(2);
		$pdf->Cell(20,3,'Total : ',0,0,'',true);
		$pdf->Cell(2,3,'',0,0,'',true);
		$pdf->Cell(18,3,number_format($totalP,2),0,0,'R',true);
		$pdf->Cell(155,3,'',0,0,'',true);
		
		$pdf->Ln(5);
		$totalFinal=$totalProductos+$totalDevoluciones-$totalEgresos;
		$pdf->Cell(20,3,'Total productos: ',0,0,'',true);
		$pdf->Cell(2,3,'+',0,0,'',true);
		$pdf->Cell(18,3,number_format($totalP,2),0,0,'R',true);
		$pdf->Cell(155,3,'',0,0,'',true);
		$pdf->Ln(3);
		$pdf->Cell(20,3,'Total devoluciones: ',0,0,'',true);
		$pdf->Cell(2,3,'+',0,0,'',true);
		$pdf->Cell(18,3,number_format($totalDevoluciones,2),0,0,'R',true);
		$pdf->Cell(155,3,'',0,0,'',true);
		$pdf->Ln(3);
		$pdf->Cell(20,3,'Total egresos: ',0,0,'',true);
		$pdf->Cell(2,3,'-',0,0,'',true);
		$pdf->Cell(18,3,number_format($totalEgresos,2),0,0,'R',true);
		$pdf->Cell(155,3,'',0,0,'',true);
		$pdf->Ln(3);
		$pdf->Cell(20,3,'Total final: ',0,0,'',true);
		$pdf->Cell(20,3,number_format($totalFinal,2),0,0,'R',true);
		$pdf->Cell(155,3,'',0,0,'',true);
	//imprimimos el PDF
        $pdf->Output();
        exit;

		//return PDF::load($html.$css, 'letter', 'portrait')->show();

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

//JSON corte de caja
	public function json($accion, $id){

		switch ($accion) {
			case 'todos':
				$ventas = Venta::all();
				return  Response::json($ventas->toArray());
				break;
			
			case 'corte':
				$ventas = Venta::where('id_empleado',$id)
						->where('habilitado',false)->get();
				return  Response::json($ventas->toArray());
				break;
			
			case 'venta':
				$venta = Venta::find($id);
				return  Response::json($venta);
				break;
			
			case 'detallesVenta':
				$detallesVenta = 
					VentasProductos::where('id_venta',$id)->get();
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
				$ventas = 
					Venta::whereBetween('created_at', $fecha)->get();
				return  Response::json($ventas);
				break;
			
			default:
				return  Response::json(['error']);
				break;
		}
	}
//Funciones par hacer las tablas
	public function bodyTabla($filas, $ancho, $posicion, $pdf){
		foreach ($filas as $i => $fila) {
			if(($i%2)==0){
		        $pdf->SetFillColor(176,237,201);
		    }else{
		        $pdf->SetFillColor(224,237,176);
		    }
		    foreach ($fila as $j => $columna)
		    	$pdf->Cell($ancho[$j],3,$fila[$j],0,0,$posicion[$j],true);
		    $pdf->Ln();
		}
	}

	public function footerTabla($tabla, $ntotal, $i, $pdf){
		$pdf->Cell(178,3,'_______________________________',0,0,'R');
		$pdf->Ln();
		$pdf->Cell(20,3,ucfirst($tabla).': '.($i+1),0,0,'',true);
		$pdf->Cell(135,3,'Total '.$tabla.':',0,0,'R',true);
		$pdf->Cell(20,3,'$'.
			number_format($ntotal,2),0,0,'R',true);
		$pdf->Cell(20,3,'',0,0,'R',true);
	}

	public function headerTabla($tableName, $tableHeaders, $pdf){
		$pdf->SetFillColor(255,255,255);
		$pdf->Cell(20,3,$tableName,1,0,'L',true);
		$pdf->Ln();
		$pdf->SetFillColor(93,137,219);
		foreach ($tableHeaders as $i => $th) {
			$pdf->Cell($th[0],3,$th[1],1,0,$th[2],true);	
		}
		$pdf->Ln();
	}

}
