//
//  HisCEXViewController.swift
//  DoctorManage
//
//  Created by 陈海峰 on 2018/12/30.
//  Copyright © 2018年 chenshengchang. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire
class HisCEXViewController: IGBaseViewController,UITableViewDelegate,UITableViewDataSource {
    var dataSource:[JSON] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "历史CEX"
        addChildViews()
        setUpConstrains()
    }

    func addChildViews() {
        self.view.addSubview(self.tableView)
        self.tableView.mj_header.beginRefreshing()
    }
    
    func setUpConstrains() {
        tableView.mas_makeConstraints { (make) in
            make?.left.right().bottom().offset()(0)
            make?.top.offset()(0)
        }
    }
    
    func requestData() {
        let urlString = "http://"+Ip_port2+"doctor_train/rest/app/queryHistoryMiniCEX.do"
        guard let token = UserInfo.instance().token else { return }
        let params = ["token":token,"officeid":"143"]
        Alamofire.request(urlString, method: .post, parameters: params).responseJSON { (response) in
            self.tableView.mj_header.endRefreshing()
            switch(response.result){
            case .failure(let error):
                print(error)
            case .success(let response):
                let json = JSON(response)
                if json["code"].stringValue == "1"{
                    self.dataSource = json["data"].arrayValue
                    self.tableView.reloadData()
                }else{
                    print("error")
                }
            }
        }
        
    }
    
    func refreshAction() {
        requestData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! HisCEXTableViewCell
        cell.nameLabel.text =  dataSource[indexPath.row]["studentname"].stringValue
        cell.dateLabel.text =  dataSource[indexPath.row]["testtime"].stringValue
        cell.scoreLabel.text =  dataSource[indexPath.row]["totalscore"].stringValue+"/90"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let historyView = HisCEXDetailViewController()
        historyView.dataSource = self.dataSource[indexPath.row]
//        publicView.titleStr = dataSource[indexPath.row]["traintypename"].stringValue
        self.navigationController?.pushViewController(historyView, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    lazy var tableView:UITableView = {
        let table = UITableView()
        table.delegate = self
        table.dataSource = self
        table.register(HisCEXTableViewCell.classForCoder(), forCellReuseIdentifier: "cell")
        let header = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: #selector(refreshAction))
        table.mj_header = header
        table.tableFooterView = UIView()
        return table
    }()
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
