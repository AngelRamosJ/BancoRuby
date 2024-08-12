# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

tamCadMaxDecimales = 10
tamCadMinNombre = 5
tamCadMaxNombre = 50
tamCadMaxHoras = 5
empleadosMin = 5
empleadosMax = 200

$.validator.addMethod(
	'Numero_Decimal'

	(value,element) -> if value != '' then new RegExp("^[0-9]{1,7}(\.[0-9]{1,2})?$").test(value) else false

	'Numero Decimal Invalido (como máximo 2 decimales)'

)



$.validator.addMethod(
	'Hora'

	(value,element) -> if value != '' then new RegExp("^([01]?[0-9]|2[0-3]):[0-5][0-9]$").test(value) else false

	'Ingrese una Hora valida'

)


ready = -> 
	validator = $('#formulario_departamentos').validate
		rules:
			'departamento[nombre]':
				required: true
				minlength: tamCadMinNombre
				maxlength: tamCadMaxNombre
			'departamento[telefono]':
				required: true
				digits: true
				rangelength: [10,10]
			'departamento[maximo_empleados]':
				required: true
				min: empleadosMin
				max: empleadosMax
			'departamento[fondo]':
				required: true
				maxlength: tamCadMaxDecimales
				Numero_Decimal: true
			'departamento[fecha_creacion]':
				required: true
			'departamento[estado]':
				required: true
			'departamento[hora_apertura]':
				required: true
				Hora: true
				maxlength: tamCadMaxHoras
			'departamento[hora_cierre]':
				required: true
				Hora: true
				maxlength: tamCadMaxHoras
			'departamento[localidad_id]':
				required: true
			
		messages:
			'departamento[nombre]':
				required: 'Nombre Requerido'
				minlength: 'El mínimo de carácteres es ' + tamCadMinNombre
				maxlength: 'El máximo de carácteres es ' + tamCadMaxNombre
			'departamento[telefono]':
				required: 'Teléfono Requerido'
				digits: 'Solo se aceptan Números'
				rangelength: 'El Teléfono debe de ser de 10 carácteres'
			'departamento[maximo_empleados]':
				required: 'Máximo de Empleados Requerido'
				min: empleadosMin + ' empleados mínimo'
				max: empleadosMax + ' empleados máximo'
			'departamento[fondo]':
				required: 'Fondo Requerido'
				maxlength: 'El máximo de carácteres es ' + tamCadMaxDecimales
			'departamento[fecha_creacion]':
				required: 'Fecha de Creación Requerida'
			'departamento[estado]':
				required: 'Estado del Departamento Requerido'
			'departamento[hora_apertura]':
				required: 'Hora de Apertura Requerida'
				maxlength: 'El máximo de carácteres es ' + tamCadMaxHoras
			'departamento[hora_cierre]':
				required: 'Hora de Cierre Requerida'
				maxlength: 'El máximo de carácteres es ' + tamCadMaxHoras
			'departamento[localidad_id]':
				required: 'Localidad Requerida'
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