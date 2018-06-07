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
platforms = survey.stations.create(name: 'Platforms')
ai = survey.stations.create(name: 'Artifical Intelligence')
multimodal_priv = survey.stations.create(name: 'Multimodal Privacy')
ddp = survey.stations.create(name: 'Data Driven Planning')
hsa = survey.stations.create(name: 'HSA-Exponat')

# TOPICS
platforms_topic_1 = platforms.topics.create(name: platforms.name, description: 'Fragen zu Platforms')
ai_topic_1 = ai.topics.create(name: ai.name, description: 'Fragen zum AI Supported Flow Management')
multimodal_priv_topic_1 = multimodal_priv.topics.create(name: multimodal_priv.name, description: 'Fragen zu Multimodal Privacy')
ddp_topic_1 = ddp.topics.create(name: ddp.name, description: 'Fragen zum Data Driven Planning')
hsa_topic_1 = hsa.topics.create(name: hsa.name, description: 'Szenarien für Nutzerinnen und Nutzer')
hsa_topic_2 = hsa.topics.create(name: hsa.name, description: 'Szenarien für Politik und Planung')
hsa_topic_3 = hsa.topics.create(name: hsa.name, description: 'Szenarien für Fahrzeughersteller und Flottenbetreiberinnen')
hsa_topic_4 = hsa.topics.create(name: hsa.name, description: 'Szenarien für Mobilitätsdienstanbieterinnen und -anbieter')
hsa_topic_5 = hsa.topics.create(name: hsa.name, description: 'Szenarien für Flow Management in den Bereichen Eenrgie und Verkehr')

# STATEMENTSETS + STATEMENTS + CHOICES
# PLATFORMS
Role.all.each do |role|
  set = platforms_topic_1.statement_sets.create(role: role)

  if role == role_1
    s = set.statements.create(style: 'single_choice', text: 'Was erhoffen Sie sich am meisten von einer stärkeren digitalen Vernetzung verschiedener Mobilitätsangebote?')
    s.choices.create(text: 'Individuelle Zeitersparnis')
    s.choices.create(text: 'Mehr Verkehrssicherheit (niedrigere Unfallgefahr)')
    s.choices.create(text: 'Präzise Navigationsmöglichkeiten')
    s.choices.create(text: 'Umwelt- und ressourcenschonende Mobilitätsangebote')
    s.choices.create(text: 'Kostenersparnis')
    s.choices.create(text: 'Einfachere Nutzung der Mobilitätsangebote')
    s.choices.create(text: 'Bessere Erreichbarkeit meiner Ziele')

    s = set.statements.create(style: 'single_choice', text: 'Welche Befürchtungen haben Sie in Bezug auf eine stärkere Vernetzung verschiedener Mobilitätsangebote?')
    s.choices.create(text: 'Datenschutz wird unterhöhlt')
    s.choices.create(text: 'Anfälligkeit für Hackerangriffe')
    s.choices.create(text: 'Zusammenbruch bei Stromausfall')
    s.choices.create(text: 'Weniger Verkehrssicherheit (höhere Unfallgefahr)')
    s.choices.create(text: 'Mehr Ressourcenverbrauch im Mobilitätsbereich')
    s.choices.create(text: 'Abhängigkeit vom Smartphone zur Nutzung des Mobilitätsangebots')
  end

  if role == role_4
    s = set.statements.create(style: 'single_choice', text: 'Wo erwarten Sie erfolgreiche Geschäftsmodelle rund um die digitale Vernetzung von Mobilitätsangeboten?')
    s.choices.create(text: 'Im Bereich der Datensicherheit')
    s.choices.create(text: 'Datenverarbeitung zu Diensten')
    s.choices.create(text: 'IT-Beratung von Stakeholdern aus dem Mobilitätssektor')
    s.choices.create(text: 'IT-Beratung von kommunalen Stakeholdern')
    s.choices.create(text: 'Erstellen von Personenprofilen')
    s.choices.create(text: 'Interaktion mit Verkehrsteilnehmern (z.B. Information, Warnungen etc.)')
  end

  if [role_2, role_3, role_5].include? role
    s = set.statements.create(style: 'single_choice', text: 'Was erhoffen Sie sich durch die digitale Vernetzung von Mobilitätsangeboten?')
    s.choices.create(text: 'Insgesamt weniger Staus')
    s.choices.create(text: 'Optimierte Verkehrsflüsse')
    s.choices.create(text: 'Komfortablere Nutzung aller verfügbaren Angebote')
    s.choices.create(text: 'Stärkung des Fuß- und Radverkehrs')
    s.choices.create(text: 'Weniger Abhängigkeit von dominanten Stakeholdern (z.B. Infrastrukturbetreiber)')
    s.choices.create(text: 'Weniger Flächenverbrauch durch den privaten Pkw-Verkehr')
    s.choices.create(text: 'Einsparen von (lokalen) Emissionen')
    s.choices.create(text: 'Besserer Zugang zum öffentlichen Verkehr für bestimmte soziale Gruppen (z.B. Ältere)')
  end

  if [role_2, role_5].include? role
    s = set.statements.create(style: 'single_choice', text: 'Welche Herausforderungen erwarten Sie bei der Integration verschiedener Mobilitätsdienste (z.B. Carsharing) in aktuelle Verkehrsmanagementsysteme?')
    s.choices.create(text: 'Probleme beim Austausch von Daten mit Flottenbetreibern, z.B. zu freien Fahrzeugkapazitäten')
    s.choices.create(text: 'Probleme beim Austausch von Daten mit anderen Stakeholdern')
    s.choices.create(text: 'Erhöhte Komplexität der Verkehrsprognosen')
    s.choices.create(text: 'Erhöhte Komplexität der Verkehrsinformationssysteme')
    s.choices.create(text: 'Erhöhte Komplexität der Verkehrssteuerung')
  end

  if [role_2, role_3, role_4, role_5].include? role
    s = set.statements.create(style: 'single_choice', text: 'Welche IT-technischen Herausforderungen erwarten Sie bei der Nutzung von Datenplattformen für die Entwicklung von Mobilitätsinnovationen?')
    s.choices.create(text: 'Mangelnde Datenverfügbarkeit')
    s.choices.create(text: 'Mangelnde Datenqualität')
    s.choices.create(text: 'Strikte Datenschutzbestimmungen')
    s.choices.create(text: 'Mangelnde IT-Kenntnisse relevanter Stakeholder in Unternehmen oder Kommunen')
    s.choices.create(text: 'Hohe Kosten für relevante Daten')
    s.choices.create(text: 'Fehlende interkommunale oder überregionale Kooperationen')
    s.choices.create(text: 'Fehlende IT-Standards (z.B. zur Aufbereitung unstrukturierter Datensätze)')
  end
end

# AI
Role.all.each do |role|
  set = ai_topic_1.statement_sets.create(role: role)

  s = set.statements.create(style: 'single_choice', text: 'Wie bewerten Sie einen solchen Service (kein Fahrplan; angekündigte Wartezeit; Möglichkeit, zwischen warten und sofort fahren (mit Aufpreis) zu wählen)?')
  s.choices.create(text: 'Sehr schlecht')
  s.choices.create(text: 'Eher schlecht')
  s.choices.create(text: 'Eher gut')
  s.choices.create(text: 'Sehr gut')

  s = set.statements.create(style: 'single_choice', text: 'Wie hoch ist Ihr Vertrauen in die Zuverlässigkeit von Anwendungen, die mit künstlicher Intelligenz arbeiten?')
  s.choices.create(text: 'Sehr gering')
  s.choices.create(text: 'Eher gering')
  s.choices.create(text: 'Eher hoch')
  s.choices.create(text: 'Sehr hoch')

  if role == role_1
    s = set.statements.create(style: 'single_choice', text: 'Stellen Sie sich vor, Sie befinden sich in einer Stadt und möchten eine Fahrt im autonomen Shuttle buchen. Welche der folgenden Möglichkeiten würden Sie am ehesten wählen?')
    s.choices.create(text: 'Wartezeit: 10 Minuten; Preis für die Fahrt: 2 €')
    s.choices.create(text: 'Wartezeit: keine; Preis für die Fahrt: 3 €')

    s = set.statements.create(style: 'single_choice', text: 'Stellen Sie sich vor, Sie befinden sich im ländlichen Raum und möchten eine Fahrt im autonomen Shuttle buchen. Welche der folgenden Möglichkeiten würden Sie am ehesten wählen?')
    s.choices.create(text: 'Wartezeit: 30 Minuten; Preis für die Fahrt: 3 €')
    s.choices.create(text: 'Wartezeit: keine; Preis für die Fahrt: 9 €')
  end

  if role == role_2
    s = set.statements.create(style: 'single_choice', text: 'Wie bewerten Sie diesen Service für Ihre Region?')
    s.choices.create(text: 'Sehr schlecht')
    s.choices.create(text: 'Eher schlecht')
    s.choices.create(text: 'Eher gut')
    s.choices.create(text: 'Sehr gut')
  end

  if [role_2, role_3].include? role
    s = set.statements.create(style: 'single_choice', text: 'Wie stark werden solche Services Ihre Arbeit in Zukunft verändern?')
    s.choices.create(text: 'Gar nicht stark')
    s.choices.create(text: 'Eher nicht stark')
    s.choices.create(text: 'Eher stark')
    s.choices.create(text: 'Sehr stark')
  end

  if role == role_4
    s = set.statements.create(style: 'single_choice', text: 'Wie stark werden solche Services ihr Mobilitätsangebot in der Zukunft verändern?')
    s.choices.create(text: 'Gar nicht stark')
    s.choices.create(text: 'Eher nicht stark')
    s.choices.create(text: 'Eher stark')
    s.choices.create(text: 'Sehr stark')
  end

  if role == role_5
    s = set.statements.create(style: 'single_choice', text: 'Wir würden Sie eine Anbindung dieses Services an Ihre Infrastruktur bewerten?')
    s.choices.create(text: 'Sehr schlecht')
    s.choices.create(text: 'Eher schlecht')
    s.choices.create(text: 'Eher gut')
    s.choices.create(text: 'Sehr gut')
  end
end

# multimodal privacy
Role.all.each do |role|
  set = multimodal_priv_topic_1.statement_sets.create(role: role)

  s = set.statements.create(style: 'single_choice', text: 'Wie wichtig finden Sie es, dass bei multimodalen Apps das Level der Datensicherheit wählbar ist?')
  s.choices.create(text: 'Gar nicht wichtig')
  s.choices.create(text: 'Weniger wichtig')
  s.choices.create(text: 'Eher wichtig')
  s.choices.create(text: 'Sehr wichtig')

  if role == role_1
    s = set.statements.create(style: 'multiple_choice', text: 'Welche Daten würden Sie für die Nutzung solcher Services bereitstellen?')
    s.choices.create(text: 'Zugriff auf Standort')
    s.choices.create(text: 'Zugriff auf Kalender')
    s.choices.create(text: 'Zugriff auf Kontakte')
    s.choices.create(text: 'Zugriff auf Kamera')
    s.choices.create(text: 'Zugriff auf Dateien')
    s.choices.create(text: 'Hinterlegung von Kontodaten')

    s = set.statements.create(style: 'multiple_choice', text: 'Wenn Sie Informationen zum verwendungszweck der Daten erhalten würden, welche Daten würden Sie für die Nutzung solcher Services bereitstellen?')
    s.choices.create(text: 'Navigation und Öffnen des Fahrzeugs: Zugriff auf Standort')
    s.choices.create(text: 'Erinnerungen, Empfehlungen o.Ä.: Zugriff auf Kalender')
    s.choices.create(text: 'Auswahl hinterlegter Adressen aus dem Adressbuch: Zugriff auf Kontakte')
    s.choices.create(text: 'Authentifizierung und Führerscheinprüfung: Zugriff auf Kamera')
    s.choices.create(text: 'Abspielen persönlicher Lieblingsmusik: Zugriff auf Dateien')
    s.choices.create(text: 'Abrechnung: Hinterlegung von Kontodaten')
  end

  if role == role_2
    s = set.statements.create(style: 'single_choice', text: 'Für wie wichtig halten Sie die Durchsetzung von schärferen Datenschutzrichtlinien?')
    s.choices.create(text: 'Gar nicht wichtig')
    s.choices.create(text: 'Wenig wichtig')
    s.choices.create(text: 'Eher wichtig')
    s.choices.create(text: 'Sehr wichtig')
  end

  if [role_3, role_4, role_5].include? role
    s = set.statements.create(style: 'single_choice', text: 'Bitte geben Sie an, wie wertvvoll Sie die anfallenden Daten (z.B. zurückgelegte Strecken und genutzte Verkehrsmittel, Orte und Wegezwecke, Zeitpunkte der Wege etc.) für Ihre eigene Arbeit finden')
    s.choices.create(text: 'Nicht wertvoll')
    s.choices.create(text: 'Wenig wertvoll')
    s.choices.create(text: 'Ziemlich wertvoll')
    s.choices.create(text: 'Sehr wertvoll')
  end
end

# Data Driven Planning
Role.all.each do |role|
  set = ddp_topic_1.statement_sets.create(role: role)

  s = set.statements.create(style: 'single_choice', text: 'Wie wichtig sind Ihnen interaktive Aufbereitungen verfügbarer Daten zur Illustration oder Kommunikation?')
  s.choices.create(text: 'Gar nicht wichtig')
  s.choices.create(text: 'Eher unwichtig')
  s.choices.create(text: 'Eher wichtig')
  s.choices.create(text: 'Sehr wichtig')

  if role == role_1
    s = set.statements.create(style: 'single_choice', text: 'Würden Sie sich mit Ihrem eigenen Smartphone tracken, um Ihre eigene Mobilität besser zu verstehen? (D.h. Sie erfassen kontinuierlich Ihre eigene Position woraus automatisch Wege, Verkehrsmittel und CO2-Emissionen berechnet werden.)')
    s.choices.create(text: 'Ja')
    s.choices.create(text: 'Nein')
  end

  if role == role_2
    s = set.statements.create(style: 'single_choice', text: 'Wie hilfreich ist die Aufbereitung von mobilitätsrelevanten Daten für Sie um Entscheidungen zu treffen?')
    s.choices.create(text: 'Gar nicht hilfreich')
    s.choices.create(text: 'Eher nicht hilfreich')
    s.choices.create(text: 'Eher hilfreich')
    s.choices.create(text: 'Sehr hilfreich')
  end

  if [role_3, role_4, role_5].include? role
    s = set.statements.create(style: 'single_choice', text: 'Verknüpfen Sie proprietäre und offene Daten für Analysen, um Kundenverhalten besser zu verstehen?')
    s.choices.create(text: 'Ja')
    s.choices.create(text: 'Nein')
  end

  if [role_2, role_3, role_4, role_5].include? role
    s = set.statements.create(style: 'multiple_choice', text: 'Welchen Herausforderungen begegnen Sie auf Ebene der Datenverarbeitung in Ihrer Arbeit mit Daten?')
    s.choices.create(text: 'Unterschiedliche Datenformate')
    s.choices.create(text: 'Fehlende Aktualität der Daten')
    s.choices.create(text: 'Schlechte Datenverfügbarkeit')
    s.choices.create(text: 'Fehlende Methoden zur Datenverarbeitung')
    s.choices.create(text: 'Detaillierungsgrad der Daten')
    s.choices.create(text: 'Fehlende IT-Standards')
  end
 end

# HSA-Exponat
# Topic Nutzer
Role.all.each do |role|
  set = hsa_topic_1.statement_sets.create(role: role)

  s = set.statements.create(style: 'multiple_choice', text: 'Von welchen Gruppen sollten gesammelte Daten bei der Entwicklung solcher Angebote mit einbezogen werden?')
  s.choices.create(text: 'Von Nutzerinnen und Nutzern')
  s.choices.create(text: 'Von Personen aus Politik und Planung')
  s.choices.create(text: 'Von Fahrzeugherstellern und Flottenbetreiberinnen')
  s.choices.create(text: 'Von Mobilitätsdienstanbietern')
  s.choices.create(text: 'Vom Energy and Transport Flow Management')

  s = set.statements.create(style: 'multiple_choice', text: 'Von welchen Gruppen sollte eine Expertenmeinung aus der jeweiligen Perspektive bei der Entwicklung solcher Angebote mit einbezogen werden?')
  s.choices.create(text: 'Von Nutzerinnen und Nutzern')
  s.choices.create(text: 'Von Personen aus Politik und Planung')
  s.choices.create(text: 'Von Fahrzeugherstellern und Flottenbetreiberinnen')
  s.choices.create(text: 'Von Mobilitätsdienstanbietern')
  s.choices.create(text: 'Von Personen aus dem Flow Management im Energie- und Verkehrsbereich')

  s = set.statements.create(style: 'single_choice', text: 'Wie wichtig finden Sie den frühzeitigen Einbezug der Nutzer in die Entwicklung solcher Angebote?')
  s.choices.create(text: 'Gar nicht wichtig')
  s.choices.create(text: 'Eher unwichtig')
  s.choices.create(text: 'Eher wichtig')
  s.choices.create(text: 'Sehr wichtig')

  s = set.statements.create(style: 'single_choice', text: 'Wie wichtig finden Sie den frühzeitigen Einbezug von Personen aus Politik und Planung in die Entwicklung solcher Angebote?')
  s.choices.create(text: 'Gar nicht wichtig')
  s.choices.create(text: 'Eher unwichtig')
  s.choices.create(text: 'Eher wichtig')
  s.choices.create(text: 'Sehr wichtig')

  s = set.statements.create(style: 'single_choice', text: 'Wie wichtig finden Sie den frühzeitigen Einbezug von Fahrzeugherstellern und Flottenbetreiberinnen in die Entwicklung solcher Angebote?')
  s.choices.create(text: 'Gar nicht wichtig')
  s.choices.create(text: 'Eher unwichtig')
  s.choices.create(text: 'Eher wichtig')
  s.choices.create(text: 'Sehr wichtig')

  s = set.statements.create(style: 'single_choice', text: 'Wie wichtig finden Sie den frühzeitigen Einbezug von Mobilitätsdienstanbietern in die Entwicklung solcher Angebote?')
  s.choices.create(text: 'Gar nicht wichtig')
  s.choices.create(text: 'Eher unwichtig')
  s.choices.create(text: 'Eher wichtig')
  s.choices.create(text: 'Sehr wichtig')

  s = set.statements.create(style: 'single_choice', text: 'Wie wichtig finden Sie den frühzeitigen Einbezug von Personen aus dem Flow Management im Energie- und Verkehrsbereich in die Entwicklung solcher Angebote?')
  s.choices.create(text: 'Gar nicht wichtig')
  s.choices.create(text: 'Eher unwichtig')
  s.choices.create(text: 'Eher wichtig')
  s.choices.create(text: 'Sehr wichtig')

 end

 # Topic Politik und Planung
Role.all.each do |role|
  set = hsa_topic_2.statement_sets.create(role: role)

  s = set.statements.create(style: 'multiple_choice', text: 'Von welchen Gruppen sollten gesammelte Daten bei der Entwicklung solcher Angebote mit einbezogen werden?')
  s.choices.create(text: 'Von Nutzerinnen und Nutzern')
  s.choices.create(text: 'Von Personen aus Politik und Planung')
  s.choices.create(text: 'Von Fahrzeugherstellern und Flottenbetreiberinnen')
  s.choices.create(text: 'Von Mobilitätsdienstanbietern')
  s.choices.create(text: 'Vom Energy and Transport Flow Management')

  s = set.statements.create(style: 'multiple_choice', text: 'Von welchen Gruppen sollte eine Expertenmeinung aus der jeweiligen Perspektive bei der Entwicklung solcher Angebote mit einbezogen werden?')
  s.choices.create(text: 'Von Nutzerinnen und Nutzern')
  s.choices.create(text: 'Von Personen aus Politik und Planung')
  s.choices.create(text: 'Von Fahrzeugherstellern und Flottenbetreiberinnen')
  s.choices.create(text: 'Von Mobilitätsdienstanbietern')
  s.choices.create(text: 'Von Personen aus dem Flow Management im Energie- und Verkehrsbereich')

  s = set.statements.create(style: 'single_choice', text: 'Wie wichtig finden Sie den frühzeitigen Einbezug der Nutzer in die Entwicklung solcher Angebote?')
  s.choices.create(text: 'Gar nicht wichtig')
  s.choices.create(text: 'Eher unwichtig')
  s.choices.create(text: 'Eher wichtig')
  s.choices.create(text: 'Sehr wichtig')

  s = set.statements.create(style: 'single_choice', text: 'Wie wichtig finden Sie den frühzeitigen Einbezug von Personen aus Politik und Planung in die Entwicklung solcher Angebote?')
  s.choices.create(text: 'Gar nicht wichtig')
  s.choices.create(text: 'Eher unwichtig')
  s.choices.create(text: 'Eher wichtig')
  s.choices.create(text: 'Sehr wichtig')

  s = set.statements.create(style: 'single_choice', text: 'Wie wichtig finden Sie den frühzeitigen Einbezug von Fahrzeugherstellern und Flottenbetreiberinnen in die Entwicklung solcher Angebote?')
  s.choices.create(text: 'Gar nicht wichtig')
  s.choices.create(text: 'Eher unwichtig')
  s.choices.create(text: 'Eher wichtig')
  s.choices.create(text: 'Sehr wichtig')

  s = set.statements.create(style: 'single_choice', text: 'Wie wichtig finden Sie den frühzeitigen Einbezug von Mobilitätsdienstanbietern in die Entwicklung solcher Angebote?')
  s.choices.create(text: 'Gar nicht wichtig')
  s.choices.create(text: 'Eher unwichtig')
  s.choices.create(text: 'Eher wichtig')
  s.choices.create(text: 'Sehr wichtig')

  s = set.statements.create(style: 'single_choice', text: 'Wie wichtig finden Sie den frühzeitigen Einbezug von Personen aus dem Flow Management im Energie- und Verkehrsbereich in die Entwicklung solcher Angebote?')
  s.choices.create(text: 'Gar nicht wichtig')
  s.choices.create(text: 'Eher unwichtig')
  s.choices.create(text: 'Eher wichtig')
  s.choices.create(text: 'Sehr wichtig')
 end

 # Topic Fahrzeughersteller
Role.all.each do |role|
  set = hsa_topic_3.statement_sets.create(role: role)

  s = set.statements.create(style: 'multiple_choice', text: 'Von welchen Gruppen sollten gesammelte Daten bei der Entwicklung solcher Angebote mit einbezogen werden?')
  s.choices.create(text: 'Von Nutzerinnen und Nutzern')
  s.choices.create(text: 'Von Personen aus Politik und Planung')
  s.choices.create(text: 'Von Fahrzeugherstellern und Flottenbetreiberinnen')
  s.choices.create(text: 'Von Mobilitätsdienstanbietern')
  s.choices.create(text: 'Vom Energy and Transport Flow Management')

  s = set.statements.create(style: 'multiple_choice', text: 'Von welchen Gruppen sollte eine Expertenmeinung aus der jeweiligen Perspektive bei der Entwicklung solcher Angebote mit einbezogen werden?')
  s.choices.create(text: 'Von Nutzerinnen und Nutzern')
  s.choices.create(text: 'Von Personen aus Politik und Planung')
  s.choices.create(text: 'Von Fahrzeugherstellern und Flottenbetreiberinnen')
  s.choices.create(text: 'Von Mobilitätsdienstanbietern')
  s.choices.create(text: 'Von Personen aus dem Flow Management im Energie- und Verkehrsbereich')

  s = set.statements.create(style: 'single_choice', text: 'Wie wichtig finden Sie den frühzeitigen Einbezug der Nutzer in die Entwicklung solcher Angebote?')
  s.choices.create(text: 'Gar nicht wichtig')
  s.choices.create(text: 'Eher unwichtig')
  s.choices.create(text: 'Eher wichtig')
  s.choices.create(text: 'Sehr wichtig')

  s = set.statements.create(style: 'single_choice', text: 'Wie wichtig finden Sie den frühzeitigen Einbezug von Personen aus Politik und Planung in die Entwicklung solcher Angebote?')
  s.choices.create(text: 'Gar nicht wichtig')
  s.choices.create(text: 'Eher unwichtig')
  s.choices.create(text: 'Eher wichtig')
  s.choices.create(text: 'Sehr wichtig')

  s = set.statements.create(style: 'single_choice', text: 'Wie wichtig finden Sie den frühzeitigen Einbezug von Fahrzeugherstellern und Flottenbetreiberinnen in die Entwicklung solcher Angebote?')
  s.choices.create(text: 'Gar nicht wichtig')
  s.choices.create(text: 'Eher unwichtig')
  s.choices.create(text: 'Eher wichtig')
  s.choices.create(text: 'Sehr wichtig')

  s = set.statements.create(style: 'single_choice', text: 'Wie wichtig finden Sie den frühzeitigen Einbezug von Mobilitätsdienstanbietern in die Entwicklung solcher Angebote?')
  s.choices.create(text: 'Gar nicht wichtig')
  s.choices.create(text: 'Eher unwichtig')
  s.choices.create(text: 'Eher wichtig')
  s.choices.create(text: 'Sehr wichtig')

  s = set.statements.create(style: 'single_choice', text: 'Wie wichtig finden Sie den frühzeitigen Einbezug von Personen aus dem Flow Management im Energie- und Verkehrsbereich in die Entwicklung solcher Angebote?')
  s.choices.create(text: 'Gar nicht wichtig')
  s.choices.create(text: 'Eher unwichtig')
  s.choices.create(text: 'Eher wichtig')
  s.choices.create(text: 'Sehr wichtig')
 end

 # Topic Mobilitätsdienstanbieter
Role.all.each do |role|
  set = hsa_topic_4.statement_sets.create(role: role)

  s = set.statements.create(style: 'multiple_choice', text: 'Von welchen Gruppen sollten gesammelte Daten bei der Entwicklung solcher Angebote mit einbezogen werden?')
  s.choices.create(text: 'Von Nutzerinnen und Nutzern')
  s.choices.create(text: 'Von Personen aus Politik und Planung')
  s.choices.create(text: 'Von Fahrzeugherstellern und Flottenbetreiberinnen')
  s.choices.create(text: 'Von Mobilitätsdienstanbietern')
  s.choices.create(text: 'Vom Energy and Transport Flow Management')

  s = set.statements.create(style: 'multiple_choice', text: 'Von welchen Gruppen sollte eine Expertenmeinung aus der jeweiligen Perspektive bei der Entwicklung solcher Angebote mit einbezogen werden?')
  s.choices.create(text: 'Von Nutzerinnen und Nutzern')
  s.choices.create(text: 'Von Personen aus Politik und Planung')
  s.choices.create(text: 'Von Fahrzeugherstellern und Flottenbetreiberinnen')
  s.choices.create(text: 'Von Mobilitätsdienstanbietern')
  s.choices.create(text: 'Von Personen aus dem Flow Management im Energie- und Verkehrsbereich')

  s = set.statements.create(style: 'single_choice', text: 'Wie wichtig finden Sie den frühzeitigen Einbezug der Nutzer in die Entwicklung solcher Angebote?')
  s.choices.create(text: 'Gar nicht wichtig')
  s.choices.create(text: 'Eher unwichtig')
  s.choices.create(text: 'Eher wichtig')
  s.choices.create(text: 'Sehr wichtig')

  s = set.statements.create(style: 'single_choice', text: 'Wie wichtig finden Sie den frühzeitigen Einbezug von Personen aus Politik und Planung in die Entwicklung solcher Angebote?')
  s.choices.create(text: 'Gar nicht wichtig')
  s.choices.create(text: 'Eher unwichtig')
  s.choices.create(text: 'Eher wichtig')
  s.choices.create(text: 'Sehr wichtig')

  s = set.statements.create(style: 'single_choice', text: 'Wie wichtig finden Sie den frühzeitigen Einbezug von Fahrzeugherstellern und Flottenbetreiberinnen in die Entwicklung solcher Angebote?')
  s.choices.create(text: 'Gar nicht wichtig')
  s.choices.create(text: 'Eher unwichtig')
  s.choices.create(text: 'Eher wichtig')
  s.choices.create(text: 'Sehr wichtig')

  s = set.statements.create(style: 'single_choice', text: 'Wie wichtig finden Sie den frühzeitigen Einbezug von Mobilitätsdienstanbietern in die Entwicklung solcher Angebote?')
  s.choices.create(text: 'Gar nicht wichtig')
  s.choices.create(text: 'Eher unwichtig')
  s.choices.create(text: 'Eher wichtig')
  s.choices.create(text: 'Sehr wichtig')

  s = set.statements.create(style: 'single_choice', text: 'Wie wichtig finden Sie den frühzeitigen Einbezug von Personen aus dem Flow Management im Energie- und Verkehrsbereich in die Entwicklung solcher Angebote?')
  s.choices.create(text: 'Gar nicht wichtig')
  s.choices.create(text: 'Eher unwichtig')
  s.choices.create(text: 'Eher wichtig')
  s.choices.create(text: 'Sehr wichtig')
 end

 # Topic Energie management
Role.all.each do |role|
  set = hsa_topic_5.statement_sets.create(role: role)

  s = set.statements.create(style: 'multiple_choice', text: 'Von welchen Gruppen sollten gesammelte Daten bei der Entwicklung solcher Angebote mit einbezogen werden?')
  s.choices.create(text: 'Von Nutzerinnen und Nutzern')
  s.choices.create(text: 'Von Personen aus Politik und Planung')
  s.choices.create(text: 'Von Fahrzeugherstellern und Flottenbetreiberinnen')
  s.choices.create(text: 'Von Mobilitätsdienstanbietern')
  s.choices.create(text: 'Vom Energy and Transport Flow Management')

  s = set.statements.create(style: 'multiple_choice', text: 'Von welchen Gruppen sollte eine Expertenmeinung aus der jeweiligen Perspektive bei der Entwicklung solcher Angebote mit einbezogen werden?')
  s.choices.create(text: 'Von Nutzerinnen und Nutzern')
  s.choices.create(text: 'Von Personen aus Politik und Planung')
  s.choices.create(text: 'Von Fahrzeugherstellern und Flottenbetreiberinnen')
  s.choices.create(text: 'Von Mobilitätsdienstanbietern')
  s.choices.create(text: 'Von Personen aus dem Flow Management im Energie- und Verkehrsbereich')

  s = set.statements.create(style: 'single_choice', text: 'Wie wichtig finden Sie den frühzeitigen Einbezug der Nutzer in die Entwicklung solcher Angebote?')
  s.choices.create(text: 'Gar nicht wichtig')
  s.choices.create(text: 'Eher unwichtig')
  s.choices.create(text: 'Eher wichtig')
  s.choices.create(text: 'Sehr wichtig')

  s = set.statements.create(style: 'single_choice', text: 'Wie wichtig finden Sie den frühzeitigen Einbezug von Personen aus Politik und Planung in die Entwicklung solcher Angebote?')
  s.choices.create(text: 'Gar nicht wichtig')
  s.choices.create(text: 'Eher unwichtig')
  s.choices.create(text: 'Eher wichtig')
  s.choices.create(text: 'Sehr wichtig')

  s = set.statements.create(style: 'single_choice', text: 'Wie wichtig finden Sie den frühzeitigen Einbezug von Fahrzeugherstellern und Flottenbetreiberinnen in die Entwicklung solcher Angebote?')
  s.choices.create(text: 'Gar nicht wichtig')
  s.choices.create(text: 'Eher unwichtig')
  s.choices.create(text: 'Eher wichtig')
  s.choices.create(text: 'Sehr wichtig')

  s = set.statements.create(style: 'single_choice', text: 'Wie wichtig finden Sie den frühzeitigen Einbezug von Mobilitätsdienstanbietern in die Entwicklung solcher Angebote?')
  s.choices.create(text: 'Gar nicht wichtig')
  s.choices.create(text: 'Eher unwichtig')
  s.choices.create(text: 'Eher wichtig')
  s.choices.create(text: 'Sehr wichtig')

  s = set.statements.create(style: 'single_choice', text: 'Wie wichtig finden Sie den frühzeitigen Einbezug von Personen aus dem Flow Management im Energie- und Verkehrsbereich in die Entwicklung solcher Angebote?')
  s.choices.create(text: 'Gar nicht wichtig')
  s.choices.create(text: 'Eher unwichtig')
  s.choices.create(text: 'Eher wichtig')
  s.choices.create(text: 'Sehr wichtig')
 end
