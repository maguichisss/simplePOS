@extends('tipoDeEmpleado.content')
@section('contenido')


{{ Form::open(array('url'=>'tiposDeEmpleados/'.$tipoDeEmpleado->id_tipo_de_empleado, 'method'=>'put')) }}
<table>
	<tr>
		<td>Tipo</td> 
		<td>
			{{Form::text('tipo', $tipoDeEmpleado->tipo_de_empleado, ['required'] )}}
		</td>
	</tr>
	<tr>
		<td>Descripcion</td> 
		<td>
			{{Form::textArea('descripcion', $tipoDeEmpleado->descripcion,$atributos = array(	  
							'rows' => '3', 
							'maxlength' => '150'		))}}
		</td>
	</tr>
	<tr>
		<td>Habilitado</td>
		<td>
		{{-- Traemos todas las s y las pasamos a la lista --}}
			{{Form::select('habilitado', 
							array( 	true => 'Habilitado', 
									false => 'Deshabilitado'),
							$tipoDeEmpleado->habilitado)}}
		</td>
	</tr>
	<tr>
		<td></td> 
		<td>
			{{Form::submit('Guardar', ['class' => 'btn btn-danger'])}}
			<a href="{{URL::route('tiposDeEmpleados.index')}}" class="btn btn-success">
				Regresar
			</a>
		</td>
	</tr>

</table>
{{ Form::close() }}
@stop