FactoryBot.define do
  factory :contact do
    doc { "12345678901" }
    phone { "11914474020" }
    association :user
  end
end
