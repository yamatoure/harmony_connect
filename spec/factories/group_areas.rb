FactoryBot.define do
  factory :group_area do
    association :group
    association :area
  end
end