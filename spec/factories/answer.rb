FactoryBot.define do
  factory :answer do
    statement { create(:statement) }
    result ''
  end
end
