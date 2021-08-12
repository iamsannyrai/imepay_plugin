#import "FlutterImepayPlugin.h"
#if __has_include(<flutter_imepay/flutter_imepay-Swift.h>)
#import <flutter_imepay/flutter_imepay-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "flutter_imepay-Swift.h"
#endif

@implementation FlutterImepayPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftFlutterImepayPlugin registerWithRegistrar:registrar];
}
@end
