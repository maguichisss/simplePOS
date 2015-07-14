{{
	Session::put('title', 'Clientes')
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
					Clientes
				</h1>
			</div>
				@yield('subtitulos')
		</div>
		<div class="row">
			<div class="col-sm-12">
				@yield('datos_cliente')
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
</script>

</body>