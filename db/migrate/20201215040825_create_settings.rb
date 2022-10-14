class CreateSettings < ActiveRecord::Migration[6.1]
  def change
    create_table :settings do |t|
      t.string :parametro
      t.string :descricao
      t.string :valor

      t.timestamps
    end
  end
end
