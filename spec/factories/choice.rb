FactoryBot.define do
  factory :choice do
    text 'This is a sample choice'
    statement { create(:statement) }
  end
end
