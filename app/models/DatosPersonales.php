<?php

class DatosPersonales extends Eloquent{
	
	//protected $table = 'productos';
	protected $table = 'datos_personales';
	protected $primaryKey = 'id_datos_personales';

	public static function soloHabilitados()
    {
        return DatosPersonales::where('habilitado', '=', true)->get();
    }

}
