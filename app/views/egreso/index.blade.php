@extends('egreso.content')


@section('registrar_egreso')
	{{--Si se guardo la sesion en algun metodo de ProductoController.php
		muestra el mensaje con los parametros enviados 		--}}
	@if(Session::has('message'))
		<div class="alert alert-{{ Session::get('class')}}">
			{{ Session::get('message') }} 
		</div>
	@endif
	{{ Form::open(array('url'=>'egresos', 'id'=>'formEgreso')) }}
	<table class="table table-striped table-hover table-condensed">
		<thead>
			<th class="col-sm-2"></th>
			<th class="col-sm-9"></th>
			<th class="col-sm-1"></th>
		</thead>
		<tr>
			<td>
				<span>Importe </span>
				<input type="text" name="importe" class="form-control" pattern="\d+(\.\d{2})?"autofocus required/>
			</td>
			<td>
				<span>Concepto </span>
				<input type="text" name="concepto" class="form-control" maxlength="150" required />
			</td>		
			<td>
				<span>. </span>
				{{Form::submit('Registrar', ['class' => 'btn btn-danger'])}}
			</td>
		</tr>
	</table>
	{{ Form::close() }}
@stop

@section('egresos')

<table class="table table-striped table-hover table-condensed">
	<thead>
		<th class="col-sm-3">Empleado|Usuario</th>
		<th class="col-sm-2">Importe</th>
		<th class="col-sm-4">Concepto</th>
		<th class="col-sm-2">Fecha</th>
	</thead>
	@foreach($egresos as $egreso)
	<tr>
		<td>
			{{$egreso['empleado']}}
		</td>		
		<td>
			{{$egreso['importe']}}
		</td>
		<td>
			{{$egreso['concepto']}}
		</td>		
		<td>
			{{$egreso['fecha']}}
		</td>		
	</tr>
	@endforeach
</table>

@stop