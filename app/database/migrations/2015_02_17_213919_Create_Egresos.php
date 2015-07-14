<?php

use Illuminate\Database\Schema\Blueprint;
use Illuminate\Database\Migrations\Migration;

class CreateEgresos extends Migration {

	/**
	 * Run the migrations.
	 *
	 * @return void
	 */
	public function up()
	{
		Schema::create('egresos', function(Blueprint $table)
		{
			$table->increments('id_egreso');
			$table->integer('id_empleado')->unsigned();
			$table->foreign('id_empleado')
					->references('id_empleado')
						->on('empleados');
			$table->integer('id_sucursal')->unsigned();
			$table->foreign('id_sucursal')
					->references('id_sucursal')
						->on('sucursales');
			$table->decimal('importe', 12,2);
			$table->string('concepto', 150);
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
		Schema::drop('egresos');
	}

}
