> 🇬🇧 **Reference translation** of [`../SKILL.md`](../SKILL.md) (Vietnamese). The Vietnamese file is the source of truth and the one agents load.
>
> - **name:** `obsidian-explain-to-note`
> - **description:** Explain a specific concept/keyword/request via web search, then turn it into linked atomic Obsidian notes. Use when you want to learn and save a concept as a note, or say "explain X as a note", "look into Y", "take notes about Z" — no source document needed.
> - **allowed-tools:** `Read`, `Write`, `Glob`, `Grep`, `WebSearch`, `WebFetch`, `Bash(find *)`

## Goal

Take a **concept, keyword, or specific request** (no existing document required), search the web to understand it, explain it in your own words, then save it as atomic Obsidian-compatible markdown notes — following Zettelkasten and linking into the existing Vault.

## When to use

- You want to learn a new concept and save it as structured notes
- You have a specific keyword or question but no source document yet
- You want to grow a topic into a network of linked notes

## When NOT to use

- A source document already exists (PDF, URL, file) → use `obsidian-doc-to-note`
- You only need a quick explanation in chat, no note → use `learn`
- Documenting code or writing a changelog

## Input

Parsed from `$ARGUMENTS`:

| Parameter | Description | Default |
|---|---|---|
| **Topic** | A concept, keyword, or specific request | (required) |
| **effort** | Depth level: `low` · `medium` · `high` | `low` |

Examples:
- `CAP theorem`
- `event sourcing effort:medium`
- `explain how Raft reaches consensus effort:high`

If the topic is missing → ask the user before continuing.

## Depth (effort)

### `low` (default)

- Web search **only** for the requested topic
- Create a topic MOC + the atomic notes needed for a basic understanding
- Do not proactively expand into side concepts unless the topic cannot be explained without mentioning them

### `medium`

- Web search for the main topic
- While writing: if a side concept needs an in-depth explanation → **search the web again** and create a separate atomic note for it
- The MOC lists all child notes, including side notes created along the way

### `high`

- **Very in-depth** web search: multiple sources, different viewpoints, edge cases, comparison with related concepts
- Detailed explanations with concrete examples
- Each atomic note (or MOC) may include a **Memory aids** section — analogies, self-check questions, or tips to avoid confusion
- Proactively create side notes for every foundational concept needed to understand the topic

## Zettelkasten principles

Follow the [Zettelkasten principles](../../../docs/en/Zettelkasten-Principles.md): one idea per note (atomic), written in your own words, actively linked with `[[wiki-link]]`s to existing notes in the Vault. In addition, this skill has one principle of its own:

- **Cite sources**: at the end of each note add a `## Nguồn tham khảo` (References) section with the URLs used (do not paste the text).

## Frontmatter defaults

If the `[[Hướng dẫn sử dụng]]` (User guide) file cannot be found in the Vault, use these defaults:
- `type`: `input`
- `status`: `seed`

## Instructions

Explain `$ARGUMENTS` and turn it into notes.

### Step 1 — Determine the topic and effort

- Split the topic and `effort` from the input
- If the topic is ambiguous → ask to clarify the scope before searching

### Step 2 — Web search

- Use **WebSearch** to find reputable sources (official docs, technical articles, Wikipedia)
- Use **WebFetch** to read the 2–4 most relevant sources in detail
- Number of searches by effort:

| effort | Initial searches | Additional searches |
|---|---|---|
| `low` | 1–2 queries | None |
| `medium` | 2–3 queries | Add more when writing reveals a gap |
| `high` | 3–5 queries | Many queries for the main topic + each side concept |

### Step 3 — Plan the note structure

| Topic complexity | Note structure |
|---|---|
| Simple concept, one idea | A single atomic note |
| Concept with several aspects | Topic MOC + atomic notes |
| Broad topic, many related concepts | Topic MOC + atomic notes + (medium/high) side notes |

Name the folder after the main topic (lowercase, no diacritics, short).

### Step 4 — Find links in the Vault

For each important idea/concept, use Grep to find `.md` files in the Vault whose name or content matches the keyword. Only attach a `[[wiki-link]]` when a genuinely related note is found — never link to a note that does not exist.

### Step 5 — Write and save the notes

- Create one folder named after the topic and save all notes into it (flat, no subfolders)
- The user will move it to the right folder after reviewing
- For `effort:high`: add a **Memory aids** section to the MOC or to each atomic note

### Step 6 — Review

- Re-read the MOC (if any) and check that the atomic notes are complete and correct
- Confirm every `[[wiki-link]]` points to an existing note or one created in the same batch
- For `medium`/`high`: check that no important concept is mentioned without a note of its own

### File naming rules

- Use Vietnamese, lowercase, no hyphens or underscores as separators
- Short but meaningful, no special characters `/ \ : * ? " < > |`
- The name reflects the **idea**, not a plain English term (unless it is a widely used proper name)

| Type | Good example | Bad example |
|---|---|---|
| Topic MOC | `CAP theorem` | `cap_theorem_notes` |
| Atomic note | `Hệ thống phân tán chỉ đảm bảo được hai trong ba` (A distributed system can only guarantee two of three) | `note_cap_001` |
| Side note | `Tính nhất quán trong CAP` (Consistency in CAP) | `consistency_chapter` |

### Note-splitting rules

- Follow the Zettelkasten principles
- Definitions, principles, examples, comparisons, memory aids — each may be its own note if long enough
- For `effort:low`: merge lightly if the topic really has only one idea

### Output format

**Topic MOC** — file name: `topic name`

~~~markdown
---
type: input
related: []
status: seed
---

# {{Topic name}}

{{Short description — what this topic is and why it matters}}

## Key ideas

- [[idea name 1]]
- [[idea name 2]]

## Memory aids

{{effort:high only — analogies, self-check questions, or tips to avoid confusion}}

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

{{Content in your own words — one idea only}}

## Ví dụ

{{A concrete example — required for effort:medium and effort:high}}

## Mẹo ghi nhớ

{{effort:high only}}

## Nguồn tham khảo

- [Source name](URL)
~~~

**Single atomic note** (simple topic, no MOC needed) — use the same atomic-note template above; drop the `related` link to the MOC if there is none.

> Note: the section headings inside the templates (`Ví dụ` = Examples, `Mẹo ghi nhớ` = Memory aids, `Nguồn tham khảo` = References) stay in Vietnamese in the real output, because the notes themselves are written in Vietnamese.

## Comparison with related skills

| | `obsidian-doc-to-note` | `obsidian-explain-to-note` | `learn` |
|---|---|---|---|
| Input | An existing document | A concept / keyword | A concept |
| Source | The source document | Web search | Agent knowledge + light web |
| Output | Notes in the Vault | Notes in the Vault | Chat + (optional) note |
| Depth | Follows the document | `effort: low/medium/high` | Interactive Feynman |
