class Smelter < Formula
  desc "Lisp scripts that just work - Coalton or Common Lisp, 43ms startup"
  homepage "https://github.com/abacusnoir/smelter"
  version "0.2.0"
  license "MIT"

  # v0.2.0 release URLs and checksums
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/abacusnoir/smelter/releases/download/v0.2.0/smt-darwin-arm64.tar.gz"
    sha256 "4b6fae04ec17d022dd7d983ac33aa284a78bf72088417f5f003cfa0a5b7d2b1b"
  elsif OS.mac? && Hardware::CPU.intel?
    url "https://github.com/abacusnoir/smelter/releases/download/v0.2.0/smt-darwin-x64.tar.gz"
    sha256 "eba1a7a1c2dff9f03779e268ea301221f255594c54d39727d5fb34f82777bc32"
  elsif OS.linux? && Hardware::CPU.intel?
    url "https://github.com/abacusnoir/smelter/releases/download/v0.2.0/smt-linux-x64.tar.gz"
    sha256 "27a590f5fcb6da18705ccb7efd7a6e78d3725b88da3ce9ea442a91c155ba7925"
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
    # Create smt-cl symlink for CL mode shebang support
    bin.install_symlink "smt" => "smt-cl"
  end

  def caveats
    <<~EOS
      🔥 Smelter installed successfully!

      Coalton (type-safe):
        smt run script.coal          # Run Coalton script
        smt eval '(+ 1 2)'           # Evaluate expression
        smt repl                     # Start REPL

      Common Lisp:
        smt cl run script.lisp       # Run CL script
        smt cl eval '(format nil "~A" 42)'
        smt-cl script.lisp           # Shortcut (for shebangs)

      Same binary. ~43ms startup. Types optional.

      For more information:
        smt --help
    EOS
  end

  test do
    # Test Coalton mode
    assert_equal "5", shell_output("#{bin}/smt eval '(+ 2 3)'").strip

    # Test CL mode
    assert_equal "42", shell_output("#{bin}/smt cl eval '(* 6 7)'").strip

    # Test smt-cl symlink
    assert_equal "10", shell_output("#{bin}/smt-cl eval '(+ 3 7)'").strip

    # Test version command
    assert_match "Smelter", shell_output("#{bin}/smt --version 2>&1")

    # Verify startup performance (should be under 150ms)
    require "benchmark"
    time = Benchmark.realtime { system "#{bin}/smt", "eval", "'(+ 1 2)'", out: File::NULL }
    assert time < 0.15, "Startup time #{(time * 1000).round}ms exceeds 150ms"
  end
end
