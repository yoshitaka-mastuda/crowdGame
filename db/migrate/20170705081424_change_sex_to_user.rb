class ChangeSexToUser < ActiveRecord::Migration[5.1]
  def change
    change_column :users, :sex, :string
  end
end
