class AddAgeRangeToActivities < ActiveRecord::Migration[8.0]
  def up
    add_column :activities, :minimum_age, :integer, null: true
    add_column :activities, :maximum_age, :integer, null: true

    execute "UPDATE activities SET minimum_age = 18 WHERE minimum_age IS NULL"
    execute "UPDATE activities SET maximum_age = 100 WHERE maximum_age IS NULL"

    change_column_null :activities, :minimum_age, false
    change_column_null :activities, :maximum_age, false
  end

  def down
    remove_column :activities, :minimum_age
    remove_column :activities, :maximum_age
  end
end
