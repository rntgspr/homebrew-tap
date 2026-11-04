class AlterBridge < Formula
  desc "Durable asynchronous messaging between local LLM agent sessions"
  homepage "https://github.com/rntgspr/alter-bridge-client"
  url "https://github.com/rntgspr/alter-bridge-client/releases/download/v0.8.6/alter-bridge-v0.8.6.zip"
  sha256 "c55bc6351f80a67c9a7bd1793f65e14068938d07bd4615954617456ab974923d"

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
