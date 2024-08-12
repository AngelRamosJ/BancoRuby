class CreatePruebas < ActiveRecord::Migration[7.0]
  def change
    create_table :pruebas do |t|
      t.string :nombre
      t.string :descripcion

      t.timestamps
    end
  end
end
