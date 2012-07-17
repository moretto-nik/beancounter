FactoryGirl.define do
  factory :user do
    id {"foo#{rand(10000).to_s}"}
    name "foo"
  end

  factory :application do
    api_key "6fce3865-8f51-404b-9905-c6a8600f7b66"
  end
end