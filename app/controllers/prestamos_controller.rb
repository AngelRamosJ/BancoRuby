class PrestamosController < ApplicationController
  before_action :set_prestamo, only: %i[ show edit update destroy ]

  # GET /prestamos or /prestamos.json
  def index
    values = {}
    if params[:cantidad].present?
      values[:cantidad] = params[:cantidad]
    end
    if params[:intereses].present?
      values[:intereses] = params[:intereses]
    end
    if params[:tiempo_tolerancia].present?
      values[:tiempo_tolerancia] = params[:tiempo_tolerancia]
    end
    @prestamos = Prestamo.where(values).paginate(:page => params[:page], :per_page => 5).order("modo_pago")

    respond_to do |format|
       format.html
       format.pdf { send_data reporte_pdf(values), filename: "reporte_prestamos.pdf", type: 'application/pdf', dispotition: :attachment }
    end
  end

  # GET /prestamos/1 or /prestamos/1.json
  def show
    if @prestamo.modo_pago == 'E'
      @pagoPrestamo = "Efectivo"
    elsif @prestamo.modo_pago == 'T'
      @pagoPrestamo = "Tarjeta"
    else
      @pagoPrestamo = "Nomina"
    end
    if @prestamo.estado == 'E'
      @estadoPrestamo = "Estable"
    elsif @prestamo.estado == 'A'
      @estadoPrestamo = "Atrasado"
    else
      @estadoPrestamo = "Pagado"
    end
    @cliente = @prestamo.cliente.nombre + ' ' + @prestamo.cliente.paterno + ' ' + @prestamo.cliente.paterno 
  end

  # GET /prestamos/new
  def new
    @prestamo = Prestamo.new
    @clientes = Cliente.all
  end

  # GET /prestamos/1/edit
  def edit
    @clientes = Cliente.all
  end

  # POST /prestamos or /prestamos.json
  def create
    @prestamo = Prestamo.new(prestamo_params)

    respond_to do |format|
      if @prestamo.save
        format.html { redirect_to @prestamo, notice: "Préstamo creado Exitosamente." }
        format.json { render :show, status: :created, location: @prestamo }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @prestamo.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /prestamos/1 or /prestamos/1.json
  def update
    respond_to do |format|
      if @prestamo.update(prestamo_params)
        format.html { redirect_to @prestamo, notice: "Préstamo actualizado Exitosamente." }
        format.json { render :show, status: :ok, location: @prestamo }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @prestamo.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /prestamos/1 or /prestamos/1.json
  def destroy
    @prestamo.destroy
    respond_to do |format|
      format.html { redirect_to prestamos_url, notice: "Préstamo eliminado Exitosamente." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_prestamo
      @prestamo = Prestamo.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def prestamo_params
      params.require(:prestamo).permit(:descripcion, :cantidad, :intereses, :fecha_expedicion, :fecha_termino, :tiempo_tolerancia, :modo_pago, :estado, :cliente_id)
    end

    def reporte_pdf(values)
    #Generar el pdf
    @prestamos = Prestamo.where(values).order('modo_pago')

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
    pdf.text "Préstamos", align: :center, style: :bold
    pdf.move_down 10
    pdf.font_size 6



    #Cuerpo
    encabezado=[]
    datos=[]



    pdf.bounding_box([0,650],width: pdf.bounds.width) do
    encabezado = [["#","DESCRIPCION","CANTIDAD","INTERESES","FECHA EXPEDICION","FECHA TERMINO","DIAS DE TOLERANCIA","MODO DE PAGO","ESTADO","CLIENTE"]]
    i=0
    datos = @prestamos.collect { |prest|
    i+=1
    [i,prest.descripcion,prest.cantidad,prest.intereses,prest.fecha_expedicion,prest.fecha_termino,prest.tiempo_tolerancia,prest.modo_pago,prest.estado,prest.cliente.nombre + ' ' + prest.cliente.paterno + ' ' + prest.cliente.materno]
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
