<?php

use Illuminate\Database\Schema\Blueprint;
use Illuminate\Database\Migrations\Migration;

class CreateReglasDelNegocio extends Migration {

	/**
	 * Run the migrations.
	 *
	 * @return void
	 */
	public function up()
	{
		Schema::create('reglas_del_negocio', function(Blueprint $table)
		{
			$table->increments('id');
			$table->string('regla', 100);
			$table->decimal('minimo', 12,2);
			$table->decimal('maximo', 12,2);
			$table->decimal('descuento', 4,2);
			$table->text('descripcion');
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
		Schema::drop('reglas_del_negocio');
	}

}
