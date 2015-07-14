@extends('producto.content')

@section('contenido')
<h1>Catalogo Productos</h1>
{{--Si se guardo la sesion en algun metodo de ProductoController.php
	muestra el mensaje con los parametros enviados 		--}}
@if(Session::has('message'))
	<div class="alert alert-{{ Session::get('class')}}">
		{{ Session::get('message') }} 
	</div>
@endif
<table class="table table-striped table-hover table-condensed sieve">
	<thead>
		<td colspan="7">
			
		</td>
		<td colspan="2">
		@if(Session::get('tipo') != 'VENDEDOR')
			<a href="productos/create" class="btn btn-success center-block">
				<span class="glyphicon glyphicon-plus" aria-hidden="true"></span>
			</a>
		@endif
		</td>
	</thead>
	<thead>
		<th class='col-sm-*'>#</th>
		<th class='col-sm-4'>Producto</th>
		<th class='col-sm-3'>Descripcion</th>
		<th class='col-sm-1'>Categoria</th>
		<th class='col-sm-1'>$/Compra</th>
		<th class='col-sm-1'>$/Frecuente</th>
		<th class='col-sm-2'>Fecha de Registro</th>
		@if(Session::get('tipo') != 'VENDEDOR')
		<th class='col-sm-*'>
			<span class="glyphicon glyphicon-pencil" aria-hidden="true"></span>
		</th>
		<th class='col-sm-*'>
			<span class=" glyphicon glyphicon-remove" aria-hidden="true"></span>
		</th>
		@endif
	</thead>
	@foreach($productos as $producto)
	<tr>
		<td>{{$producto->id_producto}}</td>
		<td>{{$producto->nombre_producto}}</td>
		<td class="concat setWidth">{{$producto->descripcion}}</td>
		<td>{{$producto->id_categoria_de_producto}}</td>
		<td>{{$producto->precio_compra}}</td>
		<td>{{$producto->precio_cliente_frecuente}}</td>
		<td class="concat setWidth">{{$producto->created_at}}</td>
		@if(Session::get('tipo') != 'VENDEDOR')
		<td >
			<a href="productos/{{$producto->id_producto}}/edit"
			class="btn btn-info btn-sm">
				<span class="glyphicon glyphicon-pencil" aria-hidden="true"></span>
			</a>
		</td>
		@endif

		<td>
		@if(Session::get('tipo') != 'VENDEDOR')
			{{ Form::open(array('url'=>'productos/'.$producto->id_producto , 'method'=>'delete')) }}
			
			<button type="submit" class="btn btn-danger btn-sm">
			  <span class="glyphicon glyphicon-remove" aria-hidden="true"></span>
			</button>
			{{ Form::close() }}
		</td>
		@endif
	</tr>
	@endforeach
</table>
@stop