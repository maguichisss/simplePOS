@extends('tipoDeCliente.content')

@section('contenido')

{{ Form::open(array('url'=>'tiposDeClientes')) }}
<table  class="table table-hover table-condensed">
	<thead>
		<th class='col-sm-1'></th>
		<th class='col-sm-5'></th>
	</thead>
	<tr>
		<td>Tipo</td> 
		<td>{{Form::text('tipoDeCliente','',['required'])}}</td>
	</tr>
	<tr>
		<td>Descripcion</td> 
		<td>{{Form::textArea('descripcion','', $atributos = 
			array(	'rows' => '3', 
					'maxlength' => '150'		))}}</td>
	</tr>
	<tr>
		<td></td>
		<td>
			{{Form::submit('Guardar', ['class' => 'btn btn-danger'])}}
	{{-- route url hacia donde va a regresar--}}
			<a href="{{URL::route('tiposDeClientes.index')}}" class="btn btn-success">
				Regresar
			</a>
		</td>
	</tr>
</table>
{{ Form::close() }}
@stop