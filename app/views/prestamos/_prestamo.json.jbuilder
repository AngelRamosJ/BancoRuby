json.extract! prestamo, :id, :descripcion, :cantidad, :intereses, :fecha_expedicion, :fecha_termino, :tiempo_tolerancia, :modo_pago, :estado, :cliente_id, :created_at, :updated_at
json.url prestamo_url(prestamo, format: :json)
