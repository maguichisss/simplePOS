@extends('tipoDePago.content')

@section('contenido')
<h1>Tipo de Pago</h1>
{{ Form::open(array('url'=>'tiposDePagos')) }}
<table  class="table table-hover table-condensed">
	<thead>
		<th class='col-sm-1'></th>
		<th class='col-sm-4'></th>
		<th class='col-sm-7'></th>
	</thead>
	<tr>
		<td>Tipo de Pago</td> 
		<td>{{Form::text('tipoDePago','',['required'])}}</td>
	</tr>
	<tr>
		<td></td>
		<td>
			{{Form::submit('Guardar', ['class' => 'btn btn-danger'])}}
	{{-- route url hacia donde va a regresar--}}
			<a href="{{URL::route('tiposDePagos.index')}}" class="btn btn-success">
				Regresar
			</a>
		</td>
	</tr>
</table>
{{ Form::close() }}
@stop