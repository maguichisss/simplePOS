@extends('compra.content')

@section('compras')
{{ HTML::style('css/jquery-ui.min.css') }}
{{ Form::open(array('url'=>'compras', 'id'=>'formCompras')) }}
<div class="row">
	<div class="col-sm-4">
		<table>
			<tr>
				<td><label>Fecha: </label></td>
				<td><input type="date" name="fechaCompra" required pattern="(?:19|20)[0-9]{2}-(?:(?:0[1-9]|1[0-2])-(?:0[1-9]|1[0-9]|2[0-9])|(?:(?!02)(?:0[1-9]|1[0-2])-(?:30))|(?:(?:0[13578]|1[02])-31))" placeholder="aaaa-mm-dd" value="{{date('Y-m-d')}}"/></td>
			</tr>
			<tr>
				<td><label>No. de factura: </label></td>
				<td><input type="text" name="facturaCompra" pattern="\d+" autocomplete="off"/></td>
			</tr>
		
			<tr>
		
				<td><label>Total: </label></td>
				<td><input type="text" name="totalCompra" pattern="\d+(\.\d{2})?" autocomplete="off"/></td>
			</tr>

		</table>
	</div>
		<div class="col-sm-6">
		<label>Detalles:</label>
		<textarea rows="3" cols="50" name="detallesCompra" maxlength="150"> </textarea>
	</div>
</div>
<div class="row">
	<div class="col-sm-3">
	<table id="tblProveedor">
		<thead></thead>
		<tbody>
			<tr>
				<td class="col-sm-*">
					<span>Proveedor: </span>
					{{Form::select('cmbProveedores', $proveedores,null, array( 'required' => 'true', 'class' => 'form-control', 'id' => 'cmbProveedores'))}}
				</td>
				<!--
				<td class="col-sm-*">
					<span>Direccion: </span>
					<input type='text' class='form-control' id="direccionProveedor" disabled/>
				</td>
				<td class="col-sm-*">
					<span>Telefono: </span>
					<input type='text' class='form-control' id="telefonoProveedor" disabled/>
				</td>
				<td class="col-sm-*">
					<span>Email:</span>
					<input type='text' class='form-control' id="emailProveedor" disabled/>
				</td>
				<td hidden>
					<span></span>
					<input type='text' class='form-control' id="idProveedor" readonly/>
				</td>
				-->
			</tr>
		</tbody>
	</table>
	</div>
	<div class="col-sm-6">
	<table id="tblTiposDePago">
		<thead></thead>
		<tbody>
			<tr>
			@foreach($tiposDePago as $id => $tipoDePago)
				<td class="col-sm-*">
					<span>{{$tipoDePago}}: </span>
					<input name="cantidadTipoPago[{{$id}}]"type='text' class='form-control' pattern="\d+(\.\d{2})?"/>
				</td>
			@endforeach
			</tr>
		</tbody>
	</table>
	</div>
</div>
<br/>
<div class="row">
	<label>Buscar producto:</label>
	<input type="text" id="buscarProducto" autofocus/>
</div>
<div class="row" id="divTblCompraProductos" hidden>
<table id="tblCompraProductos" class="table table-striped table-hover table-condensed table-bordered">
	<thead>
	    <td class="col-sm-2" ><label>Codigo</label></td>
	    <td class="col-sm-2" ><label>Nombre</label></td>
	    <td class="col-sm-2" ><label>Descripcion</label></td>
	    <td class="col-sm-2" ><label>Categoria</label></td>
	    <td class="col-sm-1" ><label>Cantidad</label></td>
	    <td class="col-sm-1" ><label>Stock</label></td>
	    <td class="col-sm-1" ><label>Precio compra</label></td>
	    <td class="col-sm-1" ><label>Caducidad</label></td>
	    <td></td>
	</thead>
	<tbody>
		<tr>
		    
		</tr>    
	</tbody>
</table>
</div>
<br/>
<div class="row">
{{Form::submit('Comprar', ['class' => 'btn btn-danger'])}}
<a href="{{URL::route('compras.index')}}" class="btn btn-success">
	Regresar
</a>
<!--
<a href="#" id="btnNuevoProducto" class="btn btn-info">
	Nuevo Producto
</a>
-->
</div>
<div class="row" id="divTblNuevosProductos" hidden>
<h3>Nuevo producto</h3>
<table id="tblNuevosProductos" class="table table-striped table-hover table-condensed table-bordered"  >
	<thead>
	    <td class="col-sm-2" ><label>Codigo</label></td>
	    <td class="col-sm-2" ><label>Nombre</label></td>
	    <td class="col-sm-2" ><label>Descripcion</label></td>
	    <td class="col-sm-2" ><label>Categoria</label></td>
	    <td class="col-sm-1" ><label>Cantidad</label></td>
	    <td class="col-sm-1" ><label>Stock</label></td>
	    <td class="col-sm-1" ><label>Precio compra</label></td>
	    <td class="col-sm-1" ><label>Precio venta</label></td>
	    <td class="col-sm-1" ><label>Caducidad</label></td>
	    <td class="col-sm-*"></td>
	</thead>
	<tbody>
		<tr>
		    
		</tr>    
	</tbody>
</table>
</div>
{{ Form::close() }}


@stop