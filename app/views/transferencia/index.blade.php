@extends('transferencia.content')


@section('nueva_transferencia')
	{{--Si se guardo la sesion en algun metodo de ProductoController.php
		muestra el mensaje con los parametros enviados 		--}}
	@if(Session::has('message'))
		<div class="alert alert-{{ Session::get('class')}}">
			{{ Session::get('message') }} 
		</div>
	@endif
	{{ Form::open(array('url'=>'transferencias', 'id'=>'formTransferencia')) }}
	<table class="table table-striped table-hover table-condensed">
		<thead>
			<th class="col-sm-2"></th>
			<th class="col-sm-2"></th>
			<th class="col-sm-6"></th>
			<th class="col-sm-2"></th>
			<th class="col-sm-1"></th>
		</thead>
		<tr>
			<td>
				<span>Origen </span>
				{{Form::select('sucursalOrigen', $origen ,null, $atributos=array(	'required' => 'true',
							'id'  => 'sucursalOrigen',
							'class' => 'form-control'))}}
			</td>
			<td>
				<span>Destino </span>
				{{Form::select('sucursalDestino',$sucursales,null, $atributos=array('required' => 'true', 
							'class' => 'form-control'))}}
			</td>		
			<td>
				<span>Producto </span>
				<input type="text" id="buscarProducto" class="form-control" autofocus/>
			</td>		
			<td>
				<span>Cantidad </span>
				<input type="text" id="inCantidad" name="cantidadSolicitada" class="form-control" pattern="\d+" required/>
			</td>		
			<td>
				<span>. </span>
				{{Form::submit('Transferir', ['class' => 'btn btn-danger'])}}
			</td>
		</tr>
		<tr>
			<td>
				<span>Codigo </span>
				<input type="text" name="idProducto" id="inCodigo" class="form-control" required/>
			</td>
			<td colspan="3">
				<span>Detalles del producto </span>
				<input type="text" id="inDetalles" class="form-control"/>
			</td>
			<td>
				<span>Disponible </span>
				<input type="text" name="cantidadDisponible" id="inDisponible" class="form-control"/>
			</td>
		</tr>
	</table>
	{{ Form::close() }}
@stop

@section('transferencias')

<table class="table table-striped table-hover table-condensed">
		<thead>
			<th class="col-sm-*">Id</th>
			<th class="col-sm-3">Empleado|Usuario</th>
			<th class="col-sm-2">Sucursal Origen</th>
			<th class="col-sm-2">Sucursal Destino</th>
			<th class="col-sm-2">Producto</th>
			<th class="col-sm-1">Cantidad</th>
			<th class="col-sm-2">Fecha</th>
		</thead>
		@foreach($transferencias as $transferencia)
		<tr>
			<td>
				{{$transferencia['id']}}
			</td>
			<td>
				{{$transferencia['empleado']}}
			</td>		
			<td>
				{{$transferencia['sucursalOrigen']}}
			</td>		
			<td>
				{{$transferencia['sucursalDestino']}}
			</td>		
			<td>
				{{$transferencia['idProducto']}}
			</td>
			<td>
				{{$transferencia['cantidad']}}
			</td>
			<td>
				{{$transferencia['fecha']}}
			</td>
		</tr>
		@endforeach
	</table>

@stop