---
name: vault-search
description: Search the Obsidian vault for text, tags, or file patterns. Uses CLI search:context for plain text (shows surrounding line context) and MCP complex_search for structured queries (tag filters, path globs). Use when the user wants to find notes, search for a concept, or query by tag or property.
argument-hint: <query>
allowed-tools: Bash, mcp__mcp-obsidian__obsidian_simple_search, mcp__mcp-obsidian__obsidian_complex_search, mcp__mcp-obsidian__obsidian_get_file_contents
---

# Vault Search

Search the Obsidian vault using the best tool for the query type.

## Arguments

`$ARGUMENTS` is the search query. It may be:
- Plain text: `deployment notes`
- A tag filter: `#project` or `tag:project`
- A path glob: `personal/**`
- A combination: `#work deployment`

## Steps

1. **Classify the query** from `$ARGUMENTS`:
   - If it starts with `#` or `tag:` → **tag search** (use MCP `complex_search`)
   - If it contains a glob pattern (`*`, `**`) → **path search** (use MCP `complex_search`)
   - Otherwise → **text search** (use CLI `search:context`)

2. **Execute the search**:

   **Text search** (CLI):
   ```bash
   obsidian search:context query="<query>" limit=10
   ```
   This returns matching files with the surrounding line context. Parse the output and present results grouped by file.

   **Tag search** (MCP `complex_search`):
   ```json
   {"in": ["#tag", {"var": "tags"}]}
   ```

   **Path glob** (MCP `complex_search`):
   ```json
   {"glob": ["personal/**/*.md", {"var": "path"}]}
   ```

3. **Present results** as a list grouped by file:

```
### Results for "<query>"

**personal/2-Project/My Note.md**
> ...surrounding context with the match highlighted...

**claude/CLAUDE.md**
> ...matching line with context...
```

4. **If no results**, say so clearly and suggest a broader query or alternate terms.

5. **Offer next steps**: "Want me to read any of these files, or refine the search?"

## Notes
- CLI `search:context` is better for discovering where a concept appears across many files
- MCP `complex_search` is better for structured filtering (tags, paths, frontmatter)
- For best coverage on ambiguous queries, run both and deduplicate
- Default limit is 10 results; increase with `limit=N` if user wants more
