/*!
 *  \~chinese
 *  @header     PTPrinter.h
 *  @abstract   打印机属性
 *
 *  \~english
 *  @header     PTPrinter.h
 *  @abstract   Printer properties
 */

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import "PTRouter.h"

/*!
 *  \~chinese
 *  打印机配备哪些模块
 *
 *  \~english
 *  Which modules that the current printer equipped
 */
typedef NS_ENUM(NSInteger, PTPrinterModule) {
    
    PTPrinterModuleUnknown    = 0,  /*! *\~chinese 未知类型 *\~english Unknown */
    PTPrinterModuleBLE        = 1,  /*! *\~chinese 蓝牙 *\~english BLE */
    PTPrinterModuleWiFi       = 2,  /*! *\~chinese 无线 *\~english WiFi */
    PTPrinterModuleBoth       = 3,  /*! *\~chinese 蓝牙和无线 *\~english Ble and wifi */
};

@interface PTPrinter : NSObject<NSCoding>

/*!
 *  \~chinese
 *  打印机名称
 *
 *  \~english
 *  Printer name
 */
@property(strong,nonatomic,readwrite) NSString *name;

/*!
 *  \~chinese
 *  打印机mac地址
 *
 *  \~english
 *  Printer mac address
 */
@property(strong,nonatomic,readwrite) NSString *mac;

/*!
 *  \~chinese
 *  打印机蓝牙模块
 *
 *  \~english
 *  Printer Bluetooth module
 */
@property(assign,nonatomic,readwrite) PTPrinterModule module;

/*!
 *  \~chinese
 *  发现蓝牙时获取到的广播信息
 *
 *  \~english
 *  The broadcast information obtained when Bluetooth is found
 */
@property(strong,nonatomic,readwrite) NSDictionary *advertisement;

/*!
 *  \~chinese
 *  蓝牙外设UUID
 *
 *  \~english
 *  Bluetooth peripherals UUID
 */
@property(strong,nonatomic,readwrite) NSString *uuid;

/*!
 *  \~chinese
 *  发现外设时获取到的信号强度值，单位分贝
 *
 *  \~english
 *  The signal strength value obtained when peripherals are found, unit is db
 */
@property(strong,nonatomic,readwrite) NSNumber *rssi;

/*!
 *  \~chinese
 *  信号强度等级分0-5级
 *
 *  \~english
 *  Signal strength level is from 0 to 5
 */
@property(strong,nonatomic,readwrite) NSNumber *strength;

/*!
 *  \~chinese
 *  由信号强度计算的距离
 *
 *  \~english
 *  The distance calculated by signal strength
 */
@property(strong,nonatomic,readwrite) NSNumber *distance;

/*!
 *  \~chinese
 *  蓝牙外设
 *
 *  \~english
 *  Bluetooth peripherals
 */
@property(strong,nonatomic,readwrite) CBPeripheral *peripheral;

/*!
 *  \~chinese
 *  外设的ip地址
 *
 *  \~english
 *  IP
 */
@property(strong,nonatomic,readwrite) NSString *ip;

/*!
 *  \~chinese
 *  端口
 *
 *  \~english
 *  port
 */
@property(strong,nonatomic,readwrite) NSString *port;


@end
