@extends('devolucion.content')

@section('devoluciones')
{{ HTML::style('css/jquery-ui.min.css') }}
{{ Form::open(array('url'=>'devoluciones', 'id'=>'formDevoluciones')) }}
<div class="row">
	<table id="tblProductoDevuelto" class="col-sm-4">
		<tbody>
			<tr>
				<td><label>Producto devuelto: </label></td>
				<td>
					<input type="text" id="productoDevuelto" class="noEnterSubmit buscarProducto" autocomplete="off" autofocus/>
				</td>
			</tr>
			<tr><td>&nbsp;</td></tr>
			<tr>
				<td><label>Codigo: </label></td>
				<td>
					<input type="text" id="codigoD" class="noEnterSubmit" autocomplete="off" disabled/>
					<input type="text" id="idProductoDevuelto" name="idProductoDevuelto" class="noEnterSubmit" autocomplete="off" hidden/>
				</td>
			</tr>
		    <tr>
		    	<td><label>Nombre: </label></td>
		    	<td>
		    		<input type="text" id="nombreD" class="noEnterSubmit" autocomplete="off" disabled/>
		    	</td>
		    </tr>
		    <tr>
		    	<td><label>Descripcion: </label></td>
		    	<td>
		    		<input type="text" id="descripcionD" class="noEnterSubmit" autocomplete="off" disabled/>
		    	</td>
		    </tr>
		    <tr>
		    	<td><label>Precio: </label></td>
		    	<td>
		    		<input type="text" id="precioD" class="noEnterSubmit" autocomplete="off" disabled/>
		    	</td>
		    </tr>
		</tbody>
	</table>
	<table id="tblProductoCambio" class="col-sm-4">
		<tbody>
			<tr>
				<td><label>Producto cambio: </label></td>
				<td>
					<input type="text" id="productoCambio" class="noEnterSubmit buscarProducto" autocomplete="off" autofocus/>
				</td>
			</tr>
			<tr><td>&nbsp;</td></tr>
			<tr>
				<td><label>Codigo: </label></td>
				<td>
					<input type="text" id="codigoC" class="noEnterSubmit" autocomplete="off" disabled/>
					<input type="text" id="idProductoCambio" name="idProductoCambio" class="noEnterSubmit" autocomplete="off" hidden/>
				</td>
			</tr>
		    <tr>
		    	<td><label>Nombre: </label></td>
		    	<td>
		    		<input type="text" id="nombreC" class="noEnterSubmit" autocomplete="off" disabled/>
		    	</td>
		    </tr>
		    <tr>
		    	<td><label>Descripcion: </label></td>
		    	<td>
		    		<input type="text" id="descripcionC" class="noEnterSubmit" autocomplete="off" disabled/>
		    	</td>
		    </tr>
		    <tr>
		    	<td><label>Precio: </label></td>
		    	<td>
		    		<input type="text" id="precioC" class="noEnterSubmit" autocomplete="off" disabled/>
		    	</td>
		    </tr>
		</tbody>
	</table>
	<table class="col-sm-4">
		<tr>
			<td><label>Concepto: </label></td>
	    	<td>
	    		<input type="text" name="concepto" id="concepto" class="noEnterSubmit" autocomplete="off"/>
	    	</td>
		</tr>
		<tr><td>&nbsp;</td></tr>
		<tr>
			<td></td>
			<td>
				{{Form::submit('Realizar cambio', ['class' => 'btn btn-danger'])}}
			</td>
		</tr>
		<tr>
			<td></td>
			<td> <h2>Diferencia</h2> </td>
		</tr>
		<tr>
			<td></td>
			<td><h1 id="diferencia">00.00</h1></td>
		</tr>
	</table>
</div>
<br/>
{{ Form::close() }}


@stop