class CreateActivities < ActiveRecord::Migration[8.0]
  def change
    create_table :activities do |t|
      t.string :title
      t.text :description
      t.string :location
      t.timestamp :start_time
      t.integer :max_participants

      t.timestamps
    end
  end
end
