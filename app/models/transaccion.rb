class Transaccion < ApplicationRecord
  belongs_to :cliente
  self.primary_key = 'id'
  self.sequence_name = 'auto_increment_transacciones'
end
