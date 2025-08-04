# Mielialapäiväkirja

Mielialapäiväkirja on Flutterilla toteutettu mobiilisovellus, jonka avulla käyttäjä voi seurata omaa mielialaansa visuaalisessa muodossa. Sovellus mahdollistaa mielialan kirjaamisen päivän mukaan, huomioiden myös mahdolliset lisämuistiinpanot. Tiedot tallennetaan paikallisesti laitteelle, ja ne esitetään viikko- ja kuukausikohtaisina kaavioina.

---

## Ominaisuudet

- Lisää mielialamerkintöjä valitsemalla emoji
- Lisää jokaiselle merkinnälle muistiinpano
- Näe merkinnät viikko- tai kuukausikohtaisina pylväskaavioina
- Kalenterinäkymä valitun päivän merkintöihin
- Poista merkintä kalenterista
- Teeman vaihto (vaalea / tumma)
- Tietojen nollaus
- Tallennus paikallisesti Hive-tietokannan avulla

---

## Käytetyt teknologiat

- Flutter
- Hive – paikallinen tietokanta
- Hive_Flutter – Flutter-integraatio Hiveen
- ThemeProvider – teemanhallinta
- FL_Chart – kaaviot
- table_calendar – kalenteri

---

## Asennus ja käynnistäminen

### 1. Vaatimukset

- Flutter SDK (versio 3.x tai uudempi)
- Dart
- Android Studio / VSCode tai muu Flutter-ympäristö
- Android/iOS-emulaattori tai fyysinen laite

### 2. Asennusvaiheet

```bash
git clone https://github.com/essigranath/mielialapaivakirja
cd mielialapaivakirja
flutter pub get
```

### 3. Varmista että Flutter toimii

```bash
flutter doctor
```

### 4. Käynnistä Android-emulaattori

- Avaa Android Studio
- Avaa More actions > Device Manager
- Luo uusi virtuaalilaite, jos sellaista ei ole.
- Valitse emulaattori ja klikkaa Start.

### 5. Käynnistä sovellus

```bash
flutter run
```