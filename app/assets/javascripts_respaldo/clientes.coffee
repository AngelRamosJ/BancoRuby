# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

tamCadMax = 30
tamCadMin = 3
tamCadMaxCorreo = 50
tamCadMaxSalario = 10
edadMin = 6
edadMax = 120
tiempoMin = 0
tiempoMax = 60

$.validator.addMethod(
	'RFC'

	(value,element) -> if value != '' then new RegExp("^[A-ZÑ&]{3,4}[0-9]{6}(?:[A-Z0-9]{3})?$").test(value) else false

	'Ingrese un RFC valido'

)

$.validator.addMethod(
	'CURP'

	(value,element) -> if value != '' then new RegExp("[A-Z]{4}[0-9]{6}[A-Z]{7}[0-9]").test(value) else false

	'Ingrese un CURP valido'

)

$.validator.addMethod(
	'Correo'

	(value,element) -> if value != '' then new RegExp("[a-zA-Z0-9-._]+@[a-zA-Z0-9-._]+[.]{1}[a-z]{2,4}").test(value) else false

	'Correo INvalido, usa el formato angel_5@gmail.com'

)

$.validator.addMethod(
	'Password_Mayuscula'

	(value,element) -> if value != '' then new RegExp("[A-Z]").test(value) else false

	'La Contraseña debe tener una Mayuscula'

)

$.validator.addMethod(
	'Password_Caracter_Especial'

	(value,element) -> if value != '' then new RegExp("[^A-Za-z0-9]").test(value) else false

	'La Contraseña debe tener un Caracter Especial'

)

$.validator.addMethod(
	'Password_Numero'

	(value,element) -> if value != '' then new RegExp("[0-9]").test(value) else false

	'La Contraseña debe tener un Numero'

)


$.validator.addMethod(
	'Hora'

	(value,element) -> if value != '' then new RegExp("([01]?[0-9]|2[0-3]):[0-5][0-9]").test(value) else false

	'Ingrese una Hora valida'

)

$.validator.addMethod(
	'Numero_Decimal'

	(value,element) -> if value != '' then new RegExp("^[0-9]{1,7}(\.[0-9]{1,2})?$").test(value) else false

	'Numero Decimal Invalido (como máximo 2 decimales)'

)


ready = -> 
	validator = $('#formulario_clientes').validate
		rules:
			'cliente[nombre]':
				required: true
				minlength: tamCadMin
				maxlength: tamCadMax
			'cliente[paterno]':
				required: true
				minlength: tamCadMin
				maxlength: tamCadMax
			'cliente[materno]':
				required: true
				minlength: tamCadMin
				maxlength: tamCadMax
			'cliente[rfc]':
				required: true
				rangelength: [13,13]
				RFC: true
				remote:
					url: '/validar_rfc_cliente'
					type: 'GET'
					datatype: 'JSON'
					dataFilter: (txtResponse) ->
						resultado = $.parseJSON(txtResponse)
						if resultado.validar
							return true
						else
							return false
			'cliente[curp]':
				required: true
				rangelength: [18,18]
				CURP: true
				remote:
					url: '/validar_curp_cliente'
					type: 'GET'
					datatype: 'JSON'
					dataFilter: (txtResponse) ->
						resultado = $.parseJSON(txtResponse)
						if resultado.validar
							return true
						else
							return false
			'cliente[fecha_nacimiento]':
				required: true
			'cliente[correo]':
				required: true
				Correo: true
				maxlength: tamCadMaxCorreo
			'cliente[telefono]':
				required: true
				digits: true
				rangelength: [10,10]
			'cliente[estado_laboral]':
				required: true
			'cliente[salario_mensual]':
				required: true
				maxlength: tamCadMaxSalario
				Numero_Decimal: true
			'cliente[estudio]':
				required: true
				minlength: tamCadMin
				maxlength: tamCadMax
			'cliente[tiempo_laboral]':
				required: true
				digits: true
				min: tiempoMin
				max: tiempoMax
			'cliente[riesgo_trabajo]':
				required: true
			'cliente[localidad_id]':
				required: true
			'cliente[login]':
				required: true
				remote:
					url: '/validar_login_cliente'
					type: 'GET'
					datatype: 'JSON'
					dataFilter: (txtResponse) ->
						resultado = $.parseJSON(txtResponse)
						if resultado.validar
							return true
						else
							return false
			'cliente[password]':
				required: true
				Password_Mayuscula: true
				Password_Caracter_Especial: true
				Password_Numero: true
		messages:
			'cliente[nombre]':
				required: 'Nombre Requerido'
				minlength: 'El minimo de caracteres es ' + tamCadMin
				maxlength: 'El maximo de caracteres es ' + tamCadMax
			'cliente[paterno]':
				required: 'Apellido Paterno Requerdio'
				minlength: 'El minimo de caracteres es ' + tamCadMin
				maxlength: 'El maximo de caracteres es ' + tamCadMax
			'cliente[materno]':
				required: 'Apellido Materno Requerido'
				minlength: 'El minimo de caracteres es ' + tamCadMin
				maxlength: 'El maximo de caracteres es ' + tamCadMax
			'cliente[rfc]':
				required: 'RFC Requerido'
				rangelength: 'El RFC debe ser de 13 caracteres'
				remote: 'El Empleado con ese RFC ya existe'
			'cliente[curp]':
				required: 'CURP Requerida'
				rangelength: 'La CURP debe ser de 18 caracteres'
				remote: 'El Empleado con esa CURP ya existe'
			'cliente[fecha_nacimiento]':
				required: 'Fecha de Nacimiento Requerida'
			'cliente[correo]':
				required: 'Correo Requerido'
				maxlength: 'El maximo de caracteres es ' + tamCadMaxCorreo
			'cliente[telefono]':
				required: 'Telefono Requerido'
				digits: 'Telefono Invalido, solo Numeros'
				rangelength: 'El Telefono debe ser de 10 caracteres'
			'cliente[estado_laboral]':
				required: 'Estado Laboral Requerido'
			'cliente[salario_mensual]':
				required: 'Salario Mensual Requerido'
				maxlength: 'El máximo de carácteres es ' + tamCadMaxSalario
			'cliente[estudio]':
				required: 'Estudio Requerido'
				minlength: 'El mínimo de caracteres es ' + tamCadMin
				maxlength: 'El máximo de carácteres es ' + tamCadMax
			'cliente[tiempo_laboral]':
				required: 'Años Laborales Requeridos'
				digits: 'Solo se permiten números'
				min: tiempoMin + ' año mínimo'
				max: tiempoMax + ' año máximo'
			'cliente[riesgo_trabajo]':
				required: 'Respuesta a Riesgo Laboral Requerida'
			'cliente[localidad_id]':
				required: 'Localidad Requerida'
			'cliente[login]':
				required: 'Usuario Requerido'
				remote: 'El Empleado con ese Usuario ya existe'
			'cliente[password]':
				required: 'Contraseña Requerida'
		errorPlacement: 
			(error,element) ->
				if element.is(":radio")
					error.appendTo(element.parents('.padre_radio').children('.etiqueta-error').children('span'))
				else		
					error.appendTo(element.siblings('div').children('span'))
				return

		errorElement : "span"
		highlight: 
			( element, errorClass, validClass ) ->
				
				$( element ).addClass( "tiene-error" ).removeClass( "success" )
				$( element ).siblings('div').addClass("mostrar_error").removeClass("ocultar_error")
				$( element ).siblings('div').children('img').addClass("mostrar_error").removeClass("ocultar_error")
				$( element ).parents('.padre_radio').children('.etiqueta-error').addClass("mostrar_error").removeClass("ocultar_error")
				$( element ).parents('.padre_radio').children('.etiqueta-error').children('img').addClass("mostrar_error").removeClass("ocultar_error")
				return
		unhighlight:
			( element, errorClass, validClass ) ->

				$( element ).addClass( "success" ).removeClass( "tiene-error" )
				$( element ).siblings('div').addClass("ocultar_error").removeClass("mostrar_error")
				$( element ).siblings('div').children('img').addClass("ocultar_error").removeClass("mostrar_error")
				$( element ).parents('.padre_radio').children('.etiqueta-error').addClass("ocultar_error").removeClass("mostrar_error")
				$( element ).parents('.padre_radio').children('.etiqueta-error').children('img').addClass("ocultar_error").removeClass("mostrar_error")
				return

$(document).ready(ready)
$(document).on('turbolinks:load',ready) 

ready2 = -> 
	validator = $('#formulario_clientes_editar').validate
		rules:
			'cliente[nombre]':
				required: true
				minlength: tamCadMin
				maxlength: tamCadMax
			'cliente[paterno]':
				required: true
				minlength: tamCadMin
				maxlength: tamCadMax
			'cliente[materno]':
				required: true
				minlength: tamCadMin
				maxlength: tamCadMax
			'cliente[rfc]':
				required: true
				rangelength: [13,13]
				RFC: true
			'cliente[curp]':
				required: true
				rangelength: [18,18]
				CURP: true
			'cliente[fecha_nacimiento]':
				required: true
			'cliente[correo]':
				required: true
				Correo: true
				maxlength: tamCadMaxCorreo
			'cliente[telefono]':
				required: true
				digits: true
				rangelength: [10,10]
			'cliente[estado_laboral]':
				required: true
			'cliente[salario_mensual]':
				required: true
				maxlength: tamCadMaxSalario
				Numero_Decimal: true
			'cliente[estudio]':
				required: true
				minlength: tamCadMin
				maxlength: tamCadMax
			'cliente[tiempo_laboral]':
				required: true
				digits: true
				min: tiempoMin
				max: tiempoMax
			'cliente[riesgo_trabajo]':
				required: true
			'cliente[localidad_id]':
				required: true
			'cliente[login]':
				required: true
			'cliente[password]':
				required: true
				Password_Mayuscula: true
				Password_Caracter_Especial: true
				Password_Numero: true
		messages:
			'cliente[nombre]':
				required: 'Nombre Requerido'
				minlength: 'El minimo de caracteres es ' + tamCadMin
				maxlength: 'El maximo de caracteres es ' + tamCadMax
			'cliente[paterno]':
				required: 'Apellido Paterno Requerdio'
				minlength: 'El minimo de caracteres es ' + tamCadMin
				maxlength: 'El maximo de caracteres es ' + tamCadMax
			'cliente[materno]':
				required: 'Apellido Materno Requerido'
				minlength: 'El minimo de caracteres es ' + tamCadMin
				maxlength: 'El maximo de caracteres es ' + tamCadMax
			'cliente[rfc]':
				required: 'RFC Requerido'
				rangelength: 'El RFC debe ser de 13 caracteres'
			'cliente[curp]':
				required: 'CURP Requerida'
				rangelength: 'La CURP debe ser de 18 caracteres'
			'cliente[fecha_nacimiento]':
				required: 'Fecha de Nacimiento Requerida'
			'empleado[correo]':
				required: 'Correo Requerido'
				maxlength: 'El maximo de caracteres es ' + tamCadMaxCorreo
			'cliente[telefono]':
				required: 'Telefono Requerido'
				digits: 'Telefono Invalido, solo Numeros'
				rangelength: 'El Telefono debe ser de 10 caracteres'
			'cliente[estado_laboral]':
				required: 'Estado Laboral Requerido'
			'cliente[salario_mensual]':
				required: 'Salario Mensual Requerido'
				maxlength: 'El máximo de carácteres es ' + tamCadMaxSalario
			'cliente[estudio]':
				required: 'Estudio Requerido'
				minlength: 'El mínimo de caracteres es ' + tamCadMin
				maxlength: 'El máximo de carácteres es ' + tamCadMax
			'cliente[tiempo_laboral]':
				required: 'Años Laborales Requeridos'
				digits: 'Solo se permiten números'
				min: tiempoMin + ' año mínimo'
				max: tiempoMax + ' año máximo'
			'cliente[riesgo_trabajo]':
				required: 'Respuesta a Riesgo Laboral Requerida'
			'cliente[localidad_id]':
				required: 'Localidad Requerida'
			'cliente[login]':
				required: 'Usuario Requerido'
			'cliente[password]':
				required: 'Contraseña Requerida'
		errorPlacement: 
			(error,element) ->
				if element.is(":radio")
					error.appendTo(element.parents('.padre_radio').children('.etiqueta-error').children('span'))
				else		
					error.appendTo(element.siblings('div').children('span'))
				return

		errorElement : "span"
		highlight: 
			( element, errorClass, validClass ) ->
				
				$( element ).addClass( "tiene-error" ).removeClass( "success" )
				$( element ).siblings('div').addClass("mostrar_error").removeClass("ocultar_error")
				$( element ).siblings('div').children('img').addClass("mostrar_error").removeClass("ocultar_error")
				$( element ).parents('.padre_radio').children('.etiqueta-error').addClass("mostrar_error").removeClass("ocultar_error")
				$( element ).parents('.padre_radio').children('.etiqueta-error').children('img').addClass("mostrar_error").removeClass("ocultar_error")
				return
		unhighlight:
			( element, errorClass, validClass ) ->

				$( element ).addClass( "success" ).removeClass( "tiene-error" )
				$( element ).siblings('div').addClass("ocultar_error").removeClass("mostrar_error")
				$( element ).siblings('div').children('img').addClass("ocultar_error").removeClass("mostrar_error")
				$( element ).parents('.padre_radio').children('.etiqueta-error').addClass("ocultar_error").removeClass("mostrar_error")
				$( element ).parents('.padre_radio').children('.etiqueta-error').children('img').addClass("ocultar_error").removeClass("mostrar_error")
				return

$(document).ready(ready2)
$(document).on('turbolinks:load',ready2) 


