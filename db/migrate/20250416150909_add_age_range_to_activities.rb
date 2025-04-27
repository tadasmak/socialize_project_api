class AddAgeRangeToActivities < ActiveRecord::Migration[8.0]
  def up
    add_column :activities, :minimum_age, :integer, null: true
    add_column :activities, :maximum_age, :integer, null: true

    reversible do |dir|
      dir.up do
        Activity.where(minimum_age: nil).update_all(minimum_age: 18)
        Activity.where(maximum_age: nil).update_all(maximum_age: 100)

        change_column_null :activities, :minimum_age, false
        change_column_null :activities, :maximum_age, false
      end
    end
  end
end
