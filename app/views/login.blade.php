<!DOCTYPE html>
<html lang="en">
<head>
	<meta charset="utf-8" />
	<title>Ingresa</title>
	<meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1"/>
	<link rel="icon" type="image/png" href="{{ asset('muscle2.png') }}" />
	<!-- Latest compiled and minified CSS -->
	<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.2/css/bootstrap.min.css"/>
	<!-- Optional theme -->
	<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.2/css/bootstrap-theme.min.css"/>
	<script src="http://code.jquery.com/jquery-1.11.2.min.js"></script>
	<script>
		$(function(){
			var $form_inputs =   $('form input');
			var $rainbow_and_border = $('.rain, .border');
			/* Used to provide loping animations in fallback mode */
			$form_inputs.bind('focus', function(){
				$rainbow_and_border.addClass('end').removeClass('unfocus start');
			});
			$form_inputs.bind('blur', function(){
				$rainbow_and_border.addClass('unfocus start').removeClass('end');
			});
			$form_inputs.first().delay(800).queue(function() {
				$(this).focus();
			});
		});
	</script>
	<style>
		body{
			/* background: #000;*/
			color: #DDD;
			font-family: 'Helvetica', 'Lucida Grande', 'Arial', sans-serif;
			background: url( {{ 
								$a='images/muscleLogin'.rand(1, 12).'.jpg'; 
								asset($a) 
							}} ) no-repeat center center fixed; 
			-webkit-background-size: cover;
			-moz-background-size: cover;
			-o-background-size: cover;
			background-size: cover;
		}
		.border,
		.rain{
			height: 210px;
		}
		/* Layout with mask */
		.rain{
			-moz-box-shadow: 10px 10px 10px rgba(0,0,0,1) inset, -9px -9px 8px rgba(0,0,0,1) inset;
			-webkit-box-shadow: 8px 8px 8px rgba(0,0,0,1) inset, -9px -9px 8px rgba(0,0,0,1) inset;
			box-shadow: 8px 8px 8px rgba(0,0,0,1) inset, -9px -9px 8px rgba(0,0,0,1) inset;
			margin: 100px auto;
		}
		/* Artifical "border" to clear border to bypass mask */
		.border{
			padding: 1px;
			-moz-border-radius: 5px;
			-webkit-border-radius: 5px;
			border-radius: 5px;
		}

		.border,
		.rain,
		.border.start,
		.rain.start{
			background-repeat: repeat-x, repeat-x, repeat-x, repeat-x;
			background-position: 0 0, 0 0, 0 0, 0 0;
			/* Blue-ish Green Fallback for Mozilla */
			background-image: -moz-linear-gradient(left, #09BA5E 0%, #00C7CE 15%, #3472CF 26%, #00C7CE 48%, #0CCF91 91%, #09BA5E 100%);
			/* Add "Highlight" Texture to the Animation */
			background-image: -webkit-gradient(linear, left top, right top, color-stop(1%,rgba(0,0,0,.3)), color-stop(23%,rgba(0,0,0,.1)), color-stop(40%,rgba(255,231,87,.1)), color-stop(61%,rgba(255,231,87,.2)), color-stop(70%,rgba(255,231,87,.1)), color-stop(80%,rgba(0,0,0,.1)), color-stop(100%,rgba(0,0,0,.25)));
			/* Starting Color */
			background-color: #39f;
			/* Just do something for IE-suck */
			filter: progid:DXImageTransform.Microsoft.gradient( startColorstr='#00BA1B', endColorstr='#00BA1B',GradientType=1 );
		}

		/* Non-keyframe fallback animation */
		.border.end,
		.rain.end{
			-moz-transition-property: background-position;  
			-moz-transition-duration: 30s;
			-moz-transition-timing-function: linear;
			-webkit-transition-property: background-position;  
			-webkit-transition-duration: 30s;  
			-webkit-transition-timing-function: linear;
			-o-transition-property: background-position;  
			-o-transition-duration: 30s;  
			-o-transition-timing-function: linear;
			transition-property: background-position;  
			transition-duration: 30s;  
			transition-timing-function: linear;
			background-position: -5400px 0, -4600px 0, -3800px 0, -3000px 0;	
		}

		/* Keyfram-licious animation */
		@-webkit-keyframes colors {
			0% {background-color: #39f;}
			15% {background-color: #F246C9;}
			30% {background-color: #4453F2;}
			45% {background-color: #44F262;}
			60% {background-color: #F257D4;}
			75% {background-color: #EDF255;}
			90% {background-color: #F20006;}
			100% {background-color: #39f;}
		}
		.border,.rain{
			-webkit-animation-direction: normal;
			-webkit-animation-duration: 20s;
			-webkit-animation-iteration-count: infinite;
			-webkit-animation-name: colors;
			-webkit-animation-timing-function: ease;
		}

		/* In-Active State Style */
		.border.unfocus{
			background: #333 !important;	
			-moz-box-shadow: 0px 0px 15px rgba(255,255,255,.2);
			-webkit-box-shadow: 0px 0px 15px rgba(255,255,255,.2);
			box-shadow: 0px 0px 15px rgba(255,255,255,.2);
			-webkit-animation-name: none;
		}
		.rain.unfocus{
			background: #000 !important;	
			-webkit-animation-name: none;
		}

		/* Regular Form Styles */
		form{
			background: #212121;
			-moz-border-radius: 5px;
			-webkit-border-radius: 5px;
			border-radius: 5px;
			height: 100%;
			width: 100%;
			background: -moz-radial-gradient(50% 46% 90deg,circle closest-corner, #242424, #090909);
			background: -webkit-gradient(radial, 50% 50%, 0, 50% 50%, 150, from(#242424), to(#090909));
		}
		form label{
			display: block;
			padding: 10px 10px 5px 15px;
			font-size: 11px;
			color: #777;
		}
		form input{
			display: block;
			margin: 5px 10px 10px 15px;
			width: 85%;
			background: #111;
			-moz-box-shadow: 0px 0px 4px #000 inset;
			-webkit-box-shadow: 0px 0px 4px #000 inset;
			box-shadow: 0px 0px 4px #000 inset;
			outline: 1px solid #333;
			border: 1px solid #000;
			padding: 5px;
			color: #aaa;
			font-size: 16px;
		}
		form input:focus{
			outline: 1px solid #555;
			color: #FFF;
		}
		input[type="submit"]{
			width: 99%;
			color: #ccc;
			margin: 20px 0;
			margin-left: 1px;
			background: #45484d;
			background: -moz-linear-gradient(top, #222 0%, #111 100%);
			background: -webkit-gradient(linear, left top, left bottom, color-stop(0%,#222), color-stop(100%,#111));
			filter: progid:DXImageTransform.Microsoft.gradient( startColorstr='#22222', endColorstr='#11111',GradientType=0 );
			-moz-box-shadow: 0px 1px 1px #000, 0px 1px 0px rgba(255,255,255,.3) inset;
			-webkit-box-shadow: 0px 1px 1px #000, 0px 1px 0px rgba(255,255,255,.3) inset;
			box-shadow: 0px 1px 1px #000,0px 1px 0px rgba(255,255,255,.3) inset;
			text-shadow: 0 1px 1px #000;
		}
	</style>
</head>
<body id="home">
	<div class="container">
		<div class="row">
			<div class="col-sm-4">
			</div>
			<div class="col-sm-4">
				<div class="rain">
					<div class="border start">
						<form action="" method="post">
							<label for="username">Usuario</label>
							<input name="username" type="text" placeholder="Usuario" required autofocus/>
							<label for="password">Password</label>
							<input name="password" type="password" placeholder="Password" required />
							<input type="submit" value="Ingresar"/>
						</form>
						@if(Session::has('message'))
							<div class="alert alert-{{ Session::get('class')}}">
								{{ Session::get('message') }} 
							</div>
						@endif
					</div>
				</div>
			</div>
			<div class="col-sm-4">
			</div>

		</div>
	</div>
</body>
</html>