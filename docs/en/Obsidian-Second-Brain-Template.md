# Second Brain — Structure and Workflows

> 🇬🇧 **Reference translation** of [`../Obsidian-Second-Brain-Template.md`](../Obsidian-Second-Brain-Template.md) (Vietnamese). The Vietnamese file is the source of truth. Folder names, property values, and Vietnamese note names (e.g. `Hướng dẫn sử dụng` = "User guide") are kept as-is because they appear literally in the vault.

## Overview

The second brain is a personal Obsidian vault for storing notes in order to learn, reason, and create knowledge. The Obsidian principle is to avoid folders. However, folders are still needed in some note-taking workflows, so the second brain does contain folders. This folder layout is based on the "[Obsidian Go](https://github.com/thinh-vu/obsidian-go)" configuration, tuned for learning, project work, and self-reflection.

The vault rests on three ideas:

- **Folders only hold special-purpose kinds of notes** (journal, projects, resources, archive). Knowledge is not split by topic into folders; it is connected with `[[wiki-link]]`s and index notes instead.
- **Zettelkasten**: one idea per note (atomic), written in your own words, actively linked to other notes.
- **Properties instead of folders**: `type`, `status`, `related`, `tags` tell you what a note is and how mature it is (see Note conventions below).

Life cycle of a note: **raw idea or source** → `seed` note → reviewed and linked (`bud`) → finished note, ready to be linked to (`evergreen`).

## Obsidian Graph

The graph is a knowledge graph that shows the clusters of knowledge in the second brain. It shows **how notes connect to each other**. Looking at it regularly helps you:

- See the big picture: which topics are dense and which are sparse.
- Spot unlinked notes and broken links before they are forgotten.
- Check whether your Zettelkasten is "alive": are new notes wired into the existing network, or just piling up in isolation?
- Track how mature your knowledge is, using the color by `status` (see the color section below).

### What to look for

| Observation on the graph | Meaning | What to do |
| --- | --- | --- |
| A lone node with no edges (orphan) | The note is not linked to any other note | Add `related` pointing to an index note or a note on the same topic |
| A faded node that is only a link name, not a real file (unresolved) | A `[[link]]` points to a note that does not exist yet, or the name is mistyped | Research the topic and create that note, or fix the link |
| A dense cluster around an index node | The topic already has many ideas | Review, split overly long notes, write a summary note |
| A cluster with no index node | The topic has no "entry point" | Create an index note and connect the cluster's notes to it |
| A cluster with few green (`evergreen`) nodes | The knowledge is still raw | Review, rewrite, promote `status` from `seed` to `bud`, then `evergreen` |
| Two clusters close together but connected by very few edges | Missing cross-topic links | Find what they have in common and add links |
| A node with very many edges | A hub note for a topic | Keep its content short and move details into child notes |

### Coloring the graph

The graph uses color groups (`colorGroups`) declared in `.obsidian/graph.json`. Each group is a property query plus a color. There are two groups, so the colors reflect exactly the `type` and `status` properties from the Note conventions section:

| Order | Query | Color | Meaning |
| --- | --- | --- | --- |
| 1 | `["type":index]` | Red (`#D65C5C`) | Index note: the entry point of a topic |
| 2 | `["status":evergreen]` | Green (`#34A236`) | Finished note, ready to be linked to |
| — | (matches no group) | Default color | Notes still `seed` or `bud`, journal notes, project notes... |

A note that matches several groups takes the color of the group listed first, so a note that is both `index` and `evergreen` is shown in red. Rule of thumb for reading the graph: **red is a topic entry point, green is mature knowledge, everything else is work in progress**.

Other display options in the same file:

- `showOrphans: true`: show orphan notes so you can see them.
- `hideUnresolved: false`: show links whose note does not exist yet, so you can spot broken links.
- `showTags: false`, `showAttachments: false`, `showArrow: false`: hide tags, attachments and arrowheads to reduce clutter, leaving only notes and links.

## Folder structure

Six numbered folders sit next to the to-be-processed area in the vault root; the hidden folders are tool configuration.

```text
<Vault>/
├── 0. JOURNAL/            daily journal (YYYY-MM-DD.md)
├── 1. PROJECT/            one subfolder per project
│   └── <Project name>/
├── 2. RESOURCE/           long-lived knowledge and goals
│   ├── index/             topic index notes
│   ├── template/          note templates
│   └── attachments/       images and attached files
├── 3. ARCHIVED/
│   └── clippings/         clipped web articles
├── 4. VISUAL NOTES/       diagrams, canvas, Excalidraw
├── 5. OPERATION/          documentation for running the vault
├── <Document in progress>/  book/course folder (MOC + atomic notes)
├── <Loose note>.md        note not yet processed
├── .obsidian/             Obsidian configuration and plugins
└── .claude/               skills and config for AI agents (optional)
```

## What each folder is for

| Folder | Contains | Notes |
| --- | --- | --- |
| `0. JOURNAL` | Daily journal, one `YYYY-MM-DD.md` file per day. | Uses the Daily Journal template, `type: journal`, tag `daily`. |
| `1. PROJECT` | Notes per active project, one subfolder each. | Each folder has a central note with the same name (`type: index`, `related: [[Project]]`) holding links to related documents (PRD, wiki), plus separate notes for individual tasks: incident investigations, queries, feature requirements, ideas. |
| `2. RESOURCE` | Long-lived knowledge: concepts, methods, people profiles, personal metrics, yearly goals (OKR). | The largest folder, notes kept flat at its root. Three subfolders: `index/` (topic index notes), `template/`, `attachments/` (the vault's attachment folder). |
| `3. ARCHIVED` | Material not used regularly, kept only so it can be found again. | Mostly `clippings/`: verbatim web clips, tag `clipping`, with the source `url`. |
| `4. VISUAL NOTES` | Visual notes: sketch notes, flowcharts (Excalidraw or Canvas). | Holds only drawing files, not text notes. |
| `5. OPERATION` | Vault operating docs: `README` (the configuration set), `Hướng dẫn sử dụng` (User guide: property and tag rules, working order), `KNOWLEDGE BASE` (root index note). | Very few files; the place to look up how the vault is used. |
| Document folders in the root | One flat folder per book/course/document: a top-level MOC, a MOC per chapter, and atomic notes. | Not finished yet; once processed, move into `2. RESOURCE`. Usually the output of the `obsidian-doc-to-note` and `obsidian-explain-to-note` skills. |
| Loose notes in the root | Newly created notes not yet filed anywhere. | Not finished yet; once processed, move into `2. RESOURCE`. |

### The `2. RESOURCE/index` folder

Each index note is an "entry point" for a life or knowledge topic (for example health, career, productivity, technology). A new note gets a `[[link]]` to at least one index note through the `related` property, so notes on the same topic sit close together on the graph.

### Templates in `2. RESOURCE/template`

Suggested template set: `New Note`, `Index Note`, `Daily Journal`, `Weekly Journal`, `Monthly Journal`, `Life Reflection`, `People profile`, `Book Highlights`, `Course Highlights`.

## Note conventions

Every note starts with frontmatter containing these properties:

| Property | Values | Meaning |
| --- | --- | --- |
| `type` | `index`, `input`, `output`, `journal` | `index`: a MOC or a reference note for one topic. `input`: a note written for learning. `output`: a finished product. `journal`: daily/weekly/monthly journal. |
| `status` | `seed`, `bud`, `evergreen` | `seed`: raw idea, not processed. `bud`: under review and refactoring. `evergreen`: a finished atomic note, ready to be linked to. |
| `related` | list of `[[link]]`s | Notes on the same topic, index notes, or the daily note it was created from. |
| `created` | `YYYY-MM-DD HH:mm` | Creation time. |
| `tags` | list | Quick classification for queries. |
| `url` | list | Reference sources. |

Reference tag catalog: `#idea`, `#daily`, `#weekly`, `#monthly`, `#people`, `#clipping`, `#todo`, `#okr`, `#book`, `#course`.

Naming and splitting conventions:

- **Atomic note**: one idea; the title is a short sentence expressing that idea, not named after a chapter number or a position in the source document.
- **Books, courses**: one top-level MOC, one MOC per chapter (`Document name - Chapter name`), atomic notes below them; exercises, quizzes, and checklists are split into their own notes.
- **Yearly goals**: one note per Key Result, `<year> KR - <name>` (`type: output`, tag `okr`), summarized by a `<year> KR` note and a Dataview query.

## Daily workflows

### 1. Start the day (journal)

1. Open today's note with `Open Today` (Periodic Notes); the plugin creates `0. JOURNAL/YYYY-MM-DD.md` from the Daily Journal template.
2. Under `Project`, list what needs doing as `- [ ]` tasks, linked with `[[link]]` to the related project note.
3. Under `OKR`, write the tasks tied to the yearly goals.
4. At the bottom of the note a Dataview query lists the `#okr` notes that link to the yearly goal note (`[[<year> KR]]`) together with their `status`, for a quick view of progress.

### 2. During the day: quick capture

1. Create a new note with `Cmd + N` (macOS) or `Ctrl + N`.
2. Insert a template (`/Templates: Insert Template`), usually `New Note`.
3. Fill in `related`: today's journal note and at least one index note.
4. Write the idea in your own words with `status: seed`, then add `[[wiki-link]]`s to related notes.
5. Project work notes (bug investigations, queries, requirements) go straight into `1. PROJECT/<project>/` and link back to the project's central note.

### 3. Learn from a document or a new concept

1. With a document (PDF, URL, book, course): run the `obsidian-doc-to-note` skill. With only a concept or keyword: run `obsidian-explain-to-note` (choose `effort:low|medium|high`).
2. The skill creates a flat folder in the vault root with a MOC and atomic notes, `status: seed`, already linked to existing notes.
3. Re-read, digest, rewrite in your own words, set `status` to `bud`, then `evergreen` when finished.
4. When done, move the folder/notes into `2. RESOURCE` and add `related` to an index note.

### 4. Save articles from the web

1. Clip the web page into the vault with the Obsidian plugin for Chrome, adding the `clipping` tag and the source `url`.
2. Put it in `3. ARCHIVED/clippings`.
3. When you need it, pull ideas out into separate atomic notes and link back to the clip.

### 5. End of day and periodic reviews

1. Tick `- [x]` the finished tasks in today's note; leave unfinished work for the next day.
2. At the end of the week / month, use the `Weekly Journal` / `Monthly Journal` templates to look back; `Life Reflection` for longer wrap-ups.
3. Notes that are finished but not used regularly move to `3. ARCHIVED`.

## Supporting tools

**Suggested community plugins**

| Plugin | Used for |
| --- | --- |
| Periodic Notes, Calendar, Full Calendar | Create and browse daily/weekly/monthly journals, view a calendar |
| Natural Language Dates | Type dates in natural language |
| Dataview | Query notes by property/tag (e.g. the OKR progress table in the journal) |
| Obsidian TODO | Text-based task management |
| Mind Map, Charts | Mind maps and charts from notes |
| Icon Folder, Emoji Shortcodes, Editing Toolbar | Display and editing helpers |
| Claudian | Chat with Claude inside the vault |

Besides these, the core plugins: Templates, Canvas, Bases, Backlinks, Graph view, Bookmarks, Properties, Sync.
