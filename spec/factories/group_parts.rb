FactoryBot.define do
  factory :group_part do
    association :group
    association :part
  end
end