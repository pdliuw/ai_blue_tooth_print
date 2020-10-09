#import "AiBlueToothPrintPlugin.h"
#if __has_include(<ai_blue_tooth_print/ai_blue_tooth_print-Swift.h>)
#import <ai_blue_tooth_print/ai_blue_tooth_print-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "ai_blue_tooth_print-Swift.h"

#import <CoreBluetooth/CoreBluetooth.h>
#endif

@implementation AiBlueToothPrintPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftAiBlueToothPrintPlugin registerWithRegistrar:registrar];
}
@end
