<?php

use Illuminate\Database\Schema\Blueprint;
use Illuminate\Database\Migrations\Migration;

class CreateDevoluciones extends Migration {

	/**
	 * Run the migrations.
	 *
	 * @return void
	 */
	public function up()
	{
		Schema::create('devoluciones', function(Blueprint $table)
		{
			$table->increments('id_devolucion');
			$table->integer('id_empleado')->unsigned();
			$table->foreign('id_empleado')
					->references('id_empleado')
						->on('empleados');
			$table->integer('id_sucursal')->unsigned();
			$table->foreign('id_sucursal')
					->references('id_sucursal')
						->on('sucursales_productos');
			$table->bigInteger('id_producto_devuelto')->unsigned();
			$table->foreign('id_producto_devuelto')
					->references('id_producto')
						->on('sucursales_productos');
			$table->bigInteger('id_producto_cambio')->unsigned();
			$table->foreign('id_producto_cambio')
					->references('id_producto')
						->on('sucursales_productos');
			$table->decimal('diferencia',12,2);
			$table->string('concepto',150);
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
		Schema::drop('devoluciones');
	}

}
