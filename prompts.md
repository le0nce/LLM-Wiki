# Prompt Templates for LLM Wiki Operations

## Ingest a Source

```
Read sources/<filename> and integrate it into the wiki.
1. Tell me the key takeaways first.
2. List which existing wiki pages would need updates.
3. Wait for my confirmation before making changes.
4. Create new entity/concept pages as needed.
5. Add cross-links and update the index.
```

## Scoped Update

```
Read sources/<filename>. Update only wiki/entities/<page>.md and wiki/concepts/<page>.md
with the new findings. Preserve existing content, add new information, and flag
any contradictions.
```

## Query

```
Based on the wiki, <your question here>. Cite wiki pages in your answer.
If the wiki doesn't cover this well enough, suggest what source could fill the gap.
```

## Lint / Health Check

```
Scan the entire wiki/ directory. Report:
- Contradictions between pages
- Stale pages (not updated in 30+ days with relevant newer sources)
- Orphan pages with no inbound links
- Concepts mentioned but lacking their own page
- Broken wikilinks
Don't fix anything — just list findings.
```

## Contradiction Check

```
Read every page in wiki/ and list any claims that contradict each other.
For each conflict, quote both claims, name both pages, and identify which source
supports each claim.
```

## Batch Ingest

```
Process all unprocessed files in sources/. For each:
1. Summarize key findings.
2. Show me the planned wiki updates.
3. Wait for my go-ahead before executing.
Process one source at a time.
```

## Generate Analysis

```
Compare <topic A> and <topic B> based on what's in the wiki.
Write the comparison as a new analysis page in wiki/analyses/.
Include a structured table and cite source pages.
```
