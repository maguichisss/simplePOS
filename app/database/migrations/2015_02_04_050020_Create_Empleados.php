<?php

use Illuminate\Database\Schema\Blueprint;
use Illuminate\Database\Migrations\Migration;

class CreateEmpleados extends Migration {

	/**
	 * Run the migrations.
	 *
	 * @return void
	 */
	public function up()
	{
		Schema::create('empleados', function(Blueprint $table)
		{
			$table->increments('id_empleado');
			$table->integer('id_datos_personales')->unsigned();
			$table->foreign('id_datos_personales')
					->references('id_datos_personales')
						->on('datos_personales');
			$table->integer('id_tipo_de_empleado')->unsigned();
			$table->foreign('id_tipo_de_empleado')
					->references('id_tipo_de_empleado')
						->on('tipos_de_empleados');
			$table->integer('id_sucursal')->unsigned();
			$table->foreign('id_sucursal')
					->references('id_sucursal')
						->on('sucursales');
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
		Schema::drop('empleados');
	}

}
