class AddAgeRangeToActivities < ActiveRecord::Migration[8.0]
  def change
    add_column :activities, :minimum_age, :integer
    add_column :activities, :maximum_age, :integer
  end
end
