var tamCadMaxDesc, tamCadMaxMotivo, tamCadMinDesc, tamCadMinMotivo;

tamCadMinMotivo = 5;

tamCadMaxMotivo = 45;

tamCadMinDesc = 10;

tamCadMaxDesc = 100;


$(document).ready(function(){
    $('#formulario_quejas').validate({
        rules: {
            'queja[motivo]': {
            required: true,
            minlength: tamCadMinMotivo,
            maxlength: tamCadMaxMotivo
            },
            'queja[descripcion]': {
            required: true,
            minlength: tamCadMinDesc,
            maxlength: tamCadMaxDesc
            },
            'queja[fecha_suceso]': {
            required: true
            },
            'queja[tipo]': {
            required: true
            },
            'queja[confirmacion]': {
            required: true
            },
            'queja[respuesta]': {
            required: true
            },
            'queja[causante]': {
            required: true
            },
            'queja[evidencia]': {
            required: true
            },
            'queja[cliente_id]': {
            required: true
            }
        },
        messages: {
            'queja[motivo]': {
            required: 'Motivo Requerido',
            minlength: 'El mínimo de carácteres es ' + tamCadMinMotivo,
            maxlength: 'El máximo de carácteres es ' + tamCadMaxMotivo
            },
            'queja[descripcion]': {
            required: 'Descripción Requerida',
            minlength: 'El mínimo de carácteres es ' + tamCadMinDesc,
            maxlength: 'El máximo de carácteres es ' + tamCadMaxDesc
            },
            'queja[fecha_suceso]': {
            required: 'Fecha del Suceso Requerida'
            },
            'queja[tipo]': {
            required: 'Tipo de Queja Requerida'
            },
            'queja[confirmacion]': {
            required: 'Confirmación Requerida'
            },
            'queja[respuesta]': {
            required: 'Respuesta Requerida'
            },
            'queja[causante]': {
            required: 'Causante Requerido'
            },
            'queja[evidencia]': {
            required: 'Confirmación de Evidencia Requerida'
            },
            'queja[cliente_id]': {
            required: 'Cliente Requerido'
            }
        },
        errorPlacement: function(error, element) {
            if (element.is(":radio")) {
            error.appendTo(element.parents('.padre_radio').children('.etiqueta-error').children('span'));
            } else {
            error.appendTo(element.siblings('div').children('span'));
            }
        },
        errorElement: "span",
        highlight: function(element, errorClass, validClass) {
            $(element).addClass("tiene-error").removeClass("success");
            $(element).siblings('div').addClass("mostrar_error").removeClass("ocultar_error");
            $(element).siblings('div').children('img').addClass("mostrar_error").removeClass("ocultar_error");
            $(element).parents('.padre_radio').children('.etiqueta-error').addClass("mostrar_error").removeClass("ocultar_error");
            $(element).parents('.padre_radio').children('.etiqueta-error').children('img').addClass("mostrar_error").removeClass("ocultar_error");
        },
        unhighlight: function(element, errorClass, validClass) {
            $(element).addClass("success").removeClass("tiene-error");
            $(element).siblings('div').addClass("ocultar_error").removeClass("mostrar_error");
            $(element).siblings('div').children('img').addClass("ocultar_error").removeClass("mostrar_error");
            $(element).parents('.padre_radio').children('.etiqueta-error').addClass("ocultar_error").removeClass("mostrar_error");
            $(element).parents('.padre_radio').children('.etiqueta-error').children('img').addClass("ocultar_error").removeClass("mostrar_error");
        }
    });
});

