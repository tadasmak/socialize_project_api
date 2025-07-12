class AddStatusToActivities < ActiveRecord::Migration[8.0]
  def change
    add_column :activities, :status, :string, default: "open", null: false
  end
end
