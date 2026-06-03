# Avelan Übersetzer

Ein interaktiver Übersetzer für **Avelan**, eine konstruierte Kunstsprache (Conlang). Übersetzt Deutsch in Avelan mit intelligenter Tempus-Erkennung und morphologischer Analyse.

## 🌐 Features

- **Deutsch → Avelan Übersetzung**: Echtzeit-Konvertierung deutscher Texte in die Kunstsprache Avelan
- **Tempus-Erkennung**: Automatische Erkennung von Vergangenheit, Zukunft und Gegenwart mit visuellen Indikatoren
- **Artikel-Filterung**: Intelligentes Entfernen von deutschen Artikeln (der, die, das, ein, eine, etc.)
- **Tempus-Präfixe**: Automatische Anwendung von Präfixen:
  - `ba-` für Vergangenheit
  - `fi-` für Zukunft
- **Pluralhandling**: Erkennung und Übersetzung von Pluralformen
- **Fuzzy Matching**: Toleranz für Schreibfehler durch Edit-Distance-Algorithmen
- **Beispielsätze**: Vordefinierte Sätze zum Ausprobieren der Übersetzung
- **Dunkles Design**: Modern gestaltete, benutzerfreundliche Oberfläche
- **Tastenkürzel**: `Ctrl + Enter` zum schnellen Übersetzen
- **Wörterzähler**: Live-Zählung von Wörtern in Eingabe und Ausgabe

## 📋 Struktur

### `index.html`
Die Hauptanwendung mit:
- Responsive Benutzeroberfläche
- Zwei-Panel Layout (Eingabe/Ausgabe)
- Zentrale Steuerkontrolle für Übersetzung
- Beispiele und Vokabular-Legende
- Eingebautes JavaScript mit Übersetzungslogik

### `vocab.json`
Die Sprachdatenbank mit:
- **ignore**: Liste von deutschen Artikeln und Funktionswörtern (wird gefiltert)
- **rules**: Konfiguration für:
  - `past_prefix`: `ba-`
  - `future_prefix`: `fi-`
  - `plural_suffix`: `-en`
  - `indicators`: Wörter zur Tempus-Erkennung
- **verbs**: 500+ deutsche Verben mit Avelan-Äquivalenten
- **nouns**: Deutsche Nomen mit Übersetzungen
- **dictionary**: Vollständiges Deutsch→Avelan Wörterbuch

## 🎯 Wie es funktioniert

### Übersetzungsprozess

1. **Tokenisierung**: Text wird in Wort- und Whitespace-Token aufgeteilt
2. **Tempus-Erkennung**: Erste erkannte Tempus-Indikatoren bestimmen den Tempus
3. **Token-Übersetzung** pro Token:
   - Artikel → entfernen (null zurückgeben)
   - Verben → übersetzen + optional Tempus-Präfix
   - Nomen → übersetzen + optional Plural-Suffix
   - Andere Wörter → Wörterbuch-Lookup
4. **Fuzzy Matching**: Bei unbekannten Wörtern werden automatisch ähnliche Wörter gesucht
5. **Ausgabe**: Übersetzte Tokens zusammenfügen, Whitespace normalisieren

### Fuzzy Matching

Das System toleriert Schreibfehler bis zu einer Edit-Distance von 2:
- Edit-Distance 1: Löschen, Transposition, Ersetzen, Einfügen
- Edit-Distance 2: Iterative Anwendung von Edit-Distance 1
- Bevorzugung häufiger Wörter bei mehreren Kandidaten

## 🚀 Verwendung

### Online
Öffnen Sie `index.html` im Browser und beginnen Sie zu tippen.

### Grundworkflow
1. Geben Sie einen deutschen Text in das linke Panel ein
2. Das System erkennt automatisch den Tempus
3. Klicken Sie **„Übersetzen"** oder drücken Sie **Ctrl+Enter**
4. Die Avelan-Übersetzung erscheint im rechten Panel
5. Kopieren Sie mit dem **„Kopieren"**-Button

### Beispiele
Das System enthält vordefinierte Beispiele:
- ✓ Zukunft: *„Ich werde morgen in die Stadt gehen"*
- ✓ Vergangenheit: *„Wir haben gestern das Buch lesen"*
- ✓ Neutral: *„Der Hund ist groß und stark"*

## 🎨 Design

- **Dunkles Theme** mit akzentuierten UI-Elementen
- **Farbkodierung**:
  - 🔴 Rot für Vergangenheit
  - 🔵 Blau für Zukunft
  - ⚪ Grau für neutral
- **Responsive Layout**: Funktioniert auf Desktop und Mobile
- **Glüh-Effekte**: Visuelle Rückmeldung durch CSS-Animationen

## 📝 Sprachregeln (Avelan)

| Deutsch | Avelan | Regel |
|---------|--------|-------|
| haben | hav | Basis-Verb |
| ba-haben | bahav | Vergangenheit |
| fi-haben | fihav | Zukunft |
| Hunde | hund-en | Plural |

### Tempus-Indikatoren
**Vergangenheit**: gestern, früher, damals, war, hatte, wurde
**Zukunft**: morgen, bald, werde, wird, werden, wirst, werdet

## 💻 Technologie

- **HTML5** + **CSS3** (mit CSS-Variablen für Theming)
- **JavaScript ES6+**
- Keine externen Abhängigkeiten
- ~500 KB Vokabular-Datei (komprimierbar)

## 🔧 Technische Highlights

### Set-basierte Lookups
Verbindungen, Artikel und Nomen verwenden `Set` für O(1) Membership-Tests bei großen Listen.

### Phonetische Fehlertoleranz
```javascript
editsOne(word) // Generiert alle 1-Edit-Varianten
