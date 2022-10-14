class AddContracttitular2attributesToCustomers < ActiveRecord::Migration[6.1]
  def change
    add_column :customers, :titular2, :string
    add_column :customers, :titular2_cpf, :string
    add_column :customers, :titular2_c, :boolean
  end
end
