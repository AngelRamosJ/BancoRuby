# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

tamCadMaxDecimales = 10
tamCadMaxInteres = 5
mesesMin = 1
mesesMax = 60



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

$.validator.addMethod(
	'Numero_Interes'

	(value,element) -> if value != '' then new RegExp("^[0-9]{1,7}\.[0-9]{1,2}$").test(value) else false

	'Numero Decimal Invalido (como máximo 2 decimales). Ejemplo: 8.5'

)

$.validator.addMethod(
	'Numero_Descuento'

	(value,element) -> if value != '' then new RegExp("^[0-9]{1,7}\.[0-9]{2}$").test(value) else false

	'Numero Decimal Invalido (con 2 decimales). Ejemplo: 50.00'

)


ready = -> 
	validator = $('#formulario_ahorros').validate
		rules:
			'ahorro[clabe]':
				required: true
				rangelength: [18,18]
				digits: true
				remote:
					url: '/validar_clabe_ahorro'
					type: 'GET'
					datatype: 'JSON'
					dataFilter: (txtResponse) ->
						resultado = $.parseJSON(txtResponse)
						if resultado.validar
							return true
						else
							return false
			'ahorro[numero_tarjeta]':
				required: true
				rangelength: [16,16]
				digits: true
				remote:
					url: '/validar_tarjeta_ahorro'
					type: 'GET'
					datatype: 'JSON'
					dataFilter: (txtResponse) ->
						resultado = $.parseJSON(txtResponse)
						if resultado.validar
							return true
						else
							return false
			'ahorro[monto]':
				required: true
				maxlength: tamCadMaxDecimales
				Numero_Decimal: true
			'ahorro[monto_maximo]':
				required: true
				maxlength: tamCadMaxDecimales
				Numero_Decimal: true
			'ahorro[estado]':
				required: true
			'ahorro[fecha_creacion]':
				required: true
			'ahorro[interes]':
				required: true
				maxlength: tamCadMaxInteres
				Numero_Interes: true
			'ahorro[impuesto_anual]':
				required: true
				maxlength: tamCadMaxDecimales
				Numero_Decimal: true
			'ahorro[descuento_transaccion]':
				required: true
				maxlength: tamCadMaxDecimales
				Numero_Descuento: true
			'ahorro[meses_cambio]':
				required: true
				min: mesesMin
				max: mesesMax
			'ahorro[limite_monto_transaccion]':
				required: true
				maxlength: tamCadMaxDecimales
				Numero_Decimal: true
			'ahorro[cliente_id]':
				required: true
		messages:
			'ahorro[clabe]':
				required: 'CLABE Requerida'
				rangelength: 'La CLABE debe ser de 18 carácteres'
				digits: 'Solo se permiten números'
				remote: 'La CLABE ya existe en otra Cuenta'
			'ahorro[numero_tarjeta]':
				required: 'Número de Tarjeta Requerido'
				rangelength: 'El Número de Tarjeta debe ser de 16 carácteres'
				digits: 'Solo se permiten números'
				remote: 'El Número de Tarjeta ya existe en otra Cuenta'
			'ahorro[monto]':
				required: 'Monto Requerido'
				maxlength: 'El máximo de carácteres es ' + tamCadMaxDecimales
			'ahorro[monto_maximo]':
				required: 'Monto Máximo Requerido'
				maxlength: 'El máximo de carácteres es ' + tamCadMaxDecimales
			'ahorro[estado]':
				required: 'Estado Requerido'
			'ahorro[fecha_creacion]':
				required: 'Fecha de Creación Requerida'
			'ahorro[interes]':
				required: 'Interés Requerido'
				maxlength: 'El máximo de carácteres es ' + tamCadMaxInteres
			'ahorro[impuesto_anual]':
				required: 'Impuesto Anual Requerido'
				maxlength: 'El máximo de carácteres es ' + tamCadMaxDecimales
			'ahorro[descuento_transaccion]':
				required: 'Descuento en Transacciones Requerido'
				maxlength: 'El máximo de carácteres es ' + tamCadMaxDecimales
			'ahorro[meses_cambio]':
				required: 'Meses para Cambio Requerido'
				min: 'mínimo 1 mes'
				max: 'máximo 60 meses'
			'ahorro[limite_monto_transaccion]':
				required: 'Monto Máximo en Compras Requerido'
				maxlength: 'El máximo de carácteres es ' + tamCadMaxDecimales
			'ahorro[cliente_id]':
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


ready2 = -> 
	validator = $('#formulario_ahorros_editar').validate
		rules:
			'ahorro[clabe]':
				required: true
				rangelength: [18,18]
				digits: true
			'ahorro[numero_tarjeta]':
				required: true
				rangelength: [16,16]
				digits: true
			'ahorro[monto]':
				required: true
				maxlength: tamCadMaxDecimales
				Numero_Decimal: true
			'ahorro[monto_maximo]':
				required: true
				maxlength: tamCadMaxDecimales
				Numero_Decimal: true
			'ahorro[estado]':
				required: true
			'ahorro[fecha_creacion]':
				required: true
			'ahorro[interes]':
				required: true
				maxlength: tamCadMaxInteres
				Numero_Interes: true
			'ahorro[impuesto_anual]':
				required: true
				maxlength: tamCadMaxDecimales
				Numero_Decimal: true
			'ahorro[descuento_transaccion]':
				required: true
				maxlength: tamCadMaxDecimales
				Numero_Descuento: true
			'ahorro[meses_cambio]':
				required: true
				min: mesesMin
				max: mesesMax
			'ahorro[limite_monto_transaccion]':
				required: true
				maxlength: tamCadMaxDecimales
				Numero_Decimal: true
			'ahorro[cliente_id]':
				required: true
		messages:
			'ahorro[clabe]':
				required: 'CLABE Requerida'
				rangelength: 'La CLABE debe ser de 18 carácteres'
				digits: 'Solo se permiten números'
			'ahorro[numero_tarjeta]':
				required: 'Número de Tarjeta Requerido'
				rangelength: 'El Número de Tarjeta debe ser de 16 carácteres'
				digits: 'Solo se permiten números'
			'ahorro[monto]':
				required: 'Monto Requerido'
				maxlength: 'El máximo de carácteres es ' + tamCadMaxDecimales
			'ahorro[monto_maximo]':
				required: 'Monto Máximo Requerido'
				maxlength: 'El máximo de carácteres es ' + tamCadMaxDecimales
			'ahorro[estado]':
				required: 'Estado Requerido'
			'ahorro[fecha_creacion]':
				required: 'Fecha de Creación Requerida'
			'ahorro[interes]':
				required: 'Interés Requerido'
				maxlength: 'El máximo de carácteres es ' + tamCadMaxInteres
			'ahorro[impuesto_anual]':
				required: 'Impuesto Anual Requerido'
				maxlength: 'El máximo de carácteres es ' + tamCadMaxDecimales
			'ahorro[descuento_transaccion]':
				required: 'Descuento en Transacciones Requerido'
				maxlength: 'El máximo de carácteres es ' + tamCadMaxDecimales
			'ahorro[meses_cambio]':
				required: 'Meses para Cambio Requerido'
				min: 'mínimo 1 mes'
				max: 'máximo 60 meses'
			'ahorro[limite_monto_transaccion]':
				required: 'Monto Máximo en Compras Requerido'
				maxlength: 'El máximo de carácteres es ' + tamCadMaxDecimales
			'ahorro[cliente_id]':
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

$(document).ready(ready2)
$(document).on('turbolinks:load',ready2) 
