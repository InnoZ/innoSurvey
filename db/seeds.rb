require 'faker'

# WIPE EVERYTHING
Survey.destroy_all
Topic.destroy_all
Statement.destroy_all
StatementSet.destroy_all
Choice.destroy_all
Role.destroy_all

# CREATE SURVEYS
2.times do
  Survey.create(description: Faker::Lorem.sentence(3), name: Faker::Dessert.topping)
end

# CREATE ROLES AND STATIONS
Survey.all.each_with_index do |s, i|
  Role.create(name: "Role #{i}", survey: s)
  # Create 1 - 3 stations
  (1..3).to_a.sample.times do
    Station.create(survey: s, name: Faker::Hacker.noun.capitalize)
  end
end

# CREATE STATIONS
Survey.all.each do |s|
  (1..3).to_a.sample.times do
    s.stations.create(survey: s, name: Faker::Hacker.noun.capitalize)
  end
end

# CREATE TOPICS
Station.all.each do |s|
  6.times do
    s.topics.create(description: Faker::Hacker.say_something_smart, name: Faker::Hacker.adjective.capitalize)
  end
end

# StatementSets
Topic.all.each do |t|
  n = (1..Role.count).to_a.sample 
  roles = Role.all.sample(n)
  roles.each do |r|
    StatementSet.create(topic: t, role: r)
  end
end

# CREATE STATEMENTS
STYLES = %w[multiple single].freeze

StatementSet.all.each do |s|
  s.statements.create(style: STYLES.sample, text: Faker::WorldOfWarcraft.quote + '?')
end

# CREATE CHOICES
Statement.all.each do |s|
  (2..5).to_a.sample.times do
    s.choices.create(text: Faker::WorldOfWarcraft.quote)
  end
end

