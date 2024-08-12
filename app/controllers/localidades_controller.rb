class LocalidadesController < ApplicationController
  rescue_from ActiveRecord::InvalidForeignKey, with: :no_borrar_localidad
  before_action :set_localidad, only: %i[ show edit update destroy ]

  # GET /localidades or /localidades.json
  def index
    values = {}
    if params[:municipio].present?
      values[:municipio] = params[:municipio]
    end
    if params[:ciudad].present?
      values[:ciudad] = params[:ciudad]
    end
    if params[:codigo_postal].present?
      values[:codigo_postal] = params[:codigo_postal]
    end
    @localidades = Localidad.where(values).paginate(:page => params[:page], :per_page => 5).order("ciudad")

    respond_to do |format|
       format.html
       format.pdf { send_data reporte_pdf(values), filename: "reporte_localidades.pdf", type: 'application/pdf', dispotition: :attachment }
    end
  end

  # GET /localidades/1 or /localidades/1.json
  def show
  end

  # GET /localidades/new
  def new
    @localidad = Localidad.new
    @estados = Estado.all
  end

  # GET /localidades/1/edit
  def edit
    @estados = Estado.all
  end

  # POST /localidades or /localidades.json
  def create
    @localidad = Localidad.new(localidad_params)

    respond_to do |format|
      if @localidad.save
        format.html { redirect_to @localidad, notice: "Localidad creada exitosamente." }
        format.json { render :show, status: :created, location: @localidad }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @localidad.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /localidades/1 or /localidades/1.json
  def update
    respond_to do |format|
      if @localidad.update(localidad_params)
        format.html { redirect_to @localidad, notice: "Localidad actualizada exitosamente." }
        format.json { render :show, status: :ok, location: @localidad }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @localidad.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /localidades/1 or /localidades/1.json
  def destroy
    @localidad.destroy
    respond_to do |format|
      format.html { redirect_to localidades_url, notice: "Localidad eliminada exitosamente." }
      format.json { head :no_content }
    end
  end

  private
  def no_borrar_localidad
    respond_to do |format|
      format.html{redirect_to localidades_path, alert: "IMPOSIBLE Borrar la Localidad, está información está siendo usada en otros Datos"}
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_localidad
      @localidad = Localidad.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def localidad_params
      params.require(:localidad).permit(:tipo, :codigo_postal, :municipio, :ciudad, :colonia, :calle, :exterior, :interior, :estado_id)
    end

    def reporte_pdf(values)
    #Generar el pdf
    @localidades = Localidad.where(values).order('ciudad')

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
    pdf.text "Localidades", align: :center, style: :bold
    pdf.move_down 10
    pdf.font_size 6



    #Cuerpo
    encabezado=[]
    datos=[]



    pdf.bounding_box([0,650],width: pdf.bounds.width) do
    encabezado = [["#","CODIGO POSTAL","TIPO","MUNICIPIO","CIUDAD","COLONIA","CALLE","EXTERIOR","INTERIOR","ESTADO"]]
    i=0
    datos = @localidades.collect { |local|
    i+=1
    [i,local.codigo_postal,local.tipo,local.municipio,local.ciudad,local.colonia,local.calle,local.exterior,local.interior,local.estado.nombre]
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
