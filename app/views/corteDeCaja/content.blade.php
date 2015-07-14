{{
	Session::put('title', 'Corte de caja')
}}

@include('master.head')

<body>
@include('master.menu')

	<!-- Content -->
	<div class="container">
		<div class="row">
			<div class="col-sm-4">
				<h1>
					Corte de caja
				</h1>
			</div>
			<div class="col-sm-8">
			<!-- Aqui van los mensajes de ERROR-->
			@if(Session::has('message'))
				<div class="alert alert-{{ Session::get('class')}}">
					{{ Session::get('message') }} 
				</div>
			@endif
			</div>		
		</div>
		<div class="row">
			<div class="col-sm-12">
				@yield('corteDeCaja')
			</div>
		</div>
	</div>

{{ HTML::script('js/jquery-1.11.2.min.js') }}
{{ HTML::script('js/jquery-ui.min.js') }}
{{ HTML::script('js/angular-1.3.12.min.js') }}
{{ HTML::script('js/bootstrap.min.js') }}
{{ HTML::script('js/main.js') }}

<script type="text/javascript">
//datepicker
	$('input[type=date]').datepicker({
		dateFormat: "yy-mm-dd"
	});
/*
//filtra por sucursal seleccionada
	$('#cmbSucursales').change(function(){
		var sucursal = $('#cmbSucursales').val();
    	$('#idSucursal').attr('value',sucursal);
    	$('#idEmpleado').attr('value','');
    	if (sucursal == 0){		sucursal = 'corte/0';}
    	else{					sucursal = 'corteSucursal/'+sucursal;}
		//borramos lo que tenga la tabla
		$('.tblBody').html('');
    	var ventas=null;
    	var url='http://{{$_SERVER["SERVER_NAME"]}}/puntoDeVenta/ventas.json/'+sucursal;
		//esperamos la respuesta y la guardamos en ventas
		$.ajax({
			url: url,
			async: false,
			dataType: 'json',
			success: function (json) {
				ventas = json;
			},
			error: function(json) {
				ventas = {'id_empleado':'HA OCURRIDO ','id_venta':'UN ERROR',
							'detalles':'AL CONECTAR CON ','total':'LA BASE'};
			}
		});
		var devoluciones=null;
    	var url='http://{{$_SERVER["SERVER_NAME"]}}/puntoDeVenta/devoluciones.json/'+sucursal;
    	//esperamos la respuesta y la guardamos en devoluciones
		$.ajax({
			url: url,
			async: false,
			dataType: 'json',
			success: function (json) {
				devoluciones = json;
			}
		});
		$.each(ventas, function(i, obj) {
			$("#tblCorteVentas tbody").append(
				"<tr>"+
				"<td>"+obj.nombre+" "+obj.apellido_paterno+"</td>"+
				"<td>"+obj.id_venta+"</td>"+
				"<td>"+obj.detalles+"</td>"+
				"<td class='cantidad'>"+obj.total+
				"<input hidden type='text' name='ventas[]' value='"+obj.id_venta+"' class='required'/></td>"+
				"</tr>"
			);
		});
		$.each(devoluciones, function(i, obj) {
			$("#tblCorteDevoluciones tbody").append(
				"<tr>"+
				"<td>"+obj.nombre+" "+obj.apellido_paterno+"</td>"+
				"<td>"+obj.id_producto_devuelto+"</td>"+
				"<td>"+obj.id_producto_cambio+"</td>"+
				"<td>"+obj.concepto+"</td>"+
				"<td class='cantidad'>"+obj.diferencia+
				"<input hidden type='text' name='devoluciones[]' value='"+obj.id_devolucion+"' class='required'/></td>"+
				"</tr>"
			);
		});
		var sum = 0;
		$('.cantidad').each(function(){
		    sum += parseFloat($(this).text());
		});
		$('#total').html(sum.toFixed(2));	
	});
//filtra por empleado seleccionada
	$('#cmbEmpleados').change(function(){
		var empleado = $('#cmbEmpleados').val();
		$('#idEmpleado').attr('value',empleado);
    	$('#idSucursal').attr('value','');
    	if (empleado == 0) 		empleado = 'corte/0';
    	else			   		empleado = 'corteEmpleado/'+empleado;
		//borramos lo que tenga la tabla
		$('.tblBody').html('');
    	var ventas=null;
    	var url='http://{{$_SERVER["SERVER_NAME"]}}/puntoDeVenta/ventas.json/'+empleado;
		//esperamos la respuesta y la guardamos en ventas
		$.ajax({
			url: url,
			async: false,
			dataType: 'json',
			success: function (json) {
				ventas = json;
			},
			error: function(json) {
				ventas = {'id_empleado':'HA OCURRIDO ','id_venta':'UN ERROR',
							'detalles':'AL CONECTAR CON ','total':'LA BASE'};
			}
		});
		var devoluciones=null;
    	var url='http://{{$_SERVER["SERVER_NAME"]}}/puntoDeVenta/devoluciones.json/'+empleado;
    	//esperamos la respuesta y la guardamos en devoluciones
		$.ajax({
			url: url,
			async: false,
			dataType: 'json',
			success: function (json) {
				devoluciones = json;
			}
		});
		$.each(ventas, function(i, obj) {
			$("#tblCorteVentas tbody").append(
				"<tr>"+
				"<td>"+obj.nombre+" "+obj.apellido_paterno+"</td>"+
				"<td>"+obj.id_venta+"</td>"+
				"<td>"+obj.detalles+"</td>"+
				"<td class='cantidad'>"+obj.total+
				"<input hidden type='text' name='ventas[]' value='"+obj.id_venta+"' class='required'/></td>"+
				"</tr>"
			);
		});
		$.each(devoluciones, function(i, obj) {
			$("#tblCorteDevoluciones tbody").append(
				"<tr>"+
				"<td>"+obj.nombre+" "+obj.apellido_paterno+"</td>"+
				"<td>"+obj.id_producto_devuelto+"</td>"+
				"<td>"+obj.id_producto_cambio+"</td>"+
				"<td>"+obj.concepto+"</td>"+
				"<td class='cantidad'>"+obj.diferencia+
				"<input hidden type='text' name='devoluciones[]' value='"+obj.id_devolucion+"' class='required'/></td>"+
				"</tr>"
			);
		});
		var sum = 0;
		$('.cantidad').each(function(){
		    sum += parseFloat($(this).text());
		});
		$('#total').html(sum.toFixed(2));
	});

//suma total del corte
	var sum = 0;
	$('.cantidad').each(function(){
	    sum += parseFloat($(this).text());
	});
	$('#total').html(sum.toFixed(2));
//confirmar antes de enviar el formulario
	$('#formCorteDeCaja').submit(function() {
		if($('.required').val() == null){
			alert('No es necesario realizar el corte');
			return false;
		}else{
		    var c = confirm("Esta seguro que desea realizar el corte?");
		    return c; //return true or false
		}
	});
*/
</script>


</body>