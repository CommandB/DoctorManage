//
//  WaitExamViewController.swift
//  DoctorManage
//
//  Created by 陈海峰 on 2017/7/6.
//  Copyright © 2017年 chenshengchang. All rights reserved.
//

import UIKit

class WaitExamViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate {
    var tableview = UITableView()
    var examDataSource:[NSDictionary] = []
    var index = 0
    var parentView:BaseEvaluateController?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableview.frame = CGRect.init(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height-64-49-45)
        tableview.delegate = self
        tableview.dataSource = self
        self.tableview.backgroundColor = UIColor.init(red: 245/255.0, green: 248/255.0, blue: 251, alpha: 1.0)
        self.view.addSubview(tableview)
        let nib1 = UINib(nibName: "WaitEvaluateCell", bundle: nil)
        tableview.register(nib1, forCellReuseIdentifier: "WaitEvaluateCell")
        tableview.tableFooterView = UIView()
        
        let header = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: #selector(refreshAction))
        self.tableview.mj_header = header
        self.tableview.mj_header.beginRefreshing()
        
        let footer = MJRefreshAutoNormalFooter(refreshingTarget: self, refreshingAction: #selector(loadMoreAction))
        self.tableview.mj_footer = footer
        header?.setTitle("", for: .idle)
        footer?.setTitle("", for: .idle)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
    }
    func requestData(pageindex:Int) {
        let params = ["pageindex":String(pageindex*10),"pagesize": "10","token":UserInfo.instance().token]
            NetworkTool.sharedInstance.requestTaskexamURL(params: params as! [String : String], success: { (response) in
                self.tableview.mj_header.endRefreshing()
                self.tableview.mj_footer.endRefreshing()
                if pageindex == 0 {
                    self.examDataSource.removeAll()
                }
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
            }
    }
    
    func refreshAction() {
        index = 0
        self.tableview.mj_footer.resetNoMoreData()
        requestData(pageindex:index)
    }
    
    func loadMoreAction() {
        index = index + 1
        requestData(pageindex: index)
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return examDataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "WaitEvaluateCell", for: indexPath) as! WaitEvaluateCell
        cell.titleLabel.text = examDataSource[indexPath.row].stringValue(forKey: "title")
        cell.typeLabel.text = examDataSource[indexPath.row].stringValue(forKey: "examtypename")
        cell.timeLabel.text = examDataSource[indexPath.row].stringValue(forKey: "createtime")
        cell.personLabel.text = examDataSource[indexPath.row].stringValue(forKey: "bepersonname")
        cell.addressLabel.text = examDataSource[indexPath.row].stringValue(forKey: "addressname")
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 125
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let examInfoVC = ExamInfoViewController()
        examInfoVC.headInfo = examDataSource[indexPath.row]
        let nav = UINavigationController(rootViewController: examInfoVC)
        self.present(nav, animated: true, completion: nil)
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        parentView?.moreMenu.isHidden = true
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
