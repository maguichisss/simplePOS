@extends('sucursal.content')
@section('contenido')

<h4>Modificar Sucursal</h4>
{{ Form::open(array('url'=>'sucursales/'.$sucursal->id_sucursal, 'method'=>'put')) }}
<table  class="table table-hover table-condensed">
	<thead>
		<th class='col-sm-1'></th>
		<th class='col-sm-5'></th>
	</thead>
	<tr>
		<td>Nombre</td> 
		<td>{{Form::text('nombre', $sucursal->nombre_sucursal, $atributos = 
			array(	'required' => 'required', 
					'maxlength' => '50'		))}}</td>
	</tr>
	<tr>
		<td>Direccion</td> 
		<td>{{Form::text('direccion', $sucursal->direccion, $atributos = 
			array(	'required' => 'required', 
					'maxlength' => '50'		))}}</td>
	</tr>
	<tr>
		<td>Telefono</td> 
		<td>{{Form::number('telefono', $sucursal->telefono, $atributos = 
			array(	'required' => 'required', 
					'pattern' => '[0-9]{8,10}?',
					'maxlength' => '10'		))}}</td>
	</tr>
	<tr>
		<td>Email</td> 
		<td>{{Form::email('email', $sucursal->email, $atributos = 
			array(	'required' => 'required', 
					'maxlength' => '45'		))}}</td>
	</tr>
	<tr>
		<td>Habilitado</td>
		<td>
		{{-- Traemos todas las s y las pasamos a la lista --}}
			{{Form::select('habilitado', 
							array( 	true => 'Habilitado', 
									false => 'Deshabilitado'),
							$sucursal->habilitado)}}
		</td>
	</tr>
	<tr>
		<td></td> 
		<td>
			{{Form::submit('Guardar', ['class' => 'btn btn-danger'])}}
			<a href="{{URL::route('sucursales.index')}}" class="btn btn-success">
				Regresar
			</a>
		</td>
	</tr>

</table>
{{ Form::close() }}
@stop