<?php

use Illuminate\Database\Schema\Blueprint;
use Illuminate\Database\Migrations\Migration;

class CreateCompras extends Migration {

	/**
	 * Run the migrations.
	 *
	 * @return void
	 */
	public function up()
	{
		Schema::create('compras', function(Blueprint $table)
		{
			$table->increments('id_compra');
			$table->integer('id_sucursal')->unsigned();
			$table->foreign('id_sucursal')
					->references('id_sucursal')
						->on('sucursales');
			$table->integer('id_proveedor')->unsigned();
			$table->foreign('id_proveedor')
					->references('id_proveedor')
						->on('proveedores');
			$table->integer('id_empleado')->unsigned();
			$table->foreign('id_empleado')
					->references('id_empleado')
						->on('empleados');
			$table->string('numero_de_nota', 20)->nullable();
			$table->decimal('total', 12,2);
			$table->date('fecha');
			$table->string('detalles', 150)->nullable();
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
		Schema::drop('compras');
	}

}
