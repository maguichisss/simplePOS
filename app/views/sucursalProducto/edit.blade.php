@extends('sucursalProducto.content')

@section('sucursalProducto')
{{ HTML::style('css/jquery-ui.min.css') }}
{{ Form::open(array('url'=>'sucursalesProductos/'.$producto->id_sucursal.$producto->id_producto, 
					'method'=>'put',
					'id' => 'formUpdate')) }}
<br/><br/>
<div class="row">
<table class="table table-striped table-hover table-condensed"  >
	<thead>
		<th class="col-sm-1"></th>
		<th class="col-sm-4"></th>
	</thead>
	<tbody>
		<tr>
			<td><label>Codigo: </label></td>
			<td>
				<input disabled type='text' value='{{$producto->id_sucursal.$producto->id_producto}}' />
			</td>
		</tr>
		<tr>
			<td><label>Producto: </label></td>
			<td>
				<input disabled type='text' value='{{$producto->nombre_producto}}'/>
			</td>
		</tr>
		<tr>
			<td><label>Descripcion: </label></td>
			<td>
				<input disabled type='text'  value='{{$producto->descripcion}}'/>
			</td>
		</tr>
		<tr>
			<td><label>Categoria: </label></td>
			<td>
				<input disabled type='text' value='{{$producto->categoria}}'/>
			</td>
		</tr>
		<tr>
			<td><label>Cantidad: </label></td>
			<td>
				<input autofocus disabled type='text' name='cantidad' pattern='\d+' value="{{$producto->cantidad}}"/>
			</td>
		</tr>
		<tr>
			<td><label>Stock: </label></td>
			<td>
				<input required type='text' name='stock' pattern='\d+' value="{{$producto->stock}}"/>
			</td>
		</tr>
		<tr>
			<td><label>Precio compra: </label></td>
			<td>
				<input disabled type='text' name='precioCompra' pattern="\d+(\.\d{1,2})?" value="{{$producto->precio_compra}}"/>
			</td>
		</tr>
		<tr>
			<td><label>Precio venta: </label></td>
			<td>
				<input disabled type='text'  name='precioVenta' pattern="\d+(\.\d{1,2})?" value="{{$producto->precio_cliente_frecuente}}"/>
			</td>
		</tr>	
	</tbody>
</table>
</div>
{{Form::submit('Actualizar Producto', ['class' => 'btn btn-danger'])}}
<a href="{{URL::route('sucursalesProductos.index')}}" class="btn btn-success">
	Regresar
</a>
{{ Form::close() }}


@stop