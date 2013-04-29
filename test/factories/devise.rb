FactoryGirl.define do
  sequence(:email) { |n| "admin#{n}@example.com" }
  sequence(:name) { |n| "SomeName#{n}" }

  factory :admin, :class => Admin do
    email { generate(:email) }
    password 'admin'
    password_confirmation 'admin'
  end

  factory :user, :class => User do
    email { generate(:email) }
    first_name { generate(:name) }
    last_name { generate(:name) }
    password 'user'
    password_confirmation 'user'
  end
end
