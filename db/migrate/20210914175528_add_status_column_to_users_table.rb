class AddStatusColumnToUsersTable < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :status, :integer, null: false, default: 1
  end
end
