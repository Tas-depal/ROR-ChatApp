class CreateChannels < ActiveRecord::Migration[7.0]
  def change
    create_table :channels do |t|
      t.string :channel_name
      t.boolean :is_private, default: :false

      t.timestamps
    end
  end
end
