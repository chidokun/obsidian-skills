# obsidian-skills

A small plugin of [Agent Skills](https://agentskills.io) for turning documents and concepts into well-structured [Obsidian](https://obsidian.md) notes, following [Zettelkasten](https://en.wikipedia.org/wiki/Zettelkasten) principles.

It installs into **Claude Code**, **Cursor**, and any other agent that supports the `SKILL.md` format.

> **Language:** the skills themselves are written in **Vietnamese** — the notes they produce are Vietnamese too. Every skill has an English translation under its `en/` folder, **for reference only** (it is not loaded by agents).

## Skills

| Skill | What it does | English reference |
|---|---|---|
| [`obsidian-doc-to-note`](skills/obsidian-doc-to-note/SKILL.md) | Convert a PDF, web page, article, or raw text into atomic, linked Obsidian notes. `--doc` (default) for ordinary documents, `--book` for multi-chapter books/courses (adds MOCs per chapter). | [en](skills/obsidian-doc-to-note/en/SKILL.md) |
| [`obsidian-explain-to-note`](skills/obsidian-explain-to-note/SKILL.md) | Research a concept or keyword on the web and save it as atomic notes. Depth is controlled with `effort:low\|medium\|high`. | [en](skills/obsidian-explain-to-note/en/SKILL.md) |
| [`obsidian-socratic-learn`](skills/obsidian-socratic-learn/SKILL.md) | Learn a concept interactively with the Socratic method: the agent asks guiding questions, you reason out the answers, and what you worked out is saved as atomic notes. | [en](skills/obsidian-socratic-learn/en/SKILL.md) |
| [`obsidian-feynman-learn`](skills/obsidian-feynman-learn/SKILL.md) | Learn a concept interactively with the Feynman technique: you explain it to a chosen audience (`audience:primary-school\|secondary-school\|university\|same-field`), the agent plays that audience to expose gaps, and your final explanation is saved as atomic notes. | [en](skills/obsidian-feynman-learn/en/SKILL.md) |

### Usage examples

```text
/obsidian-doc-to-note https://example.com/some-article
/obsidian-doc-to-note --book ~/Downloads/atomic-habits.pdf 
/obsidian-explain-to-note CAP theorem
/obsidian-explain-to-note event sourcing effort:medium
/obsidian-socratic-learn CAP theorem
/obsidian-feynman-learn event sourcing
/obsidian-feynman-learn Raft audience:same-field
```

Or just ask in natural language (in Vietnamese), e.g. "lưu bài này thành note", "giải thích Raft thành note", "hỏi tôi về Raft", "để tôi giải thích Raft".

## Second brain template

The skills assume a vault organised as a numbered-folder + Zettelkasten "second brain". The full layout, note conventions, graph coloring and daily workflows are documented in [`docs/Obsidian-Second-Brain-Template.md`](docs/Obsidian-Second-Brain-Template.md) (Vietnamese) with an [English reference translation](docs/en/Obsidian-Second-Brain-Template.md).

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
cp -R obsidian-skills/docs ~/.cursor/docs
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
cp -R obsidian-skills/docs ~/.agents/docs
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
cp -R obsidian-skills/docs .github/docs
```

### Other agents (manual)

Each skill is a folder with a `SKILL.md`. Copy the folders in [`skills/`](skills/) into whatever skills directory your agent reads (for example `.claude/skills/`, `.cursor/skills/`, `.agents/skills/`, `.opencode/skills/`).

The skills link to shared documents in [`docs/`](docs/) with the relative path `../../docs/`, so also copy `docs/` **next to** that skills directory (e.g. `.cursor/skills/` and `.cursor/docs/`, as in the commands above). Skills still work without it, but the links will be broken. The `en/` subfolders are optional and can be deleted.

> Skill directory locations differ between tools and change over time — check your agent's documentation if a path above doesn't work.

## Requirements

- An Obsidian vault reachable from the agent's working directory (the skills search it for `.md` files to link to).
- `obsidian-explain-to-note` and `obsidian-doc-to-note` need web access tools (`WebSearch` / `WebFetch`) for URLs and research.

## Repository layout

```text
.claude-plugin/         Claude Code plugin + marketplace manifests
.cursor-plugin/         Cursor plugin + marketplace manifests
skills/
  <skill-name>/
    SKILL.md            Vietnamese skill (loaded by agents)
    en/SKILL.md         English translation (reference only)
docs/
  Obsidian-Second-Brain-Template.md      Second brain layout and workflows (Vietnamese)
  en/Obsidian-Second-Brain-Template.md   English reference translation
  Zettelkasten-Principles.md             Shared principles linked from the skills (Vietnamese)
  en/Zettelkasten-Principles.md          English reference translation
```

## Contributing

Edit the Vietnamese `SKILL.md` first, then update the matching `en/SKILL.md` so the two stay in sync.

Before publishing a change, bump the plugin version in all manifests at once (installed plugins only update when the version changes):

```bash
scripts/bump-version.sh patch   # or minor | major | X.Y.Z
```

## License

[MIT](LICENSE)
