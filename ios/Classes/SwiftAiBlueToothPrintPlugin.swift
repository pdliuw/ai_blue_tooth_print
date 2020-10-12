import Flutter
import UIKit
import CoreBluetooth


public class SwiftAiBlueToothPrintPlugin: NSObject, FlutterPlugin,UIApplicationDelegate {
    
    
    public static var mViewController = UIViewController()
    
    var encoding = CFStringConvertEncodingToNSStringEncoding(CFStringEncoding(CFStringEncodings.GB_18030_2000.rawValue))
    
    public var window: UIWindow?
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        
        mViewController = (UIApplication.shared.delegate?.window??.rootViewController)!
        let channel = FlutterMethodChannel(name: "ai_blue_tooth_print", binaryMessenger: registrar.messenger())
        let instance = SwiftAiBlueToothPrintPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
        
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        
        let arg = call.arguments as? [String:Any]
        
        print("handle：\(call.method),\(call.arguments)");
        if("scanBluetooth".elementsEqual(call.method)){
            //            BluetoothHelper.shared.startScan(name: "HY")
            
        }else if("connectBluetooth".elementsEqual(call.method)){
            //            let mac = arg?["mac"] as! String
            //            connectDevice(mac: mac);
        }else if("print".elementsEqual(call.method)){
            
            //pushViewController’方式在这里没有效果（PS:iOS native is ok）
            //            SwiftAiBlueToothPrintPlugin.mViewController.navigationController?.pushViewController(PDWiFiSelectIPViewController(), animated:true);
            SwiftAiBlueToothPrintPlugin.mViewController.present(PDMainViewController(), animated:true) {
                
            }
            
            
            //            let info = arg?["info"] as! [String]
            //            bluetoothPrint(printInfoList: info);
        }else if("disconnectBluetooth".elementsEqual(call.method)){
            //disconnectDevice();
        }else{
            result("not implement");
        }
        
    }
    
}
