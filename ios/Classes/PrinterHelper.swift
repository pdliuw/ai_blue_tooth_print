//
//  PrinterHelper.swift
//  AirBluetooth
//
//  Created by JamesAir on 2020/7/31.
//  Copyright © 2020 JamesAir. All rights reserved.
//

import Foundation
import CoreBluetooth

import Foundation

extension Data{
    
    static func bytesArray(bytes:UInt8 ...) -> Data{
        var data = Data()
        data.append(contentsOf: bytes)
        return data
    }
    
    static func bytesArray(byteArray: [UInt8]) -> Data{
        var data = Data()
        data.append(contentsOf: byteArray)
        return data
    }
    
    static func gbkData(text:String) -> Data?{
        let enc = CFStringConvertEncodingToNSStringEncoding(CFStringEncoding(CFStringEncodings.GB_18030_2000.rawValue))
        return text.data(using: String.Encoding(rawValue: enc))
    }
    
}

typealias Byte = UInt8
/// printer helper
///
/// single instance
class PrinterHelper{
    
    static var shared:PrinterHelper = PrinterHelper()
    
    var helper : BluetoothHelper!
    
    //    var devices = [Printer]()
    
    private init(){
        helper = BluetoothHelper.shared
    }

    func registerDelegate(delegate: BluetoothHelperDelegate){
        helper.registerDelegate(delegate: delegate)
    }
    
    func unregisterDelegate(delegate: BluetoothHelperDelegate){
        helper.unregisterDelegate(delegate: delegate)
    }
    
    var index = 0
    
    let DIVIDER = "-----------------------------------------------"
    let ESC: Byte = 27//换码
    let FS: Byte = 28//文本分隔符
    let GS: Byte = 29//组分隔符
    let DLE: Byte = 16//数据连接换码
    let EOT: Byte = 4//传输结束
    let ENQ: Byte = 5//询问字符
    let SP: Byte = 32//空格
    let HT: Byte = 9//横向列表
    let LF: Byte = 10//打印并换行（水平定位）
    let CR: Byte = 13//归位键
    let FF: Byte = 12//走纸控制（打印并回到标准模式（在页模式下）
    let CAN: Byte = 24//作废（页模式下取消打印数据 ）
    
    func conn(deviceName:String){
        helper.startScan(name: deviceName)
    }
    
    func disconnect(){
        helper.disconnect()
    }
    
    func sendMsg(msg:String) -> Self{
        try? helper.writeText(text: msg)
        return self
    }
    
    func sendBytes(bytes:[Byte]) -> Self{
        
        
        try? helper.writeData(data: Data.bytesArray(byteArray: bytes))
        return self
    }
    
    func sendHex(int:Int) -> Self {
        return self.sendHexs(hexInt: int)
    }
    
    func sendHexs(hexInt ints:Int...) -> Self{
        var data = Data()
        ints.forEach { (int) in
            data.append(UInt8(int))
        }
        try? helper.writeData(data: data)
        return self
    }
    
    func sendBytes(bytes:Byte...) -> Self{
        return sendBytes(bytes: bytes)
    }
    
    func alignLeft()-> Self{
        return sendBytes(bytes: ESC,97,0)
    }
    
    func alignCenter() -> Self {
        return sendBytes(bytes: ESC,97,1)
    }
    
    func alignRight() -> Self{
        return sendBytes(bytes: ESC,97,2)
    }
    
    func printDivider() -> Self {
        return sendMsg(msg: DIVIDER)
    }
    
    
    func startPrint(){
        helper.printByBluetooth()
    }
    
    func setFontSize(size:Int)  -> Self{
        var realSize: Byte = 0
        
        if(size <= 7){
            realSize = Byte(size * 17)
        }
        
        var result = [Byte]()
        result.append(0x1D)
        result.append(0x21)
        result.append(realSize)
        print("size = \(size)  realSize = \(realSize)")
        return sendBytes(bytes: result)
    }
    
    func newLine(lines:Int = 1) -> Self{
        for _ in 0...lines - 1{
            _ = sendHex(int: 0x0A)
        }
        return self
    }
    
    /**
     * 选择加粗模式
     
     * @return
     */
    func boldOn() -> Self {
        var result = [Byte]()
        result.append(ESC)
        result.append(69)
        result.append(0xF)
        return sendBytes(bytes: result)
    }
    
    
    /**
     * 取消加粗模式
     
     * @return
     */
    func boldOff() -> Self {
        var result = [Byte]()
        result.append(ESC)
        result.append(69)
        result.append(0)
        return sendBytes(bytes: result)
    }
    
    func subTitle(_ title:String) -> Self{
        return
            self.newLine()
                .setFontSize(size: 1)
                .boldOn()
                .alignCenter()
                .sendMsg(msg: title)
                .setFontSize(size: 0)
                .boldOff()
    }
    
//    func sendQrcode(qrcode:String) -> Self{
//        let moduleSize:Byte = 8
//        var list = [Byte]()
//
//        if let data = Data.gbkData(text: qrcode){
//
//            //打印二维码矩阵
//            list.append(0x1D)// init
//            list.append(40) // adjust height of barcode
//            list.append(107)// adjust height of barcode
//            list.append(Byte(data.count + 3)) // pl
//            list.append(0) // ph
//            list.append(49) // cn
//            list.append(80) // fn
//            list.append(48) //
//
//            data.forEach({ (char) in
//                list.append(char)
//            })
//
//            list.append(0x1D)
//            list.append(40)// list.append("(k")
//            list.append(107)// list.append("(k")
//            list.append(3)
//            list.append(0)
//            list.append(49)
//            list.append(69)
//            list.append(48)
//
//            list.append(0x1D)
//            list.append(40)// list.append("(k")
//            list.append(107)// list.append("(k")
//            list.append(3)
//            list.append(0)
//            list.append(49)
//            list.append(67)
//            list.append(moduleSize)
//
//            list.append(0x1D)
//            list.append(40)// list.append("(k")
//            list.append(107)// list.append("(k")
//            list.append(3) // pl
//            list.append(0) // ph
//            list.append(49) // cn
//            list.append(81) // fn
//            list.append(48) // m
//        }
//
//        return
//            alignCenter()
//            .sendBytes(bytes: list)
//    }
}

