{{
	Session::put('title', 'Productos Sucursal')
}}

@include('master.head')

<body>
@include('master.menu')

	<!-- Content -->
	<div class="container">
		<div class="row">
			<div class="col-sm-4">
				<h1>
					Productos Sucursal
				</h1>
			</div>
			<div class="col-sm-7">
			<!-- Aqui van los mensajes de ERROR-->
			@if(Session::has('message'))
				<h6 class="alert alert-{{ Session::get('class')}}">
					{{ Session::get('message') }} 
				</h6>
			@endif
			</div>
		</div>
		<div class="row">
			<div class="col-sm-12">
				@yield('sucursalProducto')
			</div>
		</div>
	</div>

{{ HTML::script('js/jquery-1.11.2.min.js') }}
{{ HTML::script('js/jquery-ui.min.js') }}
{{ HTML::script('js/jquery.sieve.min.js') }}
{{ HTML::script('js/bootstrap.min.js') }}
{{ HTML::script('js/main.js') }}

<script type="text/javascript">
//buscar productos en la tabla
	$("table.sieve").sieve();

//boton nuevo producto
	$(".btnBorrarNuevo").on("click", borrarNuevoProducto);

	$('#btnNuevoProducto').on("click", function(){
		$('#divTblNuevosProductos').show();

		var url='http://localhost/puntoDeVenta/categoriasDeProductos.json/todos';
		var categoriasSelect = '';
		$.getJSON(url, function datos(d){
			categoriasSelect='<select name="categoriaN[]" class ="form-control">';
			$.each(d, function(i, obj) {

				categoriasSelect +='<option value="'+obj.id_categoria_de_producto+'">'+obj.categoria+'</option>';

			});
			categoriasSelect += '</select>';

			$("#divTblNuevosProductos tbody").append(
			"<tr>"+
			"<td><input required type='text' class='focusCodigo form-control' name='codigoN[]' pattern='\\d+'/></td>"+
			"<td><input required type='text' class='form-control' name='productoN[]'/></td>"+
			"<td><input required type='text' class='form-control' name='descripcionN[]'/></td>"+
			"<td>"+categoriasSelect+"</td>"+
			"<td><input required type='text' class='form-control' name='stockN[]' pattern='\\d+'/></td>"+
			"<td><input required type='text' class='form-control' name='precioCompraN[]' pattern='\\d+(\\.\\d{1,2})?'/></td>"+
			"<td><input required type='text' class='enterVenta form-control' name='precioVentaN[]' pattern='\\d+(\\.\\d{1,2})?'/></td>"+
			"<td><span class='btnBorrarNuevo glyphicon glyphicon-remove'></span></td>"+
			"</tr>");
			$(".btnBorrarNuevo").on("click", borrarNuevoProducto);
			$(".focusCodigo").focus();


			return false;
		});

	});

/*
//al dar enter en precio venta crear nuevo registro
	$('input.enterVenta').keypress(function(e){
		if(e.keyCode == 13){
			var url='http://localhost/puntoDeVenta/categoriasDeProductos.json/todos';
			var categoriasSelect = '';
			$.getJSON(url, function datos(d){
				categoriasSelect='<select name="categoriaN[]" class ="form-control">';
				$.each(d, function(i, obj) {

					categoriasSelect +='<option value="'+obj.id_categoria_de_producto+'">'+obj.categoria+'</option>';

				});
				categoriasSelect += '</select>';

				$("#divTblNuevosProductos tbody").append(
				"<tr>"+
				"<td><input required type='text' class='focusCodigo form-control' name='codigoN[]' pattern='\\d+'/></td>"+
				"<td><input required type='text' class='form-control' name='productoN[]'/></td>"+
				"<td><input required type='text' class='form-control' name='descripcionN[]'/></td>"+
				"<td>"+categoriasSelect+"</td>"+
				"<td><input required type='text' class='form-control' name='cantidadN[]' pattern='\\d+'/></td>"+
				"<td><input required type='text' class='form-control' name='stockN[]' pattern='\\d+'/></td>"+
				"<td><input required type='text' class='form-control' name='precioCompraN[]' pattern='\\d+(\\.\\d{1,2})?'/></td>"+
				"<td><input required type='text' class='enterVenta form-control' name='precioVentaN[]' pattern='\\d+(\\.\\d{1,2})?'/></td>"+
				"<td><span class='btnBorrarNuevo glyphicon glyphicon-remove'></span></td>"+
				"</tr>");
				$(".btnBorrarNuevo").on("click", borrarNuevoProducto);
				$(".focusCodigo").focus();
				return false;
			});
        }
        	
    });
*/
	function borrarNuevoProducto(){
		var par = $(this).parent().parent(); //tr
		par.remove();
	};


//confirmar antes de enviar el formulario
	$('#formNuevos').submit(function() {
	    var c = confirm("Esta seguro que desea agregar estos productos?");
	    return c; //return true or false
	});
	$('#formUpdate').submit(function() {
	    var c = confirm("Esta seguro que desea actualizar este producto?");
	    return c; //return true or false
	});

</script>


</body>