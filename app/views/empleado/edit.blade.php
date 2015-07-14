@extends('empleado.content')

@section('subtitulos')
	<div class="col-sm-6">
		<h4>Modificar datos personales</h4>
	</div>
	<div class="col-sm-6">
		<h4>Usuario y sucursal</h4>
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
		<td>
			<input id="nacimiento" name="nacimiento" type="date" pattern="(?:19|20)[0-9]{2}-(?:(?:0[1-9]|1[0-2])-(?:0[1-9]|1[0-9]|2[0-9])|(?:(?!02)(?:0[1-9]|1[0-2])-(?:30))|(?:(?:0[13578]|1[02])-31))" placeholder="aaaa-mm-dd" value="{{$empleado[0]->fecha_nacimiento}}"/>
		</td>
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
		<td>Calle</td> 
		<td>{{Form::text('calle',$empleado[0]->calle, $atributos = 
			array(	'placeholder' => '', 
					'style' => 'width:100%', 
					'maxlength' => '50'		))}}</td>
	</tr>
	<tr>
		<td>Colonia</td> 
		<td>{{Form::text('colonia',$empleado[0]->colonia, $atributos = 
			array(	'placeholder' => '', 
					'style' => 'width:100%', 
					'maxlength' => '50'		))}}</td>
	</tr>
	<tr>
		<td>Delegacion/Municipio</td> 
		<td>{{Form::text('delegacion',$empleado[0]->delegacion, $atributos = 
			array(	'placeholder' => '', 
					'style' => 'width:100%', 
					'maxlength' => '50'		))}}</td>
	</tr>
	<tr>
		<td>Estado</td> 
		<td>{{Form::text('estado',$empleado[0]->estado, $atributos = 
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
		<td>{{Form::text('cp',$empleado[0]->cp, $atributos = 
			array(	'placeholder' => '12345', 
					'pattern' => '[0-9]{5}?',
					'maxlength' => '50'		))}}</td>
	</tr>
	<tr>
		<td>RFC</td> 
		<td>{{Form::text('rfc',$empleado[0]->rfc, $atributos = 
			array(	'placeholder' => 'abcd123456123', 
					'pattern' => '[a-zA-Z]{4}[0-9]{6,9}?',
					'maxlength' => '13'		))}}</td>
	</tr>
	<tr>
		<td>Telefono</td> 
		<td>{{Form::text('telefono',$empleado[0]->telefono, $atributos = 
			array(	'placeholder' => '1122334455', 
					'pattern' => '[0-9]{8,10}?',
					'maxlength' => '10'		))}}</td>
	</tr>
	<tr>
		<td>Email</td> 
		<td>{{Form::email('email',$empleado[0]->email, $atributos = 
			array(	'placeholder' => 'hola@ejemplo.com', 
					'style' => 'width:100%', 
					'maxlength' => '45'		))}}</td>
	</tr>
	<tr>
		<td>Usuario</td> 
		<td>{{Form::text('usuario',$empleado[0]->username, $atributos = 
			array(	'required' => 'true', 
					'placeholder' => 'Usuario', 
					'maxlength' => '50'		))}}</td>
	</tr>
	<tr>
		<td>Contraseña</td> 
		<td>{{Form::password('password','', $atributos = 
			array(	'placeholder' => 'Contraseña', 
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
