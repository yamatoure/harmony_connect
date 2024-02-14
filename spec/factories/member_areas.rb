FactoryBot.define do
  factory :member_area do
    association :member
    association :area
  end
end