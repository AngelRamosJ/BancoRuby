class QuejasController < ApplicationController
  before_action :set_queja, only: %i[ show edit update destroy ]

  # GET /quejas or /quejas.json
  def index
    values = {}
    if params[:motivo].present?
      values[:motivo] = params[:motivo]
    end
    if params[:fecha_suceso].present?
      values[:fecha_suceso] = params[:fecha_suceso]
    end
    @quejas = Queja.where(values).paginate(:page => params[:page], :per_page => 5).order("fecha_suceso")

    respond_to do |format|
       format.html
       format.pdf { send_data reporte_pdf(values), filename: "reporte_quejas.pdf", type: 'application/pdf', dispotition: :attachment }
    end
  end

  # GET /quejas/1 or /quejas/1.json
  def show
    if @queja.tipo == 'R'
      @tipo = "Reclamo"
    elsif @queja.tipo == 'S'
      @tipo = "Sugerencia"
    else
      @tipo = "Aclaración"
    end 
    if @queja.confirmacion == 'S'
      @confirmacion = "Si"
    else
      @confirmacion = "No"
    end
    if @queja.respuesta == 'S'
      @respuesta = "Si"
    else
      @respuesta = "No"
    end
    if @queja.causante == 'E'
      @causante = "Empleado"
    elsif @queja.causante == 'C'
      @causante = "Cliente"
    elsif @queja.causante == 'S'
      @causante = "Sucursal"
    else
      @causante = "Persona Ajena"
    end
    if @queja.evidencia == 'S'
      @evidencia = "Si"
    else
      @evidencia = "No"
    end
    @cliente = @queja.cliente.nombre + ' ' + @queja.cliente.paterno + ' ' + @queja.cliente.paterno 
  end

  # GET /quejas/new
  def new
    @queja = Queja.new
    @clientes = Cliente.all
  end

  # GET /quejas/1/edit
  def edit
    @clientes = Cliente.all
  end

  # POST /quejas or /quejas.json
  def create
    @queja = Queja.new(queja_params)

    respond_to do |format|
      if @queja.save
        format.html { redirect_to @queja, notice: "Queja creada Exitosamente." }
        format.json { render :show, status: :created, location: @queja }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @queja.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /quejas/1 or /quejas/1.json
  def update
    respond_to do |format|
      if @queja.update(queja_params)
        format.html { redirect_to @queja, notice: "Queja actualizada Exitosamente.." }
        format.json { render :show, status: :ok, location: @queja }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @queja.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /quejas/1 or /quejas/1.json
  def destroy
    @queja.destroy
    respond_to do |format|
      format.html { redirect_to quejas_url, notice: "Queja eliminada Exitosamente." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_queja
      @queja = Queja.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def queja_params
      params.require(:queja).permit(:motivo, :descripcion, :fecha_suceso, :tipo, :confirmacion, :respuesta, :causante, :evidencia, :cliente_id)
    end

    def reporte_pdf(values)
    #Generar el pdf
    @quejas = Queja.where(values).order('fecha_suceso')

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
    pdf.text "Quejas", align: :center, style: :bold
    pdf.move_down 10
    pdf.font_size 6



    #Cuerpo
    encabezado=[]
    datos=[]



    pdf.bounding_box([0,650],width: pdf.bounds.width) do
    encabezado = [["#","MOTIVO","FECHA SUCESO","TIPO","CONFIRMACION","RESPUESTA","CAUSANTE","EVIDENCIA","CLIENTE","DESCRIPCION"]]
    i=0
    datos = @quejas.collect { |queja|
    i+=1
    [i,queja.motivo,queja.fecha_suceso,queja.tipo,queja.confirmacion,queja.respuesta,queja.causante,queja.evidencia,queja.cliente.nombre + ' ' + queja.cliente.paterno + ' ' + queja.cliente.materno,queja.descripcion]
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
