FactoryBot.define do
  factory :role do
    name "SampleRole"
    survey { create(:survey) }
  end
end
