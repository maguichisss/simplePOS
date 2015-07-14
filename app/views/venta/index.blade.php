@extends('venta.content')

@section('ventas')
{{ HTML::style('css/jquery-ui.min.css') }}
{{ Form::open(array('url'=>'ventas', 'id'=>'formVentas')) }}
<div class="row">
	<table id="tblCliente" class="col-sm-12">
		<tbody>
			<tr>
				<td class="col-sm-2">
					<span>Cliente: </span>
					<input type="text" class='noEnterSubmit form-control' placeholder="id|nombre" id="buscarCliente"/>
				</td>
				<td class="col-sm-3">
					<span>Nombre:</span>
					<input disabled type='text' class='form-control' value="Cliente de mostrador" id="datosCliente"/>
				</td>
				<td hidden>
					<span></span>
					<input type='text' class='form-control' id="idCliente" name="idCliente"/>
					<input type='text' id="tipoCliente"/>
				</td>
			</tr>
		</tbody>
	</table>
</div>
<br/>
<div class="row">
	<label>Cantidad:</label>
	<input type="text" id="cantidadProducto" pattern="\d+" class="noEnterSubmit" autocomplete="off" autofocus/>
	<label>Buscar producto:</label>
	<input type="text" id="buscarProducto" class="noEnterSubmit" autocomplete="off"/>
</div>
<div class="row" id="divTblVentaProductos" hidden>
<table id="tblVentaProductos" class="table table-striped table-hover table-condensed table-bordered">
	<thead>
	    <td class="col-sm-2" ><label>Codigo</label></td>
	    <td class="col-sm-3" ><label>Nombre</label></td>
	    <td class="col-sm-3 content setWidth" ><label>Descripcion</label></td>
	    <td class="col-sm-2" ><label>Categoria</label></td>
	    <td class="col-sm-*" ><label>Cantidad</label></td>
	    <td class="col-sm-*" ><label>$/Precio/U</label></td>
	    <td class="col-sm-*" ><label>$/Subtotal</label></td>
	    <td class='col-sm-*'>
			<span class=" glyphicon glyphicon-remove" aria-hidden="true"></span>
		</th>
	</thead>
	<tbody>
		<tr>
		    
		</tr>    
	</tbody>
</table>
</div>
<div class="row">
	<table id="tblTiposDePago">
		<tbody>
			<tr>
			<td class="col-sm-2">
				<h4>Tipo de pago</h4>
			</td>
			@foreach($tiposDePago as $id => $tipoDePago)
			<td class="col-sm-*">
				<span>{{$tipoDePago}}: </span>
				<input name="cantidadTipoPago[{{$id}}]"type='text' class='noEnterSubmit form-control tipoPago' id="{{$tipoDePago}}" autocomplete="off" pattern="\d+(\.\d{1,2})?" value="00.00"/>
			</td>
			@endforeach
			<td class="col-sm-5">
				<span>Detalles pago</span>
				<input type='text' class='noEnterSubmit form-control' name="detallesVenta" id="detallesVenta" autocomplete="off"/>
			</td>
			</tr>
			@foreach($reglas as $id => $regla)
			<tr hidden>
				<input id="regla{{$regla->id}}" type='text' class='noEnterSubmit regla' min="{{$regla->minimo}}" max="{{$regla->maximo}}" des="{{$regla->descuento}}" value="{{$regla->id}}" hidden/>
			</tr hidden>
			@endforeach
			@foreach($reglasFitness as $id => $reglaF)
			<tr hidden>
				<input id="regla{{$reglaF->id}}" type='text' class='noEnterSubmit reglaF' min="{{$reglaF->minimo}}" max="{{$reglaF->maximo}}" des="{{$reglaF->descuento}}" value="{{$reglaF->id}}" hidden/>
			</tr hidden>
			@endforeach
		</tbody>
	</table>
</div>
<br/>
<div class="row">
{{Form::submit('Realizar Venta', ['class' => 'btn btn-danger btn-lg col-sm-2'])}}
</div>
{{ Form::close() }}


@stop