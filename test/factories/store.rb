FactoryGirl.define do

  factory :product, :class => Product do
    title { generate(:name) }
    price { 10.00 }
  end

end