class Pais < ApplicationRecord
	self.primary_key = 'id'
	self.sequence_name = 'auto_increment_paises'
end
