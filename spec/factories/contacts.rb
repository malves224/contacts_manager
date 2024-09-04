FactoryBot.define do
  factory :contact do
    doc { "17404081017" }
    phone { "11914474020" }
    association :user
  end
end
