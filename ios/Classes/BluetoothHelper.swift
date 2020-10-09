//
//  BluetoothHelper.swift
//  AirBluetooth
//
//  Created by JamesAir on 2020/7/31.
//  Copyright © 2020 JamesAir. All rights reserved.
//

import Foundation
import CoreBluetooth

protocol BluetoothHelperDelegate {
    
    func bluetoothHelperIndex()->Int
    
    func bluetoothHelperNotifyConnected(isConnected:Bool)
    
    func bluetoothHelperAutoStopScan()
}

class BluetoothHelper :NSObject,CBCentralManagerDelegate,CBPeripheralDelegate{

    static let shared = BluetoothHelper()

    private var cm:CBCentralManager! = nil
    private var peripheral: CBPeripheral! = nil
    private var service:CBService! = nil

    private var characteristic:CBCharacteristic! = nil
    
    private var delegateDict = Dictionary<Int,BluetoothHelperDelegate>()
    
    public func registerDelegate(delegate:BluetoothHelperDelegate){
        delegateDict[delegate.bluetoothHelperIndex()] = delegate
    }
    
    public func unregisterDelegate(delegate:BluetoothHelperDelegate){
        delegateDict.removeValue(forKey: delegate.bluetoothHelperIndex())
    }
    
    private override init(){
        super.init()
        self.cm = CBCentralManager(delegate: self, queue: nil)
    }
    
    /// 被连接的打印机的名字
    var connectDeviceName:String? = ""
    
    /// 是否连接了打印机
    var isConnected:Bool = false{
        didSet{
            if(!isConnected){
                peripheral = nil
                service = nil
                characteristic = nil
                connectDeviceName = nil
                
                delegateDict.forEach({ (key,delegate) in
                    
                })
            }else{
                connectDeviceName = self.name
            }
        }
    }
    
    /// 蓝牙开关是否打开
    var btOpen = false
    private var name = "QSPrinter"

    // 后面是代理方法
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        NSLog("状态变化")
        if(central.state.rawValue == 5){
            btOpen = true
        }else{
            btOpen = false
            isConnected = false
        }
    }
    
    /// 开始扫描设备
    func startScan(name:String){
        self.name = name
        self.cm.stopScan()
        self.cm.scanForPeripherals(withServices: nil, options: nil)
//        runDelay(5) {
//            self.delegateDict.forEach({ (_,delegate) in
//                self.cm.stopScan()
//                delegate.bluetoothHelperAutoStopScan()
//            })
//        }
        
        self.delegateDict.forEach({ (_,delegate) in
            self.cm.stopScan()
            delegate.bluetoothHelperAutoStopScan()
        })
    }
    
    /// 停止扫描设备
    func stopScan(){
        self.cm.stopScan()
    }
    
    /// 关闭连接设备
    func disconnect(){
        if(peripheral != nil){
            self.cm.cancelPeripheralConnection(peripheral)
        }
    }

    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String: Any], rssi RSSI: NSNumber) {
        NSLog("\(String(describing: peripheral.name)) is discovered")
        if(peripheral.name?.uppercased() == name.uppercased()){
            self.peripheral = peripheral
            peripheral.delegate = self
            cm.connect(peripheral)
            cm.stopScan()
        }
    }

    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        NSLog("\(String(describing: peripheral.name)) 连接成功")
        let uuid = CBUUID(string: "18F0")
        peripheral.discoverServices([uuid])
    }

    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        NSLog("\(String(describing: peripheral.name)) 连接断开")
        isConnected = false
    }

    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        print("peripheral");
        if let service = peripheral.services?[0]{
            let uuid = CBUUID(string: "2AF1")
            peripheral.discoverCharacteristics([uuid], for: service)
            self.service = service
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        if let characteristic = service.characteristics?[0]{
            NSLog("characteristic is prepared")
            isConnected = true
            self.characteristic = characteristic
        }
    }

    /// 输出字符串
    func writeText(text:String)throws{
        let enc = CFStringConvertEncodingToNSStringEncoding(CFStringEncoding(CFStringEncodings.GB_18030_2000.rawValue))

        if let data = text.data(using: String.Encoding(rawValue: enc)){
            do {
               try self.writeData(data: data)
            } catch  {
                throw error
            }
        }
    }
    
    
    private var datas = [Data]()
    
    /// 写入数据
    func writeData(data:Data) throws {
        if(isConnected){
            datas.append(data)
        }else{
            throw BtError.NoConnectError
        }
    }
    
    /// 真实的打印方法
    func printByBluetooth(){
        for index in 0 ... datas.count - 1  {
            let item = datas[index]
//            runDelay(0.02 * Double(index), {
//                self.peripheral.writeValue(item, for: self.characteristic, type: CBCharacteristicWriteType.withoutResponse)
//            })
            self.peripheral.writeValue(item, for: self.characteristic, type: CBCharacteristicWriteType.withoutResponse)
        }
        self.datas.removeAll()
    }

}

enum BtError :Error{
    case NoConnectError
}
