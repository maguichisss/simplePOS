@extends('tipoDeCliente.content')
@section('contenido')


{{ Form::open(array('url'=>'tiposDeClientes/'.$tipoDeCliente->id_tipo_de_cliente, 'method'=>'put')) }}
<table>
	<tr>
		<td>Tipo</td> 
		<td>
			{{Form::text('tipoDeCliente', $tipoDeCliente->tipo_de_cliente, ['required'] )}}
		</td>
	</tr>
	<tr>
		<td>Descripcion</td> 
		<td>
			{{Form::textArea('descripcion', $tipoDeCliente->descripcion,$atributos = array(	  'rows' => '3', 
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
							$tipoDeCliente->habilitado)}}
		</td>
	</tr>
	<tr>
		<td></td> 
		<td>
			{{Form::submit('Guardar', ['class' => 'btn btn-danger'])}}
			<a href="{{URL::route('tiposDeClientes.index')}}" class="btn btn-success">
				Regresar
			</a>
		</td>
	</tr>

</table>
{{ Form::close() }}
@stop