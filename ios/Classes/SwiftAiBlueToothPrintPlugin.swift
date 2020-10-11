import Flutter
import UIKit
import CoreBluetooth
//import PrinterSDK


public class SwiftAiBlueToothPrintPlugin: NSObject, FlutterPlugin,UIApplicationDelegate {
    
    
    
    public static var mViewController = UIViewController()
    private static var mMethodChannel:FlutterMethodChannel?;
    var encoding = CFStringConvertEncodingToNSStringEncoding(CFStringEncoding(CFStringEncodings.GB_18030_2000.rawValue))
    
    public var window: UIWindow?
//    var mDataSources = [PTPrinter]();
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        
        mViewController = (UIApplication.shared.delegate?.window??.rootViewController)!
        let channel = FlutterMethodChannel(name: "ai_blue_tooth_print", binaryMessenger: registrar.messenger())
        let instance = SwiftAiBlueToothPrintPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
        
        mMethodChannel=channel;
        //Test
        registrar.addApplicationDelegate(instance)
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        
        let arg = call.arguments as? [String:Any]
        
        print("handle：\(call.method),\(call.arguments)");
        if("scanBluetooth".elementsEqual(call.method)){
            BluetoothHelper.shared.startScan(name: "HY")
            //            scanBluetoothDevice();
        }else if("connectBluetooth".elementsEqual(call.method)){
            let mac = arg?["mac"] as! String
            //connectDevice(mac: mac);
        }else if("print".elementsEqual(call.method)){

//           ‘pushViewController’方式在这里没有效果（PS:iOS native is ok） SwiftAiBlueToothPrintPlugin.mViewController.navigationController?.pushViewController(PDWiFiSelectIPViewController(), animated:true);
            SwiftAiBlueToothPrintPlugin.mViewController.present(PDMainViewController(), animated:true) {
                
            }
            
//            navigationController?.pushViewController(PDWiFiSelectIPViewController(), animated: true)
            //            SwiftAiBlueToothPrintPlugin.mViewController.navigationController?.pushViewController(TestViewController(), animated: true);
            
            //            let info = arg?["info"] as! [String]
            //            bluetoothPrint(printInfoList: info);
        }else if("disconnectBluetooth".elementsEqual(call.method)){
            //disconnectDevice();
        }else{
            result("not implement");
        }
        
    }
    
//
//    //connectDevice
//    private func connectDevice(mac:String){
//        disconnectDevice();
//
//        print("连接蓝牙:\(mac)");
//        //Connect success callback
//        PTDispatcher.share().whenConnectSuccess {
//            print("连接蓝牙成功");
//        }
//        //Connect error callback
//        PTDispatcher.share().whenConnectFailureWithErrorBlock { (error) in
//
//            print("连接蓝牙失败：\(error)");
//        }
//        //Find bluetooth by mac,and connect it
//        for device in mDataSources{
//
//            if(mac.elementsEqual(device.mac)){
//                print("匹配到的蓝牙设备 name:\(device.name),mac:\(device.mac)");
//
//
//                do{
//                    defer{
//                        print("释放资源11")
//                        print("释放资源12")
//                    }
//                    print("test1")
//                    try PTDispatcher.share().connect(device) //如果路径为空，执行顺序如何？
//                    print("test2")
//                }catch{//内置变量error
//                    print(error)
//                }
//            }
//
//        }
//
//
//    }
//    //disconnectDevice
//    private func disconnectDevice() {
//        PTDispatcher.share()?.unconnectPrinter(PTDispatcher.share()?.printerConnected)
//    }
//
//    func bluetoothPrint(printInfoList:[String]){
//        print("开始打印");
//        print("数据：\(printInfoList)");
//        var totalData = Data.init()
//
//        let esc = PTCommandESC.init()
//        esc.initializePrinter()
//        esc.encoding = self.encoding
//        for info in printInfoList{
//
//            esc.appendText(info, mode: .normal)
//        }
//        //换行方便观察
//        esc.printAndLineFeed()
//        esc.printAndLineFeed()
//        esc.printAndLineFeed()
//        totalData.append(esc.getCommandData())
//
//        //send
//        PTDispatcher.share()?.send(totalData)
//    }
//
//    private func scanBluetoothDevice(){
//        print("扫描开始");
//        if PTDispatcher.share()?.getBluetoothStatus() == PTBluetoothState.poweredOn {
//            PTDispatcher.share()?.stopScanBluetooth()
//
//            PTDispatcher.share().scanBluetooth()
//            PTDispatcher.share()?.whenFindAllBluetooth({ [weak self](ptArray) in
//                guard let self = self else { return }
//
//                print("扫描成功");
//
//
//                var dataSources = [PTPrinter]();
//                dataSources = ptArray as! [PTPrinter]
//                var index = 0;
//
//                let empty:[String:Any] = [
//                    "name":""
//                ];
//
//                for device in dataSources{
//                    index = index + 1
//                    print("爱蓝牙-扫描设备,\(index)：name:\(device.name),ip:\(device.ip),mac:\(device.mac)");
//
//                }
//
//                self.mDataSources = ptArray as! [PTPrinter]
//
//                SwiftAiBlueToothPrintPlugin.mMethodChannel?.invokeMethod("scanBluetoothDeviceResultStart", arguments: empty);
//                for device in dataSources{
//                    index = index + 1
//                    print("爱蓝牙-扫描设备,\(index)：name:\(device.name),ip:\(device.ip),mac:\(device.mac)");
//                    let bluetoothDevice:[String:Any] = [
//                        "name":device.name ?? "",
//                        "ip":device.ip ?? "",
//                        "mac":device.mac ?? "",//Device的唯一标识符
//                    ];
//                    SwiftAiBlueToothPrintPlugin.mMethodChannel?.invokeMethod("scanBluetoothDeviceResult", arguments: bluetoothDevice);
//                }
//
//                SwiftAiBlueToothPrintPlugin.mMethodChannel?.invokeMethod("scanBluetoothDeviceResultEnd", arguments: empty);
//
//
//                PTDispatcher.share()?.stopScanBluetooth()
//            })
//        }else if PTDispatcher.share()?.getBluetoothStatus() == PTBluetoothState.poweredOff {
//            //"Please turn on Bluetooth"
//        }else {
//            //"Please go to system Settings to find your APP open bluetooth permissions"
//        }
//
//    }
}
