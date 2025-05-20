class ChangeAgeToBirthDateInUsers < ActiveRecord::Migration[8.0]
  def change
    add_column :users, :birth_date, :date
    remove_column :users, :age, :integer
  end
end
