<?php

class Cliente extends Eloquent{
	
	//protected $table = 'productos';
	protected $table = 'clientes';
	protected $primaryKey = 'id_cliente';

	public static function soloHabilitados()
    {
        return Cliente::where('habilitado', '=', true)->get();
    }

}
