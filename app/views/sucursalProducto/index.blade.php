@extends('sucursalProducto.content')

@section('sucursalProducto')
{{ HTML::style('css/jquery-ui.min.css') }}

	<div class="col-sm-1" style="float:right;">
	@if(Session::get('tipo') != 'VENDEDOR')
		<h1>
		<a href="sucursalesProductos/create" class="btn btn-success center-block">
		<span class="glyphicon glyphicon-plus" aria-hidden="true"></span>
		</a>
		</h1>
	@endif
	</div>
<table id="tblNuevosProductos" class="table table-striped table-hover table-condensed sieve"  >
	<thead><th></th>
	</thead>
	<thead>
		@if(Session::get('tipo') == 'ADMINISTRADOR' || 
			Session::get('tipo') == 'GERENTE GENERAL' )
			<th class="col-sm-*" ><label>Sucursal</label></th>
		@endif
	    <th class="col-sm-*" ><label>Codigo</label></th>
	    <th class="col-sm-4" ><label>Nombre</label></th>
	    <th class="col-sm-3" ><label>Descripcion</label></th>
	    <th class="col-sm-*" ><label>Categoria</label></th>
	    <th class="col-sm-*" ><label>Cantidad</label></th>
	    <th class="col-sm-*" ><label>Stock</label></th>
	    <th class="col-sm-1" ><label>Precio  al Publico</label></th>
	    <th class="col-sm-1" ><label>Precio  cliente Frecuente</label></th>
	    <th class="col-sm-1" ><label>Precio Distribuidor</label></th>
	    <th class="col-sm-1" ><label>Precio Mayorista 1</label></th>
	    <th class="col-sm-1" ><label>Precio Mayorista 2</label></th>
	    <th class="col-sm-1" ><label>Precio Mayorista 3</label></th>
	    @if(Session::get('tipo') != 'VENDEDOR')
		    <th class='col-sm-*'>
				<span class="glyphicon glyphicon-pencil" aria-hidden="true"></span>
			</th>
		@endif
	</thead>
	<tbody>
		@foreach($productos as $producto)
		<tr>
			@if(Session::get('tipo') == 'ADMINISTRADOR' || 
				Session::get('tipo') == 'GERENTE GENERAL' )
				<td>{{$producto->nombre_sucursal}}</td>
			@endif
			<td>{{$producto->id_producto}}</td>
			<td>{{$producto->nombre_producto}}</td>
			<td class="concat setWidth">{{$producto->descripcion}}</td>
			<td>{{$producto->categoria}}</td>
			<td>{{$producto->cantidad}}</td>		
			<td>{{$producto->stock}}</td>
			@if($producto->categoria == 'Fitness')
				<td>{{number_format($producto->precio_cliente_frecuente * $reglas[7]->descuento, 2)}}</td>
				<td>{{number_format($producto->precio_cliente_frecuente * $reglas[6]->descuento, 2)}}</td>
				<td>{{number_format($producto->precio_cliente_frecuente * $reglas[8]->descuento, 2)}}</td>
				<td>{{number_format($producto->precio_cliente_frecuente * $reglas[9]->descuento, 2)}}</td>
				<td>{{number_format($producto->precio_cliente_frecuente * $reglas[10]->descuento, 2)}}</td>
				<td>{{number_format($producto->precio_cliente_frecuente * $reglas[11]->descuento, 2)}}</td>
			@else
				<td>{{number_format($producto->precio_cliente_frecuente * $reglas[1]->descuento, 2)}}</td>		
				<td>{{number_format($producto->precio_cliente_frecuente * $reglas[0]->descuento, 2)}}</td>		
				<td>{{number_format($producto->precio_cliente_frecuente * $reglas[2]->descuento, 2)}}</td>		
				<td>{{number_format($producto->precio_cliente_frecuente * $reglas[3]->descuento, 2)}}</td>		
				<td>{{number_format($producto->precio_cliente_frecuente * $reglas[4]->descuento, 2)}}</td>		
				<td>{{number_format($producto->precio_cliente_frecuente * $reglas[5]->descuento, 2)}}</td>		
			@endif
			@if(Session::get('tipo') != 'VENDEDOR')
				<td>
					<a href="sucursalesProductos/{{$producto->id_sucursal.$producto->id_producto}}/edit" class="btn btn-info btn-sm">
						<span class="glyphicon glyphicon-pencil" aria-hidden="true"></span>
					</a>
				</td>
			@endif
		</tr>
		@endforeach   
	</tbody>
</table>
@stop