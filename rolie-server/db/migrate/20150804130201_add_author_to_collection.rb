class AddAuthorToCollection < ActiveRecord::Migration
  def change
    add_column :collections, :author, :string
  end
end
