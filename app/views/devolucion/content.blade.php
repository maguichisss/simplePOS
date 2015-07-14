{{
	Session::put('title', 'Devoluciones')
}}

@include('master.head')

<body>
@include('master.menu')

	<!-- Content -->
	<div class="container">
		<div class="row">
			<div class="col-sm-6">
				<h1>
					Devoluciones
				</h1>
			</div>
			<div class="col-sm-6">
			<!-- Aqui van los mensajes de ERROR-->
			@if(Session::has('message'))
				<div id="divMensaje" class="alert alert-{{ Session::get('class')}}">
					{{ Session::get('message') }} 
				</div>
			@endif
			</div>
		</div>
		<div class="row">
			<div class="col-sm-12">
				@yield('devoluciones')
			</div>
		</div>
	</div>

{{ HTML::script('js/jquery-1.11.2.min.js') }}
{{ HTML::script('js/jquery-ui.min.js') }}
{{ HTML::script('js/angular-1.3.12.min.js') }}
{{ HTML::script('js/bootstrap.min.js') }}
{{ HTML::script('js/main.js') }}

<script type="text/javascript">
	var idRow=0;
//previene dar enter antes de enviar el formulario
	$('.noEnterSubmit').keypress(function(e){
	    if ( e.which == 13 ) return false;
	});
//confirmar antes de enviar el formulario
	$('#formDevoluciones').submit(function() {
		//compureba que el total de tipos de pago sea igual al total
		var precioDevuelto = parseFloat($('#precioD').val());
		var precioCambio = parseFloat($('#precioC').val());
		var diferencia = precioCambio - precioDevuelto;
		if ( diferencia < 0) {
			alert('La diferencia no puede ser negativa');
			return false;
		}else{
		    var c = confirm("Esta seguro que desea realizar este cambio?");
		    return c; //return true or false
		}
	});
//buscar/autocompletar producto devuelto
	$('#productoDevuelto').autocomplete({
		source: 'productos.auto',
		minLength: 1,
		select: function(e, ui){
			$("#codigoD").val(ui.item.id);
			$("#idProductoDevuelto").val(ui.item.id);
			$("#nombreD").val(ui.item.producto);
			$("#descripcionD").val(ui.item.descripcion);
			$("#precioD").val(ui.item.precioVenta);
			$(this).val("");
			$("#productoCambio").focus();
			return false;
		}
	});
//buscar/autocompletar producto cambio
	$('#productoCambio').autocomplete({
		source: 'productos.auto',
		minLength: 1,
		select: function(e, ui){
			if (ui.item.cantidad <=0 ) {
				$(this).val("");
				alert('No hay productos disponibles');
				return false;
			};
			$("#codigoC").val(ui.item.id);
			$("#idProductoCambio").val(ui.item.id);
			$("#nombreC").val(ui.item.producto);
			$("#descripcionC").val(ui.item.descripcion);
			$("#precioC").val(ui.item.precioVenta);
			$(this).val("");
			var precioDevuelto = parseFloat($('#precioD').val());
			var precioCambio = parseFloat($('#precioC').val());
			var diferencia = precioCambio - precioDevuelto;
			$('#diferencia').html(diferencia);
			if ( diferencia < 0) {
				alert('La diferencia no puede ser negativa');
				return false;
			}
			$("#concepto").focus();
			return false;
		}
	});


</script>


</body>