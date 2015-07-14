<?php

use Illuminate\Database\Schema\Blueprint;
use Illuminate\Database\Migrations\Migration;

class CreateVentasProductos extends Migration {

	/**
	 * Run the migrations.
	 *
	 * @return void
	 */
	public function up()
	{
		Schema::create('ventas_productos', function(Blueprint $table)
		{
			$table->increments('id_ventas_productos');
			$table->integer('id_venta')->unsigned();
			$table->foreign('id_venta')
					->references('id_venta')
						->on('ventas');
			$table->bigInteger('id_producto')->unsigned();
			$table->foreign('id_producto')
					->references('id_producto')
						->on('productos');
			$table->smallInteger('cantidad');
			$table->decimal('precio_unitario', 12,2);
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
		Schema::drop('ventas_productos');
	}

}
