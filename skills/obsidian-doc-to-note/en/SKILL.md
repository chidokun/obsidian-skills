> 🇬🇧 **Reference translation** of [`../SKILL.md`](../SKILL.md) (Vietnamese). The Vietnamese file is the source of truth and the one agents load.
>
> - **name:** `obsidian-doc-to-note`
> - **description:** Convert documents (PDF, web pages, articles, plain text) into structured Obsidian notes. Use when the user wants to save a document as a note, create notes from a URL, file, or given text, or says "save as note", "create a note", "summarize this document". The `--book` flag is for multi-chapter books/courses, `--doc` (default) for ordinary documents.
> - **argument-hint:** `[--book|--doc] <URL | file path | text>`
> - **allowed-tools:** `Read`, `Write`, `Glob`, `WebFetch`, `Bash(find *)`

## Goal

Convert a document (PDF, web page, article, text) into Obsidian-compatible markdown notes that follow Zettelkasten principles, and save them into the Vault.

## When to use

- You want to save a PDF or web page as notes
- You want to organize a document's content inside your Obsidian Vault
- You want to summarize an article or document into notes

## When NOT to use

- Documenting code.
- Creating a changelog.

## Parameters

Flags may appear anywhere in `$ARGUMENTS`; the rest is the source (a URL, a file path, or text).

| Flag | Meaning | Note structure |
|---|---|---|
| `--doc` (default) | Ordinary document: article, web page, text, short PDF | Atomic notes, no chapter MOCs |
| `--book` | A book (or course) with multiple chapters | Top-level MOC + one MOC per chapter + atomic notes |

- No flag → treated as `--doc`. Never guess that something is a book.
- Both `--book` and `--doc` → ask the user which one to use.

Examples:

- `https://example.com/some-article`
- `--book ~/Downloads/atomic-habits.pdf`
- `--doc notes.txt`

## Zettelkasten principles

Follow the [Zettelkasten principles](../../../docs/en/Zettelkasten-Principles.md): one idea per note (atomic), written in your own words, actively linked with `[[wiki-link]]`s to existing notes in the Vault.

## Frontmatter defaults

If the `[[Hướng dẫn sử dụng]]` (User guide) file cannot be found in the Vault, use these defaults:
- `type`: `input`
- `status`: `seed`

## Instructions

Convert `$ARGUMENTS` (a URL, a file path, or raw text, plus the `--book` or `--doc` flag) into notes.

### Step 1 — Analyze the input

- Split the `--book` / `--doc` flag out of `$ARGUMENTS` (default `--doc`); the rest is the source
- URL → fetch the content with WebFetch
- File path → read it with Read
- Raw text → use it directly

### Step 2 — Choose the note structure from the flag

| Flag | Document type | Note structure |
|---|---|---|
| `--book` | Book / course with multiple chapters | Top-level MOC + one MOC per chapter + atomic notes |
| `--doc` | Single article / web page | Atomic notes (no MOC needed) |
| `--doc` | Short piece of text | A single atomic note |

The flag decides the structure; do not re-guess it from the content. If `--book` is given but no chapters can be identified, ask the user instead of falling back to `--doc`.

### Step 3 — Find links in the Vault

For each important idea/concept in the content, use Grep to find `.md` files in the Vault whose name or content matches that keyword. Only attach a `[[wiki-link]]` when a genuinely related note is found — never link to a note that does not exist.

### Step 4 — Write and save the notes

- If there is only one note, do not create a document folder; just save the note.
- If there are several notes, create one folder named after the document and save all notes into it (flat, no subfolders).
- The user will move it to the right folder after reviewing.

### Step 5 — Review

- Re-read the table of contents and check it against the notes for completeness and correctness.

### File naming rules

- Use Vietnamese, lowercase, no hyphens or underscores as separators
- Short but meaningful, no special characters `/ \ : * ? " < > |`
- The name reflects the **idea**, not the chapter number or position in the document

| Type | Good example | Bad example |
|---|---|---|
| Top-level MOC | `Atomic Habits` | `atomic_habits_book` |
| Chapter MOC | `Atomic Habits - Bản sắc quyết định hành vi` (Identity drives behavior) | `Chương 2` (Chapter 2) |
| Atomic note | `Thay đổi nhỏ tạo ra kết quả lớn` (Small changes produce big results) | `note_001_chapter2_idea` |

### Note-splitting rules

- Follow the Zettelkasten principles.
- Exercises, quizzes, checklists, and recommendations mentioned in the document must be split into their own note and linked from the corresponding chapter MOC.

### Output format

The top-level MOC and chapter MOC are used only with `--book`. With `--doc`, use only the atomic note.

**Top-level MOC** — file name: `name of the book/course/document`

Notes:
- If it is a book: use the `[[Book Highlights]]` template instead
- If it is a course: use the `[[Course Highlights]]` template instead

~~~markdown
---
type: input
related: []
status: seed
tags:
  - {{book or course}}
---

# {{book/course/document title}}

{{Short description of the document}}

## Table of contents

- [[document name - Chương 1|Chapter 1: Chapter name]]
- [[document name - Chương 2|Chapter 2: Chapter name]]
~~~

**Chapter MOC** — file name: `document name - Chapter name`

~~~markdown
---
alias: "{{Chapter name}}"
type: input
related:
  - "[[document name]]"
status: seed
---

# {{Chapter name}}

{{Short description of the chapter}}

## Key ideas

- [[idea name 1]]
- [[idea name 2]]
~~~

**Atomic note** — file name: `short title expressing one idea`

~~~markdown
---
type: input
related:
  - "[[chapter MOC or source document]]"
  - "[[other related note]]"
status: seed
---

# {{Short title}}

{{Content in your own words — one idea only}}
~~~
