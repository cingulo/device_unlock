import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

/// Custom exception to notify when device do not have local auth options
class DeviceUnlockUnavailable implements Exception {}

/// Exception to notify when a second request was invoked before receive the first request answer
class RequestInProgress implements Exception {}

/// Android exception to notify when there is no foreground Activity
class NoForegroundActivity implements Exception {}

/// A Flutter plugin focused on authenticating the user identity locally
/// with native passcode as a fallback
class DeviceUnlock {
  static const MethodChannel _channel = const MethodChannel('device_unlock');

  /// Authenticates the user with biometrics (faceId or touchId)
  /// if available on the device or by passcode as a fallback.
  ///
  /// Returns a [Future] holding true, if the user successfully unlocked the device,
  /// false otherwise.
  ///
  /// [localizedReason] is the subtitle that is displayed on the native alert
  /// that prompts user for authentication.
  ///
  /// Throws an [DeviceUnlockUnavailable] if the Device does not have face,
  /// touch or pin security available.
  Future<bool> request({@required String localizedReason}) async {
    assert(localizedReason != null);
    try {
      return await _channel.invokeMethod('request', localizedReason);
    } on PlatformException catch (e) {
      if (e.code == "DeviceUnlockUnavailable") {
        throw DeviceUnlockUnavailable();
      } else if (e.code == "RequestInProgress") {
        throw RequestInProgress();
      } else if (e.code == "NoForegroundActivity") {
        throw NoForegroundActivity();
      } else {
        return throw e;
      }
    }
  }
}
