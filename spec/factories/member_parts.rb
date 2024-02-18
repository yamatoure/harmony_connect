FactoryBot.define do
  factory :member_part do
    association :member
    association :part
  end
end