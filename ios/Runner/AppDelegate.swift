import Flutter
import UIKit
import WidgetKit

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)

    // Widget Method Channel 설정
    let controller = window?.rootViewController as! FlutterViewController
    let widgetChannel = FlutterMethodChannel(
      name: "com.jundev.oneline/widget",
      binaryMessenger: controller.binaryMessenger
    )

    widgetChannel.setMethodCallHandler { [weak self] (call, result) in
      switch call.method {
      case "updateWidgetData":
        if let args = call.arguments as? [String: Any] {
          self?.updateWidgetData(args: args)
          result(nil)
        } else {
          result(FlutterError(code: "INVALID_ARGS", message: "Invalid arguments", details: nil))
        }
      case "reloadWidget":
        self?.reloadWidget()
        result(nil)
      default:
        result(FlutterMethodNotImplemented)
      }
    }

    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  private func updateWidgetData(args: [String: Any]) {
    let defaults = UserDefaults(suiteName: "group.com.jundev.oneline")

    if let hasWrittenToday = args["hasWrittenToday"] as? Bool {
      defaults?.set(hasWrittenToday, forKey: "hasWrittenToday")
    }
    if let currentStreak = args["currentStreak"] as? Int {
      defaults?.set(currentStreak, forKey: "currentStreak")
    }
    if let lastEntryContent = args["lastEntryContent"] as? String {
      defaults?.set(lastEntryContent, forKey: "lastEntryContent")
    }

    defaults?.synchronize()
    reloadWidget()
  }

  private func reloadWidget() {
    if #available(iOS 14.0, *) {
      WidgetCenter.shared.reloadAllTimelines()
    }
  }
}
