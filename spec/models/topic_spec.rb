RSpec.describe Topic, type: :model do
  context "Attributes" do
    it "should respond to description" do
      expect(Topic.new).to(respond_to(:description))
      expect(Topic.new).to(respond_to(:name))
    end
  end

  context "Associations" do
    it { is_expected.to(belong_to(:station)) }
    it { is_expected.to(have_many(:statement_sets)) }

    context 'DELETIONS' do
      before(:each) do
        # FactoryBot land...
        @survey = create :survey
        @station = create :station, survey: @survey
        @topic = create :topic, station: @station
        @statement_set = create :statement_set, topic: @topic
        @statement = create :statement, statement_set: @statement_set
        @choice = create :choice, statement: @statement
      end

      it 'destroys associated statement set on destroy' do
        expect { @topic.destroy }.to change(StatementSet, :count).by(-1)
      end
    end
  end
end
