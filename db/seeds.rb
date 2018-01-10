require 'faker'

# WIPE EVERYTHING
Survey.destroy_all
Topic.destroy_all
Statement.destroy_all
Choice.destroy_all
Role.destroy_all

# CREATE SURVEYS
2.times do
  Survey.create(description: Faker::Lorem.sentence(3))
end

# CREATE ROLES
Role.create(name: 'Role 1')
Role.create(name: 'Role 2')
Role.create(name: 'Role 3')

# CREATE TOPICS
Survey.all.each do |s|
  6.times do
    s.topics.create(description: Faker::Lorem.sentence(3), role: Role.all.sample)
  end
end

# CREATE STATEMENTS
STYLES = %w[multiple single].freeze

Topic.all.each do |t|
  t.statements.create(style: STYLES.sample, text: Faker::WorldOfWarcraft.quote + '?')
end

# CREATE CHOICES
Statement.all.each do |s|
  (2..5).to_a.sample.times do
    s.choices.create(text: Faker::WorldOfWarcraft.quote)
  end
end

