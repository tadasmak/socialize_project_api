class AddAgeRangeToActivities < ActiveRecord::Migration[8.0]
  def up
    add_column :activities, :minimum_age, :integer
    add_column :activities, :maximum_age, :integer

    Activity.update_all(minimum_age: 18, maximum_age: 100)

    change_column_null :activities, :minimum_age, false
    change_column_null :activities, :maximum_age, false
  end

  def down
    remove_column :activities, :minimum_age
    remove_column :activities, :maximum_age
  end
end
