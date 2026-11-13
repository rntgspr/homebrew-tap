---
human_revised: false
targets: [platform]
summary: Step-by-step formula version bump; fetch artifacts, update url and sha256, audit, install, test, and commit.
---

# Bump a formula version

## Steps

1. Read `formulae/<name>/index.md` for the tag prefix and the artifact list.
2. Confirm that the upstream release exists: `gh release view <tag> --repo rntgspr/<repo>`.
3. Download each artifact and compute its checksum: `shasum -a 256 <file>`.
4. Update every `url` and `sha256` in `Formula/<name>.rb`. Update each resource that the new release needs.
5. Run `brew audit --strict --formula Formula/<name>.rb`.
6. Run `brew reinstall --build-from-source Formula/<name>.rb`.
7. Run `brew test Formula/<name>.rb`.
8. Commit only `Formula/<name>.rb`.

## Commit convention

- Message: `chore: update <name> to <version> [<agent_name>]`.
- Write `<version>` as the upstream tag spells it, for example `v0.8.8` for alter-bridge and `0.14.0` for cumaru.
- One formula per commit.
