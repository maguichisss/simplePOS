@extends('master.producto')

@section('contenido')
<h1>Nuevo Producto</h1>
{{ Form::open(array('url'=>'producto')) }}
<table  class="table table-hover table-condensed">
	<thead>
		<th class='col-sm-1'></th>
		<th class='col-sm-4'></th>
		<th class='col-sm-7'></th>
	</thead>
	<tr>
		<td>Producto</td> 
		<td>{{Form::text('productouuu','',['required'])}}</td>
	</tr>
	<tr>
		<td>Categoria</td>
		<td>
		{{-- Traemos todas las categorias y las pasamos a la lista --}}
			{{Form::select('categoria', $categorias, ['required'])}}
		</td>
	</tr>
	<tr>
		<td>Descripcion</td> 
		<td>{{Form::textArea('descripcionnn')}}</td>
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