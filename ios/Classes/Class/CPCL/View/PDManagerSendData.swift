//
//  PDManagerSendData.swift
//  PrinterDemo
//
//  Created by ios on 2019/11/6.
//  Copyright © 2019 XiamenHY. All rights reserved.
//

import UIKit

class PDManagerSendData: NSObject {

    static var shared = PDManagerSendData()
    
    func sendDataToPeripheral(data:Data,_ showProgressHUD:Bool) {
        
        if PTDispatcher.share().printerConnected == nil {
            SVProgressHUD.showInfo(withStatus: "Printer unconnected, pls. connect".localized)
            return
        }
        
        if showProgressHUD {
            SVProgressHUD.show()
        }
        
        PTDispatcher.share().send(data)
        
        PTDispatcher.share()?.whenSendProgressUpdate({ (_) in
            //
        })
        
        PTDispatcher.share()?.whenSendSuccess({(_,_) in
            SVProgressHUD.showSuccess(withStatus: "Data sent successfully".localized)
        })
        
        PTDispatcher.share().whenSendFailure {
            SVProgressHUD.showError(withStatus: "Data send failed".localized)
        }
        
        PTDispatcher.share().whenReceiveData { (data) in
            guard let temp = data else { return }
            print(#line,temp.hexString)
            let str = String.init(data: temp, encoding: String.Encoding.ascii)
            SVProgressHUD.showSuccess(withStatus: str)
        }
        
    }
        
    func removeSDKAllBlcok() {
        PTDispatcher.share().sendSuccessBlock = nil
        PTDispatcher.share().sendFailureBlock = nil
        PTDispatcher.share().sendProgressBlock = nil
        PTDispatcher.share().connectFailBlock = nil
        PTDispatcher.share().connectSuccessBlock = nil
        PTDispatcher.share().readRSSIBlock = nil
        PTDispatcher.share().receiveDataBlock = nil
    }
}
