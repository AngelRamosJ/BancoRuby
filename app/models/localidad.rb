class Localidad < ApplicationRecord
  belongs_to :estado
  self.primary_key = 'id'
  self.sequence_name = 'auto_increment_localidades'
end
