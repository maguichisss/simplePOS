@extends('proveedor.content')

@section('contenido')

{{ Form::open(array('url'=>'proveedores')) }}
<h4>Nuevo Proveedor</h4>
<table  class="table table-hover table-condensed">
	<thead>
		<th class='col-sm-1'></th>
		<th class='col-sm-5'></th>
	</thead>
	<tr>
		<td>Nombre</td> 
		<td>{{Form::text('nombre','', $atributos = 
			array(	'required' => 'required', 
					'placeholder' => 'Nombre', 
					'maxlength' => '50'		))}}</td>
	</tr>
	<tr>
		<td>Direccion</td> 
		<td>{{Form::text('direccion','', $atributos = 
			array(	'required' => 'required', 
					'placeholder' => 'Direccion', 
					'maxlength' => '50'		))}}</td>
	</tr>
	<tr>
		<td>RFC</td> 
		<td>{{Form::text('rfc','', $atributos = 
			array(	'required' => 'required', 
					'placeholder' => 'abcd123456123', 
					'pattern' => '[a-zA-Z]{4}[0-9]{6,9}?',
					'maxlength' => '13'		))}}</td>
	</tr>
	<tr>
		<td>Telefono</td> 
		<td>{{Form::text('telefono','', $atributos = 
			array(	'required' => 'required', 
					'pattern' => '[0-9]{8,10}?',
					'placeholder' => '1122334455', 
					'maxlength' => '15'		))}}</td>
	</tr>
	<tr>
		<td>Email</td> 
		<td>{{Form::email('email','', $atributos = 
			array(	'placeholder' => 'hola@ejemplo.com', 
					'maxlength' => '45'		))}}</td>
	</tr>
	<tr>
		<td>Pagina web</td> 
		<td>{{Form::url('web','http://www.', $atributos = 
			array(	'placeholder' => 'http://www.', 
					'maxlength' => '100'		))}}</td>
	</tr>
	<tr>
		<td></td>
		<td>
			{{Form::submit('Guardar', ['class' => 'btn btn-danger'])}}
	{{-- route URL hacia donde va a regresar--}}
			<a href="{{URL::route('proveedores.index')}}" class="btn btn-success">
				Regresar
			</a>
		</td>
	</tr>
</table>
{{ Form::close() }}
@stop