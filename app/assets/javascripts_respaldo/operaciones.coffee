# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

tamCadMaxDecimales = 7


$.validator.addMethod(
	'Numero_Decimal'

	(value,element) -> if value != '' then new RegExp("^[0-9]{1,7}\.[0-9]{1,2}$").test(value) else false

	'Numero Decimal Invalido (como máximo 2 decimales). Ejemplo: 999.99'

)

ready = -> 
	validator = $('#formulario_transferir').validate
		rules:
			'eleccion':
				required: true
			'cuenta[clabe_origen]':
				required: true	
			'clabe_destino':
				required: true
				digits: true
				rangelength: [18,18]
				remote:
					url: '/validar_clabe'
					type: 'GET'
					datatype: 'JSON'
					dataFilter: (txtResponse) ->
						resultado = $.parseJSON(txtResponse)
						if resultado.validar
							return true
						else
							return false
			'cuenta[tarjeta_origen]':
				required: true
			'tarjeta_destino':
				required: true
				digits: true
				rangelength: [16,16]
				remote:
					url: '/validar_tarjeta'
					type: 'GET'
					datatype: 'JSON'
					dataFilter: (txtResponse) ->
						resultado = $.parseJSON(txtResponse)
						if resultado.validar
							return true
						else
							return false
				
			'monto':
				required: true	
				maxlength: tamCadMaxDecimales
				Numero_Decimal: true
		messages:
			'eleccion':
				required: 'Elección Requerida'
			'cuenta[clabe_origen]':
				required: 'CLABE de Cuenta Origen Requerida'
			'clabe_destino':
				required: 'CLABE de Cuenta Destino Requerida'
				digits: 'Solo se aceptan números'
				rangelength: 'La CLABE debe de ser de 18 carácteres'
				remote: 'La Cuenta con esa CLABE no existe'
			'cuenta[tarjeta_origen]':
				required: 'Número de Tarjeta de Cuenta Origen Requerido'
			'tarjeta_destino':
				required: 'Número de Tarjeta de Cuenta Destino Requerido'
				digits: 'Solo se aceptan números'
				rangelength: 'El Número de Tarjeta debe de ser de 16 carácteres'
				remote: 'La Cuenta con ese Número de Tarjeta no existe'
			'monto':
				required: 'Monto Requerido'
				maxlength: 'El máximo de carácteres es ' + tamCadMaxDecimales
			
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
	validator = $('#formulario_depositar').validate
		rules:
			'eleccion':
				required: true
			'cuenta[clabe]':
				required: true	
			'cuenta[tarjeta]':
				required: true
			'monto':
				required: true	
				maxlength: tamCadMaxDecimales
				Numero_Decimal: true
		messages:
			'eleccion':
				required: 'Elección Requerida'
			'cuenta[clabe]':
				required: 'CLABE de Cuenta Requerida'
			'cuenta[tarjeta]':
				required: 'Número de Tarjeta de Cuenta Requerido'
			'monto':
				required: 'Monto Requerido'
				maxlength: 'El máximo de carácteres es ' + tamCadMaxDecimales
			
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

ready3 = -> 
	validator = $('#formulario_consultar').validate
		rules:
			'eleccion':
				required: true
			'debito':
				required: true	
			'ahorro':
				required: true
			'mes':
				required: true	
		messages:
			'eleccion':
				required: 'Elección Requerida'
			'debito':
				required: 'Cuenta de Débito Requerida'
			'ahorro':
				required: 'Cuenta de Ahorro Requerida'
			'mes':
				required: 'Mes Requerido'

			
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

$(document).ready(ready3)
$(document).on('turbolinks:load',ready3) 

ready4 = -> 
	clabe_click = $('#eleccion_C').click ->
		$('.inputs_clabe').removeClass('d-none')
		$('.inputs_tarjeta').addClass('d-none')
		return

$(document).ready(ready4)
$(document).on('turbolinks:load',ready4) 

ready5 = -> 
	tarjeta_click = $('#eleccion_T').click ->
		$('.inputs_tarjeta').removeClass('d-none')
		$('.inputs_clabe').addClass('d-none')
		return

$(document).ready(ready5)
$(document).on('turbolinks:load',ready5) 

ready6 = -> 
	ahorro_click = $('#eleccion_D').click ->
		$('.input_debito').removeClass('d-none')
		$('.input_ahorro').addClass('d-none')
		$('.input_mes').removeClass('d-none')
		return

$(document).ready(ready6)
$(document).on('turbolinks:load',ready6) 

ready7 = -> 
	ahorro_click = $('#eleccion_A').click ->
		$('.input_debito').addClass('d-none')
		$('.input_ahorro').removeClass('d-none')
		$('.input_mes').removeClass('d-none')
		return

$(document).ready(ready7)
$(document).on('turbolinks:load',ready7) 

