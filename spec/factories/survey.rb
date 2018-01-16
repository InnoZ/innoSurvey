FactoryBot.define do
  factory :survey do
    description "I am a sample survey"
    name 'Sample survey'
    user { create(:user) }
  end
end
