<?php

class Empleado extends Eloquent{
	
	//protected $table = 'productos';
	protected $table = 'empleados';
	protected $primaryKey = 'id_empleado';

	public static function soloHabilitados()
    {
        return Empleado::where('habilitado', '=', true)->get();
    }

}
