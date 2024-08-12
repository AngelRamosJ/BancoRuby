class Cita < ApplicationRecord
  belongs_to :cliente
  belongs_to :departamento
  self.primary_key = 'id'
  self.sequence_name = 'auto_increment_citas'
end
