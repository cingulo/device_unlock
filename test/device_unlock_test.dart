import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:device_unlock/device_unlock.dart';

void main() {
  const MethodChannel channel = MethodChannel('device_unlock');

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('getPlatformVersion', () async {
    expect(await DeviceUnlock.platformVersion, '42');
  });
}
