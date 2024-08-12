# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

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

	(value,element) -> if value != '' then new RegExp("^[0-9]{1,4}\.[0-9]{1,2}$").test(value) else false

	'Numero Decimal Invalido (como máximo 2 decimales). Ejemplo: 8.5'

)


ready = -> 
	validator = $('#formulario_debitos').validate
		rules:
			'debito[clabe]':
				required: true
				rangelength: [18,18]
				digits: true
				remote:
					url: '/validar_clabe_debito'
					type: 'GET'
					datatype: 'JSON'
					dataFilter: (txtResponse) ->
						resultado = $.parseJSON(txtResponse)
						if resultado.validar
							return true
						else
							return false
			'debito[numero_tarjeta]':
				required: true
				rangelength: [16,16]
				digits: true
				remote:
					url: '/validar_tarjeta_debito'
					type: 'GET'
					datatype: 'JSON'
					dataFilter: (txtResponse) ->
						resultado = $.parseJSON(txtResponse)
						if resultado.validar
							return true
						else
							return false
			'debito[monto]':
				required: true
				maxlength: tamCadMaxDecimales
				Numero_Decimal: true
			'debito[monto_maximo]':
				required: true
				maxlength: tamCadMaxDecimales
				Numero_Decimal: true
			'debito[estado]':
				required: true
			'debito[fecha_creacion]':
				required: true
			'debito[saldo_minimo]':
				required: true
				maxlength: tamCadMaxDecimales
				Numero_Decimal: true
			'debito[comision]':
				required: true
				maxlength: tamCadMaxDecimales
				Numero_Decimal: true
			'debito[seguro]':
				required: true
			'debito[cobro_inactividad]':
				required: true
				maxlength: tamCadMaxDecimales
				Numero_Decimal: true
			'debito[bonificacion_uso]':
				required: true
				maxlength: tamCadMaxDecimales
				Numero_Decimal: true
			'debito[cliente_id]':
				required: true
		messages:
			'debito[clabe]':
				required: 'CLABE Requerida'
				rangelength: 'La CLABE debe ser de 18 carácteres'
				digits: 'Solo se permiten números'
				remote: 'La CLABE ya existe en otra Cuenta'
			'debito[numero_tarjeta]':
				required: 'Número de Tarjeta Requerido'
				rangelength: 'El Número de Tarjeta debe ser de 16 carácteres'
				digits: 'Solo se permiten números'
				remote: 'El Número de Tarjeta ya existe en otra Cuenta'
			'debito[monto]':
				required: 'Monto Requerido'
				maxlength: 'El máximo de carácteres es ' + tamCadMaxDecimales
			'debito[monto_maximo]':
				required: 'Monto Máximo Requerido'
				maxlength: 'El máximo de carácteres es ' + tamCadMaxDecimales
			'debito[estado]':
				required: 'Estado Requerido'
			'debito[fecha_creacion]':
				required: 'Fecha de Creación Requerida'
			'debito[saldo_minimo]':
				required: 'Saldo Mínimo Requerido'
				maxlength: 'El máximo de carácteres es ' + tamCadMaxDecimales
			'debito[comision]':
				required: 'Comisión Requerida'
				maxlength: 'El máximo de carácteres es ' + tamCadMaxDecimales
			'debito[seguro]':
				required: 'Respuesta a Seguro Requerida'
			'debito[cobro_inactividad]':
				required: 'Cobro por Inactividad Requerido'
				maxlength: 'El máximo de carácteres es ' + tamCadMaxDecimales
			'debito[bonificacion_uso]':
				required: 'Bonificación por Uso Requerida'
				maxlength: 'El máximo de carácteres es ' + tamCadMaxDecimales
			'debito[cliente_id]':
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
	validator = $('#formulario_debitos_editar').validate
		rules:
			'debito[clabe]':
				required: true
				rangelength: [18,18]
				digits: true

			'debito[numero_tarjeta]':
				required: true
				rangelength: [16,16]
				digits: true

			'debito[monto]':
				required: true
				maxlength: tamCadMaxDecimales
				Numero_Decimal: true
			'debito[monto_maximo]':
				required: true
				maxlength: tamCadMaxDecimales
				Numero_Decimal: true
			'debito[estado]':
				required: true
			'debito[fecha_creacion]':
				required: true
			'debito[saldo_minimo]':
				required: true
				maxlength: tamCadMaxDecimales
				Numero_Decimal: true
			'debito[comision]':
				required: true
				maxlength: tamCadMaxDecimales
				Numero_Decimal: true
			'debito[seguro]':
				required: true
			'debito[cobro_inactividad]':
				required: true
				maxlength: tamCadMaxDecimales
				Numero_Decimal: true
			'debito[bonificacion_uso]':
				required: true
				maxlength: tamCadMaxDecimales
				Numero_Decimal: true
			'debito[cliente_id]':
				required: true
		messages:
			'debito[clabe]':
				required: 'CLABE Requerida'
				rangelength: 'La CLABE debe ser de 18 carácteres'
				digits: 'Solo se permiten números'

			'debito[numero_tarjeta]':
				required: 'Número de Tarjeta Requerido'
				rangelength: 'El Número de Tarjeta debe ser de 16 carácteres'
				digits: 'Solo se permiten números'

			'debito[monto]':
				required: 'Monto Requerido'
				maxlength: 'El máximo de carácteres es ' + tamCadMaxDecimales
			'debito[monto_maximo]':
				required: 'Monto Máximo Requerido'
				maxlength: 'El máximo de carácteres es ' + tamCadMaxDecimales
			'debito[estado]':
				required: 'Estado Requerido'
			'debito[fecha_creacion]':
				required: 'Fecha de Creación Requerida'
			'debito[saldo_minimo]':
				required: 'Saldo Mínimo Requerido'
				maxlength: 'El máximo de carácteres es ' + tamCadMaxDecimales
			'debito[comision]':
				required: 'Comisión Requerida'
				maxlength: 'El máximo de carácteres es ' + tamCadMaxDecimales
			'debito[seguro]':
				required: 'Respuesta a Seguro Requerida'
			'debito[cobro_inactividad]':
				required: 'Cobro por Inactividad Requerido'
				maxlength: 'El máximo de carácteres es ' + tamCadMaxDecimales
			'debito[bonificacion_uso]':
				required: 'Bonificación por Uso Requerida'
				maxlength: 'El máximo de carácteres es ' + tamCadMaxDecimales
			'debito[cliente_id]':
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

