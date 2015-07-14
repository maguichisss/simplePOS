@extends('empleado.content')

@section('subtitulos')
	<div class="col-sm-6">
		<h4>Datos personales</h4>
	</div>
	<div class="col-sm-6">
	</div>
@stop

@section('datos_empleado')
{{ Form::open(array('url'=>'empleados')) }}
<div class="row">
<div class="col-sm-6">
<table  class="table table-hover table-condensed">
	<thead>
		<th class='col-sm-2'></th>
		<th class='col-sm-4'></th>
	</thead>
	<tr>
		<td>
			<span class='requerido'>*</span>
			Nombre
		</td> 
		<td>{{Form::text('nombre','', $atributos = 
			array(	'required' => 'true', 
					'autofocus' => 'true', 
					'style' => 'width:100%', 
					'placeholder' => 'Nombre', 
					'maxlength' => '50'		))}}</td>
	</tr>
	<tr>
		<td>
			<span class='requerido'>*</span>
			Apellido Paterno
		</td> 
		<td>{{Form::text('apellidoP','', $atributos = 
			array(	'required' => 'required', 
					'style' => 'width:100%', 
					'placeholder' => 'Apellido Paterno', 
					'maxlength' => '30'		))}}</td>
	</tr>
	<tr>
		<td>Apellido Materno</td> 
		<td>{{Form::text('apellidoM','', $atributos = 
			array(	'placeholder' => 'Apellido Materno', 
					'style' => 'width:100%', 
					'maxlength' => '30'		))}}</td>
	</tr>
	<tr>
		<td>
			<span class='requerido'>*</span>
			Fecha de nacimiento
		</td>  
		<td>
			<input id="nacimiento" name="nacimiento" type="date" pattern="(?:19|20)[0-9]{2}-(?:(?:0[1-9]|1[0-2])-(?:0[1-9]|1[0-9]|2[0-9])|(?:(?!02)(?:0[1-9]|1[0-2])-(?:30))|(?:(?:0[13578]|1[02])-31))" placeholder="aaaa-mm-dd" />
		</td>
	</tr>
	<tr>
		<td>
			<span class='requerido'>*</span>
			Genero
		</td> 
		<td>
			Masculino
			{{Form::radio('genero',false, false, $atributos = 
				array(	'required' => 'required' ))}}
			Femenino
			{{Form::radio('genero',true, false, $atributos = 
				array(	'required' => 'required' ))}}
		</td>
	</tr>
	<tr>
		<td>Calle</td> 
		<td>{{Form::text('calle','', $atributos = 
			array(	'placeholder' => '', 
					'style' => 'width:100%', 
					'maxlength' => '50'		))}}</td>
	</tr>
	<tr>
		<td>Colonia</td> 
		<td>{{Form::text('colonia','', $atributos = 
			array(	'placeholder' => '', 
					'style' => 'width:100%', 
					'maxlength' => '50'		))}}</td>
	</tr>
	<tr>
		<td>Delegacion/Municipio</td> 
		<td>{{Form::text('delegacion','', $atributos = 
			array(	'placeholder' => '', 
					'style' => 'width:100%', 
					'maxlength' => '50'		))}}</td>
	</tr>
	<tr>
		<td>Estado</td> 
		<td>{{Form::text('estado','', $atributos = 
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
		<td>{{Form::text('cp','', $atributos = 
			array(	'placeholder' => '', 
					'maxlength' => '5'		))}}</td>
	</tr>
	<tr>
		<td>RFC</td> 
		<td>{{Form::text('rfc','', $atributos = 
			array(	'placeholder' => 'abcd123456123', 
					'maxlength' => '13'		))}}</td>
	</tr>
	<tr>
		<td>Telefono</td> 
		<td>{{Form::text('telefono','', $atributos = 
			array(	'placeholder' => '1122334455', 
					'maxlength' => '10'		))}}</td>
	</tr>
	<tr>
		<td>Email</td> 
		<td>{{Form::email('email','', $atributos = 
			array(	'placeholder' => 'hola@ejemplo.com', 
					'maxlength' => '45'		))}}</td>
	</tr>
	<tr>
		<td>
			<span class='requerido'>*</span>
			Usuario
		</td> 
		<td>{{Form::text('usuario','', $atributos = 
			array(	'required' => 'true', 
					'placeholder' => 'Usuario', 
					'maxlength' => '50'		))}}</td>
	</tr>
	<tr>
		<td>
			<span class='requerido'>*</span>
			Contraseña
		</td> 
		<td>{{Form::password('password', $atributos = 
			array(	'required' => 'true', 
					'placeholder' => 'Contraseña', 
					'maxlength' => '60'		))}}</td>
	</tr>
	<tr>
		<td>
			<span class='requerido'>*</span>
			Sucursal
		</td> 
		<td>
			{{-- Traemos todas las sucursales --}}
			{{Form::select('sucursal', $sucursales,['required'])}}
		</td>
	</tr>
	<tr>
		<td>
			<span class='requerido'>*</span>
			Tipo de empleado
		</td> 
		<td>
			{{-- Traemos todas las sucursales --}}
			{{Form::select('tipo', $tipos_de_empleados, ['required'])}}
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
