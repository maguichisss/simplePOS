<?php

use Illuminate\Database\Schema\Blueprint;
use Illuminate\Database\Migrations\Migration;

class CreateComprasTipoDePago extends Migration {

	/**
	 * Run the migrations.
	 *
	 * @return void
	 */
	public function up()
	{
		Schema::create('compras_tipo_de_pago', function(Blueprint $table)
		{
			$table->increments('id_compras_tipo_de_pago');
			$table->integer('id_compra')->unsigned();
			$table->foreign('id_compra')
					->references('id_compra')
						->on('compras');
			$table->integer('id_tipo_de_pago')->unsigned();
			$table->foreign('id_tipo_de_pago')
					->references('id_tipo_de_pago')
						->on('tipos_de_pagos');
			$table->decimal('importe_pagado', 12,2);
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
		Schema::drop('compras_tipo_de_pago');
	}

}
