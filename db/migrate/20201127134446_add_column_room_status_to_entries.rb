class AddColumnRoomStatusToEntries < ActiveRecord::Migration[6.0]
  def change
    add_column :entries, :room_status, :boolean, default: false, null: false
  end
end
