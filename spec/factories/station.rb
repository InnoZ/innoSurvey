FactoryBot.define do
  factory :station do
    survey { create(:survey) }
  end
end
