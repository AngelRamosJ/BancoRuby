# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

tamCadMax = 30
tamCadMin = 3
tamCadMaxCorreo = 50
tamCadMaxSalario = 10
edadMin = 6
edadMax = 120


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
	validator = $('#formulario_empleados').validate
		rules:
			'empleado[nombre]':
				required: true
				minlength: tamCadMin
				maxlength: tamCadMax
			'empleado[paterno]':
				required: true
				minlength: tamCadMin
				maxlength: tamCadMax
			'empleado[materno]':
				required: true
				minlength: tamCadMin
				maxlength: tamCadMax
			'empleado[rfc]':
				required: true
				rangelength: [13,13]
				RFC: true
				remote:
					url: '/validar_rfc_empleado'
					type: 'GET'
					datatype: 'JSON'
					dataFilter: (txtResponse) ->
						resultado = $.parseJSON(txtResponse)
						if resultado.validar
							return true
						else
							return false
			'empleado[curp]':
				required: true
				rangelength: [18,18]
				CURP: true
				remote:
					url: '/validar_curp_empleado'
					type: 'GET'
					datatype: 'JSON'
					dataFilter: (txtResponse) ->
						resultado = $.parseJSON(txtResponse)
						if resultado.validar
							return true
						else
							return false
			'empleado[fecha_nacimiento]':
				required: true
			'empleado[correo]':
				required: true
				Correo: true
				maxlength: tamCadMaxCorreo
			'empleado[telefono]':
				required: true
				digits: true
				rangelength: [10,10]
			'empleado[salario]':
				required: true
				maxlength: tamCadMaxSalario
				Numero_Decimal: true
			'empleado[fecha_contratacion]':
				required: true
			'empleado[bono]':
				required: true
				maxlength: tamCadMaxSalario
				Numero_Decimal: true
			'empleado[descuento]':
				required: true
				maxlength: tamCadMaxSalario
				Numero_Decimal: true
			'empleado[prestacion_dinero]':
				required: true
			'empleado[localidad_id]':
				required: true
			'empleado[departamento_id]':
				required: true
			'empleado[trabajo_id]':
				required: true
			'empleado[login]':
				required: true
				remote:
					url: '/validar_login_empleado'
					type: 'GET'
					datatype: 'JSON'
					dataFilter: (txtResponse) ->
						resultado = $.parseJSON(txtResponse)
						if resultado.validar
							return true
						else
							return false
			'empleado[password]':
				required: true
				Password_Mayuscula: true
				Password_Caracter_Especial: true
				Password_Numero: true
		messages:
			'empleado[nombre]':
				required: 'Nombre Requerido'
				minlength: 'El minimo de caracteres es ' + tamCadMin
				maxlength: 'El maximo de caracteres es ' + tamCadMax
			'empleado[paterno]':
				required: 'Apellido Paterno Requerdio'
				minlength: 'El minimo de caracteres es ' + tamCadMin
				maxlength: 'El maximo de caracteres es ' + tamCadMax
			'empleado[materno]':
				required: 'Apellido Materno Requerido'
				minlength: 'El minimo de caracteres es ' + tamCadMin
				maxlength: 'El maximo de caracteres es ' + tamCadMax
			'empleado[rfc]':
				required: 'RFC Requerido'
				rangelength: 'El RFC debe ser de 13 caracteres'
				remote: 'El Empleado con ese RFC ya existe'
			'empleado[curp]':
				required: 'CURP Requerida'
				rangelength: 'La CURP debe ser de 18 caracteres'
				remote: 'El Empleado con esa CURP ya existe'
			'empleado[fecha_nacimiento]':
				required: 'Fecha de Nacimiento Requerida'
			'empleado[correo]':
				required: 'Correo Requerido'
				maxlength: 'El maximo de caracteres es ' + tamCadMaxCorreo
			'empleado[telefono]':
				required: 'Telefono Requerido'
				digits: 'Telefono Invalido, solo Numeros'
				rangelength: 'El Telefono debe ser de 10 caracteres'
			'empleado[salario]':
				required: 'Salario Requerido'
				maxlength: 'El máximo de caracteres es ' + tamCadMaxSalario
			'empleado[fecha_contratacion]':
				required: 'Fecha de Contratación Requerida'
			'empleado[bono]':
				required: 'Bonos Requeridos'
				maxlength: 'El máximo de caracteres es ' + tamCadMaxSalario
			'empleado[descuento]':
				required: 'Descuentos Requeridos'
				maxlength: 'El máximo de caracteres es ' + tamCadMaxSalario
			'empleado[prestacion_dinero]':
				required: 'Respuesta a Presntación de Dinero Requerida'
			'empleado[localidad_id]':
				required: 'Localidad Requerida'
			'empleado[departamento_id]':
				required: 'Departamento Requerido'
			'empleado[trabajo_id]':
				required: 'Trabajo Requerido'
			'empleado[login]':
				required: 'Usuario Requerido'
				remote: 'El Empleado con ese Usuario ya existe'
			'empleado[password]':
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
	validator = $('#formulario_empleados_editar').validate
		rules:
			'empleado[nombre]':
				required: true
				minlength: tamCadMin
				maxlength: tamCadMax
			'empleado[paterno]':
				required: true
				minlength: tamCadMin
				maxlength: tamCadMax
			'empleado[materno]':
				required: true
				minlength: tamCadMin
				maxlength: tamCadMax
			'empleado[rfc]':
				required: true
				rangelength: [13,13]
				RFC: true
			'empleado[curp]':
				required: true
				rangelength: [18,18]
				CURP: true

			'empleado[fecha_nacimiento]':
				required: true
			'empleado[correo]':
				required: true
				Correo: true
				maxlength: tamCadMaxCorreo
			'empleado[telefono]':
				required: true
				digits: true
				rangelength: [10,10]
			'empleado[salario]':
				required: true
				maxlength: tamCadMaxSalario
				Numero_Decimal: true
			'empleado[fecha_contratacion]':
				required: true
			'empleado[bono]':
				required: true
				maxlength: tamCadMaxSalario
				Numero_Decimal: true
			'empleado[descuento]':
				required: true
				maxlength: tamCadMaxSalario
				Numero_Decimal: true
			'empleado[prestacion_dinero]':
				required: true
			'empleado[localidad_id]':
				required: true
			'empleado[departamento_id]':
				required: true
			'empleado[trabajo_id]':
				required: true
			'empleado[login]':
				required: true
			'empleado[password]':
				required: true
				Password_Mayuscula: true
				Password_Caracter_Especial: true
				Password_Numero: true
		messages:
			'empleado[nombre]':
				required: 'Nombre Requerido'
				minlength: 'El minimo de caracteres es ' + tamCadMin
				maxlength: 'El maximo de caracteres es ' + tamCadMax
			'empleado[paterno]':
				required: 'Apellido Paterno Requerdio'
				minlength: 'El minimo de caracteres es ' + tamCadMin
				maxlength: 'El maximo de caracteres es ' + tamCadMax
			'empleado[materno]':
				required: 'Apellido Materno Requerido'
				minlength: 'El minimo de caracteres es ' + tamCadMin
				maxlength: 'El maximo de caracteres es ' + tamCadMax
			'empleado[rfc]':
				required: 'RFC Requerido'
				rangelength: 'El RFC debe ser de 13 caracteres'
			'empleado[curp]':
				required: 'CURP Requerida'
				rangelength: 'La CURP debe ser de 18 caracteres'
			'empleado[fecha_nacimiento]':
				required: 'Fecha de Nacimiento Requerida'
			'empleado[correo]':
				required: 'Correo Requerido'
				maxlength: 'El maximo de caracteres es ' + tamCadMaxCorreo
			'empleado[telefono]':
				required: 'Telefono Requerido'
				digits: 'Telefono Invalido, solo Numeros'
				rangelength: 'El Telefono debe ser de 10 caracteres'
			'empleado[salario]':
				required: 'Salario Requerido'
				maxlength: 'El maximo de caracteres es ' + tamCadMaxSalario
			'empleado[fecha_contratacion]':
				required: 'Fecha de Contratación Requerida'
			'empleado[bono]':
				required: 'Bonos Requeridos'
				maxlength: 'El máximo de caracteres es ' + tamCadMaxSalario
			'empleado[descuento]':
				required: 'Descuentos Requeridos'
				maxlength: 'El máximo de caracteres es ' + tamCadMaxSalario
			'empleado[prestacion_dinero]':
				required: 'Respuesta a Presntación de Dinero Requerida'
			'empleado[localidad_id]':
				required: 'Localidad Requerida'
			'empleado[departamento_id]':
				required: 'Departamento Requerido'
			'empleado[trabajo_id]':
				required: 'Trabajo Requerido'
			'empleado[login]':
				required: 'Usuario Requerido'
			'empleado[password]':
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

