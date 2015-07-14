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
		<div class="col-sm-4">
			<h1>
				Reporte de Ventas
			</h1>
		</div>
		<div class="col-sm-4">
			<h1>
				Reporte de Compras
			</h1>
		</div>
		<div class="col-sm-4">
		</div>
	</div>
	<div class="row">
<!-- Reporte de Ventas -->
		<div class="col-sm-4">
{{ Form::open(array('url'=>'reportes', 'id'=>'formVentas',
	'target'=>'_blank')) }}
<div class="row">
	<table id="tblVentas">
		<tr>
			<td class="col-sm-*">
				<label>Sucursal: </label>
				{{Form::select('idSucursal', $sucursales, null,array(
						'required' => 'true', 
						'class' => 'form-control', 
						'id' => 'cmbSucursales'))}}
			</td>
		</tr>
		<tr>
			<td class="col-sm-*">
				<label>Empleado: </label>
				{{Form::select('idEmpleado', $empleados, null, array(
						'required' => 'true', 
						'class' => 'form-control', 
						'id' => 'cmbEmpleados'))}}
			</td>
		</tr>
		<tr>
			<td class="col-sm-*">
				<label>Fecha Inicio: </label>
				<input id="fechaInicio" name="fechaInicio" type="date" class="form-control" pattern="(?:19|20)[0-9]{2}-(?:(?:0[1-9]|1[0-2])-(?:0[1-9]|1[0-9]|2[0-9])|(?:(?!02)(?:0[1-9]|1[0-2])-(?:30))|(?:(?:0[13578]|1[02])-31))" placeholder="aaaa-mm-dd" value="{{date('Y-m-d', strtotime('-7 days', strtotime(date('Y-m-d'))))}}" />
			</td>
		</tr>
		<tr>
			<td class="col-sm-*">
				<label>Fecha Fin: </label>
				<input id="fechaFin" name="fechaFin" type="date" class="form-control" pattern="(?:19|20)[0-9]{2}-(?:(?:0[1-9]|1[0-2])-(?:0[1-9]|1[0-9]|2[0-9])|(?:(?!02)(?:0[1-9]|1[0-2])-(?:30))|(?:(?:0[13578]|1[02])-31))" placeholder="aaaa-mm-dd" value="{{date('Y-m-d')}}" />
			</td>
		</tr>
		<tr>
			<td>
				<input hidden name="accion" value="ventas"/>
			</td>
		</tr>
	</table>
	<br/>
	{{Form::submit('Crear reporte', ['class' => 'btn btn-success btn-lg col-sm-*'])}}
</div>
{{ Form::close() }}
		</div>

<!-- Reporte de Compras -->
		<div class="col-sm-4">
{{ Form::open(array('url'=>'reportes', 'id'=>'formCompras',
	'target'=>'_blank')) }}
<div class="row">
	<table id="tblCompras">
		<tr>
			<td class="col-sm-*">
				<label>Sucursal: </label>
				{{Form::select('idSucursal', $sucursales, null,array(
						'required' => 'true', 
						'class' => 'form-control', 
						'id' => 'cmbSucursales'))}}
			</td>
		</tr>
		<tr>
			<td class="col-sm-*">
				<label>Empleado: </label>
				{{Form::select('idEmpleado', $empleados, null, array(
						'required' => 'true', 
						'class' => 'form-control', 
						'id' => 'cmbEmpleados'))}}
			</td>
		</tr>
		<tr>
			<td class="col-sm-*">
				<label>Fecha Inicio: </label>
				<input id="fechaInicio" name="fechaInicio" type="date" class="form-control" pattern="(?:19|20)[0-9]{2}-(?:(?:0[1-9]|1[0-2])-(?:0[1-9]|1[0-9]|2[0-9])|(?:(?!02)(?:0[1-9]|1[0-2])-(?:30))|(?:(?:0[13578]|1[02])-31))" placeholder="aaaa-mm-dd" value="{{date('Y-m-d', strtotime('-7 days', strtotime(date('Y-m-d'))))}}" />
			</td>
		</tr>
		<tr>
			<td class="col-sm-*">
				<label>Fecha Fin: </label>
				<input id="fechaFin" name="fechaFin" type="date" class="form-control" pattern="(?:19|20)[0-9]{2}-(?:(?:0[1-9]|1[0-2])-(?:0[1-9]|1[0-9]|2[0-9])|(?:(?!02)(?:0[1-9]|1[0-2])-(?:30))|(?:(?:0[13578]|1[02])-31))" placeholder="aaaa-mm-dd" value="{{date('Y-m-d')}}" />
			</td>
		</tr>
		<tr>
			<td>
				<input hidden name="accion" value="compras"/>
			</td>
		</tr>
	</table>
	<br/>
	{{Form::submit('Crear reporte', ['class' => 'btn btn-success btn-lg col-sm-*'])}}
</div>
{{ Form::close() }}
		</div>

	</div>
</div>

{{ HTML::script('js/jquery-1.11.2.min.js') }}
{{ HTML::script('js/jquery-ui.min.js') }}
{{ HTML::script('js/bootstrap.min.js') }}
{{ HTML::script('js/main.js') }}
</body>