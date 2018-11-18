//
//  WaitEvaluateController.swift
//  DoctorManage
//
//  Created by 陈海峰 on 2017/7/6.
//  Copyright © 2017年 chenshengchang. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
class WaitEvaluateController: UIViewController,UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate {
    var tableview = UITableView()
    var evaluDataSource:[JSON] = []
    var index = 0
    var parentView:BaseEvaluateController?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.setBackgroundImage(UIImage.init(named: "topBackgroundIcon"), for: .default)
        self.extendedLayoutIncludesOpaqueBars = true
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.white]
        self.navigationController?.navigationBar.tintColor = UIColor.white
        let image = UIImage(named: "返回")!.withRenderingMode(.alwaysOriginal)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image:image, style: .done, target: self, action: #selector(backAction))
        self.title = "考评"
        tableview.frame = CGRect.init(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height-64-49-45)
        tableview.delegate = self
        tableview.dataSource = self
        self.view.addSubview(tableview)
        self.tableview.backgroundColor = UIColor.init(red: 245/255.0, green: 248/255.0, blue: 251, alpha: 1.0)
        let nib1 = UINib(nibName: "EvaluateBaseCell", bundle: nil)
        tableview.register(nib1, forCellReuseIdentifier: "EvaluateBaseCell")
        tableview.tableFooterView = UIView()
        
        self.tableview.mj_header = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: #selector(refreshAction))
        self.tableview.mj_footer = MJRefreshAutoNormalFooter(refreshingTarget: self, refreshingAction: #selector(loadMoreAction))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.tableview.mj_header.beginRefreshing()
    }
    
    func requestData(pageindex:Int) {
        let urlString = "http://"+Ip_port2+kQueryTaskEvaluationURL
        let params = ["pageindex":String(pageindex*10),"pagesize": "10","token":UserInfo.instance().token,"state":"1"] as! [String:String]
        NetworkTool.sharedInstance.myPostRequest(urlString,params, method: HTTPMethod.post).responseJSON { (response) in
            self.tableview.mj_header.endRefreshing()
            self.tableview.mj_footer.endRefreshing()
            switch(response.result){
            case .failure(let error):
                print(error)
            case .success(let response):
                let json = JSON(response)
                if json["code"].stringValue == "1"{
                    self.evaluDataSource += json["data"].arrayValue
                    self.tableview.reloadData()
                }else{
                    print("error")
                }
            }
        }
    }
    
    func refreshAction() {
        evaluDataSource.removeAll()
        index = 0
        self.tableview.mj_footer.resetNoMoreData()
        requestData(pageindex: index)
    }
    
    func loadMoreAction() {
        index = index + 1
        requestData(pageindex: index)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return evaluDataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EvaluateBaseCell", for: indexPath) as! EvaluateBaseCell
        cell.waitTypeLabel.text = "被评人:"
        cell.examLabel.text = "截止时间: "
        cell.titleLabel.text = evaluDataSource[indexPath.row]["title"].stringValue
        cell.typeLabel.text = evaluDataSource[indexPath.row]["evaluatetypename"].stringValue
        cell.timeLabel.text = evaluDataSource[indexPath.row]["endtime_show"].stringValue
        cell.personLabel.text = evaluDataSource[indexPath.row]["bepersonname"].stringValue
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 110
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let evaluateInfoVC = EvaluateInfoController()
        evaluateInfoVC.headInfo = evaluDataSource[indexPath.row]
        let nav = UINavigationController(rootViewController: evaluateInfoVC)
        self.present(nav, animated: true, completion: nil)
    }
    
    func backAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
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
