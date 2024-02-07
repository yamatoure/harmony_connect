class Area < ApplicationRecord
  has_many :group_areas
  has_many :groups, through: :group_areas
end
