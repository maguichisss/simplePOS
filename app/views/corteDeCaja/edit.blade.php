@extends('empleado.content')

@section('subtitulos')
	<div class="col-sm-6">
		<h4>Modificar datos personales</h4>
	</div>
	<div class="col-sm-6">
		<h4>{{$empleado[0]->id_empleado}}Usuario y sucursal</h4>
	</div>
@stop

@section('datos_empleado')
{{ Form::open(array('url'=>'empleados/'.$empleado[0]->id_empleado, 'method'=>'put')) }}
<div class="row">
<div class="col-sm-6">
<table  class="table table-hover table-condensed">
	<thead>
		<th class='col-sm-2'></th>
		<th class='col-sm-4'></th>
	</thead>
	<tr>
		<td>Nombre</td> 
		<td>{{Form::text('nombre',$empleado[0]->nombre, $atributos = 
			array(	'required' => 'true', 
					'autofocus' => 'true', 
					'style' => 'width:100%', 
					'placeholder' => 'Nombre', 
					'maxlength' => '50'		))}}</td>
	</tr>
	<tr>
		<td>Apellido Paterno</td> 
		<td>{{Form::text('apellidoP',$empleado[0]->apellido_paterno, $atributos = 
			array(	'required' => 'required', 
					'style' => 'width:100%', 
					'placeholder' => 'Apellido Paterno', 
					'maxlength' => '30'		))}}</td>
	</tr>
	<tr>
		<td>Apellido Materno</td> 
		<td>{{Form::text('apellidoM',$empleado[0]->apellido_materno, $atributos = 
			array(	'placeholder' => 'Apellido Materno', 
					'style' => 'width:100%', 
					'maxlength' => '30'		))}}</td>
	</tr>
	<tr>
		<td>Fecha de nacimiento</td> 
		<td>{{Form::input('date','nacimiento', $empleado[0]->fecha_nacimiento, $atributos = 
			array(	'required' => 'required',  
					'placeholder' => 'aaaa-mm-dd', 
					'maxlength' => '10'		))}}</td>
	</tr>
	<tr>
		<td>Genero</td> 
		<td>
			Masculino
			{{Form::radio('genero',0, ($empleado[0]->genero == 0) ? 1 : 0, $atributos = 
				array(	'required' => 'required' ))}}
			Femenino
			{{Form::radio('genero',1, ($empleado[0]->genero == 1) ? 1 : 0, $atributos = 
				array(	'required' => 'required' ))}}
		</td>
	</tr>
	<tr>
		<td>Direccion</td> 
		<td>{{Form::text('direccion',$empleado[0]->direccion, $atributos = 
			array(	'placeholder' => '', 
					'style' => 'width:100%', 
					'maxlength' => '100'		))}}</td>
	</tr>
	<tr>
		<td>Codigo Postal</td> 
		<td>{{Form::text('cp',$empleado[0]->cp, $atributos = 
			array(	'placeholder' => '', 
					'maxlength' => '50'		))}}</td>
	</tr>
	<tr>
		<td>RFC</td> 
		<td>{{Form::text('rfc',$empleado[0]->rfc, $atributos = 
			array(	'placeholder' => 'abcd123456123', 
					'maxlength' => '13'		))}}</td>
	</tr>
	<tr>
		<td>Telefono</td> 
		<td>{{Form::number('telefono',$empleado[0]->telefono, $atributos = 
			array(	'placeholder' => '1122334455', 
					'maxlength' => '10'		))}}</td>
	</tr>
	<tr>
		<td>Email</td> 
		<td>{{Form::email('email',$empleado[0]->email, $atributos = 
			array(	'placeholder' => 'hola@ejemplo.com', 
					'style' => 'width:100%', 
					'maxlength' => '45'		))}}</td>
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
		<td>Usuario</td> 
		<td>{{Form::text('usuario',$empleado[0]->username, $atributos = 
			array(	'required' => 'true', 
					'placeholder' => 'Usuario', 
					'maxlength' => '50'		))}}</td>
	</tr>
	<tr>
		<td>Contraseña</td> 
		<td>{{Form::password('password', $atributos = 
			array(	'required' => 'true', 
					'placeholder' => 'Contraseña', 
					'maxlength' => '60'		))}}</td>
	</tr>
	<tr>
		<td>Sucursal</td> 
		<td>
			{{-- Traemos todas las sucursales --}}
			{{Form::select('sucursal', $sucursales, $empleado[0]->id_sucursal)}}
		</td>
	</tr>
	<tr>
		<td>Tipo de empleado</td> 
		<td>
			{{-- Traemos todas las sucursales --}}
			{{Form::select('tipo', $tipos_de_empleados, $empleado[0]->id_tipo_de_empleado)}}
		</td>
	</tr>
	<tr>
		<td></td>
		<td>
			{{Form::submit('Guardar', ['class' => 'btn btn-danger'])}}
	{{-- route URL hacia donde va a regresar--}}
			<a href="{{URL::route('empleados.index')}}" class="btn btn-success">
				Regresar
			</a>
		</td>
	</tr>
</table>
</div>
</div>
{{ Form::close() }}
@stop
