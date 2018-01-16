FactoryBot.define do
  factory :statement_set do
    role { create(:role) }
    topic { create(:topic) }
  end
end
