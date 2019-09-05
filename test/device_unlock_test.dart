import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:device_unlock/device_unlock.dart';

void main() {
  const MethodChannel channel = MethodChannel('device_unlock');
  DeviceUnlock deviceUnlock;

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return true;
    });
    deviceUnlock = DeviceUnlock();
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('request returns true', () async {
    expect(await deviceUnlock.request(localizedReason: "To check your credentials"), true);
  });

  test('localized reason should be required with request method', () async {
    try {
        await deviceUnlock.request(localizedReason: null);
        fail("exception not thrown");
    } catch (e) {
        expect(e, isA<AssertionError>());
    }
  });
}
