# Json import
## Beschrijving
Momenteel wordt CSV data opgeslagen in migraine.inbox. Ik wil dat gaan vervangen door Json data.
Ik wil de SQL scripts in de migraine map ongewijzigd laten.
De Json data moet opgeslagen worden in een nieuwe tabel migraine.inbox_json.
De Json data moet verwerkt worden naar een nieuwe tabel migraine.registratie_json.
De verwerking van de Json data naar de nieuwe tabel moet met een stored proc migraine.verwerk_registraties.csv.
## Opdracht
Maak nog nieuwe SQL scripts, maar beschrijf onder '## Plan' wat aangemaakt zou moeten worden.
Welke tabellen met welke kolommen en eventuele indices.
Welke stored procedures.
## Plan

### Uitgangspunten
- Doelplatform is Azure SQL Database (`SqlAzureV12` in het `.sqlproj`), dus `ISJSON` en `OPENJSON` zijn beschikbaar. De helperfuncties `dbo.fnSplitString` en `dbo.fnSEPARATES_COLUMNS` zijn voor JSON niet meer nodig.
- Bestaande objecten in `migraine/` (`inbox`, `registratie`, `verwerk_registratie` en de views) blijven ongewijzigd.
- Formaat volgens het voorbeeldbestand `Registraties.json`: een array op root-niveau met één object per registratie (nieuwste eerst, ca. 1.100 regels):

```json
[
  {
    "Datum": "24-9-2025",
    "Dag": "Wo",
    "Dagdeel": "Nacht",
    "Soort": "Migraine",
    "Signaal": "",
    "Rebound": "Ja",
    "Locatie": "Rechts",
    "Medicate genomen": "Ja",
    "Medicatie": "Sumatriptan injectie",
    "Medicate tijdstip": "03:15"
  }
]
```

- Aandachtspunten uit het voorbeeld:
  - **Veldnamen** beginnen met een hoofdletter en twee bevatten een spatie (`Medicate genomen`, `Medicate tijdstip`, met de typfout "Medicate"). JSON-paden in `OPENJSON` zijn hoofdlettergevoelig, dus de paden moeten exact overeenkomen en de namen met een spatie moeten tussen aanhalingstekens: `'$."Medicate genomen"'`.
  - **Datum** heeft geen voorloopnullen (`d-m-yyyy`, bijvoorbeeld `1-1-2019`). `CONVERT(date, ..., 105)` accepteert dit. Gebruik wel `TRY_CONVERT`, zodat een ongeldige datum als fout wordt herkend in plaats van de hele batch te laten crashen zonder duidelijke melding (zie stap 5).
  - **`Rebound`** is het veld dat in de huidige tabel `recurrence` heet. De kolom blijft `recurrence`, zodat de bestaande views dezelfde kolomnaam hebben.
  - **Lege waarden** komen als `""` binnen (bij `Signaal`, `Medicatie` en `Medicate tijdstip`). Dat gedrag blijft zo, net als bij de CSV-import. De views filteren alleen op gevulde waarden.
  - **Dubbele regels** komen voor (meerdere registraties op dezelfde datum en hetzelfde dagdeel). Er komt dus geen unieke sleutel op de inhoud.
  - Alle waarden passen binnen de huidige kolomlengtes. De langste zijn `Sumatriptan injectie` (20 tekens, kolom 30) en `Locatie onbekend` (16, kolom 20).

- **Naam van de stored procedure:** in de beschrijving staat `migraine.verwerk_registraties.csv`. Een punt in de naam vereist altijd `[...]` en `.csv` past niet bij JSON-verwerking. Voorstel: `migraine.verwerk_registraties_json`. Graag bevestigen.

### Nieuwe bestanden (nog niet aangemaakt)
| Bestand | Object |
|---|---|
| `migraine/Tables/inbox_json.sql` | tabel `migraine.inbox_json` |
| `migraine/Tables/registratie_json.sql` | tabel `migraine.registratie_json` |
| `migraine/StoredProcedures/verwerk_registraties_json.sql` | procedure `migraine.verwerk_registraties_json` |

Daarnaast worden deze drie bestanden als `<Build Include=... />` toegevoegd aan `project-sdb-flippie-10.sqlproj`, en krijgt `migraine/README.MD` een korte beschrijving van de nieuwe objecten. Dit zijn geen SQL-scripts in de migraine-map, dus de bestaande scripts blijven ongewijzigd.

### Tabel `migraine.inbox_json`
Bevat één regel per aangeleverd JSON-bestand. De opzet volgt `migraine.inbox`, aangevuld met een sleutel en een JSON-controle.

| Kolom | Type | Null | Default / constraint | Toelichting |
|---|---|---|---|---|
| `id` | `INT IDENTITY(1,1)` | NOT NULL | `PK_inbox_json` (clustered) | technische sleutel |
| `datum` | `DATETIME2(0)` | NOT NULL | `DF_inbox_json_datum` = `SYSDATETIME()` | moment van aanlevering |
| `omschrijving` | `NVARCHAR(100)` | NULL | | bijvoorbeeld de bestandsnaam uit de blob |
| `registraties` | `NVARCHAR(MAX)` | NOT NULL | `CK_inbox_json_registraties` = `ISJSON(registraties) = 1` | de ruwe JSON |
| `verwerkt` | `BIT` | NOT NULL | `DF_inbox_json_verwerkt` = `0` | 0 = nog verwerken, 1 = verwerkt |
| `verwerkt_op` | `DATETIME2(0)` | NULL | | tijdstip van verwerking |

**Index:** `IX_inbox_json_verwerkt` (non-clustered) op `(verwerkt, datum)` om snel de nieuwste onverwerkte regel te vinden. Gezien het kleine volume is deze index optioneel.

> Het native `JSON`-datatype van Azure SQL wordt nog niet overal ondersteund door SSDT/DacFx. Daarom `NVARCHAR(MAX)` met een `ISJSON`-check.

### Tabel `migraine.registratie_json`
Bevat dezelfde kolommen als `migraine.registratie`, zodat de bestaande views later eenvoudig naar deze tabel kunnen worden omgezet. Er komen een sleutel en een verwijzing naar de bronregel bij.

| Kolom | Type | Null | Toelichting |
|---|---|---|---|
| `id` | `INT IDENTITY(1,1)` | NOT NULL | `PK_registratie_json` (clustered) |
| `inbox_json_id` | `INT` | NOT NULL | FK `FK_registratie_json_inbox_json` naar `migraine.inbox_json(id)` |
| `datum` | `DATE` | NOT NULL | uit `Datum`, geconverteerd met stijl 105 (`d-m-yyyy`) |
| `dag` | `NVARCHAR(2)` | NULL | uit `Dag` |
| `dagdeel` | `NVARCHAR(10)` | NULL | uit `Dagdeel` |
| `soort` | `NVARCHAR(20)` | NULL | uit `Soort` |
| `signaal` | `NVARCHAR(20)` | NULL | uit `Signaal` |
| `recurrence` | `NVARCHAR(5)` | NULL | uit `Rebound` |
| `locatie` | `NVARCHAR(20)` | NULL | uit `Locatie` |
| `medicatie_genomen` | `NVARCHAR(5)` | NULL | uit `Medicate genomen` |
| `medicatie` | `NVARCHAR(30)` | NULL | uit `Medicatie` |
| `medicatie_tijd` | `NVARCHAR(10)` | NULL | uit `Medicate tijdstip` |

**Index:** `IX_registratie_json_datum` (non-clustered) op `(datum)`. Alle views groeperen en filteren op datum (maand en jaar).

### Stored procedure `migraine.verwerk_registraties_json`
Werkt hetzelfde als `migraine.verwerk_registratie`: elke aanlevering is een volledige export, dus de doeltabel wordt telkens volledig ververst.

1. `SET NOCOUNT ON; SET XACT_ABORT ON;`
2. Haal de nieuwste onverwerkte regel op: `SELECT TOP 1 @id = id, @registraties = registraties FROM migraine.inbox_json WHERE verwerkt = 0 ORDER BY datum DESC, id DESC`. Is er niets, dan stopt de procedure.
3. `BEGIN TRANSACTION`
4. `TRUNCATE TABLE migraine.registratie_json`. Dit kan, omdat de foreign key vanuit deze tabel verwijst en niet ernaartoe.
5. Insert de registraties via `OPENJSON`. De paden komen exact overeen met de veldnamen uit het bestand, inclusief hoofdletters, spaties en de typfout "Medicate":
   ```sql
   INSERT INTO migraine.registratie_json (inbox_json_id, datum, dag, dagdeel, soort, signaal,
          recurrence, locatie, medicatie_genomen, medicatie, medicatie_tijd)
   SELECT @id, TRY_CONVERT(date, j.datum, 105), j.dag, j.dagdeel, j.soort, j.signaal,
          j.rebound, j.locatie, j.medicatie_genomen, j.medicatie, j.medicatie_tijd
   FROM OPENJSON(@registraties)
   WITH (
       datum             NVARCHAR(10) '$.Datum',
       dag               NVARCHAR(2)  '$.Dag',
       dagdeel           NVARCHAR(10) '$.Dagdeel',
       soort             NVARCHAR(20) '$.Soort',
       signaal           NVARCHAR(20) '$.Signaal',
       rebound           NVARCHAR(5)  '$.Rebound',
       locatie           NVARCHAR(20) '$.Locatie',
       medicatie_genomen NVARCHAR(5)  '$."Medicate genomen"',
       medicatie         NVARCHAR(30) '$.Medicatie',
       medicatie_tijd    NVARCHAR(10) '$."Medicate tijdstip"'
   ) AS j;
   ```
   Omdat `datum` NOT NULL is, laat een onleesbare datum (`TRY_CONVERT` levert dan `NULL` op) de insert falen. De `CATCH` draait dan alles terug. Wil je liever een duidelijke melding, controleer dan vooraf met een `SELECT` of er rijen zijn waarvoor `TRY_CONVERT(...) IS NULL`, en gebruik `THROW` met het aantal.
   Gebruik zo nodig `'strict $.Datum'` in plaats van `'$.Datum'`: dan faalt de verwerking als het veld ontbreekt, in plaats van stil `NULL` te geven.
6. Markeer **alle** onverwerkte regels als verwerkt (`verwerkt = 1, verwerkt_op = SYSDATETIME()`). Oudere exports zijn achterhaald door de nieuwste. Dit komt overeen met de huidige `UPDATE migraine.inbox SET verwerkt = 1`.
7. `COMMIT`. Foutafhandeling met `BEGIN TRY ... END TRY BEGIN CATCH ... ROLLBACK; THROW; END CATCH`, zodat een onjuiste datum of ongeldige JSON de regel onverwerkt laat.

### Open punten
- Bevestig de naam van de procedure: `verwerk_registraties_json` in plaats van `verwerk_registraties.csv`.
- ~~Voorbeeld-JSON aanleveren~~: ontvangen (`Registraties.json`) en verwerkt in dit plan.
- De veldnamen `Medicate genomen` en `Medicate tijdstip` bevatten een typfout. Wordt dat ooit gecorrigeerd in de bron-app, dan levert de import stil `NULL` op voor die kolommen. Overweeg om ze te lezen als `COALESCE(JSON_VALUE(value, '$."Medicate genomen"'), JSON_VALUE(value, '$."Medicatie genomen"'))`, of om te kiezen voor `strict`-paden zodat het meteen opvalt.
- Wordt de JSON net als nu vanuit blob `MigraineInboxBlob` ingelezen (bijvoorbeeld met `OPENROWSET(BULK 'Registraties.json', DATA_SOURCE = 'MigraineInboxBlob', SINGLE_CLOB)`)? Dan kan een optionele procedure `migraine.laad_inbox_json @bestand` het bestand in `inbox_json` zetten. Let bij UTF-8 op de tekencodering zodra er speciale tekens (zoals é of ë) in de data komen. Het voorbeeld bevat alleen ASCII.
- Moeten de bestaande views later overgezet worden naar `registratie_json`? Dat valt buiten deze opdracht, omdat de migraine-scripts ongewijzigd blijven.