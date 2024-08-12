
var tamCadMaxHora, tamCadMaxMotivo, tamCadMaxObser, tamCadMaxTipo, tamCadMinMotivo, tamCadMinObser, tamCadMinTipo;

tamCadMinTipo = 5;

tamCadMaxTipo = 50;

tamCadMinMotivo = 5;

tamCadMaxMotivo = 50;

tamCadMinObser = 10;

tamCadMaxObser = 100;

tamCadMaxHora = 5;

$.validator.addMethod('Hora', function(value, element) {
    if (value !== '') {
    return new RegExp("^([01]?[0-9]|2[0-3]):[0-5][0-9]$").test(value);
    } else {
    return false;
    }
}, 'Ingrese una Hora valida');



$(document).ready(function(){

    $('#formulario_citas').validate({
        rules: {
            'cita[tipo_tramite]': {
            required: true,
            minlength: tamCadMinTipo,
            maxlength: tamCadMaxTipo
            },
            'cita[motivo]': {
            required: true,
            minlength: tamCadMinMotivo,
            maxlength: tamCadMaxMotivo
            },
            'cita[fecha_encuentro]': {
            required: true
            },
            'cita[hora_inicio]': {
            required: true,
            Hora: true,
            maxlength: tamCadMaxHora
            },
            'cita[hora_final]': {
            required: true,
            Hora: true,
            maxlength: tamCadMaxHora
            },
            'cita[confirmacion]': {
            required: true
            },
            'cita[tipo_atencion]': {
            required: true
            },
            'cita[observacion]': {
            required: true,
            minlength: tamCadMinObser,
            maxlength: tamCadMaxObser
            },
            'cita[cliente_id]': {
            required: true
            },
            'cita[departamento_id]': {
            required: true
            }
        },
        messages: {
            'cita[tipo_tramite]': {
            required: 'Tipo de Trámite Requerido',
            minlength: 'El mínimo de carácteres es ' + tamCadMinTipo,
            maxlength: 'El máximo de carácteres es ' + tamCadMaxTipo
            },
            'cita[motivo]': {
            required: 'Motivo Requerido',
            minlength: 'El mínimo de carácteres es ' + tamCadMinMotivo,
            maxlength: 'El máximo de carácteres es ' + tamCadMaxMotivo
            },
            'cita[fecha_encuentro]': {
            required: 'Fecha de Encuentro Requerida'
            },
            'cita[hora_inicio]': {
            required: 'Hora de Inicio Requerida',
            maxlength: 'El máximo de carácteres es ' + tamCadMaxHora
            },
            'cita[hora_final]': {
            required: 'Hora de Termino Requerida',
            maxlength: 'El máximo de carácteres es ' + tamCadMaxHora
            },
            'cita[confirmacion]': {
            required: 'Confirmación Requerida'
            },
            'cita[tipo_atencion]': {
            required: 'Tipo de Atención Requerida'
            },
            'cita[observacion]': {
            required: 'Oberservación Requerida',
            minlength: 'El mínimo de carácteres es ' + tamCadMinObser,
            maxlength: 'El máximo de carácteres es ' + tamCadMaxObser
            },
            'cita[cliente_id]': {
            required: 'Cliente Requerido'
            },
            'cita[departamento_id]': {
            required: 'Departamento Requerido'
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
