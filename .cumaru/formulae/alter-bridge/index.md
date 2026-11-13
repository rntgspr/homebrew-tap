---
human_revised: false
targets: [alter-bridge]
summary: alter-bridge formula; macOS-only zip release from alter-bridge-client with abg alias and bundled native assets.
---

# alter-bridge

Durable asynchronous messaging between local LLM agent sessions.

## Contract

- **Upstream:** [rntgspr/alter-bridge-client](https://github.com/rntgspr/alter-bridge-client) GitHub releases.
- **Artifact:** one universal zip, `alter-bridge-v<version>.zip`. Tags use a `v` prefix.
- **Platform:** `depends_on :macos`.
- **Install:** `bin/alter-bridge`, an `abg` symlink, and `native-assets`, `skills`, `VERSION`, `SHA256SUMS` in `pkgshare`.
- **Caveats:** device pairing, `abg config claude|codex`, and daemon install.
- **Test:** `alter-bridge --help` prints `usage: alter-bridge`.
