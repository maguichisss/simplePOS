<!-- Content -->
<div class="container">
	<div class="row">
		<div class="col-sm-12">
			<!-- Main Content -->
			<section>
				<h2>
					Bienvenido {{Session::get('tipo')}} {{Session::get('nombre')}}
				</h2>
				<p>
					
				</p>
			</section>
		</div>
	</div>
	<div class="row">
		<!-- Aqui van los mensajes de ERROR-->
		@if(Session::has('message'))
			<div class="alert alert-{{ Session::get('class')}}">
				{{ Session::get('message') }} 
			</div>
		@endif
	</div>
</div>
