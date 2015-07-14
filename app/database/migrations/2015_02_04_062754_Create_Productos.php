<?php

use Illuminate\Database\Schema\Blueprint;
use Illuminate\Database\Migrations\Migration;

class CreateProductos extends Migration {

	/**
	 * Run the migrations.
	 *
	 * @return void
	 */
	public function up()
	{
		Schema::create('productos', function(Blueprint $table)
		{
			$table->bigIncrements('id_producto');
			$table->integer('id_categoria_de_producto')->unsigned();
			$table->foreign('id_categoria_de_producto')
					->references('id_categoria_de_producto')
						->on('categorias_de_productos');
			$table->string('nombre_producto',100);
			$table->string('descripcion',150)->nullable();
			$table->decimal('precio_compra', 12,2);
			$table->decimal('precio_cliente_frecuente', 12,2);
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
		Schema::drop('productos');
	}

}
