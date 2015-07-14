<?php

class ProductoTableSeeder extends Seeder{

	public function run(){
        $date = new DateTime;

//tabla 1 tipos_de_clientes
        DB::table('tipos_de_clientes')->insert(
        	array(
                array(
                    'tipo_de_cliente' => 'cliente de mostrador',
                    'descripcion' => 'cliente no registrado en el sistema',
                    'created_at' => $date,
                    'updated_at' => $date),
                array(
                    'tipo_de_cliente' => 'normal',
                    'descripcion' => null,
                    'created_at' => $date,
                    'updated_at' => $date ),
                array(
                    'tipo_de_cliente' => 'tienda',
                    'descripcion' => null,
                    'created_at' => $date,
                    'updated_at' => $date ),
                array(
                    'tipo_de_cliente' => 'distribuidor',
                    'descripcion' => 'cliente que vende mucho',
                    'created_at' => $date,
                    'updated_at' => $date)
             
        	)
        );
//tabla 2 tipos_de_empleados
        DB::table('tipos_de_empleados')->insert(
        	array(
                array(
                    'tipo_de_empleado' => 'administrador',
                    'descripcion' => 'administra todo el sistema y sucursales',
                    'created_at' => $date,
                    'updated_at' => $date),
                array(
                    'tipo_de_empleado' => 'gerente general',
                    'descripcion' => 'administra varias sucursales',
                    'created_at' => $date,
                    'updated_at' => $date ),
                array(
                    'tipo_de_empleado' => 'gerente de sucursal',
                    'descripcion' => 'arministra una sucursal',
                    'created_at' => $date,
                    'updated_at' => $date ),
                array(
                    'tipo_de_empleado' => 'vendedor',
                    'descripcion' => 'ventas, devoluciones, inventario',
                    'created_at' => $date,
                    'updated_at' => $date )
        	)
        );
//tabla 3 datos_personales
        DB::table('datos_personales')->insert(
        	array(
                array(
                    'nombre' => 'Mauricio',
                    'apellido_paterno' => 'Garces',
                    'apellido_materno' => null,
                    'fecha_nacimiento' => 
                            date("Y-m-d", mt_rand(162055681,1262055681*2) ),
                    'genero' => 0,
                    'calle' => null,
                    'colonia' => null,
                    'delegacion' => null,
                    'estado' => null,
                    'cp' => null,
                    'telefono' => null,
                    'email' => null,
                    'rfc' => null,
                    'created_at' => $date,
                    'updated_at' => $date ),
                array(
                    'nombre' => 'copilco',
                    'apellido_paterno' => 'c',
                    'apellido_materno' => null,
                    'fecha_nacimiento' => 
                            date("Y-m-d", mt_rand(162055681,1262055681*2) ),
                    'genero' => 0,
                    'calle' => null,
                    'colonia' => null,
                    'delegacion' => null,
                    'estado' => null,
                    'cp' => null,
                    'telefono' => null,
                    'email' => null,
                    'rfc' => null,
                    'created_at' => $date,
                    'updated_at' => $date ),
                array(
                    'nombre' => 'ajusco',
                    'apellido_paterno' => 'a',
                    'apellido_materno' => null,
                    'fecha_nacimiento' => 
                            date("Y-m-d", mt_rand(162055681,1262055681*2) ),
                    'genero' => 0,
                    'calle' => null,
                    'colonia' => null,
                    'delegacion' => null,
                    'estado' => null,
                    'cp' => null,
                    'telefono' => null,
                    'email' => null,
                    'rfc' => null,
                    'created_at' => $date,
                    'updated_at' => $date ),
                array(
                    'nombre' => 'valle',
                    'apellido_paterno' => 'v',
                    'apellido_materno' => null,
                    'fecha_nacimiento' => 
                            date("Y-m-d", mt_rand(162055681,1262055681*2) ),
                    'genero' => 0,
                    'calle' => null,
                    'colonia' => null,
                    'delegacion' => null,
                    'estado' => null,
                    'cp' => null,
                    'telefono' => null,
                    'email' => null,
                    'rfc' => null,
                    'created_at' => $date,
                    'updated_at' => $date ),
                array(
                    'nombre' => 'cliente de mostrador',
                    'apellido_paterno' => 'c',
                    'apellido_materno' => null,
                    'fecha_nacimiento' => 
                            date("Y-m-d", mt_rand(162055681,1262055681*2) ),
                    'genero' => 0,
                    'calle' => null,
                    'colonia' => null,
                    'delegacion' => null,
                    'estado' => null,
                    'cp' => null,
                    'telefono' => null,
                    'email' => null,
                    'rfc' => null,
                    'created_at' => $date,
                    'updated_at' => $date ),
                array(
                    'nombre' => 'Primer',
                    'apellido_paterno' => 'cliente',
                    'apellido_materno' => 'normal',
                    'fecha_nacimiento' => 
                            date("Y-m-d", mt_rand(162055681,1262055681*2) ),
                    'genero' => 1,
                    'calle' => 'calle13',
                    'colonia' => null,
                    'delegacion' => null,
                    'estado' => null,
                    'cp' => null,
                    'telefono' => null,
                    'email' => null,
                    'rfc' => null,
                    'created_at' => $date,
                    'updated_at' => $date ),
                array(
                    'nombre' => 'empleado',
                    'apellido_paterno' => 'ajusco',
                    'apellido_materno' => 'primero',
                    'fecha_nacimiento' => 
                            date("Y-m-d", mt_rand(162055681,1262055681*2) ),
                    'genero' => 1,
                    'calle' => 'calle1',
                    'colonia' => null,
                    'delegacion' => null,
                    'estado' => null,
                    'cp' => null,
                    'telefono' => null,
                    'email' => null,
                    'rfc' => null,
                    'created_at' => $date,
                    'updated_at' => $date ),
                array(
                    'nombre' => 'empleado',
                    'apellido_paterno' => 'copilco',
                    'apellido_materno' => 'primero',
                    'fecha_nacimiento' => 
                            date("Y-m-d", mt_rand(162055681,1262055681*2) ),
                    'genero' => 1,
                    'calle' => 'calle1',
                    'colonia' => null,
                    'delegacion' => null,
                    'estado' => null,
                    'cp' => null,
                    'telefono' => null,
                    'email' => null,
                    'rfc' => null,
                    'created_at' => $date,
                    'updated_at' => $date ),
                array(
                    'nombre' => 'empleado',
                    'apellido_paterno' => 'valle',
                    'apellido_materno' => 'primero',
                    'fecha_nacimiento' => 
                            date("Y-m-d", mt_rand(162055681,1262055681*2) ),
                    'genero' => 1,
                    'calle' => 'calle1',
                    'colonia' => null,
                    'delegacion' => null,
                    'estado' => null,
                    'cp' => null,
                    'telefono' => null,
                    'email' => null,
                    'rfc' => null,
                    'created_at' => $date,
                    'updated_at' => $date )
        	)
        );
//tabla 4 tipos_de_pagos
        DB::table('tipos_de_pagos')->insert(
        	array(
                array(
                    'tipo_de_pago' => 'Efectivo',
                    'created_at' => $date,
                    'updated_at' => $date	),
                array(
                    'tipo_de_pago' => 'Tarjeta',
                    'created_at' => $date,
                    'updated_at' => $date	),
                array(
                    'tipo_de_pago' => 'Deposito',
                    'created_at' => $date,
                    'updated_at' => $date ),
                array(
                    'tipo_de_pago' => 'Cheque',
                    'created_at' => $date,
                    'updated_at' => $date )
             
        	)
        );
//tabla 5 proveedores
        DB::table('proveedores')->insert(
        	array(
                array(
                    'nombre' => 'Compra directa',
                    'direccion' => 'compra directa',
                    'rfc' => '123456789',
                    'telefono' => '123456789',
                    'email' => 'compradirecta@compradirecta.com',
                    'created_at' => $date,
                    'updated_at' => $date ),
                array(
                    'nombre' => 'Genesis',
                    'direccion' => 'Hidalgo 895',
                    'rfc' => '0987654321123',
                    'telefono' => '1231231231',
                    'email' => 'gen@hola.com',
                    'created_at' => $date,
                    'updated_at' => $date ),
                array(
                    'nombre' => 'GNC',
                    'direccion' => 'Mexico 86',
                    'rfc' => '12345',
                    'telefono' => '5654441234',
                    'email' => 'gnc@gnc.com',
                    'created_at' => $date,
                    'updated_at' => $date ),
                array(
                    'nombre' => 'VPX',
                    'direccion' => 'Morelos 656',
                    'rfc' => '12345',
                    'telefono' => '5560441234',
                    'email' => 'vpx@hola.com',
                    'created_at' => $date,
                    'updated_at' => $date ),
                array(
                    'nombre' => 'Muscle',
                    'direccion' => 'Universidad 1246',
                    'rfc' => '1234567890123',
                    'telefono' => '5560441234',
                    'email' => 'muscle@hola.com',
                    'created_at' => $date,
                    'updated_at' => $date )
        	)
        );
//tabla 6 sucursales
        DB::table('sucursales')->insert(
            array(
                array(
                    'nombre_sucursal' => 'Copilco',
                    'direccion' => 'Hidalgo 895',
                    'telefono' => '1231231231',
                    'email' => 'gen@hola.com',
                    'created_at' => $date,
                    'updated_at' => $date ),
                array(
                    'nombre_sucursal' => 'Ajusco',
                    'direccion' => 'Mexico 86',
                    'telefono' => '5654441234',
                    'email' => 'dsa@hola.com',
                    'created_at' => $date,
                    'updated_at' => $date ),
                array(
                    'nombre_sucursal' => 'Del Valle',
                    'direccion' => 'Morelos 656',
                    'telefono' => '5560441234',
                    'email' => 'asd@hola.com',
                    'created_at' => $date,
                    'updated_at' => $date )
            )
        );
//tabla 7 empleados
        DB::table('empleados')->insert(
            array(
                array(
                    'id_datos_personales' => 1,
                    'id_tipo_de_empleado' => 1,
                    'id_sucursal' => 1,
                    'created_at' => $date,
                    'updated_at' => $date ),
                array(
                    'id_datos_personales' => 2,
                    'id_tipo_de_empleado' => 3,
                    'id_sucursal' => 1,
                    'created_at' => $date,
                    'updated_at' => $date ),
                array(
                    'id_datos_personales' => 3,
                    'id_tipo_de_empleado' => 3,
                    'id_sucursal' => 2,
                    'created_at' => $date,
                    'updated_at' => $date ),
                array(
                    'id_datos_personales' => 4,
                    'id_tipo_de_empleado' => 3,
                    'id_sucursal' => 3,
                    'created_at' => $date,
                    'updated_at' => $date ),
                array(
                    'id_datos_personales' => 7,
                    'id_tipo_de_empleado' => 4,
                    'id_sucursal' => 1,
                    'created_at' => $date,
                    'updated_at' => $date ),
                array(
                    'id_datos_personales' => 8,
                    'id_tipo_de_empleado' => 4,
                    'id_sucursal' => 2,
                    'created_at' => $date,
                    'updated_at' => $date ),
                array(
                    'id_datos_personales' => 9,
                    'id_tipo_de_empleado' => 4,
                    'id_sucursal' => 3,
                    'created_at' => $date,
                    'updated_at' => $date )
            )
        );
//tabla 8 usuarios
        DB::table('usuarios')->insert(
            array(
                array(
                    'username' => 'superadmin',
                    'password' => Hash::make('123'),
                    'id_empleado' => 1,
                    'created_at' => $date,
                    'updated_at' => $date     ),
                array(
                    'username' => 'copilco',
                    'password' => Hash::make('123'),
                    'id_empleado' => 2,
                    'created_at' => $date,
                    'updated_at' => $date     ),
                array(
                    'username' => 'ajusco',
                    'password' => Hash::make('123'),
                    'id_empleado' => 3,
                    'created_at' => $date,
                    'updated_at' => $date     ),
                array(
                    'username' => 'valle',
                    'password' => Hash::make('123'),
                    'id_empleado' => 4,
                    'created_at' => $date,
                    'updated_at' => $date     ),
                array(
                    'username' => 'ajuscoe',
                    'password' => Hash::make('123'),
                    'id_empleado' => 5,
                    'created_at' => $date,
                    'updated_at' => $date     ),
                array(
                    'username' => 'copilcoe',
                    'password' => Hash::make('123'),
                    'id_empleado' => 6,
                    'created_at' => $date,
                    'updated_at' => $date     ),
                array(
                    'username' => 'vallee',
                    'password' => Hash::make('123'),
                    'id_empleado' => 7,
                    'created_at' => $date,
                    'updated_at' => $date     )
            )
        );
//tabla 9 clientes
        DB::table('clientes')->insert(
            array(
                array(
                    'id_datos_personales' => 5,
                    'id_tipo_de_cliente' => 1,
                    'created_at' => $date,
                    'updated_at' => $date    ),
                array(
                    'id_datos_personales' => 6,
                    'id_tipo_de_cliente' => 2,
                    'created_at' => $date,
                    'updated_at' => $date    )
            )
        );
//tabla 10 categorias_de_productos
        DB::table('categorias_de_productos')->insert(
        	array(
                array(
                    'categoria' => 'Beauty',
                    'created_at' => $date,
                    'updated_at' => $date ),
                array(
                    'categoria' => 'Complemento',
                    'created_at' => $date,
                    'updated_at' => $date	),
                array(
                    'categoria' => 'Fitness',
                    'created_at' => $date,
                    'updated_at' => $date ),
                array(
                    'categoria' => 'Varios',
                    'created_at' => $date,
                    'updated_at' => $date )
             
        	)
        );
//tabla 11 productos
/*
        DB::table('productos')->insert(
        	array(
                array(
                    'id_producto' => '893912124892',
                    'nombre_producto' => 'Super pastillas',
                    'descripcion' => 'muy buenas',
                    'id_categoria_de_producto' => 2,
                    'precio_compra' => 200,
                    'precio_cliente_frecuente' => 225,
                    'created_at' => $date,
                    'updated_at' => $date	),
                array(
                    'id_producto' => '893912124915',
                    'nombre_producto' => 'SOBRES NECTAR GRABN GO',
                    'descripcion' => 'VAINILLA 12 PIEZAS',
                    'id_categoria_de_producto' => 3,
                    'precio_compra' => 350,
                    'precio_cliente_frecuente' => 490,
                    'created_at' => $date,
                    'updated_at' => $date ),
                array(
                    'id_producto' => '893912124861',
                    'nombre_producto' => 'SOBRES NECTAR GRABN GO',
                    'descripcion' => 'FRESA 12 PIEZAS',
                    'id_categoria_de_producto' => 3,
                    'precio_compra' => 350,
                    'precio_cliente_frecuente' => 490,
                    'created_at' => $date,
                    'updated_at' => $date ),
                array(
                    'id_producto' => '893912125073',
                    'nombre_producto' => 'NECTAR 2 LB',
                    'descripcion' => 'COOKIES',
                    'id_categoria_de_producto' => 1,
                    'precio_compra' => 78,
                    'precio_cliente_frecuente' => 145,
                    'created_at' => $date,
                    'updated_at' => $date )
             
        	)
        );
//tabla 18 sucursales_productos
        DB::table('sucursales_productos')->insert(
            array(
                array(
                    'id_sucursales_productos' => 1893912125073,
                    'id_sucursal' => 1,
                    'id_producto' => 893912125073,
                    'cantidad' => 14,
                    'stock' => 5,
                    'created_at' => $date,
                    'updated_at' => $date    ),
                array(
                    'id_sucursales_productos' => 2893912125073,
                    'id_sucursal' => 2,
                    'id_producto' => 893912125073,
                    'cantidad' => 23,
                    'stock' => 7,
                    'created_at' => $date,
                    'updated_at' => $date    ),
                array(
                    'id_sucursales_productos' => 3893912125073,
                    'id_sucursal' => 3,
                    'id_producto' => 893912125073,
                    'cantidad' => 19,
                    'stock' => 5,
                    'created_at' => $date,
                    'updated_at' => $date    ),
                
                array(
                    'id_sucursales_productos' => 1893912124861,
                    'id_sucursal' => 1,
                    'id_producto' => 893912124861,
                    'cantidad' => 34,
                    'stock' => 5,
                    'created_at' => $date,
                    'updated_at' => $date    ),
                array(
                    'id_sucursales_productos' => 2893912124861,
                    'id_sucursal' => 2,
                    'id_producto' => 893912124861,
                    'cantidad' => 23,
                    'stock' => 7,
                    'created_at' => $date,
                    'updated_at' => $date    ),
                array(
                    'id_sucursales_productos' => 3893912124861,
                    'id_sucursal' => 3,
                    'id_producto' => 893912124861,
                    'cantidad' => 21,
                    'stock' => 5,
                    'created_at' => $date,
                    'updated_at' => $date    ),
                
                array(
                    'id_sucursales_productos' => 1893912124892,
                    'id_sucursal' => 1,
                    'id_producto' => 893912124892,
                    'cantidad' => 50,
                    'stock' => 5,
                    'created_at' => $date,
                    'updated_at' => $date    ),
                array(
                    'id_sucursales_productos' => 2893912124892,
                    'id_sucursal' => 2,
                    'id_producto' => 893912124892,
                    'cantidad' => 73,
                    'stock' => 7,
                    'created_at' => $date,
                    'updated_at' => $date    ),
                array(
                    'id_sucursales_productos' => 3893912124892,
                    'id_sucursal' => 3,
                    'id_producto' => 893912124892,
                    'cantidad' => 27,
                    'stock' => 5,
                    'created_at' => $date,
                    'updated_at' => $date    ),
                
                array(
                    'id_sucursales_productos' => 1893912124915,
                    'id_sucursal' => 1,
                    'id_producto' => 893912124915,
                    'cantidad' => 19,
                    'stock' => 15,
                    'created_at' => $date,
                    'updated_at' => $date    ),
                array(
                    'id_sucursales_productos' => 2893912124915,
                    'id_sucursal' => 2,
                    'id_producto' => 893912124915,
                    'cantidad' => 63,
                    'stock' => 10,
                    'created_at' => $date,
                    'updated_at' => $date    ),
                array(
                    'id_sucursales_productos' => 3893912124915,
                    'id_sucursal' => 3,
                    'id_producto' => 893912124915,
                    'cantidad' => 17,
                    'stock' => 3,
                    'created_at' => $date,
                    'updated_at' => $date    ),
                
             
            )
        );
*/
//tabla 23 reglas_del_negocio
        DB::table('reglas_del_negocio')->insert(
            array(
                array(
                    'regla' => 'frecuente',
                    'minimo' => 1,
                    'maximo' => 1000,
                    'descuento' => 1,
                    'descripcion' => 'En la compra de 2 o mas productos
                        y hasta $1000 aplica precio de cliente frecuente',
                    'created_at' => $date,
                    'updated_at' => $date   ),
                array(
                    'regla' => 'publico',
                    'minimo' => 1,
                    'maximo' => 1,
                    'descuento' => 1.05,
                    'descripcion' => 'En la compra de 1 solo producto
                        aplica precio publico, %5 mas del precio de
                        cliente frecuente',
                    'created_at' => $date,
                    'updated_at' => $date   ),
                array(
                    'regla' => 'distribuidor',
                    'minimo' => 1001,
                    'maximo' => 5000,
                    'descuento' => 0.95,
                    'descripcion' => 'En la compra de $1000 a $5000 
                        aplica precio distribuidor, %5 de descuento',
                    'created_at' => $date,
                    'updated_at' => $date   ),
                array(
                    'regla' => 'mayorista1',
                    'minimo' => 5001,
                    'maximo' => 10000,
                    'descuento' => 0.92,
                    'descripcion' => 'En la compra de $5000 a $10000 
                        aplica precio mayorista1, %8 de descuento',
                    'created_at' => $date,
                    'updated_at' => $date   ),
                array(
                    'regla' => 'mayorista2',
                    'minimo' => 10001,
                    'maximo' => 100000,
                    'descuento' => 0.85,
                    'descripcion' => 'En la compra de $10000 a $100000 
                        aplica precio mayorista2, %15 de descuento',
                    'created_at' => $date,
                    'updated_at' => $date   ),
                array(
                    'regla' => 'mayorista3',
                    'minimo' => 100001,
                    'maximo' => 9999999999,
                    'descuento' => 0.8075,
                    'descripcion' => 'En la compra de mas de $100000 
                        aplica precio mayorista3, %19.25 de descuento',
                    'created_at' => $date,
                    'updated_at' => $date   ),
                array(
                    'regla' => 'frecuente fitness',
                    'minimo' => 2,
                    'maximo' => 9,
                    'descuento' => 0.9,
                    'descripcion' => 'De 2 a 9 piezas en los productos 
                         fitness se hace un 10% de descuento',
                    'created_at' => $date,
                    'updated_at' => $date   ),
                array(
                    'regla' => 'publico fitness',
                    'minimo' => 1,
                    'maximo' => 1,
                    'descuento' => 1,
                    'descripcion' => '1 pieza en los productos 
                         fitness no se hace descuento',
                    'created_at' => $date,
                    'updated_at' => $date   ),
                array(
                    'regla' => 'distribuidor fitness',
                    'minimo' => 10,
                    'maximo' => 19,
                    'descuento' => 0.85,
                    'descripcion' => 'De 10 a 19 piezas en los productos 
                         fitness se hace un 15% de descuento',
                    'created_at' => $date,
                    'updated_at' => $date   ),
                array(
                    'regla' => 'mayorista1 fitness',
                    'minimo' => 20,
                    'maximo' => 29,
                    'descuento' => 0.80,
                    'descripcion' => 'De 20 a 29 piezas en los productos 
                         fitness se hace un 20% de descuento',
                    'created_at' => $date,
                    'updated_at' => $date   ),
                array(
                    'regla' => 'mayorista2 fitness',
                    'minimo' => 30,
                    'maximo' => 50,
                    'descuento' => 0.70,
                    'descripcion' => 'De 30 a 50 piezas en los productos 
                         fitness se hace un 30% de descuento',
                    'created_at' => $date,
                    'updated_at' => $date   ),
                array(
                    'regla' => 'mayorista3 fitness',
                    'minimo' => 50,
                    'maximo' => 9999999999,
                    'descuento' => 0.60,
                    'descripcion' => 'Mas de 50 piezas en los productos 
                         fitness se hace un 40% de descuento',
                    'created_at' => $date,
                    'updated_at' => $date   )

            )
        );
	}

}