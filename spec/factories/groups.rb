FactoryBot.define do
  factory :group do
    title {Faker::Lorem.sentence}
    content {Faker::Lorem.sentence}
    #checked {false}
    association :user

    transient do
      num_areas { rand(1..48) }
      num_parts { rand(1..6) }
    end

    after(:build) do |group, evaluator|
      group.areas << Area.all.sample(evaluator.num_areas)
      group.parts << Part.all.sample(evaluator.num_parts)
    end
  end
end