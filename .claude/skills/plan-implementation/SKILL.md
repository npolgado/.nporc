---

## name: plan-implementation
description: Formulate a concrete execution plan from one or more implementation documents (roadmaps, PRDs, TDDs, architecture docs). Writes a structured plan file to disk. Use when the user has design or roadmap docs and wants a concrete, ordered implementation plan. Trigger when the user says "plan from docs", "create a plan from this roadmap", "turn this into a plan", passes implementation file paths, or wants to convert any spec/design document into executable steps.
argument-hint:  [doc-path-2 ...]
allowed-tools: Read, Grep, Glob, Write

# Plan Implementation

Convert one or more implementation documents into a concrete, ordered execution plan written to disk.

## Arguments

`$ARGUMENTS` is a space-separated list of file paths (relative to the project root, or absolute). Multiple paths are supported to synthesize a plan across several documents.

If no arguments are provided, ask the user which documents to read before proceeding.

## Steps

1. **Read all source documents.** For each path in `$ARGUMENTS`, read the full file. If a path doesn't exist, report it and skip it. If none exist, stop and tell the user.
2. **Extract key information** from each document:
  - High-level goal and motivation
  - Phases or milestones (if the doc is phased)
  - Concrete deliverables: files to create, directories to make, modules to write
  - Dependencies between phases/tasks (what must exist before what)
  - Tech stack and tooling requirements
  - Any explicit constraints or non-goals
3. **Order and synthesize tasks.** If multiple docs are provided, reconcile them into a single unified task order. Respect dependencies — if task B requires task A's output, A must come first. Preserve the source doc's phasing where it exists.
4. **Write the plan file.** Determine a short slug from the phase/goal (e.g., `phase_0`). Write it to a `plans/` subdirectory *inside the same directory as the source document*. For example, if the source is `docs/roadmaps/architecture_migration/phase_0_1_foundation_and_port.md`, the plan is written to `docs/roadmaps/architecture_migration/plans/phase_0.md`. Create the `plans/` directory if it doesn't exist (the Write tool handles this automatically).
5. **Report the output path** to the user so they know where to find the plan.

## Plan File Format

Use this exact structure:

```markdown
# <Goal Title>

**Source docs:** <list of input files>
**Date:** YYYY-MM-DD

## Goal

<1-2 sentence summary of what this plan achieves and why.>

---

## Phase N — <Phase Name>

### Task N.M — <Task Name>

**Files:**
- `path/to/create.ts` — what this file is
- `path/to/modify.ts` — what changes

**Steps:**
1. Step one (concrete action, not vague)
2. Step two
3. ...

**Depends on:** Task N.M-1 (or "none")

**Verify:** How to confirm this task is done (run a command, see a file, check output)

---

## Verification

Steps to verify the full implementation end-to-end once all tasks are complete.
```

## Format Rules

- **No placeholders.** Every task must be concrete. No "TBD", "add logic here", "figure this out later". If you can't determine what goes in a step from the source docs, note the ambiguity explicitly so the implementer knows to ask.
- **Preserve phases from the source doc.** If the doc says "Phase 0", "Phase 1", keep that structure. Don't flatten it.
- **Tasks should be one-sitting sized.** If a task is enormous (e.g., "port the entire physics engine"), break it into sub-tasks.
- **File paths must be real.** Copy file paths verbatim from the source doc. Don't invent paths.
- **Dependencies must be explicit.** Every task states what it depends on, or "none".

## Example

If invoked as `/plan-implementation docs/roadmaps/architecture_migration/phase_0_1_foundation_and_port.md phase 0`:

The skill reads the migration roadmap, extracts Phase 0 (project scaffold) and writes:

```
docs/roadmaps/architecture_migration/plans/phase_0.md
```

With phases and tasks derived directly from the roadmap's sections and file listings.