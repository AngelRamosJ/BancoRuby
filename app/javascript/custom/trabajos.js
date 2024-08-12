var horasMax, horasMin, tamCadMaxArea, tamCadMaxDecimales, tamCadMaxDesc, tamCadMaxEstudio, tamCadMaxNombre, tamCadMinArea, tamCadMinDesc, tamCadMinEstudio, tamCadMinNombre;

tamCadMinNombre = 5;

tamCadMaxNombre = 50;

tamCadMinDesc = 10;

tamCadMaxDesc = 100;

tamCadMinEstudio = 5;

tamCadMaxEstudio = 35;

tamCadMinArea = 5;

tamCadMaxArea = 35;

tamCadMaxDecimales = 10;

horasMin = 3;

horasMax = 10;

$.validator.addMethod('Numero_Decimal', function(value, element) {
    if (value !== '') {
    return new RegExp("^[0-9]{1,7}(\.[0-9]{1,2})?$").test(value);
    } else {
    return false;
    }
}, 'Numero Decimal Invalido (como máximo 2 decimales)');



$(document).ready(function(){
    $('#formulario_trabajos').validate({
        rules: {
            'trabajo[nombre]': {
            required: true,
            minlength: tamCadMinNombre,
            maxlength: tamCadMaxNombre
            },
            'trabajo[descripcion]': {
            required: true,
            minlength: tamCadMinDesc,
            maxlength: tamCadMaxDesc
            },
            'trabajo[salario_minimo]': {
            required: true,
            maxlength: tamCadMaxDecimales,
            Numero_Decimal: true
            },
            'trabajo[salario_maximo]': {
            required: true,
            maxlength: tamCadMaxDecimales,
            Numero_Decimal: true
            },
            'trabajo[estudio_minimo]': {
            required: true,
            minlength: tamCadMinEstudio,
            maxlength: tamCadMaxEstudio
            },
            'trabajo[area]': {
            required: true,
            minlength: tamCadMinArea,
            maxlength: tamCadMaxArea
            },
            'trabajo[horas]': {
            required: true,
            min: horasMin,
            max: horasMax
            },
            'trabajo[prestacion]': {
            required: true
            }
        },
        messages: {
            'trabajo[nombre]': {
            required: 'Nombre Requerido',
            minlength: 'El mínimo de carácteres es ' + tamCadMinNombre,
            maxlength: 'El máximo de carácteres es ' + tamCadMaxNombre
            },
            'trabajo[descripcion]': {
            required: 'Descripción Requerida',
            minlength: 'El mínimo de carácteres es ' + tamCadMinDesc,
            maxlength: 'El máximo de carácteres es ' + tamCadMaxDesc
            },
            'trabajo[salario_minimo]': {
            required: 'Salario Mínimo Requerido',
            maxlength: 'El máximo de carácteres es ' + tamCadMaxDecimales
            },
            'trabajo[salario_maximo]': {
            required: 'Salario Máximo Requerido',
            maxlength: 'El máximo de carácteres es ' + tamCadMaxDecimales
            },
            'trabajo[estudio_minimo]': {
            required: 'Estudio Mínimo Requerido',
            minlength: 'El mínimo de carácteres es ' + tamCadMinEstudio,
            maxlength: 'El máximo de carácteres es ' + tamCadMaxEstudio
            },
            'trabajo[area]': {
            required: 'Área Laboral Requerida',
            minlength: 'El mínimo de carácteres es ' + tamCadMinArea,
            maxlength: 'El máximo de carácteres es ' + tamCadMaxArea
            },
            'trabajo[horas]': {
            required: 'Horas por Día Requeridas',
            min: horasMin + ' horas mínimo',
            max: horasMax + ' horas máximo'
            },
            'trabajo[prestacion]': {
            required: 'Respuesta a Prestaciones Requerida'
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
