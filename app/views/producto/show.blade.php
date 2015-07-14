@extends('producto.content')

@section('contenido')
<h1>Producto: {{$producto->nombre_producto}}</h1>
<table class="table table-striped table-hover table-condensed">
	<tr>
		<th class='col-sm-1'>Id</th>
		<th class='col-sm-5'>Detalles</th>
		<th class='col-sm-1'>Categoria</th>
		<th class='col-sm-1'>Estado</th>
		<th class='col-sm-2'>Creado</th>
		<th class='col-sm-2'>Modificado</th>
	</tr>
	<tr>
		<td>{{$producto->id_producto}}</td>
		<td><h2>{{$producto->descripcion}}</h2></td>
		<td>{{$categoria}}</td>
		@if($producto->habilitado)
		<td>Habilitado</td>
		@else
		<td>Deshabilitado</td>
		@endif
		<td>{{$producto->created_at}}</td>
		<td>{{$producto->updated_at}}</td>
	</tr>
</table>
<a href="{{URL::route('productos.index')}}" class="btn btn-success">Regresar</a>
@stop