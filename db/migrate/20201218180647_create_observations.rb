class CreateObservations < ActiveRecord::Migration[6.1]
  def change
    create_table :observations do |t|
      t.string :descricao
      t.text :content

      t.timestamps
    end
  end
end
