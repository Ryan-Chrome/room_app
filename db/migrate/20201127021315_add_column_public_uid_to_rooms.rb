class AddColumnPublicUidToRooms < ActiveRecord::Migration[6.0]
  def change
    add_column :rooms, :public_uid, :string
    add_index :rooms, :public_uid, unique: true
  end
end
