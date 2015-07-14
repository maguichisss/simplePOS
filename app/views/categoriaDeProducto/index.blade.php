@extends('categoriaDeProducto.content')

@section('contenido')

<h1>Categorias de productos</h1>
<table class="table table-striped table-hover table-condensed">
	<thead>
		<td></td><td></td><td></td>
		<td>
			<a href="categoriasDeProductos/create" class="btn btn-success btn-xs">
				Agregar
			</a>
		</td>
	</thead>
	<thead>
		<th class="col-sm-2">Categoria</th>
		<th class="col-sm-3">Creado</th>
		<th class="col-sm-3">Modificado</th>
		<th class="col-sm-0">Eliminar</th>
	</thead>
	@foreach($categorias as $categoria)
	<tr>
		<td>{{$categoria->categoria}}</td>
		<td>{{$categoria->created_at}}</td>
		<td class="alert alert-warning">
			<a href="categoriasDeProductos/{{$categoria->id_categoria_de_producto}}/edit"
			class="btn btn-link">
			{{$categoria->updated_at}}
			</a>
		</td>
		<td class="alert alert-danger">
			{{ Form::open(array('url'=>'categoriasDeProductos/'.$categoria->id_categoria_de_producto , 'method'=>'delete')) }}
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