class AddTitleToGroups < ActiveRecord::Migration[7.0]
  def change
    add_column :groups, :title, :string
    change_column :groups, :title, :string, null: false
  end
end
