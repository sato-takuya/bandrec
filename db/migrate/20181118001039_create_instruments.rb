class CreateInstruments < ActiveRecord::Migration[5.2]
  def change
    create_table :instruments do |t|
      t.integer :part
      t.integer :user_id
      t.timestamps
    end
  end
end
