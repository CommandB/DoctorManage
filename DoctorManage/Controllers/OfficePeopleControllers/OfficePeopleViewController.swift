//
//  OfficePeopleViewController.swift
//  DoctorManage
//
//  Created by 陈海峰 on 2018/8/6.
//  Copyright © 2018年 chenshengchang. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class OfficePeopleViewController: JHBaseViewController,UITableViewDelegate,UITableViewDataSource {
    var office = JSON()
    var tableView = UITableView()
    var dataSource = [JSON]()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "科室人员"
        configUI()
    }

    func configUI() {
        tableView.frame = CGRect.init(x: 0, y: 0, width: kScreenW, height: kScreenH-64);
        self.view.addSubview(tableView)
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(OfficePeopleCell.classForCoder(), forCellReuseIdentifier: "OfficePeopleCell")
        self.tableView.tableFooterView = UIView()
        self.tableView.backgroundColor = UIColor.init(red: 245/255.0, green: 248/255.0, blue: 251, alpha: 1.0)
        self.tableView.separatorStyle = .none
        self.tableView.mj_header = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: #selector(requestOfficePeople))
        self.tableView.mj_header.beginRefreshing()
    }
    
    func requestOfficePeople() {
        MBProgressHUD.showAdded(to: self.view, animated: true)
        let params = ["officeid":office["officeid"].stringValue,"token":UserInfo.instance().token]
        NetworkTool.sharedInstance.requestOfficePeople(params: params as! [String : String], success: { (response) in
            self.tableView.mj_header.endRefreshing()
            MBProgressHUD.hide(for:  self.view, animated: true)
            let json = JSON(response)
            if json["code"].stringValue == "1"{
                self.dataSource = json["officepersonlist"].arrayValue
                self.tableView.reloadData()
            }else{
                print("error")
            }
        }) { (error) in
            self.tableView.mj_header.endRefreshing()
            MBProgressHUD.hide(for:  self.view, animated: true)
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.dataSource.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "OfficePeopleCell", for: indexPath) as! OfficePeopleCell
        
        cell.bindData(self.dataSource[indexPath.section])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let itemDataList = self.dataSource[indexPath.section]["my_data_list"].arrayValue
        return  CGFloat(((itemDataList.count-1)/4+1)*50)+20
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 25
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label = UILabel(frame: CGRect.init(x: 0, y: 0, width: self.view.bounds.size.width, height: 25))
        label.backgroundColor = UIColor(red: 245/255.0, green: 248/255.0, blue: 251/255.0, alpha: 1.0)
        return label
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        view.tintColor =  UIColor(red: 245/255.0, green: 248/255.0, blue: 251/255.0, alpha: 1.0);
    }
    
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
