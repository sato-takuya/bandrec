class AddElementToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users,:name,:string
    add_column :users,:birthday,:date
    add_column :users,:area,:string
    add_column :users,:gender,:integer
    add_column :users,:job,:integer
    add_column :users,:future,:integer
    add_column :users,:band_type,:integer
    add_column :users,:song_type,:integer
    add_column :users,:user_type,:integer
    add_column :users,:info,:text
  end
end
