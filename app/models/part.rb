class Part < ApplicationRecord
  has_many :group_parts
  has_many :groups, through: :group_parts
  has_many :member_parts
  has_many :members, through: :member_parts
end
