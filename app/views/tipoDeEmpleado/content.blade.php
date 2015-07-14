{{
	Session::put('title', 'Tipos De Empleados')
}}

@include('master.head')

<body>
@include('master.menu')

	<!-- Content -->
	<div class="container">
		<div class="row">
			<div class="col-sm-1">
			</div>
			<div class="col-sm-11">
				<!-- Main Content -->
				<section>
					<h1>
						Tipos de Empleados
					</h1>
						@yield('contenido')
				</section>
			</div>
			<div class="col-sm-1">
			</div>
		</div>
	</div>

{{ HTML::script('js/jquery-1.11.2.min.js') }}
{{ HTML::script('js/bootstrap.min.js') }}
{{ HTML::script('js/main.js') }}

</body>