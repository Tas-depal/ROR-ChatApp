class CreateBroadcasts < ActiveRecord::Migration[7.0]
  def change
    create_table :broadcasts do |t|
      t.integer :broadcast_type
      t.references :user, null: false, foreign_key: true
      t.text :broadcast_msg
      t.references :channel, null: false, foreign_key: true

      t.timestamps
    end
  end
end
