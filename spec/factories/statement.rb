FactoryBot.define do
  factory :statement do
    style "single_choice"
    text "I am a sample statement"
    statement_set { create(:statement_set) }
  end
end
