
@include('master.head')
{{ HTML::style('css/jquery-ui.min.css') }}
<div class="container">
<div class="row">
<div class="col-sm-4">
	<select name="sucursal" id="cmbSucursales">
		<option value="1">Copilco</option>
		<option value="2">Ajusco</option>
		<option value="3">Del Valle</option>
		<option value="5">Acatl&aacute;n</option>
	</select>
{{ Form::open(array('url'=>'compras', 'id'=>'validar')) }}

	<table>
		<tr>
		    <td><label>Id:</label></td>
		    <td><input type="text" id="txtId"/></td>
		</tr>
		<tr>
		    <td><label>Nombre:</label></td>
		    <td><input type="text" class="txtNombre" pattern="[a-zA-Z ]+"/></td>
		</tr>
		    <td><label>Direccion:</label></td>
		    <td><input type="text" id="txtDireccion"/></td>
		</tr>
		<tr>
		    <td><label>Telefono:</label></td>
		    <td><input type="text" id="txtTelefono" pattern="\d+"/></td>
		</tr>
		<tr>
		    <td><label>Email:</label></td>
		    <td><input type="email" id="txtEmail"/></td>
		</tr> 
		<tr>
		    <td><label>Fecha:</label></td>
		    <td><input type="text" id="txtFecha" pattern="(?:19|20)[0-9]{2}-(?:(?:0[1-9]|1[0-2])-(?:0[1-9]|1[0-9]|2[0-9])|(?:(?!02)(?:0[1-9]|1[0-2])-(?:30))|(?:(?:0[13578]|1[02])-31))" placeholder="aaaa-mm-dd"/></td>
		</tr>    
		    
		<tr>
		    <td><label>Nombre:</label></td>
		    <td><input type="text" class="txtNombre"/></td>
		</tr>
		<tr>

	</table>
{{ Form::close() }}
</div>
//ocultar
	<div class="col-sm-8">
		<label>Buscar:</label>
		<input type="text" id="buscar"/>
		<table class="table table-striped table-hover table-condensed table-bordered">
			<thead>
			    <td><label>Nombre:</label></td>
			    <td><label>Direccion:</label></td>
			    <td><label>Telefono:</label></td>
			    <td><label>Email:</label></td>
			</thead>
			<tbody>
				<tr>
				    <td><input type="text" id="nombre"/></td>
				    <td><input type="text" id="direccion"/></td>
				    <td><input type="text" id="telefono"/></td>
				    <td><input type="text" id="email"/></td>
				</tr>    
			</tbody>

		</table>
	</div>
	</div>
	<br/>
	<div class="row">
	<div class="col-sm-8">
		<label>Buscar:</label>
		<input type="text" id="search" autofocus/>
		<table id="tblSucursales" class="table table-striped table-hover table-condensed table-bordered">
			<thead>
			    <td class="col-sm-2" ><label>Nombre:</label></td>
			    <td class="col-sm-2" ><label>Direccion:</label></td>
			    <td class="col-sm-2" ><label>Telefono:</label></td>
			    <td class="col-sm-2" ><label>Email:</label></td>
			    <td></td>
			</thead>
			<tbody>
				<tr>
				    
				</tr>    
			</tbody>

		</table>
	</div>
	</div>
	<a id="btnNuevoProducto" class="btn btn-info">
		Nuevo
	</a>
	<div class="row" id="divTblNuevosProductos" hidden>
	<h3>Nuevo producto</h3>
	<table id="tblNuevosProductos" class="table table-striped table-hover table-condensed table-bordered"  >
		<thead>
		    <td class="col-sm-2" ><label>Codigo</label></td>
		    <td class="col-sm-2" ><label>Nombre</label></td>
		    <td class="col-sm-3" ><label>Descripcion</label></td>
		    <td class="col-sm-2" ><label>Categoria</label></td>
		    <td class="col-sm-1" ><label>Cantidad</label></td>
		    <td class="col-sm-1" ><label>Stock</label></td>
		    <td class="col-sm-1" ><label>Precio compra</label></td>
		    <td class="col-sm-1" ><label>Precio venta</label></td>
		    <td class="col-sm-*"></td>
		</thead>
		<tbody>
			<tr>
			    
			</tr>    
		</tbody>
	</table>
	</div>

	<div class="row">
		<table id="tblProveedor">
			<thead></thead>
			<tbody>
				<tbody>
				<tr>
					<td>
						<select  id="cmbProveedores">
							<option value="1">Genesis</option>
							<option value="2">GNC</option>
							<option value="3">VPX</option>
							<option value="4">Muscle</option>
							<option value="5">NTC</option>
							<option value="6">3DPO</option>
						</select>
					</td>
					<td hidden>
						<span></span>
						<input type='text' class='form-control' id="idProveedor"/>
					</td>
					<td>
						<span>Direccion: </span>
						<input type='text' class='form-control' id="direccionProveedor"/>
					</td>
					<td>
						<span>Telefono: </span>
						<input type='text' class='form-control' id="telefonoProveedor"/>
					</td>
					<td>
						<span>Email:</span>
						<input type='text' class='form-control' id="emailProveedor"/>
					</td>

			</tbody>
			</tbody>
		</table>
	</div>



	<div class="row">

	</div>


</div>


<!--	
	   $.getJSON(url )
        .done(function( json ) {
		console.log( "JSON Data: " +json );
		})
		.fail(function( jqxhr, textStatus, error ) {
		var err = textStatus + ", " + error;
		( "Request Failed: " + err );
		});

-->

{{ HTML::script('js/jquery-1.11.2.min.js') }}
{{ HTML::script('js/jquery-ui.min.js') }}
{{ HTML::script('js/jquery.validate.min.js') }}
{{ HTML::script('js/bootstrap.min.js') }}
{{ HTML::script('js/main.js') }}



<script type="text/javascript">







	//trae los datos del proveedor seleccionado

		$('#cmbProveedores').change(function(){

	    	var url='http://localhost/puntoDeVenta/proveedores.json/'
	    				+ $('#cmbProveedores').val();
			$.getJSON(url, datosPro);
		});


		$('#cmbProveedores').keypress(function(e){

			var url='http://localhost/puntoDeVenta/proveedores.json/'
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

	//agrega fila nuevo producto
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

				$("#tblNuevosProductos tbody").append(
				"<tr>"+
				"<td><input type='text' class='form-control' name='codigoN[]'/></td>"+
				"<td><input type='text' class='form-control' name='productoN[]'/></td>"+
				"<td><input type='text' class='form-control' name='descripcionN[]'/></td>"+
				"<td>"+categoriasSelect+"</td>"+
				"<td><input type='text' class='form-control' name='cantidad[]'/></td>"+
				"<td><input type='text' class='form-control' name='stockN[]'/></td>"+
				"<td><input type='text' class='form-control' name='precioCompraN[]'/></td>"+
				"<td><input type='text' class='form-control' name='precioVentaN[]'/></td>"+
				"<td><span class='btnBorrarNuevo glyphicon glyphicon-remove'></span></td>"+
				"</tr>");
				$(".btnBorrarNuevo").on("click", borrarNuevoProducto);
				return false;
			});

		});

		function borrarNuevoProducto(){
			var par = $(this).parent().parent(); //tr
			par.remove();
		};

	//AUTOCOMPLETA
		$(".btnDelete").on("click", Delete);

		$('#search').autocomplete({
			source: 'sucursales.auto',
			minLength: 1,
			select: function(e, ui){
				$('#search').val();
				$("#tblSucursales tbody").append(
				"<tr>"+
				"<td><input type='text' value='"+ui.item.value+"'/></td>"+
				"<td><input type='text' value='"+ui.item.direccion+"'/></td>"+
				"<td><input type='text' value='"+ui.item.telefono+"'/></td>"+
				"<td><input type='text' value='"+ui.item.email+"'/></td>"+
				"<td><a class='btnDelete' href='#'>Delete</a></td>"+
				"</tr>");
				$(".btnDelete").on("click", Delete);

			}
		});

		function Delete(){
			var par = $(this).parent().parent(); //tr
			par.remove();
		};

	//AUTOCOMPLETA
		$('#buscar').autocomplete({
			source: 'sucursales.auto',
			minLength: 1,
			select: function(e, ui){
				$('#nombre').val( ui.item.value);
				$('#direccion').val( ui.item.direccion);
				$('#telefono').val( ui.item.telefono);
				$('#email').val( ui.item.email);
				console.log('id: '+ui.item.id);
				console.log('nombre: '+ui.item.value);
				console.log('direccion: '+ui.item.direccion);
				console.log('telefono: '+ui.item.telefono);
				console.log('email: '+ui.item.email);

			}
		});

	//trae los datos de la sucursal seleccionada

		$('#cmbSucursales').change(function(){

	    	var url='http://localhost/puntoDeVenta/sucursales.json/'
	    				+ $('#cmbSucursales').val();

			$.getJSON(url, datos);
		});


		$('#cmbSucursales').keypress(function(e){

			var url='http://localhost/puntoDeVenta/sucursales.json/'
	    				+ $('#cmbSucursales').val();

	        if(e.keyCode == 13)
	        	$.getJSON(url, datos);
	    });

		function datos(d)
		{
			$('#txtId').attr('value',d.id_sucursal);
			$('#txtNombre').attr('value',d.nombre_sucursal);
			$('#txtDireccion').attr('value',d.direccion);
			$('#txtTelefono').attr('value',d.telefono);
			$('#txtEmail').attr('value',d.email);
		}


</script>