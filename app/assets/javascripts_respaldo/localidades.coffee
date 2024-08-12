# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/


tamCadMinMunicipio = 5
tamCadMaxMunicipio = 50
tamCadMinCiudad = 5
tamCadMaxCiudad = 50
tamCadMinColonia = 5
tamCadMaxColonia = 50
tamCadMinCalle = 5
tamCadMaxCalle = 50
tamCadMinExtInt = 1
tamCadMaxExtInt = 4


ready = -> 
	validator = $('#formulario_localidades').validate
		rules:
			'localidad[tipo]':
				required: true
			'localidad[codigo_postal]':
				required: true
				digits: true
				rangelength: [5,5]
			'localidad[municipio]':
				required: true
				minlength: tamCadMinMunicipio
				maxlength: tamCadMaxMunicipio
			'localidad[ciudad]':
				required: true
				minlength: tamCadMinCiudad
				maxlength: tamCadMaxCiudad
			'localidad[colonia]':
				required: true
				minlength: tamCadMinColonia
				maxlength: tamCadMaxColonia
			'localidad[calle]':
				required: true
				minlength: tamCadMinCalle
				maxlength: tamCadMaxCalle
			'localidad[exterior]':
				required: true
				digits: true
				minlength: tamCadMinExtInt
				maxlength: tamCadMaxExtInt
			'localidad[interior]':
				required: true
				digits: true
				minlength: tamCadMinExtInt
				maxlength: tamCadMaxExtInt
			'localidad[estado_id]':
				required: true
			
		messages:
			'localidad[tipo]':
				required: 'Tipo de Localidad Requerido'
			'localidad[codigo_postal]':
				required: 'Código Postal Requerido'
				digits: 'Solo se aceptan números'
				rangelength: 'El Código Postal debe de ser de 5 carácteres'
			'localidad[municipio]':
				required: 'Municipio Requerido'
				minlength: 'El mínimo de carácteres es ' + tamCadMinMunicipio
				maxlength: 'El máximo de carácteres es ' + tamCadMaxMunicipio
			'localidad[ciudad]':
				required: 'Ciudad Requerida'
				minlength: 'El mínimo de carácteres es ' + tamCadMinCiudad
				maxlength: 'El máximo de carácteres es ' + tamCadMaxCiudad
			'localidad[colonia]':
				required: 'Colonia Requerida'
				minlength: 'El mínimo de carácteres es ' + tamCadMinColonia
				maxlength: 'El máximo de carácteres es ' + tamCadMaxColonia
			'localidad[calle]':
				required: 'Calle Requerida'
				minlength: 'El mínimo de carácteres es ' + tamCadMinCalle
				maxlength: 'El máximo de carácteres es ' + tamCadMaxCalle
			'localidad[exterior]':
				required: 'Número Exterior Requerido'
				digits: 'Solo se permiten números'
				minlength: 'El mínimo de carácteres es ' + tamCadMinExtInt
				maxlength: 'El máximo de carácteres es ' + tamCadMaxExtInt
			'localidad[interior]':
				required: 'Número Interior Requerido'
				digits: 'Solo se permiten números'
				minlength: 'El mínimo de carácteres es ' + tamCadMinExtInt
				maxlength: 'El máximo de carácteres es ' + tamCadMaxExtInt
			'localidad[estado_id]':
				required: 'Estado Requerido'
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
