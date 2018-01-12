FactoryBot.define do
  factory :station do
    name 'Sample station'
    survey { create(:survey) }
  end
end
