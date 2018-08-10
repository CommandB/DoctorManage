//
//  TaskCenterViewController.swift
//  DoctorManage
//
//  Created by 陈海峰 on 2017/6/2.
//  Copyright © 2017年 chenshengchang. All rights reserved.
//

import UIKit

class TaskCenterViewController: UIViewController,UITableViewDataSource,UITableViewDelegate  {
    var tableview = UITableView()
    var dataSource:[NSDictionary] = []
    var index = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(named: "topBack.png"), for: .default)
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.white]
        self.title = "任务中心"
        
        let leftBtn = UIButton.init(frame: CGRect.init(x: 0, y: 0, width: 40, height: 30))
        leftBtn.setImage(UIImage.init(named: "扫一扫-白"), for: .normal)
        leftBtn.addTarget(self, action: #selector(scannerAction), for: .touchUpInside)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem.init(customView: leftBtn)
        
        let rightBtn = UIButton.init(frame: CGRect.init(x: 0, y: 0, width: 80, height: 30))
        rightBtn.setTitle("历史任务", for: .normal)
        rightBtn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        rightBtn.addTarget(self, action: #selector(historyTaskAction), for: .touchUpInside)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(customView: rightBtn)
        
        self.tableview = UITableView(frame: CGRect.init(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.bounds.size.height-64-49))
        self.view.addSubview(tableview)
        self.tableview.delegate = self
        self.tableview.dataSource = self
        let nib = UINib(nibName: "TrainingCell", bundle: nil)
        self.tableview.register(nib, forCellReuseIdentifier: "TrainingCell")
        self.tableview.tableFooterView = UIView()
        self.tableview.backgroundColor = UIColor.init(red: 245/255.0, green: 248/255.0, blue: 251, alpha: 1.0)
        self.tableview.separatorStyle = .none
        self.tableview.mj_header = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: #selector(refreshAction))
        self.tableview.mj_footer = MJRefreshAutoNormalFooter(refreshingTarget: self, refreshingAction: #selector(loadMoreAction))
        self.tableview.mj_header.beginRefreshing()
        //        getData(pageindex: "0")
    }
    
    func getData(pageindex:Int) {
        MBProgressHUD.showAdded(to: self.view, animated: true)
        let params = ["pageindex":String(pageindex*10),"pagesize": "10","task_state":"1,2","myshop_forapp_key":"987654321","token":UserInfo.instance().token]
        
        NetworkTool.sharedInstance.requestUnCompleteTask(params: params as! [String : String], success: { (response) in
            self.tableview.mj_header.endRefreshing()
            self.tableview.mj_footer.endRefreshing()
            MBProgressHUD.hide(for:  self.view, animated: true)
            if let data = response["data"],response["data"]?.count != 0{
                for i in 1...(data as! [NSDictionary]).count {
                    self.dataSource.append((data as! [NSDictionary])[i-1])
                }
                self.tableview.reloadData()
                print(self.dataSource)
            }
            else if response["data"]?.count == 0{
                self.tableview.mj_footer.endRefreshingWithNoMoreData()
            }
        }) { (error) in
            self.tableview.mj_header.endRefreshing()
            self.tableview.mj_footer.endRefreshing()
            MBProgressHUD.hide(for:  self.view, animated: true)
        }
    }
    func refreshAction() {
        dataSource.removeAll()
        index = 0
        self.tableview.mj_footer.resetNoMoreData()
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
        let cell = tableview.dequeueReusableCell(withIdentifier: "TrainingCell", for: indexPath) as! TrainingCell
        cell.titleLabel.text = dataSource[indexPath.section].stringValue(forKey: "title")
        //        cell.timeLabel.text = "(明天)"
        cell.timeLabel.isHidden = true
        //        if Int(dataSource[indexPath.section].stringValue(forKey: "left_hour"))! <= 0 {
        //            cell.retainTimeLabel.text = "0"
        //        }else{
        //            cell.retainTimeLabel.text = dataSource[indexPath.section].stringValue(forKey: "left_hour")
        //        }
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
        let taskDetailVC = TaskDetailController()
        taskDetailVC.title = "任务详细"
        taskDetailVC.enterPath = .UNCOMPLETE
        taskDetailVC.headInfo = dataSource[indexPath.section]
        let nav = UINavigationController(rootViewController: taskDetailVC)
        self.present(nav, animated: true, completion: nil)
    }
    
    func historyTaskAction() {
        let completeView = CompleteController()
        let nav = UINavigationController.init(rootViewController: completeView)
        self.present(nav, animated: true, completion: nil)
    }
    
    func scannerAction(){
        myPresentView(self, viewName: "scannerView")
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
