//
//  JHMyTaskViewController.swift
//  DoctorManage
//
//  Created by chenhaifeng on 2018/8/10.
//  Copyright © 2018年 chenshengchang. All rights reserved.
//

import UIKit
import SwiftyJSON
class JHMyTaskViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
    var tableView = UITableView()
    var dataSource:[NSDictionary] = []
    var index = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .red
        configUI()
    }

    func configUI() {
        self.view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        tableView.delegate = self
        tableView.dataSource = self
        let nib = UINib(nibName: "TrainingCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "TrainingCell")
        tableView.tableFooterView = UIView()
        tableView.backgroundColor = UIColor.init(red: 245/255.0, green: 248/255.0, blue: 251, alpha: 1.0)
        tableView.separatorStyle = .none
        tableView.mj_header = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: #selector(refreshAction))
        tableView.mj_footer = MJRefreshAutoNormalFooter(refreshingTarget: self, refreshingAction: #selector(loadMoreAction))
        tableView.mj_header.beginRefreshing()
    }
    
    
    func getData(pageindex:Int) {
        MBProgressHUD.showAdded(to: self.view, animated: true)
        let params = ["pageindex":String(pageindex*10),"pagesize": "10","task_state":"0","myshop_forapp_key":"987654321","token":UserInfo.instance().token]
        
        NetworkTool.sharedInstance.requestStudentUnCompleteTask(params: params as! [String : String], success: { (response) in
            self.tableView.mj_header.endRefreshing()
            self.tableView.mj_footer.endRefreshing()
            MBProgressHUD.hide(for:  self.view, animated: true)
            if let data = response["data"],response["data"]?.count != 0{
                for i in 1...(data as! [NSDictionary]).count {
                    self.dataSource.append((data as! [NSDictionary])[i-1])
                }
                self.tableView.reloadData()
                print(self.dataSource)
            }
            else if response["data"]?.count == 0{
                self.tableView.mj_footer.endRefreshingWithNoMoreData()
            }
        }) { (error) in
            self.tableView.mj_header.endRefreshing()
            self.tableView.mj_footer.endRefreshing()
            MBProgressHUD.hide(for:  self.view, animated: true)
        }
    }
    func refreshAction() {
        dataSource.removeAll()
        index = 0
        self.tableView.mj_footer.resetNoMoreData()
        getData(pageindex: index)
    }
    
    func loadMoreAction() {
        index = index + 1
        getData(pageindex: index)
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TrainingCell", for: indexPath) as! TrainingCell
        cell.titleLabel.text = dataSource[indexPath.section].stringValue(forKey: "title")
        cell.timeLabel.isHidden = true
 
        cell.retainTimeLabel.text = dataSource[indexPath.section].stringValue(forKey: "overhour")
        cell.beginTimeLabel.text = dataSource[indexPath.section].stringValue(forKey: "starttime_show")
        cell.endTimeLabel.text = dataSource[indexPath.section].stringValue(forKey: "endtime_show")
        cell.addressLabel.text = dataSource[indexPath.section].stringValue(forKey: "addressname")
        if dataSource[indexPath.section].stringValue(forKey: "task_state") == "1" {
            cell.taskStateLabel.text = "未开始"
        }else{
            cell.taskStateLabel.text = "正在进行中..."
        }
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 170
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 5
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label = UILabel(frame: CGRect.init(x: 0, y: 0, width: self.view.bounds.size.width, height: 25))
        label.backgroundColor = UIColor(red: 245/255.0, green: 248/255.0, blue: 251/255.0, alpha: 1.0)
        return label
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let taskCenterStoryboard = UIStoryboard.init(name: "TaskCenter", bundle: nil)
        if self.dataSource[indexPath.section].stringValue(forKey: "type") == "2"{
            let taskDetailView = taskCenterStoryboard.instantiateViewController(withIdentifier: "taskDetailView") as! JHMyTaskDetaiController
            taskDetailView.headDataJson = JSON(self.dataSource[indexPath.section])
            self.present(taskDetailView, animated: true, completion: nil)
        }else {
            let taskDetailView2 = taskCenterStoryboard.instantiateViewController(withIdentifier: "taskDetailView2") as! JHMyTaskDetai2Controller
            taskDetailView2.headDataJson = JSON(self.dataSource[indexPath.section])
            self.present(taskDetailView2, animated: true, completion: nil)
        }
       
    }
    
    func historyTaskAction() {
        let taskCenterStoryboard = UIStoryboard.init(name: "TaskCenter", bundle: nil)
        let taskDetailView = taskCenterStoryboard.instantiateViewController(withIdentifier: "taskDetailView")
//        let nav = UINavigationController.init(rootViewController: completeView)
        self.present(taskDetailView, animated: true, completion: nil)
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
