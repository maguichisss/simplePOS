<?php

class SucursalesProductos extends Eloquent{
	
	//protected $table = 'productos';
	protected $table = 'sucursales_productos';
	protected $primaryKey = 'id_sucursales_productos';

	public static function soloHabilitados()
    {
        return SucursalesProductos::where('habilitado', '=', true)->get();
    }

}
