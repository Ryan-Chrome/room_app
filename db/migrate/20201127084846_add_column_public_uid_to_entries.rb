class AddColumnPublicUidToEntries < ActiveRecord::Migration[6.0]
  def change
    add_column :entries, :public_uid, :string
    add_column :entries, :check, :boolean, default: true, null: false
    add_index :entries, :public_uid, unique: true
  end
end
