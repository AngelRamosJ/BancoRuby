json.extract! transaccion, :id, :monto_nuevo, :monto_anterior, :fecha_creacion, :mes, :hora_creacion, :tipo_envio, :clabe_origen, :clabe_destino, :tarjeta_destino, :cliente_id, :created_at, :updated_at
json.url transaccion_url(transaccion, format: :json)
