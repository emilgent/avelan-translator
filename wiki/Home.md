# Avelan Übersetzer – Wiki

Willkommen im Wiki des **Avelan Übersetzers** – einem interaktiven Browser-Tool zur Übersetzung zwischen Deutsch und der konstruierten Kunstsprache *Avelan*.

## Projektübersicht

Der Avelan Übersetzer ist eine clientseitige Webanwendung ohne externe Abhängigkeiten. Er übersetzt deutschen Text in Echtzeit in die Kunstsprache Avelan und unterstützt auch die umgekehrte Richtung (Avelan → Deutsch).

**Live-Demo:** Öffne einfach `index.html` im Browser – kein Server erforderlich.

## Features

| Feature | Beschreibung |
|---------|-------------|
| **Bidirektionale Übersetzung** | Deutsch → Avelan und Avelan → Deutsch |
| **Tempus-Erkennung** | Automatische Erkennung von Vergangenheit, Zukunft und Gegenwart |
| **Morphologische Präfixe** | `ba-` (Vergangenheit), `fi-` (Zukunft) für Verben |
| **Pluralhandling** | Suffix `-en` für Pluralformen |
| **Fuzzy Matching** | Toleranz für Tippfehler (Edit-Distance bis 2) |
| **Namenerkennung** | Eigennamen werden unverändert übernommen |
| **Artikel-Filterung** | Deutsche Artikel (der, die, das …) werden entfernt |
| **20.000+ Wörter** | Umfangreiches Wörterbuch |
| **Dunkles Design** | Moderne, responsive Benutzeroberfläche |
| **Tastenkürzel** | `Ctrl+Enter` zum Übersetzen |

## Technologie

- HTML5, CSS3 (CSS-Variablen für Theming)
- Vanilla JavaScript (ES6+)
- JSON-basiertes Vokabular
- Keine externen Abhängigkeiten / Kein Build-Prozess

## Wiki-Seiten

- [[Projektstruktur]] – Dateiaufbau und Architektur
- [[Übersetzungs-Engine]] – Tempus-Erkennung, Morphologie, Fuzzy Matching
- [[Vokabular]] – Aufbau der `vocab.json`
- [[Benutzeroberfläche]] – UI, Design und Interaktion

## Schnellstart

```bash
# Repository klonen
git clone https://github.com/emilgent/avelan-translator.git

# index.html im Browser öffnen – fertig!
```

Kein Node.js, kein Build-Schritt, keine Abhängigkeiten.
