RSpec.describe Station, type: :model do
  context 'Attributes' do
    it { is_expected.to respond_to(:name) }
  end

  context 'Associations' do
    it { is_expected.to have_many(:topics) }
    it { is_expected.to belong_to(:survey) }
     
    it "should delete associated records when deleting a station" do
      station = create :station
      create :topic, station: station

      expect { station.destroy }.to change( Topic, :count).by(-1)
    end
  end
end
