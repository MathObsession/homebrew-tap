class VicinusAi < Formula
  include Language::Python::Virtualenv

  desc "Local AI console: Gemma 4 inference via TurboFieldfare + web UI"
  homepage "https://github.com/MathObsession/VicinusAI"
  url "https://github.com/MathObsession/VicinusAI/archive/refs/tags/v0.1.11.tar.gz"
  sha256 "2dc0e28663b08f3eaa6da9629e69f00a23184604f670c70abad5ddede3243365"
  license "Apache-2.0"

  depends_on "node" => :build
  depends_on "python@3.12"
  # The TurboFieldfare Swift runtime is built inside this formula (not as a
  # separate tap dependency) so a single fully qualified install auto-taps,
  # auto-trusts and completes on a fresh machine with one command.
  # Requires Apple's Swift toolchain (Xcode or Command Line Tools), macOS 26
  # and arm64 — same requirements as upstream turbo-fieldfare 0.5.0.
  depends_on :macos
  depends_on arch: :arm64

  resource "blinker" do
    url "https://files.pythonhosted.org/packages/21/28/9b3f50ce0e048515135495f198351908d99540d69bfdc8c1d15b73dc55ce/blinker-1.9.0.tar.gz"
    sha256 "b4ce2265a7abece45e7cc896e98dbebe6cead56bcf805a3d23136d145f5445bf"
  end

  resource "turbo-fieldfare-src" do
    url "https://github.com/drumih/turbo-fieldfare/archive/refs/tags/0.5.0.tar.gz"
    sha256 "6ab539e7b836c95a4f1054b6f5746e1c5eae2e6c1aaefd9b25abb2b2fae006cc"
  end

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/a3/c2/24167ea9858356b47a87a50d39908bfdb72ceeefe0041586e704e5376b3a/certifi-2026.7.22.tar.gz"
    sha256 "741e2c3b351ddf169a738da9f2c048608ff7f2c5cc02f1ebc6b118bb090d5d55"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/e5/3f/143b048436775b0f76ac3eec145c019e8173ccc2885c8f20319b996d5e83/charset_normalizer-3.5.1.tar.gz"
    sha256 "6117b84ea48435e5356dc737f5121485c30920ba43375fa7b434fd753df0eac3"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/76/d4/81420972a676e8ffea40450d8c8c92943e7218a78fe9b64359836cc9876b/click-8.4.2.tar.gz"
    sha256 "9a6cea6e60b17ebe0a44c5cc636d94f09bd66142c1cd7d8b4cd731c4917a15f6"
  end

  resource "flask" do
    url "https://files.pythonhosted.org/packages/26/00/35d85dcce6c57fdc871f3867d465d780f302a175ea360f62533f12b27e2b/flask-3.1.3.tar.gz"
    sha256 "0ef0e52b8a9cd932855379197dd8f94047b359ca0a78695144304cb45f87c9eb"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/5f/f7/abb373e5757eaec4b922b92f97ec8d6d7e057cf06778247604fbc4e7c3f3/idna-3.19.tar.gz"
    sha256 "5e0811a4383b21dc5838069f801c4fb62113b7447663d2530d2bd6e77b49bf15"
  end

  resource "itsdangerous" do
    url "https://files.pythonhosted.org/packages/9c/cb/8ac0172223afbccb63986cc25049b154ecfb5e85932587206f42317be31d/itsdangerous-2.2.0.tar.gz"
    sha256 "e0050c0b7da1eea53ffaf149c0cfbb5c6e2e2b69c4bef22c81fa6eb73e5f6173"
  end

  resource "jinja2" do
    url "https://files.pythonhosted.org/packages/df/bf/f7da0350254c0ed7c72f3e33cef02e048281fec7ecec5f032d4aac52226b/jinja2-3.1.6.tar.gz"
    sha256 "0137fb05990d35f1275a587e9aee6d56da821fc83491a0fb838183be43f66d6d"
  end

  resource "markupsafe" do
    url "https://files.pythonhosted.org/packages/7e/99/7690b6d4034fffd95959cbe0c02de8deb3098cc577c67bb6a24fe5d7caa7/markupsafe-3.0.3.tar.gz"
    sha256 "722695808f4b6457b320fdc131280796bdceb04ab50fe1795cd540799ebe1698"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/ac/c3/e2a2b89f2d3e2179abd6d00ebd70bff6273f37fb3e0cc209f48b39d00cbf/requests-2.34.2.tar.gz"
    sha256 "f288924cae4e29463698d6d60bc6a4da69c89185ad1e0bcc4104f584e960b9ed"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/53/0c/06f8b233b8fd13b9e5ee11424ef85419ba0d8ba0b3138bf360be2ff56953/urllib3-2.7.0.tar.gz"
    sha256 "231e0ec3b63ceb14667c67be60f2f2c40a518cb38b03af60abc813da26505f4c"
  end

  resource "werkzeug" do
    url "https://files.pythonhosted.org/packages/dd/b2/381be8cfdee792dd117872481b6e378f85c957dd7c5bca38897b08f765fd/werkzeug-3.1.8.tar.gz"
    sha256 "9bad61a4268dac112f1c5cd4630a56ede601b6ed420300677a869083d70a4c44"
  end

  def install
    # Build the vendored TurboFieldfare inference runtime (Swift + Metal).
    resource("turbo-fieldfare-src").stage do
      system "swift", "build", "--disable-sandbox", "-c", "release",
             "--product", "TurboFieldfareServer"
      system "swift", "build", "--disable-sandbox", "-c", "release",
             "--product", "TurboFieldfareRepack"

      turbo = libexec/"turbo"
      turbo.install ".build/release/TurboFieldfareServer"
      turbo.install ".build/release/TurboFieldfareRepack"
      # SwiftPM resource bundles must sit beside the executables; Homebrew
      # does not link directories out of bin/, hence libexec + wrappers.
      turbo.install Dir[".build/release/*.bundle"]
    end
    turbo_bin = libexec/"turbo"
    (bin/"TurboFieldfareServer").write_env_script(turbo_bin/"TurboFieldfareServer", {})
    (bin/"TurboFieldfareRepack").write_env_script(turbo_bin/"TurboFieldfareRepack", {})

    # Build the React frontend and ship it as static assets.
    cd "frontend" do
      system "npm", "ci"
      system "npm", "run", "build"
    end
    (share/"vicinus-ai").install "frontend/dist"

    # Fetch the custom app icon from the repo (not in the v0.1.11 tag yet).
    icon_url = "https://raw.githubusercontent.com/MathObsession/VicinusAI/main/vicinus.png"
    system "curl", "-fL", "-o", "vicinus.png", icon_url

    # Native GUI launcher (AppKit + WebKit) wrapping the CLI orchestrator.
    # scripts/build-app.sh runs the (sandbox-disabled) SwiftPM build itself.
    system "bash", "scripts/build-app.sh"
    (libexec/"apps").install "build/VicinusAI.app"

    virtualenv_install_with_resources(using: "python@3.12",
                                      without: "turbo-fieldfare-src")

    # vicinus-ai-cli is created automatically from pyproject.toml entry_points.
    # vicinus-ai is the GUI launcher — copies the app to /Applications on first
    # run and opens it from there on subsequent runs.
    gui_wrapper = <<~EOS
      #!/bin/bash
      HOMEBREW_PREFIX="${HOMEBREW_PREFIX:-/opt/homebrew}"
      APP_SRC="$HOMEBREW_PREFIX/opt/vicinus-ai/libexec/apps/VicinusAI.app"
      APP_DST="/Applications/VicinusAI.app"
      xattr -d com.apple.quarantine "$APP_SRC" 2>/dev/null || true
      if [ ! -d "$APP_DST" ] || [ "$APP_SRC/Contents/MacOS/VicinusAI" -nt "$APP_DST/Contents/MacOS/VicinusAI" ]; then
          rm -rf "$APP_DST"
          cp -R "$APP_SRC" "$APP_DST"
      fi
      exec /usr/bin/open "$APP_DST" "$@"
    EOS
    (bin/"vicinus-ai").write(gui_wrapper)
  end

  def caveats
    <<~EOS
      Launch the GUI (recommended):

        vicinus-ai            # installs to /Applications, opens it

      Or use the CLI directly:

        vicinus-ai-cli

      On first run it downloads the Gemma 4 model (~15 GB, once) to:
        ~/Library/Application Support/VicinusAI/gemma4.gturbo

      To reuse an existing .gturbo installation instead:
        export VICINUS_MODEL_DIR=/path/to/gemma4.gturbo

      Run without the Swift inference server (simulated UI):
        vicinus-ai-cli --no-turbo

      To fully uninstall:
        brew uninstall vicinus-ai
    EOS
  end

  test do
    assert_match "vicinus-ai-cli #{version}", shell_output("#{bin}/vicinus-ai-cli --version")
    assert_match "usage: vicinus-ai-cli", shell_output("#{bin}/vicinus-ai-cli --help")
  end
end
