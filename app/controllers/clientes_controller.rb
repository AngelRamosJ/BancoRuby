class ClientesController < ApplicationController
  rescue_from ActiveRecord::InvalidForeignKey, with: :no_borrar_cliente
  def inicio
  	#@usuarios = Usuario.all

    #Agregar Codigo para la busqueda

    values = {}
    if params[:paterno].present?
      values[:paterno] = params[:paterno]
    end
    if params[:materno].present?
      values[:materno] = params[:materno]
    end
    if params[:rfc].present?
      values[:rfc] = params[:rfc]
    end
    if params[:curp].present?
      values[:curp] = params[:curp]
    end

    @clientes = Cliente.where(values).paginate(:page => params[:page], :per_page => 5).order("paterno")

    respond_to do |format|
       format.html
       format.pdf { send_data reporte_pdf(values), filename: "reporte_clientes.pdf", type: 'application/pdf', dispotition: :attachment }
    end

  end
 
  def nuevo_cliente
  	@cliente = Cliente.new
    @localidades = Localidad.all
  end

  def guardar_cliente
  	@cliente = Cliente.new(nombre: params[:cliente][:nombre], 
            						   paterno: params[:cliente][:paterno], 
            						   :materno => params[:cliente][:materno],  
            						   rfc: params[:cliente][:rfc], 
            						   curp: params[:cliente][:curp], 
            						   fecha_nacimiento: params[:cliente][:fecha_nacimiento], 
            						   correo: params[:cliente][:correo], 
            						   telefono: params[:cliente][:telefono], 
            						   estado_laboral: params[:cliente][:estado_laboral],
                           salario_mensual: params[:cliente][:salario_mensual],
                           estudio: params[:cliente][:estudio],
                           tiempo_laboral: params[:cliente][:tiempo_laboral],
                           riesgo_trabajo: params[:cliente][:riesgo_trabajo],
            						   login: params[:cliente][:login],
            						   password: params[:cliente][:password],
            						   localidad_id: params[:cliente][:localidad_id])
  	respond_to do |format|
  		if @cliente.save
  			format.html{redirect_to clientes_inicio_path, notice: "Cliente creado exitosamente"}
  		end
  	end

  end

  def editar_cliente
    @cliente = Cliente.find(params[:id])
    @localidades = Localidad.all
  end

  def actualizar_cliente
    @cliente = Cliente.find(params[:cliente][:id])
    respond_to do |format|
      if @cliente.update(nombre: params[:cliente][:nombre], 
                                   paterno: params[:cliente][:paterno], 
                                   :materno => params[:cliente][:materno],  
                                   rfc: params[:cliente][:rfc], 
                                   curp: params[:cliente][:curp], 
                                   fecha_nacimiento: params[:cliente][:fecha_nacimiento], 
                                   correo: params[:cliente][:correo], 
                                   telefono: params[:cliente][:telefono], 
                                   estado_laboral: params[:cliente][:estado_laboral],
                                   salario_mensual: params[:cliente][:salario_mensual],
                                   estudio: params[:cliente][:estudio],
                                   tiempo_laboral: params[:cliente][:tiempo_laboral],
                                   riesgo_trabajo: params[:cliente][:riesgo_trabajo],
                                   login: params[:cliente][:login],
                                   password: params[:cliente][:password],
                                   localidad_id: params[:cliente][:localidad_id])
        format.html{redirect_to clientes_inicio_path, notice: "Cliente actualizado exitosamente"}
      end
    end
  end

  def mostrar_cliente
    @cliente = Cliente.where('id = ?', params[:id]).first
  	if @cliente.estado_laboral == 'T'
      @estadoClien = "Trabajador"
    elsif @cliente.estado_laboral == 'P'
      @estadoClien = "Pensionado"
    elsif @cliente.estado_laboral == 'D'
      @estadoClien = "Desempleado"
    else
      @estadoClien = "Estudiante"
    end
  	@localidad = 'C ' + @cliente.localidad.calle + ' ' + @cliente.localidad.exterior+ ' ' + @cliente.localidad.interior + ' COL ' + @cliente.localidad.colonia + ' ' + @cliente.localidad.codigo_postal + ' ' + @cliente.localidad.ciudad + ', ' + @cliente.localidad.estado.nombre
  end

  def eliminar_cliente
    @cliente = Cliente.find(params[:id])
    respond_to do |format|
      if @cliente.destroy
        format.html{redirect_to clientes_inicio_path, alert: "Cliente eliminado exitosamente"}
      end
    end
  end

  def validar_rfc_cliente
    #verificar que el RFC sea unico en Base de Datos. Necesitamos el RFC
    @cliente = Cliente.where('rfc = ?',params[:cliente][:rfc]).first # [nombre: '', rfc = ''], nil
    respond_to do |format|

      format.js {render json: { validar: @cliente.nil? ? true : false}, content_type: 'text/json'}
    end
  end

  def validar_curp_cliente
    #verificar que el RFC sea unico en Base de Datos. Necesitamos la CURP
    @cliente = Cliente.where('curp = ?',params[:cliente][:curp]).first
    respond_to do |format|

      format.js {render json: { validar: @cliente.nil? ? true : false}, content_type: 'text/json'}
    end
  end

  def validar_login_cliente
    #verificar que el RFC sea unico en Base de Datos. Necesitamos la CURP
    @cliente = Cliente.where('login = ?',params[:cliente][:login]).first
    respond_to do |format|

      format.js {render json: { validar: @cliente.nil? ? true : false}, content_type: 'text/json'}
    end
  end

  private
  def no_borrar_cliente
    respond_to do |format|
      format.html{redirect_to clientes_inicio_path, alert: "IMPOSIBLE Borrar el Cliente, está información está siendo usada en otros Datos"}
    end
  end

  def reporte_pdf(values)
    #Generar el pdf
    @clientes = Cliente.where(values).order('paterno')

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
  	pdf.text "clientes", align: :center, style: :bold
  	pdf.move_down 10
  	pdf.font_size 6



  	#Cuerpo
  	encabezado=[]
  	datos=[]



  	pdf.bounding_box([0,650],width: pdf.bounds.width) do
  	encabezado = [["#","NOMBRE","PATERNO","MATERNO","RFC","CURP","FECHA NACIMIENTO","CORREO","TELEFONO","ESTADO LABORAL","SALARIO MENSUAL","ESTUDIO","AÑOS LABORALES","RIESGO LABORAL","LOGIN","PASSWORD","LOCALIDAD"]]
  	i=0
  	datos = @clientes.collect { |clien|
  	i+=1
  	[i,clien.nombre,clien.paterno,clien.materno,clien.rfc,clien.curp,clien.fecha_nacimiento,clien.correo,clien.telefono,clien.estado_laboral,clien.salario_mensual,clien.estudio,clien.tiempo_laboral,clien.riesgo_trabajo,clien.login,clien.password,'C ' + clien.localidad.calle + ' ' + clien.localidad.exterior+ ' ' + clien.localidad.interior + ' COL ' + clien.localidad.colonia + ' ' + clien.localidad.codigo_postal + ' ' + clien.localidad.ciudad + ', ' + clien.localidad.estado.nombre]
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
