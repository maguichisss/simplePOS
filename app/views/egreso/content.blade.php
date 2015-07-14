{{
	Session::put('title', 'Egresos')
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
					Egresos
				</h1>
				<h3>Registrar Egreso</h3>
				@yield('registrar_egreso')
			</div>
		</div>
		<div class="row">
			<div class="col-sm-12">
				<h2>Historial de egresos</h2>
				@yield('egresos')
			</div>
		</div>
	</div>

{{ HTML::script('js/jquery-1.11.2.min.js') }}
{{ HTML::script('js/jquery-ui.min.js') }}
{{ HTML::script('js/bootstrap.min.js') }}
{{ HTML::script('js/main.js') }}

<script type="text/javascript">
//confirmar antes de enviar el formulario
	$('#formEgreso').submit(function() {
	    var c = confirm("Esta seguro que desea registrar este egreso?");
	    return c; //return true or false
	});
</script>


</body>