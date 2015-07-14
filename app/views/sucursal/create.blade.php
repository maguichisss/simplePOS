@extends('sucursal.content')
@section('contenido')

<h4>Nueva Sucursal</h4>
{{ Form::open(array('url'=>'sucursales')) }}
<table  class="table table-hover table-condensed">
	<thead>
		<th class='col-sm-1'></th>
		<th class='col-sm-5'></th>
	</thead>
	<tr>
		<td>Nombre</td> 
		<td>{{Form::text('nombre','', $atributos = 
			array(	'required' => 'required', 
					'maxlength' => '50'		))}}</td>
	</tr>
	<tr>
		<td>Direccion</td> 
		<td>{{Form::text('direccion','', $atributos = 
			array(	'required' => 'required', 
					'maxlength' => '50'		))}}</td>
	</tr>
	<tr>
		<td>Telefono</td> 
		<td>{{Form::text('telefono','', $atributos = 
			array(	'required' => 'required', 
					'pattern' => '[0-9]{8,10}?',
					'maxlength' => '10'		))}}</td>
	</tr>
	<tr>
		<td>Email</td> 
		<td>{{Form::email('email','', $atributos = 
			array(	'required' => 'required', 
					'maxlength' => '45'		))}}</td>
	</tr>
	<tr>
		<td></td>
		<td>
			{{Form::submit('Guardar', ['class' => 'btn btn-danger'])}}
	{{-- route URL hacia donde va a regresar--}}
			<a href="{{URL::route('sucursales.index')}}" class="btn btn-success">
				Regresar
			</a>
		</td>
	</tr>
</table>
{{ Form::close() }}
@stop