---
human_revised: false
targets: [alter-bridge, claude-statusline-stickers, cumaru]
summary: One entity per formula in Formula/, with its upstream source, artifact shape, and install contract.
---

# Formulae

A pillar for **the knowledge behind each formula in `Formula/`**. One entity exists per formula. Create it when a formula enters the tap and remove it when the formula leaves.

## Rules

- **One entity per formula** — the directory name equals the formula file name without `.rb`.
- **Facts, not copies** — record upstream, artifact shape, and constraints. Do not copy version numbers or checksums; `Formula/<name>.rb` is the canonical source.
- **Each entry is a directory** with `index.md` and any aux files, following the universal entity rules.

Use `cumaru tree formulae` to navigate current entries.

## When to use

- You change, debug, or explain one formula.
- You add a new formula to the tap.

## When NOT to use

- You bump a version or update a checksum → `release/`.
