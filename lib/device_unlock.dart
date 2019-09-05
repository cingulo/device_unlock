import 'dart:async';

import 'package:flutter/services.dart';

/// Custom exception to notify when device do not have local auth options
class DeviceUnlockUnavailable implements Exception {
}

/// A Flutter plugin focused on authenticating the user identity locally 
/// with native passcode as a fallback
class DeviceUnlock {
  static const MethodChannel _channel =
      const MethodChannel('device_unlock');

  /// Authenticates the user with biometrics (faceId or touchId) 
  /// if available on the device or by passcode as a fallback.
  ///
  /// Returns a [Future] holding true, if the user successfully unlocked the device,
  /// false otherwise.
  /// Throws an [DeviceUnlockUnavailable] if the Device does not have face, 
  /// touch or pin security available.
  Future<bool> request() async {
    try {
        final result = await _channel.invokeMethod('request');
        return result;
      } on PlatformException catch(e) {
        if (e.code == "DeviceUnlockUnavailable") {
          throw DeviceUnlockUnavailable();
        } else {
          return throw e;
        }
      }
  }

}
