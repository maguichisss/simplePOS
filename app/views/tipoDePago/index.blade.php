@extends('tipoDePago.content')

@section('contenido')

<h1>
	Tipos de Pago
</h1>
<table class="table table-striped table-hover table-condensed">
	<thead>
		<td></td><td></td><td></td>
		<td>
			<a href="tiposDePagos/create" class="btn btn-success btn-xs">
				Agregar
			</a>
		</td>
	</thead>
	<thead>
		<th class="col-sm-2">Tipo</th>
		<th class="col-sm-3">Creado</th>
		<th class="col-sm-3">Modificado</th>
		<th class="col-sm-0">Eliminar</th>
	</thead>
	@foreach($tiposDePagos as $tipoDePago)
	<tr>
		<td>{{$tipoDePago->tipo_de_pago}}</td>		
		<td>{{$tipoDePago->created_at}}</td>
		<td class="alert alert-warning">
			<a href="tiposDePagos/{{$tipoDePago->id_tipo_de_pago}}/edit"
			class="btn btn-link">
			{{$tipoDePago->updated_at}}
			</a>
		</td>
		<td class="alert alert-danger">
			{{ Form::open(array('url'=>'tiposDePagos/'.$tipoDePago->id_tipo_de_pago , 'method'=>'delete')) }}
			{{Form::submit('Eliminar', ['class' => 'btn btn-link'])}}
			{{ Form::close() }}
		</td>
	</tr>
	@endforeach
</table>
{{--Si se guardo la sesion en algun metodo de ProductoController.php
	muestra el mensaje con los parametros enviados 		--}}
@if(Session::has('message'))
	<div class="alert alert-{{ Session::get('class')}}">
		{{ Session::get('message') }} 
	</div>
@endif

@stop