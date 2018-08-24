require 'faker'

# WIPE EVERYTHING
Survey.destroy_all
Topic.destroy_all
Statement.destroy_all
StatementSet.destroy_all
Choice.destroy_all
Role.destroy_all

# CREATE USERS
@user = User.create(email: 'user@test.com', password: 'secret', password_confirmation: 'secret')

# CREATE SURVEYS
2.times do
  Survey.create(description: Faker::Lorem.sentence(3), name: Faker::Dessert.topping, user: @user)
end

# CREATE ROLES AND STATIONS
Survey.all.each_with_index do |s, i|
  # Create 2 - 4 roles
  (2..4).to_a.sample.times do
    Role.create(name: Faker::Superhero.prefix, survey: s)
  end
  # Create 1 - 3 stations
  (2..4).to_a.sample.times do
    Station.create(survey: s, name: Faker::Hacker.noun.capitalize)
  end
end

# CREATE TOPICS
Station.all.each do |s|
  (1..5).to_a.sample.times do
    s.topics.create(description: Faker::Hacker.say_something_smart, name: Faker::Hacker.adjective.capitalize)
  end
end

# StatementSets
Topic.all.each do |t|
  n = (1..Role.count).to_a.sample
  roles = t.survey.roles.sample(n)
  roles.each do |r|
    StatementSet.create(topic: t, role: r)
  end
end

# CREATE STATEMENTS
STYLES = %w[multiple_choice single_choice].freeze

StatementSet.all.each do |s|
  (1..5).to_a.sample.times do
    s.statements.create(style: STYLES.sample, text: Faker::WorldOfWarcraft.quote[0...-1] + '?')
  end
end

# CREATE CHOICES
Statement.all.each do |s|
  (2..5).to_a.sample.times do
    s.choices.create(text: Faker::WorldOfWarcraft.quote)
  end
end

# CREATE ANSWER
def random_answer
  @visitor_id = SecureRandom.urlsafe_base64(6)
  @visitor_role_id = Role.all.sample.id
  statement_sets = StatementSet.where(role_id: @visitor_role_id)
  (statement_sets.count-rand(1..statement_sets.count-1)).times do |i|
    Statement.where(statement_set_id: statement_sets[i].id).to_a.each do |s|
      choices = Choice.where(statement_id: s.id)
      selected_choices_array = "[#{choices[rand(0..choices.length-1)].id.to_s} , #{choices[rand(0..choices.length-1)].id.to_s} ]"
      Answer.create(statement_id: s.id, uuid: @visitor_id,selected_choices: selected_choices_array)
    end
  end
end
