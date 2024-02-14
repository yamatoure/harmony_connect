FactoryBot.define do
  factory :member do
    title {Faker::Lorem.sentence}
    content {Faker::Lorem.sentence}
    #checked {false}
    association :user

    transient do
      num_areas { rand(1..48) }
      num_parts { rand(1..6) }
    end

    after(:build) do |member, evaluator|
      member.areas << Area.all.sample(evaluator.num_areas)
      member.parts << Part.all.sample(evaluator.num_parts)
    end
  end
end