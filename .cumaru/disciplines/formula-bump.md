---
human_revised: false
name: formula-bump
applies-when: a change edits a url, sha256, version, or resource in Formula/*.rb
strictness: 9/10
summary: "Before you commit a formula change, verify every checksum against the real artifact and pass brew audit, install, and test. Follow release/bump.md."
---

# Verify formula bumps

**Gate:** do not commit a `Formula/*.rb` change until each checksum matches its downloaded artifact and `brew audit`, `brew install`, and `brew test` pass.

## Rules

- Follow [`release/bump.md`](../release/bump.md).
- Compute each `sha256` from the downloaded file. Never copy a checksum from release notes or memory.
- Update all platform blocks together. A partial bump breaks some platforms.
- Report each verification step that you could not run, for example Linux artifacts on macOS.

## Red flags

- A `url` changes but its `sha256` does not.
- A commit touches more than one formula.
- A version string differs between the URL and the commit message.
