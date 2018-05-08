survey = Survey.create(description: 'A survey for emily, the automated shuttle', name: 'emily', user: User.first)

# CREATE ROLES
role = survey.roles.create(id: 6, name: 'emily-Nutzer')

# CREATE STATIONS
station_1 = survey.stations.create(name: 'Im Shuttle')

# TOPICS
topic_1 = station_1.topics.create(name: 'Im Shuttle', description: 'Im Shuttle')

# STATEMENTSETS + STATEMENTS + CHOICES
# AI
set = topic_1.statement_sets.create(role: role)

statement_1 = set.statements.create(style: 'single_choice', text: 'Wie finden sie Emily?')
statement_1.choices.create(text: 'Sehr schlecht')
statement_1.choices.create(text: 'Eher schlecht')
statement_1.choices.create(text: 'Eher gut')
statement_1.choices.create(text: 'Sehr gut')
