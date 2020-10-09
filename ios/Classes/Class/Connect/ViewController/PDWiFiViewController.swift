//
//  PDWiFiViewController.swift
//  PrinterDemo
//
//  Created by ios on 2019/9/9.
//  Copyright © 2019 XiamenHY. All rights reserved.
//

import UIKit

class PDWiFiViewController: PDBaseViewController {

    private var dataSources = [PTPrinter]()
    
    lazy var tableView : UITableView = {
        let temp = UITableView.init(frame: .zero, style: .grouped)
        temp.delegate = self
        temp.dataSource = self
        temp.backgroundColor = .white
        temp.showsVerticalScrollIndicator = false
        temp.separatorStyle = UITableViewCell.SeparatorStyle.singleLine
        return temp
    }()
    
    lazy var mj_header: MJRefreshNormalHeader = {
        let temp = MJRefreshNormalHeader.init(refreshingTarget: self, refreshingAction: #selector(getIPAddress))
        temp.setTitle("Scanning network segment, pls. wait".localized, for: MJRefreshState.refreshing)
        temp.stateLabel?.textColor = UIColor.gray
        temp.lastUpdatedTimeLabel!.isHidden = true
        temp.activityIndicatorViewStyle = UIActivityIndicatorView.Style.gray
        return temp
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "WiFi".localized
        view.addSubview(tableView)
        tableView.snp.makeConstraints {
            $0.edges.equalTo(self.view.usnp.edges)
        }
        tableView.mj_header = mj_header
    }
    
    @objc private func getIPAddress() {
        
        self.dataSources.removeAll()
        self.tableView.reloadData()
        
        PTDispatcher.share()?.scanWiFi({[weak self](ptArray) in
            guard let self = self else { return }
            self.dataSources = ptArray as! [PTPrinter]
            self.mj_header.endRefreshing()
            self.tableView.reloadData()
        })
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //防止切换连接的时候会走断开连接的回调
        PTDispatcher.share()?.unconnectBlock = nil
        SVProgressHUD.show(withStatus: "Scanning network segment, pls. wait".localized)
        PTDispatcher.share().scanWiFi({ [weak self](ptArray) in
            guard let self = self else { return }
            SVProgressHUD.showSuccess(withStatus: "Scan succeeded".localized)
            self.dataSources = ptArray as! [PTPrinter]
            self.tableView.reloadData()
        })
    }
    

}

extension PDWiFiViewController : UITableViewDelegate,UITableViewDataSource {
    
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
        cell?.textLabel?.text = dataSources[indexPath.row].ip
//        cell?.detailTextLabel?.text = dataSources[indexPath.row].mac
        
        cell?.textLabel?.textColor = UIColor.black
//        cell?.detailTextLabel?.textColor = UIColor.titleColor
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Pls. select a corresponding IP".localized
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 45.0
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 60.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let pt = dataSources[indexPath.row]
        SVProgressHUD.show(withStatus: "Connecting, pls. wait".localized)
        PTDispatcher.share().connect(pt)
        
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
            case .wifiTimeout:
                errorStr = "Connection timeout".localized
            case .wifiSocketError:
                errorStr = "Connection Error".localized
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
