@extends('cliente.content')

@section('datos_cliente')

<table class="table table-striped table-hover table-condensed">
	<thead>
		<td></td><td></td><td></td><td></td><td></td><td>
		</td><td></td><td></td><td></td><td></td>
		<td>
			<a href="clientes/create" class="btn btn-success ">
				Agregar
			</a>
		</td>
	</thead>
	<thead>
		<th class="col-sm-2">Nombre</th>
		<th class="col-sm-2">Apellido Paterno</th>
		<th class="col-sm-2">Apellido Materno</th>
		<th class="col-sm-2">Tipo de cliente</th>
		<th class="col-sm-2">Direccion</th>
		<th class="col-sm-0">Telefono</th>
		<th class="col-sm-*">CP</th>
		<th class="col-sm-*">Email</th>
		<th class="col-sm-*">RFC</th>
		<th class="col-sm-*">Modificado</th>
		<th class="col-sm-*">Eliminar</th>
	</thead>
	@foreach($clientes as $cliente)
	<tr>
		<td>{{$cliente->nombre}}</td>
		<td>{{$cliente->apellido_paterno}}</td>
		<td>{{$cliente->apellido_materno}}</td>
		<td>{{$cliente->tipo_de_cliente}}</td>
		<td class="setWidth concat">{{$cliente->calle.' '.$cliente->colonia.' '.$cliente->delegacion.' '.$cliente->estado}}</td>
		<td>{{$cliente->telefono}}</td>
		<td>{{$cliente->cp}}</td>
		<td>{{$cliente->email}}</td>
		<td>{{$cliente->rfc}}</td>		
		<td class="alert alert-warning">
			<a href="clientes/{{$cliente->id_cliente}}/edit"
			class="btn btn-link">
			{{$cliente->updated_at}}
			</a>
		</td>
		<td class="alert alert-danger">
			{{ Form::open(array('url'=>'clientes/'.$cliente->id_cliente , 'method'=>'delete')) }}
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