<?php

use Illuminate\Database\Schema\Blueprint;
use Illuminate\Database\Migrations\Migration;

class CreateComprasProductos extends Migration {

	/**
	 * Run the migrations.
	 *
	 * @return void
	 */
	public function up()
	{
		Schema::create('compras_productos', function(Blueprint $table)
		{
			$table->increments('id_compras_productos');
			$table->integer('id_compra')->unsigned();
			$table->foreign('id_compra')
					->references('id_compra')
						->on('compras');
			$table->bigInteger('id_producto')->unsigned();
			$table->foreign('id_producto')
					->references('id_producto')
						->on('productos');
			$table->smallInteger('cantidad');
			$table->date('fecha_caducidad');
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
		Schema::drop('compras_productos');
	}

}
