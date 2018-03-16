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
role_1 = survey.roles.create(id: 1, name: 'Nutzer')
role_2 = survey.roles.create(id: 2, name: 'Politik & Planung')
role_3 = survey.roles.create(id: 3, name: 'Fahrzeughersteller & Flottenbetreiber')
role_4 = survey.roles.create(id: 4, name: 'Mobilitätsdienstanbieter')
role_5 = survey.roles.create(id: 5, name: 'Energie & Verkehrsmanagement')

# CREATE STATIONS
ai = survey.stations.create(name: 'Artifical Intelligence')
multimodal_priv = survey.stations.create(name: 'Multimodal Privacy')
ddp = survey.stations.create(name: 'Data Driven Planning')
hsa = survey.stations.create(name: 'HSA-Exponat')

# TOPICS
ai_topic_1 = ai.topics.create(name: ai.name, description: 'Fragen zum AI Supported Flow Management')
multimodal_priv_topic_1 = multimodal_priv.topics.create(name: multimodal_priv.name, description: 'Fragen zu Multimodal Privacy')
ddp_topic_1 = ddp.topics.create(name: ddp.name, description: 'Fragen zum Data Driven Planning')
hsa_topic_1 = hsa.topics.create(name: hsa.name, description: 'Szenarien für Nutzerinnen und Nutzer')
hsa_topic_2 = hsa.topics.create(name: hsa.name, description: 'Szenarien für Politik und Planung')
hsa_topic_3 = hsa.topics.create(name: hsa.name, description: 'Szenarien für Fahrzeughersteller und Flottenbetreiberinnen')
hsa_topic_4 = hsa.topics.create(name: hsa.name, description: 'Szenarien für Mobilitätsdienstanbieterinnen und -anbieter')
hsa_topic_5 = hsa.topics.create(name: hsa.name, description: 'Szenarien für Flow Management in den Bereichen Eenrgie und Verkehr')

# STATEMENTSETS + STATEMENTS + CHOICES
# AI
Role.all.each do |role|
  set = ai_topic_1.statement_sets.create(role: role)

  statement_1 = set.statements.create(style: 'multiple_choice', text: 'Wie bewerten Sie einen solchen Service (kein Fahrplan; angekündigte Wartezeit; Möglichkeit, zwischen warten und sofort fahren (mit Aufpreis) zu wählen)?')
  statement_1.choices.create(text: 'Sehr schlecht')
  statement_1.choices.create(text: 'Eher schlecht')
  statement_1.choices.create(text: 'Eher gut')
  statement_1.choices.create(text: 'Sehr gut')

  statement_2 = set.statements.create(style: 'multiple_choice', text: 'Wie hoch ist Ihr Vertrauen in die Zuverlässigkeit von Anwendungen, die mit künstlicher Intelligenz arbeiten?')
  statement_2.choices.create(text: 'Sehr gering')
  statement_2.choices.create(text: 'Eher gering')
  statement_2.choices.create(text: 'Eher hoch')
  statement_2.choices.create(text: 'Sehr hoch')

  if role == role_1
    statement_3 = set.statements.create(style: 'multiple_choice', text: 'Stellen Sie sich vor, Sie befinden sich in einer Stadt und möchten eine Fahrt im autonomen Shuttle buchen. Welche der folgenden Möglichkeiten würden Sie am ehesten wählen?')
	statement_3.choices.create(text: 'Wartezeit: 10 Minuten; Preis für die Fahrt: 2 €')
    statement_3.choices.create(text: 'Wartezeit: keine; Preis für die Fahrt: 3 €')

	statement_4 = set.statements.create(style: 'multiple_choice', text: 'Stellen Sie sich vor, Sie befinden sich im ländlichen Raum und möchten eine Fahrt im autonomen Shuttle buchen. Welche der folgenden Möglichkeiten würden Sie am ehesten wählen?')
	statement_4.choices.create(text: 'Wartezeit: 30 Minuten; Preis für die Fahrt: 3 €')
    statement_4.choices.create(text: 'Wartezeit: keine; Preis für die Fahrt: 9 €')
  end

  if role == role_2
    statement_5 = set.statements.create(style: 'multiple_choice', text: 'Wie bewerten Sie diesen Service für Ihre Region?')
	statement_5.choices.create(text: 'Sehr schlecht')
	statement_5.choices.create(text: 'Eher schlecht')
	statement_5.choices.create(text: 'Eher gut')
	statement_5.choices.create(text: 'Sehr gut')
  end

  if [role_2, role_3].include? role
	statement_6 = set.statements.create(style: 'multiple_choice', text: 'Wie stark werden solche Services Ihre Arbeit in Zukunft verändern?')
	statement_6.choices.create(text: 'Gar nicht stark')
	statement_6.choices.create(text: 'Eher nicht stark')
	statement_6.choices.create(text: 'Eher stark')
	statement_6.choices.create(text: 'Sehr stark')
  end

  if role == role_4
    statement_7 = set.statements.create(style: 'multiple_choice', text: 'Wie stark werden solche Services ihr Mobilitätsangebot in der Zukunft verändern?')
	statement_7.choices.create(text: 'Gar nicht stark')
	statement_7.choices.create(text: 'Eher nicht stark')
	statement_7.choices.create(text: 'Eher stark')
	statement_7.choices.create(text: 'Sehr stark')
  end

  if role == role_5
    statement_8 = set.statements.create(style: 'multiple_choice', text: 'Wir würden Sie eine Anbindung dieses Services an Ihre Infrastruktur bewerten?')
    statement_8.choices.create(text: 'Sehr schlecht')
	statement_8.choices.create(text: 'Eher schlecht')
	statement_8.choices.create(text: 'Eher gut')
	statement_8.choices.create(text: 'Sehr gut')
  end
end


# multimodal privacy
Role.all.each do |role|
  set = multimodal_priv_topic_1.statement_sets.create(role: role)

  statement_1 = set.statements.create(style: 'multiple_choice', text: 'Wie wichtig finden Sie es, dass bei multimodalen Apps das Level der Datensicherheit wählbar ist?')
  statement_1.choices.create(text: 'Gar nicht wichtig')
  statement_1.choices.create(text: 'Weniger wichtig')
  statement_1.choices.create(text: 'Eher wichtig')
  statement_1.choices.create(text: 'Sehr wichtig')

  if role == role_1
    statement_2 = set.statements.create(style: 'multiple_choice', text: 'Welche Daten würden Sie für die Nutzung solcher Services bereitstellen?')
    statement_2.choices.create(text: 'Zugriff auf Standort')
    statement_2.choices.create(text: 'Zugriff auf Kalender')
	statement_2.choices.create(text: 'Zugriff auf Kontakte')
    statement_2.choices.create(text: 'Zugriff auf Kamera')
	statement_2.choices.create(text: 'Zugriff auf Dateien')
    statement_2.choices.create(text: 'Hinterlegung von Kontodaten')

	statement_3 = set.statements.create(style: 'multiple_choice', text: 'Wenn Sie Informationen zum verwendungszweck der Daten erhalten würden, welche Daten würden Sie für die Nutzung solcher Services bereitstellen?')
    statement_3.choices.create(text: 'Navigation und Öffnen des Fahrzeugs: Zugriff auf Standort')
    statement_3.choices.create(text: 'Erinnerungen, Empfehlungen o.Ä.: Zugriff auf Kalender')
	statement_3.choices.create(text: 'Auswahl hinterlegter Adressen aus dem Adressbuch: Zugriff auf Kontakte')
    statement_3.choices.create(text: 'Authentifizierung und Führerscheinprüfung: Zugriff auf Kamera')
	statement_3.choices.create(text: 'Abspielen persönlicher Lieblingsmusik: Zugriff auf Dateien')
    statement_3.choices.create(text: 'Abrechnung: Hinterlegung von Kontodaten')
  end

  if role == role_2
    statement_4 = set.statements.create(style: 'multiple_choice', text: 'Für wie wichtig halten Sie die Durchsetzung von schärferen Datenschutzrichtlinien?')
    statement_4.choices.create(text: 'Gar nicht wichtig')
	statement_4.choices.create(text: 'Wenig wichtig')
	statement_4.choices.create(text: 'Eher wichtig')
	statement_4.choices.create(text: 'Sehr wichtig')
  end

  if [role_3, role_4, role_5].include? role
    statement_5 = set.statements.create(style: 'multiple_choice', text: 'Bitte geben Sie an, wie wertvvoll Sie die anfallenden Daten (z.B. zurückgelegte Strecken und genutzte Verkehrsmittel, Orte und Wegezwecke, Zeitpunkte der Wege etc.) für Ihre eigene Arbeit finden')
    statement_5.choices.create(text: 'Nicht wertvoll')
	statement_5.choices.create(text: 'Wenig wertvoll')
	statement_5.choices.create(text: 'Ziemlich wertvoll')
	statement_5.choices.create(text: 'Sehr wertvoll')
  end
end

# Data Driven Planning
Role.all.each do |role|
  set = ddp_topic_1.statement_sets.create(role: role)

  statement_1 = set.statements.create(style: 'multiple_choice', text: 'Wie wichtig sind Ihnen interaktive Aufbereitungen verfügbarer Daten zur Illustration oder Kommunikation?')
  statement_1.choices.create(text: 'Gar nicht wichtig')
  statement_1.choices.create(text: 'Eher unwichtig')
  statement_1.choices.create(text: 'Eher wichtig')
  statement_1.choices.create(text: 'Sehr wichtig')

  if role == role_1
    statement_2 = set.statements.create(style: 'multiple_choice', text: 'Würden Sie sich mit Ihrem eigenen Smartphone tracken, um Ihre eigene Mobilität besser zu verstehen? (D.h. Sie erfassen kontinuierlich Ihre eigene Position woraus automatisch Wege, Verkehrsmittel und CO2-Emissionen berechnet werden.)')
    statement_2.choices.create(text: 'Ja')
    statement_2.choices.create(text: 'Nein')
  end

  if role == role_2
    statement_3 = set.statements.create(style: 'multiple_choice', text: 'Wie hilfreich ist die Aufbereitung von mobilitätsrelevanten Daten für Sie um Entscheidungen zu treffen?')
    statement_3.choices.create(text: 'Gar nicht hilfreich')
    statement_3.choices.create(text: 'Eher nicht hilfreich')
    statement_3.choices.create(text: 'Eher hilfreich')
    statement_3.choices.create(text: 'Sehr hilfreich')
  end

  if [role_3, role_4, role_5].include? role
    statement_4 = set.statements.create(style: 'multiple_choice', text: 'Verknüpfen Sie proprietäre und offene Daten für Analysen, um Kundenverhalten besser zu verstehen?')
    statement_4.choices.create(text: 'Ja')
    statement_4.choices.create(text: 'Nein')
  end

  if [role_2, role_3, role_4, role_5].include? role
    statement_5 = set.statements.create(style: 'multiple_choice', text: 'Welchen Herausforderungen begegnen Sie auf Ebene der Datenverarbeitung in Ihrer Arbeit mit Daten?')
    statement_5.choices.create(text: 'Unterschiedliche Datenformate')
    statement_5.choices.create(text: 'Fehlende Aktualität der Daten')
    statement_5.choices.create(text: 'Schlechte Datenverfügbarkeit')
    statement_5.choices.create(text: 'Fehlende Methoden zur Datenverarbeitung')
    statement_5.choices.create(text: 'Detaillierungsgrad der Daten')
    statement_5.choices.create(text: 'Fehlende IT-Standards')
  end
 end

# HSA-Exponat
# Topic Nutzer
Role.all.each do |role|
  set = hsa_topic_1.statement_sets.create(role: role)

  statement_1 = set.statements.create(style: 'multiple_choice', text: 'Von welchen Gruppen sollten gesammelte Daten bei der Entwicklung solcher Angebote mit einbezogen werden?')
  statement_1.choices.create(text: 'Von Nutzerinnen und Nutzern')
  statement_1.choices.create(text: 'Von Personen aus Politik und Planung')
  statement_1.choices.create(text: 'Von Fahrzeugherstellern und Flottenbetreiberinnen')
  statement_1.choices.create(text: 'Von Mobilitätsdienstanbietern')
  statement_1.choices.create(text: 'Vom Energy and Transport Flow Management')

  statement_2 = set.statements.create(style: 'multiple_choice', text: 'Von welchen Gruppen sollte eine Expertenmeinung aus der jeweiligen Perspektive bei der Entwicklung solcher Angebote mit einbezogen werden?')
  statement_2.choices.create(text: 'Von Nutzerinnen und Nutzern')
  statement_2.choices.create(text: 'Von Personen aus Politik und Planung')
  statement_2.choices.create(text: 'Von Fahrzeugherstellern und Flottenbetreiberinnen')
  statement_2.choices.create(text: 'Von Mobilitätsdienstanbietern')
  statement_2.choices.create(text: 'Von Personen aus dem Flow Management im Energie- und Verkehrsbereich')

  statement_3 = set.statements.create(style: 'multiple_choice', text: 'Wie wichtig finden Sie den frühzeitigen Einbezug der Nutzer in die Entwicklung solcher Angebote?')
  statement_3.choices.create(text: 'Gar nicht wichtig')
  statement_3.choices.create(text: 'Eher unwichtig')
  statement_3.choices.create(text: 'Eher wichtig')
  statement_3.choices.create(text: 'Sehr wichtig')

  statement_4 = set.statements.create(style: 'multiple_choice', text: 'Wie wichtig finden Sie den frühzeitigen Einbezug von Personen aus Politik und Planung in die Entwicklung solcher Angebote?')
  statement_4.choices.create(text: 'Gar nicht wichtig')
  statement_4.choices.create(text: 'Eher unwichtig')
  statement_4.choices.create(text: 'Eher wichtig')
  statement_4.choices.create(text: 'Sehr wichtig')

  statement_5 = set.statements.create(style: 'multiple_choice', text: 'Wie wichtig finden Sie den frühzeitigen Einbezug von Fahrzeugherstellern und Flottenbetreiberinnen in die Entwicklung solcher Angebote?')
  statement_5.choices.create(text: 'Gar nicht wichtig')
  statement_5.choices.create(text: 'Eher unwichtig')
  statement_5.choices.create(text: 'Eher wichtig')
  statement_5.choices.create(text: 'Sehr wichtig')

  statement_6 = set.statements.create(style: 'multiple_choice', text: 'Wie wichtig finden Sie den frühzeitigen Einbezug von Mobilitätsdienstanbietern in die Entwicklung solcher Angebote?')
  statement_6.choices.create(text: 'Gar nicht wichtig')
  statement_6.choices.create(text: 'Eher unwichtig')
  statement_6.choices.create(text: 'Eher wichtig')
  statement_6.choices.create(text: 'Sehr wichtig')

  statement_7 = set.statements.create(style: 'multiple_choice', text: 'Wie wichtig finden Sie den frühzeitigen Einbezug von Personen aus dem Flow Management im Energie- und Verkehrsbereich in die Entwicklung solcher Angebote?')
  statement_7.choices.create(text: 'Gar nicht wichtig')
  statement_7.choices.create(text: 'Eher unwichtig')
  statement_7.choices.create(text: 'Eher wichtig')
  statement_7.choices.create(text: 'Sehr wichtig')

 end

 # Topic Politik und Planung
Role.all.each do |role|
  set = hsa_topic_2.statement_sets.create(role: role)

  statement_1 = set.statements.create(style: 'multiple_choice', text: 'Von welchen Gruppen sollten gesammelte Daten bei der Entwicklung solcher Angebote mit einbezogen werden?')
  statement_1.choices.create(text: 'Von Nutzerinnen und Nutzern')
  statement_1.choices.create(text: 'Von Personen aus Politik und Planung')
  statement_1.choices.create(text: 'Von Fahrzeugherstellern und Flottenbetreiberinnen')
  statement_1.choices.create(text: 'Von Mobilitätsdienstanbietern')
  statement_1.choices.create(text: 'Vom Energy and Transport Flow Management')

  statement_2 = set.statements.create(style: 'multiple_choice', text: 'Von welchen Gruppen sollte eine Expertenmeinung aus der jeweiligen Perspektive bei der Entwicklung solcher Angebote mit einbezogen werden?')
  statement_2.choices.create(text: 'Von Nutzerinnen und Nutzern')
  statement_2.choices.create(text: 'Von Personen aus Politik und Planung')
  statement_2.choices.create(text: 'Von Fahrzeugherstellern und Flottenbetreiberinnen')
  statement_2.choices.create(text: 'Von Mobilitätsdienstanbietern')
  statement_2.choices.create(text: 'Von Personen aus dem Flow Management im Energie- und Verkehrsbereich')

  statement_3 = set.statements.create(style: 'multiple_choice', text: 'Wie wichtig finden Sie den frühzeitigen Einbezug der Nutzer in die Entwicklung solcher Angebote?')
  statement_3.choices.create(text: 'Gar nicht wichtig')
  statement_3.choices.create(text: 'Eher unwichtig')
  statement_3.choices.create(text: 'Eher wichtig')
  statement_3.choices.create(text: 'Sehr wichtig')

  statement_4 = set.statements.create(style: 'multiple_choice', text: 'Wie wichtig finden Sie den frühzeitigen Einbezug von Personen aus Politik und Planung in die Entwicklung solcher Angebote?')
  statement_4.choices.create(text: 'Gar nicht wichtig')
  statement_4.choices.create(text: 'Eher unwichtig')
  statement_4.choices.create(text: 'Eher wichtig')
  statement_4.choices.create(text: 'Sehr wichtig')

  statement_5 = set.statements.create(style: 'multiple_choice', text: 'Wie wichtig finden Sie den frühzeitigen Einbezug von Fahrzeugherstellern und Flottenbetreiberinnen in die Entwicklung solcher Angebote?')
  statement_5.choices.create(text: 'Gar nicht wichtig')
  statement_5.choices.create(text: 'Eher unwichtig')
  statement_5.choices.create(text: 'Eher wichtig')
  statement_5.choices.create(text: 'Sehr wichtig')

  statement_6 = set.statements.create(style: 'multiple_choice', text: 'Wie wichtig finden Sie den frühzeitigen Einbezug von Mobilitätsdienstanbietern in die Entwicklung solcher Angebote?')
  statement_6.choices.create(text: 'Gar nicht wichtig')
  statement_6.choices.create(text: 'Eher unwichtig')
  statement_6.choices.create(text: 'Eher wichtig')
  statement_6.choices.create(text: 'Sehr wichtig')

  statement_7 = set.statements.create(style: 'multiple_choice', text: 'Wie wichtig finden Sie den frühzeitigen Einbezug von Personen aus dem Flow Management im Energie- und Verkehrsbereich in die Entwicklung solcher Angebote?')
  statement_7.choices.create(text: 'Gar nicht wichtig')
  statement_7.choices.create(text: 'Eher unwichtig')
  statement_7.choices.create(text: 'Eher wichtig')
  statement_7.choices.create(text: 'Sehr wichtig')
 end

 # Topic Fahrzeughersteller
Role.all.each do |role|
  set = hsa_topic_3.statement_sets.create(role: role)

  statement_1 = set.statements.create(style: 'multiple_choice', text: 'Von welchen Gruppen sollten gesammelte Daten bei der Entwicklung solcher Angebote mit einbezogen werden?')
  statement_1.choices.create(text: 'Von Nutzerinnen und Nutzern')
  statement_1.choices.create(text: 'Von Personen aus Politik und Planung')
  statement_1.choices.create(text: 'Von Fahrzeugherstellern und Flottenbetreiberinnen')
  statement_1.choices.create(text: 'Von Mobilitätsdienstanbietern')
  statement_1.choices.create(text: 'Vom Energy and Transport Flow Management')

  statement_2 = set.statements.create(style: 'multiple_choice', text: 'Von welchen Gruppen sollte eine Expertenmeinung aus der jeweiligen Perspektive bei der Entwicklung solcher Angebote mit einbezogen werden?')
  statement_2.choices.create(text: 'Von Nutzerinnen und Nutzern')
  statement_2.choices.create(text: 'Von Personen aus Politik und Planung')
  statement_2.choices.create(text: 'Von Fahrzeugherstellern und Flottenbetreiberinnen')
  statement_2.choices.create(text: 'Von Mobilitätsdienstanbietern')
  statement_2.choices.create(text: 'Von Personen aus dem Flow Management im Energie- und Verkehrsbereich')

  statement_3 = set.statements.create(style: 'multiple_choice', text: 'Wie wichtig finden Sie den frühzeitigen Einbezug der Nutzer in die Entwicklung solcher Angebote?')
  statement_3.choices.create(text: 'Gar nicht wichtig')
  statement_3.choices.create(text: 'Eher unwichtig')
  statement_3.choices.create(text: 'Eher wichtig')
  statement_3.choices.create(text: 'Sehr wichtig')

  statement_4 = set.statements.create(style: 'multiple_choice', text: 'Wie wichtig finden Sie den frühzeitigen Einbezug von Personen aus Politik und Planung in die Entwicklung solcher Angebote?')
  statement_4.choices.create(text: 'Gar nicht wichtig')
  statement_4.choices.create(text: 'Eher unwichtig')
  statement_4.choices.create(text: 'Eher wichtig')
  statement_4.choices.create(text: 'Sehr wichtig')

  statement_5 = set.statements.create(style: 'multiple_choice', text: 'Wie wichtig finden Sie den frühzeitigen Einbezug von Fahrzeugherstellern und Flottenbetreiberinnen in die Entwicklung solcher Angebote?')
  statement_5.choices.create(text: 'Gar nicht wichtig')
  statement_5.choices.create(text: 'Eher unwichtig')
  statement_5.choices.create(text: 'Eher wichtig')
  statement_5.choices.create(text: 'Sehr wichtig')

  statement_6 = set.statements.create(style: 'multiple_choice', text: 'Wie wichtig finden Sie den frühzeitigen Einbezug von Mobilitätsdienstanbietern in die Entwicklung solcher Angebote?')
  statement_6.choices.create(text: 'Gar nicht wichtig')
  statement_6.choices.create(text: 'Eher unwichtig')
  statement_6.choices.create(text: 'Eher wichtig')
  statement_6.choices.create(text: 'Sehr wichtig')

  statement_7 = set.statements.create(style: 'multiple_choice', text: 'Wie wichtig finden Sie den frühzeitigen Einbezug von Personen aus dem Flow Management im Energie- und Verkehrsbereich in die Entwicklung solcher Angebote?')
  statement_7.choices.create(text: 'Gar nicht wichtig')
  statement_7.choices.create(text: 'Eher unwichtig')
  statement_7.choices.create(text: 'Eher wichtig')
  statement_7.choices.create(text: 'Sehr wichtig')
 end

 # Topic Mobilitätsdienstanbieter
Role.all.each do |role|
  set = hsa_topic_4.statement_sets.create(role: role)

  statement_1 = set.statements.create(style: 'multiple_choice', text: 'Von welchen Gruppen sollten gesammelte Daten bei der Entwicklung solcher Angebote mit einbezogen werden?')
  statement_1.choices.create(text: 'Von Nutzerinnen und Nutzern')
  statement_1.choices.create(text: 'Von Personen aus Politik und Planung')
  statement_1.choices.create(text: 'Von Fahrzeugherstellern und Flottenbetreiberinnen')
  statement_1.choices.create(text: 'Von Mobilitätsdienstanbietern')
  statement_1.choices.create(text: 'Vom Energy and Transport Flow Management')

  statement_2 = set.statements.create(style: 'multiple_choice', text: 'Von welchen Gruppen sollte eine Expertenmeinung aus der jeweiligen Perspektive bei der Entwicklung solcher Angebote mit einbezogen werden?')
  statement_2.choices.create(text: 'Von Nutzerinnen und Nutzern')
  statement_2.choices.create(text: 'Von Personen aus Politik und Planung')
  statement_2.choices.create(text: 'Von Fahrzeugherstellern und Flottenbetreiberinnen')
  statement_2.choices.create(text: 'Von Mobilitätsdienstanbietern')
  statement_2.choices.create(text: 'Von Personen aus dem Flow Management im Energie- und Verkehrsbereich')

  statement_3 = set.statements.create(style: 'multiple_choice', text: 'Wie wichtig finden Sie den frühzeitigen Einbezug der Nutzer in die Entwicklung solcher Angebote?')
  statement_3.choices.create(text: 'Gar nicht wichtig')
  statement_3.choices.create(text: 'Eher unwichtig')
  statement_3.choices.create(text: 'Eher wichtig')
  statement_3.choices.create(text: 'Sehr wichtig')

  statement_4 = set.statements.create(style: 'multiple_choice', text: 'Wie wichtig finden Sie den frühzeitigen Einbezug von Personen aus Politik und Planung in die Entwicklung solcher Angebote?')
  statement_4.choices.create(text: 'Gar nicht wichtig')
  statement_4.choices.create(text: 'Eher unwichtig')
  statement_4.choices.create(text: 'Eher wichtig')
  statement_4.choices.create(text: 'Sehr wichtig')

  statement_5 = set.statements.create(style: 'multiple_choice', text: 'Wie wichtig finden Sie den frühzeitigen Einbezug von Fahrzeugherstellern und Flottenbetreiberinnen in die Entwicklung solcher Angebote?')
  statement_5.choices.create(text: 'Gar nicht wichtig')
  statement_5.choices.create(text: 'Eher unwichtig')
  statement_5.choices.create(text: 'Eher wichtig')
  statement_5.choices.create(text: 'Sehr wichtig')

  statement_6 = set.statements.create(style: 'multiple_choice', text: 'Wie wichtig finden Sie den frühzeitigen Einbezug von Mobilitätsdienstanbietern in die Entwicklung solcher Angebote?')
  statement_6.choices.create(text: 'Gar nicht wichtig')
  statement_6.choices.create(text: 'Eher unwichtig')
  statement_6.choices.create(text: 'Eher wichtig')
  statement_6.choices.create(text: 'Sehr wichtig')

  statement_7 = set.statements.create(style: 'multiple_choice', text: 'Wie wichtig finden Sie den frühzeitigen Einbezug von Personen aus dem Flow Management im Energie- und Verkehrsbereich in die Entwicklung solcher Angebote?')
  statement_7.choices.create(text: 'Gar nicht wichtig')
  statement_7.choices.create(text: 'Eher unwichtig')
  statement_7.choices.create(text: 'Eher wichtig')
  statement_7.choices.create(text: 'Sehr wichtig')
 end

 # Topic Energie management
Role.all.each do |role|
  set = hsa_topic_5.statement_sets.create(role: role)

  statement_1 = set.statements.create(style: 'multiple_choice', text: 'Von welchen Gruppen sollten gesammelte Daten bei der Entwicklung solcher Angebote mit einbezogen werden?')
  statement_1.choices.create(text: 'Von Nutzerinnen und Nutzern')
  statement_1.choices.create(text: 'Von Personen aus Politik und Planung')
  statement_1.choices.create(text: 'Von Fahrzeugherstellern und Flottenbetreiberinnen')
  statement_1.choices.create(text: 'Von Mobilitätsdienstanbietern')
  statement_1.choices.create(text: 'Vom Energy and Transport Flow Management')

  statement_2 = set.statements.create(style: 'multiple_choice', text: 'Von welchen Gruppen sollte eine Expertenmeinung aus der jeweiligen Perspektive bei der Entwicklung solcher Angebote mit einbezogen werden?')
  statement_2.choices.create(text: 'Von Nutzerinnen und Nutzern')
  statement_2.choices.create(text: 'Von Personen aus Politik und Planung')
  statement_2.choices.create(text: 'Von Fahrzeugherstellern und Flottenbetreiberinnen')
  statement_2.choices.create(text: 'Von Mobilitätsdienstanbietern')
  statement_2.choices.create(text: 'Von Personen aus dem Flow Management im Energie- und Verkehrsbereich')

  statement_3 = set.statements.create(style: 'multiple_choice', text: 'Wie wichtig finden Sie den frühzeitigen Einbezug der Nutzer in die Entwicklung solcher Angebote?')
  statement_3.choices.create(text: 'Gar nicht wichtig')
  statement_3.choices.create(text: 'Eher unwichtig')
  statement_3.choices.create(text: 'Eher wichtig')
  statement_3.choices.create(text: 'Sehr wichtig')

  statement_4 = set.statements.create(style: 'multiple_choice', text: 'Wie wichtig finden Sie den frühzeitigen Einbezug von Personen aus Politik und Planung in die Entwicklung solcher Angebote?')
  statement_4.choices.create(text: 'Gar nicht wichtig')
  statement_4.choices.create(text: 'Eher unwichtig')
  statement_4.choices.create(text: 'Eher wichtig')
  statement_4.choices.create(text: 'Sehr wichtig')

  statement_5 = set.statements.create(style: 'multiple_choice', text: 'Wie wichtig finden Sie den frühzeitigen Einbezug von Fahrzeugherstellern und Flottenbetreiberinnen in die Entwicklung solcher Angebote?')
  statement_5.choices.create(text: 'Gar nicht wichtig')
  statement_5.choices.create(text: 'Eher unwichtig')
  statement_5.choices.create(text: 'Eher wichtig')
  statement_5.choices.create(text: 'Sehr wichtig')

  statement_6 = set.statements.create(style: 'multiple_choice', text: 'Wie wichtig finden Sie den frühzeitigen Einbezug von Mobilitätsdienstanbietern in die Entwicklung solcher Angebote?')
  statement_6.choices.create(text: 'Gar nicht wichtig')
  statement_6.choices.create(text: 'Eher unwichtig')
  statement_6.choices.create(text: 'Eher wichtig')
  statement_6.choices.create(text: 'Sehr wichtig')

  statement_7 = set.statements.create(style: 'multiple_choice', text: 'Wie wichtig finden Sie den frühzeitigen Einbezug von Personen aus dem Flow Management im Energie- und Verkehrsbereich in die Entwicklung solcher Angebote?')
  statement_7.choices.create(text: 'Gar nicht wichtig')
  statement_7.choices.create(text: 'Eher unwichtig')
  statement_7.choices.create(text: 'Eher wichtig')
  statement_7.choices.create(text: 'Sehr wichtig')
 end
