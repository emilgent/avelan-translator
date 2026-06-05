# Vokabular (`vocab.json`)

Die Datei `vocab.json` (~8,7 MB) ist die zentrale Sprachdatenbank des Avelan Übersetzers. Sie enthält alle Wörter, Regeln und Konfigurationsdaten.

## Top-Level-Struktur

```json
{
  "ignore":     [...],    // Artikel / Funktionswörter (gefiltert)
  "names":      [...],    // Eigennamen (nicht übersetzen)
  "rules":      {...},    // Grammatik-Konfiguration
  "verbs":      [...],    // Deutsche Verb-Infinitive
  "nouns":      [...],    // Deutsche Nomen
  "dictionary": {...}     // Vollständiges Deutsch → Avelan Mapping
}
```

## Abschnitte im Detail

### `ignore` (12 Einträge)

Deutsche Artikel und Funktionswörter, die bei der Übersetzung entfernt werden:

```json
["der", "die", "das", "ein", "eine", "den", "dem", "des", "einer", "eines", "einem", "einen"]
```

### `names` (299 Einträge)

Eigennamen, die unverändert in die Übersetzung übernommen werden (z.B. „Anna", „Felix", „Mohammed"). Diese werden **nicht** im Dictionary nachgeschlagen, um Kollisionen mit gleichlautenden Wörtern zu vermeiden.

### `rules`

Grammatik-Konfiguration für morphologische Transformationen:

```json
{
  "past_prefix": "ba-",
  "future_prefix": "fi-",
  "plural_suffix": "-en",
  "indicators": {
    "past": ["gestern", "früher", "damals", "war", "hatte", "wurde"],
    "future": ["morgen", "bald", "werde", "wird", "werden", "wirst", "werdet"]
  }
}
```

| Feld | Beschreibung |
|------|-------------|
| `past_prefix` | Präfix für Vergangenheitsform von Verben |
| `future_prefix` | Präfix für Zukunftsform von Verben |
| `plural_suffix` | Suffix für Pluralformen |
| `indicators.past` | Wörter, die den Satz als Vergangenheit markieren |
| `indicators.future` | Wörter, die den Satz als Zukunft markieren |

### `verbs` (7.815 Einträge)

Liste deutscher Verb-Infinitive. Wird zur Laufzeit in ein `Set` konvertiert, um O(1)-Prüfungen zu ermöglichen. Beispiele:

```
sein, haben, werden, gehen, kommen, machen, sehen, ...
```

Verben erhalten bei der Übersetzung automatisch Tempus-Präfixe (`ba-` / `fi-`).

### `nouns` (52.254 Einträge)

Liste deutscher Nomen. Dient zur Kategorisierung bei der Übersetzung.

### `dictionary` (242.749 Einträge)

Das Haupt-Wörterbuch: ein Key-Value-Mapping von Deutsch zu Avelan.

```json
{
  "ich": "vel",
  "du": "tor",
  "er": "kem",
  "sie": "mira",
  "es": "sel",
  "Haus": "kalor",
  "Hund": "canik",
  "lieben": "amora",
  ...
}
```

**Besonderheiten:**
- Enthält sowohl Grundformen als auch flektierte Formen (z.B. „gehe", „gehst", „geht")
- Großgeschriebene Einträge sind meist Nomen
- Kleingeschriebene Einträge sind Verben, Adjektive, Pronomen etc.
- Pluralformen sind als eigenständige Einträge vorhanden

## Datenvolumen

| Kategorie | Anzahl |
|-----------|--------|
| Ignorierte Wörter | 12 |
| Eigennamen | 299 |
| Verben | 7.815 |
| Nomen | 52.254 |
| Dictionary-Einträge | 242.749 |
| **Dateigröße** | **~8,7 MB** |

## Verwendung zur Laufzeit

Beim Laden der Anwendung (`loadVocab()`) wird `vocab.json` per `fetch` geladen. Anschließend baut `buildIndexes()` folgende Laufzeit-Strukturen auf:

| Struktur | Typ | Zweck |
|----------|-----|-------|
| `verbSet` | `Set` | Schnelle Verb-Erkennung |
| `ignoreSet` | `Set` | Schnelle Artikel-Erkennung |
| `nameSet` | `Set` | Schnelle Namens-Erkennung |
| `lowerToKey` | `Map` | Lowercase → Original-Key (für Fuzzy) |
| `lowerRank` | `Map` | Lowercase → Einfüge-Rang (für Ranking) |
| `reverseDict` | `Map` | Avelan → Deutsche Finite-Form |
| `reverseLemmaDict` | `Map` | Avelan → Deutscher Infinitiv |
