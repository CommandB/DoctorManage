//
//  EvaluateViewController.swift
//  jisoshi5
//
//  Created by chenhaifeng  on 2017/6/16.
//  Copyright © 2017年 chenhaifeng . All rights reserved.
//

import UIKit
enum TASKTYPE {
    case WaitExam
    case WaitEvalute
}
class EvaluateViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    var tableview = UITableView()
    var examDataSource:[NSDictionary] = []
    var evaluDataSource:[NSDictionary] = []
    var taskType:TASKTYPE!
    var index1 = 0
    var index2 = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.setBackgroundImage(UIImage.init(named: "topBackgroundIcon"), for: .default)
        self.extendedLayoutIncludesOpaqueBars = true
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.white]
        self.navigationController?.navigationBar.tintColor = UIColor.white
        let image = UIImage(named: "返回")!.withRenderingMode(.alwaysOriginal)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image:image, style: .done, target: self, action: #selector(backAction))
        self.title = "考评"
        tableview.frame = CGRect.init(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
        tableview.delegate = self
        tableview.dataSource = self
        self.view.addSubview(tableview)
        let nib1 = UINib(nibName: "EvaluateBaseCell", bundle: nil)
        tableview.register(nib1, forCellReuseIdentifier: "EvaluateBaseCell")
        tableview.tableFooterView = UIView()
        
        self.tableview.mj_header = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: #selector(refreshAction))
        self.tableview.mj_footer = MJRefreshAutoNormalFooter(refreshingTarget: self, refreshingAction: #selector(loadMoreAction))
        if taskType == .WaitExam {
            requestData(taskType: taskType, pageindex: String(index1))
        }else{
            requestData(taskType: taskType, pageindex: String(index2))
        }
    }
    func requestData(taskType:TASKTYPE,pageindex:String) {
        MBProgressHUD.showAdded(to: self.view, animated: true)
        let params = ["pageindex":pageindex,"pagesize": "3","token":UserInfo.instance().token]
        if taskType == .WaitExam{
            NetworkTool.sharedInstance.requestTaskexamURL(params: params as! [String : String], success: { (response) in
                self.tableview.mj_header.endRefreshing()
                self.tableview.mj_footer.endRefreshing()
                MBProgressHUD.hide(for:  self.view, animated: true)
                if let data = response["data"],(response["data"] as AnyObject).count != 0{
                    for i in 1...(data as! [NSDictionary]).count {
                        self.examDataSource.append((data as! [NSDictionary])[i-1])
                    }
                    self.tableview.reloadData()
                }
                else if (response["data"] as AnyObject).count == 0{
                    self.tableview.mj_footer.endRefreshingWithNoMoreData()
                }
            }) { (error) in
                self.tableview.mj_header.endRefreshing()
                self.tableview.mj_footer.endRefreshing()
                MBProgressHUD.hide(for:  self.view, animated: true)
            }
        }else{
            NetworkTool.sharedInstance.requestTaskEvaluationURL(params: params as! [String : String], success: { (response) in
                self.tableview.mj_header.endRefreshing()
                self.tableview.mj_footer.endRefreshing()
                MBProgressHUD.hide(for:  self.view, animated: true)
                if let data = response["data"],(response["data"] as AnyObject).count != 0{
                    for i in 1...(data as! [NSDictionary]).count {
                        self.evaluDataSource.append((data as! [NSDictionary])[i-1])
                    }
                    self.tableview.reloadData()
                }
                else if (response["data"] as AnyObject).count == 0{
                    self.tableview.mj_footer.endRefreshingWithNoMoreData()
                }
            }) { (error) in
                self.tableview.mj_header.endRefreshing()
                self.tableview.mj_footer.endRefreshing()
                MBProgressHUD.hide(for:  self.view, animated: true)
            }

        }
    }

    func refreshAction() {
        switch taskType! {
        case .WaitEvalute:
            examDataSource.removeAll()
            index2 = 0
            self.tableview.mj_footer.resetNoMoreData()
            requestData(taskType: taskType, pageindex: String(index2))
        case .WaitExam:
            examDataSource.removeAll()
            index1 = 0
            self.tableview.mj_footer.resetNoMoreData()
            requestData(taskType: taskType, pageindex: String(index1))
        }
    }
    
    func loadMoreAction() {
        switch taskType! {
        case .WaitEvalute:
            index2 = index2 + 1
            requestData(taskType: taskType, pageindex: String(index2))
        case .WaitExam:
            index1 = index1 + 1
            requestData(taskType: taskType, pageindex: String(index1))
        }
    }
    
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if taskType == .WaitEvalute {
            return evaluDataSource.count
        }
        return examDataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EvaluateBaseCell", for: indexPath) as! EvaluateBaseCell
        switch taskType! {
        case .WaitEvalute:
            cell.titleLabel.text = evaluDataSource[indexPath.section].stringValue(forKey: "title")
            cell.typeLabel.text = evaluDataSource[indexPath.section].stringValue(forKey: "examtypename")
            cell.timeLabel.text = evaluDataSource[indexPath.section].stringValue(forKey: "createtime")
            cell.personLabel.text = evaluDataSource[indexPath.section].stringValue(forKey: "bepersonname")
        case .WaitExam:
            cell.titleLabel.text = examDataSource[indexPath.section].stringValue(forKey: "title")
            cell.typeLabel.text = examDataSource[indexPath.section].stringValue(forKey: "examtypename")
            cell.timeLabel.text = examDataSource[indexPath.section].stringValue(forKey: "createtime")
            cell.personLabel.text = examDataSource[indexPath.section].stringValue(forKey: "bepersonname")
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 110
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        //        view.tintColor = UIColor(red: 214.0/255.0, green: 214.0/255.0, blue: 214.0/255.0, alpha: 1.0)
        let leftLabel = UILabel()
        leftLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(leftLabel)
        view.addConstraint(NSLayoutConstraint.init(item: leftLabel, attribute: .centerY, relatedBy: .equal, toItem: view, attribute: .centerY, multiplier: 1, constant: 0))
        view.addConstraint(NSLayoutConstraint.init(item: leftLabel, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1, constant: 15))
        leftLabel.text = "待考任务"
        leftLabel.font = UIFont.systemFont(ofSize: 13.0)
        leftLabel.textColor = UIColor(red: 155/255.0, green: 155/255.0, blue: 155/255.0, alpha: 1.0)
        
        let rightBtn = UIButton()
        rightBtn.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(rightBtn)
        view.addConstraint(NSLayoutConstraint.init(item: rightBtn, attribute: .centerY, relatedBy: .equal, toItem: view, attribute: .centerY, multiplier: 1, constant: 0))
        view.addConstraint(NSLayoutConstraint.init(item: rightBtn, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1, constant: -15))
        rightBtn.setTitle("历史考试", for: .normal)
        rightBtn.setTitleColor(UIColor(red: 94/255.0, green: 163/255.0, blue: 243/255.0, alpha: 1.0), for: .normal)
        rightBtn.titleLabel?.font = UIFont.systemFont(ofSize: 13.0)
        rightBtn.addTarget(self, action: #selector(touchBtn(sender:)), for: .touchUpInside)
        switch taskType! {
        case .WaitExam:
            leftLabel.text = "待考任务"
            rightBtn.setTitle("历史考试", for: .normal)
        case .WaitEvalute:
            leftLabel.text = "待评任务"
            rightBtn.setTitle("历史评价", for: .normal)
        }
//        if section == 1 {
//            leftLabel.text = "待评任务"
//            rightBtn.setTitle("历史评价", for: .normal)
//        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if taskType == .WaitExam {
            let examInfoVC = ExamInfoViewController()
            let nav = UINavigationController(rootViewController: examInfoVC)
            self.present(nav, animated: true, completion: nil)
        }else{
            let EvaluateInfoVC = EvaluateInfoController()
            let nav = UINavigationController(rootViewController: EvaluateInfoVC)
            self.present(nav, animated: true, completion: nil)
        }
    }
    
    func touchBtn(sender:UIButton){
        if sender.currentTitle == "历史考试" {
            let historyExamVC = HistoryExamController()
            let nav = UINavigationController(rootViewController: historyExamVC)
            self.present(nav, animated: true, completion: nil)
        }else{
            let historyEvaluateVC = HistoryEvaluateController()
            let nav = UINavigationController(rootViewController: historyEvaluateVC)
            self.present(nav, animated: true, completion: nil)
        }
    }
    
    func backAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
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
