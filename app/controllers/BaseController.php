<?php

class BaseController extends Controller {

	public function __construct()
    {
    	//llama al filtro auth en filters.php
        $this->beforeFilter('auth');
    }
    /**
	 * Setup the layout used by the controller.
	 *
	 * @return void
	 */
	protected function setupLayout()
	{
		if ( ! is_null($this->layout))
		{
			$this->layout = View::make($this->layout);
		}
	}
//salteVendedor
	public function salteVendedor(){
		if (Session::get('tipo') != 'ADMINISTRADOR' && 
	        Session::get('tipo') != 'GERENTE GENERAL' && 
	        Session::get('tipo') != 'GERENTE DE SUCURSAL') {
			Session::flash('message', 
					'No tienes permiso de estar aqui!');
			Session::flash('class', 'danger');
			return true;
		}
		return false;
	}
//salteGerenteSucursal
	public function salteGerenteSucursal(){
		if (Session::get('tipo') != 'ADMINISTRADOR' && 
	        Session::get('tipo') != 'GERENTE GENERAL') {
			Session::flash('message', 
					'No tienes permiso de estar aqui!');
			Session::flash('class', 'danger');
			return true;
		}
		return false;
	}



}
