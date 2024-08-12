class Prueba < ApplicationRecord
	ignore_columns = :id
	self.primary_key = 'id'
	self.sequence_name = 'secuencia_id'
end
