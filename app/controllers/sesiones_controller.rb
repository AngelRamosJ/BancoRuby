class SesionesController < ApplicationController
	layout 'application_login'
	skip_before_action :login_empleado?, only: [ :login_empleado, :validar_empleado, :login_cliente, :validar_cliente, :cerrar_sesion_empleado, :cerrar_sesion_cliente ] 
	def login_empleado
	end

	def validar_empleado
		@empleado = Empleado.where('login = ? and password = ?',params[:nombre],params[:contraseña]).first # [] | [[]] | [[],[],[]]
		if @empleado.nil?
			validar = false
		else
			validar = true
			session[:empleado_id] = @empleado.id
			session[:nombre_empleado] = @empleado.nombre+' '+@empleado.paterno+' '+@empleado.materno
		end
		respond_to do |format|
			if validar
				format.html { redirect_to empleados_inicio_path, notice: 'Empleado valido.' }
			else
				format.html { redirect_to login_empleado_path, alert: 'Empleado/Contraseña no validos.' }
			end
		end
	end

	def cerrar_sesion_empleado
		session[:empleado_id] = nil
		session[:nombre_empleado] = nil
		redirect_to login_empleado_path, alert: 'Sesión Terminada.'
	end

	def login_cliente
	end

	def validar_cliente
		@cliente = Cliente.where('login = ? and password = ?',params[:nombre],params[:contraseña]).first # [] | [[]] | [[],[],[]]
		if @cliente.nil?
			validar = false
		else
			validar = true
			session[:cliente_id] = @cliente.id
			session[:nombre_cliente] = @cliente.nombre+' '+@cliente.paterno+' '+@cliente.materno
		end
		respond_to do |format|
			if validar
				format.html { redirect_to inicio_cliente_path, notice: 'Cliente valido.' }
			else
				format.html { redirect_to login_cliente_path, alert: 'Cliente/Contraseña no validos.' }
			end
		end
	end

	def cerrar_sesion_cliente
		session[:cliente_id] = nil
		session[:nombre_cliente] = nil
		redirect_to login_cliente_path, alert: 'Sesión Terminada.'
	end

end
