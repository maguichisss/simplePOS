<?php

class Sucursal extends Eloquent{
	
	//protected $table = 'productos';
	protected $table = 'sucursales';
	protected $primaryKey = 'id_sucursal';

	public static function soloHabilitados()
    {
        return Sucursal::where('habilitado', '=', true)->get();
    }

}
