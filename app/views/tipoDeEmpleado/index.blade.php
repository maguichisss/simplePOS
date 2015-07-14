@extends('tipoDeEmpleado.content')

@section('contenido')

<table class="table table-striped table-hover table-condensed">
	<thead>
		<td></td><td></td><td></td><td></td>
		<td>
			<a href="tiposDeEmpleados/create" class="btn btn-success">
				Agregar
			</a>
		</td>
	</thead>
	<thead>
		<th class="col-sm-2">Tipo</th>
		<th class="col-sm-3">Descripcion</th>
		<th class="col-sm-2">Creado</th>
		<th class="col-sm-2">Modificado</th>
		<th class="col-sm-0">Eliminar</th>
	</thead>
	@foreach($tiposDeEmpleados as $tipoDeEmpleado)
	<tr>
		<td>{{$tipoDeEmpleado->tipo_de_empleado}}</td>
		<td>{{$tipoDeEmpleado->descripcion}}</td>
		<td>{{$tipoDeEmpleado->created_at}}</td>
		<td class="alert alert-warning">
			<a href="tiposDeEmpleados/{{$tipoDeEmpleado->id_tipo_de_empleado}}/edit"
			class="btn btn-link">
			{{$tipoDeEmpleado->updated_at}}
			</a>
		</td>
		<td class="alert alert-danger">
			{{ Form::open(array('url'=>'tiposDeEmpleados/'.$tipoDeEmpleado->id_tipo_de_empleado , 'method'=>'delete')) }}
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