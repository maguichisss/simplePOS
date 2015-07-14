@extends('master.producto')

@section('contenido')
<h1>Producto</h1>
{{ Form::open(array('url'=>'producto/'.$producto->id_producto, 'method'=>'put')) }}
<table>
	<tr>
		<td>Producto</td> 
		<td>{{Form::text('productouuu', $producto->nombre_producto )}}</td>
	</tr>
	<tr>
		<td>Categoria</td>
		<td>
		{{-- Traemos todas las categorias y las pasamos a la lista --}}
			{{Form::select('categoria', $categorias)}}
		</td>
	</tr>
	<tr>
		<td>Descripcion</td> 
		<td>{{Form::textArea('descripcionnn', $producto->descripcion )}}</td>
	</tr>
	<tr>
		<td></td> 
		<td>
			{{Form::submit('Guardar', ['class' => 'btn btn-danger'])}}
			<a href="{{URL::route('producto.index')}}" class="btn btn-success">
				Regresar
			</a>
		</td>
	</tr>

</table>
{{ Form::close() }}
@stop