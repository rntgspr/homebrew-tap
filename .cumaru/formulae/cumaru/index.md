---
human_revised: false
targets: [cumaru]
summary: cumaru formula; four pinned per-platform binaries (macOS and Linux musl, ARM64 and Intel) with a Linux ARM64 FP16 guard.
---

# cumaru

Context-oriented knowledge framework for AI-assisted work.

## Contract

- **Upstream:** [rntgspr/cumaru](https://github.com/rntgspr/cumaru) GitHub releases. Tags have **no** `v` prefix.
- **Artifacts:** four raw binaries, installed with `using: :nounzip`:
  - `cumaru-aarch64-apple-darwin`
  - `cumaru-x86_64-apple-darwin`
  - `cumaru-aarch64-unknown-linux-musl`
  - `cumaru-x86_64-unknown-linux-musl`
- **Install:** the binary goes to `libexec/cumaru`. `bin/cumaru` is a Bash wrapper that blocks `cumaru upgrade` (except `--check` and `--help`) and execs the binary.
- **Linux:** depends on `curl` and `git`. ARM64 requires the FP16 CPU flags `fphp` and `asimdhp`.
- **Upgrade:** users run `brew upgrade rntgspr/tap/cumaru`.
- **Test:** `--version` matches the formula version, `help` lists `context`, bare `upgrade` fails with `managed by Homebrew`, and an offline `context` query ranks a fixture without creating `~/.cumaru`.
- **Bump risk:** one version change touches four URLs and four checksums.
