# LLM Wiki — Agent Instructions

You maintain a persistent, interlinked markdown wiki in this project. The wiki compiles knowledge from raw sources into structured pages — it is a **compiler for knowledge**, not a search engine.

## Architecture

Three layers, strict ownership:

| Layer | Directory | Written by | Read by | Contains |
|-------|-----------|-----------|---------|----------|
| Raw sources | `sources/` | Human | Agent | Articles, papers, notes, PDFs, images — immutable, never modified by agent |
| Wiki | `wiki/` | Agent | Human + Agent | Summaries, entity pages, concept pages, analyses, cross-references |
| Index | `wiki/_index/` | Agent | Agent + Human | Navigation indexes and operation log |

## Wiki Page Format

Every wiki page uses this structure:

```markdown
---
title: "Page Title"
type: entity | concept | source | analysis | overview
tags: [tag1, tag2]
sources: [source-filename-1, source-filename-2]
last_updated: YYYY-MM-DD
---

# Page Title

Content with [[wikilinks]] to other pages.

## See Also
- [[Related Page 1]]
- [[Related Page 2]]
```

Rules:
- One markdown file per entity, concept, or topic
- Filenames: lowercase, hyphens, no spaces (e.g., `transformer-architecture.md`)
- Use `[[wikilinks]]` for cross-references between wiki pages
- Link only the **first mention** of an entity per page
- Never create links to pages that don't exist
- YAML frontmatter is mandatory on every page

## Operations

### Ingest (`/wiki ingest`)

When told to ingest a source:

1. Read the source document in `sources/`
2. Discuss key takeaways with the user
3. List which existing wiki pages would need updates — get confirmation before proceeding
4. Write a summary page in `wiki/sources/`
5. Create new entity/concept pages as needed in `wiki/entities/` or `wiki/concepts/`
6. Update existing pages with new information — surgical edits, not full rewrites
7. Flag any contradictions between new and existing content
8. Update `wiki/_index/index.md`
9. Append an entry to `wiki/_index/log.md`

**Critical**: Never do an unscoped update. Always identify affected pages first and confirm scope with the user.

### Query (`/wiki query <question>`)

1. Read `wiki/_index/index.md` to find relevant pages
2. Read those pages
3. Synthesize an answer with `[[wikilink]]` citations
4. If the answer reveals a gap, suggest what source could fill it
5. Valuable answers can be filed as new analysis pages in `wiki/analyses/`

### Lint (`/wiki lint`)

Health-check the wiki. Look for:
- Contradictions between pages
- Stale claims superseded by newer sources
- Orphan pages with no inbound links
- Important concepts mentioned but lacking their own page
- Missing cross-references
- Broken `[[wikilinks]]`
- Pages not updated in 30+ days that have relevant newer sources

Report findings as a checklist. Don't auto-fix — let the user decide.

### Contradiction Check (`/wiki contradictions`)

Scan all wiki pages and list any claims that contradict each other, with:
- The conflicting claims quoted
- Page references for each
- The source that supports each claim

## Conventions

- Preserve existing content during updates — add, don't rewrite
- Keep pages focused: one entity/concept per page, aim for 200-500 words
- Use consistent terminology (define naming in `wiki/conventions.md`)
- Date all claims that might become stale
- When sources disagree, note both positions with citations
- Track page freshness via `last_updated` in frontmatter

## Directory Structure

```
sources/                    # Raw input (human-owned, agent reads only)
wiki/
├── _index/
│   ├── index.md            # Content catalog: every page with one-line summary
│   └── log.md              # Chronological operation log
├── overview.md             # High-level wiki overview
├── conventions.md          # Naming conventions and style guide
├── sources/                # Source summary pages
├── entities/               # Entity pages (people, orgs, tools, projects)
├── concepts/               # Concept pages (theories, methods, patterns)
└── analyses/               # Analysis pages (comparisons, syntheses)
```
