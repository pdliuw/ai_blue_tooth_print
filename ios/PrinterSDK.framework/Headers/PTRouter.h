/*!
 *  \~chinese
 *  @header     PTRouter.h
 *  @abstract   路由器属性
 *
 *  \~english
 *  @header     PTRouter.h
 *  @abstract   Router properties
 */

#import <Foundation/Foundation.h>

@interface PTRouter : NSObject

/*!
 *  \~chinese
 *  广播地址
 *
 *  \~english
 *  Broadcast address
 */
@property(strong,nonatomic,readwrite) NSString *broadcastIP;

/*!
 *  \~chinese
 *  本机地址
 *
 *  \~english
 *  Local address
 */
@property(strong,nonatomic,readwrite) NSString *localIP;

/*!
 *  \~chinese
 *  子网掩码
 *
 *  \~english
 *  Netmask
 */
@property(strong,nonatomic,readwrite) NSString *netmask;

/*!
 *  \~chinese
 *  接口
 *
 *  \~english
 *  Interface
 */
@property(strong,nonatomic,readwrite) NSString *interface;

/*!
 *  \~chinese
 *  网关
 *
 *  \~english
 *  Gateway
 */
@property(strong,nonatomic,readwrite) NSString *gateway;

/*!
 *  \~chinese
 *  是否连接路由器
 *
 *  \~english
 *  Whether to connect to the router
 */
@property(assign,nonatomic,readwrite) BOOL connected;

/*!
 *  \~chinese
 *  mac地址
 *
 *  \~english
 *  Mac
 */
@property(strong,nonatomic,readwrite) NSString *MAC;

/*!
 *  \~chinese
 *  热点名称
 *
 *  \~english
 *  ssid
 */
@property(strong,nonatomic,readwrite) NSString *SSID;

/*!
 *  \~chinese
 *  热点详情
 *
 *  \~english
 *  SSIDDATA
 */
@property(strong,nonatomic,readwrite) NSString *SSIDDATA;

@end
