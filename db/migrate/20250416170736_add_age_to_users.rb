class AddAgeToUsers < ActiveRecord::Migration[8.0]
  def up
    add_column :users, :age, :integer

    User.update_all(age: 18)

    change_column_null :users, :age, false
  end

  def down
    remove_column :users, :age
  end
end
