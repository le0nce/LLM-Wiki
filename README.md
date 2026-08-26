# LLM Wiki

A portable scaffold for Karpathy's [LLM Wiki pattern](https://gist.github.com/karpathy/442a6bf555914893e9891c11519de94f). Copy it into any project, and Claude Code automatically picks up the instructions to build and maintain a persistent knowledge base from your source documents.

## Quick Start

### Install into an existing project

**Windows (PowerShell):**
```powershell
.\install.ps1 -TargetPath C:\path\to\your\project
```

**macOS / Linux:**
```bash
./install.sh /path/to/your/project
```

This creates the wiki structure and drops a `CLAUDE.md` into your project. If one already exists, it appends the wiki instructions.

### Use It

1. Drop documents (markdown, text, PDFs) into `sources/`
2. Open Claude Code in the project
3. Say: *"Read sources/my-paper.md and integrate it into the wiki"*
4. Browse the compiled wiki in `wiki/` — or open it in Obsidian for graph view

### Slash-Style Commands

These are natural-language triggers Claude Code understands from the CLAUDE.md:

| Command | What it does |
|---------|-------------|
| `/wiki ingest` | Process a source and update the wiki |
| `/wiki query <question>` | Answer from compiled wiki pages |
| `/wiki lint` | Health-check: contradictions, orphans, stale pages |
| `/wiki contradictions` | Deep scan for conflicting claims across pages |

See [prompts.md](prompts.md) for ready-to-use prompt templates.

## What Gets Created

```
your-project/
├── CLAUDE.md               # Agent instructions (Claude Code reads this automatically)
├── sources/                # YOUR raw documents — agent never modifies these
│   └── (your files here)
├── wiki/
│   ├── _index/
│   │   ├── index.md        # Content catalog (agent navigates by this)
│   │   └── log.md          # Chronological operation log
│   ├── overview.md         # High-level wiki summary
│   ├── conventions.md      # Naming and style guide
│   ├── sources/            # Source summary pages
│   ├── entities/           # People, orgs, tools, projects
│   ├── concepts/           # Theories, methods, patterns
│   └── analyses/           # Comparisons, syntheses
```

## How It Works

The wiki is a **compiled artifact**. Instead of re-retrieving and re-synthesizing from raw documents on every question (like RAG), the agent reads sources once, extracts entities and claims, and writes them into structured, interlinked markdown pages. Querying is just reading.

Key principles:
- **Sources are immutable** — the agent reads them but never modifies them
- **Wiki is agent-owned** — the agent creates, updates, and cross-links all pages
- **Updates are surgical** — new sources update only affected pages, not the whole wiki
- **Contradictions are flagged** — not silently resolved

## Tips

- **Use git** — the wiki is just markdown files. `git diff` shows exactly what changed per ingestion.
- **Obsidian** — open the `wiki/` folder as an Obsidian vault for graph view and backlinks.
- **Scope updates** — always tell the agent which pages to update rather than "update everything."
- **Lint regularly** — run `/wiki lint` every 20-30 sources to catch drift.
- **One source at a time** — stay involved during ingestion for better quality.

## Credit

Based on [Andrej Karpathy's LLM Wiki gist](https://gist.github.com/karpathy/442a6bf555914893e9891c11519de94f) (April 2026). Structured following guidance from [Kunal Ganglani's setup guide](https://www.kunalganglani.com/blog/llm-wiki-karpathy-local-knowledge-base).
