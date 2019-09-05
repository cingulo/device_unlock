import Flutter
import UIKit
import LocalAuthentication

public class SwiftDeviceUnlockPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "device_unlock", binaryMessenger: registrar.messenger())
    let instance = SwiftDeviceUnlockPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
      case "request":
        let unlocked = self.request { (unlocked) in
          result(unlocked)
        }
        break
      default:
        result(FlutterMethodNotImplemented)
    }
  }

  private func request(completionBlock: @escaping (Bool) -> Void) {
    let context = LAContext()
    var evaluationError: NSError?
    let policy: LAPolicy
    if #available(iOS 9, *) {
      policy = LAPolicy.deviceOwnerAuthentication
    } else {
      policy = LAPolicy.deviceOwnerAuthenticationWithBiometrics
    }
    let reason = "We need to check your credentials"

    if (!context.canEvaluatePolicy(policy, error: &evaluationError)) {
        if(evaluationError?.code == LAError.passcodeNotSet.rawValue) {
            //TODO: Return exception
            completionBlock(true)
        }
    } else {
        context.evaluatePolicy(policy, localizedReason: reason) { (success, error) in
            completionBlock(success)
        }
    }
  }

}
