# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/


tamCadMinDesc = 10
tamCadMaxDesc = 50
tamCadMaxDecimales = 10
tamCadMaxInteres = 5
tiempoMin = 1
tiempoMax = 90

$.validator.addMethod(
	'Numero_Decimal'

	(value,element) -> if value != '' then new RegExp("^[0-9]{1,7}(\.[0-9]{1,2})?$").test(value) else false

	'Numero Decimal Invalido (como máximo 2 decimales)'

)

$.validator.addMethod(
	'Numero_Interes'

	(value,element) -> if value != '' then new RegExp("^[0-9]{1,7}\.[0-9]{1,2}$").test(value) else false

	'Numero Decimal Invalido (como máximo 2 decimales). Ejemplo: 8.5'

)


ready = -> 
	validator = $('#formulario_prestamos').validate
		rules:
			'prestamo[descripcion]':
				required: true
				minlength: tamCadMinDesc
				maxlength: tamCadMaxDesc
			'prestamo[cantidad]':
				required: true
				maxlength: tamCadMaxDecimales
				Numero_Decimal: true
			'prestamo[intereses]':
				required: true
				maxlength: tamCadMaxInteres
				Numero_Interes: true
			'prestamo[fecha_expedicion]':
				required: true
			'prestamo[fecha_termino]':
				required: true
			'prestamo[tiempo_tolerancia]':
				required: true
				min: tiempoMin
				max: tiempoMax
			'prestamo[modo_pago]':
				required: true
			'prestamo[estado]':
				required: true
			'prestamo[cliente_id]':
				required: true
			
		messages:
			'prestamo[descripcion]':
				required: 'Descripción Requerida'
				minlength: 'El mínimo de carácteres es ' + tamCadMinDesc
				maxlength: 'El máximo de carácteres es ' + tamCadMaxDesc
			'prestamo[cantidad]':
				required: 'Cantidad Requerida'
				maxlength: 'El máximo de carácteres es ' + tamCadMaxDecimales
			'prestamo[intereses]':
				required: 'Interéses Requeridos'
				maxlength: 'El máximo de carácteres es ' + tamCadMaxInteres
			'prestamo[fecha_expedicion]':
				required: 'Fecha de Expedición Requerida'
			'prestamo[fecha_termino]':
				required: 'Fecha de Termino Requerida'
			'prestamo[tiempo_tolerancia]':
				required: 'Días de Tolerancia Requeridos'
				min: tiempoMin + ' día mínimo'
				max: tiempoMax + ' días máximo'
			'prestamo[modo_pago]':
				required: 'Modo de Pago Requerido'
			'prestamo[estado]':
				required: 'Estado del Préstamos Requerido'
			'prestamo[cliente_id]':
				required: 'Cliente Requerido'
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