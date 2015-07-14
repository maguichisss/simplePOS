{{
	Session::put('title', 'Venta Directa')
}}

@include('master.head')

<body>
@include('master.menu')

	<!-- Content -->
	<div class="container">
		<div class="row">
			<div class="col-sm-6">
				<h1>
					Venta Directa
				</h1>
			</div>
			<div class="col-sm-6">
			<!-- Aqui van los mensajes de ERROR-->
			@if(Session::has('message'))
				<div id="divMensaje" class="alert alert-{{ Session::get('class')}}">
					{{ Session::get('message') }} 
				</div>
			@endif
				<div id="divTotal" hidden>
					<h1>
						Total: 
						<span id="total">0.00</span>
					</h1>
				</div>
			</div>
		</div>
		<div class="row">
			<div class="col-sm-12">
				@yield('ventas')
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
	var totalProductos=0;
	var total=0;

//buscar/autocompletar producto
	$(".btnDelete").on("click", borrarProducto);

	$('#buscarProducto').autocomplete({
		source: 'productos.auto',
		minLength: 1,
		select: function(e, ui){
			var categoriaProducto;
			var idCategoriaProducto;
			var cantidadProducto = $("#cantidadProducto").val();
			$(this).val("");
			$("#cantidadProducto").val("");
			$("#cantidadProducto").focus();
			if ( cantidadProducto == '' || parseInt(cantidadProducto) < 1) {
				alert('Debes ingresar una cantidad mayor que cero');
				return false;
			};
			if ( parseInt(cantidadProducto) > ui.item.cantidad) {
				alert('Solo hay '+ui.item.cantidad+' productos en inventario!');
				return false;
			};
			//obtenemos la categoria del producto
			$.each(categorias, function(i, obj) {
				if(obj.id_categoria_de_producto == ui.item.idCateProducto){
					categoriaProducto = obj.categoria;
					idCategoriaProducto = obj.id_categoria_de_producto;
				}
			});
			
			var precioVenta = ui.item.precioVenta;
			var subtotal = precioVenta*cantidadProducto;
			
			$("#tblVentaProductos tbody").append(
				"<tr>"+
				"<td><span>"+ui.item.id+"</span><input hidden type='text' name='codigo[]' value='"+ui.item.id+"' required/></td>"+
				"<td><span>"+ui.item.producto+"</span></td>"+
				"<td><span>"+ui.item.descripcion+"</span></td>"+
				"<td><span>"+categoriaProducto+"</span><select hidden name='categoriaC[]' class ='categoriaProducto' disabled><option value='"+idCategoriaProducto+"'>"+categoriaProducto+"</option></select></td>"+
				"<td><span>"+cantidadProducto+"</span><input hidden class='cantidadProducto' type='text' name='cantidad[]' value='"+cantidadProducto+"' required/></td>"+
				"<td><span class='precioVenta'>"+precioVenta+"</span><input disabled hidden type='text' class='precioO' value='"+ui.item.precioVenta+"'/></td>"+
				"<td><span class='spanSubtotal'>"+subtotal+"</span> <input  disabled hidden type='text' id='subtotal"+(idRow)+"' class='subtotal' value='"+subtotal+"'/></td>"+
				"<td><span onclick='quitarSubtotal("+(idRow++)+")' class='btnDelete glyphicon glyphicon-remove'></span></td>"+
				"</tr>"
			);
			
			recalcula();
			totalCompra();
			$(".btnDelete").on("click", borrarProducto);
			$("#Efectivo").val(total.toFixed(2));
			$('#divMensaje').hide();
			$('#divTblVentaProductos').show();
			$('#divTotal').show();
			$("#cantidadProducto").focus();
			return false;

		}
	});
//recalcula precios aplicando las reglas de negocio
	function recalcula(){
	//cuenta cuantos productos hay
		totalProductos=0;
		$('.cantidadProducto').each(function(){
			totalProductos += parseInt($(this).val());
		});
		
	//obtenemos precios originales, cantidad de producto y su categoria
		var precioO=[];
		var cantidad=[];
		var categoria=[];
		$('.precioO').each(function(){
			precioO.push( parseFloat($(this).attr('value')) );
		});
		$('.cantidadProducto').each(function(){
			cantidad.push( parseFloat($(this).attr('value')) );
		});
		$('select').each(function(){
			categoria.push( $("option:selected", this).text() );
		});
	//contamos cuantos productos de categoria fitness hay
		var cantidadFitness=0;
		$.each(categoria, function(i, valor){
			if (categoria[i].toUpperCase() == 'FITNESS')
				cantidadFitness+=cantidad[i];
		});
	//calculamos el total sin descuento
		total=0;
		$.each(precioO, function(i, valor){
			total += (precioO[i] * cantidad[i]);
		});
	//obtenemos el tipo de cliente para aplicar descuento especial
		var  tipoCliente=$('#tipoCliente').val();
	//reglas del negocio $
		var descuento=1;
		var descuentoF=1;
		if (tipoCliente=='' ||tipoCliente=='Normal') {
			if (totalProductos==1) {
				var precioVenta = precioO[0];
				if (categoria[0].toUpperCase() == 'FITNESS'){
					descuentoF = parseFloat($('#regla8').attr('des'));
				}else{
					descuento = parseFloat($('#regla2').attr('des'));
				}
			}else{
				
				var reglaMin=[];
				var reglaMax=[];
				$('.regla').each(function(){
					reglaMin.push( parseFloat($(this).attr('min')) );
					reglaMax.push( parseFloat($(this).attr('max')) );
				});
				var reglaMinF=[];
				var reglaMaxF=[];
				$('.reglaF').each(function(){
					reglaMinF.push( parseFloat($(this).attr('min')) );
					reglaMaxF.push( parseFloat($(this).attr('max')) );
				});
				$.each(reglaMax, function(i, valor){
					if (total>=reglaMin[i] && total<reglaMax[i])
						descuento = parseFloat($('#regla'+(i+1)).attr('des'));
					if (cantidadFitness>=reglaMinF[i] && 
							cantidadFitness<=reglaMaxF[i])
						descuentoF = parseFloat($('#regla'+(i+7)).attr('des'));
				});
				
			}
		}else if (tipoCliente=='Revendedor') {
			descuento = parseFloat($('#regla4').attr('des'));
			descuentoF = parseFloat($('#regla10').attr('des'));
		}else if (tipoCliente=='Distribuidor') {
			descuento = parseFloat($('#regla5').attr('des'));
			descuentoF = parseFloat($('#regla11').attr('des'));
		}else if (tipoCliente=='Tienda') {
			descuento = parseFloat($('#regla6').attr('des'));
			descuentoF = parseFloat($('#regla12').attr('des'));
		}
	//recalcula precios
		var precioV=[];
		var subtotal=[];
		var subtotalF=0;
		var subtotalO=0;
		$('.precioVenta').each(function(i, valor){
			if (categoria[i].toUpperCase() == 'FITNESS')
				precioV.push( precioO[i] * descuentoF );		
			else
				precioV.push( precioO[i] * descuento );
				
			$(this).text(precioV[i]);
		});
		$('.subtotal').each(function(i, valor){
			subtotal.push( precioV[i] * cantidad[i] );
			$(this).attr('value', subtotal[i]);
			$(this).siblings('span').text(subtotal[i]);
			//calulamos el subtotal sin descuento de los productos fitness
			var sub = parseFloat(precioO[i] * cantidad[i]);
			if (categoria[i].toUpperCase() == 'FITNESS')
				subtotalF+=sub;
			else
				subtotalO+=sub;
		});

		if (descuento>1){
			descuento=1;
		}else if (descuento==1) {
			descuento=(1)/1.05;
			total=total-subtotalO;
			subtotalO=subtotalO*1.05;
			total=total+subtotalO;
		}
		subO=parseFloat( subtotalO * descuento);
		subFi=parseFloat( subtotalF * descuentoF);
		var totalFinal=subFi+subO;
		var ahorro=parseFloat(total-totalFinal);
		$('#detallesVenta').val('F: '+subtotalF+'*'+descuentoF+'='+subFi.toFixed(2)+' O: '+subtotalO+'*'+descuento.toFixed(2)+'='+subO.toFixed(2)+' Total: '+totalFinal.toFixed(2)+' Ahorro: '+ahorro.toFixed(2) );
		$('#detallesVenta').val('Ahorro: '+ahorro.toFixed(2) );
	}
//borra producto seleccionado
	function borrarProducto(){
		var par = $(this).parent().parent(); //tr
		par.remove();
		recalcula();
		totalCompra();
		$('#cantidadProducto').focus();
		return false;
	};
//calcula el total de la compra
	function totalCompra(){
		total = 0;
		$('.subtotal').each(function(){
			total += parseFloat($(this).attr('value') );
		});
		$("#total").html(total.toFixed(2));
		$("#Efectivo").val(parseFloat($("#total").text()));
	}
//recalcula el subtotal cuando un producto es eliminado
	function quitarSubtotal(idRowX){
		var idSubtotal = '#subtotal'+idRowX;
		var quitarSubtotal = $(idSubtotal).val();
		total = parseFloat($("#total").text());
		$("#total").html(total - quitarSubtotal);
		$('.tipoPago').each(function(){
			$(this).val('00.00');
		});
		$("#Efectivo").val(total - quitarSubtotal);
	}
//obtiene las categorias de los productos
	var url='http://{{$_SERVER["SERVER_NAME"]}}/simplePOS/categoriasDeProductos.json/todos';
	var categorias;
	$.ajax({
		url: url,
		async: false,
		dataType: 'json',
		success: function (json) {
			categorias=json;
		}
	});
//confirmar antes de enviar el formulario
	$('#formVentas').submit(function() {

		//compureba que el total de tipos de pago sea igual al total
		var totalPagos = 0;
		$('.tipoPago').each(function(){
			totalPagos += parseFloat( $(this).val() );
		});
		total = parseFloat($("#total").text());
		if (total <= 0) {
			alert('Debes seleccionar al menos un producto');
			return false;
		} else if (total != totalPagos) {
			alert('El total no coincide con el total en los tipos de pago');
			return false;
		}else{
		    var c = confirm("Esta seguro que desea realizar esta venta?");
		    return c; //return true or false
		}
	});
//buscar/autocompletar cliente
	$('#buscarCliente').autocomplete({
		source: 'clientes.auto',
		minLength: 1,
		select: function(e, ui){
			$(this).val("");
			$("#idCliente").val(ui.item.id);
			$("#datosCliente").val(ui.item.value);
			$("#tipoCliente").val(ui.item.tipo_de_cliente);
			$("#cantidadProducto").focus();
			return false;

		}
	});
</script>


</body>