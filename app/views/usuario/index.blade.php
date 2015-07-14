@extends('master.producto')

@section('contenido')
<h1>Productos</h1>
{{ $productos->links() }}
<table class="table table-striped table-hover table-condensed table-bordered">
	<thead>
		<td></td><td></td><td></td><td></td>
		<td>
			<a href="producto/create" class="btn btn-success btn-xs">Agregar</a>
		</td>
	</thead>
	<thead>
		<th >#</th>
		<th class='col-sm-9'>Producto</th>
		<th >Detalles</th>
		<th >Editar</th>
		<th >Eliminar</th>
	</thead>
	@foreach($productos as $producto)
	<tr>
		<td>{{$producto->id_producto}}</td>
		<td>{{$producto->nombre_producto}}</td>
		<td>
			<a href="producto/{{$producto->id_producto}}" 
			class="btn btn-info btn-xs">Detalles</a>
		</td>
		<td>
			<a href="producto/{{$producto->id_producto}}/edit"
			class="btn btn-warning btn-xs">Editar</a>
		</td>
		<td>
			{{ Form::open(array('url'=>'producto/'.$producto->id_producto , 'method'=>'delete')) }}
			{{Form::submit('Eliminar', ['class' => 'btn btn-danger btn-xs'])}}
			{{ Form::close() }}
		</td>
	</tr>
	@endforeach
</table>
{{ $productos->links() }}
{{--Si se guardo la sesion en algun metodo de ProductoController.php
	muestra el mensaje con los parametros enviados 		--}}
@if(Session::has('message'))
	<div class="alert alert-{{ Session::get('class')}}">
		{{ Session::get('message') }} 
	</div>
@endif

@stop