---
human_revised: false
summary: Base domain context for Cumaru projects that need local framework extensions.
targets: [meta]
---

<!-- cumaru:components -->
| Link | Description |
|------|-------------|
| [Formula/alter-bridge.rb](../Formula/alter-bridge.rb) | alter-bridge client and daemon, macOS zip release |
| [Formula/claude-statusline-stickers.rb](../Formula/claude-statusline-stickers.rb) | statusline sprite font, Python virtualenv |
| [Formula/cumaru.rb](../Formula/cumaru.rb) | cumaru CLI, four per-platform binaries |
<!-- /cumaru:components -->

<!-- cumaru:root -->
## Tap domain

This repository is the personal Homebrew tap `rntgspr/tap`. Stack: Homebrew formula Ruby DSL and GitHub releases.

- **Pillars:** `formulae/` holds one entity per formula. `release/` holds the bump workflow.
- **Discipline:** `formula-bump` gates every formula version or checksum change.
- **Entry:** for work on one formula, load `formulae/<name>/index.md`. For a bump, also load `release/bump.md`.
- **Commits:** `chore: update <name> to <version> [<agent_name>]`, one formula per commit.
<!-- /cumaru:root -->

# Base domain

The base is a **minimal domain kernel** — universal rules and meta scaffolding, with **no domain pillars**. This file is the per-domain hook the root `index.md` declares as a `depends-on`; in a real domain it carries the pillars, roles, entry points, and domain conventions. Here it stays intentionally bare.

## Roles

- **Admin** ([`roles/admin.md`](roles/admin.md)) — full read/write across `.cumaru/` and the project. The starting point for any framework; domains extend this set.

## Pillars

None. Declare your own under `config.yaml`'s `root.entities`, then create each `<pillar>/index.md` from `templates/any-index.md` and run `cumaru doctor`.

## Flow

No predefined flow — the base defines no pillars. Declare your own entities
in `config.yaml`'s `root.entities`, seed their `index.md`, and `cumaru doctor`
validates the graph. The loading-rule traversal then follows whatever
structure you build.

## Entry

With no pillars, the Admin role loads only what the task names. Build your domain to get pillar indexes the loading rule can traverse.

## Execution disciplines

Framework-shipped conduct for *how* work is done — distinct from the pillars, which hold *what* the
project is. Every modular file in `disciplines/` is loaded at context start; `applies-when:` controls
when its rules apply, never whether its body is loaded. `disciplines/index.md` defines how
`strictness:` controls required consideration. `cumaru-first` is universal and ships in every
domain; add rows as you build this one.

| Discipline | Applies when | File |
|---|---|---|
| cumaru-first | repository work can benefit from a relevant Cumaru surface | `disciplines/cumaru-first.md` |
