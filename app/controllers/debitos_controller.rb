class DebitosController < ApplicationController
  def inicio
  	#@usuarios = Usuario.all

    #Agregar Codigo para la busqueda

    values = {}
    if params[:clabe].present?
      values[:clabe] = params[:clabe]
    end
    if params[:saldo_minimo].present?
      values[:saldo_minimo] = params[:saldo_minimo]
    end
    if params[:bonificacion_uso].present?
      values[:bonificacion_uso] = params[:bonificacion_uso]
    end
    if params[:fecha_creacion].present?
      values[:fecha_creacion] = params[:fecha_creacion]
    end

    @debitos = Debito.where(values).paginate(:page => params[:page], :per_page => 5).order("fecha_creacion")

    respond_to do |format|
       format.html
       format.pdf { send_data reporte_pdf(values), filename: "reporte_debitos.pdf", type: 'application/pdf', dispotition: :attachment }
    end

  end
 
  def nuevo_cuenta_debito
  	@debito = Debito.new
  	@clientes = Cliente.all
    
  end

  def guardar_debito
  	@debito = Debito.new(clabe: params[:debito][:clabe], 
						   numero_tarjeta: params[:debito][:numero_tarjeta], 
						   :monto => params[:debito][:monto],  
						   monto_maximo: params[:debito][:monto_maximo], 
						   estado: params[:debito][:estado], 
						   fecha_creacion: params[:debito][:fecha_creacion], 
						   saldo_minimo: params[:debito][:saldo_minimo], 
						   comision: params[:debito][:comision], 
						   seguro: params[:debito][:seguro], 
						   cobro_inactividad: params[:debito][:cobro_inactividad], 
						   bonificacion_uso: params[:debito][:bonificacion_uso], 
						   cliente_id: params[:debito][:cliente_id])
  	respond_to do |format|
  		if @debito.save
  			format.html{redirect_to debitos_inicio_path, notice: "Cuenta de Debito creada exitosamente"}
  		end
  	end

  end

  def editar_cuenta_debito
    @debito = Debito.find(params[:id])
    @clientes = Cliente.all
  end

  def actualizar_debito
    @debito = Debito.find(params[:debito][:id])
    respond_to do |format|
      if @debito.update(clabe: params[:debito][:clabe], 
								   numero_tarjeta: params[:debito][:numero_tarjeta], 
								   :monto => params[:debito][:monto],  
								   monto_maximo: params[:debito][:monto_maximo], 
								   estado: params[:debito][:estado], 
								   fecha_creacion: params[:debito][:fecha_creacion], 
								   saldo_minimo: params[:debito][:saldo_minimo], 
								   comision: params[:debito][:comision], 
								   seguro: params[:debito][:seguro], 
								   cobro_inactividad: params[:debito][:cobro_inactividad], 
								   bonificacion_uso: params[:debito][:bonificacion_uso], 
								   cliente_id: params[:debito][:cliente_id])
        format.html{redirect_to debitos_inicio_path, notice: "Cuenta de Debito actualizada exitosamente"}
      end
    end
  end

  def mostrar_cuenta_debito
    @debito = Debito.where('id = ?', params[:id]).first
  	if @debito.estado == 'A'
  		@estado = "Activa"
  	elsif @debito.estado == 'B'
  		@estado = "Bloqueada"
  	else
  		@estado = "Suspendida"
  	end
  	if @debito.seguro == 'S'
  		@seguro = 'Si tiene'
  	else
  		@seguro = 'No tiene'
  	end
  	@cliente = @debito.cliente.nombre + ' ' + @debito.cliente.paterno + ' ' + @debito.cliente.materno
  end

  def eliminar_debito
    @debito = Debito.find(params[:id])
    respond_to do |format|
      if @debito.destroy
        format.html{redirect_to debitos_inicio_path, alert: "Cuenta de Debito eliminada exitosamente"}
      end
    end
  end

  def validar_clabe_debito
    #verificar que el RFC sea unico en Base de Datos. Necesitamos el RFC
    @debito = Debito.where('clabe = ?',params[:debito][:clabe]).first # [nombre: '', rfc = ''], nil
    respond_to do |format|

      format.js {render json: { validar: @debito.nil? ? true : false}, content_type: 'text/json'}
    end
  end

  def validar_tarjeta_debito
    #verificar que el RFC sea unico en Base de Datos. Necesitamos la CURP
    @debito = Debito.where('numero_tarjeta = ?',params[:debito][:numero_tarjeta]).first
    respond_to do |format|

      format.js {render json: { validar: @debito.nil? ? true : false}, content_type: 'text/json'}
    end
  end

  def reporte_pdf(values)
    #Generar el pdf
    @debitos = Debito.where(values).order('fecha_creacion')

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
  	pdf.text "Cuentas de Débitos", align: :center, style: :bold
  	pdf.move_down 10
  	pdf.font_size 6



  	#Cuerpo
  	encabezado=[]
  	datos=[]



  	pdf.bounding_box([0,650],width: pdf.bounds.width) do
  	encabezado = [["#","CLABE","NUMERO TARJETA","MONTO","MONTO MÁXIMO","ESTADO","FECHA CREACIÓN","SALDO MINIMO","COMISION","SEGURO","COBRO INACTIVIDAD","BONIFICACION USO","CLIENTE"]]
  	i=0
  	datos = @debitos.collect { |debit|
  	i+=1
  	[i,debit.clabe,debit.numero_tarjeta,debit.monto,debit.monto_maximo,debit.estado,debit.fecha_creacion,debit.saldo_minimo,debit.comision,debit.seguro,debit.cobro_inactividad,debit.bonificacion_uso,debit.cliente.nombre + ' ' + debit.cliente.paterno + ' ' + debit.cliente.materno]
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
