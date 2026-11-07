class Cumaru < Formula
  desc "Context-oriented knowledge framework for AI-assisted work"
  homepage "https://github.com/rntgspr/cumaru"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/rntgspr/cumaru/releases/download/0.13.1/cumaru-aarch64-apple-darwin", using: :nounzip
      sha256 "83f441e74a1c3c8f6ba90b1f319d8b694a087d62c3f70edc69a5c78c43cf199d"
    end
    on_intel do
      url "https://github.com/rntgspr/cumaru/releases/download/0.13.1/cumaru-x86_64-apple-darwin", using: :nounzip
      sha256 "929c1d6fbb7fa5ef0c9df755a1db1955eba2aeca691f7bf67b48d7e4af13b21b"
    end
  end

  on_linux do
    depends_on "curl"
    depends_on "git"

    on_arm do
      url "https://github.com/rntgspr/cumaru/releases/download/0.13.1/cumaru-aarch64-unknown-linux-musl", using: :nounzip
      sha256 "9cc0c83b294eed3ec4ecb110b11d0874bbb6e402113066006b97293657ed6f98"
    end
    on_intel do
      url "https://github.com/rntgspr/cumaru/releases/download/0.13.1/cumaru-x86_64-unknown-linux-musl", using: :nounzip
      sha256 "cac1d7ca3adbfcc5f39fd8c01b325dd61144adac5ad253d3db33a7ce86daa61b"
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
