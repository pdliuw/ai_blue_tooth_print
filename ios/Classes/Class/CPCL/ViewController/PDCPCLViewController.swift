//
//  PDCPCLViewController.swift
//  PrinterDemo
//
//  Created by ios on 2019/9/6.
//  Copyright © 2019 XiamenHY. All rights reserved.
//

import UIKit

enum PDDocumentPickerView {
    case commandDocument
    case firmwareBin
}

public struct PDSettingItem {
    
    var title: String
    var detailTitle: String?
    weak var target: NSObject?
    var selector: Selector?
}

class PDCPCLViewController: PDBaseViewController {

    lazy var tableView : UITableView = {
        let temp = UITableView.init(frame: .zero, style: .plain)
        temp.delegate = self
        temp.dataSource = self
        temp.backgroundColor = .white
        temp.rowHeight = 50.0
        temp.showsVerticalScrollIndicator = false
        temp.separatorStyle = UITableViewCell.SeparatorStyle.singleLine
        return temp
    }()
    
    private var functions = [PDSettingItem]()
    var selectDocumentType = PDDocumentPickerView.commandDocument
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "CPCL function".localized
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints {
            $0.edges.equalTo(self.view.usnp.edges)
        }
        
        PTDispatcher.share().whenUpdatePrintState({ (state) in
            print(#line,"\(state)")
            if state == .success {
                SVProgressHUD.showSuccess(withStatus: "Print Success".localized)
                
            } else if state == PTPrintState.failureLidOpen {
                SVProgressHUD.showInfo(withStatus: "Print fail (LidOpe)".localized)
                
            } else if state == PTPrintState.failurePaperEmpty {
                SVProgressHUD.showInfo(withStatus: "Print fail (PaperEmpty)".localized)
            }
        })
        
        loadDataSource()
    }
    
    private func loadDataSource() {
        
        functions.removeAll()
        var item : PDSettingItem
        
        item = PDSettingItem.init(title: "Custom text Sample".localized, detailTitle: nil, target: self, selector: #selector(pushAutoTextVC))
        functions.append(item)
        
        item = PDSettingItem.init(title: "Device Status Sample".localized, detailTitle: nil, target: nil, selector: #selector(PDCPCLTestFunctions.testPrinterStatus))
        functions.append(item)
        
        item = PDSettingItem.init(title: "Self-test page Sample".localized, detailTitle: nil, target: nil, selector: #selector(PDCPCLTestFunctions.printSelfTestPage))
        functions.append(item)
        
        item = PDSettingItem.init(title: "Printer serial number".localized, detailTitle: nil, target: nil, selector: #selector(PDCPCLTestFunctions.getPrinterSN))
        functions.append(item)
        
        item = PDSettingItem.init(title: "Printer firmware version number".localized, detailTitle: nil, target: nil, selector: #selector(PDCPCLTestFunctions.getPrinterFirmwareVersion))
        functions.append(item)
        
        item = PDSettingItem.init(title: "Font Sample".localized, detailTitle: nil, target: nil, selector: #selector(PDCPCLTestFunctions.testPrinterFont))
        functions.append(item)
        
        //区分A400 A300S的机子和3寸机子
        if kUserDefaults.integer(forKey: PDPrintDots) == 832 {
            item = PDSettingItem.init(title: "Text Sample".localized, detailTitle: nil, target: nil, selector: #selector(PDCPCLTestFunctions.printText))
            functions.append(item)
            
            item = PDSettingItem.init(title: "Set Paper Type Sample".localized, detailTitle: nil, target: nil, selector: #selector(PDCPCLTestFunctions.testPaperType))
            functions.append(item)
        }else {
            item = PDSettingItem.init(title: "Text Sample".localized, detailTitle: nil, target: nil, selector: #selector(PDCPCLTestFunctions.testCpclText))
            functions.append(item)
            
            
//            item = PDSettingItem.init(title: "Set Paper Type Sample".localized, detailTitle: nil, target: nil, selector: #selector(PDCPCLTestFunctions.testPaperTypeFor3Inch))
//            functions.append(item)
        }
        
        
        item = PDSettingItem.init(title: "Barcode Sample".localized, detailTitle: nil, target: nil, selector: #selector(PDCPCLTestFunctions.testBarcode))
        functions.append(item)
        
        item = PDSettingItem.init(title: "QRcode Sample".localized, detailTitle: nil, target: nil, selector: #selector(PDCPCLTestFunctions.testQRcode))
        functions.append(item)
        
        item = PDSettingItem.init(title: "Bitmap Sample".localized, detailTitle: nil, target: self, selector: #selector(self.pushSystenPhoto))
        functions.append(item)
        
        item = PDSettingItem.init(title: "Background Text Sample".localized, detailTitle: nil, target: nil, selector: #selector(PDCPCLTestFunctions.printBackGroundText))
        functions.append(item)
        
        item = PDSettingItem.init(title: "Express template".localized, detailTitle: nil, target: nil, selector: #selector(PDCPCLTestFunctions.testCpclModel))
        functions.append(item)
        
        item = PDSettingItem.init(title: "ZTO Sample".localized, detailTitle: nil, target: nil, selector: #selector(PDCPCLTestFunctions.testZTOSample))
        functions.append(item)
        
        item = PDSettingItem.init(title: "Command File Print".localized, detailTitle: nil, target: self, selector: #selector(self.selectDocument))
        functions.append(item)
        
        item = PDSettingItem.init(title: "OTA upgrade".localized, detailTitle: nil, target: self, selector: #selector(self.updateOTABleFirmware))
        functions.append(item)
        
        item = PDSettingItem.init(title: "Set QRCode version".localized, detailTitle: nil, target: self, selector: #selector(self.pushQRCodeVC))
        functions.append(item)
    }

}

extension PDCPCLViewController {
    
    @objc func pushAutoTextVC() {
        self.navigationController?.pushViewController(PDPrintTextViewController(with: PTCommandType.CPCL), animated: true)
    }
    
    @objc func pushQRCodeVC() {
        self.navigationController?.pushViewController(PDQRCodeVersionViewController(), animated: true)
    }
    
    //MARK:print image
    @objc func pushSystenPhoto() {
        
        let photoPickerVC = PDPhotoListViewController.init(with: PTCommandType.CPCL)
        navigationController?.pushViewController(photoPickerVC, animated: true)
    }
    
    @objc func selectDocument() {
        
        self.selectDocumentType = PDDocumentPickerView.commandDocument
        let picker = UIDocumentPickerViewController.init(documentTypes: ["public.data"], in: .import)
        picker.delegate = self
        picker.modalPresentationStyle = .fullScreen
        if #available(iOS 11.0, *) {
            picker.allowsMultipleSelection = false
        } else {
            // Fallback on earlier versions
        }
        self.present(picker, animated: true, completion: nil)
    }
    
    @objc func updateOTABleFirmware() {
        
        UIAlertController.showActionAlert("Tips".localized, message: "This function is only for some models that can upgrade the Bluetooth firmware. Please confirm whether your printer supports the function".localized, confirm: "OK".localized) { (_) in
            self.selectDocumentType = PDDocumentPickerView.firmwareBin
            let picker = UIDocumentPickerViewController.init(documentTypes: ["public.data"], in: .import)
            picker.delegate = self
            picker.modalPresentationStyle = .fullScreen
            if #available(iOS 11.0, *) {
                picker.allowsMultipleSelection = false
            } else {
                // Fallback on earlier versions
            }
            self.present(picker, animated: true, completion: nil)
        }
        
    }
}

extension PDCPCLViewController: UIDocumentPickerDelegate {
    
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentAt url: URL) {
        
        sendData(from: url)
    }
    
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        
        sendData(from: urls[0])
    }
    
    func sendData(from url: URL) -> Void {
        
        switch self.selectDocumentType {
            case .commandDocument:
                print("1")
                let alertControl = UIAlertController(title: "Tips".localized, message: "Please select the mode of sending data".localized, preferredStyle: UIAlertController.Style.alert)
                alertControl.addTextField { (textTF) in
                    textTF.placeholder = "Please enter the number of copies".localized
                }
                
                let cancel = UIAlertAction(title: "Cancel".localized, style: UIAlertAction.Style.cancel, handler: nil)
                let strConfirm = UIAlertAction(title: "Text mode".localized, style: UIAlertAction.Style.default) { [weak alertControl](_) in
                    guard let alert = alertControl else { return }
                    guard let position = alert.textFields?.first, var temp = position.text else { return }
                    if temp.isEmpty {
                        temp = "1"
                    }
                    
                    if let resultInt = Int(temp) {
                        
                        guard let data = try? Data.init(contentsOf: url) else {
                            SVProgressHUD.showError(withStatus: "Get File failed".localized)
                            return
                        }
                        
                        guard let utf_string = PTEncode.decodeString(with: data) else {
                            SVProgressHUD.showInfo(withStatus: "The file is not supported".localized)
                            return
                        }
                        
                        guard let fileData = PTEncode.encodeData(with: utf_string) else {
                            SVProgressHUD.showInfo(withStatus: "The file is not supported".localized)
                            return
                        }
                        
                        var sendData = Data()
                        
                        for _ in 0..<resultInt {
                            sendData.append(fileData)
                        }
                        
                        PTDispatcher.share()?.send(sendData)
                        PTDispatcher.share()?.whenSendFailure({
                            SVProgressHUD.showError(withStatus: "Data send failed".localized)
                        })
                        
                        PTDispatcher.share()?.whenSendSuccess({(_,_) in
                            SVProgressHUD.showSuccess(withStatus: "Data sent successfully".localized)
                        })
                        
                        PTDispatcher.share()?.whenSendProgressUpdate({
                            SVProgressHUD.showProgress($0!.floatValue)
                        })
                        
                    }else {
                        SVProgressHUD.showError(withStatus: "Incorrect input, please re-enter".localized)
                    }
                }
                
                let hexConfirm = UIAlertAction(title: "Hex mode".localized, style: UIAlertAction.Style.default) { [weak alertControl](_) in
                    guard let alert = alertControl else { return }
                    guard let position = alert.textFields?.first, var temp = position.text else { return }
                    if temp.isEmpty {
                        temp = "1"
                    }
                    
                    if let resultInt = Int(temp) {
                        
                        guard let data = try? Data.init(contentsOf: url) else {
                            SVProgressHUD.showError(withStatus: "Get File failed".localized)
                            return
                        }

                        guard let utf_string = PTEncode.decodeString(with: data) else {
                            SVProgressHUD.showInfo(withStatus: "The file is not supported".localized)
                            return
                        }

                        guard let fileData = try? utf_string.hexStringToData() else {
                            SVProgressHUD.showInfo(withStatus: "Irregular HEX data".localized)
                            return
                        }
                        
                        var sendData = Data()
                        
                        for _ in 0..<resultInt {
                            sendData.append(fileData)
                        }
                        
                        PTDispatcher.share()?.send(sendData)
                        PTDispatcher.share()?.whenSendFailure({
                            SVProgressHUD.showError(withStatus: "Data send failed".localized)
                        })
                        
                        PTDispatcher.share()?.whenSendSuccess({(_,_) in
                            SVProgressHUD.showSuccess(withStatus: "Data sent successfully".localized)
                        })
                        
                        PTDispatcher.share()?.whenSendProgressUpdate({
                            SVProgressHUD.showProgress($0!.floatValue)
                        })
                        
                    }else {
                        SVProgressHUD.showError(withStatus: "Incorrect input, please re-enter".localized)
                    }
                }
                
                alertControl.addAction(strConfirm)
                alertControl.addAction(hexConfirm)
                alertControl.addAction(cancel)
                self.present(alertControl, animated: true, completion: nil)
            
            case .firmwareBin:
                print("2")
                
                UIAlertController.showActionAlert("Tips".localized, message: "Are you sure to upgrade the Bluetooth firmware?".localized, confirm: "OK".localized) { (_) in
                    
                    guard let data_ota = try? Data.init(contentsOf: url) else {
                        SVProgressHUD.showError(withStatus: "Get File failed".localized)
                        return
                    }
                    
                    let cmd = PTCommandCommon.init()
                    cmd.updateOTABleFirmware(with: data_ota as Data)
                    PTDispatcher.share()?.send(cmd.cmdData as Data)
                    
                    //寻找打印机型号-OTA[mac地址后三位]的蓝牙名称
                    guard let macArrays = PTDispatcher.share()?.printerConnected.mac.components(separatedBy: ":") else { return }
                    let macSuffix = String.init(format: "%@%@%@", macArrays[3],macArrays[4],macArrays[5])
                    
                    SVProgressHUD.show(withStatus: "Prepare to enter OTA upgrade mode".localized)
                    PTDispatcher.share()?.whenUnconnect({ (_, _) in
                        SVProgressHUD.show(withStatus: "OTA connection".localized)
                        PTDispatcher.share().scanBluetooth()
                    })
                    
                    PTDispatcher.share()?.whenFindAllBluetooth({ (array) in
                        for printer in array as! [PTPrinter] {
                            //自动连接后会自动开始升级
                            if printer.name.contains(String.init(format: "-OTA[%@]", macSuffix)) {
                                PTDispatcher.share().connect(printer)
                            }
                        }
                    })
                    
                    PTDispatcher.share()?.whenConnectSuccess({
                        
                        SVProgressHUD.show(withStatus: "OTA upgrade...".localized)
                        PTDispatcher.share().whenSendProgressUpdate { (num) in
                            guard let temp = num else { return }
                            SVProgressHUD.showProgress(Float.init(truncating: temp))
                        }
                        
                        //这边重新调用断开连接接口，防止上面调用
                        PTDispatcher.share()?.whenUnconnect({ (_, _) in
                            print("断开连接了哦")
                            self.navigationController?.popViewController(animated: true)
                        })
                    })
                    
                    PTDispatcher.share()?.whenUpgradeFirmwareStateBlock({ (state) in
                        SVProgressHUD.dismiss()
                        switch state {
                        case .success:
                            UIAlertController.showConfirmView("Tips".localized, message: "The upgrade is successful. Please restart the printer before using".localized, confirmHandle: nil)
                        case .fail:
                            UIAlertController.showConfirmView("Tips".localized, message: "Upgrade failed, please restart the printer before upgrading".localized, confirmHandle: nil)
                        default:
                            break
                        }
                    })
                    
                }
        }
    }
}

extension PDCPCLViewController : UITableViewDelegate,UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return functions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCell(withIdentifier: "iden")
        if cell == nil {
            cell = UITableViewCell.init(style: UITableViewCell.CellStyle.subtitle, reuseIdentifier: "iden")
        }
        cell?.textLabel?.text = functions[indexPath.row].title
        cell?.textLabel?.textColor = UIColor.black
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let action = functions[indexPath.row]
        if let target = action.target {
            if let selector = action.selector {
                target.perform(selector)
            }
        }else {
            if let selector = action.selector {
                PDCPCLTestFunctions.perform(selector)
            }
        }
    }
}

//Printer Status
struct PDPrinterCPCLStatusOptionSet : OptionSet,CustomStringConvertible {
    
    var rawValue: UInt8
    typealias RawValue = UInt8
    
    static let busy = PDPrinterCPCLStatusOptionSet.init(rawValue: 1<<0)
    static let paperEnd = PDPrinterCPCLStatusOptionSet.init(rawValue: 1<<1)
    static let openCover = PDPrinterCPCLStatusOptionSet.init(rawValue: 1<<2)
    static let lowVoltage = PDPrinterCPCLStatusOptionSet.init(rawValue: 1<<3)
    
    var description: String {
        
        var messages = [String]()
        if contains(.busy) {
            messages.append("Busy".localized)
        }
        
        if contains(.paperEnd) {
            messages.append("Out of paper".localized)
        }
        
        if contains(.openCover) {
            messages.append("Open".localized)
        }
        
        if contains(.lowVoltage) {
            messages.append("Battery is Low".localized)
        }
        
        if messages.count == 0 {
            messages.append("Ready".localized)
        }
        return  messages.joined(separator: "--")
    }
}


