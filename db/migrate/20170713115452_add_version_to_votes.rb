class AddVersionToVotes < ActiveRecord::Migration[5.1]
  def change
    add_column :votes, :version, :integer
  end
end
