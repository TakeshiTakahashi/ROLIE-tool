class AddPathToWorkspace < ActiveRecord::Migration
  def change
    add_column :workspaces, :path, :string
  end
end
