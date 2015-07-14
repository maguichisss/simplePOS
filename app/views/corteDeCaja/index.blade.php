@extends('corteDeCaja.content')

@section('corteDeCaja')
{{ HTML::style('css/jquery-ui.min.css') }}
{{ Form::open(array('url'=>'corteDeCaja', 'id'=>'formCorteDeCaja',
	'target'=>'_blank')) }}
<div class="row">
	<div class="col-sm-4">
	<table id="tblFechas">
		<tr>
			<td class="col-sm-*">
				<label>Sucursal: </label>
				{{Form::select('cmbSucursales', $sucursales, null,array(
						'required' => 'true', 
						'class' => 'form-control', 
						'id' => 'cmbSucursales'))}}
			</td>
		</tr>
		<tr>
			<td class="col-sm-*">
				<label>Empleado: </label>
				{{Form::select('cmbEmpleados', $empleados, null, array(
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
			<td class="col-sm-*">
				<br/>
				{{Form::submit('Realizar corte', array(
						'class' => 'btn btn-success'))}}

			</td>
		</tr>
		<tr>
			<td hidden>
				<input type='text' class='form-control' id="idSucursal" name="idSucursal" readonly/>
			</td>
			<td hidden>
				<input type='text' class='form-control' id="idEmpleado" name="idEmpleado" readonly/>
			</td>
		</tr>
	</table>
	</div>
</div>
{{ Form::close() }}
@stop