# device_unlock

A Flutter plugin to request the device unlock screen.

## Sample code

```
try {
    if (await DeviceUnlock.request()) {
        // Unlocked successfully.
    } else {
        // Did not pass face, touch or pin validation.
    }
} on DeviceUnlockUnavailable catch (_) {
    // Device does not have face, touch or pin security available.
}
```

## How does it work

The following attempts and fallbacks should be made:

1. Is face unlock available? Request and return true if user passed validation or false otherwise.
2. Is touch unlock available? Request and return true if user passed validation or false otherwise.
3. Is pin unlock available? Request and return true if user passed validation or false otherwise.
4. If the device does not have face, touch or pin security, throw an exception and let the dev decide what to do.
