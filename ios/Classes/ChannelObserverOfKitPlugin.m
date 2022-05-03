#import "ChannelObserverOfKitPlugin.h"
#if __has_include(<channel_observer_of_kit/channel_observer_of_kit-Swift.h>)
#import <channel_observer_of_kit/channel_observer_of_kit-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "channel_observer_of_kit-Swift.h"
#endif

@implementation ChannelObserverOfKitPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftChannelObserverOfKitPlugin registerWithRegistrar:registrar];
}
@end
