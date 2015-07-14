<?php

class TipoDeCliente extends Eloquent{
	
	//protected $table = 'productos';
	protected $table = 'tipos_de_clientes';
	protected $primaryKey = 'id_tipo_de_cliente';

	public static function soloHabilitados()
    {
        return TipoDeCliente::where('habilitado', '=', true)->get();
    }

}
