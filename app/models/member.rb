class Member < ApplicationRecord
  belongs_to :user
  has_many :member_areas, dependent: :destroy
  has_many :areas, through: :member_areas
  has_many :member_parts, dependent: :destroy
  has_many :parts, through: :member_parts

  validates :user_id,  uniqueness: true
  validates :title,    presence: true
  validates :area_ids, presence: true
  validates :part_ids, presence: true

  def self.search(search_area_params, search_part_params)
    if search_area_params.present? && search_part_params.present?
      Member.joins(:member_areas, :member_parts).where(member_areas: { area_id: search_area_params }, member_parts: { part_id: search_part_params }).distinct
    elsif search_area_params.present?
      Member.joins(:member_areas).where(member_areas: { area_id: search_area_params }).distinct
    elsif search_part_params.present?
      Member.joins(:member_parts).where(member_parts: { part_id: search_part_params }).distinct
    else
      Member.all
    end
  end
end
