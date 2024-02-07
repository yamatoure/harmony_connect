class Part < ApplicationRecord
  has_many :group_parts
  has_many :groups, through: :group_parts
end
