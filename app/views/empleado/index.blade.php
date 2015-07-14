@extends('empleado.content')

@section('datos_empleado')

<table class="table table-striped table-hover table-condensed">
	<thead>
		<td></td><td></td><td></td><td>
		</td><td></td><td></td><td></td><td></td>
		<td>
			<a href="empleados/create" class="btn btn-success ">
				Agregar
			</a>
		</td>
	</thead>
	<thead>
		<th class="col-sm-2">Nombre</th>
		<th class="col-sm-2">Apellido</th>
		<th class="col-sm-2">Sucursal</th>
		<th class="col-sm-2">Usuario</th>
		<th class="col-sm-2">Tipo de empleado</th>
		<th class="col-sm-0">Habilitado</th>
		<th class="col-sm-0">Creado</th>
		<th class="col-sm-0">Modificado</th>
		<th class="col-sm-0">Eliminar</th>
	</thead>
@foreach($empleados as $empleado)
@if(Session::get('tipo')=='ADMINISTRADOR')
	<tr>
		<td>{{$empleado->nombre}}</td>
		<td>{{$empleado->apellido_paterno}}</td>
		<td>{{$empleado->nombre_sucursal}}</td>
		<td>{{$empleado->username}}</td>
		<td>{{$empleado->tipo_de_empleado}}</td>		
		@if($empleado->habilitado==true)
			<td class="alert alert-success">
				{{ Form::open(array('url'=>'empleados/delete/'.$empleado->id_empleado , 'method'=>'post')) }}
				{{Form::submit('Habilitado', ['class' => 'btn btn-link'])}}
				{{ Form::close() }}
			</td>
		@else
			<td class="alert alert-danger">
				{{ Form::open(array('url'=>'empleados/habilitar/'.$empleado->id_empleado , 'method'=>'post')) }}
				{{Form::submit('Deshabilitado', ['class' => 'btn btn-link'])}}
				{{ Form::close() }}
			</td>
		@endif
		<td>{{$empleado->created_at}}</td>
		<td class="alert alert-warning">
			<a href="empleados/{{$empleado->id_empleado}}/edit"
			class="btn btn-link">
			{{$empleado->updated_at}}
			</a>
		</td>
		<td class="alert alert-danger">
			{{ Form::open(array('url'=>'empleados/'.$empleado->id_empleado , 'method'=>'delete')) }}
			{{Form::submit('Eliminar', ['class' => 'btn btn-link'])}}
			{{ Form::close() }}
		</td>
	</tr>
@elseif(Session::get('tipo')=='GERENTE GENERAL' && $empleado->tipo_de_empleado!='administrador')
	<tr>
		<td>{{$empleado->nombre}}</td>
		<td>{{$empleado->apellido_paterno}}</td>
		<td>{{$empleado->nombre_sucursal}}</td>
		<td>{{$empleado->username}}</td>
		<td>{{$empleado->tipo_de_empleado}}</td>		
		
		@if($empleado->habilitado==true)
			<td class="alert alert-success">
				{{ Form::open(array('url'=>'empleados/delete/'.$empleado->id_empleado , 'method'=>'post')) }}
				{{Form::submit('Habilitado', ['class' => 'btn btn-link'])}}
				{{ Form::close() }}
			</td>
		@else
			<td class="alert alert-danger">
				{{ Form::open(array('url'=>'empleados/habilitar/'.$empleado->id_empleado , 'method'=>'post')) }}
				{{Form::submit('Deshabilitado', ['class' => 'btn btn-link'])}}
				{{ Form::close() }}
			</td>
		@endif


		<td>{{$empleado->created_at}}</td>
		<td class="alert alert-warning">
			<a href="empleados/{{$empleado->id_empleado}}/edit"
			class="btn btn-link">
			{{$empleado->updated_at}}
			</a>
		</td>
		<td class="alert alert-danger">
			{{ Form::open(array('url'=>'empleados/'.$empleado->id_empleado , 'method'=>'delete')) }}
			{{Form::submit('Eliminar', ['class' => 'btn btn-link'])}}
			{{ Form::close() }}
		</td>
	</tr>
@elseif(Session::get('tipo')=='GERENTE DE SUCURSAL' && $empleado->tipo_de_empleado!='administrador' && $empleado->tipo_de_empleado!='gerente general')
	<tr>
		<td>{{$empleado->nombre}}</td>
		<td>{{$empleado->apellido_paterno}}</td>
		<td>{{$empleado->nombre_sucursal}}</td>
		<td>{{$empleado->username}}</td>
		<td>{{$empleado->tipo_de_empleado}}</td>		
		@if($empleado->habilitado==true)
			<td class="alert alert-success">
				{{ Form::open(array('url'=>'empleados/delete/'.$empleado->id_empleado , 'method'=>'post')) }}
				{{Form::submit('Habilitado', ['class' => 'btn btn-link'])}}
				{{ Form::close() }}
			</td>
		@else
			<td class="alert alert-danger">
				{{ Form::open(array('url'=>'empleados/habilitar/'.$empleado->id_empleado , 'method'=>'post')) }}
				{{Form::submit('Deshabilitado', ['class' => 'btn btn-link'])}}
				{{ Form::close() }}
			</td>
		@endif
		<td>{{$empleado->created_at}}</td>
		<td class="alert alert-warning">
			<a href="empleados/{{$empleado->id_empleado}}/edit"
			class="btn btn-link">
			{{$empleado->updated_at}}
			</a>
		</td>
		<td class="alert alert-danger">
			{{ Form::open(array('url'=>'empleados/'.$empleado->id_empleado , 'method'=>'delete')) }}
			{{Form::submit('Eliminar', ['class' => 'btn btn-link'])}}
			{{ Form::close() }}
		</td>
	</tr>
@endif
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