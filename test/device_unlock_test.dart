import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:device_unlock/device_unlock.dart';

void main() {
  const MethodChannel channel = MethodChannel('device_unlock');

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return true;
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('request', () async {
    final deviceUnlock = DeviceUnlock();
    expect(await deviceUnlock.request(), true);
  });
}
