# homebrew-tap

Personal [Homebrew](https://brew.sh) tap

```bash
brew tap rntgspr/tap
brew trust rntgspr/tap
```

## Formulae

### claude-statusline-stickers

Themed sprite-glyph font for the Claude Code statusline — a sticker per agent.

```bash
# if you trust the tap, install directly
brew install claude-statusline-stickers
# or
brew install rntgspr/tap/claude-statusline-stickers

# then download sprites, build the font, and wire it live
stickers fetch && stickers build && stickers install
```

Project & source: https://github.com/rntgspr/claude-statusline-stickers
