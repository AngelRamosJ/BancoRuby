class Trabajo < ApplicationRecord
	self.primary_key = 'id'
	self.sequence_name = 'auto_increment_trabajos'
end
