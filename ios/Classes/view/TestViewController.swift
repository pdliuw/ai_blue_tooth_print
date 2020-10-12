//
//  TestViewController.swift
//  ai_blue_tooth_print
//
//  @author JamesAir on 2020
//

import Foundation
import UIKit
import CoreBluetooth


class TestViewController: PDBaseViewController, CBCentralManagerDelegate{
    
    var mCentralManager:CBCentralManager?
    var mBluetoothStateButton = UIButton(type: UIButton.ButtonType.system);
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        switch central.state {
        case CBManagerState.poweredOff:
            mBluetoothStateButton.setTitle("蓝牙状态:关闭", for: UIControl.State.normal)
            print("蓝牙关闭状态");
            break;
            
        case CBManagerState.poweredOn:
            mBluetoothStateButton.setTitle("蓝牙状态:开启", for: UIControl.State.normal)
            
            //搜索所有设备
            mCentralManager?.scanForPeripherals(withServices: nil, options: nil);
            
            
            print("蓝牙打开状态");
            break;
        default:
            
            break;
        }
    }
    
        func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
            
            print("搜索设备:\(peripheral.name ?? "未知"),\(peripheral)")
//            print("搜索设备： \(peripheral.services)");
//            print("搜索Data： \(advertisementData)");
//            print("搜索Number： \(RSSI)");
            
        }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mCentralManager = CBCentralManager.init(delegate:self,queue:nil);
        
        view.backgroundColor = kRGBACOLOR(r: 242, g: 242, b: 242, a: 1)

        
        print("add viewDidLoad");
        
        let button = UIButton(type: UIButton.ButtonType.system);
        button.frame = CGRect(x: 10, y: 10, width: 100, height: 40);
        button.setTitle("连接设备", for: UIControl.State.normal)
        
        button.setTitleColor(UIColor.blue, for: UIControl.State.normal)
        button.backgroundColor = UIColor.white
        
        button.addTarget(self, action: #selector(connectDevice(button:)), for: UIControl.Event.touchUpInside)
        
        view.addSubview(button);
        
//        addBluetoothStateView();
        
    }
    
    private func addBluetoothStateView(){
        
        mBluetoothStateButton.frame = CGRect(x: 10, y: 10, width: 100, height: 40);
        mBluetoothStateButton.setTitle("蓝牙状态", for: UIControl.State.normal)
        
        mBluetoothStateButton.setTitleColor(UIColor.blue, for: UIControl.State.normal)
        mBluetoothStateButton.backgroundColor = UIColor.white
        
//        mBluetoothStateButton.addTarget(self, action: #selector(connectDevice(button:)), for: UIControl.Event.touchUpInside)
        
        view.addSubview(mBluetoothStateButton);
    }
    
    
    
    @objc func connectDevice(button:UIButton){
        print("跳转页面");
        navigationController?.present(PDMainViewController(), animated: true, completion: {
            
        });
        
        
    }
    

    func kRGBACOLOR(r:CGFloat,g:CGFloat,b:CGFloat, a:CGFloat) -> UIColor{
        return UIColor(red:  r/255.0, green: g/255.0, blue:  b/255.0, alpha: a)
    }
}
