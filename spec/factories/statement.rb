FactoryBot.define do
  factory :statement do
    style "single_choice"
    text "I am a sample statement"
    topic { create(:topic) }
  end
end
