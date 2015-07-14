@extends('tipoDePago.content')

@section('contenido')
<h1>Tipo de Pago</h1>
{{ Form::open(array('url'=>'tiposDePagos/'.$tipoDePago->id_tipo_de_pago, 'method'=>'put')) }}
<table>
	<tr>
		<td>Tipo</td> 
		<td>{{Form::text('tipoDePago', $tipoDePago->tipo_de_pago )}}</td>
	</tr>
	<tr>
		<td>Habilitado</td>
		<td>
		{{-- Traemos todas las tipoDePagos y las pasamos a la lista --}}
			{{Form::select('habilitado', 
							array( 	true => 'Habilitado', 
									false => 'Deshabilitado'),
							$tipoDePago->habilitado)}}
		</td>
	</tr>
	<tr>
		<td></td> 
		<td>
			{{Form::submit('Guardar', ['class' => 'btn btn-danger'])}}
			<a href="{{URL::route('tiposDePagos.index')}}" class="btn btn-success">
				Regresar
			</a>
		</td>
	</tr>

</table>
{{ Form::close() }}
@stop