<?php

class Transferencia extends Eloquent{
	
	//protected $table = 'productos';
	protected $table = 'transferencias';
	protected $primaryKey = 'id_transferencia';

	public static function soloHabilitados()
    {
        return Transferencia::where('habilitado', '=', true)->get();
    }

}
