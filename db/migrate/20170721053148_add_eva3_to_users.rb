class AddEva3ToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :evaluation_count3, :integer, defailt:0
  end
end