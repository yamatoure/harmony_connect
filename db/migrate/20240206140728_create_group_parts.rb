class CreateGroupParts < ActiveRecord::Migration[7.0]
  def change
    create_table :group_parts do |t|
      t.references :group, null: false, foreign_key: true
      t.references :part, null: false, foreign_key: true
      t.timestamps
    end
  end
end
