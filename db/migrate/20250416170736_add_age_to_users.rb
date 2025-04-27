class AddAgeToUsers < ActiveRecord::Migration[8.0]
  def change
    add_column :users, :age, :integer, null: true

    reversible do |dir|
      dir.up do
        User.where(age: nil).update_all(age: 18)
        change_column_null :users, :age, false
      end
    end
  end
end
