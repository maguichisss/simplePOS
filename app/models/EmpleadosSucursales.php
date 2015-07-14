<?php

class EmpleadosSucursales extends Eloquent{
	
	//protected $table = 'productos';
	protected $table = 'empleados_sucursales';
	protected $primaryKey = 'id_empleados_sucursales';

	public static function soloHabilitados()
    {
        return EmpleadosSucursales::where('habilitado', '=', true)->get();
    }

}
