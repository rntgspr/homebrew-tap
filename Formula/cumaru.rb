class Cumaru < Formula
  desc "Context-oriented knowledge framework for AI-assisted work"
  homepage "https://github.com/rntgspr/cumaru"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/rntgspr/cumaru/releases/download/0.14.0/cumaru-aarch64-apple-darwin", using: :nounzip
      sha256 "4f760475444666de1c2aab022024065e6a8e7fddf7c1068c71fdd33a42f15015"
    end
    on_intel do
      url "https://github.com/rntgspr/cumaru/releases/download/0.14.0/cumaru-x86_64-apple-darwin", using: :nounzip
      sha256 "4a812188887fb85e26e9e507fd9093f8fc63d0cf1a836b0b7f97e2f709341476"
    end
  end

  on_linux do
    depends_on "curl"
    depends_on "git"

    on_arm do
      url "https://github.com/rntgspr/cumaru/releases/download/0.14.0/cumaru-aarch64-unknown-linux-musl", using: :nounzip
      sha256 "58e65d9cbe61043d743d5515ecd5ffda7d6e299e83a2a34c1a46d892b8325ccd"
    end
    on_intel do
      url "https://github.com/rntgspr/cumaru/releases/download/0.14.0/cumaru-x86_64-unknown-linux-musl", using: :nounzip
      sha256 "142b3696dc05207b83f6509487e99c6693d268f4c12297de6415063ff1220788"
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
