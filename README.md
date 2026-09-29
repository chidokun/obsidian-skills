# obsidian-skills

A small plugin of [Agent Skills](https://agentskills.io) for turning documents and concepts into well-structured [Obsidian](https://obsidian.md) notes, following [Zettelkasten](https://en.wikipedia.org/wiki/Zettelkasten) principles.

It installs into **Claude Code**, **Cursor**, and any other agent that supports the `SKILL.md` format.

> **Language:** the skills themselves are written in **Vietnamese** — the notes they produce are Vietnamese too. Every skill has an English translation under its `en/` folder, **for reference only** (it is not loaded by agents).

## Skills

| Skill | What it does | English reference |
|---|---|---|
| [`obsidian-doc-to-note`](skills/obsidian-doc-to-note/SKILL.md) | Convert a PDF, web page, article, or raw text into atomic, linked Obsidian notes (with MOCs for books/courses). | [en](skills/obsidian-doc-to-note/en/SKILL.md) |
| [`obsidian-explain-to-note`](skills/obsidian-explain-to-note/SKILL.md) | Research a concept or keyword on the web and save it as atomic notes. Depth is controlled with `effort:low\|medium\|high`. | [en](skills/obsidian-explain-to-note/en/SKILL.md) |
| [`obsidian-notes`](skills/obsidian-notes/SKILL.md) | Write research / decision / learn / daily notes with consistent frontmatter, file naming, and templates. | [en](skills/obsidian-notes/en/SKILL.md) |

### Usage examples

```text
/obsidian-doc-to-note https://example.com/some-article
/obsidian-doc-to-note ~/Downloads/atomic-habits.pdf
/obsidian-explain-to-note CAP theorem
/obsidian-explain-to-note event sourcing effort:medium
```

Or just ask in natural language (in Vietnamese), e.g. "lưu bài này thành note", "giải thích Raft thành note".

## Installation

### Claude Code

```bash
claude plugin marketplace add chidokun/obsidian-skills
claude plugin install obsidian-skills@obsidian-skills
```

Or, from inside a Claude Code session:

```text
/plugin marketplace add chidokun/obsidian-skills
/plugin install obsidian-skills@obsidian-skills
```

Skills are then available as `/obsidian-skills:obsidian-doc-to-note`, etc.

### Cursor

Install this repository as a plugin (Cursor reads [`.cursor-plugin/`](.cursor-plugin/plugin.json)), or add it as a Remote Rule:

- **Settings → Rules → Add Rule → Remote Rule (GitHub)** → `https://github.com/chidokun/obsidian-skills`

Or install manually as user-level skills:

```bash
git clone https://github.com/chidokun/obsidian-skills.git
mkdir -p ~/.cursor/skills
cp -R obsidian-skills/skills/* ~/.cursor/skills/
```

### Any agent via the `skills` CLI

The [`skills`](https://github.com/vercel-labs/skills) CLI installs to many agents at once (Claude Code, Cursor, Codex, Gemini CLI, GitHub Copilot, OpenCode, …):

```bash
npx skills add chidokun/obsidian-skills
```

### Codex CLI

```bash
git clone https://github.com/chidokun/obsidian-skills.git
mkdir -p ~/.agents/skills
cp -R obsidian-skills/skills/* ~/.agents/skills/
```

### Gemini CLI

```bash
gemini skills install https://github.com/chidokun/obsidian-skills.git
```

### GitHub Copilot / VS Code

Copy the skill folders into your project's `.github/skills/` (or `~/.copilot/skills/` for user level):

```bash
mkdir -p .github/skills
cp -R obsidian-skills/skills/* .github/skills/
```

### Other agents (manual)

Every skill is a self-contained folder with a `SKILL.md`. Copy the folders in [`skills/`](skills/) into whatever skills directory your agent reads (for example `.claude/skills/`, `.cursor/skills/`, `.agents/skills/`, `.opencode/skills/`). The `en/` subfolders are optional and can be deleted.

> Skill directory locations differ between tools and change over time — check your agent's documentation if a path above doesn't work.

## Requirements

- An Obsidian vault reachable from the agent's working directory (the skills search it for `.md` files to link to).
- `obsidian-explain-to-note` and `obsidian-doc-to-note` need web access tools (`WebSearch` / `WebFetch`) for URLs and research.
- `obsidian-notes` reads `obsidian.vault_path` and `obsidian.notes_folder` from a `config.local.yaml`; if it is missing, the skill asks you for the vault path.

## Repository layout

```text
.claude-plugin/         Claude Code plugin + marketplace manifests
.cursor-plugin/         Cursor plugin + marketplace manifests
skills/
  <skill-name>/
    SKILL.md            Vietnamese skill (loaded by agents)
    en/SKILL.md         English translation (reference only)
  obsidian-notes/
    templates/          Note templates (Vietnamese)
    en/templates/       Note templates (English, reference only)
```

## Contributing

Edit the Vietnamese `SKILL.md` first, then update the matching `en/SKILL.md` so the two stay in sync.

## License

[MIT](LICENSE)
