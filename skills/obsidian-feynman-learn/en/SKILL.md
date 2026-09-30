> 🇬🇧 **Reference translation** of [`../SKILL.md`](../SKILL.md) (Vietnamese). The Vietnamese file is the source of truth and the one agents load.
>
> - **name:** `obsidian-feynman-learn`
> - **description:** Learn a concept with the Feynman technique: the user explains it in simple language, the agent plays a curious learner to expose what isn't understood, iterating until the explanation flows, then saves it as linked atomic Obsidian notes. Use when you say "let me explain X", "learn X the Feynman way", "check whether my explanation of X is simple enough".
> - **argument-hint:** `<concept / topic> [audience:primary-school|secondary-school|university|same-field]`
> - **allowed-tools:** `Read`, `Write`, `Glob`, `Grep`, `WebSearch`, `WebFetch`, `Bash(find *)`

## Goal

Help the user **test and consolidate their understanding** of a concept with the Feynman technique: the user explains it as if teaching a specific audience (a primary-school student, a secondary-school student, a university student, or someone in the same field), while the agent plays that audience to expose vague spots, skipped steps, and errors. After a few rounds of refinement, save the user's final explanation as atomic Obsidian-compatible markdown notes — following Zettelkasten and linking into the existing Vault.

## When to use

- You feel you understand a concept but aren't sure you can explain it
- You just finished reading/studying and want to test your understanding before saving notes
- You want notes in your own simple words, with a memorable analogy

## When NOT to use

- You know nothing about the topic and want to be guided step by step → use `obsidian-socratic-learn`
- You just want to read an explanation and save a note → use `obsidian-explain-to-note`
- A source document already exists (PDF, URL, file) → use `obsidian-doc-to-note`
- You only need a quick explanation in chat, no note → use `learn`
- Documenting code or writing a changelog

## Input

Parsed from `$ARGUMENTS`:

| Parameter | Description | Default |
|---|---|---|
| **Topic** | The concept you want to explain | (required) |
| **audience** | Who you explain it to: `primary-school` · `secondary-school` · `university` · `same-field` (someone in your own field) | `secondary-school` |

Examples:
- `CAP theorem`
- `event sourcing audience:primary-school`
- `how Raft reaches consensus audience:same-field`

If the topic is missing → ask the user before continuing. If the topic is too broad → ask to narrow it to a concept that can be explained in a few paragraphs.

Natural-language wording is accepted too (e.g. "for a primary-school kid", "as if explaining to a colleague") and mapped to the matching value. No `audience` → use the default `secondary-school`, without asking. An unrecognized value → ask the user to pick one of the four levels.

## Audience

The level determines **the background the agent assumes** in the audience, the **"simple enough" standard**, and the **kind of questions** the agent asks.

| Value | Audience | Assumed background | "Simple enough" standard |
|---|---|---|---|
| `primary-school` | Primary-school student (about 8–10 years old) | Only everyday life experience; not yet used to algebra or abstract thinking | Short sentences, ordinary words, examples with concrete objects (toys, school, food); no jargon, no symbols |
| `secondary-school` (default) | Secondary-school student (about 12–16 years old) | General maths and science, can follow simple abstract ideas; no specialist knowledge | No specialist jargon (explain it if unavoidable); numbers and everyday examples are fine |
| `university` | University student | The field's common foundations (maths, basic programming, ...) but knows nothing about this topic | Foundational terms are fine; terms specific to the topic must be explained; precise definitions, tight reasoning |
| `same-field` | Someone in the same field (colleague, domain expert) | Knows the field's terminology and foundations; not necessarily deep on this topic | No need to explain basic terms; "simple" means concise, precise, stating conditions of applicability, trade-offs and edge cases |

## Zettelkasten principles

Follow the [Zettelkasten principles](../../../docs/en/Zettelkasten-Principles.md): one idea per note (atomic), written in your own words, actively linked with `[[wiki-link]]`s to existing notes in the Vault. "Your own words" here means **the user's words** from the final explanation round, corrected only when wrong. In addition, this skill has its own principles:

- **The user explains first**: do not explain the topic for the user before they have tried. Explain only when they ask, after at least one attempt.
- **Never write errors into a note**: errors must be corrected during the session and recorded under "Other points" (`Một số vấn đề khác`) as the correct understanding, never as an assertion.
- **Cite sources**: at the end of each note add a `## Nguồn tham khảo` (References) section with the URLs used for verification (do not paste the text).

## Frontmatter defaults

If the `[[Hướng dẫn sử dụng]]` (User guide) file cannot be found in the Vault, use these defaults:
- `type`: `input`
- `status`: `seed`

## Instructions

Guide the user to explain `$ARGUMENTS` themselves, then turn the result into notes. This is a **multi-turn interactive** skill: after each turn, stop and wait for the user. Use the user's language (Vietnamese by default).

### Step 1 — Determine the topic and audience

- Split the topic from the input; ask to clarify if ambiguous or too broad
- Determine `audience` per the **Audience** section (default `secondary-school`); the audience is always imagined as someone **smart but with no knowledge of this topic**, at the foundation level given in the table above
- Tell the user which audience is in use, so they can change it if they want

### Step 2 — Prepare (not shown to the user)

- Check whether the Vault already has related notes; if so, use them.
- Also use **WebSearch** to find reputable sources (official docs, technical articles, Wikipedia) and **WebFetch** to read the 1–3 most relevant in detail. The purpose is for the agent to be the **yardstick for right/wrong**, not to re-teach.
- Quickly list the 3–6 core ideas a complete explanation must touch, plus common misconceptions. Keep it internal.

### Step 3 — The user explains for the first time

Invite the user to explain the topic as if teaching the audience from Step 1, with these ground rules:

- No looking at sources
- Follow the chosen level's standard:
  - `primary-school`, `secondary-school`: avoid jargon; if it's unavoidable, explain that term too
  - `university`: foundational terms are fine; terms specific to the topic must be explained
  - `same-field`: use field terminology freely but precisely; say when it holds and when it doesn't
- It needn't be perfect — the spots where you get stuck are valuable information

Then stop and wait.

### Step 4 — The agent plays a curious learner

Take on the chosen audience's role, using a voice and vocabulary that fit that audience. In this role:

- Ask only sincere questions pitched at the audience's level:

| audience | Kind of question |
|---|---|
| `primary-school` | Naive, keeps asking "why?": "What's that?", "Why is it like that?", "Is it like something I know?" |
| `secondary-school` | Curious, asks for examples: "What does X mean?", "How did we get from this part to that part?", "Can you give me an example?" |
| `university` | Demands rigor: "What's the exact definition of X?", "Why does this step imply the next?", "What if we drop this assumption?" |
| `same-field` | Skeptical and sharp: "When does this not hold?", "How does it differ from Y?", "What's the trade-off?", "What about edge cases?" |

- **Do not** correct errors or add knowledge while in role; **do not** use knowledge the audience couldn't have
- Each turn ask 1–2 questions at the vaguest spot, then wait for the answer
- About 2–4 turns are enough to expose the main gaps

**Keep internal notes** of the types of gaps:

| Type | Sign |
|---|---|
| Unexplained jargon | Uses terms beyond the audience's background as if everyone knew them (does not apply to terms in `same-field`'s shared foundation) |
| Skipped step | A conclusion with no reason leading to it |
| Circular | The definition uses the very word being defined |
| Vague | Speaks generally with no concrete example |
| Missing conditions | Doesn't say when it holds and when it doesn't, or what the trade-offs are (most important for `university` and `same-field`) |
| Wrong | Contradicts the verified source |
| Missing core idea | Skips one idea from the Step 2 list |

### Step 5 — Gap report

Step out of the role and say explicitly that you have. Present briefly and specifically:

- ✅ **Explained well**: clear, correct spots (be specific)
- ⚠️ **Jargon / vague spots** to clarify
- ❓ **Skipped steps** to fill in
- ❌ **Errors**, with a short correct understanding based on the source
- 🧩 **Missing core ideas** (if any)

List no more than 5 items to fix per round — pick the highest-impact ones. Then ask the user to choose: **try fixing it themselves** or **have the agent explain** the missing part. If the agent explains, use analogies and concrete examples, briefly, without re-reading the whole topic.

### Step 6 — Re-explain (loop)

Invite the user to re-explain the fixed part, or the whole thing, **more simply**. Go back to Steps 4–5 if significant gaps remain.

- At most about 3 rounds. If they are still stuck, suggest studying more (recommend `obsidian-socratic-learn` or `obsidian-explain-to-note`) and coming back later, and record the correct understanding of the remaining sticking points under **Other points** (`Một số vấn đề khác`)
- Stop as soon as the user explains it fluently and correctly; don't drag on

### Step 7 — Wrap up

Ask the user to write:

1. A **one-sentence summary** of the concept
2. **One analogy** with something familiar to the chosen audience (toys and school for `primary-school`; everyday life for `secondary-school`; the field's foundational concepts for `university`) (not needed if the user already seems to understand the concept well)

For `same-field`, an analogy is optional: replace it with **a real-world example** or **a comparison with a neighboring concept** (how they differ, when to pick which).

If the user can't think of one, offer 2–3 suggestions to pick from or adapt. Check that it doesn't lead to a misunderstanding (point out where the analogy or comparison stops being accurate, if it does).

### Step 8 — Find links in the Vault

For each important idea, use Grep to find `.md` files in the Vault whose name or content matches the keyword. Only attach a `[[wiki-link]]` when a genuinely related note is found — never link to a note that does not exist.

### Step 9 — Write and save the notes

- Ask the user whether they want to save the note; if not, skip and finish.
- The note content is **the user's final explanation** (the latest round), corrected only for accuracy and brevity; do not replace it with the agent's own explanation
- Small concept, one idea → one atomic note, no folder, just save the note
- Concept with several ideas → one atomic note per idea; with 3 or more notes, create a topic MOC and one folder named after the topic (lowercase, no diacritics, short), saving all notes into it (flat, no subfolders)
- The user will move it to the right folder after reviewing
- The **Other points** (`Một số vấn đề khác`) section records the correct understanding for some of the gaps exposed during the session (for review)

### Step 10 — Review

- Re-read the notes: no false statements, one idea per note, no jargon beyond the chosen audience's background left unexplained
- Confirm every `[[wiki-link]]` points to an existing note or one created in the same batch
- Tell the user the list of notes created and their paths

### File naming rules

- Use Vietnamese, lowercase, no hyphens or underscores as separators
- Short but meaningful, no special characters `/ \ : * ? " < > |`
- The name reflects the **idea**, not a plain English term (unless it is a widely used proper name)

| Type | Good example | Bad example |
|---|---|---|
| Topic MOC | `CAP theorem` | `cap_theorem_notes` |
| Atomic note | `Hệ thống phân tán chỉ đảm bảo được hai trong ba` (A distributed system can only guarantee two of three) | `note_cap_001` |

### Output format

**Topic MOC** (only with 3 or more atomic notes) — file name: `topic name`

~~~markdown
---
type: input
related: []
status: seed
---

# {{Topic name}}

{{The user's one-sentence summary}}

## Các ý chính

- [[idea name 1]]
- [[idea name 2]]

## Nguồn tham khảo

- [Source name](URL)
~~~

**Atomic note** — file name: `short title expressing one idea`

~~~markdown
---
type: input
related:
  - "[[topic MOC]]"
  - "[[other related note]]"
status: seed
---

# {{Short title}}

> {{One-sentence summary}}

*Explained for: {{the chosen audience, e.g. secondary-school student}}*

{{Explanation in the user's words at the chosen audience's level — one idea only}}

## Liên tưởng

{{The analogy chosen by the user, with where it stops being accurate, if applicable. For `same-field`: rename the section to `## Ví dụ và so sánh`}}

## Một số vấn đề khác

- {{The correct understanding for some of the gaps exposed during the session}}

## Nguồn tham khảo

- [Source name](URL)
~~~

If there is only one note, drop the `related` link to the MOC.

> Note: the section headings inside the templates (`Các ý chính` = Key ideas, `Giải thích cho` = Explained for, `Liên tưởng` = Associations (the analogy), `Ví dụ và so sánh` = Examples and comparisons, `Một số vấn đề khác` = Other points, `Nguồn tham khảo` = References) stay in Vietnamese in the real output, because the notes themselves are written in Vietnamese.

## Comparison with related skills

| | `obsidian-feynman-learn` | `obsidian-socratic-learn` | `obsidian-explain-to-note` |
|---|---|---|---|
| Who talks more | User explains, agent asks naive questions | Agent asks, user answers | Agent explains |
| Best for | Feels they understand, wants to test it | Knows nothing or only vaguely, wants to reason it out | Needs knowledge quickly |
| Note source | The user's explanation | The user's answers | Web search |
| Interaction | Multi-turn | Multi-turn | None |
