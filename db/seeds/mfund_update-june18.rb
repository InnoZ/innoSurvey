# CREATE SURVEY
survey = Survey.find_by_name('mFUND')

# CREATE STATIONS
hsa = survey.stations.find_by(name: 'Case Studies')

# TOPICS
topic_user = hsa.topics.find(20)
topic_planning = hsa.topics.find(23)
topic_vehicle = hsa.topics.find(22)
topic_mobility = hsa.topics.find(21)
topic_energy = hsa.topics.find(24)

topic_planning.statement_sets.destroy_all
topic_energy.statement_sets.destroy_all
topic_vehicle.statement_sets.destroy_all
topic_mobility.statement_sets.destroy_all
topic_user.statement_sets.destroy_all

# STATEMENTSETS + STATEMENTS + CHOICES
# Topic Politik und Planung
survey.roles.all.each do |role|
  set1 = topic_planning.statement_sets.create(role: role)

  s1 = set1.statements.create(style: 'multiple_choice', text: 'Stellen Sie sich vor, Sie sind in Ihrer Heimatstadt dafür zuständig, die Emissionen durch Verkehr zu senken. Welche Maßnahme würden Sie am stärksten unterstützen?')
  s1.choices.create(text: 'Temporäre oder zonenabhängige Fahrverbote für Verbrenner-Fahrzeuge')
  s1.choices.create(text: 'Fußgänger- und Fahrradfreundlichere Straßenräume')
  s1.choices.create(text: 'Mobilitätsalternativen zum Pkw ausbauen (ÖV, Shared Mobility, Lieferdienste etc.)')
  s1.choices.create(text: 'Förderung der Elektromobilität und des Ladens mit „Grünstrom“')
  s1.choices.create(text: 'Keine dieser Maßnahmen')

  # Topic Energie management
  set2 = topic_energy.statement_sets.create(role: role)

  s2 = set2.statements.create(style: 'multiple_choice', text: 'Stellen Sie sich vor, Sie sind in Ihrer Heimatstadt dafür zuständig, die Verkehrsflüsse quer über alle Verkehrsmittel hinweg zu optimieren. Was würde Ihnen am meisten weiterhelfen?')
  s2.choices.create(text: 'Zentrales Informationssystem für alle Mobilitätsanbieter zur aktuellen Verkehrslage')
  s2.choices.create(text: 'Zentrales Informationssystem zur Verfügbarkeit von grünem Ladestrom für alle Elektrofahrzeuge')
  s2.choices.create(text: 'Eine offene Datenplattform für alle verfügbaren Bewegungsdaten')
  s2.choices.create(text: 'Eine offene Datenplattform für alle verfügbaren Infrastrukturdaten')
  s2.choices.create(text: 'Keine dieser Maßnahmen')

  # Topic Fahrzeughersteller und Flottenbetreiber
  # Remove all statement sets (hence all statements, choices, etc.)
  set3 = topic_vehicle.statement_sets.create(role: role)

  s3 = set3.statements.create(style: 'multiple_choice', text: 'Stellen Sie sich vor, Sie bieten ein neues Shared Mobility-System an (Cargo-Bike, Scooter, Shuttle o.ä.). Welche Maßnahme seitens Politik und Planung würde Ihnen am meisten weiterhelfen?')
  s3.choices.create(text: 'Unterstützung durch die Verwaltung z.B. durch vereinfachte Genehmigungsverfahren')
  s3.choices.create(text: 'Politisches Bekenntnis zu Shared Mobility')
  s3.choices.create(text: 'Infrastrukturelle Maßnahmen wie z.B. Ausbau von Parkflächen oder Ladeoptionen')
  s3.choices.create(text: 'Informationen zur Verkehrslage und potenzieller Nachfrage-Hotspots')
  s3.choices.create(text: 'Keine dieser Maßnahmen')

  # Mobilitätsdienstleister
  # Remove all statement sets (hence all statements, choices, etc.)
  set4 = topic_mobility.statement_sets.create(role: role)

  s4 = set4.statements.create(style: 'multiple_choice', text: 'Stellen Sie sich vor, Sie bieten eine digitale Mobilitätsdienstleistung an, die Daten von verschiedenen anderen Mobilitätsdienstleistern verarbeitet. Welche Maßnahme seitens Politik und Planung würde Ihnen am stärksten weiterhelfen?')
  s4.choices.create(text: 'Offene Datenplattformen')
  s4.choices.create(text: 'Stakeholder-Vernetzung z.B. durch Arbeitsgemeinschaften oder Meet-ups')
  s4.choices.create(text: 'Mobilitätsdatenmarktplatz in öffentlicher Hand mit hohen Datenschutz-Standards')
  s4.choices.create(text: 'Keine dieser Maßnahmen')

  # Nutzer*innen
  # Remove all statement sets (hence all statements, choices, etc.)
  set5 = topic_user.statement_sets.create(role: role)

  s5 = set5.statements.create(style: 'multiple_choice', text: 'Würden Sie ihre Wege aufzeichnen, wenn Sie hierfür ein Incentive (z.B. ein Carsharing-Guthaben) erhalten würden? ')
  s5.choices.create(text: 'Ja')
  s5.choices.create(text: 'Nein')
  s5.choices.create(text: 'Vielleicht')

  s6 = set5.statements.create(style: 'multiple_choice', text: 'Stellen Sie sich vor, Sie nutzen eine digitale Mobilitätsdienstleistung, die Daten von verschiedenen Mobilitätsdienstleistern verarbeitet. Welcher Aspekt wäre Ihnen besonders wichtig?')
  s6.choices.create(text: 'Sicherstellen von Datensouveränität, z.B. durch Kontrollen, ob auch wirklich alle Daten gelöscht wurden, wenn ein Nutzer dies verlangt hat')
  s6.choices.create(text: 'Unterstützung von Datensparsamkeit, z.B. durch Zugangssysteme mit einer anonymen ID')
  s6.choices.create(text: 'Abstimmung der Dienste auf meine ganz speziellen Bedürfnisse, z.B. durch einen Abgleich mit meinem Kalender')
  s6.choices.create(text: 'Mir ist es egal, was mit meinen Daten passiert, wenn ich dafür einen kostenlosen Service erhalten.')
end
