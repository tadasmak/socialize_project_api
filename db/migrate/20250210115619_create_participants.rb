class CreateParticipants < ActiveRecord::Migration[8.0]
  def change
    create_table :participants do |t|
      t.references :user, null: false, foreign_key: { to_table: :users }
      t.references :activity, null: false, foreign_key: { to_table: :activities }

      t.timestamps
    end

    add_index :participants, [:activity_id, :user_id], unique: true
  end
end
