class AddDiaCobrancaToCustomers < ActiveRecord::Migration[6.1]
  def change
    add_column :customers, :dia_cobranca, :string
  end
end
