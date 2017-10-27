//
//  ExamInfoViewController.swift
//  jisoshi5
//
//  Created by chenhaifeng  on 2017/6/16.
//  Copyright © 2017年 chenhaifeng . All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class ExamInfoViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
    var tableview = UITableView()
    var titleLabel = UILabel()
    var headInfo:NSDictionary  = NSDictionary()
    var dataSource:JSON = JSON("")

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "考试"
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(named: "topBack.png"), for: .default)
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.white]
        let image = UIImage(named: "返回")!.withRenderingMode(.alwaysOriginal)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image:image, style: .done, target: self, action: #selector(dismissAction))
        setSubviews()
        requestkQueryExercisesInfo()
    }

    func requestkQueryExercisesInfo() {
        MBProgressHUD.showAdded(to: self.view, animated: true)
        let urlString = "http://"+Ip_port2+kQueryExercisesInfoURl
        NetworkTool.sharedInstance.myPostRequest(urlString, ["token":UserInfo.instance().token!,"exercisesid":headInfo["exercisesid"]], method: HTTPMethod.post).responseJSON { (response) in
            MBProgressHUD.hide(for: self.view, animated: true)
                switch(response.result){
                case .failure(let error):
                    print(error)
                case .success(let response):
                    let json = JSON(response)
                    if json["code"].stringValue == "1"{
                        self.dataSource = json["data"].arrayValue.first!
                        self.reloadTitleLabel()
                        self.tableview.reloadData()
                    }else{
                        print("error")
                    }
                }
            }
    }
    
    func setSubviews() {
        titleLabel.frame = CGRect.init(x: 0, y: 0, width: self.view.frame.size.width, height: 50)
        titleLabel.text = dataSource["title"].stringValue
        titleLabel.font = UIFont.systemFont(ofSize: 17.0)
        titleLabel.textColor = UIColor(red: 59/255.0, green: 69/255.0, blue: 79/255.0, alpha: 1.0)
        titleLabel.textAlignment = .center

        let startExamBtn = UIButton(frame: CGRect.init(x: 0, y: 0, width: self.view.frame.size.width-100, height: 40))
        startExamBtn.setTitle("开始考试", for: .normal)
        startExamBtn.setBackgroundImage(UIImage.init(named: "top背景"), for: .normal)
        startExamBtn.layer.cornerRadius = startExamBtn.frame.size.height/2
        startExamBtn.layer.masksToBounds = true
        startExamBtn.addTarget(self, action: #selector(startExamAction), for: .touchUpInside)
        let backgroundView = UIView(frame: CGRect.init(x: 0, y: 0, width: self.view.frame.size.width, height: 100))
        backgroundView.addSubview(startExamBtn)
        startExamBtn.center = CGPoint(x: backgroundView.center.x, y: backgroundView.frame.size.height/2)
        if let examtypename = headInfo["examtypename"] {
            if examtypename as! String == "理论"{
                startExamBtn.isHidden = true
            }else{
                startExamBtn.isHidden = false
            }
        }

        tableview.frame = CGRect.init(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
        tableview.delegate = self
        tableview.dataSource = self
        tableview.separatorStyle = .none
        self.view.addSubview(tableview)
        let nib1 = UINib(nibName: "ExamInfoCell", bundle: nil)
        tableview.register(nib1, forCellReuseIdentifier: "ExamInfoCell")
        tableview.isScrollEnabled = false
        tableview.tableHeaderView = titleLabel
        tableview.tableFooterView = backgroundView

    }
    
    func reloadTitleLabel() {
        titleLabel.text = dataSource["title"].stringValue
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ExamInfoCell", for: indexPath) as! ExamInfoCell
        switch indexPath.row {
        case 0:
            cell.titleLabel.text = "类型"
            cell.contentLabel.text = dataSource["classificationshow"].stringValue
        case 1:
            cell.titleLabel.text = "被考人"
            cell.contentLabel.text = headInfo.value(forKey: "bepersonname") as? String
        case 2:
            cell.titleLabel.text = "试卷编号"
            cell.contentLabel.text = dataSource["exercisesid"].stringValue
        case 3:
            cell.titleLabel.text = "总分"
            cell.contentLabel.text = dataSource["score"].stringValue+"分"
        case 4:
            cell.titleLabel.text = "时长"
            cell.contentLabel.text = dataSource["longtime"].stringValue+"分钟"
        case 5:
            cell.titleLabel.text = "开考时间"
            cell.contentLabel.text = headInfo.value(forKey: "starttime") as? String
        default:
            break
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func startExamAction() {
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        let examingView = storyboard.instantiateViewController(withIdentifier: "ExamingView") as! ExamingViewController
        examingView.headInfo = headInfo
        self.navigationController?.pushViewController(examingView, animated: true)
    }
    
    func dismissAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
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
