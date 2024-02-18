class Group < ApplicationRecord
  belongs_to :user
  has_many :group_areas, dependent: :destroy
  has_many :areas, through: :group_areas
  has_many :group_parts, dependent: :destroy
  has_many :parts, through: :group_parts

  validates :title,    presence: true
  validates :area_ids, presence: true
  validates :part_ids, presence: true

  def self.search(search_area_params, search_part_params)
    if search_area_params.present? && search_part_params.present?
      Group.joins(:group_areas, :group_parts).where(group_areas: { area_id: search_area_params }, group_parts: { part_id: search_part_params }).distinct
    elsif search_area_params.present?
      Group.joins(:group_areas).where(group_areas: { area_id: search_area_params }).distinct
    elsif search_part_params.present?
      Group.joins(:group_parts).where(group_parts: { part_id: search_part_params }).distinct
    else
      Group.all
    end
  end
end
