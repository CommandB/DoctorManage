//
//  SelectLectureViewController.swift
//  DoctorManage
//
//  Created by 陈海峰 on 2018/11/24.
//  Copyright © 2018年 chenshengchang. All rights reserved.
//

import UIKit
import SwiftyJSON
class SelectLectureViewController: IGBaseViewController,UITableViewDelegate,UITableViewDataSource {
    var dataSource:[JSON] = []

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "选择培训"
        addChildViews()
        setUpConstrains()
        setDataSource()
    }
    
    func addChildViews() {
        self.view.addSubview(self.tableView)
    }
    
    func setUpConstrains() {
        tableView.mas_makeConstraints { (make) in
            make?.left.right().bottom().offset()(0)
            make?.top.offset()(0)
        }
    }
    
    func setDataSource() {
        guard let teachingTypeListStr = UserDefaults.AppConfig.string(forKey: .teachingActivityType) else { return }
        dataSource  = JSON(parseJSON:teachingTypeListStr).arrayValue
        self.tableView.reloadData()
    }
    func requestData() {
        tableView.mj_header.beginRefreshing()
    }
    
    func refreshAction() {
//        let urlString = "http://"+Ip_port2+"doctor_train/rest/app/searchPerson.do"
//        guard let token = UserInfo.instance().token else { return }
//        let params = ["token":token,"officeid":"143"]
//        Alamofire.request(urlString, method: .post, parameters: params).responseJSON { (response) in
//            self.tableView.mj_header.endRefreshing()
//            switch(response.result){
//            case .failure(let error):
//                print(error)
//            case .success(let response):
//                let json = JSON(response)
//                if json["code"].stringValue == "1"{
//                    self.dataSource = json["data"].arrayValue
//                    self.tableView.reloadData()
//                }else{
//                    print("error")
//                }
//            }
//        }
        
        
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = dataSource[indexPath.row]["traintypename"].stringValue
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let publicView = PublishLectureController()
        publicView.titleStr = dataSource[indexPath.row]["traintypename"].stringValue
        self.navigationController?.pushViewController(publicView, animated: true)
    //        if let callBack = cellClickCallBack {
//            callBack(dataSource[indexPath.row]["personname"].stringValue)
//        }
    }
    
    lazy var tableView:UITableView = {
        let table = UITableView()
        table.delegate = self
        table.dataSource = self
        table.register(UITableViewCell.classForCoder(), forCellReuseIdentifier: "cell")
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
