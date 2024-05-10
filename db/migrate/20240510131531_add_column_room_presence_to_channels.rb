class AddColumnRoomPresenceToChannels < ActiveRecord::Migration[7.0]
  def change
    add_column :channels, :room_presence, :jsonb, default: {}
  end
end
