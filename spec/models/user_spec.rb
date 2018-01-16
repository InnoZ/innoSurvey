describe User do
  context 'Attributes' do
    it { is_expected.to respond_to(:email) }
    it { is_expected.to respond_to(:enabled) }
    it { is_expected.to respond_to(:password) }
    it { is_expected.to respond_to(:password_confirmation) }
  end

  context 'Validations' do
    let(:user) { build :user }

    it 'password must be longer than 5 chars' do
      user.password = 'asd'
      user.password_confirmation = 'asd'

      expect(user).not_to be_valid
    end

    it 'cannot add user with invalid email' do
      user.email = 'peokjwef@pokpwe'

      expect(user).not_to be_valid
    end

    it 'cannot add user with duplicate email address' do
      create :user, email: 'foo@bar.org'
      user.email = 'foo@bar.org'

      expect(user).not_to be_valid
    end
  end
end

