FactoryBot.define do
  factory :topic do
    description 'I am a sample topic'
    name 'Sample topic'
    station { create(:station) }
  end
end
