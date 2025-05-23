class AddIsConfirmedToActivities < ActiveRecord::Migration[8.0]
  def change
    add_column :activities, :is_confirmed, :boolean, default: false, null: false
  end
end
