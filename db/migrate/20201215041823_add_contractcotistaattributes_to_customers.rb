class AddContractcotistaattributesToCustomers < ActiveRecord::Migration[6.1]
  def change
    add_column :customers, :cotista, :string
    add_column :customers, :cotista_cpf, :string
    add_column :customers, :cotista_c, :boolean
  end
end
