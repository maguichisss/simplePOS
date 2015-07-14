<?php

class CategoriaDeProducto extends Eloquent{
	
	//protected $table = 'productos';
	protected $table = 'categorias_de_productos';
	protected $primaryKey = 'id_categoria_de_producto';

	public static function habilitado()
    {
        return CategoriaDeProducto::where('habilitado', '=', true)->get();
    }
    
}

	