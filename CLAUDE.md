# Chumash ha-Arizal — working notes for Claude

Weekly parasha study through the Arizal, from a printed edition scanned to PDF.
This file is the method; it carries over from the earlier claude.ai sessions.

## Repository layout

One directory per parasha, matching what is already here:

```
<Parasha>/
  Notes/<Parasha>.md    sentence-by-sentence study notes (written as we go)
  Slides/NN.md          slide decks; ./gen.sh builds NN.pptx from them
```

The scans are **not** in the repo. They live on Google Drive, and each parasha's
notes carry the link to its PDF in the `## Progress` section. Nothing under
`Scans/` is ever committed — see `## Reading the scans` below.

Reference material that is not tied to a single parasha — editions, the
systematic works, lectures, the buying list — lives in `SOURCES.md` at the repo
root, not in a parasha's notes.

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
- Reference material worth keeping — an edition, a commentary, something to buy
  — goes in root `SOURCES.md`, under a parasha heading when it is tied to one
  passage. Keep the notes themselves about the text.
- Summarize a footnote briefly when it raises a difficulty (קושיא / צ"ע).

## How a session runs

Chavruta style. Mark posts a screenshot of a piece of the page and we discuss it
— back and forth, a piece at a time, not a lecture. Work only from the piece in
front of us; if it starts mid-sentence or mid-passage, say so and ask for what
comes before rather than filling the gap.

Write the notes into `<Parasha>/Notes/<Parasha>.md` as we go, and update that
file's `## Progress` section before the session ends.

## Reading the scans

The scans live on Google Drive, outside this repo; each parasha's notes link to
its PDF. **A Drive link is not something Claude can open** — it needs Mark's
Google session — so do not try to fetch one, and do not treat a link as if the
page behind it had been read.

Mark supplies the images. When we need a page he has not posted, or the columns
around one, ask him for it: a fresh screenshot, or the PDF downloaded to a local
path to render from. Never fill the gap by guessing at what a page says.

Given a local copy, render it rather than extract it. The scans are images, and
**`pdftotext` on these PDFs returns garbage** — the embedded font has no usable
Unicode mapping, so the output looks like Latin gibberish. Ignore it; it is not
a text layer.

```bash
pdftoppm -r 300 -png -f <page> -l <page> <local-path>/<Parasha>.pdf /tmp/.../p
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
