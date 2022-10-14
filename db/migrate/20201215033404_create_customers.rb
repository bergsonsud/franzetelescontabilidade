class CreateCustomers < ActiveRecord::Migration[6.1]
  def change
    create_table :customers do |t|
      t.string :razao
      t.string :iss
      t.string :cnpj
      t.string :cei
      t.string :cgf
      t.string :cod
      t.string :logradouro
      t.string :numero
      t.string :bairro
      t.string :complemento
      t.string :municipio
      t.string :estado
      t.string :telefone
      t.string :telefone2
      t.string :telefone3
      t.string :celular
      t.string :celular2
      t.string :email
      t.string :email2
      t.string :contato
      t.string :contato2
      t.string :endereco_coleta
      t.float :honorarios
      t.datetime :desde

      t.timestamps
    end
  end
end
