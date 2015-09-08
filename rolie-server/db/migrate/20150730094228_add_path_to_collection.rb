class AddPathToCollection < ActiveRecord::Migration
  def change
    add_column :collections, :path, :string
  end
end
