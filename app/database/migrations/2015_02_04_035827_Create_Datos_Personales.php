<?php

use Illuminate\Database\Schema\Blueprint;
use Illuminate\Database\Migrations\Migration;

class CreateDatosPersonales extends Migration {

	/**
	 * Run the migrations.
	 *
	 * @return void
	 */
	public function up()
	{
		Schema::create('datos_personales', function(Blueprint $table)
		{
			$table->increments('id_datos_personales');
			$table->string('nombre', 50);
			$table->string('apellido_paterno', 30);
			$table->string('apellido_materno', 30)->nullable();
			$table->date('fecha_nacimiento');
			$table->boolean('genero');
			$table->string('calle', 50)->nullable()->default(null);
			$table->string('colonia', 50)->nullable()->default(null);
			$table->string('delegacion', 50)->nullable()->default(null);
			$table->string('estado', 50)->nullable()->default(null);
			$table->string('cp', 5)->nullable()->default(null);
			$table->string('telefono', 10)->nullable()->default(null);
			$table->string('email', 45)->nullable()->default(null);
			$table->string('rfc', 13)->nullable()->default(null);
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
		Schema::drop('datos_personales');
	}

}
