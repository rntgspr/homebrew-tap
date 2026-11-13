---
human_revised: false
targets: [platform, alter-bridge, claude-statusline-stickers, cumaru]
summary: Step-by-step formula version bump; fetch artifacts, update url and sha256, stage the edit in the tap clone, audit, install, test, and commit.
---

# Bump a formula version

## Why the tap clone

Homebrew refuses `brew audit` with a file path, and it refuses `brew install` and `brew test` with a file path unless `HOMEBREW_DEVELOPER` is set. The name `rntgspr/tap/<name>` resolves to the tap clone at `$(brew --repository rntgspr/tap)`, not to this working copy. Copy the edited file into the clone to verify it, then restore the clone.

## Steps

1. Read `formulae/<name>/index.md` for the tag prefix and the artifact list.
2. Confirm that the upstream release exists: `gh release view <tag> --repo rntgspr/<repo>`.
3. Download each artifact and compute its checksum: `shasum -a 256 <file>`.
4. Update every `url` and `sha256` in `Formula/<name>.rb`. Update each resource that the new release needs.
5. Stage the edit in the tap clone: `cp Formula/<name>.rb "$(brew --repository rntgspr/tap)/Formula/"`.
6. Run `brew audit --strict rntgspr/tap/<name>`.
7. Run `brew reinstall --build-from-source rntgspr/tap/<name>`.
8. Run `brew test rntgspr/tap/<name>`.
9. Restore the tap clone: `git -C "$(brew --repository rntgspr/tap)" checkout -- Formula/<name>.rb`.
10. Commit only `Formula/<name>.rb` in this repository.

## Commit convention

- Message: `chore: update <name> to <version> [<agent_name>]`.
- Write `<version>` as the upstream tag spells it, for example `v0.8.8` for alter-bridge and `0.14.0` for cumaru.
- One formula per commit.
- This convention applies from commit `c2304b8` onward. Older stickers commits use `chore: bump <name> formula to <version>`; do not rewrite them.
