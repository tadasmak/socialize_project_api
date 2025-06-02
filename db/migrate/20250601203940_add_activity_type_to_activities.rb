class AddTypeToActivities < ActiveRecord::Migration[8.0]
  def change
    add_column :activities, :activity_type, :integer, null: false, default: 0
  end
end
