---
human_revised: false
targets: [claude-statusline-stickers]
summary: claude-statusline-stickers formula; Python virtualenv from a source tarball that reuses the Homebrew pillow bottle.
---

# claude-statusline-stickers

Themed sprite-glyph font for the Claude Code statusline.

## Contract

- **Upstream:** [rntgspr/claude-statusline-stickers](https://github.com/rntgspr/claude-statusline-stickers) tag tarball. Tags use a `v` prefix.
- **Build:** `Language::Python::Virtualenv` with `system_site_packages: true`. Only the pure-Python `fonttools` resource goes into the venv.
- **Dependencies:** `pillow`, `python@3.13`, and `jq`. The Python version must match the one that the `pillow` bottle uses.
- **Bump risk:** a new upstream release can need a new `fonttools` resource. Update its URL and `sha256` together.
- **Test:** `stickers --help` prints `stickers`.
