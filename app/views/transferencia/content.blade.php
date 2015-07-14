{{
	Session::put('title', 'Transferencias')
}}

@include('master.head')

<body>
{{ HTML::style('css/jquery-ui.min.css') }}
@include('master.menu')

	<!-- Content -->
	<div class="container">
		<div class="row">
			<div class="col-sm-12">
				<h1>
					Transferencias
				</h1>
				<h3>Nueva transferencia</h3>
				@yield('nueva_transferencia')
			</div>
		</div>
		<div class="row">
			<div class="col-sm-12">
				<h2>Historial de transferencias</h2>
				@yield('transferencias')
			</div>
		</div>
	</div>

{{ HTML::script('js/jquery-1.11.2.min.js') }}
{{ HTML::script('js/jquery-ui.min.js') }}
{{ HTML::script('js/bootstrap.min.js') }}
{{ HTML::script('js/main.js') }}

<script type="text/javascript">
//confirmar antes de enviar el formulario
	$('#formTransferencia').submit(function() {
	    var c = confirm("Esta seguro que desea realizar esta transferencia?");
	    return c; //return true or false
	});
/*
//limpiar todo al cambiar de sucursal origen
	$('#sucursalOrigen').change(function() {
	    $('#buscarProducto').val("");
	    $('#inCodigo').val("");
	    $('#inDetalles').val("");
	    $('#inDisponible').val("");
	    $('#inCantidad').val("");
	});
*/
//buscar/autocompletar producto
	
	$('#buscarProducto').autocomplete({
		source: function(request, response) {
					$.getJSON('productos.auto', { term: request.term, sucursalO: $('#sucursalOrigen').val() }, response);
				},
		minLength: 1,
		select: function(e, ui){

			$('#inCodigo').attr('value',ui.item.id);
			$('#inDetalles').attr('value','Producto:'+ui.item.producto+
										'| Descripcion:'+ui.item.descripcion+
										'| Stock:'+ui.item.stock+
										'| PrecioCompra:'+ui.item.precioCompra+
										'| PrecioVenta:'+ui.item.precioVenta);
			$('#inDisponible').attr('value',ui.item.cantidad);
		}
	});


</script>


</body>