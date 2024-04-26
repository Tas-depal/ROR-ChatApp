class AddColumnsToChannels < ActiveRecord::Migration[7.0]
  def change
    add_column :channels, :creator_id, :integer
    add_column :channels, :member_ids, :integer, array: true, default: []
  end
end
