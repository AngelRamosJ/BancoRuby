class OperacionesController < ApplicationController
	layout 'application_operaciones'
	skip_before_action :login_empleado?
	before_action :login_cliente?
	$pdf_eleccion
	$pdf_values
	def inicio
	end

	def transferir
		@debitos = Debito.where("cliente_id = ?",session[:cliente_id])

	end

	def transferir_monto_cuentas
		if params[:eleccion] == 'C'
			@cuenta_origen = Debito.where("clabe = ?",params[:cuenta][:clabe_origen]).first
			@cuenta_destino = Debito.where("clabe = ?",params[:clabe_destino]).first
			@cuenta_igual = params[:cuenta][:clabe_origen] == params[:clabe_destino] ? true : false
		else
			@cuenta_origen = Debito.where("numero_tarjeta = ?",params[:cuenta][:tarjeta_origen]).first
			@cuenta_destino = Debito.where("numero_tarjeta = ?",params[:tarjeta_destino]).first
			@cuenta_igual = params[:cuenta][:tarjeta_origen] == params[:tarjeta_destino] ? true : false
		end

		@montoTransferido = params[:monto].to_f

		respond_to do |format|
			if @cuenta_igual
				format.html{redirect_to transferir_path, alert: "Transferencia Rechazada: La Cuenta es la misma"}
			elsif @cuenta_origen.monto < @montoTransferido
				format.html{redirect_to transferir_path, alert: "Transferencia Rechazada: NO tiene el Saldo Suficiente"}
			elsif @cuenta_origen.estado != 'A'
				format.html{redirect_to transferir_path, alert: "Transferencia Rechazada: Su Cuenta se encuentra Bloqueada o Suspendida"}
			elsif @cuenta_destino.estado != 'A'
				format.html{redirect_to transferir_path, alert: "Transferencia Rechazada: La Cuenta Destino está Bloqueada o Suspendida"}
			else
				@monto_nuevo = @cuenta_origen.monto - @montoTransferido
				@tiempo_creacion = Time.now
				@transaccion = Transaccion.new(monto_nuevo: @monto_nuevo,
												monto_anterior: @cuenta_origen.monto,
												fecha_creacion: @tiempo_creacion.strftime("%F"),
												mes: @tiempo_creacion.month,
												hora_creacion: @tiempo_creacion.strftime("%H:%M"),
												tipo_envio: params[:eleccion],
												clabe_origen: @cuenta_origen.clabe,
												clabe_destino: @cuenta_destino.clabe,
												tarjeta_destino: @cuenta_destino.numero_tarjeta,
												cliente_id: @cuenta_origen.cliente.id)
				@cuenta_origen.monto = @monto_nuevo
				@cuenta_destino.monto = @cuenta_destino.monto + @montoTransferido
				if @transaccion.save
					if @cuenta_origen.save
						if @cuenta_destino.save
							format.html{redirect_to inicio_cliente_path, notice: "Transferencia realizada Exitosamente"}
						end
					end
				end
			end
    	end
	end

	def validar_clabe
		@cuenta = Debito.where('clabe = ?',params[:clabe_destino]).first # [nombre: '', rfc = ''], nil
		respond_to do |format|
		  format.js {render json: { validar: @cuenta.nil? ? false : true}, content_type: 'text/json'}
		end
	end

	def validar_tarjeta
		@cuenta = Debito.where('numero_tarjeta = ?',params[:tarjeta_destino]).first
		respond_to do |format|
		  format.js {render json: { validar: @cuenta.nil? ? false : true}, content_type: 'text/json'}
		end
	end



	
	def depositar
		@ahorros = Ahorro.where("cliente_id = ?",session[:cliente_id])
	end

	def depositar_monto_cuenta
		if params[:eleccion] == 'C'
			@cuenta = Ahorro.where("clabe = ?",params[:cuenta][:clabe]).first
		else
			@cuenta = Ahorro.where("numero_tarjeta = ?",params[:cuenta][:tarjeta]).first
		end

		@nuevoMonto = params[:monto].to_f + @cuenta.monto
		respond_to do |format|
			if @cuenta.monto_maximo < @nuevoMonto
				format.html{redirect_to depositar_path, alert: "Depósito Rechazado: El depósito hace exceder su Monto Máximo"}
			elsif @cuenta.estado != 'A'
				format.html{redirect_to depositar_path, alert: "Depósito Rechazado: Su Cuenta se encuentra Bloqueada o Suspendida"}
			else
				if @nuevoMonto >= 500000.0
					@cuenta.descuento_transaccion = 35.0
				elsif @nuevoMonto >= 200000.0
					@cuenta.descuento_transaccion = 20.0
				elsif @nuevoMonto >= 100000.0
					@cuenta.descuento_transaccion = 15.0
				elsif @nuevoMonto >= 50000.0
					@cuenta.descuento_transaccion = 10.0
				elsif @nuevoMonto >= 10000.0
					@cuenta.descuento_transaccion = 5.0
				end	
				@tiempo_creacion = Time.now	
				@transaccion = Transaccion.new(monto_nuevo: @nuevoMonto,
												monto_anterior: @cuenta.monto,
												fecha_creacion: @tiempo_creacion.strftime("%F"),
												mes: @tiempo_creacion.month,
												hora_creacion: @tiempo_creacion.strftime("%H:%M"),
												tipo_envio: params[:eleccion],
												clabe_origen: @cuenta.clabe,
												cliente_id: @cuenta.cliente.id)
				@cuenta.monto = @nuevoMonto
				if @transaccion.save
					if @cuenta.save
						format.html{redirect_to inicio_cliente_path, notice: "Depósito realizado Exitosamente"}
					end
				end
			end
    	end
	end

	def consultar
		@debitos = Debito.where("cliente_id = ?",session[:cliente_id])
		@ahorros = Ahorro.where("cliente_id = ?",session[:cliente_id])
		@datos_cuenta = []
		@monto_total_mes = []
		@estado_clientes = []
		values = {}
	    if params[:debito].present?
	      values[:clabe_origen] = params[:debito]
	    end
	    if params[:ahorro].present?
	      values[:clabe_origen] = params[:ahorro]
	    end
	    if params[:mes].present?
	      values[:mes] = params[:mes]
	    end
	    if params[:eleccion].present?
	    	@tipo_cuenta = params[:eleccion]
	    	$pdf_eleccion = params[:eleccion]
	    	$pdf_values = values
	    	@transacciones = Transaccion.where(values).paginate(:page => params[:page], :per_page => 5).order("fecha_creacion")

	    	#Con solo la vista
	    	#@datos_cuenta = Vistadebito.all
	    	#Con la Vista pero con el Sinónimo asociado y exec_query
	    	@datos_cuenta = ActiveRecord::Base.connection.exec_query('SELECT * from vista')
	   		#Con la Vista pero con el Sinónimo asociado y find_by_sql
	   		#@datos_cuenta = Vistadebito.find_by_sql("SELECT * from vista")

	   		@monto_total_mes = Transaccion.select("mes, SUM(monto_anterior - monto_nuevo) as movimiento").where("clabe_destino IS NOT NULL").group("mes")
	 		
	 		@estado_clientes = Cliente.select("e.nombre as estado, COUNT(clientes.nombre) as num_clientes").joins("JOIN localidades l ON clientes.localidad_id = l.id JOIN estados e ON l.estado_id = e.id").group("e.nombre")
	    else
	    	@transacciones = Transaccion.where("clabe_origen = ?","-1")
	    end
	    respond_to do |format|
	       format.html
	       format.pdf { send_data reporte_pdf(values), filename: "reporte_transaccios.pdf", type: 'application/pdf', dispotition: :attachment }
	    end

	end

	def login_cliente?
		if session[:cliente_id].nil?
			redirect_to login_cliente_path, alert: 'Debes iniciar sesión.' 
		end
	end


	def reporte_pdf(values)
    #Generar el pdf
    bandera = false
    estado = ''
    if $pdf_eleccion != ''
    	@transacciones = Transaccion.where($pdf_values).order("fecha_creacion")
    	bandera = $pdf_eleccion == 'D' ? true : false
    	if bandera
    		@cuenta = Debito.where("clabe = ?",@transacciones.first.clabe_origen).first
    	else
    		@cuenta = Ahorro.where("clabe = ?",@transacciones.first.clabe_origen).first
    	end
    	if @cuenta.estado == 'A'
    		estado = 'Activa'
    	elsif @cuenta.estado == 'B'
    		estado = 'Bloqueada'
    	else 		
    		estado = 'Suspendida'
    	end 
    else
    	@transacciones = Transaccion.where("clabe_origen = ?","-1")
    end
   


    pdf = Prawn::Document.new

    pdf.repeat(:all) do

  	pdf.font_size 7
  	pdf.draw_text "#{l(Time.now,format: '%d de %B %Y')}", :at => [pdf.bounds.right - 80,pdf.bounds.bottom - 4] #repetar espacios
  	#pdf.image "#{Rails.root}/app/assets/images/buscar.png", at: [pdf.bounds.left,pdf.bounds.top], scale: 0.4
  	pdf.font_size 6
  	pdf.draw_text "DATOS GENERALES DE LA CUENTA", at: [pdf.bounds.right - 140,pdf.bounds.top + 20 ]
  	pdf.font_size 6
  	pdf.draw_text "CLABE: #{@cuenta.clabe}", at: [pdf.bounds.right - 140,pdf.bounds.top + 10]
  	pdf.font_size 6
  	pdf.draw_text "NÚMERO DE TARJETA: #{@cuenta.numero_tarjeta}", at: [pdf.bounds.right - 140,pdf.bounds.top ]
  	pdf.font_size 6
  	pdf.draw_text "ESTADO O SITUACIÓN: #{estado}", at: [pdf.bounds.right - 140,pdf.bounds.top - 10]
  	pdf.font_size 6
  	pdf.draw_text "MONTO TOTAL: #{@cuenta.monto}", at: [pdf.bounds.right - 140,pdf.bounds.top - 20]
  	pdf.font_size 6
  	pdf.draw_text "FECHA DE CREACIÓN: #{@cuenta.fecha_creacion}", at: [pdf.bounds.right - 140,pdf.bounds.top - 30]
  	end



  	pdf.move_down 55
  	pdf.font_size 10
  	pdf.text "Reporte de Transacciones", align: :center, style: :bold
  	pdf.move_down 10
  	pdf.font_size 6



  	#Cuerpo
  	encabezado=[]
  	datos=[]
  	final=[]
  	ultimoReg = 0
  	if $pdf_eleccion == 'D'

	  	pdf.bounding_box([0,650],width: pdf.bounds.width) do
	  	
	  	encabezado = [["#","ENVIADO MEDIANTE","        FECHA","HORA","CLABE DESTINO","TARJETA DESTINO","MONTO ANTERIOR","MONTO NUEVO","DINERO MANEJADO","¿INGRESO O EGRESO?"]]
	  	i=0
	  	ultimoReg += 1
	  	sumEgresos = 0
	  	datos = @transacciones.collect { |trans|
	  	i+=1
	  	ultimoReg += 1
	  	enviado = trans.tipo_envio == 'C' ? 'CLABE' : 'TARJETA'
	  	monto_manejado = trans.monto_anterior - trans.monto_nuevo
	  	tipo_ingreso_egreso = 'Egreso' 
	  	sumEgresos += monto_manejado
	  	[i,enviado,trans.fecha_creacion,trans.hora_creacion,trans.clabe_destino,trans.tarjeta_destino,trans.monto_anterior,trans.monto_nuevo,monto_manejado,tipo_ingreso_egreso]

	  	}
	  	final = [["","","","","","","","TOTAL DE EGRESOS",sumEgresos,""]]
	  	end
  	else
  		pdf.bounding_box([0,650],width: pdf.bounds.width) do
	  	
	  	encabezado = [["#","ENVIADO MEDIANTE","        FECHA","HORA","MONTO ANTERIOR","MONTO NUEVO","DINERO MANEJADO","¿INGRESO O EGRESO?"]]
	  	i=0
		ultimoReg += 1
		sumIngresos = 0
	  	datos = @transacciones.collect { |trans|
	  	i+=1
	  	ultimoReg += 1
	  	enviado = trans.tipo_envio == 'C' ? 'CLABE' : 'TARJETA'
	  	monto_manejado = trans.monto_nuevo - trans.monto_anterior
	  	tipo_ingreso_egreso = 'Ingreso' 
	  	sumIngresos += monto_manejado
	  	[i,enviado,trans.fecha_creacion,trans.hora_creacion,trans.monto_anterior,trans.monto_nuevo,monto_manejado,tipo_ingreso_egreso]

	  	}
	  	final = [["","","","","","TOTAL DE INGRESOS",sumIngresos,""]]
	  	end
 	end


  	pdf.table encabezado.concat(datos).concat(final), position: :center do
  	row(0).border_width= 2
  	row(0).font_style= :bold
  	row(ultimoReg).border_width= 2
  	row(ultimoReg).font_style= :bold
  	for r in (0..ultimoReg)
  		row(r).align= :center
  	end
  	end





  	#Pie
  	pdf.font_size=7
  	pdf.number_pages "Pag. <page>/<total>",{at: [0,pdf.bounds.bottom],width: pdf.bounds.width,align: :center, font_size: 7}
  	pdf.render

	end

end




