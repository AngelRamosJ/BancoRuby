json.extract! estado, :id, :nombre, :descripcion, :pais_id, :created_at, :updated_at
json.url estado_url(estado, format: :json)
