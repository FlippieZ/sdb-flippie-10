<div style='text-align: right;'><a href="/README.md">sdb-flippie-10</a></div>

# Introductie 

Alle objecten in de database **sdb-flippie-10** in het schema **migraine**. 

## Tabellen

#### INBOX
de inhoud van de aangeleverde CSV wordtn opgeslagen in 1 regel in deze tabel

#### REGISTRATIE
voor elke registratie wordt een regel aangemaakt met de diverse kenmerken uitgesplitst

#### INBOX_JSON
de inhoud van een aangeleverd JSON-bestand wordt opgeslagen in 1 regel in deze tabel (gecontroleerd met ISJSON)

#### REGISTRATIE_JSON
voor elke registratie uit de JSON wordt een regel aangemaakt, met dezelfde kolommen als REGISTRATIE plus een sleutel en een verwijzing naar INBOX_JSON

## Views
#### aantalDagDeelPerMaand
gebruikt tabel REGISTRATIE

#### aantallenPerJaar
gebruikt tabel REGISTRATIE

#### aantallenPerMaand
gebruikt de volgende views
* aantalWeekDagPerMaand
* aantalDagDeelPerMaand
* aantalLocatiePerMaand
* aantalMigrainePerMaand
* aantalLichteMigrainePerMaand
* aantalHoofdpijnPerMaand
* aantalTotaalUitvalPerMaand
* aantalTriptaanPerMaand
* aantalRecurrencePerMaand

#### aantallenPerMaandPerJaar
gebruikt tabel REGISTRATIE

#### aantalLichteMigrainePerMaand
gebruikt tabel REGISTRATIE

#### aantalLocatiePerMaand
gebruikt tabel REGISTRATIE

#### aantalMigrainePerMaand
gebruikt tabel REGISTRATIE

###### aantalHoofdpijnPerMaand
gebruikt tabel REGISTRATIE

#### aantalPerDagVanWeek
gebruikt tabel REGISTRATIE

#### aantalRecurrencePerMaand
gebruikt tabel REGISTRATIE

#### aantalSignaalPerMaand
gebruikt tabel REGISTRATIE

#### aantalSignaalVoorAanvalPerMaand
gebruikt tabel REGISTRATIE

#### aantalTotaalUitvalPerMaand
gebruikt de volgende views
* aantalMigrainePerMaand
* aantalLichteMigrainePerMaand
* aantalHoofdpijnPerMaand

#### aantalTriptaanPerMaand
gebruikt tabel REGISTRATIE

#### aantalWeekDagPerMaand
gebruikt tabel REGISTRATIE

###### analyse_per_jaar
gebruikt tabel REGISTRATIE

#### v_aantallen_per_maand
gebruikt tabel REGISTRATIE

#### v_aantallen_per_maand_per_jaar
gebruikt de volgende views
* v_aantallen_per_maand
* v_maanden

#### v_maanden
geeft de Nederlandse maandnamen met maandnummers

## Procedures
####VERWERK_REGISTRATIE
verwerkt de aangeleverde registraties vanuit de tabel INBOX in de tabel REGISTRATIE

na verwerking wordt de verwerkt regel gemarkeerd (verwerkt = 1)

####VERWERK_REGISTRATIES_JSON
verwerkt de nieuwste onverwerkte JSON-export vanuit de tabel INBOX_JSON in de tabel REGISTRATIE_JSON (volledige verversing)

na verwerking worden alle onverwerkte regels gemarkeerd (verwerkt = 1, verwerkt_op = tijdstip)