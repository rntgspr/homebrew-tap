class AlterBridge < Formula
  desc "Durable asynchronous messaging between local LLM agent sessions"
  homepage "https://github.com/rntgspr/alter-bridge-client"
  url "https://github.com/rntgspr/alter-bridge-client/releases/download/v0.10.1/alter-bridge-v0.10.1.zip"
  sha256 "53462a32a4291df0466c8202a9b5291b71b82afe290f88bd1ace780b474d4664"

  depends_on :macos

  # Installs the universal CLI, its abg alias and the native assets used by config.
  def install
    bin.install "bin/alter-bridge"
    bin.install_symlink "alter-bridge" => "abg"

    pkgshare.install "native-assets", "skills", "VERSION", "SHA256SUMS"
  end

  # Points the user at the device pairing and native provider setup steps.
  def caveats
    <<~EOS
      Connect this device to an existing broker:
        abg connect device <url> --hexid <code>

      Install native provider integration (MCP, hooks, skills):
        abg config claude
        abg config codex

      Bundled assets live in:
        #{opt_pkgshare}

      Start the daemon:
        abg daemon install
    EOS
  end

  test do
    assert_match "usage: alter-bridge", shell_output("#{bin}/alter-bridge --help 2>&1")
  end
end
