class UnreferenceRoleFromTopic < ActiveRecord::Migration[5.1]
  def change
    remove_reference :topics, :role
  end
end
