//
//  PDMainViewController.swift
//  PrinterDemo
//
//  Created by ios on 2019/9/6.
//  Copyright © 2019 XiamenHY. All rights reserved.
//

import UIKit

enum PDSectionIndex : Int {
    case device = 0
    case command
    case appendix
}

class PDMainViewController: PDBaseViewController {

    private lazy var tableView : UITableView = {
        let tw = UITableView(frame: CGRect.zero, style: UITableView.Style.grouped)
        tw.delegate = self
        tw.dataSource = self
        tw.backgroundColor = UIColor.white
        tw.showsVerticalScrollIndicator = false
        tw.separatorStyle = UITableViewCell.SeparatorStyle.singleLine
        return tw
    }()
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("11111111111111111111")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "iOS SDK"

        navigationItem.leftBarButtonItem = UIBarButtonItem.init(title: "Disconnect".localized, style: UIBarButtonItem.Style.plain, target: self, action: #selector(disconnectDevice))
        
        kUserDefaults.set(true, forKey: PDPaperType)
    }
    
    @objc private func disconnectDevice() {
        PTDispatcher.share()?.unconnectPrinter(PTDispatcher.share()?.printerConnected)
    }
    
    override func configUI() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints {
            $0.edges.equalTo(self.view.usnp.edges)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tableView.reloadRows(at: [IndexPath.init(row: 0, section: 0)], with: UITableView.RowAnimation.automatic)
        PTDispatcher.share().whenUnconnect { [weak self](_, flag) in
            guard let self = self else { return }
            self.tableView.reloadRows(at: [IndexPath.init(row: 0, section: 0)], with: UITableView.RowAnimation.automatic)
            SVProgressHUD.showInfo(withStatus: "Disconnected".localized)
            self.navigationController?.popToRootViewController(animated: true)
            PTDispatcher.share().sendSuccessBlock = nil
            PTDispatcher.share().sendFailureBlock = nil
            PTDispatcher.share().sendProgressBlock = nil
            PTDispatcher.share().connectFailBlock = nil
            PTDispatcher.share().connectSuccessBlock = nil
            PTDispatcher.share().readRSSIBlock = nil
            PTDispatcher.share()?.receiveDataBlock = nil
            
            if flag {
                print("Active disconnect")
            }else {
                print("Passive disconnect")
            }
        }
    }

}

extension PDMainViewController : UITableViewDelegate,UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return PDSectionIndex.appendix.rawValue + 1
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        var title = ""
        
        switch PDSectionIndex.init(rawValue: section)?.rawValue {
        case PDSectionIndex.device.rawValue:
            title = "目标设备"
        case PDSectionIndex.command.rawValue:
            title = "指令集"
        case PDSectionIndex.appendix.rawValue:
            title = "Appendix".localized
        case .none:
            title = ""
        case .some(_):
            title = ""
        }
         return title
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == PDSectionIndex.device.rawValue {
            return 1
        }
        if section == PDSectionIndex.command.rawValue {
            return 4
        }
        if section == PDSectionIndex.appendix.rawValue {
            return 2
        }
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "iden")
        
        if indexPath.section == 0 {
            if cell == nil {
                cell = UITableViewCell.init(style: UITableViewCell.CellStyle.subtitle, reuseIdentifier: "iden")
            }
            if cell != nil {
                if PTDispatcher.share()?.printerConnected == nil {
                    cell?.backgroundColor = UIColor(red: 0.8, green: 0.9, blue: 1.0, alpha: 1.0)
                    
                    cell?      .textLabel!.text = "未连接"
                    cell?.detailTextLabel!.text = ""
                    
                    cell?      .textLabel!.textColor = UIColor.theme
                    cell?.detailTextLabel!.textColor = UIColor.theme
                    
                    UIView.beginAnimations(nil, context: nil)
                    
                    cell?      .textLabel!.alpha = 0.0
                    cell?.detailTextLabel!.alpha = 0.0
                    
                    UIView.setAnimationDelay             (0.0)                             // 0mS!!!
                    UIView.setAnimationDuration          (0.6)                             // 600mS!!!
                    UIView.setAnimationRepeatCount       (Float(UINT32_MAX))
                    UIView.setAnimationRepeatAutoreverses(true)
                    UIView.setAnimationCurve             (UIView.AnimationCurve.easeIn)
                    
                    cell?      .textLabel!.alpha = 1.0
                    cell?.detailTextLabel!.alpha = 1.0
                    
                    UIView.commitAnimations()
                }else {
                    
                    if PTDispatcher.share()?.printerConnected.name.isEmpty ?? false {
                        cell?.textLabel?.text = "Connected".localized
                    }else {
                        if PTDispatcher.share()?.printerConnected.name == "unknown" || PTDispatcher.share()?.printerConnected.name == "Unknown" {
                            cell?.textLabel?.text = "Connected".localized
                        }else {
                            cell?.textLabel?.text = PTDispatcher.share()?.printerConnected.name
                        }
                        
                    }
                    cell?.textLabel?.textColor = UIColor.black
                }
                cell?.accessoryType = UITableViewCell.AccessoryType.disclosureIndicator
                cell?.isUserInteractionEnabled = true
            }
        }else {
            
            let cmdTypes = ["CPCL","ESC","TSPL","ZPL"]
            if indexPath.section == 1 {
                
                if cell == nil {
                    cell = UITableViewCell.init(style: UITableViewCell.CellStyle.subtitle, reuseIdentifier: "iden")
                }
                cell?      .textLabel!.text = cmdTypes[indexPath.row]
                cell?.detailTextLabel!.text = ""
                
                cell?      .textLabel!.textColor = UIColor.titleColor
                cell?.detailTextLabel!.textColor = UIColor.titleColor
                cell?.accessoryType = UITableViewCell.AccessoryType.disclosureIndicator
            }
            //版本信息-start
            let appdixs = ["Framework Version".localized,"Compile time".localized]
            if indexPath.section == 2 {
                
                if cell == nil {
                    cell = UITableViewCell.init(style: UITableViewCell.CellStyle.subtitle, reuseIdentifier: "iden")
                }
                
                cell?      .textLabel!.text = appdixs[indexPath.row]
                cell?.detailTextLabel!.text = ""
                
                cell?      .textLabel!.textColor = UIColor.black
                cell?.detailTextLabel!.textColor = UIColor.black
            }
            //版本信息-end
        }
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let selectedSection = PDSectionIndex.init(rawValue: indexPath.section)!
        switch (selectedSection,indexPath.row) {
        case (PDSectionIndex.device,0):
            showConnectType()
        case (PDSectionIndex.command, let row):
            if PTDispatcher.share()?.printerConnected == nil {
                UIAlertController.showActionAlert("Tips".localized, message: "Printer unconnected, pls. connect".localized, confirm: "OK".localized) { (_) in
                    self.showConnectType()
                }
            }else {
            
                if row == 0 {
                    let alert = UIAlertController(title: "Please select the type of paper you want to print".localized, message: nil, preferredStyle: .alert)
                    let continueAction = UIAlertAction.init(title: "Continuous paper".localized, style: UIAlertAction.Style.default) { (_) in
                        kUserDefaults.set(false, forKey: PDPaperType)
                        self.navigationController?.pushViewController(PDCPCLViewController(), animated: true)
                    }
                    
                    let labelAction = UIAlertAction.init(title: "Label".localized, style: UIAlertAction.Style.default) { (_) in
                        kUserDefaults.set(true, forKey: PDPaperType)
                        self.navigationController?.pushViewController(PDCPCLViewController(), animated: true)
                    }
                    alert.addAction(continueAction)
                    alert.addAction(labelAction)
                    self.present(alert, animated: true, completion: nil)
                }else if row == 1 {
                    self.navigationController?.pushViewController(PDESCViewController(), animated: true)
                }else if row == 2 {
                    self.navigationController?.pushViewController(PDTSPLViewController(), animated: true)
                }else if row == 3 {
                    self.navigationController?.pushViewController(PDZPLViewController(), animated: true)
                    
                }
            }
        case (PDSectionIndex.appendix,let row):
            
            if row == 0 {
                UIAlertController.showConfirmView("Framework Version".localized, message: "PrinterSDK version".localized + "3.2.5") { (_) in
                    
                }
            }else {
                UIAlertController.showConfirmView("Compile time".localized, message: PTDispatcher.share().sdkBuildTime()) { (_) in
                    
                }
            }
            
        default:
            break
        }
        
    }
}

//connect
extension PDMainViewController {
    
    private func showConnectType() {
//        dismiss(animated: true) {
//
//        }
        self.showAlert(title: "请选择一种连接方式", buttonTitles: ["蓝牙", "无线",], handler: { (selectedButtonIndex) in
            self.selectConnectType(index: selectedButtonIndex)
            self.navigationController?.popViewController(animated: true)
        })
//        navigationController?.pushViewController(PDMainViewController(), animated: true)
//        UIAlertController.showLessActionSheet(with: "Please select a connect type".localized, actionStr1: "Bluetooth Low Energy".localized, actionStr2: "Wi-Fi".localized, actionHandle1: { (_) in
//            self.pushBleController()
//        }) { (_) in
//            self.pushWifiController()
//        }
    }
    func selectConnectType(index:Int){
        switch index {
        case 1:
            self.pushBlueTypeController()
        case 2:
            self.pushWifiTypeController()
        default:
            //
            print("");
        }
    }
    
    private func pushBlueTypeController() {
        self.navigationController?.pushViewController(PDBLEViewController(), animated: true)
    }
    private func pushWifiTypeController() {
        navigationController?.pushViewController(PDBLEViewController(), animated: true)
    }
    
    @objc private func pushBleController() {
        navigationController?.pushViewController(PDBLEViewController(), animated: true)
    }
    
    @objc private func pushWifiController() {
        navigationController?.pushViewController(PDWiFiSelectIPViewController(), animated: true)
    }
}
