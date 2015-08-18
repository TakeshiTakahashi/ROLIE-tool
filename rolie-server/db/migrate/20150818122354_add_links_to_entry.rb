class AddLinksToEntry < ActiveRecord::Migration
  def change
    add_column :entries, :links, :string
  end
end
