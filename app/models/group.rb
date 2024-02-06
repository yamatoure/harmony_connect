class Group < ApplicationRecord
  has_many :group_areas
  has_many :areas, through: :group_areas
  has_many :group_parts
  has_many :parts, through: :group_parts

  validates :title,    presence: true
  validates :area_ids, presence: true
  validates :part_ids, presence: true
end
