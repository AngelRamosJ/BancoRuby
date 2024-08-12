json.extract! cita, :id, :tipo_tramite, :motivo, :fecha_encuentro, :hora_inicio, :hora_final, :confirmacion, :tipo_atencion, :observacion, :cliente_id, :departamento_id, :created_at, :updated_at
json.url cita_url(cita, format: :json)
