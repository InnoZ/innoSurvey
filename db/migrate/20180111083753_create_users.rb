class CreateUsers < ActiveRecord::Migration[5.1]
  def change
    create_table :users do |t|
      t.string :email, null: false
      t.boolean :enabled, null: false, default: false
      t.string :password_digest, nul: false

      t.timestamps
    end
  end
end
