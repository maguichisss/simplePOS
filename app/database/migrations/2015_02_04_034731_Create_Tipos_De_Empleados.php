<?php

use Illuminate\Database\Schema\Blueprint;
use Illuminate\Database\Migrations\Migration;

class CreateTiposDeEmpleados extends Migration {

	/**
	 * Run the migrations.
	 *
	 * @return void
	 */
	public function up()
	{
		Schema::create('tipos_de_empleados', function(Blueprint $table)
		{
			$table->increments('id_tipo_de_empleado');
			$table->string('tipo_de_empleado',30)->unique();
			$table->string('descripcion',150)->nullable();
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
		Schema::drop('tipos_de_empleados');
	}

}
