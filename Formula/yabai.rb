# Upstream yabai (asmvik/formulae) plus one patch: treat a macOS release newer
# than the newest one yabai knows (26) like that newest one. Without it every
# macOS-version check is false on macOS 27 and window management falls back to
# pre-Ventura code paths (e.g. no bsp re-layout after closing a window, see
# asmvik/yabai#2828). Drop this formula once upstream ships the fix.
class Yabai < Formula
  desc "Tiling window manager for macOS (bsp), with the macOS 27 version-clamp patch"
  homepage "https://github.com/asmvik/yabai"
  url "https://github.com/asmvik/yabai/archive/refs/tags/v7.1.25.tar.gz"
  sha256 "f60f503b24896dcb4babc034b2f85494e4be2cab6e0d41575a2f03e767403602"
  license "MIT"
  revision 1
  head "https://github.com/asmvik/yabai.git", branch: "master"

  depends_on :macos

  conflicts_with "koekeishiya/formulae/yabai", because: "both install bin/yabai"

  # https://github.com/idvorkin/yabai/compare/master...upstream-pr/newer-macos-clamp
  patch do
    url "https://github.com/idvorkin/yabai/commit/537b17c.patch?full_index=1"
    sha256 "d582b9d7d71c9c6f68b29fef445ac2299b2d2f911f9b65d8718f09e5d3c4d0f5"
  end

  def install
    system "make", "-j1", "install"
    system "codesign", "-fs", "-", "#{buildpath}/bin/yabai"
    bin.install "bin/yabai"
    (pkgshare/"examples").install "examples/yabairc", "examples/skhdrc"
    man1.install "doc/yabai.1"
  end

  def caveats
    <<~EOS
      Patched build for macOS 27 (version clamp). After every (re)build macOS
      asks for Accessibility again, then: yabai --restart-service
      Logs: /tmp/yabai_<user>.[out|err].log
    EOS
  end

  test do
    assert_match "yabai-v#{version}", shell_output("#{bin}/yabai --version")
  end
end
