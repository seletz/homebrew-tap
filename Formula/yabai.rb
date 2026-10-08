# yabai built from the seletz/yabai soft fork: upstream v7.1.25 plus a version
# clamp so that a macOS release newer than the newest one yabai knows (26)
# takes that release's code paths. Without it every macOS-version check is
# false on macOS 27 and window management falls back to pre-Ventura code
# paths (e.g. no bsp re-layout after closing a window, asmvik/yabai#2828).
# Upstream releases ship a prebuilt binary only, so the patched build comes
# from source. Fork branch: https://github.com/seletz/yabai/tree/seletz
class Yabai < Formula
  desc "Tiling window manager for macOS (bsp), with the macOS 27 version-clamp patch"
  homepage "https://github.com/seletz/yabai"
  url "https://github.com/seletz/yabai/archive/refs/tags/v7.1.25-seletz.1.tar.gz"
  version "7.1.25"
  sha256 "e0802bfb36d0f5a8d94765661e95259f301a664bc290795d5c423d7a779fe030"
  license "MIT"
  revision 1
  head "https://github.com/seletz/yabai.git", branch: "seletz"

  depends_on :macos

  conflicts_with "koekeishiya/formulae/yabai", because: "both install bin/yabai"

  def install
    system "make", "-j1", "install"
    system "codesign", "-fs", "-", "#{buildpath}/bin/yabai"
    bin.install "bin/yabai"
    (pkgshare/"examples").install "examples/yabairc", "examples/skhdrc"
    man1.install "doc/yabai.1"
  end

  def caveats
    <<~EOS
      Built from source (seletz/yabai, upstream v7.1.25 + macOS 27 clamp).
      After every (re)build macOS asks for Accessibility again, then:
        yabai --restart-service
      Logs: /tmp/yabai_<user>.[out|err].log
    EOS
  end

  test do
    assert_match "yabai-v#{version}", shell_output("#{bin}/yabai --version")
  end
end
