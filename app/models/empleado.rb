class Empleado < ApplicationRecord
	belongs_to :localidad
	belongs_to :departamento
	belongs_to :trabajo
	self.primary_key = 'id'
	self.sequence_name = 'auto_increment_empleados'
end
