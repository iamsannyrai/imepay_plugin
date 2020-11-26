#import "ImepayPlugin.h"
#if __has_include(<imepay/imepay-Swift.h>)
#import <imepay/imepay-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "imepay-Swift.h"
#endif

@implementation ImepayPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftImepayPlugin registerWithRegistrar:registrar];
}
@end
