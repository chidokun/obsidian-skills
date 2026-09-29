> 🇬🇧 **Reference translation** of [`../SKILL.md`](../SKILL.md) (Vietnamese). The Vietnamese file is the source of truth and the one agents load.
>
> - **name:** `obsidian-notes`
> - **description:** Write Obsidian notes following a consistent convention (frontmatter, template, links). Use when saving research, decisions, learn notes, or a daily log into the vault.

# Obsidian Notes

## Goal

The agent **writes notes in the correct format** into the vault the user points to.

## Config

Read `config.local.yaml`:

- `obsidian.vault_path`
- `obsidian.notes_folder` (default `Notes`)

If there is no config → ask for the vault path, do not guess.

## Convention

1. Use the templates in the [`templates/`](templates/) folder next to this skill (English copies for reference; the Vietnamese originals live in [`../templates/`](../templates/)):
   - `research.md` · `decision.md` · `learn.md` · `daily.md`
2. Minimum frontmatter:

```yaml
---
title: "…"
date: YYYY-MM-DD
tags: […]
---
```

3. File name: `YYYY-MM-DD-short-slug.md` (ASCII slug).
4. Path: `{vault_path}/{notes_folder}/{kind}/` where `kind` ∈ `research|decisions|learn|daily`.
5. Internal Obsidian links: `[[note-name]]` whenever a related note is known.

## Workflow

1. Determine the note kind + template.
2. Fill in the content from the task result (research / decision / learn).
3. Write the file to the right path (create the folder if missing).
4. Report the full path back to the user.

## Prohibited

- Overwriting a note without asking
- Committing vault content into the repo of the project you are working in
- Putting secrets into a note
