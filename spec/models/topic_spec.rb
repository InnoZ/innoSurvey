RSpec.describe Topic, type: :model do
  context "Attributes" do
    it "should respond to description" do
      expect(Topic.new).to(respond_to(:description))
    end
  end

  context "Associations" do
    it { is_expected.to(belong_to(:survey)) }
    it { is_expected.to(belong_to(:role)) }
    it { is_expected.to(have_many(:statements)) }

    context 'DELETIONS' do
      before(:each) do
        # FactoryBot land...
        @survey = create :survey
        @topic = create :topic, survey: @survey
        @statement = create :statement, topic: @topic
        @choice = create :choice, statement: @statement
      end

      it 'destroys associated statements on destroy' do
        expect { @topic.destroy }.to change(Statement, :count).by(-1)
      end
    end
  end
end
