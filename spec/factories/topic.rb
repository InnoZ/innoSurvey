FactoryBot.define do
  factory :topic do
    description "I am a sample topic"
    survey { create(:survey) }
    role { create(:role) }
  end
end
