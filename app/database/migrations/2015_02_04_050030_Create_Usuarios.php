<?php

use Illuminate\Database\Schema\Blueprint;
use Illuminate\Database\Migrations\Migration;

class CreateUsuarios extends Migration {

	/**
	 * Run the migrations.
	 *
	 * @return void
	 */
	public function up()
	{
		Schema::create('usuarios', function(Blueprint $table)
		{
			$table->increments('id_usuario');
			$table->string('username',50)->unique();
			$table->string('password',60);
			$table->integer('id_empleado')->unsigned();
			$table->foreign('id_empleado')
					->references('id_empleado')
						->on('empleados');
			$table->boolean('habilitado')->default(true);
			$table->rememberToken();
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
		Schema::drop('usuarios');
	}

}
