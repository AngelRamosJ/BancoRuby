class TrabajosController < ApplicationController
  rescue_from ActiveRecord::InvalidForeignKey, with: :no_borrar_trabajo 

  def inicio

    #Agregar Codigo para la busqueda

    values = {}
    if params[:salario_minimo].present?
      values[:salario_minimo] = params[:salario_minimo]
    end
    if params[:area].present?
      values[:area] = params[:area]
    end
    if params[:horas].present?
      values[:horas] = params[:horas]
    end

    @trabajos = Trabajo.where(values).paginate(:page => params[:page], :per_page => 5).order("area")

    respond_to do |format|
       format.html
       format.pdf { send_data reporte_pdf(values), filename: "reporte_trabajos.pdf", type: 'application/pdf', dispotition: :attachment }
    end

  end
 
  def nuevo_trabajo
  	@trabajo = Trabajo.new
  end

  def guardar_trabajo
  	@trabajo = Trabajo.new(nombre: params[:trabajo][:nombre], 
						   descripcion: params[:trabajo][:descripcion], 
						   :salario_minimo => params[:trabajo][:salario_minimo],  
						   salario_maximo: params[:trabajo][:salario_maximo], 
						   estudio_minimo: params[:trabajo][:estudio_minimo],  
						   area: params[:trabajo][:area],
						   horas: params[:trabajo][:horas], 
						   prestacion: params[:trabajo][:prestacion])
  	respond_to do |format|
  		if @trabajo.save
  			format.html{redirect_to trabajos_inicio_path, notice: "Trabajo creado exitosamente"}
  		end
  	end

  end

  def editar_trabajo
    @trabajo = Trabajo.find(params[:id])
  end

  def actualizar_trabajo
    @trabajo = Trabajo.find(params[:trabajo][:id])
    respond_to do |format|
      if @trabajo.update(nombre: params[:trabajo][:nombre], 
								   descripcion: params[:trabajo][:descripcion], 
								   :salario_minimo => params[:trabajo][:salario_minimo],  
								   salario_maximo: params[:trabajo][:salario_maximo], 
								   estudio_minimo: params[:trabajo][:estudio_minimo],  
								   area: params[:trabajo][:area],
								   horas: params[:trabajo][:horas], 
								   prestacion: params[:trabajo][:prestacion])
        format.html{redirect_to trabajos_inicio_path, notice: "Trabajo actualizado exitosamente"}
      end
    end
  end

  def mostrar_trabajo
    @trabajo = Trabajo.where('id = ?', params[:id]).first
  	if @trabajo.prestacion = 'S'
  		@prestacion = "Tiene prestaciones"
  	else
  		@prestacion = "No tiene prestaciones"
  	end
  end

  def eliminar_trabajo
    @trabajo = Trabajo.find(params[:id])
    respond_to do |format|
      if @trabajo.destroy
        format.html{redirect_to trabajos_inicio_path, alert: "Trabajo eliminado exitosamente"}
      end
    end
  end

  private
  def no_borrar_trabajo
    respond_to do |format|
      format.html{redirect_to trabajos_inicio_path, alert: "IMPOSIBLE Borrar el Trabajo, está información está siendo usada en otros Datos"}
    end
  end

  def reporte_pdf(values)
    #Generar el pdf
    @trabajos = Trabajo.where(values).order('area')

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
	pdf.text "trabajos", align: :center, style: :bold
	pdf.move_down 10
	pdf.font_size 6



	#Cuerpo
	encabezado=[]
	datos=[]



	pdf.bounding_box([0,650],width: pdf.bounds.width) do
	encabezado = [["#","NOMBRE","AREA","HORAS POR DIA","SALARIO MINIMO","SALARIO MAXIMO","ESTUDIO MINIMO","PRESTACIONES","DESCRIPCION"]]
	i=0
	datos = @trabajos.collect { |trab|
	i+=1
	[i,trab.nombre,trab.area,trab.horas,trab.salario_minimo,trab.salario_maximo,trab.estudio_minimo,trab.prestacion,trab.descripcion]
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
