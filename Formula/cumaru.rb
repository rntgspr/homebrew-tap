class Cumaru < Formula
  desc "Context-oriented knowledge framework for AI-assisted work"
  homepage "https://github.com/rntgspr/cumaru"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/rntgspr/cumaru/releases/download/0.15.3/cumaru-aarch64-apple-darwin", using: :nounzip
      sha256 "ad0ae7b1fd883bc0b0bd8eb3b5ad95fb793eeea8ac91f614b93c63a5030ba089"
    end
    on_intel do
      url "https://github.com/rntgspr/cumaru/releases/download/0.15.3/cumaru-x86_64-apple-darwin", using: :nounzip
      sha256 "d67e37af9c750fe3a3ed5fcc8536737400bda9149e907aa5734656f26390d4da"
    end
  end

  on_linux do
    depends_on "curl"
    depends_on "git"

    on_arm do
      url "https://github.com/rntgspr/cumaru/releases/download/0.15.3/cumaru-aarch64-unknown-linux-musl", using: :nounzip
      sha256 "84846aea2e5ee787a1b9cade66fcb875e5b921709781c12303a99179c3b39109"
    end
    on_intel do
      url "https://github.com/rntgspr/cumaru/releases/download/0.15.3/cumaru-x86_64-unknown-linux-musl", using: :nounzip
      sha256 "422ca38c990b83927b538f104b35fb2149a43dafb2c9dc5680707c41ca2bd50f"
    end
  end

  # Install only the verified executable and block the unmanaged global installer.
  def install
    if OS.linux? && Hardware::CPU.arm?
      features = File.read("/proc/cpuinfo").scan(/^Features\s*:\s*(.*)$/).flatten
      if features.empty? || features.any? { |flags| (flags.split & %w[fphp asimdhp]).size != 2 }
        odie "Cumaru's Linux ARM64 release requires FP16 (fphp and asimdhp)."
      end
    end

    libexec.install Dir["cumaru-*"].fetch(0) => "cumaru"
    chmod 0755, libexec/"cumaru"
    (bin/"cumaru").write <<~EOS
      #!/bin/bash
      # Homebrew owns this binary; never run the unmanaged /usr/local/bin installer.
      command="$1"
      [[ "$command" == -- ]] && command="$2"
      if [[ "$command" == upgrade && " $* " != *" --check "* && " $* " != *" --help "* && " $* " != *" -h "* ]]; then
        echo "cumaru upgrade: managed by Homebrew; run brew upgrade rntgspr/tap/cumaru" >&2
        exit 1
      fi
      exec "#{libexec}/cumaru" "$@"
    EOS
  end

  # Explain package ownership and the optional user-owned model cache.
  def caveats
    <<~EOS
      Use brew upgrade rntgspr/tap/cumaru for this installation.
      Bare cumaru upgrade is blocked; cumaru upgrade --check remains read-only.
      Models are optional and installed only by an explicit cumaru model push.
      Brew uninstall leaves ~/.cumaru models and project knowledge untouched.
    EOS
  end

  # Exercise offline ranking and ensure self-upgrade cannot escape the managed keg.
  test do
    assert_equal "cumaru #{version}\n", shell_output("#{bin}/cumaru --version")
    assert_match "context", shell_output("#{bin}/cumaru help")
    assert_match "managed by Homebrew", shell_output("#{bin}/cumaru upgrade 2>&1", 1)

    (testpath/"home").mkpath
    (testpath/".cumaru/eggs.md").write "# Egg recipes\n\nBoil eggs for six minutes.\n"
    with_env(HOME: (testpath/"home").to_s) do
      output = shell_output("#{bin}/cumaru context 'look for egg recipes' 2>/dev/null")
      assert_match(/^eggs\.md:\d+,\d+\t\d+\.\d{2}\n$/, output)
      refute_path_exists testpath/"home/.cumaru"
    end
  end
end
