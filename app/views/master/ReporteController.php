<?php

class ReporteController extends BaseController {

	/**
	 * Display a listing of the resource.
	 *
	 * @return Response
	 */
	public function index()
	{
		//return "reportes";

		$tipo=Session::get('tipo');
		$idSucursal=Session::get('idSucursal');
		$idEmpleado=Session::get('idEmpleado');
		if($tipo == 'GERENTE DE SUCURSAL'){
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
		}elseif($tipo == 'GERENTE DE GENERAL' || 
				$tipo == 'ADMINISTRADOR'){
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
			array_unshift($sucursales, 'Todos...');
		}
		/*
		return '<pre>'.print_r($x,true).print_r($sucursales,true)
					.print_r($y,true).print_r($empleados,true);
		*/
		return View::make('reportes.reportes')
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

	}


	/**
	 * Store a newly created resource in storage.
	 *
	 * @return Response
	 */
	public function store()
	{
		$accion = Input::get('accion');
		$idSucursal = Input::get('idSucursal');
		$idEmpleado = Input::get('idEmpleado');
		$fechaInicio = Input::get('fechaInicio');
		$fechaFin = Input::get('fechaFin');

		switch ($accion) {
			case 'ventas':
				$this->reporteVentas($idSucursal,$idEmpleado,
									$fechaInicio,$fechaFin);
				break;
			
			case 'compras':
				$this->reporteCompras($idSucursal,$idEmpleado,
									$fechaInicio,$fechaFin);
				break;
			
			default:
				return 'error';
				break;
		}

		return '<pre>'.print_r(Input::all(),true).'</pre>';

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

	public function reporteVentas($idSucursal,$idEmpleado,
									$fechaInicio,$fechaFin){
		
	//obtenemos VENTAS, DEVOLUCIONES, PRODUCTOS, EGRESOS
		if ($idSucursal == false && $idEmpleado == false) {
			//corte de TODO
			$ventas = 
				json_decode(
					Venta::json('fecha',$fechaInicio.'_'.$fechaFin)
						->getContent());
			$empleados = DB::select('call SPD_CONSULTAR_EMPLEADOS');
			$sucursales = Sucursal::all();

		}elseif ($idSucursal != false && $idEmpleado == false) {
			//corte en UNA sucursal
			$sucursal = Sucursal::find($idSucursal);
			$ventas = 
				json_decode(
					Venta::json('sucursalFecha',
								$fechaInicio.'_'.$fechaFin.'_'.$idSucursal)
						->getContent());
			$empleados = DB::select(
								'call SPD_CONSULTA_EMPLEADOS_SUCURSAL(?)',
								array($idSucursal));
		}else{
			//corte de UN empleado
			$empleado = DB::select('call SPD_CONSULTA_EMPLEADO(?)'
								,array($idEmpleado));
			$ventas = 
				json_decode(
					Venta::json('empleadoFecha',
								$fechaInicio.'_'.$fechaFin.'_'.$idEmpleado)
						->getContent());
		}
		//echo '<pre>'.print_r($productos, true).'</pre>';
		$css = '<head>'.HTML::style('css/main.css').'</head>';
	//iniciamos el PDF
		$pdf = new PDF();
		$pdf->setFechas($fechaInicio, $fechaFin);
		$pdf->AliasNbPages();
        $pdf->AddPage();
	//VENTAS
		$tableName='VENTAS';
		$totalVentas=0;
		$filas=array();
		//muestra los nombres de las sucursales y empleados de TODO
		if (isset($sucursales)) {
			$ancho=array(20,20,20,95,20,20);
			$tableHeaders=array(
					array($ancho[0],'No. DE VENTA', ''),
					array($ancho[1],'EMPLEADO', ''),
					array($ancho[2],'SUCURSAL', ''),
					array($ancho[3],'DETALLES', ''),
					array($ancho[4],'IMPORTE', 'C'),
					array($ancho[5],'FECHA', 'C')
				);
			$posicion=array('', '', '', '', 'R', 'R');
        	foreach ($ventas as $i => $venta) {
				foreach ($empleados as $j => $emp)
					if ($emp->id_empleado==$venta->id_empleado) 
						$empleado=$emp->nombre.' '.$emp->apellido_paterno;
				foreach ($sucursales as $j => $suc)
					if ($suc->id_sucursal==$venta->id_sucursal) 
						$sucursal=$suc->nombre_sucursal;
				
				$filas[]=array(
						$venta->id_venta,
						$empleado,
						$sucursal,
						$venta->detalles,
						'$'.$venta->total,
						$venta->created_at
					);
			    $totalVentas += $venta->total;
			}
        }
        //muestra los nombres de los empleados de UNA sucursal
        elseif (isset($empleados)) {
        	$ancho=array(20,20,115,20,20);
			$tableHeaders=array(
					array($ancho[0],'No. DE VENTA', ''),
					array($ancho[1],'EMPLEADO', ''),
					array($ancho[2],'DETALLES', ''),
					array($ancho[3],'IMPORTE', 'C'),
					array($ancho[4],'FECHA', 'C')
				);
			$posicion=array('', '', '', 'R', 'R');
        	foreach ($ventas as $i => $venta) {
				foreach ($empleados as $j => $emp)
					if ($emp->id_empleado==$venta->id_empleado) 
						$empleado=$emp->nombre.' '.$emp->apellido_paterno;
				
				$filas[]=array(
						$venta->id_venta,
						$empleado,
						$venta->detalles,
						'$'.$venta->total,
						$venta->created_at
					);
			    $totalVentas += $venta->total;
			}   	
        }
        //NO muestra empleados NI sucursales (corte de UN empleado)
        else{
        	$ancho=array(20,135,20,20);
			$tableHeaders=array(
					array($ancho[0],'No. DE VENTA', ''),
					array($ancho[1],'DETALLES', ''),
					array($ancho[2],'IMPORTE', 'C'),
					array($ancho[3],'FECHA', 'C')
				);
			$posicion=array('', '', 'R', 'R');
        	foreach ($ventas as $i => $venta) {
				$filas[]=array(
						$venta->id_venta,
						$venta->detalles,
						'$'.$venta->total,
						$venta->created_at
					);
			    $totalVentas += $venta->total;
			}   
        }
		
		if(isset($i)){
	        $this->headerTabla($tableName, $tableHeaders, $pdf);
			$this->bodyTabla($filas, $ancho, $posicion, $pdf);
			$pdf->SetFillColor(230,230,230);
			$this->footerTabla('ventas', $totalVentas, $i, $pdf);
		}else{
			$pdf->SetFillColor(230,230,230);
			$pdf->Cell(195,3,'No hay ventas registradas',0,0,'C',true);
		}
		$pdf->Ln(5);
		$i=null;
	//imprimimos el PDF
        $pdf->Output();
        exit;
	}

	public function reporteCompras($idSucursal,$idEmpleado,
									$fechaInicio,$fechaFin){
		
	//obtenemos COMPRAS
		if ($idSucursal == false && $idEmpleado == false) {
			//corte de TODO
			$compras = 
				json_decode(
					ComprasProductos::json('fecha',$fechaInicio.'_'.$fechaFin)
						->getContent());
			$empleados = DB::select('call SPD_CONSULTAR_EMPLEADOS');
			$sucursales = Sucursal::all();

		}elseif ($idSucursal != false && $idEmpleado == false) {
			//corte en UNA sucursal
			$sucursal = Sucursal::find($idSucursal);
			$compras = 
				json_decode(
					ComprasProductos::json('sucursalFecha',
								$fechaInicio.'_'.$fechaFin.'_'.$idSucursal)
						->getContent());
			$empleados = DB::select(
								'call SPD_CONSULTA_EMPLEADOS_SUCURSAL(?)',
								array($idSucursal));
		}else{
			//corte de UN empleado
			$empleado = DB::select('call SPD_CONSULTA_EMPLEADO(?)'
								,array($idEmpleado));
			$compras = 
				json_decode(
					ComprasProductos::json('empleadoFecha',
								$fechaInicio.'_'.$fechaFin.'_'.$idEmpleado)
						->getContent());
		}
		//echo '<pre>'.print_r($productos, true).'</pre>';
	//iniciamos el PDF
		$pdf = new PDF();
		$pdf->setFechas($fechaInicio, $fechaFin);
		$pdf->AliasNbPages();
        $pdf->AddPage();
	//COMPRAS
		$tableName='COMPRAS';
		$totalCompras=0;
		$filas=array();
		//muestra los nombres de las sucursales y empleados de TODO
		if (isset($sucursales)) {
			$ancho=array(20,20,20,95,20,20);
			$tableHeaders=array(
					array($ancho[0],'No. DE COMPRA', ''),
					array($ancho[1],'EMPLEADO', ''),
					array($ancho[2],'SUCURSAL', ''),
					array($ancho[3],'', ''),
					array($ancho[4],'IMPORTE', 'C'),
					array($ancho[5],'FECHA', 'C')
				);
			$posicion=array('', '', '', '', 'R', 'R');
        	foreach ($compras as $i => $compra) {
				foreach ($empleados as $j => $emp)
					if ($emp->id_empleado==$compra->id_empleado) 
						$empleado=$emp->nombre.' '.$emp->apellido_paterno;
				foreach ($sucursales as $j => $suc)
					if ($suc->id_sucursal==$compra->id_sucursal) 
						$sucursal=$suc->nombre_sucursal;
				
				$filas[]=array(
						$compra->id_compra,
						$empleado,
						$sucursal,
						'',
						'$'.$compra->total,
						$compra->created_at
					);
			    $totalCompras += $compra->total;
			}
        }
        //muestra los nombres de los empleados de UNA sucursal
        elseif (isset($empleados)) {
        	$ancho=array(20,20,115,20,20);
			$tableHeaders=array(
					array($ancho[0],'No. DE COMPRA', ''),
					array($ancho[1],'EMPLEADO', ''),
					array($ancho[2],'', ''),
					array($ancho[3],'IMPORTE', 'C'),
					array($ancho[4],'FECHA', 'C')
				);
			$posicion=array('', '', '', 'R', 'R');
        	foreach ($compras as $i => $compra) {
				foreach ($empleados as $j => $emp)
					if ($emp->id_empleado==$compra->id_empleado) 
						$empleado=$emp->nombre.' '.$emp->apellido_paterno;
				
				$filas[]=array(
						$compra->id_compra,
						$empleado,
						'',
						'$'.$compra->total,
						$compra->created_at
					);
			    $totalCompras += $compra->total;
			}   	
        }
        //NO muestra empleados NI sucursales (corte de UN empleado)
        else{
        	$ancho=array(20,135,20,20);
			$tableHeaders=array(
					array($ancho[0],'No. DE COMPRA', ''),
					array($ancho[1],'', ''),
					array($ancho[2],'IMPORTE', 'C'),
					array($ancho[3],'FECHA', 'C')
				);
			$posicion=array('', '', 'R', 'R');
        	foreach ($compras as $i => $compra) {
				$filas[]=array(
						$compra->id_compra,
						'',
						'$'.$compra->total,
						$compra->created_at
					);
			    $totalCompras += $compra->total;
			}   
        }
		
		if(isset($i)){
	        $this->headerTabla($tableName, $tableHeaders, $pdf);
			$this->bodyTabla($filas, $ancho, $posicion, $pdf);
			$pdf->SetFillColor(230,230,230);
			$this->footerTabla('compras', $totalCompras, $i, $pdf);
		}else{
			$pdf->SetFillColor(230,230,230);
			$pdf->Cell(195,3,'No hay compras registradas',0,0,'C',true);
		}
		$pdf->Ln(5);
		$i=null;
	//imprimimos el PDF
        $pdf->Output();
        exit;
	}

//metodos para impimir las tablas
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
