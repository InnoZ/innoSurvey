FactoryBot.define do
  factory :answer do
    result 'This is a sample answer'
    statement { create(:statement) }
  end
end
