class CreateActivities < ActiveRecord::Migration[8.0]
  def change
    create_table :activities do |t|
      t.string :title, null: false
      t.text :description
      t.string :location
      t.timestamp :start_time, null: false
      t.integer :max_participants, null: false, default: 4

      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
