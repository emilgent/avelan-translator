# Projektstruktur

Der Avelan Übersetzer besteht aus nur zwei Dateien plus einer README – bewusst minimalistisch gehalten.

## Dateiübersicht

```
avelan-translator/
├── index.html      ← Gesamte Anwendung (HTML + CSS + JS)
├── vocab.json      ← Sprachdatenbank (~8,7 MB)
└── README.md       ← Dokumentation
```

## `index.html` (~ 1027 Zeilen)

Die gesamte Anwendung ist in einer einzigen HTML-Datei gebündelt:

| Bereich | Zeilen (ca.) | Inhalt |
|---------|-------------|--------|
| `<style>` | 1–455 | CSS mit Variablen, Dark Theme, Responsive Layout |
| `<body>` HTML | 457–587 | Struktur: Header, Translator-Grid, Beispiele, Legende, Footer |
| `<script>` | 589–1025 | Gesamte Übersetzungslogik in Vanilla JS |

### Architektur im Script-Block

| Modul | Funktion |
|-------|----------|
| **State & Boot** | `loadVocab()` – Lädt `vocab.json` per `fetch`, baut Indizes auf |
| **Index-Aufbau** | `buildIndexes()` – Erstellt `Set`-Objekte und Reverse-Dictionaries |
| **Fuzzy Engine** | `editsOne()`, `scanMatches()`, `findFuzzy()` – Tippfehler-Korrektur |
| **Tokenizer** | `tokenize()` – Regex-basierte Aufteilung in Wort-/Nicht-Wort-Tokens |
| **Tempus** | `detectTense()` – Scannt nach Indikator-Wörtern |
| **Translation** | `translateToken()`, `translateTokenReverse()` – Kern-Übersetzung |
| **Main** | `translateText()` – Orchestriert den gesamten Übersetzungsprozess |
| **UI** | `swapDirection()`, `clearAll()`, `copyOutput()`, `useExample()` etc. |

## `vocab.json` (~ 8,7 MB)

Die Sprachdatenbank im JSON-Format. Details siehe → [[Vokabular]].

## Datenfluss

```
User-Eingabe
    │
    ▼
tokenize(text)          → Tokens (Wörter + Whitespace)
    │
    ▼
detectTense(text)       → 'past' | 'future' | 'neutral'
    │
    ▼
translateToken(token)   → pro Token: Lookup / Präfix / Fuzzy / Fallback
    │
    ▼
join + trim             → Ausgabe
```

## Keine Build-Pipeline

Das Projekt nutzt bewusst **keine** Build-Tools (kein Webpack, kein npm, kein TypeScript). Alle Logik ist direkt in `index.html` eingebettet. Die Anwendung funktioniert durch einfaches Öffnen der Datei im Browser.
