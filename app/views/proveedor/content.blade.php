{{
	Session::put('title', 'Proveedores')
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
					<h1>
						Proveedores
					</h1>
						@yield('contenido')
				</section>
			</div>
		</div>
	</div>

{{ HTML::script('js/jquery-1.11.2.min.js') }}
{{ HTML::script('js/bootstrap.min.js') }}
{{ HTML::script('js/main.js') }}


</body>