@extends('master.producto')

@section('contenido')
<h1>Producto: {{$producto->producto}}</h1>
<table class="table table-striped table-hover table-condensed">
	<tr>
		<th>Id</th>
		<th>Detalles</th>
		<th>Estado</th>
		<th>Creado</th>
		<th>Modificado</th>
	</tr>
	<tr>
		<td>{{$producto->id_producto}}</td>
		<td><h2>{{$producto->descripcion}}</h2></td>
		<td><h2>{{$categoria}}</h2></td>
		@if($producto->habilitado)
		<td>Habilitado</td>
		@else
		<td>Deshabilitado</td>
		@endif
		<td>{{$producto->created_at}}</td>
		<td>{{$producto->updated_at}}</td>
	</tr>
</table>
<a href="{{URL::route('producto.index')}}" class="btn btn-success">Regresar</a>
@stop