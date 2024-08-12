class AhorrosController < ApplicationController
  def inicio
  	#@usuarios = Usuario.all

    #Agregar Codigo para la busqueda

    values = {}
    if params[:clabe].present?
      values[:clabe] = params[:clabe]
    end
    if params[:interes].present?
      values[:interes] = params[:interes]
    end
    if params[:impuesto_anual].present?
      values[:impuesto_anual] = params[:impuesto_anual]
    end
    if params[:fecha_creacion].present?
      values[:fecha_creacion] = params[:fecha_creacion]
    end

    @ahorros = Ahorro.where(values).paginate(:page => params[:page], :per_page => 5).order("fecha_creacion")

    respond_to do |format|
       format.html
       format.pdf { send_data reporte_pdf(values), filename: "reporte_ahorros.pdf", type: 'application/pdf', dispotition: :attachment }
    end

  end
 
  def nuevo_cuenta_ahorro
  	@ahorro = Ahorro.new
  	@clientes = Cliente.all
    
  end

  def guardar_ahorro
  	@ahorro = Ahorro.new(clabe: params[:ahorro][:clabe], 
						   numero_tarjeta: params[:ahorro][:numero_tarjeta], 
						   :monto => params[:ahorro][:monto],  
						   monto_maximo: params[:ahorro][:monto_maximo], 
						   estado: params[:ahorro][:estado], 
						   fecha_creacion: params[:ahorro][:fecha_creacion], 
						   interes: params[:ahorro][:interes], 
						   impuesto_anual: params[:ahorro][:impuesto_anual], 
						   descuento_transaccion: params[:ahorro][:descuento_transaccion], 
						   meses_cambio: params[:ahorro][:meses_cambio], 
						   limite_monto_transaccion: params[:ahorro][:limite_monto_transaccion], 
						   cliente_id: params[:ahorro][:cliente_id])
  	respond_to do |format|
  		if @ahorro.save
  			format.html{redirect_to ahorros_inicio_path, notice: "Cuenta de Ahorro creada exitosamente"}
  		end
  	end

  end

  def editar_cuenta_ahorro
    @ahorro = Ahorro.find(params[:id])
    @clientes = Cliente.all
  end

  def actualizar_ahorro
    @ahorro = Ahorro.find(params[:ahorro][:id])
    respond_to do |format|
      if @ahorro.update(clabe: params[:ahorro][:clabe], 
								   numero_tarjeta: params[:ahorro][:numero_tarjeta], 
								   :monto => params[:ahorro][:monto],  
								   monto_maximo: params[:ahorro][:monto_maximo], 
								   estado: params[:ahorro][:estado], 
								   fecha_creacion: params[:ahorro][:fecha_creacion], 
								   interes: params[:ahorro][:interes], 
								   impuesto_anual: params[:ahorro][:impuesto_anual], 
								   descuento_transaccion: params[:ahorro][:descuento_transaccion], 
								   meses_cambio: params[:ahorro][:meses_cambio], 
								   limite_monto_transaccion: params[:ahorro][:limite_monto_transaccion], 
								   cliente_id: params[:ahorro][:cliente_id])
        format.html{redirect_to ahorros_inicio_path, notice: "Cuenta de Ahorro actualizada exitosamente"}
      end
    end
  end

  def mostrar_cuenta_ahorro
    @ahorro = Ahorro.where('id = ?', params[:id]).first
  	if @ahorro.estado == 'A'
  		@estado = "Activa"
  	elsif @ahorro.estado == 'B'
  		@estado = "Bloqueada"
  	else
  		@estado = "Suspendida"
  	end
  	@cliente = @ahorro.cliente.nombre + ' ' + @ahorro.cliente.paterno + ' ' + @ahorro.cliente.materno
  end

  def eliminar_ahorro
    @ahorro = Ahorro.find(params[:id])
    respond_to do |format|
      if @ahorro.destroy
        format.html{redirect_to ahorros_inicio_path, alert: "Cuenta de Ahorro eliminada exitosamente"}
      end
    end
  end

    def validar_clabe_ahorro
    #verificar que el RFC sea unico en Base de Datos. Necesitamos el RFC
    @ahorro = Ahorro.where('clabe = ?',params[:ahorro][:clabe]).first # [nombre: '', rfc = ''], nil
    respond_to do |format|

      format.js {render json: { validar: @ahorro.nil? ? true : false}, content_type: 'text/json'}
    end
  end

  def validar_tarjeta_ahorro
    #verificar que el RFC sea unico en Base de Datos. Necesitamos la CURP
    @ahorro = Ahorro.where('numero_tarjeta = ?',params[:ahorro][:numero_tarjeta]).first
    respond_to do |format|

      format.js {render json: { validar: @ahorro.nil? ? true : false}, content_type: 'text/json'}
    end
  end

  def reporte_pdf(values)
    #Generar el pdf
    @ahorros = Ahorro.where(values).order('fecha_creacion')

    pdf = Prawn::Document.new

    pdf.repeat(:all) do

  	pdf.font_size 7
  	pdf.draw_text "#{l(Time.now,format: '%d de %B %Y')}", :at => [pdf.bounds.right - 80,pdf.bounds.bottom - 4] #repetar espacios
  	#pdf.image "#{Rails.root}/app/assets/images/buscar.png", at: [pdf.bounds.left,pdf.bounds.top], scale: 0.4
  	pdf.font_size 6
  	pdf.draw_text "SISTEMA DE ADMINISTRACION LPOO", at: [pdf.bounds.right - 140,pdf.bounds.top + 10]
  	end



  	pdf.move_down 55
  	pdf.font_size 10
  	pdf.text "Cuentas de Ahorro", align: :center, style: :bold
  	pdf.move_down 10
  	pdf.font_size 6



  	#Cuerpo
  	encabezado=[]
  	datos=[]



  	pdf.bounding_box([0,650],width: pdf.bounds.width) do
  	encabezado = [["#","CLABE","NUMERO TARJETA","MONTO","MONTO MÁXIMO","ESTADO","FECHA CREACIÓN","INTERES","IMPUESTO ANUAL","DESCUENTO TRANSACCION","MESES CAMBIO","MONTO MAXIMO EN COMPRA","CLIENTE"]]
  	i=0
  	datos = @ahorros.collect { |ahorro|
  	i+=1
  	[i,ahorro.clabe,ahorro.numero_tarjeta,ahorro.monto,ahorro.monto_maximo,ahorro.estado,ahorro.fecha_creacion,ahorro.interes,ahorro.impuesto_anual,ahorro.descuento_transaccion,ahorro.meses_cambio,ahorro.limite_monto_transaccion,ahorro.cliente.nombre + ' ' + ahorro.cliente.paterno + ' ' + ahorro.cliente.materno]
  	}
  	end



  	pdf.table encabezado.concat(datos), position: :center do
  	row(0).border_width= 2
  	row(0).font_style= :bold
  	row(0).align= :center
  	end



  	#Pie
  	pdf.font_size=7
  	pdf.number_pages "Pag. <page>/<total>",{at: [0,pdf.bounds.bottom],width: pdf.bounds.width,align: :center, font_size: 7}
  	pdf.render

	end
end
