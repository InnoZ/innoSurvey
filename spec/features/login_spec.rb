feature 'Login / Logout', :js do
  scenario '' do
    create :user, email: 'user@test.com', password: 'secret', password_confirmation: 'secret'
    survey = create :survey

    visit login_path
    fill_in 'sessions_email', with: 'user@test.com'
    fill_in 'sessions_password', with: 'secret'
    click_on 'Log in'

    expect(page).to have_content("Survey: #{survey.name}")
  end
end
