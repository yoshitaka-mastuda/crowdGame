class ChangeColumnsToVotes < ActiveRecord::Migration[5.1]
  def change
    change_column :votes, :version, :integer, defailt:0
  end
end
