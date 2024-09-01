FactoryBot.define do
  factory :address do
    street { "MyString" }
    city { "MyString" }
    state { "MyString" }
    postal_code { "MyString" }
    country { "MyString" }
    latitude { "MyString" }
    longitude { "MyString" }
    contact { nil }
  end
end
