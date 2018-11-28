class RemovePartFromUsers < ActiveRecord::Migration[5.2]
  def change
    remove_column :users,:part,:integer
  end
end
