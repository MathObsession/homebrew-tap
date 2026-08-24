class TurboFieldfare < Formula
  desc "Swift + Metal runtime for Gemma 4 on Apple Silicon (server + installer)"
  homepage "https://github.com/drumih/turbo-fieldfare"
  url "https://github.com/drumih/turbo-fieldfare/archive/refs/tags/0.5.0.tar.gz"
  sha256 "6ab539e7b836c95a4f1054b6f5746e1c5eae2e6c1aaefd9b25abb2b2fae006cc"
  license "Apache-2.0"

  # arm64-only, macOS 26 / Metal 4 / Swift 6.2+ required upstream.
  depends_on :macos
  depends_on arch: :arm64
  # Uses Apple's Swift toolchain (Xcode or Command Line Tools).

  def install
    system "swift", "build", "--disable-sandbox", "-c", "release",
           "--product", "TurboFieldfareServer"
    system "swift", "build", "--disable-sandbox", "-c", "release",
           "--product", "TurboFieldfareRepack"

    # Executables live in libexec with their SwiftPM resource bundles beside
    # them: Homebrew does not link directories out of bin/, which would break
    # Bundle.module lookups at runtime.
    libexec.install ".build/release/TurboFieldfareServer"
    libexec.install ".build/release/TurboFieldfareRepack"
    libexec.install Dir[".build/release/*.bundle"]

    (bin/"TurboFieldfareServer").write_env_script(libexec/"TurboFieldfareServer", {})
    (bin/"TurboFieldfareRepack").write_env_script(libexec/"TurboFieldfareRepack", {})
  end

  test do
    assert_match "usage: TurboFieldfareServer",
                 shell_output("#{bin}/TurboFieldfareServer --help")
    assert_match("usage", shell_output("#{bin}/TurboFieldfareRepack --help"))
  end
end
