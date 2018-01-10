FactoryBot.define do
  factory :statement do
    style "Choice"
    text "I am a sample statement"
    topic { create(:topic) }
  end
end
