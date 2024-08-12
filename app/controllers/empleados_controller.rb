class EmpleadosController < ApplicationController
  def inicio
  	#@usuarios = Usuario.all

    #Agregar Codigo para la busqueda

    values = {}
    if params[:paterno].present?
      values[:paterno] = params[:paterno]
    end
    if params[:rfc].present?
      values[:rfc] = params[:rfc]
    end
    if params[:curp].present?
      values[:curp] = params[:curp]
    end
    if params[:salario].present?
      values[:salario] = params[:salario]
    end

    @empleados = Empleado.where(values).paginate(:page => params[:page], :per_page => 5).order("paterno")

    respond_to do |format|
       format.html
       format.pdf { send_data reporte_pdf(values), filename: "reporte_empleados.pdf", type: 'application/pdf', dispotition: :attachment }
    end

  end
 
  def nuevo_empleado
  	@empleado = Empleado.new
    @localidades = Localidad.all
    @departamentos = Departamento.all
    @trabajos = Trabajo.all
  end

  def guardar_empleado
  	@empleado = Empleado.new(nombre: params[:empleado][:nombre], 
            							   paterno: params[:empleado][:paterno], 
            							   :materno => params[:empleado][:materno],  
            							   rfc: params[:empleado][:rfc], 
            							   curp: params[:empleado][:curp], 
            							   fecha_nacimiento: params[:empleado][:fecha_nacimiento], 
            							   correo: params[:empleado][:correo], 
            							   telefono: params[:empleado][:telefono], 
            							   salario: params[:empleado][:salario],
            							   fecha_contratacion: params[:empleado][:fecha_contratacion],
            							   bono: params[:empleado][:bono],
                             descuento: params[:empleado][:descuento],
                             prestacion_dinero: params[:empleado][:prestacion_dinero],
                             login: params[:empleado][:login],
            							   password: params[:empleado][:password],
            							   localidad_id: params[:empleado][:localidad_id],
            							   departamento_id: params[:empleado][:departamento_id],
            							   trabajo_id: params[:empleado][:trabajo_id])
  	respond_to do |format|
  		if @empleado.save
  			format.html{redirect_to empleados_inicio_path, notice: "Empleado creado exitosamente"}
  		end
  	end

  end

  def editar_empleado
    @empleado = Empleado.find(params[:id])
    @localidades = Localidad.all
    @departamentos = Departamento.all
    @trabajos = Trabajo.all
  end

  def actualizar_empleado
    @empleado = Empleado.find(params[:empleado][:id])
    respond_to do |format|
      if @empleado.update(nombre: params[:empleado][:nombre], 
                                     paterno: params[:empleado][:paterno], 
                                     :materno => params[:empleado][:materno],  
                                     rfc: params[:empleado][:rfc], 
                                     curp: params[:empleado][:curp], 
                                     fecha_nacimiento: params[:empleado][:fecha_nacimiento], 
                                     correo: params[:empleado][:correo], 
                                     telefono: params[:empleado][:telefono], 
                                     salario: params[:empleado][:salario],
                                     fecha_contratacion: params[:empleado][:fecha_contratacion],
                                     bono: params[:empleado][:bono],
                                     descuento: params[:empleado][:descuento],
                                     prestacion_dinero: params[:empleado][:prestacion_dinero],
                                     login: params[:empleado][:login],
                                     password: params[:empleado][:password],
                                     localidad_id: params[:empleado][:localidad_id],
                                     departamento_id: params[:empleado][:departamento_id],
                                     trabajo_id: params[:empleado][:trabajo_id])
        format.html{redirect_to empleados_inicio_path, notice: "Empleado actualizado exitosamente"}
      end
    end
  end

  def mostrar_empleado
    @empleado = Empleado.where('id = ?', params[:id]).first
  	
  	@localidad = 'C ' + @empleado.localidad.calle + ' ' + @empleado.localidad.exterior+ ' ' + @empleado.localidad.interior + ' COL ' + @empleado.localidad.colonia + ' ' + @empleado.localidad.codigo_postal + ' ' + @empleado.localidad.ciudad + ', ' + @empleado.localidad.estado.nombre
  end

  def eliminar_empleado
    @empleado = Empleado.find(params[:id])
    respond_to do |format|
      if @empleado.destroy
        format.html{redirect_to empleados_inicio_path, alert: "Empleado eliminado exitosamente"}
      end
    end
  end

  def validar_rfc_empleado
    #verificar que el RFC sea unico en Base de Datos. Necesitamos el RFC
    @empleado = Empleado.where('rfc = ?',params[:empleado][:rfc]).first # [nombre: '', rfc = ''], nil
    respond_to do |format|

      format.js {render json: { validar: @empleado.nil? ? true : false}, content_type: 'text/json'}
    end
  end

  def validar_curp_empleado
    #verificar que el RFC sea unico en Base de Datos. Necesitamos la CURP
    @empleado = Empleado.where('curp = ?',params[:empleado][:curp]).first
    respond_to do |format|

      format.js {render json: { validar: @empleado.nil? ? true : false}, content_type: 'text/json'}
    end
  end

  def validar_login_empleado
    #verificar que el RFC sea unico en Base de Datos. Necesitamos la CURP
    @empleado = Empleado.where('login = ?',params[:empleado][:login]).first
    respond_to do |format|

      format.js {render json: { validar: @empleado.nil? ? true : false}, content_type: 'text/json'}
    end
  end

  def reporte_pdf(values)
    #Generar el pdf
    @empleados = Empleado.where(values).order('paterno')

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
  	pdf.text "empleados", align: :center, style: :bold
  	pdf.move_down 10
  	pdf.font_size 6



  	#Cuerpo
  	encabezado=[]
  	datos=[]



  	pdf.bounding_box([0,650],width: pdf.bounds.width) do
  	encabezado = [["#","NOMBRE","PATERNO","MATERNO","RFC","CURP","FECHA NACIMIENTO","CORREO","TELEFONO","DEPARTAMENTO","TRABAJO","SALARIO","FECHA CONTRATACION","BONOS","DESCUENTOS","¿PRESTAMO DE DINERO?","LOGIN","PASSWORD","LOCALIDAD"]]
  	i=0
  	datos = @empleados.collect { |emple|
  	i+=1
  	[i,emple.nombre,emple.paterno,emple.materno,emple.rfc,emple.curp,emple.fecha_nacimiento,emple.correo,emple.telefono,emple.departamento.nombre,emple.trabajo.nombre,emple.salario,emple.fecha_contratacion,emple.bono,emple.descuento,emple.prestacion_dinero,emple.login,emple.password,'C ' + emple.localidad.calle + ' ' + emple.localidad.exterior+ ' ' + emple.localidad.interior + ' COL ' + emple.localidad.colonia + ' ' + emple.localidad.codigo_postal + ' ' + emple.localidad.ciudad + ', ' + emple.localidad.estado.nombre]
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
