class CreateMemberAreas < ActiveRecord::Migration[7.0]
  def change
    create_table :member_areas do |t|
      t.references :member, null: false, foreign_key: true
      t.references :area, null: false, foreign_key: true
      t.timestamps
    end
  end
end
