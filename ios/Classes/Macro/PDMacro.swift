//
//  PDMacro.swift
//  PrinterDemo
//
//  Created by ios on 2019/9/5.
//  Copyright © 2019 XiamenHY. All rights reserved.
//

import Foundation
import SnapKit
import UIKit

let kScreenHeight = UIScreen.main.bounds.size.height
let kScreenWidth = UIScreen.main.bounds.size.width
let kSafeAreaBottomHeight:CGFloat  = (((kScreenHeight == 812.0 ) || (kScreenHeight == 896.0)) ? 34 : 0)
let kSafeAreaTopHeight:CGFloat = (((kScreenHeight == 812.0 ) || (kScreenHeight == 896.0)) ? 88 : 64)
let kSystemVersion = (UIDevice.current.systemVersion as NSString).floatValue
let kStatusBarHeight = UIApplication.shared.statusBarFrame.size.height
let kMainScreenScale = UIScreen.main.scale
let kTabbarHeight = 49
let kNabBarHeight = 44
let kNavgationHeight = (CGFloat(kStatusBarHeight) + CGFloat(kNabBarHeight))
let kUserDefaults = UserDefaults.standard
let kNotife = NotificationCenter.default
let kAppVersion = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString")
let kUUID =  UIDevice.current.identifierForVendor?.uuidString.replacingOccurrences(of: "-", with: "")
let PDAppWindow = UIApplication.shared.delegate!.window!!
let PDRatioWidth = kScreenWidth / 375.0

struct kDirectoryPath {
    static let Documents = NSSearchPathForDirectoriesInDomains(.documentDirectory,.userDomainMask, true).last
    static let Library = NSSearchPathForDirectoriesInDomains(.libraryDirectory,.userDomainMask, true).last
    static let Tmp = NSTemporaryDirectory()
    static let Caches = NSSearchPathForDirectoriesInDomains(.cachesDirectory,.userDomainMask, true).last
}


func DLog<T>(message : T,file : String = #file,function:String = #function, lineNumber : Int = #line) {
    #if DEBUG
    let fileName = (file as NSString).lastPathComponent
    print("Log：[\(fileName) | \(function) | lineNum:\(lineNumber)] \n \(message)")
    #endif
}

func kRGBCOLOR(r:CGFloat,g:CGFloat,b:CGFloat) -> UIColor{
    return UIColor(red:  r/255.0, green: g/255.0, blue:  b/255.0, alpha: 1)
}

func kRGBACOLOR(r:CGFloat,g:CGFloat,b:CGFloat, a:CGFloat) -> UIColor{
    return UIColor(red:  r/255.0, green: g/255.0, blue:  b/255.0, alpha: a)
}

//RGB 16进制转换
func KRGBHEXCOLOR(rgbValue: UInt) -> UIColor {
    return UIColor(
        red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
        green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
        blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
        alpha: CGFloat(1.0)
    )
}

func PDWidth_pt(x:CGFloat) -> CGFloat {
    return PDRatioWidth * x
}

//MARK: SnapKit
extension ConstraintView {
    
    var usnp: ConstraintBasicAttributesDSL {
        if #available(iOS 11.0, *) {
            return self.safeAreaLayoutGuide.snp
        } else {
            return self.snp
        }
    }
}

public let PDPaperType = "PD_PAPER_TYPE"
public let PDWiFiIP = "PD_WIFI_IP"
public let PDPrintDots = "PDPrintDots"
