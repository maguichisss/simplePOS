@extends('producto.content')

@section('contenido')
<h1>Producto</h1>
{{ Form::open(array('url'=>'productos/'.$producto->id_producto, 
					'method'=>'put',
					'id'=>'formProducto')) }}
<table>
	<tr>
		<td>Codigo</td> 
		<td>{{Form::text('codigo', $producto->id_producto, $atributos=array(
				'required'=>'true',
				'pattern'=>'\d+',
				'autofocus'=>'true') )}}</td>
	</tr>
	<tr>
		<td>Producto</td> 
		<td>{{Form::text('productouuu', $producto->nombre_producto, $atributos=array('required'=>'true') )}}</td>
	</tr>
	<tr>
		<td>Categoria</td>
		<td>
		{{-- Traemos todas las categorias y las pasamos a la lista --}}

			{{Form::select('categoria', $categorias, $producto->id_categoria_de_producto, $atributos=array('required'=>'true'))}}
		</td>
	</tr>
	<tr>
		<td>Precio compra</td> 
		<td>{{Form::text('precioCompra',$producto->precio_compra, $atributos = array(
						'required'=>'true',
						'pattern'=>"\d+(\.\d{1,2})?") )}}</td>
	</tr>
	<tr>
		<td>Precio cliente frecuente</td> 
		<td>{{Form::text('precioCliente',$producto->precio_cliente_frecuente, $atributos = array(
						'required'=>'true',
						'title'=>'Precio Cliente Frecuente',
						'pattern'=>"\d+(\.\d{1,2})?") )}}</td>
	</tr>
	<tr>
		<td>Descripcion</td> 
		<td>{{Form::textArea('descripcionnn', $producto->descripcion, $atributos = 				array( 'rows'=>'5') )}}</td>
	</tr>
	<tr>
		<td>Fecha de actualizacion</td> 
		<td>{{Form::text('fechaActualizacion',$producto->updated_at, $atributos = array(  'disabled'=>'true' ) )}}</td>
	</tr>
	<tr>
		<td>Fecha de creacion</td> 
		<td>{{Form::text('fechaCreacion',$producto->created_at, $atributos = array(
						'disabled'=>'true' ) )}}</td>
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