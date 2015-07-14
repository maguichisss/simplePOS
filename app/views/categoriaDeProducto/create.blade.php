@extends('categoriaDeProducto.content')

@section('contenido')
<h1>Nueva Categoria</h1>
{{ Form::open(array('url'=>'categoriasDeProductos')) }}
<table  class="table table-hover table-condensed">
	<thead>
		<th class='col-sm-1'></th>
		<th class='col-sm-4'></th>
		<th class='col-sm-7'></th>
	</thead>
	<tr>
		<td>Categoria</td> 
		<td>{{Form::text('categoria','',['required'])}}</td>
	</tr>
	<tr>
		<td></td>
		<td>
			{{Form::submit('Guardar', ['class' => 'btn btn-danger'])}}
	{{-- route url hacia donde va a regresar--}}
			<a href="{{URL::route('categoriasDeProductos.index')}}" class="btn btn-success">
				Regresar
			</a>
		</td>
	</tr>
</table>
{{ Form::close() }}
@stop