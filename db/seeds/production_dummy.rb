# WIPE EVERYTHING
Survey.destroy_all
Topic.destroy_all
Statement.destroy_all
StatementSet.destroy_all
Choice.destroy_all
Role.destroy_all

# CREATE USERS
@user = User.create(email: 'user@test.com', password: 'secret', password_confirmation: 'secret')

# CREATE SURVEY
survey = Survey.create(description: 'This is a first test survey', name: 'MFund', user: @user)

# CREATE ROLES
role_1 = survey.roles.create(name: 'Politik & Verwaltung')
role_2 = survey.roles.create(name: 'Stadt- & Verkehrsplanung')
role_3 = survey.roles.create(name: 'Infrastrukturbetreiber')
role_4 = survey.roles.create(name: 'Mobilitäts- & Verkehrsmanagement')
role_5 = survey.roles.create(name: 'Mobilitätsdienstanbieter')
role_6 = survey.roles.create(name: 'Nutzer bzw. Verkehrsteilnehmer')

# CREATE STATIONS
ai = survey.stations.create(name: 'Aritifical Intelligence')
multimodel_priv = survey.stations.create(name: 'Multimodel Privacy')

# TOPICS
ai_topic_1 = ai.topics.create(name: ai.name, description: 'This is all about AI!')
multimodel_priv_topic_1 = multimodel_priv.topics.create(name: multimodel_priv.name, description: 'This is all about Multimodel Privacy!')

# STATEMENTSETS + STATEMENTS + CHOICES
# AI
Role.all.each do |role|
  set = ai_topic_1.statement_sets.create(role: role)
  statement_1 = set.statements.create(style: 'multiple_choice', text: 'Wenn Sie erfahren, dass das Flottenmanagement mit künstlicher Intelligenz arbeitet…')
  statement_1.choices.create(text: 'Wissen Sie nicht wirklich, was damit gemeint ist, sind aber zuversichtlich, dass es zuverlässig richtige Entscheidungen trifft.')
  statement_1.choices.create(text: 'Hätten Sie gerne detaillierte Informationen darüber, welche Daten genutzt werden und wie damit Entscheidungen getroffen werden.')
  statement_1.choices.create(text: 'Wissen Sie, wie ein solches Management aussähe und sind der Ansicht, dass es hilfreich ist.')
  statement_1.choices.create(text: 'Wissen Sie, wie ein solches Management aussähe, vertrauen aber nicht in dessen Zuverlässigkeit.')
end

# Multimodel privacy
Role.all.each do |role|
  set = multimodel_priv_topic_1.statement_sets.create(role: role)
  statement_1 = set.statements.create(style: 'multiple_choice', text: 'Sehen die einzelnen Adressatengruppen an unterschiedlichen Stellen Probleme?')
  statement_1.choices.create(text: 'Abrechnung der einzelnen Services')
  statement_1.choices.create(text: 'Datenschutz')
  statement_1.choices.create(text: 'Sicherheit')
  statement_1.choices.create(text: 'Finden gemeinsamer Schnittstellen')

  if role.name == 'Nutzer bzw. Verkehrsteilnehmer'
    statement_2 = set.statements.create(style: 'multiple_choice', text: 'Welche Daten würden Sie für die Nutzung solcher Services bereitstellen? (Rolle Nutzer_in)')
    statement_2.choices.create(text: 'Standort (Navigation sonst nicht möglich)')
    statement_2.choices.create(text: 'Zugriff auf Kalender (Erinnerungen, Empfehlungen o.Ä. sonst nicht möglich)')
  end
end
