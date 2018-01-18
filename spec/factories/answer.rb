FactoryBot.define do
  factory :answer do
    statement { create(:statement) }
    selected_choices '[]'
  end
end
