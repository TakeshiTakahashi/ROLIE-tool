class CreateWorkspaces < ActiveRecord::Migration
  def change
    create_table :workspaces do |t|
      t.string :title

      t.timestamps null: false
    end
    add_index :workspaces, :title, unique: true
  end
end
