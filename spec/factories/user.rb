FactoryBot.define do
  factory :user do
    email { Faker::Name.name.split(' ').join('_').downcase + "@example.com" }
    password_digest BCrypt::Password.create('secret', cost: 4)
  end
end
