class CitasController < ApplicationController
  before_action :set_cita, only: %i[ show edit update destroy ]

  # GET /citas or /citas.json
  def index
    values = {}
    if params[:hora_inicio].present?
      values[:hora_inicio] = params[:hora_inicio]
    end
    if params[:hora_final].present?
      values[:hora_final] = params[:hora_final]
    end
    @citas = Cita.where(values).paginate(:page => params[:page], :per_page => 5).order("fecha_encuentro")

    respond_to do |format|
       format.html
       format.pdf { send_data reporte_pdf(values), filename: "reporte_citas.pdf", type: 'application/pdf', dispotition: :attachment }
    end
  end

  # GET /citas/1 or /citas/1.json
  def show
    if @cita.tipo_atencion == 'E'
      @tipo_atencion = "Ejecutiva"
    elsif @cita.tipo_atencion == 'G'
      @tipo_atencion = "Gerencial"
    else
      @tipo_atencion = "Personalizada"
    end
    if @cita.confirmacion == 'S'
      @confirmacion = "Si"
    else
      @confirmacion = "No"
    end
    @cliente = @cita.cliente.nombre + ' ' + @cita.cliente.paterno + ' ' + @cita.cliente.paterno 
  end

  # GET /citas/new
  def new
    @cita = Cita.new
    @clientes = Cliente.all
    @departamentos = Departamento.all
  end

  # GET /citas/1/edit
  def edit
    @clientes = Cliente.all
    @departamentos = Departamento.all
  end

  # POST /citas or /citas.json
  def create
    @cita = Cita.new(cita_params)

    respond_to do |format|
      if @cita.save
        format.html { redirect_to @cita, notice: "Cita creada Exitosamente." }
        format.json { render :show, status: :created, location: @cita }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @cita.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /citas/1 or /citas/1.json
  def update
    respond_to do |format|
      if @cita.update(cita_params)
        format.html { redirect_to @cita, notice: "Cita actualizada Exitosamente." }
        format.json { render :show, status: :ok, location: @cita }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @cita.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /citas/1 or /citas/1.json
  def destroy
    @cita.destroy
    respond_to do |format|
      format.html { redirect_to citas_url, notice: "Cita eliminada Exitosamente." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_cita
      @cita = Cita.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def cita_params
      params.require(:cita).permit(:tipo_tramite, :motivo, :fecha_encuentro, :hora_inicio, :hora_final, :confirmacion, :tipo_atencion, :observacion, :cliente_id, :departamento_id)
    end

    def reporte_pdf(values)
    #Generar el pdf
    @citas = Cita.where(values).order('fecha_encuentro')

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
    pdf.text "Citas", align: :center, style: :bold
    pdf.move_down 10
    pdf.font_size 6



    #Cuerpo
    encabezado=[]
    datos=[]



    pdf.bounding_box([0,650],width: pdf.bounds.width) do
    encabezado = [["#","TIPO TRAMITE","MOTIVO","FECHA ENCUENTRO","HORA INICIO","HORA TERMINO","CONFIRMACION","TIPO ATENCION","CLIENTE","DEPARTAMENTO","OBSERVACION"]]
    i=0
    datos = @citas.collect { |cita|
    i+=1
    [i,cita.tipo_tramite,cita.motivo,cita.fecha_encuentro,cita.hora_inicio,cita.hora_final,cita.confirmacion,cita.tipo_atencion,cita.cliente.nombre + ' ' + cita.cliente.paterno + ' ' + cita.cliente.materno,cita.departamento.nombre,cita.observacion]
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
