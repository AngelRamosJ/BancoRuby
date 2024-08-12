Rails.application.routes.draw do
  #get 'ejemplos/inicio'
  resources :pruebas
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"


  match '/ejemplos' => 'ejemplos#inicio', via: :get, :as => :ejemplos_inicio



  resources :transacciones
  get 'operaciones/inicio'
  get 'sesiones/login'
  #get 'ahorros/inicio'
  #get 'debitos/inicio'
  resources :citas
  resources :quejas
  resources :prestamos
  #get 'clientes/inicio'
  #get 'empleados/inicio'
  #get 'trabajos/inicio'
  #get 'departamentos/inicio'
  resources :localidades
  resources :estados
  resources :paises
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html



  match '/departamentos' => 'departamentos#inicio', via: :get, :as => :departamentos_inicio
  match '/departamento/nuevo' => 'departamentos#nuevo_departamento', via: :get, :as => :nuevo_departamento
  match '/departamentos' => 'departamentos#guardar_departamento', via: :post, :as => :guardar_departamento
  match '/departamento/actualizar' => 'departamentos#actualizar_departamento', via: :patch, :as => :actualizar_departamento
  match '/departamentos/:id/editar' => 'departamentos#editar_departamento', via: :get, :as => :editar_departamento
  match '/departamentos/:id/mostrar' => 'departamentos#mostrar_departamento', via: :get, :as => :mostrar_departamento
  match '/departamentos/:id/eliminar' => 'departamentos#eliminar_departamento', via: :delete, :as => :eliminar_departamento
  match '/departamentos/:id/eliminar' => 'departamentos#eliminar_departamento', via: :get
  match '/buscar_departamentos' => 'departamentos#inicio', via: :post, :as => :buscar_departamentos


  match '/trabajos' => 'trabajos#inicio', via: :get, :as => :trabajos_inicio
  match '/trabajo/nuevo' => 'trabajos#nuevo_trabajo', via: :get, :as => :nuevo_trabajo
  match '/trabajos' => 'trabajos#guardar_trabajo', via: :post, :as => :guardar_trabajo
  match '/trabajo/actualizar' => 'trabajos#actualizar_trabajo', via: :patch, :as => :actualizar_trabajo
  match '/trabajos/:id/editar' => 'trabajos#editar_trabajo', via: :get, :as => :editar_trabajo
  match '/trabajos/:id/mostrar' => 'trabajos#mostrar_trabajo', via: :get, :as => :mostrar_trabajo
  match '/trabajos/:id/eliminar' => 'trabajos#eliminar_trabajo', via: :delete, :as => :eliminar_trabajo
  match '/trabajos/:id/eliminar' => 'trabajos#eliminar_trabajo', via: :get
  match '/buscar_trabajos' => 'trabajos#inicio', via: :post, :as => :buscar_trabajos

  match '/buscar_localidades' => 'localidades#index', via: :post, :as => :buscar_localidades

  match '/empleados' => 'empleados#inicio', via: :get, :as => :empleados_inicio
  match '/empleado/nuevo' => 'empleados#nuevo_empleado', via: :get, :as => :nuevo_empleado
  match '/empleados' => 'empleados#guardar_empleado', via: :post, :as => :guardar_empleado
  match '/empleado/actualizar' => 'empleados#actualizar_empleado', via: :patch, :as => :actualizar_empleado
  match '/empleados/:id/editar' => 'empleados#editar_empleado', via: :get, :as => :editar_empleado
  match '/empleados/:id/mostrar' => 'empleados#mostrar_empleado', via: :get, :as => :mostrar_empleado
  match '/empleados/:id/eliminar' => 'empleados#eliminar_empleado', via: :delete, :as => :eliminar_empleado
  match '/empleados/:id/eliminar' => 'empleados#eliminar_empleado', via: :get
  match '/buscar_empleados' => 'empleados#inicio', via: :post, :as => :buscar_empleados

  match '/clientes' => 'clientes#inicio', via: :get, :as => :clientes_inicio
  match 'clienteo/nuevo' => 'clientes#nuevo_cliente', via: :get, :as => :nuevo_cliente
  match '/clientes' => 'clientes#guardar_cliente', via: :post, :as => :guardar_cliente
  match 'clienteo/actualizar' => 'clientes#actualizar_cliente', via: :patch, :as => :actualizar_cliente
  match '/clientes/:id/editar' => 'clientes#editar_cliente', via: :get, :as => :editar_cliente
  match '/clientes/:id/mostrar' => 'clientes#mostrar_cliente', via: :get, :as => :mostrar_cliente
  match '/clientes/:id/eliminar' => 'clientes#eliminar_cliente', via: :delete, :as => :eliminar_cliente
  match '/clientes/:id/eliminar' => 'clientes#eliminar_cliente', via: :get
  match '/buscar_clientes' => 'clientes#inicio', via: :post, :as => :buscar_clientes

  match '/buscar_prestamos' => 'prestamos#index', via: :post, :as => :buscar_prestamos
  match '/buscar_citas' => 'citas#index', via: :post, :as => :buscar_citas
  match '/buscar_quejas' => 'quejas#index', via: :post, :as => :buscar_quejas

  match '/debitos' => 'debitos#inicio', via: :get, :as => :debitos_inicio
  match '/debito/nuevo' => 'debitos#nuevo_cuenta_debito', via: :get, :as => :nuevo_debito
  match '/debitos' => 'debitos#guardar_debito', via: :post, :as => :guardar_debito
  match '/debito/actualizar' => 'debitos#actualizar_debito', via: :patch, :as => :actualizar_debito
  match '/debitos/:id/editar' => 'debitos#editar_cuenta_debito', via: :get, :as => :editar_debito
  match '/debitos/:id/mostrar' => 'debitos#mostrar_cuenta_debito', via: :get, :as => :mostrar_debito
  match '/debitos/:id/eliminar' => 'debitos#eliminar_debito', via: :delete, :as => :eliminar_debito
  match '/debitos/:id/eliminar' => 'debitos#eliminar_debito', via: :get
  match '/buscar_debitos' => 'debitos#inicio', via: :post, :as => :buscar_debitos

  match '/ahorros' => 'ahorros#inicio', via: :get, :as => :ahorros_inicio
  match '/ahorro/nuevo' => 'ahorros#nuevo_cuenta_ahorro', via: :get, :as => :nuevo_ahorro
  match '/ahorros' => 'ahorros#guardar_ahorro', via: :post, :as => :guardar_ahorro
  match '/ahorro/actualizar' => 'ahorros#actualizar_ahorro', via: :patch, :as => :actualizar_ahorro
  match '/ahorros/:id/editar' => 'ahorros#editar_cuenta_ahorro', via: :get, :as => :editar_ahorro
  match '/ahorros/:id/mostrar' => 'ahorros#mostrar_cuenta_ahorro', via: :get, :as => :mostrar_ahorro
  match '/ahorros/:id/eliminar' => 'ahorros#eliminar_ahorro', via: :delete, :as => :eliminar_ahorro
  match '/ahorros/:id/eliminar' => 'ahorros#eliminar_ahorro', via: :get
  match '/buscar_ahorros' => 'ahorros#inicio', via: :post, :as => :buscar_ahorros


  match '/validar_rfc_empleado' => 'empleados#validar_rfc_empleado', via: :get, :as => :validar_rfc_empleado
  match '/validar_curp_empleado' => 'empleados#validar_curp_empleado', via: :get, :as => :validar_curp_empleado
  match '/validar_login_empleado' => 'empleados#validar_login_empleado', via: :get, :as => :validar_login_empleado

  match '/validar_rfc_cliente' => 'clientes#validar_rfc_cliente', via: :get, :as => :validar_rfc_cliente
  match '/validar_curp_cliente' => 'clientes#validar_curp_cliente', via: :get, :as => :validar_curp_cliente
  match '/validar_login_cliente' => 'clientes#validar_login_cliente', via: :get, :as => :validar_login_cliente

  match '/validar_clabe_ahorro' => 'ahorros#validar_clabe_ahorro', via: :get, :as => :validar_clabe_ahorro
  match '/validar_tarjeta_ahorro' => 'ahorros#validar_tarjeta_ahorro', via: :get, :as => :validar_tarjeta_ahorro

  match '/validar_clabe_debito' => 'debitos#validar_clabe_debito', via: :get, :as => :validar_clabe_debito
  match '/validar_tarjeta_debito' => 'debitos#validar_tarjeta_debito', via: :get, :as => :validar_tarjeta_debito

  match '/login_empleado' => 'sesiones#login_empleado', via: :get, :as => :login_empleado
  match '/login_empleado' => 'sesiones#validar_empleado', via: :post, :as => :validar_empleado
  match '/cerrar_sesion_empleado' => 'sesiones#cerrar_sesion_empleado', via: :get, :as => :cerrar_sesion_empleado

  match '/login_cliente' => 'sesiones#login_cliente', via: :get, :as => :login_cliente
  match '/login_cliente' => 'sesiones#validar_cliente', via: :post, :as => :validar_cliente
  match '/cerrar_sesion_cliente' => 'sesiones#cerrar_sesion_cliente', via: :get, :as => :cerrar_sesion_cliente

  match '/cliente' => 'operaciones#inicio', via: :get, :as => :inicio_cliente
  match '/cliente/transferir' => 'operaciones#transferir', via: :get, :as => :transferir
  match '/cliente/transferir' => 'operaciones#transferir_monto_cuentas', via: :post, :as => :transferir_monto_cuentas
  match '/cliente/depositar' => 'operaciones#depositar', via: :get, :as => :depositar
  match '/cliente/depositar' => 'operaciones#depositar_monto_cuenta', via: :post, :as => :depositar_monto_cuenta
  match '/cliente/consultar' => 'operaciones#consultar', via: :get, :as => :consultar
  match '/cliente/consultar' => 'operaciones#consultar', via: :post, :as => :buscar_transacciones

  match '/validar_clabe' => 'operaciones#validar_clabe', via: :get, :as => :validar_clabe
  match '/validar_tarjeta' => 'operaciones#validar_tarjeta', via: :get, :as => :validar_tarjeta



end
