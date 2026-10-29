class AlterBridge < Formula
  desc "Durable asynchronous messaging between local LLM agent sessions"
  homepage "https://github.com/rntgspr/alter-bridge-client"
  url "https://github.com/rntgspr/alter-bridge-client/releases/download/v0.8.0/alter-bridge-v0.8.0.zip"
  sha256 "684614dd85f85ca751bfe486fde3cde2a1890a4459d1d58b8f36f2cce1b174bc"

  depends_on :macos

  # Installs the universal CLI, its abg alias and the native assets used by config.
  def install
    bin.install "bin/alter-bridge"
    bin.install_symlink "alter-bridge" => "abg"

    pkgshare.install "native-assets", "skills", "VERSION", "SHA256SUMS"
  end

  # Runs the device WebSocket daemon as a per-user LaunchAgent via brew services.
  service do
    run [opt_bin/"alter-bridge", "daemon", "run"]
    keep_alive true
    log_path var/"log/alter-bridge.log"
    error_log_path var/"log/alter-bridge.log"
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
        brew services start alter-bridge
    EOS
  end

  test do
    assert_match "usage: alter-bridge", shell_output("#{bin}/alter-bridge --help 2>&1")
  end
end
