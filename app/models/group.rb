class Group < ApplicationRecord
  has_many :group_areas
  has_many :areas, through: :group_areas
end
