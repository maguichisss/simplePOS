{{
	Session::put('title', 'Reporte de Ventas')
}}

@include('master.head')

<body>
{{ HTML::style('css/jquery-ui.min.css') }}
@include('master.menu')
	<!-- Content -->
	<div class="container">
		<div class="row">
			<div class="col-sm-6">
				<h1>
					Reporte de Ventas
				</h1>
			</div>
			<div class="col-sm-6">
			</div>
		</div>
		<div class="row">
			<div class="col-sm-12">
{{ Form::open(array('url'=>'reporteVentas', 'id'=>'formVentas')) }}
<div class="row">
	<table id="tblFechas">
		<tr>
			<td class="col-sm-*">
				<label>Sucursal: </label>
				{{Form::select('idSucursal', $sucursales, null,array(
						'required' => 'true', 
						'class' => 'form-control', 
						'id' => 'cmbSucursales'))}}
			</td>
			<td class="col-sm-*">
				<label>Empleado: </label>
				{{Form::select('idEmpleado', $empleados, null, array(
						'required' => 'true', 
						'class' => 'form-control', 
						'id' => 'cmbEmpleados'))}}
			</td>
		</tr>
	</table>
</div>
<br/>
<div class="row">
{{Form::submit('Crear reporte', ['class' => 'btn btn-success btn-lg col-sm-*'])}}
</div>
{{ Form::close() }}

			</div>
		</div>
	</div>

{{ HTML::script('js/jquery-1.11.2.min.js') }}
{{ HTML::script('js/jquery-ui.min.js') }}
{{ HTML::script('js/angular-1.3.12.min.js') }}
{{ HTML::script('js/bootstrap.min.js') }}
{{ HTML::script('js/main.js') }}
</body>