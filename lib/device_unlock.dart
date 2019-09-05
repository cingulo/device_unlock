import 'dart:async';

import 'package:flutter/services.dart';

class DeviceUnlock {
  static const MethodChannel _channel =
      const MethodChannel('device_unlock');

  Future<bool> request() async {
    final isUnlocked = await _channel.invokeMethod('request');
    return isUnlocked;
  }

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }
}
