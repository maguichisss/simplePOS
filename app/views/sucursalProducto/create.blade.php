@extends('sucursalProducto.content')

@section('sucursalProducto')
{{ HTML::style('css/jquery-ui.min.css') }}
{{ Form::open(array('url'=>'sucursalesProductos', 
					'id'=>'formNuevos',
					'onkeypress'=>'return event.keyCode != 13;')) }}
<a href="#" id="btnNuevoProducto" class="btn btn-info" autofocus>
	Nuevo Producto
</a>
<a href="{{URL::route('sucursalesProductos.index')}}" class="btn btn-success">
	Regresar
</a>
<br/><br/>
<div class="row" id="divTblNuevosProductos">
<table id="tblNuevosProductos" class="table table-striped table-hover table-condensed table-bordered"  >
	<thead>
	    <th class="col-sm-2" ><label>Codigo</label></th>
	    <th class="col-sm-2" ><label>Nombre</label></th>
	    <th class="col-sm-3" ><label>Descripcion</label></th>
	    <th class="col-sm-2" ><label>Categoria</label></th>
	    <th class="col-sm-1" ><label>Stock</label></th>
	    <th class="col-sm-1" ><label>Precio compra</label></th>
	    <th class="col-sm-1" ><label>Precio venta</label></th>
	    <th class='col-sm-*'>
			<span class=" glyphicon glyphicon-remove" aria-hidden="true"></span>
		</th>
	</thead>
	<tbody>
		<td>
			<input autofocus required type='text' class='form-control' name='codigoN[]' pattern='\d+'/>
		</td>
		<td>
			<input required type='text' class='form-control' name='productoN[]'/>
		</td>
		<td>
			<input required type='text' class='form-control' name='descripcionN[]'/>
		</td>
		<td>
			{{Form::select('categoriaN[]', $categorias, '', $atributos=array(
						'required'=>'true',
						'class' => 'form-control'))}}
		</td>
		<td>
			<input required type='text' class='form-control' name='stockN[]' pattern='\d+'/>
		</td>
		<td>
			<input required type='text' class='form-control' name='precioCompraN[]' pattern="\d+(\.\d{1,2})?"/>
		</td>
		<td>
			<input required type='text' class='enterVenta form-control' name='precioVentaN[]' pattern="\d+(\.\d{1,2})?"/>
		</td>
		<td>
			<span class='btnBorrarNuevo glyphicon glyphicon-remove'></span>
		</td>
	</tbody>
</table>
</div>
{{Form::submit('Registrar Productos', ['class' => 'btn btn-danger'])}}
{{ Form::close() }}


@stop