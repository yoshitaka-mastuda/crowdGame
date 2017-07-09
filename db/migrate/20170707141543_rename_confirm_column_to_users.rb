class RenameConfirmColumnToUsers < ActiveRecord::Migration[5.1]
  def change
    rename_column :users, :confirm_count, :accept_count
  end
end
