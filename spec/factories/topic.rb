FactoryBot.define do
  factory :topic do
    description "I am a sample topic"
    station { create(:station) }
    role { create(:role) }
  end
end
