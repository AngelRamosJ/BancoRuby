class Departamento < ApplicationRecord
	belongs_to :localidad
	self.primary_key = 'id'
	self.sequence_name = 'auto_increment_departamentos'
end
