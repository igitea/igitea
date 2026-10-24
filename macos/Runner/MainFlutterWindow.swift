import Cocoa
import FlutterMacOS

class MainFlutterWindow: NSWindow {
  override func awakeFromNib() {
    let flutterViewController = FlutterViewController()
    self.contentViewController = flutterViewController

    RegisterGeneratedPlugins(registry: flutterViewController)

    super.awakeFromNib()

    // Let Flutter paint all the way to the window edges. The title bar becomes
    // a transparent drag surface with only the traffic lights visible, which
    // gives the app the quiet, chrome-less feel of a native macOS workspace.
    self.title = "iGitea"
    self.titleVisibility = .hidden
    self.titlebarAppearsTransparent = true
    self.styleMask.insert(.fullSizeContentView)
    self.isMovableByWindowBackground = false
    self.isRestorable = false
    if #available(macOS 11.0, *) {
      self.titlebarSeparatorStyle = .none
    }

    // Give the app a comfortable desktop window instead of the tiny default,
    // so the adaptive layout (sidebar + wide content) has room to shine.
    // Disable frame restoration first so a previously tiny window cannot win.
    self.setFrameAutosaveName("")
    self.minSize = NSSize(width: 400, height: 600)
    if self.frame.width < 900 || self.frame.height < 700 {
      let visible = (self.screen ?? NSScreen.main)?.visibleFrame
      let width = min(1240, (visible?.width ?? 1280) - 80)
      let height = min(880, (visible?.height ?? 900) - 80)
      self.setContentSize(NSSize(width: width, height: height))
      self.center()
    }
  }
}
