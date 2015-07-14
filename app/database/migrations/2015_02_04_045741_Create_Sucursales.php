<?php

use Illuminate\Database\Schema\Blueprint;
use Illuminate\Database\Migrations\Migration;

class CreateSucursales extends Migration {

	/**
	 * Run the migrations.
	 *
	 * @return void
	 */
	public function up()
	{
		Schema::create('sucursales', function(Blueprint $table)
		{
			$table->increments('id_sucursal');
			$table->string('nombre_sucursal', 50);
			$table->string('direccion', 100);
			$table->string('telefono', 10);
			$table->string('email', 45);
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
		Schema::drop('sucursales');
	}

}
