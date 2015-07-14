<?php

use Illuminate\Database\Schema\Blueprint;
use Illuminate\Database\Migrations\Migration;

class CreateUsuariosEmpleados extends Migration {

	/**
	 * Run the migrations.
	 *
	 * @return void
	 */
	public function up()
	{
		Schema::create('usuarios_empleados', function(Blueprint $table)
		{
			$table->increments('id_usuarios_empleados');
			$table->integer('id_usuario')->unsigned();
			$table->foreign('id_usuario')
					->references('id_usuario')
						->on('usuarios');
			$table->integer('id_empleado')->unsigned();
			$table->foreign('id_empleado')
					->references('id_empleado')
						->on('empleados');
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
		Schema::drop('usuarios_empleados');
	}

}
