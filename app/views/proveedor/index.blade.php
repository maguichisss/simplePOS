@extends('proveedor.content')

@section('contenido')

<table class="table table-striped table-hover table-condensed">
	<thead>
		<td></td><td></td><td></td><td></td><td></td><td></td><td></td><td></td>
		<td>
			<a href="proveedores/create" class="btn btn-success ">
				Agregar
			</a>
		</td>
	</thead>
	<thead>
		<th >Proveedor</th>
		<th >Direccion</th>
		<th >RFC</th>
		<th >Telefono</th>
		<th >Email</th>
		<th >Pagina web</th>
		<th >Creado</th>
		<th >Modificado</th>
		<th >Eliminar</th>
	</thead>
	@foreach($proveedores as $proveedor)
	<tr>
		<td>{{$proveedor->nombre}}</td>
		<td>{{$proveedor->direccion}}</td>
		<td>{{$proveedor->rfc}}</td>
		<td>{{$proveedor->telefono}}</td>
		<td>{{$proveedor->email}}</td>
		<td>{{$proveedor->pagina_web}}</td>		
		<td>{{$proveedor->created_at}}</td>
		<td class="alert alert-warning">
			<a href="proveedores/{{$proveedor->id_proveedor}}/edit"
			class="">
			{{$proveedor->updated_at}}
			</a>
		</td>
		<td class="alert alert-danger">
			{{ Form::open(array('url'=>'proveedores/'.$proveedor->id_proveedor , 'method'=>'delete')) }}
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