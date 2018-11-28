class AddSoundSourceToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :sound_source, :text
  end
end
