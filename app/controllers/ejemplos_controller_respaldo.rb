class EjemplosController < ApplicationController
  def inicio
  	@ejemplos = Ejemplo.all
  end

end