import Flutter
import UIKit

public class SwiftDeviceUnlockPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "device_unlock", binaryMessenger: registrar.messenger())
    let instance = SwiftDeviceUnlockPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
      case "request":
        let unlocked = self.request()
        result(unlocked)
        break
      default:
        result(FlutterMethodNotImplemented)
    }
  }

  private func request() -> Bool {
    return true
  }

}
