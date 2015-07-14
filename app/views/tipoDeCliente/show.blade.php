@extends('xxx.content')

@section('contenido')
<h1>xxx: {{$->}}</h1>
<table class="table table-striped table-hover table-condensed">
	<tr>
		<th>Id</th>
		<th>Detalles</th>
		<th>Estado</th>
		<th>Creado</th>
		<th>Modificado</th>
	</tr>
	<tr>
		<td>{{$->id_}}</td>
		<td><h2>{{$->descripcion}}</h2></td>
		<td><h2>{{$categoria}}</h2></td>
		@if($->habilitado)
		<td>Habilitado</td>
		@else
		<td>Deshabilitado</td>
		@endif
		<td>{{$->created_at}}</td>
		<td>{{$->updated_at}}</td>
	</tr>
</table>
<a href="{{URL::route('xxx.index')}}" class="btn btn-success">Regresar</a>
@stop