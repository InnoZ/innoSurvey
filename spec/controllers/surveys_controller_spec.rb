RSpec.describe SurveysController, type: :controller do
  context 'GET #roles' do
    let(:survey) { create :survey }

    it 'can query all available roles of given survey' do
      # Create 2 roles and save attributes as JSON
      foo = {}
      roles = 1.upto(2).each do |i|
        role = create(:role, name: "role_#{i}", survey: survey)
        foo["#{role.id}"] = role.name
      end

      get :roles, params: { id: survey.id }

      roles = JSON.parse response.body
      roles.each do |role_id, role_name|
        expect(roles[role_id]).to eq foo[role_id]
      end
    end
  end
end
