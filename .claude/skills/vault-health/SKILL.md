---
name: vault-health
description: Run a vault health check using the Obsidian CLI — counts orphans (no incoming links), dead ends (no outgoing links), unresolved links, and open tasks. Use when the user wants to audit vault integrity, find broken links, or get a graph health summary.
argument-hint: [vault=<name>] [verbose]
allowed-tools: Bash
---

# Vault Health Check

Run a diagnostic on the Obsidian vault using the CLI. Reports orphans, dead ends, unresolved links, and open tasks.

## Arguments

`$ARGUMENTS` may contain:
- `vault=<name>` — target a specific vault (omit to use the currently active vault)
- `verbose` — always show full file lists even if counts are low

Parse these from `$ARGUMENTS` before running commands.

## Steps

1. **Build the vault flag**. If `vault=<name>` was given, prefix every command with `vault=<name>`. Otherwise omit it.

2. **Get counts** — run all four in parallel (single Bash call with `&& echo ---` separators, or just sequential since they're fast):
   ```
   obsidian [vault=<name>] orphans total
   obsidian [vault=<name>] deadends total
   obsidian [vault=<name>] unresolved total
   obsidian [vault=<name>] tasks todo total
   ```

3. **Get details for any non-zero counts** — if a count > 0 (or `verbose` was given), run the listing version:
   - Orphans: `obsidian orphans` (lists file paths)
   - Dead ends: `obsidian deadends`
   - Unresolved: `obsidian unresolved verbose` (includes source files)
   - Tasks: `obsidian tasks todo` (lists task text)

4. **Present a clean summary**:

```
## Vault Health

| Check          | Count |
|----------------|-------|
| Orphans        | N     |
| Dead ends      | N     |
| Broken links   | N     |
| Open tasks     | N     |

### Orphans (files with no incoming links)
- file1.md
- file2.md

### Unresolved Links
- [[BrokenRef]] ← referenced in file.md

### Open Tasks
- [ ] Task text (file.md)
```

5. **If everything is zero**, say: "Vault is healthy — no orphans, dead ends, broken links, or open tasks."

## Notes
- The CLI requires Obsidian to be running. If commands fail, tell the user to open Obsidian first.
- `deadends` = files that don't link to anything (may be intentional for atomic notes)
- `orphans` = files nothing links to (more likely to be forgotten notes)
- Broken links are the most actionable — always list them if any exist
