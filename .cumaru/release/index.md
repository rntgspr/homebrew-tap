---
human_revised: false
targets: [platform]
summary: Release workflow for the tap; how formula version bumps are prepared, verified, and committed.
---

# Release

A pillar for **the procedures that change what the tap ships**. Entries are workflow documents, not per-version logs; git history is the release log.

## Rules

- **Procedures only** — record steps and conventions. Do not record individual releases.
- **Formula specifics live in `formulae/`** — link to them instead of repeating them.

Use `cumaru tree release` to navigate current entries.

## When to use

- You bump a formula version or update a checksum.
- You review a bump commit.

## When NOT to use

- You need the install contract of one formula → `formulae/<name>/`.
