<?php

class UsuariosEmpleados extends Eloquent{
	
	//protected $table = 'productos';
	protected $table = 'usuarios_empleados';
	protected $primaryKey = 'id_usuarios_empleados';

	public static function soloHabilitados()
    {
        return UsuariosEmpleados::where('habilitado', '=', true)->get();
    }

}
