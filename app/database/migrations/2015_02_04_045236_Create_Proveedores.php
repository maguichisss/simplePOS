<?php

use Illuminate\Database\Schema\Blueprint;
use Illuminate\Database\Migrations\Migration;

class CreateProveedores extends Migration {

	/**
	 * Run the migrations.
	 *
	 * @return void
	 */
	public function up()
	{
		Schema::create('proveedores', function(Blueprint $table)
		{
			$table->increments('id_proveedor');
			$table->string('nombre', 50);
			$table->string('direccion', 100);
			$table->string('rfc', 13);
			$table->string('telefono', 15);
			$table->string('email', 45)->nullable();
			$table->string('pagina_web', 100)->nullable();
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
		Schema::drop('proveedores');
	}

}
