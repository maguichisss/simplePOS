<?php

use Illuminate\Database\Schema\Blueprint;
use Illuminate\Database\Migrations\Migration;

class CreateSucursalesProductos extends Migration {

	/**
	 * Run the migrations.
	 *
	 * @return void
	 */
	public function up()
	{
		Schema::create('sucursales_productos', function(Blueprint $table)
		{
			$table->bigIncrements('id_sucursales_productos');
			$table->integer('id_sucursal')->unsigned();
			$table->foreign('id_sucursal')
					->references('id_sucursal')
						->on('sucursales');
			$table->bigInteger('id_producto')->unsigned();
			$table->foreign('id_producto')
					->references('id_producto')
						->on('productos');
			$table->smallInteger('cantidad');
			$table->tinyInteger('stock');
			$table->boolean('habilitado')->default(true);
			$table->timestamps();
		});
	}

	/**
	 * Reverse the migrations.
	 *
	 * @return void
	 */
	public function down()
	{
		Schema::drop('sucursales_productos');
	}

}
