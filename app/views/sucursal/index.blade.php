@extends('sucursal.content')

@section('contenido')

<table class="table table-striped table-hover table-condensed">
	<thead>
		<td></td><td></td><td></td><td></td><td></td><td></td>
		<td>
			<a href="sucursales/create" class="btn btn-success ">
				Agregar
			</a>
		</td>
	</thead>
	<thead>
		<th class="col-sm-2">Sucursal</th>
		<th class="col-sm-3">Direccion</th>
		<th class="col-sm-2">Telefono</th>
		<th class="col-sm-2">Email</th>
		<th class="col-sm-2">Creado</th>
		<th class="col-sm-2">Modificado</th>
		<th class="col-sm-0">Eliminar</th>
	</thead>
	@foreach($sucursales as $sucursal)
	<tr>
		<td>{{$sucursal->nombre_sucursal}}</td>
		<td>{{$sucursal->direccion}}</td>
		<td>{{$sucursal->telefono}}</td>
		<td>{{$sucursal->email}}</td>
		<td>{{$sucursal->created_at}}</td>
		<td class="alert alert-warning">
			<a href="sucursales/{{$sucursal->id_sucursal}}/edit"
			class="btn btn-link">
			{{$sucursal->updated_at}}
			</a>
		</td>
		<td class="alert alert-danger">
			{{ Form::open(array('url'=>'sucursales/'.$sucursal->id_sucursal , 'method'=>'delete')) }}
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