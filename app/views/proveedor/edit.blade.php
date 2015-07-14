@extends('proveedor.content')
@section('contenido')

<h4>Modificar Proveedor</h4>
{{ Form::open(array('url'=>'proveedores/'.$proveedor->id_proveedor, 'method'=>'put')) }}
<table  class="table table-hover table-condensed">
	<thead>
		<th class='col-sm-1'></th>
		<th class='col-sm-5'></th>
	</thead>
	<tr>
		<td>Nombre</td> 
		<td>{{Form::text('nombre',$proveedor->nombre, $atributos = 
			array(	'required' => 'required', 
					'placeholder' => 'Nombre', 
					'maxlength' => '50'		))}}</td>
	</tr>
	<tr>
		<td>Direccion</td> 
		<td>{{Form::text('direccion',$proveedor->direccion, $atributos = 
			array(	'required' => 'required', 
					'placeholder' => 'Direccion', 
					'maxlength' => '50'		))}}</td>
	</tr>
	<tr>
		<td>RFC</td> 
		<td>{{Form::text('rfc',$proveedor->rfc, $atributos = 
			array(	'required' => 'required', 
					'placeholder' => 'abcd123456123', 
					'pattern' => '[a-zA-Z]{4}[0-9]{6,9}?',
					'maxlength' => '13'		))}}</td>
	</tr>
	<tr>
		<td>Telefono</td> 
		<td>{{Form::text('telefono',$proveedor->telefono, $atributos = 
			array(	'required' => 'required', 
					'placeholder' => '1122334455', 
					'pattern' => '[0-9]{8,10}?',
					'maxlength' => '15'		))}}</td>
	</tr>
	<tr>
		<td>Email</td> 
		<td>{{Form::email('email',$proveedor->email, $atributos = 
			array(	'placeholder' => 'hola@ejemplo.com', 
					'maxlength' => '45'		))}}</td>
	</tr>
	<tr>
		<td>Pagina web</td> 
		<td>{{Form::url('web',$proveedor->pagina_web, $atributos = 
			array(	'placeholder' => 'http://www.', 
					'maxlength' => '100'		))}}</td>
	</tr>
	<tr>
		<td>Habilitado</td>
		<td>
		{{-- Traemos todas las s y las pasamos a la lista --}}
			{{Form::select('habilitado', 
							array( 	true => 'Habilitado', 
									false => 'Deshabilitado'),
							$proveedor->habilitado)}}
		</td>
	</tr>
	<tr>
		<td></td> 
		<td>
			{{Form::submit('Guardar', ['class' => 'btn btn-danger'])}}
			<a href="{{URL::route('proveedores.index')}}" class="btn btn-success">
				Regresar
			</a>
		</td>
	</tr>

</table>
{{ Form::close() }}
@stop