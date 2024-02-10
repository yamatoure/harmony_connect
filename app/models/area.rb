class Area < ApplicationRecord
  has_many :group_areas
  has_many :groups, through: :group_areas
  has_many :member_areas
  has_many :members, through: :member_areas
end
