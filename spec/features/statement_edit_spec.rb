feature 'Statement', :js do
  before do
    create :user, email: 'user@test.com', password: 'secret', password_confirmation: 'secret'
    @survey = create :survey
    @station = create(:station, survey: @survey, name: 'Station to edit')
    @topic = create(:topic, station: @station, name: 'First topic')
    @role = create(:role, survey: @survey, name: 'Tester')
    @statement_set = create(:statement_set, role: @role, topic: @topic)
  end

  scenario 'edit view is not visible for guests' do
    visit surveys_path
    expect(page).to_not have_css('btn', text: 'Show content')
    visit station_content_path(@station)
    expect(current_path).to eq root_path
  end

  scenario 'can be created by users' do
    login
    visit surveys_path
    try_to_create_empty_statement
    create_statement_with_choices
    delete_one_choice
    delete_statement
  end

  private

  def try_to_create_empty_statement
    click_on('Show content')
    click_on('Show content')
    find('.btn', text: 'New statement').trigger('click')
    click_on('Save')
    expect(page).to have_content('error')
  end

  def create_statement_with_choices
    fill_in 'statement_text', with: 'What is your job?'
    fill_in 'statement_choices_attributes_0_text', with: 'Hacker'
    fill_in 'statement_choices_attributes_1_text', with: 'Programmer'
    click_on('Save')
    expect(page).to have_content('Hacker (0)')
    expect(page).to have_content('Programmer (0)')
  end

  def delete_one_choice
    click_on('Edit')
    check('statement_choices_attributes_0__destroy')
    click_on('Save')
    expect(page).to_not have_content('Hacker (0)')
    expect(page).to have_content('Programmer (0)')
  end

  def delete_statement
    click_on('Edit')
    find('a', text: 'Delete statement').trigger('click')
    expect(page).to have_content('Topic:')
    expect(page).to_not have_content('What is your job?')
  end

  def login
    visit login_path
    fill_in 'sessions_email', with: 'user@test.com'
    fill_in 'sessions_password', with: 'secret'
    click_on 'Log in'
  end
end
