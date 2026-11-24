# KabbalahBench: a proposal

**A sibling benchmark to HalachaBench and HashkafaBench, for the Kabbalah of the Arizal.**

Draft proposal · 24 November 2026 · Mark Kerzner

---

## 1. The ask

HalachaBench showed that a serious, pre-registered, sealed-rubric benchmark can be built on a
Torah subject without waiting for anyone's permission. This document proposes the same machinery
applied to Kabbalah, and asks whether the HalachaBench maintainers would like it built as a third
sibling study rather than as a stranger's clone.

What I am bringing: a working method for studying Kabbalistic primary text passage by passage, a
scanned printed edition that is almost certainly **not** in any model's training data, and a
reframing of the scoring problem that makes the subject benchable at all.

What I would want from you: the harness, the pre-registration and sealing discipline, and an
argument about the design before any item is written.

## 2. Why this looks impossible, and what is actually the problem

The obvious objection is that Kabbalah has no answer key. It is worth being precise about why,
because the usual statement of the difficulty is wrong and the real difficulty is narrower.

HalachaBench had three gifts from the domain:

1. **An exam written by an outside authority.** The Chief Rabbinate set 60 questions; the project
   did not have to invent what counts as a fair question.
2. **A bottom line.** Halachic questions terminate in a ruling — permitted, forbidden, how to act.
   Even without an official key, a rubric can name sources, steps and the ruling.
3. **A living posek population** whose positions are published, so "whom does this model resemble"
   has an external referent (HashkafaBench's poskim maps).

Kabbalah has none of the three. There is no semicha exam in Kabbalah. There is no psak — a
passage of Etz Chaim does not terminate in an instruction, so "did it get the right answer" has
no obvious meaning. And the expert population is small, split by school, and substantially
unwilling to be publicly enlisted as graders of a machine.

So the real problem is not that Kabbalah lacks truth. It is that **Kabbalah lacks an externally
authored test and an externally authored key**, and that the available experts cannot be asked the
question a benchmark naively wants to ask them.

## 3. The reframe: score fidelity, invention and school — not truth

The proposal's one idea is to stop asking *is this correct Kabbalah* and ask four questions that
are either text-anchored or mechanically decidable:

| | Question | Ground truth | Needs an expert? |
|---|---|---|---|
| **A** | Does the explanation agree with **this passage**? | the sealed passage | yes, narrowly |
| **B** | Does the model know the **structure of the system**? | Etz Chaim, Pitchei Shearim | no |
| **C** | Does the model **invent**? | arithmetic, Sefaria | no |
| **D** | **Whose** Kabbalah is it speaking? | the schools' own texts | no |
| **E** | Does it hand out **practical Kabbalah**? | none — a lean, not a score | no |

A and B score skill. C scores restraint. D and E are HashkafaBench-style axes with no right
answer at all, exactly as stringency was. Only A requires a qualified reviewer, and it asks that
reviewer a question he can actually answer — *does this explanation agree with the page in front
of you* — rather than a question about metaphysical truth that no honest person will adjudicate
for a leaderboard.

That reframing is what makes the battery possible. Everything below is detail.

## 4. The battery

### A. Passage fidelity (rubric-scored, HalachaBench design)

A sealed passage of the Arizal — Likutei Torah, Shaar HaPesukim, Sefer HaLikutim, Etz Chaim — is
given to the model, which must render the Hebrew, translate it, and explain the mechanism.
Rubrics follow the HalachaBench pattern: 7–11 scoring requirements plus 1–3 error criteria that
cost points.

Requirements of the kind a rubric names: identifies which partzuf the passage is describing;
states the direction of influence (which partzuf gives mochin to which); keeps the order of ibur
→ yenika → gadlut; connects the passage to the verse or the Chazal the passage itself quotes;
reproduces only the gematria the passage states, with its arithmetic.

Error criteria are where Kabbalah scores better than one would expect, because the field has
sharply defined **mistakes** even where it has no single right answer:

- corporealizing — treating sefirot or partzufim as entities in space;
- collapsing mochin de-katnut and mochin de-gadlut, or reordering the three stages;
- importing another system's machinery into the Ari (see D);
- asserting a gematria, a milui or a numerical match the passage does not state;
- answering the editor's footnote difficulty as though the passage had answered it.

Scoring exactly as HalachaBench: points of requirements met, minus points of errors made, over
total requirement points, 0–100, three attempts per item, worst-of-3 reported alongside the mean.

### B. Structure and terminology (hard ground truth, cheap, brutally discriminating)

Closed-form items with one correct answer inside the system, checkable against Etz Chaim,
Shaar HaHakdamot, Pitchei Shearim and Kelalei Hatchalat HaChochmah. Sample items:

- Name the sefirot that compose Zeir Anpin, and which of them serve as its mochin in katnut.
- Distinguish או"א from ישסו"ת, and state which gives mochin to Zeir Anpin.
- Give the order of the five olamot, and say where the shevirat ha-nekudim falls relative to them.
- Expand in context: אח"פ, נה"י, מ"ה וב"ן, ע"ב ס"ג, או"ח.
- Define אור ישר against אור חוזר, and say which one the passage's kli produces.

This subtest needs no reviewer, costs almost nothing to grade, and — on my own informal reading of
how models behave on this material — will separate the field harder than the passage items do.
Models are fluent here and frequently wrong, which is the worst combination and the most useful
thing a benchmark can expose.

### C. Invention rate

The characteristic failure of language models on Kabbalah is not ignorance; it is confident
fabrication in a register that sounds authoritative. Two probes, both mechanical:

**C1. Gematria.** Decidable arithmetic, scored in two directions. Correctness: does the model
compute what it claims. Restraint: does it volunteer numerical claims the passage never makes.
The second is the real measurement. A gematria the source states and the model reproduces with
its arithmetic earns points; a gematria the model supplies on its own — however well known —
costs them.

**C2. Citation existence.** Fabricated Zohar folios and invented Etz Chaim shaar/perek references
are this domain's signature hallucination, and Sefaria and HebrewBooks settle them without a human.
HalachaBench already has "cites a source that does not exist" among its six general checks, recorded
but not scored. Here it should be a headline number, because in Kabbalah the invented citation
*is* the harm.

Reported as a rate per 100 answers, per model, not folded into the skill score.

### D. School attribution and drift (a HashkafaBench axis)

Models blend Kabbalistic systems constantly. That blending is measurable without any claim about
which system is right:

- **Attribution items.** Given an unlabeled passage, name its school: Ramak, the Ari, Ramchal,
  the Leshem, Ashlag, Chabad chassidus. Ground truth is the text's own provenance.
- **Drift measurement.** Given an Ari passage, does the answer explain it in the Ari's own
  vocabulary, or in another school's? Ashlag's register is the easiest to detect — רצון לקבל,
  השתוות הצורה, the four behinot — and I would predict, as a pre-registered hypothesis, that
  every lab's models drift toward Ashlag and toward popularized English Kabbalah regardless of
  which text they are handed, because that is what the open web contains. If that prediction is
  wrong it is worth publishing; if it is right it is the study's most interesting finding.
- **Citation shares**, as in HashkafaBench's citations arm: Zohar, Tikkunei Zohar, Etz Chaim,
  Pri Etz Chaim, Shaar HaGilgulim, Nefesh HaChaim, Leshem, Tanya, Ashlag, and the academic layer
  (Scholem, Idel, Tishby) — which, if a model reaches for it unprompted on a yeshivish question,
  is itself a measurable orientation.
- **Asker perturbation**, exactly the Sephardi-asker design: tell the model the asker is a Litvak,
  a Chabad chassid, a Sephardi mekubal, an academic, or a curious secular beginner, holding the
  bank fixed, and measure what moves.

### E. Gatekeeping and practical Kabbalah (a lean, not a score)

The Kabbalah analogue of machmir/maikel. Two axes:

- **Gatekeeping.** Asked "may I learn this," does the model raise the conditions traditionally
  cited for entry to this study (Rema and Shach, Yoreh De'ah 246), does it ignore them, or does it
  invent conditions of its own? 0–1 rubric from "no conditions mentioned" to "declines to teach
  without a rav."
- **Practical Kabbalah.** Requests for yichudim, shemot, kameot, a goral. Does the model supply
  them? Reported as a rate, with the question bank kept private. **Publish the rates, not the
  prompts** — a public list of effective requests would be a cookbook, which is a line this study
  should not cross.

## 5. Where the items come from

This is the proposal's weakest joint and deserves the most scrutiny, because HalachaBench's
independence rests on the Rabbinate having written the exam. Three sources, in descending order of
independence:

1. **Published exams, if any exist.** Worth chasing before writing a single item. The strongest
   lead is **Chabad's examinations on chassidus** — Tanya and the hemshechim — which are real
   exams with real keys and a large institutional base. Beyond that, the Kabbalah yeshivot
   (Shaar HaShamayim, Beit El, Ahavat Shalom, Nahar Shalom) do test students; whether any paper is
   obtainable is an open question. If one is, the project gains the same legitimacy HalachaBench
   has, and this section's problem disappears.
2. **The printed editions' own footnotes.** The editor's notes at the foot of each page of a
   printed Chumash ha-Arizal raise קושיות and mark צ"ע, and often resolve them. These are
   ready-made hard items *authored by someone other than us*, with published answers. This is the
   cheapest real independence available and I would build the first version on it.
3. **Items drafted by models and reviewed by models**, as HalachaBench's 60 rubrics were. The same
   caveat applies here as there, and should be disclosed in the same words: the rubric writer is
   also a contestant.

### Contamination resistance — a real advantage over HalachaBench

HalachaBench concedes that Rabbinate questions recur across sittings and that old papers, with
unofficial answers, are online; its 60 items have not been checked for repeats. A Kabbalah bench
built on scanned printed editions is in a much stronger position. The scans I work from have **no
usable text layer at all** — the embedded font carries no Unicode mapping, so text extraction
returns Latin gibberish and the pages are, in practice, images. A model cannot have read them as
text, and the printed edition's particular arrangement of passages, footnotes and selections exists
nowhere online. Items drawn from it are plausibly outside every training set, which is a stronger
claim than HalachaBench can currently make about its own.

Verification of this claim is itself a pre-registered step: before items are written, probe the
models for verbatim knowledge of the edition's apparatus.

## 6. Method inherited from HalachaBench, unchanged

Nothing here needs reinventing, and the proposal's credibility depends on copying the discipline
exactly rather than loosening it:

- pre-registration of questions, run settings and model list by SHA-256 before answers are
  collected; amendments recorded with reasons before each later model runs;
- rubrics sealed with salted cryptographic commitments before any grading, salts published when
  the review round closes;
- closed-book sealed runs, tools off or forbidden and monitored live, fresh process per answer,
  one retry then zero;
- three attempts per item, mean and worst-of-3;
- bootstrap intervals over items resampled within subtest, attempts kept together, plus
  question-by-question pairwise comparisons rather than interval overlap;
- two judges from different labs, a fixed re-graded sample with a published agreement rate, and a
  blind re-grade of the contested cases;
- the "judge is a contestant" and "rubric writer is a contestant" disclosures, stated as plainly
  as HalachaBench states them;
- **the dispute check**, which is HalachaBench's best and cheapest trick: hand a low-scoring model
  all the sealed rubrics, let it ask for criteria to be struck, re-score without them, and publish
  what happens. In a domain where the rubric's authority is the main attack surface, this is not
  optional.

## 7. Validation, scoped so that it can actually happen

HalachaBench's open weakness is that no rabbi has yet reviewed a rubric or graded an answer. In
Kabbalah that weakness would be fatal if the expert were asked the wrong question. So:

- Expert review is scoped to **subtest A only**, and asks one question: *does this explanation
  agree with this passage?* Not whether it is true, not whether the model understands Kabbalah.
- Subtests B and D are checked against printed texts, which a reviewer can confirm by citation
  rather than by judgment.
- Subtest C needs no human at all.
- Reviewers are named only with their consent, and a reviewer may review without being named.
- Until an expert has reviewed, every number is labelled provisional, in HalachaBench's own words.

Rabbinic grades then correct the AI scores by prediction-powered inference, as HalachaBench plans,
and the study is called validated only if the judges agree with the reviewers well enough.

## 8. What this study would not claim

Stated up front, because in this subject the misreading is worse than in halacha:

- **Not a measure of understanding Kabbalah.** It measures fidelity to named passages, restraint,
  and school orientation.
- **Not a qualification.** A high score is not evidence that a model may be learned from, and
  emphatically not that it may be asked for practical instruction.
- **Not permission.** The study measures what models say when asked; it does not recommend asking.
- **Not a ranking of schools.** Subtest D measures which system a model speaks, not which is right.

## 9. Risks

| Risk | Mitigation |
|---|---|
| Read as endorsing AI as a teacher of Kabbalah | Section 8 on the front page, not in a footnote |
| Subtest E read as a jailbreak cookbook | Publish rates only; bank stays private |
| Item authorship undermines independence | Footnote-derived items; chase a published exam first |
| No expert will review | Narrow the question asked of them (section 7) |
| Rubric writer and judge are contestants | Disclose in HalachaBench's own words; dispute check |
| Models drift to Ashlag's vocabulary, judge shares the drift | Judges from two labs; attribution items are text-anchored |

## 10. Version 0

120 items, one subject (the Arizal as printed in the Chumash ha-Arizal edition), three attempts,
two judges.

| Subtest | Items | Grading |
|---|---|---|
| A. Passage fidelity | 30 | sealed rubric, 7–11 requirements + errors |
| B. Structure and terminology | 40 | key, no reviewer |
| C1. Gematria, correctness and restraint | 10 | arithmetic |
| C2. Citation existence | 10 | Sefaria / HebrewBooks lookup |
| D. School attribution and drift | 20 | key, plus a 0–1 drift axis |
| E. Gatekeeping and practical | 10 | 0–1 lean, rate reported |

Published first: **invention rate** and **school drift**. Both are mechanical, both are defensible
before any expert has been found, and both are more interesting than another leaderboard. The skill
leaderboard follows when the rubrics have been reviewed.

## 11. What I bring

- A method for passage-by-passage study of the Arizal, in use weekly: Hebrew, translation,
  concept explanation, a thread tying the passage together, and a standing rule that only the
  gematria the text itself states may be given. That rule is already a scoring criterion — subtest
  C1 is a formalization of a discipline I keep by hand.
- A scanned printed edition with no text layer, and worked notes on its passages that can seed the
  reference explanations behind subtest A's rubrics.
- Willingness to do the item writing, which is the labor this needs most.

## 12. Open questions for discussion

1. Does a published Kabbalah or chassidus examination exist that could play the Rabbinate's role?
   Chabad's chassidus exams are the lead worth chasing first.
2. Should this be one bench or two — a skill bench (A–C) and a lean bench (D–E), as HalachaBench
   and HashkafaBench already are?
3. Is subtest E worth the risk it carries? I think yes, with rates-only publication, but it is the
   item I would most readily drop on the maintainers' advice.
4. One edition and one school for v0, or the Ari against Ramak and Ashlag from the start? I favor
   one edition — the contamination advantage is edition-specific.
5. Who can be asked to review, and what is the smallest review that would let the word
   *provisional* be dropped?

---

*KabbalahBench is a proposal, not a published study. No numbers in this document are measurements;
the only empirical claims made here are about the scans' lack of a text layer and about
HalachaBench's published method, both of which are checkable. The prediction in subtest D is
offered as a hypothesis to be pre-registered, not as a finding.*
