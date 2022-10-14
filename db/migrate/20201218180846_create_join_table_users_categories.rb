class CreateJoinTableUsersCategories < ActiveRecord::Migration[6.1]
  def change
    create_join_table :customers, :observations do |t|
      # t.index [:customer_id, :observation_id]
      # t.index [:observation_id, :customer_id]
    end
  end
end
