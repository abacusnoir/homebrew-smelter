class Smelter < Formula
  desc "Type-safe scripting language with 43ms startup"
  homepage "https://github.com/abacusnoir/smelter"
  version "0.1.7"
  license "MIT"

  # v0.1.7 release URLs and checksums
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/abacusnoir/smelter/releases/download/v0.1.7/smt-darwin-arm64.tar.gz"
    sha256 "c720cf85377f33e78826f51a4ad67727b1b65de759ba39a664580fcb61c4c874"
  elsif OS.mac? && Hardware::CPU.intel?
    url "https://github.com/abacusnoir/smelter/releases/download/v0.1.7/smt-darwin-x64.tar.gz"
    sha256 "ccb712cebac44f801b98a93f2ccad64b26b0723217852aac99c44534408798be"
  elsif OS.linux? && Hardware::CPU.intel?
    url "https://github.com/abacusnoir/smelter/releases/download/v0.1.7/smt-linux-x64.tar.gz"
    sha256 "390b3f72664ec14ed2a5038b4b976536bdd1cb9e6c3e5874709e61dd519a7c00"
  end

  def install
    # Determine platform-specific binary name
    if OS.mac? && Hardware::CPU.arm?
      binary_name = "smt-darwin-arm64"
    elsif OS.mac? && Hardware::CPU.intel?
      binary_name = "smt-darwin-x64"
    elsif OS.linux? && Hardware::CPU.intel?
      binary_name = "smt-linux-x64"
    end

    # Install binary as 'smt'
    bin.install binary_name => "smt"
  end

  def caveats
    <<~EOS
      🔥 Smelter installed successfully!

      Quick start:
        smt eval '(+ 1 2)'           # Evaluate expression
        smt repl                     # Start REPL
        smt run script.coal          # Run script file

      Smelter starts in ~43ms with full type safety!
      Faster than Ruby (62ms), competitive with Python (29ms).

      For more information:
        smt --help
    EOS
  end

  test do
    # Test basic arithmetic
    assert_equal "5", shell_output("#{bin}/smt eval '(+ 2 3)'").strip

    # Test version command
    assert_match "Smelter", shell_output("#{bin}/smt --version 2>&1")

    # Verify startup performance (should be under 150ms)
    require "benchmark"
    time = Benchmark.realtime { system "#{bin}/smt", "eval", "'(+ 1 2)'", out: File::NULL }
    assert time < 0.15, "Startup time #{(time * 1000).round}ms exceeds 150ms"
  end
end
