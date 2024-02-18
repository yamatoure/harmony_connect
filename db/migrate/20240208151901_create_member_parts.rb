class CreateMemberParts < ActiveRecord::Migration[7.0]
  def change
    create_table :member_parts do |t|
      t.references :member, null: false, foreign_key: true
      t.references :part, null: false, foreign_key: true
      t.timestamps
    end
  end
end
