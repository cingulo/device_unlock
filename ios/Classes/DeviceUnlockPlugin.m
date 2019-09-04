#import "DeviceUnlockPlugin.h"
#import <device_unlock/device_unlock-Swift.h>

@implementation DeviceUnlockPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftDeviceUnlockPlugin registerWithRegistrar:registrar];
}
@end
