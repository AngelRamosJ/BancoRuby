class TransaccionesController < ApplicationController
  before_action :set_transaccion, only: %i[ show edit update destroy ]

  # GET /transacciones or /transacciones.json
  def index
    @transacciones = Transaccion.all
  end

  # GET /transacciones/1 or /transacciones/1.json
  def show
  end

  # GET /transacciones/new
  def new
    @transaccion = Transaccion.new
  end

  # GET /transacciones/1/edit
  def edit
  end

  # POST /transacciones or /transacciones.json
  def create
    @transaccion = Transaccion.new(transaccion_params)

    respond_to do |format|
      if @transaccion.save
        format.html { redirect_to @transaccion, notice: "Transaccion was successfully created." }
        format.json { render :show, status: :created, location: @transaccion }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @transaccion.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /transacciones/1 or /transacciones/1.json
  def update
    respond_to do |format|
      if @transaccion.update(transaccion_params)
        format.html { redirect_to @transaccion, notice: "Transaccion was successfully updated." }
        format.json { render :show, status: :ok, location: @transaccion }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @transaccion.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /transacciones/1 or /transacciones/1.json
  def destroy
    @transaccion.destroy
    respond_to do |format|
      format.html { redirect_to transacciones_url, notice: "Transaccion was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_transaccion
      @transaccion = Transaccion.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def transaccion_params
      params.require(:transaccion).permit(:monto_nuevo, :monto_anterior, :fecha_creacion, :mes, :hora_creacion, :tipo_envio, :clabe_origen, :clabe_destino, :tarjeta_destino, :cliente_id)
    end
end
