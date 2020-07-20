# device_unlock

A Flutter plugin to request the device unlock screen on Android and iOS.

## How does it work

The following attempts and fallbacks are made:

1. Is face unlock available? Request and return true if user passed validation or false otherwise.
2. Is touch unlock available? Request and return true if user passed validation or false otherwise.
3. Is pin unlock available? Request and return true if user passed validation or false otherwise.
4. If the device does not have face, touch or pin security, throw an exception and let the dev decide what to do.

## Sample code

```
import 'package:device_unlock/device_unlock.dart';

try {
    if (await DeviceUnlock().request(localizedReason: "We need to check your identity.")) {
        // Unlocked successfully.
    } else {
        // Did not pass face, touch or pin validation.
    }
} on RequestInProgress {
    // A new request was sent before the first one finishes
} on DeviceUnlockUnavailable {
    // Device does not have face, touch or pin security available.
}
```
