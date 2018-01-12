RSpec.describe Statement, type: :model do
  context "Attributes" do
    it "should respond to text" do 
      expect(Statement.new).to(respond_to(:text))
    end

    it "should respond to style" do 
      expect(Statement.new).to(respond_to(:style))
    end
  end

  context "Associations" do
    it { is_expected.to(belong_to(:statement_set)) }

    it 'destroys associated choice and answer on destroy' do
      test_statement = create :statement
      create :answer, statement: test_statement
      create :choice, statement: test_statement
      expect { test_statement.destroy }.to change( Answer, :count).by(-1).and change( Choice, :count).by(-1)
    end
  end
end
