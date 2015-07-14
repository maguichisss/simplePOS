<?php

use Illuminate\Database\Schema\Blueprint;
use Illuminate\Database\Migrations\Migration;

class CreateVentasTipoDePago extends Migration {

	/**
	 * Run the migrations.
	 *
	 * @return void
	 */
	public function up()
	{
		Schema::create('ventas_tipo_de_pago', function(Blueprint $table)
		{
			$table->increments('id_ventas_tipo_de_pago');
			$table->integer('id_venta')->unsigned();
			$table->foreign('id_venta')
					->references('id_venta')
						->on('ventas');
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
		Schema::drop('ventas_tipo_de_pago');
	}

}
