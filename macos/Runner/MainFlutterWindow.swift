import Cocoa
import FlutterMacOS

class MainFlutterWindow: NSWindow {
  override func awakeFromNib() {
    let flutterViewController = FlutterViewController()
    self.contentViewController = flutterViewController

    RegisterGeneratedPlugins(registry: flutterViewController)

    super.awakeFromNib()

    // Give the app a comfortable desktop window instead of the tiny default,
    // so the adaptive layout (sidebar + wide content) has room to shine.
    // Disable frame restoration first so a previously tiny window cannot win.
    self.setFrameAutosaveName("")
    self.minSize = NSSize(width: 420, height: 640)
    if self.frame.width < 900 || self.frame.height < 700 {
      let visible = (self.screen ?? NSScreen.main)?.visibleFrame
      let width = min(1200, (visible?.width ?? 1280) - 80)
      let height = min(860, (visible?.height ?? 900) - 80)
      self.setContentSize(NSSize(width: width, height: height))
      self.center()
    }
  }
}
