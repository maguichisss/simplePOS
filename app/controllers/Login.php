<?php

class Login extends BaseController {

	public function postUser(){

		//columnas en la tabla de la base que usaremos para autenticar
		$datosUsuario = array(
			'username' => Input::get('username'),
			'password' => Input::get('password')		
		);
		
		if (Auth::attempt($datosUsuario)){
		//logeo correcto
			//obetenemos el tipo de usuario y redireccionamos
			return Redirect::to('inicio');
					

		}else{
		//logeo incorrecto
			Session::flash('message', 'Usuario o contraseña incorrectos!');
			Session::flash('class', 'danger');
			//redirige a login
			return Redirect::to('login');
		}

	}
}