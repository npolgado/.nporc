---
name: daily
description: Quick actions for Obsidian daily notes — read today's note, append a bullet, check tasks, or review what changed in the vault today. Use when the user wants to interact with their daily note or get a quick daily summary.
argument-hint: [append <text> | tasks | review]
allowed-tools: Bash, mcp__mcp-obsidian__obsidian_get_periodic_note, mcp__mcp-obsidian__obsidian_get_recent_changes
---

# Daily Note Actions

Interact with today's Obsidian daily note.

## Arguments

`$ARGUMENTS` determines the action:

| Args | Action |
|------|--------|
| (empty) | Read and summarize today's daily note |
| `append <text>` | Append a bullet to the daily note |
| `prepend <text>` | Prepend a bullet to the daily note |
| `tasks` | Show incomplete tasks from the daily note |
| `review` | Read daily note + show recent vault changes |

## Steps

### No arguments — Read & Summarize
1. Run `obsidian daily:read` via Bash
2. Present the note content. If it's long, summarize the key points and list any tasks.

### `append <text>`
1. Run: `obsidian daily:append content="<text>"`
2. Confirm: "Appended to today's daily note."
3. Optionally show the updated note tail with `obsidian daily:read`

### `prepend <text>`
1. Run: `obsidian daily:prepend content="<text>"`
2. Confirm: "Prepended to today's daily note."

### `tasks`
1. Run: `obsidian tasks todo daily` via Bash
2. Present the list of open tasks from the daily note.
3. If none: "No open tasks in today's daily note."

### `review`
1. Run `obsidian daily:read` in parallel with MCP `obsidian_get_recent_changes` (last 1 day, limit 20)
2. Present:
   - Today's daily note content (or summary if long)
   - Files modified today, grouped by folder
3. If today's daily note doesn't exist yet, say so and offer to open it with `obsidian daily`

## Notes
- Daily note path can be retrieved with `obsidian daily:path` if needed
- The CLI requires Obsidian to be running
- Use `\n` for multi-line content in append/prepend: `content="- Item 1\n- Item 2"`
