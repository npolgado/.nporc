---
name: patch-noter
description: Generate patch notes for a new game version by comparing recent git changes against the existing patch_notes.md. Use when the user wants to document what changed in a new release.
argument-hint: <version> <title>
allowed-tools: Bash(git *), Read, Grep, Glob, Edit
---

# Patch Notes Generator

Generate a patch notes entry for version **$ARGUMENTS**.

## Steps

1. **Read the current patch notes** from `patch_notes.md` in the project root. Note the most recent version entry — its date, version number, and title. This tells you what is already documented.

2. **Find commits since the last patch**. Use `git log --oneline` to see recent commits. Compare against the entries already in `patch_notes.md` — any commits whose changes are already described in an existing entry should be skipped. Only document NEW changes not yet in the file.

3. **If there are no new changes** since the last documented patch, tell the user there's nothing new to add and stop. Do not create an empty or duplicate entry.

4. **Analyze the new commits**. For each relevant commit, read the diffs to understand what actually changed. Focus on gameplay-visible changes, not implementation details.

5. **Write the new entry** and prepend it to `patch_notes.md` (after the `---` separator, before the first `##` entry). Use today's date.

## Format Rules

Follow this exact format (match the style of existing entries):

```
## YYYY-MM-DD - vX.Y.Z - Short Title
- Change description in plain language
- Another change
  - Sub-detail with **bold** for specific names/terms
```

**Style guidelines** (learned from existing entries):
- Keep bullet points concise — describe WHAT changed for the player, not HOW the code works
- Use sub-bullets to group related details (e.g., listing new upgrades or sprite names)
- Use **bold** for game terms, upgrade names, config names
- Include specific numbers where meaningful (e.g., "15 pts", "+30 max HP", "x1.3 speed")
- No overly technical language (avoid "refactored", "lateral friction coefficient", etc.)
- Branch name in parentheses only if the change is on a feature branch, not main
- One entry per invocation — do not split into multiple entries
- Combine related commits into a single coherent entry

## Arguments

The user provides: `<version> <title>`
- `$ARGUMENTS` contains both, e.g., `v1.0 My Cool Update`
- If only a version is given, infer a short title from the changes

## Example

If invoked as `/patch-noter v1.0 Full Release`, and new commits added a minimap and fixed a scoring bug:

```
## 2026-03-10 - v1.0 - Full Release
- Added minimap showing player position in the arena
- Fixed score not updating on encirclement kills
```
