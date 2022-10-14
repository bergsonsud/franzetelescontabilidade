class AddContracttitularattributesToCustomers < ActiveRecord::Migration[6.1]
  def change
    add_column :customers, :titular, :string
    add_column :customers, :titular_cpf, :string
    add_column :customers, :titular_c, :boolean
  end
end
