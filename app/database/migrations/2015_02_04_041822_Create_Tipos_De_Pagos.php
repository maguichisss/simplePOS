<?php

use Illuminate\Database\Schema\Blueprint;
use Illuminate\Database\Migrations\Migration;

class CreateTiposDePagos extends Migration {

	/**
	 * Run the migrations.
	 *
	 * @return void
	 */
	public function up()
	{
		Schema::create('tipos_de_pagos', function(Blueprint $table)
		{
			$table->increments('id_tipo_de_pago');
			$table->string('tipo_de_pago', 50);
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
		Schema::drop('tipos_de_pagos');
	}

}
