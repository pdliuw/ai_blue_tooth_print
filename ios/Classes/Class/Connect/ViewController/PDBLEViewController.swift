//
//  PDBLEViewController.swift
//  PrinterDemo
//
//  Created by ios on 2019/9/9.
//  Copyright © 2019 XiamenHY. All rights reserved.
//

import UIKit
import SwiftUI

class PDBLEViewController: PDBaseViewController {


    var encoding = CFStringConvertEncodingToNSStringEncoding(CFStringEncoding(CFStringEncodings.GB_18030_2000.rawValue))
    
    private var dataSources = [PTPrinter]()
    
    lazy var tableView : UITableView = {
        let temp = UITableView.init(frame: .zero, style: .grouped)
        temp.delegate = self
        temp.dataSource = self
        temp.backgroundColor = .white
        temp.rowHeight = 60.0
        temp.showsVerticalScrollIndicator = false
        temp.separatorStyle = UITableViewCell.SeparatorStyle.singleLine
        return temp
    }()
    
    lazy var mj_header: MJRefreshNormalHeader = {
        let temp = MJRefreshNormalHeader.init(refreshingTarget: self, refreshingAction: #selector(loadBLE))
        temp.setTitle("正在扫描周围蓝牙".localized, for: MJRefreshState.refreshing)
        temp.stateLabel?.textColor = UIColor.gray
        temp.lastUpdatedTimeLabel?.isHidden = true
        temp.activityIndicatorViewStyle = UIActivityIndicatorView.Style.gray
        return temp
    }()
    
    lazy var sendBtn : UIButton = {
        let temp = UIButton.init()
        temp.backgroundColor = UIColor.theme
        temp.setTitle("发送", for: .normal)
        temp.setTitleColor(UIColor.white, for: .normal)
        temp.setTitleColor(UIColor.black, for: .highlighted)
        temp.clipsToBounds = true
        temp.layer.cornerRadius = 10
        temp.layer.borderColor = UIColor.theme.cgColor
        temp.layer.borderWidth = 0.5
        temp.addTarget(self, action: #selector(PDBLEViewController.sendDataToPeripheral), for: .touchUpInside)
        return temp
    }()
    
    lazy var backButton : UIButton = {
        let temp = UIButton.init()
        temp.backgroundColor = UIColor.theme
        temp.setTitle("返回", for: .normal)
        temp.setTitleColor(UIColor.white, for: .normal)
        temp.setTitleColor(UIColor.black, for: .highlighted)
        temp.clipsToBounds = true
        temp.layer.cornerRadius = 10
        temp.layer.borderColor = UIColor.theme.cgColor
        temp.layer.borderWidth = 0.5
        temp.addTarget(self, action: #selector(PDBLEViewController.popViewController), for: .touchUpInside)
        return temp
    }()
    lazy var searchButton : UIButton = {
        let temp = UIButton.init()
        temp.backgroundColor = UIColor.theme
        temp.setTitle("搜索", for: .normal)
        temp.setTitleColor(UIColor.white, for: .normal)
        temp.setTitleColor(UIColor.black, for: .highlighted)
        temp.clipsToBounds = true
        temp.layer.cornerRadius = 10
        temp.layer.borderColor = UIColor.theme.cgColor
        temp.layer.borderWidth = 0.5
        temp.addTarget(self, action: #selector(PDBLEViewController.loadBLE), for: .touchUpInside)
        return temp
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //测试-start
        let  item_one = UIBarButtonItem(title: "", style: UIBarButtonItem.Style.done, target: self, action: nil)
        //第二种
        let  item_two = UIBarButtonItem(title: "蓝牙", style: UIBarButtonItem.Style.done, target: self, action: nil)

        let  sepace  = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: self, action: nil)
        self.navigationController?.isToolbarHidden = true
        let  Tool_ZSJ = UIToolbar(frame: CGRect(x: 10,y: 100,width: self.view.frame.size.width-20 ,height: 200))

                //再将创建的  5个按钮添加到  Tool_ZSJ 上面
                Tool_ZSJ.setItems([item_one,sepace,item_two,sepace], animated: true)

                //然后，再将工具栏添加到 主控制器的View上面
//                self.view.addSubview(Tool_ZSJ)
        
        let linearLayout = UIStackView.init(frame: self.view.frame);
        linearLayout.axis = NSLayoutConstraint.Axis.vertical
        linearLayout.distribution = UIStackView.Distribution.fill
        linearLayout.alignment = UIStackView.Alignment.fill
        
        Tool_ZSJ.backgroundColor = .blue
        
        
        
        //bottom view
        let bottomLinearLayout = UIStackView.init();
        bottomLinearLayout.axis = NSLayoutConstraint.Axis.horizontal
        bottomLinearLayout.distribution = UIStackView.Distribution.fillEqually
        bottomLinearLayout.alignment = UIStackView.Alignment.fill
        bottomLinearLayout.spacing = 20
        bottomLinearLayout.addArrangedSubview(backButton)
        bottomLinearLayout.addArrangedSubview(searchButton)
        bottomLinearLayout.addArrangedSubview(sendBtn)
        
        
//        linearLayout.addArrangedSubview(bottomLinearLayout)
        //测试-end
        navigationItem.title = "BLE".localized
        
        linearLayout.addArrangedSubview(Tool_ZSJ)
        linearLayout.addArrangedSubview(tableView)
        linearLayout.addArrangedSubview(bottomLinearLayout)
        view.addSubview(linearLayout)
        tableView.snp.makeConstraints {
            $0.edges.equalTo(self.view.usnp.edges)
        }
        tableView.mj_header = mj_header
        
//        self.view.addSubview(Tool_ZSJ)
    }
    
    @objc func loadBLE() {
        
        if PTDispatcher.share()?.getBluetoothStatus() == PTBluetoothState.poweredOn {
            PTDispatcher.share()?.stopScanBluetooth()
            dataSources.removeAll()
            self.tableView.reloadData()
            SVProgressHUD.showInfo(withStatus: "搜索中...".localized)
            PTDispatcher.share().scanBluetooth()
            PTDispatcher.share()?.whenFindAllBluetooth({ [weak self](ptArray) in
                guard let self = self else { return }
                self.dataSources = ptArray as! [PTPrinter]
                self.mj_header.endRefreshing()
                self.tableView.reloadData()
            })
        }else if PTDispatcher.share()?.getBluetoothStatus() == PTBluetoothState.poweredOff {
            self.mj_header.endRefreshing()
            SVProgressHUD.showInfo(withStatus: "请打开蓝牙".localized)
        }else {
            self.mj_header.endRefreshing()
            SVProgressHUD.showInfo(withStatus: "请前往系统设置中找到你的APP开启蓝牙权限".localized)
        }
    }
    //back
    @objc func popViewController() {
        dismiss(animated: true) {
            
        }
    }
    
    //发送数据
    @objc func sendDataToPeripheral() {
        //打印的数据
        let printData:String = "print data";
        //打印的循环次数
        let numbersCount:Int = 1;
        //校验：是否有数据
        if printData.isEmpty {
            SVProgressHUD.showInfo(withStatus: NSLocalizedString("请填充数据", comment: ""))
            return
        }
        SVProgressHUD.show()
        
        var totalData = Data.init()
        
//        if commandType == PTCommandType.CPCL {
            
            for _ in 0..<numbersCount {
                let cpcl = PTCommandCPCL.init()
                cpcl.encoding = self.encoding
                cpcl.cpclLabel(withOffset: 0, hRes: PTCPCLLabelResolution.resolution200, vRes: PTCPCLLabelResolution.resolution200, height: 500, quantity: 1)
                cpcl.cpclPageWidth(kUserDefaults.integer(forKey: PDPrintDots))
                cpcl.cpclBox(withXPos: 10, yPos: 10, xEnd: kUserDefaults.integer(forKey: PDPrintDots) - 100, yEnd: 490, thickness: 1)
                cpcl.cpclAutoText(withRotate: PTCPCLStyleRotation.rotation0, font: PTCPCLTextFontName.font8, fontSize: 0, x: 10, y: 10, safeHeight: 490, width: kUserDefaults.integer(forKey: PDPrintDots) - 100, lineSpacing: 10, fontScale: PTCPCLFontScale._1, text: printData)
                //换行方便观察
                cpcl.cpclLineFeed()
                cpcl.cpclLineFeed()
                if kUserDefaults.bool(forKey: PDPaperType) {
                    cpcl.cpclForm()
                }
                cpcl.cpclPrint()
                totalData.append(cpcl.cmdData as Data)
            }
        //发送数据
        self.sendTotalSuccess(totalData)
    }
    
    private func sendTotalSuccess(_ resultData:Data) {
        
//        SVProgressHUD.show(withStatus: "Sending data:".localized + "\(showCount)/" + "\(printCopiesCount)")
        SVProgressHUD.show(withStatus: "数据发送中".localized)
        PTDispatcher.share()?.send(resultData)
        PTDispatcher.share()?.whenSendFailure({
            SVProgressHUD.showError(withStatus: "数据发送失败".localized)
        })
        
//        PTDispatcher.share()?.whenSendProgressUpdate({
//            SVProgressHUD.showProgress($0!.floatValue)
//        })
        
        PTDispatcher.share()?.whenSendSuccess({[weak self] in
            guard let self = self else { return }
//            self.printCountTemp -= 1
//            self.showCount += 1
//            if self.printCountTemp > 0 {
//                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + TimeInterval(self.intervalTime), execute: {
//                    self.sendTotalSuccess(resultData)
//                })
//            }else {
                SVProgressHUD.dismiss()
                UIAlertController.showConfirmView("Tips".localized, message: "Data sent successfully".localized + ",  " +  "Total data:".localized + String.init(format: "%.2f kb, ", Double($0)/1000.0) + "Total time:".localized + String.init(format: "%.2f s,  ", $1) + "Transmission rate:".localized + String.init(format: "%.2f kb/s", Double(Double($0)/1000.0)/$1), confirmHandle: nil)
//            }
        })
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //防止切换连接的时候会走断开连接的回调
        PTDispatcher.share()?.unconnectBlock = nil
        
        if PTDispatcher.share()?.getBluetoothStatus() == PTBluetoothState.poweredOn {
            PTDispatcher.share().scanBluetooth()
            PTDispatcher.share()?.whenFindAllBluetooth({ [weak self](ptArray) in
                guard let self = self else { return }
                self.dataSources = ptArray as! [PTPrinter]
                self.tableView.reloadData()
            })
        }else if PTDispatcher.share()?.getBluetoothStatus() == PTBluetoothState.poweredOff {
            SVProgressHUD.showInfo(withStatus: "请打开蓝牙".localized)
        }else {
            SVProgressHUD.showInfo(withStatus: "请前往系统设置中找到你的APP开启蓝牙权限".localized)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        PTDispatcher.share().whenConnectSuccess(nil)
        PTDispatcher.share().whenConnectFailureWithErrorBlock(nil)
    }

}

extension PDBLEViewController : UITableViewDelegate,UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSources.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCell(withIdentifier: "iden")
        if cell == nil {
            cell = UITableViewCell.init(style: UITableViewCell.CellStyle.subtitle, reuseIdentifier: "iden")
        }
        cell?.textLabel?.text = dataSources[indexPath.row].name
        cell?.detailTextLabel?.text = dataSources[indexPath.row].mac
        
        cell?.textLabel?.textColor = UIColor.black
        cell?.detailTextLabel?.textColor = UIColor.titleColor
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "附近的蓝牙设备".localized
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 45.0
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        SVProgressHUD.show(withStatus: "连接中，请稍等".localized)
        PTDispatcher.share().connect(dataSources[indexPath.row])
        
        PTDispatcher.share().whenConnectSuccess { [weak self] in
            guard let self = self else { return }
            SVProgressHUD.dismiss()
            self.showAlert(title: "Select paper size".localized, buttonTitles: ["2\" (384dots)", "3\" (576dots)", "4\" (832dots)","8\" (2360dots)"], handler: { (selectedButtonIndex) in
                self.didSelectPaperSize(buttonIndex: selectedButtonIndex)
            })
        }
        
        PTDispatcher.share().whenConnectFailureWithErrorBlock { (error) in
            var errorStr: String?
            switch error {
            case .bleTimeout:
                errorStr = "Connection timeout".localized
            case .bleValidateTimeout:
                errorStr = "Vertification timeout".localized
            case .bleUnknownDevice:
                errorStr = "Unknown device".localized
            case .bleSystem:
                errorStr = "System error".localized
            case .bleValidateFail:
                errorStr = "Vertification failed".localized
            case .bleDisvocerServiceTimeout:
                errorStr = "Connection failed".localized
            default:
                break
            }
            if let temp = errorStr {
                SVProgressHUD.showError(withStatus: temp)
            }
        }
        
        PTDispatcher.share()?.whenReceiveData({ (_) in
            
        })
        
    }
}

extension UIViewController {

    func showAlert(title: String, buttonTitles: [String], handler: ((Int) -> Void)?) {
        let alert = UIAlertController(title: title, message: nil, preferredStyle: .alert)

        for i: Int in 0..<buttonTitles.count {
            alert.addAction(UIAlertAction(title: buttonTitles[i], style: .default, handler: { _ in
                DispatchQueue.main.async {
                    handler?(i + 1)
                }
            }))
        }

        alert.addAction(UIAlertAction(title: "取消", style: UIAlertAction.Style.cancel, handler: { (_) in
            kUserDefaults.set(576, forKey: PDPrintDots)
            self.navigationController?.popViewController(animated: true)
        }))
        self.present(alert, animated: true, completion: nil)
    }

    func didSelectPaperSize(buttonIndex: Int) {
        switch buttonIndex {
        case 1:
            kUserDefaults.set(384, forKey: PDPrintDots)
        case 2:
            kUserDefaults.set(576, forKey: PDPrintDots)
        case 3:
            kUserDefaults.set(832, forKey: PDPrintDots)
        case 4:
            kUserDefaults.set(2360, forKey: PDPrintDots)
        default:
            fatalError()
        }
        self.navigationController?.popViewController(animated: true)
    }
}
