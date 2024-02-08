class Member < ApplicationRecord
  belongs_to :user
  has_many :member_areas
  has_many :areas, through: :member_areas
  has_many :member_parts
  has_many :parts, through: :member_parts

  validates :title,    presence: true
  validates :area_ids, presence: true
  validates :part_ids, presence: true
end
