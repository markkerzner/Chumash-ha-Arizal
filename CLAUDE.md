# Chumash ha-Arizal — working notes for Claude

Weekly parasha study through the Arizal, from a printed edition scanned to PDF.
This file is the method; it carries over from the earlier claude.ai sessions.

## Repository layout

One directory per parasha, matching what is already here:

```
<Parasha>/
  Scans/<Parasha>.pdf   scanned pages of the printed edition
  Notes/<Parasha>.md    sentence-by-sentence study notes (written as we go)
  Slides/NN.md          slide decks; ./gen.sh builds NN.pptx from them
```

Progress lives in a `## Progress` section at the top of each
`<Parasha>/Notes/<Parasha>.md`, not in this file. Update it at the end of every
session: what was covered, where we stopped, what comes next.

## The printed edition

Each book page has Onkelos and Rashi at the top, then `עיקר שפתי חכמים`, then
the Arizal passages under the heading `האריז"ל`, then the editor's footnotes
(marked א, ב, ג...) at the foot of the page. The Arizal passages are drawn from
collections such as ליקוטי תורה, שער הפסוקים, ספר הליקוטים and עץ חיים. The
footnotes give sources and raise difficulties.

## How to study

Sentence by sentence, in the order of the text. For each sentence give:

- the Hebrew,
- an English translation,
- an explanation of the concepts (partzufim, sefirot, mochin, and so on).

End each passage with a short **thread** tying it together, then ask whether to
go on to the next passage. Respond in English, quoting Hebrew as needed.

### Gematria — the hard rule

Give **only** the gematria the Arizal himself states in the passage, and show
the arithmetic, e.g. `חרן = 8+200+50 = 258 = 3 × אלהים`. Do not add gematria,
number associations, or milui values the text does not give, however well known
they are. If the Arizal hints at a numerical match without spelling it out, say
"the text implies" and keep it minimal.

### Sources and additions

- Verses, Talmud and Midrash that the text itself quotes: identify and explain
  them freely.
- Anything brought from outside the passage (Rashi on the verse, for instance)
  must be marked as **context**, never presented as the Arizal's words.
- Summarize a footnote briefly when it raises a difficulty (קושיא / צ"ע).

## Reading the scans

The scans are images. **`pdftotext` on these PDFs returns garbage** — the
embedded font has no usable Unicode mapping, so the output looks like Latin
gibberish. Ignore it; it is not a text layer. Render and read instead:

```bash
pdftoppm -r 300 -png -f <page> -l <page> <Parasha>/Scans/<Parasha>.pdf /tmp/.../p
convert p-01.png -crop 900x1100+1650+100 +repage -sharpen 0x1 crop.png
```

Render to the session scratchpad, never into the repo.

- A 300 dpi letter page is 2550 × 3300. The printed text block sits roughly
  within x 350–2350; the facing page bleeds in at the right edge of the image.
- Hebrew layout: read the **right column first, then the left**. Passages run
  across columns and across pages.
- Full-page renders downscaled to ~1100 px wide are legible enough to find the
  `האריז"ל` section and the column boundaries; crop at full resolution to read
  the small type.
- Check for duplicate pages — in the Vayetze scan, PDF pages 1 and 2 were the
  same book page (שפט).
- A page may begin mid-passage (e.g. "כנודע..."). Say so, and ask for the
  previous page if it matters.

## Slides

`./gen.sh <Parasha>/Slides/NN.md` builds the PowerPoint deck beside the source,
using the Elephant Scale converter at `$ES_HOME/utils/presentations/md2pptx.py`.
`./gen.sh` with no argument rebuilds every deck in the repo. Slide Markdown is
reveal-style: `#` cover/section slide, `##` content slide, `---` between slides,
`*` bullets, trailing `Notes:` block for speaker notes.
