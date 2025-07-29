class AddStatusToActivities < ActiveRecord::Migration[8.0]
  def change
    add_column :activities, :status, :integer, default: 0, null: false

    reversible do |dir|
      dir.up do
        Activity.reset_column_information

        Activity.find_each do |activity|
          if activity.max_participants.present? && activity.participant_records.count >= activity.max_participants
            activity.update_column(:status, 1)
          end
        end
      end
    end
  end
end
