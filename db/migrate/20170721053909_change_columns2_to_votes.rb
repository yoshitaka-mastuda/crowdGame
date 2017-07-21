class ChangeColumns2ToVotes < ActiveRecord::Migration[5.1]
  def change
    change_column :votes, :version, :integer, default:0
  end
end
