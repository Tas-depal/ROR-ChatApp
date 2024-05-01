class AddColumnToChannels < ActiveRecord::Migration[7.0]
  def change
    add_column :channels, :last_read, :jsonb, default: {}
  end
end
