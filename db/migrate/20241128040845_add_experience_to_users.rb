class AddExperienceToUsers < ActiveRecord::Migration[8.0]
  def change
    add_column :users, :experience, :integer, default: 0
  end
end
