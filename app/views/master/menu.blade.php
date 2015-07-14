<!-- Nav -->
<nav class="navbar navbar-inverse navbar-fixed-top">
	<div class="container">
		<div class="container-fluid">
			<!-- Brand and toggle get grouped for better mobile display -->
			<div class="navbar-header">
				<button type="button" class="navbar-toggle collapsed" data-toggle="collapse" data-target="#bs-example-navbar-collapse-1">
					<span class="sr-only">Toggle navigation</span>
					<span class="icon-bar"></span>
					<span class="icon-bar"></span>
					<span class="icon-bar"></span>
				</button>
				<a class="navbar-brand" href="{{URL::to('inicio')}}">
					<b>Boysselle</b>
				</a>
			</div>
			<!-- Collect the nav links, forms, and other content for toggling -->
			<div class="collapse navbar-collapse" id="bs-example-navbar-collapse-1">
				<ul class="nav navbar-nav">
					<li>
						<a id="Venta directa" href="{{URL::route('ventas.index')}}">
							Venta directa 
						</a>
					</li>
					<li>
						<a id="Productos" href="{{URL::route('sucursalesProductos.index')}}">
							Productos
						</a>
					</li>
					<li>
						<a id="Clientes" href="{{URL::route('clientes.index')}}">
							Clientes
						</a>
					</li>
				@if(Session::get('tipo') == 'ADMINISTRADOR' || Session::get('tipo') == 'GERENTE GENERAL' || Session::get('tipo') == 'GERENTE DE SUCURSAL')
					<li>
						<a id="Compras" href="{{URL::route('compras.index')}}">
							Compras
						</a>
					</li>
				@endif
					<li class="dropdown">
						<a id="Caja" href="#" class="dropdown-toggle" data-toggle="dropdown" 	role="button" aria-expanded="false">
							Caja 
						<span class="caret"></span>
						</a>
						<ul class="dropdown-menu">
							<li>
								<a id="Egresos" href="{{URL::route('egresos.index')}}">
									Egresos 
								</a>
							</li>
							<li>
								<a id="Corte De caja" href="{{URL::route('corteDeCaja.index')}}">
									Corte de caja
								</a>
							</li>
						</ul>
					</li>
					<li class="dropdown">
						<a id="Administracion" href="#" class="dropdown-toggle" data-toggle="dropdown" 	role="button" aria-expanded="false">
							Administracion 
						<span class="caret"></span>
						</a>
						<ul class="dropdown-menu">
							<li>
								<a id="Devoluciones" href="{{URL::route('devoluciones.index')}}">
									Devoluciones
								</a>
							</li>
							<li>
								<a id="Catalogo Productos" href="{{URL::route('productos.index')}}">
									Catalogo Productos
								</a>
							</li>
						@if(Session::get('tipo')=='ADMINISTRADOR' || Session::get('tipo')=='GERENTE GENERAL' || Session::get('tipo')=='GERENTE DE SUCURSAL')
							<li>
								<a id="Transferencias" href="{{URL::route('transferencias.index')}}">
									Transferencias
								</a>
							</li>
							<li>
								<a id="Empleados" href="{{URL::route('empleados.index')}}">
									Empleados
								</a>
							</li>
							<li>
								<a id="Proveedores" href="{{URL::route('proveedores.index')}}">
									Proveedores
								</a>
							</li>
							<li class="dropdown-submenu">
								<a id="Reportes" href="{{URL::to('reportes')}}">
									Reportes
								</a>
							</li>
						@endif
						@if(Session::get('tipo') == 'ADMINISTRADOR' || Session::get('tipo') == 'GERENTE GENERAL')
							<li>
								<a id="Sucursales" href="{{URL::route('sucursales.index')}}">
									Sucursales
								</a>
							</li>
							<li>
								<a id="Categorias de productos" href="{{URL::route('categoriasDeProductos.index')}}">
									Categorias de productos
								</a>
							</li>
							<li>
								<a id="Tipos De Clientes" href="{{URL::route('tiposDeClientes.index')}}">
									Tipos De Clientes
								</a>
							</li>
							<li>
								<a id="Tipos De Empleados" href="{{URL::route('tiposDeEmpleados.index')}}">
									Tipos De Empleados
								</a>
							</li>
							<li>
								<a id="Tipos De Pago" href="{{URL::route('tiposDePagos.index')}}">
									Tipos De Pago
								</a>
							</li>
						@endif
						</ul>
					</li>
				</ul>
				<ul class="nav navbar-nav navbar-right">
					<li>
						<a href="{{URL::to('logout')}}">
							Logout
						</a>
					</li>
				</ul>
				<p class="navbar-text navbar-right">
					<span>Sucursal: {{Session::get('sucursal')}}</span>
					&nbsp;&nbsp;
					Usuario: 
					<a href="#" class="navbar-link">
						{{Session::get('usuario')}}
					</a>
				</p>
			</div><!-- /.navbar-collapse -->
		</div><!-- /.container-fluid -->
	</div>
</nav>