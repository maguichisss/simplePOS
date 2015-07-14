<?php

class Proveedor extends Eloquent{
	
	//protected $table = 'productos';
	protected $table = 'proveedores';
	protected $primaryKey = 'id_proveedor';

	public static function soloHabilitados()
    {
        return Proveedor::where('habilitado', '=', true)->get();
    }

}
