class Group < ApplicationRecord
  has_many :group_areas
  has_many :areas, through: :group_areas
  has_many :group_parts
  has_many :parts, through: :group_parts
end
