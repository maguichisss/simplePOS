<?php

class EgresoController extends \BaseController {

	/**
	 * Display a listing of the resource.
	 *
	 * @return Response
	 */
	public function index()
	{
		$egre = Egreso::where('id_sucursal', Session::get('idSucursal'))
				->orderBy('created_at', 'desc')->take(20)->get();

		$egresos=array();
		foreach ($egre as $i => $egreso) {
			$empleado = DB::select(
				'call SPD_CONSULTA_EMPLEADO(?)',
				array($egreso->id_empleado));
		/*	el procedimiento devuelve: 
			id_empleado, nombre, apellido_paterno, id_sucursal, 
			nombre_sucursal, username, tipo_de_empleado, habilitado
		*/
			$egresos[]=array(
				'empleado'=>$empleado[0]->nombre.' '.
							$empleado[0]->apellido_paterno.' | '.
							$empleado[0]->username.' ',
				'importe'=>$egreso->importe,
				'concepto'=>$egreso->concepto,
				'fecha'=>$egreso->created_at);
		}


		return View::make('egreso.index')
			->with('egresos', $egresos);
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
		$producto = new Egreso;
		$producto->id_empleado = Session::get('idEmpleado');
		$producto->id_sucursal = Session::get('idSucursal');
		$producto->concepto = Input::get('concepto');
		$producto->importe = Input::get('importe');
		
		if($producto->save()){
			Session::flash('message','Egreso registrado correctamente');
			Session::flash('class', 'success');
		
		}else{
			Session::flash('message', 'Ha ocurrido un error al registrar
				este egreso!');
			Session::flash('class', 'danger');
		}
		return Redirect::to('egresos');
//		return '<pre>'.print_r($producto, true);
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
