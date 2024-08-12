class ApplicationController < ActionController::Base
	before_action :login_empleado?

	#Método para controlar la sesión
	def login_empleado?
		if session[:empleado_id].nil?
			redirect_to login_empleado_path, alert: 'Debes iniciar sesión.' 
		end
	end
end
