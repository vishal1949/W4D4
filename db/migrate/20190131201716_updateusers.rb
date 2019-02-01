class Updateusers < ActiveRecord::Migration[5.2]
  def change
    rename_column :users, :passwor_digest, :password_digest
  end
end
