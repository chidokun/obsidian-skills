> 🇬🇧 **Reference translation** of [`../SKILL.md`](../SKILL.md) (Vietnamese). The Vietnamese file is the source of truth and the one agents load.
>
> - **name:** `obsidian-socratic-learn`
> - **description:** Learn a concept with the Socratic method: the agent asks guiding questions so the user reasons their way to the answer, then saves what they understood as linked atomic Obsidian notes. Use when you say "quiz me on X", "teach me X the Socratic way", "learn X through questions", "check whether I understand X".
> - **argument-hint:** `<concept / topic>`
> - **allowed-tools:** `Read`, `Write`, `Glob`, `Grep`, `WebSearch`, `WebFetch`, `Bash(find *)`

## Goal

Help the user **understand a concept on their own** through a chain of guiding questions (the Socratic method) instead of being handed an explanation. At the end of the Q&A, save what the user figured out as atomic Obsidian-compatible markdown notes — following Zettelkasten and linking into the existing Vault.

## When to use

- You want to learn a concept deeply by reasoning it out, not by reading a ready-made explanation
- You want to check whether you truly understand something or it just "sounds familiar"
- You want notes that reflect how you actually understand it, with questions to review later

## When NOT to use

- You just want to read an explanation and save a note, without being questioned → use `obsidian-explain-to-note`
- A source document already exists (PDF, URL, file) → use `obsidian-doc-to-note`
- You want to re-explain it in your own words to expose gaps → use `obsidian-feynman-learn`
- You only need a quick explanation in chat, no note → use `learn`
- Documenting code or writing a changelog

## Input

Parsed from `$ARGUMENTS`:

| Parameter | Description | Default |
|---|---|---|
| **Topic** | The concept or topic to learn | (required) |

Examples:
- `CAP theorem`
- `event sourcing`
- `why does Raft need a leader election`

If the topic is missing → ask the user before continuing. If the topic is too broad (e.g. "distributed systems") → ask to narrow it to one aspect before starting.

## Zettelkasten principles

Follow the [Zettelkasten principles](../../../docs/en/Zettelkasten-Principles.md): one idea per note (atomic), written in your own words, actively linked with `[[wiki-link]]`s to existing notes in the Vault. "Your own words" here means **the user's words** — taken from their answers during the Q&A, corrected only when wrong or too vague. In addition, this skill has its own principles:

- **Don't teach before asking**: do not explain the topic before the user has tried to think it through. Explain only after the hint ladder has failed, or when the user asks.
- **Never write errors into a note**: notes contain only knowledge verified against sources. A misunderstanding must be corrected during the session and recorded as "a past misunderstanding", never as an assertion.
- **Cite sources**: at the end of each note add a `## Nguồn tham khảo` (References) section with the URLs used for verification (do not paste the text).

## Frontmatter defaults

If the `[[Hướng dẫn sử dụng]]` (User guide) file cannot be found in the Vault, use these defaults:
- `type`: `input`
- `status`: `seed`

## Instructions

Guide the user through learning `$ARGUMENTS` with questions, then turn the result into notes. This is a **multi-turn interactive** skill: each turn, ask and then stop and wait for the user's answer. Use the user's language (Vietnamese by default).

### Step 1 — Determine the topic

- Split the topic from the input; ask to clarify if ambiguous or too broad

### Step 2 — Prepare (not shown to the user)

- Use **WebSearch** to find reputable sources (official docs, technical articles, Wikipedia) and **WebFetch** to read the 1–3 most relevant in detail. The purpose is for **the agent itself to be correct**, enough to notice when the user is wrong.
- Quickly draft an internal "idea map": 3–6 core ideas and common misconceptions. Keep it internal and **do not reveal it** before the user has reasoned it out.

### Step 3 — Diagnose the starting point

Ask **one** open question to learn where the user is, e.g. "What do you already know about X? If you had to guess, what problem does X solve?". Adjust the difficulty of later questions to the answer. No need to ask about learning goals.

### Step 4 — Q&A loop

Repeat for each core idea in the idea map, from foundational to advanced.

**Rhythm per turn**: one question (at most two tightly related ones), short, then stop and wait.

**Question types** (choose by situation, not mechanically):

| Type | Purpose | Example |
|---|---|---|
| Clarifying | Understand what the user means | "What do you mean by 'consistent' here?" |
| Probing assumptions | Surface what is taken for granted | "You're assuming the network is always reliable, right?" |
| Example / counterexample | Test the boundaries | "Is there a case where that doesn't hold?" |
| Consequences | Reason further | "Then what happens when node A loses connectivity?" |
| Other viewpoints | Broaden | "How would a system that prioritizes speed see this?" |
| Self-summary | Consolidate | "Can you sum this idea up in one sentence?" |

**When the user answers correctly**: confirm briefly and specifically (say exactly what is right, no generic praise), then go deeper or move to the next idea.

**When the user answers wrongly or is stuck**: do **not** state the answer outright. Walk the hint ladder, one rung per turn:

1. Rephrase the question or break it into smaller ones
2. Give a concrete example / counterexample so the user sees the contradiction themselves
3. Hint at one piece of the answer
4. Explain briefly (at most 3–4 sentences), then ask a fresh check question so the user re-expresses it themselves

**When the user says "I don't know", "just tell me", or gets frustrated**: respect it immediately — jump to rung 4, don't push. Still let them re-express it afterwards.

**Keep internal notes** during the Q&A: which ideas the user derived alone, which needed hints, which are still not grasped, and every misconception that surfaced.

**When to stop**: when the core ideas are covered, or the user wants to stop. Typically about 6–12 exchanges. Don't drag on once the user understands.

### Step 5 — Session recap

Present briefly to the user:

- Ideas you worked out yourself
- Ideas that needed hints (worth reviewing)
- Misconceptions that were corrected
- Open questions (if any)

Ideas not firmly grasped go into "open questions"; **do not** create an atomic note asserting them as understood.

### Step 6 — Find links in the Vault

For each important idea, use Grep to find `.md` files in the Vault whose name or content matches the keyword. Only attach a `[[wiki-link]]` when a genuinely related note is found — never link to a note that does not exist.

### Step 7 — Write and save the notes

- Each idea the user came to understand becomes one atomic note; its content is based on the user's answers, corrected for accuracy and clarity
- If there is only 1 note, do not create a folder — just save the note
- If there are several notes (3 or more), create a topic MOC; create one folder named after the topic (lowercase, no diacritics, short) and save all notes into it (flat, no subfolders)
- The user will move it to the right folder after reviewing
- The **Guiding questions** section in each atomic note comes from the questions that actually helped the user understand that idea, for self-testing during later review

### Step 8 — Review

- Re-read the notes: no false statements, one idea per note
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

{{Short description — what this topic is and why it matters}}

## Các ý chính

- [[idea name 1]]
- [[idea name 2]]

## Câu hỏi còn mở

- {{Points not firmly grasped after the Q&A, if any}}

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

{{The idea as the user came to understand it, corrected for accuracy — one idea only}}

## Câu hỏi dẫn dắt

- {{A question that helped the user understand this idea}}

## Chỗ từng hiểu nhầm

{{Only if applicable — the initial misunderstanding and why it was wrong}}

## Nguồn tham khảo

- [Source name](URL)
~~~

If there is only one note, drop the `related` link to the MOC.

> Note: the section headings inside the templates (`Các ý chính` = Key ideas, `Câu hỏi còn mở` = Open questions, `Câu hỏi dẫn dắt` = Guiding questions, `Chỗ từng hiểu nhầm` = Past misunderstandings, `Nguồn tham khảo` = References) stay in Vietnamese in the real output, because the notes themselves are written in Vietnamese.

## Comparison with related skills

| | `obsidian-socratic-learn` | `obsidian-feynman-learn` | `obsidian-explain-to-note` |
|---|---|---|---|
| Who talks more | Agent asks, user answers | User explains, agent asks naive questions | Agent explains |
| Best for | Knows nothing or only vaguely, wants to reason it out | Feels they understand, wants to test it | Needs knowledge quickly |
| Note source | The user's answers | The user's explanation | Web search |
| Interaction | Multi-turn | Multi-turn | None |
