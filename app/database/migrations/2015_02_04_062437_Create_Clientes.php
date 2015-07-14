<?php

use Illuminate\Database\Schema\Blueprint;
use Illuminate\Database\Migrations\Migration;

class CreateClientes extends Migration {

	/**
	 * Run the migrations.
	 *
	 * @return void
	 */
	public function up()
	{
		Schema::create('clientes', function(Blueprint $table)
		{
			$table->increments('id_cliente');
			$table->integer('id_datos_personales')->unsigned();
			$table->foreign('id_datos_personales')
					->references('id_datos_personales')
						->on('datos_personales');
			$table->integer('id_tipo_de_cliente')->unsigned();
			$table->foreign('id_tipo_de_cliente')
					->references('id_tipo_de_cliente')
						->on('tipos_de_clientes');
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
		Schema::drop('clientes');
	}

}
