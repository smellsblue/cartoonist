FactoryGirl.define do
  factory :site do
    sequence(:name) { |n| "name#{n}" }
    description "The description of the site."
    enabled true
  end
end
