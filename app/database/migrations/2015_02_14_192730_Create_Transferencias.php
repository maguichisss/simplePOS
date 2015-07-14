<?php

use Illuminate\Database\Schema\Blueprint;
use Illuminate\Database\Migrations\Migration;

class CreateTransferencias extends Migration {

	/**
	 * Run the migrations.
	 *
	 * @return void
	 */
	public function up()
	{
		Schema::create('transferencias', function(Blueprint $table)
		{
			$table->increments('id_transferencia');
			$table->integer('id_empleado')->unsigned();
			$table->foreign('id_empleado')
					->references('id_empleado')
						->on('empleados');
						
			$table->integer('id_sucursal_origen')->unsigned();
			$table->foreign('id_sucursal_origen')
					->references('id_sucursal')
						->on('sucursales');
						
			$table->integer('id_sucursal_destino')->unsigned();
			$table->foreign('id_sucursal_destino')
					->references('id_sucursal')
						->on('sucursales');
						
			$table->bigInteger('id_producto')->unsigned();
			$table->foreign('id_producto')
					->references('id_producto')
						->on('productos');
						
			$table->smallInteger('cantidad');
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
		Schema::drop('transferencias');
	}

}
