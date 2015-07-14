<?php

class TipoDeEmpleado extends Eloquent{
	
	//protected $table = 'productos';
	protected $table = 'tipos_de_empleados';
	protected $primaryKey = 'id_tipo_de_empleado';

	public static function soloHabilitados()
    {
        return TipoDeEmpleado::where('habilitado', '=', true)->get();
    }

}
