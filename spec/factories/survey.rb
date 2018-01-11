FactoryBot.define do
  factory :survey do
    description "I am a sample survey"
    user { create(:user) }
  end
end
