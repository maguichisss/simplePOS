<?php

class ReglasNegocio extends Eloquent{
	
	//protected $table = 'productos';
	protected $table = 'reglas_del_negocio';
	protected $primaryKey = 'id';

	public static function soloHabilitados()
    {
        return ReglasNegocio::where('habilitado', '=', true)->get();
    }

}
