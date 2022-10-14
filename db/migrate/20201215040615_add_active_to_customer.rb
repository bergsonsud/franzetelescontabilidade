class AddActiveToCustomer < ActiveRecord::Migration[6.1]
  def change
    add_column :customers, :active, :boolean, default: true
  end
end
