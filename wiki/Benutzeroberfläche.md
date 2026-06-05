# Benutzeroberfläche

Der Avelan Übersetzer verwendet ein modernes, dunkles Design mit responsivem Layout.

## Layout-Aufbau

```
┌─────────────────────────────────────────────────┐
│                   HEADER                         │
│        ● Avelan Übersetzer ●                     │
│   Deutsch → Avelan · Konstruierte Sprache        │
├─────────────────────────────────────────────────┤
│                                                  │
│  ┌─────────┐    ┌──────┐    ┌─────────┐        │
│  │  INPUT   │    │CTRL  │    │ OUTPUT  │        │
│  │  Panel   │    │  ⇄   │    │  Panel  │        │
│  │          │    │  →   │    │         │        │
│  │ Deutsch  │    │ BTN  │    │ Avelan  │        │
│  │          │    │Badge │    │         │        │
│  └─────────┘    └──────┘    └─────────┘        │
│                                                  │
│  ▸ Beispielsätze (Chips)                        │
│  ▸ Kern-Vokabular (Grid)                        │
│                                                  │
├─────────────────────────────────────────────────┤
│                   FOOTER                         │
└─────────────────────────────────────────────────┘
```

## Komponenten

### Header
- Projektname „Avelan Übersetzer" in Akzentfarbe
- Pulsierende Punkte als visueller Indikator
- Untertitel mit Richtung und Wortanzahl

### Translator-Grid (3-Spalten)

| Spalte | Inhalt |
|--------|--------|
| **Links** | Eingabe-Panel (Textarea, Sprachflag, Wörterzähler) |
| **Mitte** | Steuerungsbereich (Swap-Button, Pfeil, Übersetzen-Button, Tempus-Badge, Tastenkürzel-Hinweis) |
| **Rechts** | Ausgabe-Panel (readonly Textarea, Kopieren-Button) |

### Eingabe-Panel
- **Header:** Sprachflag (🇩🇪 / 🌐) + Label + „Leeren"-Button
- **Textarea:** Freitexteingabe mit Placeholder
- **Footer:** Live-Wörterzähler

### Steuerung (Mitte)
- **Swap-Button (⇄):** Wechselt zwischen Deutsch→Avelan und Avelan→Deutsch. Rotiert um 180° beim Hover.
- **Pfeil-Separator (→):** Visuelle Richtungsanzeige
- **Übersetzen-Button:** Hauptaktion, deaktiviert bis Vokabular geladen
- **Tempus-Badge:** Zeigt erkannten Tempus (Neutral / Vergangenheit / Zukunft)
- **Tastaturhinweis:** `Ctrl` + `↵`

### Ausgabe-Panel
- Readonly-Textarea mit Avelan-Übersetzung
- „Kopieren"-Button (nutzt Clipboard API)
- Wörterzähler

### Beispielsätze
Klickbare Chips mit farbkodierten Tags:
- 🔵 **Zukunft** – z.B. „Ich werde morgen in die Stadt gehen"
- 🔴 **Vergangenheit** – z.B. „Wir haben gestern das Buch lesen"
- ⚪ **Neutral** – z.B. „Der Hund ist groß und stark"

Ein Klick füllt die Eingabe und löst sofort die Übersetzung aus.

### Kern-Vokabular (Legende)
Ein Grid zeigt eine Auswahl wichtiger Übersetzungen: ich→vel, du→tor, Haus→kalor, etc.

---

## Design-System

### Farbpalette (CSS-Variablen)

| Variable | Wert | Verwendung |
|----------|------|-----------|
| `--bg` | `#121212` | Seitenhintergrund |
| `--surface` | `#1e1e1e` | Panel-Hintergrund |
| `--surface-alt` | `#252525` | Panel-Header/Footer |
| `--accent` | `#00adb5` | Primärfarbe (Teal) |
| `--accent-hover` | `#00c9d4` | Hover-Zustand |
| `--accent-glow` | `rgba(0,173,181,0.22)` | Glow-Effekte |
| `--past-color` | `#ff6b6b` | Vergangenheit (Rot) |
| `--future-color` | `#5ba4f5` | Zukunft (Blau) |
| `--text` | `#e0e0e0` | Haupttext |
| `--text-muted` | `#999` | Sekundärtext |

### Tempus-Farbkodierung

| Tempus | Farbe | CSS-Klasse |
|--------|-------|-----------|
| Neutral | Grau | `.tense-neutral` |
| Vergangenheit | Rot | `.tense-past` |
| Zukunft | Blau | `.tense-future` |

### Responsive Design

Unter 780px Bildschirmbreite:
- Grid wechselt zu einer Spalte
- Steuerung wird horizontal angeordnet
- Tempus-Badge und Tastatur-Hinweis werden ausgeblendet
- Legende passt sich an (kleinere Min-Width)

---

## Interaktionen

| Aktion | Auslöser | Funktion |
|--------|----------|----------|
| Übersetzen | Klick auf Button / `Ctrl+Enter` | `translateText()` |
| Richtung wechseln | Klick auf ⇄ | `swapDirection()` |
| Eingabe leeren | Klick auf ✕ | `clearAll()` |
| Ausgabe kopieren | Klick auf ⎘ | `copyOutput()` |
| Beispiel verwenden | Klick auf Chip | `useExample()` |
| Wörterzählung | Bei jeder Eingabe | `onInputChange()` |

---

## Toast-Benachrichtigungen

Ein Toast-Element am unteren rechten Rand zeigt kurze Statusmeldungen:
- „✓ In die Zwischenablage kopiert"
- „⚠ Nichts zum Kopieren."
- „⚠ Wörterbuch konnte nicht geladen werden."

Die Benachrichtigung blendet nach 2,6 Sekunden automatisch aus.

---

## Ladevorgang

1. Seite wird geladen → Lade-Balken mit Shimmer-Animation
2. `vocab.json` wird per `fetch` geladen
3. Indizes werden aufgebaut
4. Übersetzen-Button wird aktiviert
5. Lade-Balken verschwindet
6. Kern-Vokabular-Legende wird generiert
