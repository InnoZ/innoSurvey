class RemoveEnabledFromUsers < ActiveRecord::Migration[5.1]
  def change
    remove_column :users, :enabled
  end
end
