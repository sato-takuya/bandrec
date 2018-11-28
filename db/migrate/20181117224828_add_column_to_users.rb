class AddColumnToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :part, :text, array: true
  end
end
