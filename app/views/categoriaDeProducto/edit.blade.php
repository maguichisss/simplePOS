@extends('categoriaDeProducto.content')

@section('contenido')
<h1>Categoria</h1>
{{ Form::open(array('url'=>'categoriasDeProductos/'.$categoria->id_categoria_de_producto, 'method'=>'put')) }}
<table>
	<tr>
		<td>Categoria</td> 
		<td>{{Form::text('categoria', $categoria->categoria , ['required'])}}</td>
	</tr>
	<tr>
		<td>Categoria</td>
		<td>
		{{-- Traemos todas las categorias y las pasamos a la lista --}}
			{{Form::select('habilitado', 
							array( 	true => 'Habilitado', 
									false => 'Deshabilitado'),
							$categoria->habilitado)}}
		</td>
	</tr>
	<tr>
		<td></td> 
		<td>
			{{Form::submit('Guardar', ['class' => 'btn btn-danger'])}}
			<a href="{{URL::route('categoriasDeProductos.index')}}" class="btn btn-success">
				Regresar
			</a>
		</td>
	</tr>

</table>
{{ Form::close() }}
@stop