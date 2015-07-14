{{
	Session::put('title', 'Compras')
}}

@include('master.head')

<body>
@include('master.menu')

	<!-- Content -->
	<div class="container">
		<div class="row">
			<div class="col-sm-4">
				<h1>
					Compras
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
				@yield('compras')
			</div>
		</div>
	</div>

{{ HTML::script('js/jquery-1.11.2.min.js') }}
{{ HTML::script('js/jquery-ui.min.js') }}
{{ HTML::script('js/bootstrap.min.js') }}
{{ HTML::script('js/main.js') }}

<script type="text/javascript">

//trae los datos del proveedor seleccionado

	$('#cmbProveedores').change(function(){

    	var url='http://{{$_SERVER["SERVER_NAME"]}}/puntoDeVenta/proveedores.json/'
    				+ $('#cmbProveedores').val();
		$.getJSON(url, datosPro);
	});


	$('#cmbProveedores').keypress(function(e){

		var url='http://{{$_SERVER["SERVER_NAME"]}}/puntoDeVenta/proveedores.json/'
    				+ $('#cmbProveedores').val();
        if(e.keyCode == 13)
        	$.getJSON(url, datosPro);
    });

	function datosPro(d)
	{
		$('#idProveedor').attr('value',d.nombre);
		$('#direccionProveedor').attr('value',d.direccion);
		$('#telefonoProveedor').attr('value',d.telefono);
		$('#emailProveedor').attr('value',d.email);
	}

//confirmar antes de enviar el formulario
	$('#formCompras').submit(function() {

		var totalProductos = 0;
		$('.cantidad').each(function(){
			totalProductos += parseInt( $(this).val() );
		});
		if (totalProductos <= 0) {
			alert('Debes agregar al menos un producto');
			return false;
		}

	    var c = confirm("Esta seguro que desea realizar esta compra?");
	    return c; //return true or false
	});

//buscar/autocompletar producto
	$(".btnDelete").on("click", borrarCompraProducto);

	$('#buscarProducto').autocomplete({
		source: 'productos.auto',
		minLength: 1,
		select: function(e, ui){

			$('#divTblCompraProductos').show();

			var url='http://{{$_SERVER["SERVER_NAME"]}}/puntoDeVenta/categoriasDeProductos.json/todos';
			var categoriasSelect = '';
			$.getJSON(url, function datos(d){
				categoriasSelect='<select name="categoriaC[]" class ="form-control" disabled>';
				$.each(d, function(i, obj) {
					if(obj.id_categoria_de_producto == ui.item.idCateProducto)
					categoriasSelect +='<option value="'+obj.id_categoria_de_producto+'">'+obj.categoria+'</option>';

				});
				categoriasSelect += '</select>';

				$("#tblCompraProductos tbody").append(
				"<tr>"+
				"<td><input disabled type='text' class='form-control' value='"+ui.item.id+"'/> <input hidden type='text' name='codigoC[]' value='"+ui.item.id+"'/></td>"+
				"<td><input disabled type='text' class='form-control' name='productoC[]' value='"+ui.item.producto+"'/></td>"+
				"<td><input disabled type='text' class='form-control' name='descripcionC[]' value='"+ui.item.descripcion+"'/></td>"+
				"<td>"+categoriasSelect+"</td>"+
				"<td><input type='text' class='cantidad form-control' name='cantidadC[]' value='0' required /></td>"+
				"<td><input type='text' class='form-control' name='stockC[]' value='"+ui.item.stock+"'/></td>"+
				"<td><input type='text' class=' form-control' name='precioCompraC[]' value='"+ui.item.precioCompra+"'/></td>"+
				"<td><input type='date' class='form-control' name='caducidadC[]' required pattern='(?:19|20)[0-9]{2}-(?:(?:0[1-9]|1[0-2])-(?:0[1-9]|1[0-9]|2[0-9])|(?:(?!02)(?:0[1-9]|1[0-2])-(?:30))|(?:(?:0[13578]|1[02])-31))' placeholder='aaaa-mm-dd'/></td>"+
				"<td><span class='btnDelete glyphicon glyphicon-remove'></span></td>"+
				"</tr>");
				$(".btnDelete").on("click", borrarCompraProducto);
			});
				$(this).val("");
				return false;


		}
	});

	function borrarCompraProducto(){
		var par = $(this).parent().parent(); //tr
		par.remove();
		$('#buscarProducto').focus();
	};

//datepicker
	$('input[type=date]').datepicker({
		dateFormat: "yy-mm-dd"
	});

</script>


</body>