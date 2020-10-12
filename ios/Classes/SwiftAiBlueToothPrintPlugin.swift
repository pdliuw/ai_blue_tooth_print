import Flutter
import UIKit
import CoreBluetooth


public class SwiftAiBlueToothPrintPlugin: NSObject, FlutterPlugin{
    
    
//    public static var mViewController = UIViewController()
//    public static var mViewController = UINavigationController()
    
    public static var mViewController = FlutterViewController()
    
    var encoding = CFStringConvertEncodingToNSStringEncoding(CFStringEncoding(CFStringEncodings.GB_18030_2000.rawValue))
    
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        
//        mViewController = (UIApplication.shared.delegate?.window??.rootViewController)!
        mViewController = (UIApplication.shared.delegate?.window??.rootViewController)! as! FlutterViewController
        let channel = FlutterMethodChannel(name: "ai_blue_tooth_print", binaryMessenger: registrar.messenger())
        let instance = SwiftAiBlueToothPrintPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
        
    }
    
//    @nonobjc public func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
//        print("application");
//        let _ = PTDispatcher.share()
//        SwiftAiBlueToothPrintPlugin.window = UIWindow.init(frame: UIScreen.main.bounds)
//        SwiftAiBlueToothPrintPlugin.window.backgroundColor = UIColor.white
//        let vc = PDMainViewController.init()
//        let nvc = PDBaseNavigationController.init(rootViewController: vc)
//        SwiftAiBlueToothPrintPlugin.window.rootViewController = nvc
//        if #available(iOS 13.0, *) {
//            SwiftAiBlueToothPrintPlugin.window.overrideUserInterfaceStyle = .light
//        }
//        SwiftAiBlueToothPrintPlugin.window.makeKeyAndVisible()
//
//        //default 576 width
//        kUserDefaults.set(576, forKey: PDPrintDots)
//
//        SVProgressHUD.setDefaultStyle(SVProgressHUDStyle.dark)
//        SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.clear)
//        SVProgressHUD.setDefaultAnimationType(SVProgressHUDAnimationType.native)
//        SVProgressHUD.setMinimumDismissTimeInterval(0.5)
//        SVProgressHUD.setMaximumDismissTimeInterval(2)
//
//        return true
//    }
    
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        
        let arg = call.arguments as? [String:Any]
        
        print("handle：\(call.method),\(call.arguments)");
        if("scanBluetooth".elementsEqual(call.method)){
            //            BluetoothHelper.shared.startScan(name: "HY")
            
        }else if("connectBluetooth".elementsEqual(call.method)){
            //            let mac = arg?["mac"] as! String
            //            connectDevice(mac: mac);
        }else if("print".elementsEqual(call.method)){
            let _ = PTDispatcher.share()
            
            //pushViewController’方式在这里没有效果（PS:iOS native is ok）
            //            SwiftAiBlueToothPrintPlugin.mViewController.navigationController?.pushViewController(PDWiFiSelectIPViewController(), animated:true);
//            SwiftAiBlueToothPrintPlugin.mViewController.navigationController?.pushViewController(PDMainViewController(), animated: true);
            //测试-start
//            let viewController:UIViewController = SwiftAiBlueToothPrintPlugin.mViewController.navigationController?.viewControllers[1] ?? UIViewController()
//            viewController.navigationController?.pushViewController(PDMainViewController(), animated: true);
            //测试-end
//            let mainController:PDMainViewController = PDMainViewController();
//            let newNavigationController:UINavigationController = UINavigationController()
//
//            SwiftAiBlueToothPrintPlugin.mViewController = newNavigationController
//            let mainController = PDBLEViewController();
            let mainController = PDBLEViewController();
//            SwiftAiBlueToothPrintPlugin.mViewController.presentingViewController = UINavigationController.init(rootViewController: mainController)
//            SwiftAiBlueToothPrintPlugin.mViewController.navigationController?.pushViewController(mainController, animated: true)
//            mainController.transition(from: PDMainViewController(), to: PDBLEViewController(), duration: TimeInterval.init(), options: UIView.AnimationOptions.transitionFlipFromRight) {
//
//            } completion: { (Bool) in
//
//            }
            
            
            
            //添加动画
            mainController.modalPresentationStyle = UIModalPresentationStyle.fullScreen
            
            SwiftAiBlueToothPrintPlugin.mViewController.present(mainController, animated:true) {
                    
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
