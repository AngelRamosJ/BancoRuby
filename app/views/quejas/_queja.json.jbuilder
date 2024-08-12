json.extract! queja, :id, :motivo, :descripcion, :fecha_suceso, :tipo, :confirmacion, :respuesta, :causante, :evidencia, :cliente_id, :created_at, :updated_at
json.url queja_url(queja, format: :json)
