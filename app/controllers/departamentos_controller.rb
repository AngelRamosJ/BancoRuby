class DepartamentosController < ApplicationController
  rescue_from ActiveRecord::InvalidForeignKey, with: :no_borrar_departamento
  def inicio
  	#@usuarios = Usuario.all

    #Agregar Codigo para la busqueda

    values = {}
    if params[:nombre].present?
      values[:nombre] = params[:nombre]
    end
    if params[:maximo_empleados].present?
      values[:maximo_empleados] = params[:maximo_empleados]
    end
    if params[:hora_apertura].present?
      values[:hora_apertura] = params[:hora_apertura]
    end

    @departamentos = Departamento.where(values).paginate(:page => params[:page], :per_page => 5).order("nombre")

    respond_to do |format|
       format.html
       format.pdf { send_data reporte_pdf(values), filename: "reporte_departamentos.pdf", type: 'application/pdf', dispotition: :attachment }
    end

  end
 
  def nuevo_departamento
  	@departamento = Departamento.new
    @localidades = Localidad.all
  end

  def guardar_departamento
  	@departamento = Departamento.new(nombre: params[:departamento][:nombre], 
            						   telefono: params[:departamento][:telefono], 
            						   :maximo_empleados => params[:departamento][:maximo_empleados],  
            						   fondo: params[:departamento][:fondo], 
            						   fecha_creacion: params[:departamento][:fecha_creacion], 
            						   estado: params[:departamento][:estado], 
            						   hora_apertura: params[:departamento][:hora_apertura], 
            						   hora_cierre: params[:departamento][:hora_cierre], 
            						   localidad_id: params[:departamento][:localidad_id])
  	respond_to do |format|
  		if @departamento.save
  			format.html{redirect_to departamentos_inicio_path, notice: "Departamento creado exitosamente"}
  		end
  	end

  end

  def editar_departamento
    @departamento = Departamento.find(params[:id])
    @localidades = Localidad.all
  end

  def actualizar_departamento
    @departamento = Departamento.find(params[:departamento][:id])
    respond_to do |format|
      if @departamento.update(nombre: params[:departamento][:nombre], 
            						   telefono: params[:departamento][:telefono], 
            						   :maximo_empleados => params[:departamento][:maximo_empleados],  
            						   fondo: params[:departamento][:fondo], 
            						   fecha_creacion: params[:departamento][:fecha_creacion], 
            						   estado: params[:departamento][:estado], 
            						   hora_apertura: params[:departamento][:hora_apertura], 
            						   hora_cierre: params[:departamento][:hora_cierre], 
            						   localidad_id: params[:departamento][:localidad_id])
        format.html{redirect_to departamentos_inicio_path, notice: "Departamento actualizado exitosamente"}
      end
    end
  end

  def mostrar_departamento
    @departamento = Departamento.where('id = ?', params[:id]).first
  	if @departamento.estado = 'A'
  		@estadoDep = "Activo"
  	elsif @departamento.estado = 'C'
  		@estadoDep = "Cerrado"
  	else
  		@estadoDep = "En Mantenimiento"
  	end
  	@localidad = 'C ' + @departamento.localidad.calle + ' ' + @departamento.localidad.exterior+ ' ' + @departamento.localidad.interior + ' COL ' + @departamento.localidad.colonia + ' ' + @departamento.localidad.codigo_postal + ' ' + @departamento.localidad.ciudad + ', ' + @departamento.localidad.estado.nombre
  end

  def eliminar_departamento
    @departamento = Departamento.find(params[:id])
    respond_to do |format|
      if @departamento.destroy
        format.html{redirect_to departamentos_inicio_path, alert: "Departamento eliminado exitosamente"}
      end
    end
  end

  private
  def no_borrar_departamento
    respond_to do |format|
      format.html{redirect_to departamentos_inicio_path, alert: "IMPOSIBLE Borrar el Departamento, está información está siendo usada en otros Datos"}
    end
  end

  def reporte_pdf(values)
    #Generar el pdf
    @departamentos = Departamento.where(values).order('nombre')

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
  	pdf.text "Departamentos", align: :center, style: :bold
  	pdf.move_down 10
  	pdf.font_size 6



  	#Cuerpo
  	encabezado=[]
  	datos=[]



  	pdf.bounding_box([0,650],width: pdf.bounds.width) do
  	encabezado = [["#","NOMBRE","TELEFONO","MAXIMO DE EMPLEADOS","FONDOS","FECHA DE CREACION","ESTADO","HORA DE APERTURA","HORA DE CIERRE","LOCALIDAD"]]
  	i=0
  	datos = @departamentos.collect { |depto|
  	i+=1
  	[i,depto.nombre,depto.telefono,depto.maximo_empleados,depto.fondo,depto.fecha_creacion,depto.estado,depto.hora_apertura,depto.hora_cierre,'C ' + depto.localidad.calle + ' ' + depto.localidad.exterior+ ' ' + depto.localidad.interior + ' COL ' + depto.localidad.colonia + ' ' + depto.localidad.codigo_postal + ' ' + depto.localidad.ciudad + ', ' + depto.localidad.estado.nombre]
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
