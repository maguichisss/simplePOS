<?php

class TipoDePago extends Eloquent{
	
	//protected $table = 'productos';
	protected $table = 'tipos_de_pagos';
	protected $primaryKey = 'id_tipo_de_pago';

	public static function habilitado()
    {
        return TipoDePago::where('habilitado', '=', true)->get();
    }

}

	