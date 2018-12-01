//
//  SelectAddressViewController.swift
//  DoctorManage
//
//  Created by 陈海峰 on 2018/11/24.
//  Copyright © 2018年 chenshengchang. All rights reserved.
//

import UIKit
import SwiftyJSON
class SelectAddressViewController: IGBaseViewController,UITableViewDelegate,UITableViewDataSource {
    var dataSource:[JSON] = []
    
    typealias funcBlock = (_ nameStr : String) -> ()
    var cellClickCallBack : funcBlock?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "选择地址"
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
        guard let officeListStr = UserDefaults.AppConfig.string(forKey: .officeList) else { return }
        dataSource  = JSON(parseJSON:officeListStr).arrayValue
        self.tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = dataSource[indexPath.row]["officename"].stringValue
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let callBack = cellClickCallBack {
            callBack(dataSource[indexPath.row]["officename"].stringValue)
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    lazy var tableView:UITableView = {
        let table = UITableView()
        table.delegate = self
        table.dataSource = self
        table.register(UITableViewCell.classForCoder(), forCellReuseIdentifier: "cell")
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
