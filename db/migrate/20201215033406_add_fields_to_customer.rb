class AddFieldsToCustomer < ActiveRecord::Migration[6.1]
  def change
    add_column :customers, :id_emp, :string
    add_column :customers, :cep, :string
    add_column :customers, :cpf, :string
    add_column :customers, :srf, :string
    add_column :customers, :sefaz, :string
    add_column :customers, :senha_iss, :string
    add_column :customers, :orgao, :string
    add_column :customers, :e_cpf, :string
    add_column :customers, :e_cnpj, :string
    add_column :customers, :decimo3, :boolean
    add_column :customers, :star, :integer
  end
end
