class AddContractattributesToCustomers < ActiveRecord::Migration[6.1]
  def change
    add_column :customers, :gerente, :string
    add_column :customers, :gerente_cpf, :string
    add_column :customers, :gerente_c, :boolean
  end
end
