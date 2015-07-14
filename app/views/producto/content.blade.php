{{
	Session::put('title', 'Catalogo Productos')
}}

@include('master.head')

<body>
@include('master.menu')

	<!-- Content -->
	<div class="container">
		<div class="row">
			<div class="col-sm-12">
				<!-- Main Content -->
				<section>
						@yield('contenido')
				</section>
			</div>
		</div>
	</div>

<!-- Latest compiled and minified JavaScript -->
{{ HTML::script('js/jquery-1.11.2.min.js') }}
{{ HTML::script('js/bootstrap.min.js') }}
{{ HTML::script('js/main.js') }}
{{ HTML::script('js/jquery.sieve.min.js') }}

<script type="text/javascript">
//buscar productos en la tabla
	$("table.sieve").sieve();
	
//confirmar antes de enviar el formulario
	$('#formProducto').submit(function() {
	    var c = confirm("Esta seguro que desea actualizar este producto?");
	    return c; //return true or false
	});
</script>

</body>