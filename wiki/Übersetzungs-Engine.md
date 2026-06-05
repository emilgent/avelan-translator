# Übersetzungs-Engine

Die Übersetzungs-Engine ist vollständig in JavaScript implementiert und läuft clientseitig im Browser.

## Übersetzungsprozess (Deutsch → Avelan)

### 1. Tokenisierung

Der Eingabetext wird mit einem Regex in Token aufgeteilt:

```javascript
const LETTER_RE = /[a-zA-ZäöüÄÖÜß]+|[^a-zA-ZäöüÄÖÜß]+/g;
```

Jedes Token ist entweder ein Wort (Buchstaben) oder ein Trennzeichen (Leerzeichen, Satzzeichen).

### 2. Tempus-Erkennung

Die Funktion `detectTense()` scannt alle Wörter des Satzes nach Indikator-Wörtern:

| Tempus | Indikatoren |
|--------|------------|
| **Vergangenheit** | gestern, früher, damals, war, hatte, wurde |
| **Zukunft** | morgen, bald, werde, wird, werden, wirst, werdet |
| **Neutral** | (kein Indikator gefunden) |

**Regel:** Der erste Treffer gewinnt – bei gemischten Indikatoren bestimmt der zuerst gefundene das Tempus.

### 3. Token-Übersetzung

Jedes Wort-Token durchläuft folgende Kaskade:

```
① Artikel?         → entfernen (null) + nächstes Whitespace überspringen
①a Eigenname?      → unverändert beibehalten
② Verb-Infinitiv?  → übersetzen + Tempus-Präfix (ba-/fi-)
③ Großgeschrieben + im Dictionary? → Nomen-Übersetzung
④ Lowercase im Dictionary?        → direkte Übersetzung
④a Capitalize-Lookup?             → z.B. "hund" → "Hund" → canik
⑤ Fuzzy Match?    → Tippfehler-Korrektur, dann erneut übersetzen
⑥ Unbekannt       → Original-Token beibehalten
```

### 4. Morphologische Transformation

Verben erhalten je nach Tempus ein Präfix:

| Tempus | Präfix | Beispiel |
|--------|--------|----------|
| Vergangenheit | `ba-` | haben → **ba**hav |
| Zukunft | `fi-` | haben → **fi**hav |
| Neutral | – | haben → hav |

Pluralformen verwenden das Suffix `-en` (z.B. `hund` → `hund-en`).

### 5. Artikel-Filterung

Folgende deutsche Wörter werden entfernt:
> der, die, das, ein, eine, den, dem, des, einer, eines, einem, einen

Nach dem Entfernen eines Artikels wird auch das direkt folgende Whitespace-Token übersprungen, um doppelte Leerzeichen zu vermeiden.

### 6. Namenerkennung

Wörter, die mit einem Großbuchstaben beginnen und in der Namensliste (299 Einträge) vorkommen, werden **nicht** übersetzt. So bleibt „Anna" als „Anna" erhalten, auch wenn es zufällig ein gleichlautendes Wort im Dictionary gibt.

---

## Reverse-Übersetzung (Avelan → Deutsch)

### Reverse-Dictionaries

Beim Laden werden zwei Reverse-Wörterbücher aufgebaut:

| Dictionary | Strategie |
|-----------|-----------|
| `reverseDict` | Bevorzugt 3. Person Singular Präsens (z.B. „ist", „geht") |
| `reverseLemmaDict` | Bevorzugt den Infinitiv (z.B. „sein", „gehen") |

### Präfix-Erkennung

Bei der Rückübersetzung werden `ba-` und `fi-` Präfixe erkannt und entfernt:
- `bahav` → Präfix `ba-` + Lookup `hav` → „haben (Vergangenheit)"
- `fihav` → Präfix `fi-` + Lookup `hav` → „haben (Zukunft)"

Für präfixlose Tokens wird `reverseDict` verwendet (liefert finite Formen), für präfixierte Tokens `reverseLemmaDict` (liefert Infinitive).

---

## Fuzzy Matching (Tippfehler-Toleranz)

### Bedingungen

- Wortlänge: mindestens 4, maximal 18 Zeichen
- Nur Kleinbuchstaben (inkl. ä, ö, ü, ß)
- Nur für Tokens, die nicht großgeschrieben sind (schützt Eigennamen)

### Algorithmus

1. **Edit-Distance 1:** Generiert alle Varianten durch:
   - Deletion (Buchstabe löschen)
   - Transposition (zwei benachbarte Buchstaben vertauschen)
   - Replacement (Buchstabe ersetzen)
   - Insertion (Buchstabe einfügen)

2. **Edit-Distance 2:** Falls kein Treffer bei Distance 1, werden alle Distance-1-Varianten erneut mit Distance 1 expandiert.

3. **Ranking:** Bei mehreren Kandidaten wird bevorzugt:
   - Geringste Längendifferenz zum Original
   - Bei Gleichstand: niedrigster Rang im Dictionary (= häufigeres Wort)

### Alphabet

```javascript
const FUZZY_ALPHABET = 'abcdefghijklmnopqrstuvwxyzäöüß';
```

---

## Performance-Optimierungen

| Optimierung | Beschreibung |
|-------------|-------------|
| **Set-basierte Lookups** | `verbSet`, `ignoreSet`, `nameSet` → O(1) Membership-Tests |
| **Map-basierte Indizes** | `lowerToKey`, `lowerRank` → schneller Fuzzy-Lookup |
| **Einmaliger Index-Aufbau** | Alle Strukturen werden beim Laden einmal erstellt |
| **Kaskadierende Lookups** | Teure Fuzzy-Suche nur als letzter Ausweg |
