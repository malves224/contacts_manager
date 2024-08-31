FactoryBot.define do
  factory :user do
    name { 'John' }
    email { 'john@example.com' }
    password { 'securepassword' }
  end
end