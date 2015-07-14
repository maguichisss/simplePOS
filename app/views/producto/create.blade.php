@extends('producto.content')

@section('contenido')
<h1>Nuevo Producto</h1>
{{ Form::open(array('url'=>'productos')) }}
<table  class="table table-hover table-condensed">
	<thead>
		<th class='col-sm-3'></th>
		<th class='col-sm-4'></th>
		<th class='col-sm-5'></th>
	</thead>
	<tr>
		<td>
			<span class='requerido'>*</span>
			Codigo
		</td> 
		<td>{{Form::text('codigo','',$atributos=array(
				'required'=>'true',
				'pattern'=>'\d+',
				'autofocus'=>'true'))}}</td>
	</tr>
	<tr>
		<td>
			<span class='requerido'>*</span>
			Producto
		</td> 
		<td>{{Form::text('productouuu','', $atributos = array(
						'required'=>'true' ) )}}</td>
	</tr>
	<tr>
		<td>
			<span class='requerido'>*</span>
			Categoria
		</td>
		<td>
		{{-- Traemos todas las categorias y las pasamos a la lista --}}
			{{Form::select('categoria', $categorias, ['required'])}}
		</td>
	</tr>
	<tr>
		<td>
			<span class='requerido'>*</span>
			Precio compra
		</td> 
		<td>{{Form::text('precioCompra','', $atributos = array(
						'required'=>'true',
						'pattern'=>"\d+(\.\d{1,2})?") )}}</td>
	</tr>
	<tr>
		<td>
			<span class='requerido'>*</span>
			Precio cliente frecuente
		</td> 
		<td>{{Form::text('precioCliente','', $atributos = array(
						'required'=>'true',
						'title'=>'Precio Cliente Frecuente',
						'pattern'=>"\d+(\.\d{1,2})?") )}}</td>
	</tr>
	<tr>
		<td>Descripcion</td> 
		<td>{{Form::textArea('descripcionnn','', $atributos = array(
						'rows'=>'5') )}}</td>
	</tr>
	<tr>
		<td></td>
		<td>
			{{Form::submit('Guardar', ['class' => 'btn btn-danger'])}}
			<a href="{{URL::route('productos.index')}}" class="btn btn-success">
				Regresar
			</a>
		</td>
	</tr>
</table>
{{ Form::close() }}
@stop