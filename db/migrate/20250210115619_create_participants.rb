class CreateParticipants < ActiveRecord::Migration[8.0]
  def change
    create_table :participants do |t|
      t.timestamp :joined_at

      t.timestamps
    end
  end
end
