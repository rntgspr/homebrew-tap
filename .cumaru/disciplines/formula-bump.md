---
human_revised: false
name: formula-bump
applies-when: a change edits Formula/*.rb, including url, sha256, resource, depends_on, install, or test blocks, or adds a new formula
strictness: 9/10
summary: "Before you commit a Formula/*.rb change, verify every checksum against the real artifact and pass brew audit, reinstall, and test through the tap clone. Follow release/bump.md."
---

# Verify formula changes

**Gate:** do not commit a `Formula/*.rb` change until each checksum matches its downloaded artifact and `brew audit`, `brew reinstall`, and `brew test` pass on `rntgspr/tap/<name>`.

## Rules

- Follow [`release/bump.md`](../release/bump.md). Steps 5 to 9 cover non-bump edits too.
- Compute each `sha256` from the downloaded file. Never copy a checksum from release notes or memory.
- Update all platform blocks together. A partial bump breaks some platforms.
- Restore the tap clone after verification.
- Report each verification step that you could not run, for example Linux artifacts on macOS.

## Red flags

- A `url` changes but its `sha256` does not.
- A commit touches more than one formula.
- A version string differs between the URL and the commit message.
- Verification ran against a file path or against the unedited tap clone.
