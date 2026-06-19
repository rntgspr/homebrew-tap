class ClaudeStatuslineStickers < Formula
  include Language::Python::Virtualenv

  desc "Themed sprite-glyph font for the Claude Code statusline — a sticker per agent"
  homepage "https://github.com/rntgspr/claude-statusline-stickers"
  url "https://github.com/rntgspr/claude-statusline-stickers/archive/refs/tags/v0.1.0.tar.gz"
  sha256 "1881b1544fb7d5c76fcf98c54abdd08764cf37bb7797890b53b79c6ece98dd2b"
  license "MIT"

  depends_on "pillow"        # the PIL module, prebuilt (bottle) — no local compile
  depends_on "python@3.13"   # the python pillow is built for; must match
  depends_on "jq"            # runtime: used by the statusline script

  resource "fonttools" do    # pure-python, installs instantly
    url "https://files.pythonhosted.org/packages/84/69/c97f2c18e0db87d2c7b15da1974dace76ae938f1cfa22e2727a648b7ed43/fonttools-4.63.0.tar.gz"
    sha256 "caeb583deeb5168e694b65cda8b4ee62abedfa66cf88488734466f2366b9c4e0"
  end

  def install
    # Reuse Homebrew's prebuilt pillow via system site-packages instead of
    # compiling it; only fonttools (pure-python) goes into the venv.
    venv = virtualenv_create(libexec, "python3.13", system_site_packages: true)
    venv.pip_install resource("fonttools")
    venv.pip_install_and_link buildpath
  end

  test do
    assert_match "stickers", shell_output("#{bin}/stickers --help")
  end
end
