class Estado < ApplicationRecord
  belongs_to :pais
  self.primary_key = 'id'
  self.sequence_name = 'auto_increment_estados'
end
