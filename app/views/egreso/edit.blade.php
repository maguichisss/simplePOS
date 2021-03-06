@extends('cliente.content')

@section('subtitulos')
	<div class="col-sm-6">
		<h4>Modificar datos personales</h4>
	</div>
	<div class="col-sm-6">
		<h4>{{$cliente->id_cliente}}Usuario y sucursal</h4>
	</div>
@stop

@section('datos_cliente')
{{ Form::open(array('url'=>'clientes/'.$cliente->id_cliente, 'method'=>'put')) }}
<div class="row">
<div class="col-sm-6">
<table  class="table table-hover table-condensed">
	<thead>
		<th class='col-sm-2'></th>
		<th class='col-sm-4'></th>
	</thead>
	<tr>
		<td>Nombre</td> 
		<td>{{Form::text('nombre',$cliente->nombre, $atributos = 
			array(	'required' => 'true', 
					'autofocus' => 'true', 
					'style' => 'width:100%', 
					'placeholder' => 'Nombre', 
					'maxlength' => '50'		))}}</td>
	</tr>
	<tr>
		<td>Apellido Paterno</td> 
		<td>{{Form::text('apellidoP',$cliente->apellido_paterno, $atributos = 
			array(	'required' => 'required', 
					'style' => 'width:100%', 
					'placeholder' => 'Apellido Paterno', 
					'maxlength' => '30'		))}}</td>
	</tr>
	<tr>
		<td>Apellido Materno</td> 
		<td>{{Form::text('apellidoM',$cliente->apellido_materno, $atributos = 
			array(	'placeholder' => 'Apellido Materno', 
					'style' => 'width:100%', 
					'maxlength' => '30'		))}}</td>
	</tr>
	<tr>
		<td>Fecha de nacimiento</td> 
		<td>{{Form::input('date','nacimiento', $cliente->fecha_nacimiento, $atributos = 
			array(	'required' => 'required',  
					'placeholder' => 'aaaa-mm-dd', 
					'maxlength' => '10'		))}}</td>
	</tr>
	<tr>
		<td>Genero</td> 
		<td>
			Masculino
			{{Form::radio('genero',0, ($cliente->genero == 0) ? 1 : 0, $atributos = 
				array(	'required' => 'required' ))}}
			Femenino
			{{Form::radio('genero',1, ($cliente->genero == 1) ? 1 : 0, $atributos = 
				array(	'required' => 'required' ))}}
		</td>
	</tr>
	<tr>
		<td>Calle</td> 
		<td>{{Form::text('calle',$cliente->calle, $atributos = 
			array(	'placeholder' => '', 
					'style' => 'width:100%', 
					'maxlength' => '50'		))}}</td>
	</tr>
	<tr>
		<td>Colonia</td> 
		<td>{{Form::text('colonia',$cliente->colonia, $atributos = 
			array(	'placeholder' => '', 
					'style' => 'width:100%', 
					'maxlength' => '50'		))}}</td>
	</tr>
	<tr>
		<td>Delegacion/Municipio</td> 
		<td>{{Form::text('delegacion',$cliente->delegacion, $atributos = 
			array(	'placeholder' => '', 
					'style' => 'width:100%', 
					'maxlength' => '50'		))}}</td>
	</tr>
	<tr>
		<td>Estado</td> 
		<td>{{Form::text('estado',$cliente->estado, $atributos = 
			array(	'placeholder' => '', 
					'style' => 'width:100%', 
					'maxlength' => '50'		))}}</td>
	</tr>
	<tr><td></td><td></td></tr>
</table>
</div>
<div class="col-sm-6">
<table  class="table table-hover table-condensed">
	<thead>
		<th class='col-sm-2'></th>
		<th class='col-sm-4'></th>
	</thead>
	<tr>
		<td>Codigo Postal</td> 
		<td>{{Form::text('cp',$cliente->cp, $atributos = 
			array(	'placeholder' => '', 
					'maxlength' => '50'		))}}</td>
	</tr>
	<tr>
		<td>RFC</td> 
		<td>{{Form::text('rfc',$cliente->rfc, $atributos = 
			array(	'placeholder' => 'abcd123456123', 
					'maxlength' => '13'		))}}</td>
	</tr>
	<tr>
		<td>Telefono</td> 
		<td>{{Form::number('telefono',$cliente->telefono, $atributos = 
			array(	'placeholder' => '1122334455', 
					'maxlength' => '10'		))}}</td>
	</tr>
	<tr>
		<td>Email</td> 
		<td>{{Form::email('email',$cliente->email, $atributos = 
			array(	'placeholder' => 'hola@ejemplo.com', 
					'style' => 'width:100%', 
					'maxlength' => '45'		))}}</td>
	</tr>
	<tr>
		<td>Tipo de cliente</td> 
		<td>
			{{-- Traemos todas las sucursales --}}
			{{Form::select('tipo', $tiposDeClientes, $cliente->id_tipo_de_cliente)}}
		</td>
	</tr>
	<tr>
		<td></td>
		<td>
			{{Form::submit('Guardar', ['class' => 'btn btn-danger'])}}
	{{-- route URL hacia donde va a regresar--}}
			<a href="{{URL::route('clientes.index')}}" class="btn btn-success">
				Regresar
			</a>
		</td>
	</tr>
</table>
</div>
</div>
{{ Form::close() }}
@stop
