FactoryBot.define do
  factory :survey do
    description "I am a sample survey"
    name { SecureRandom.urlsafe_base64(10) }
    user { create(:user) }
  end
end
