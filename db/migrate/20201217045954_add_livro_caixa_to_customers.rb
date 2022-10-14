class AddLivroCaixaToCustomers < ActiveRecord::Migration[6.1]
  def change
    add_column :customers, :area_livro_caixa, :boolean
  end
end
