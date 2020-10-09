

#if TARGET_OS_IOS
#import <UIKit/UIKit.h>
#elif TARGET_OS_MAC
#import <Cocoa/Cocoa.h>
#endif

#import <Foundation/NSObjCRuntime.h>

//! Project version number for PrinterSDK.
FOUNDATION_EXPORT double PrinterSDKVersionNumber;

//! Project version string for PrinterSDK.
FOUNDATION_EXPORT const unsigned char PrinterSDKVersionString[];

// In this header, you should import all the public headers of your framework using statements like #import <PrinterSDK/PublicHeader.h>

/*! *\~chinese ESC指令 *\~english ESC command */
#import <PrinterSDK/PTCommandESC.h>

/*! *\~chinese TSPL指令 *\~english TSPL command */
#import <PrinterSDK/PTCommandTSPL.h>

/*! *\~chinese ZPL指令 *\~english ZPL command */
#import <PrinterSDK/PTCommandZPL.h>

/*! *\~chinese CPCL指令 *\~english CPCL command */
#import <PrinterSDK/PTCommandCPCL.h>
#import <PrinterSDK/PTLabel.h>

#import <PrinterSDK/PTCommandCommon.h>
#import <PrinterSDK/PTOldCommandCPCL.h>
#import <PrinterSDK/PTOldCommandTSPL.h>

/*! *\~chinese 图片处理 *\~english image manager */
#import <PrinterSDK/PTBitmap.h>
#import <PrinterSDK/PTBitmap+GrayLevel.h>
#import <PrinterSDK/PTEncode.h>

// Dispatch

/*! *\~chinese 通讯 *\~english Communication */
#import <PrinterSDK/PTDispatcher.h>
#import <PrinterSDK/PTPrinter.h>
#import <PrinterSDK/PTRouter.h>





