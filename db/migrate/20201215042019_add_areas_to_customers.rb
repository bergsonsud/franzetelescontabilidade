class AddAreasToCustomers < ActiveRecord::Migration[6.1]
  def change
    add_column :customers, :area_fiscal, :boolean
    add_column :customers, :area_imp_renda_pj, :boolean
    add_column :customers, :area_trabalhista_previdenciaria, :boolean
    add_column :customers, :area_contabil, :boolean
  end
end
