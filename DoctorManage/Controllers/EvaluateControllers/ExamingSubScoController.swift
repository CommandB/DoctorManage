//
//  ExamingSubScoController.swift
//  jisoshi5
//
//  Created by chenhaifeng  on 2017/6/16.
//  Copyright © 2017年 chenhaifeng . All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
class ExamingSubScoController: UIViewController,UITableViewDelegate,UITableViewDataSource,SubScoreCellDelegate {
    var tableview = UITableView()
    var headDataArr:[JSON] = []
    var dataDic = [String:[JSON]]()
    var bottomView = UIView()
    var lastQuestionBtn = UIButton()
    var nextQuestionBtn = UIButton()
    var sureBtn = UIButton()
    var typeSortArr = [String]()
    
//    var allItemQuestions = JSON([:])
    
    var questionIndex = 0{
        willSet
        {
            if newValue <= 0 {
                lastQuestionBtn.isHidden = true
            }else{
                lastQuestionBtn.isHidden = false
            }
            
            if newValue == headDataArr.count {
                nextQuestionBtn.setTitle("提交试卷", for: .normal)
            }else{
                nextQuestionBtn.setTitle("下一题", for: .normal)
            }
            print("Will set an new value \(newValue) to age")
        }
        didSet
        {
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        BRCommitDataManage.shared.allItemQuestions.removeAll()
        setSubviews()
    }
    
    func setSubviews() {
        tableview.delegate = self
        tableview.dataSource = self
        self.view.addSubview(tableview)
        tableview.separatorStyle = .none
        tableview.estimatedRowHeight = 44.0//推测高度
        let nib1 = UINib(nibName: "SubScoreCell", bundle: nil)
        tableview.register(nib1, forCellReuseIdentifier: "SubScoreCell")
        
        tableview.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(tableview)
        tableview.backgroundColor = UIColor.init(red: 244/255.0, green: 247/255.0, blue: 250/255.0, alpha: 1.0)
        self.view.addConstraint(NSLayoutConstraint.init(item: tableview, attribute: .bottom, relatedBy: .equal, toItem: self.view, attribute: .bottom, multiplier: 1.0, constant: -50))
        self.view.addConstraint(NSLayoutConstraint.init(item: tableview, attribute: .width, relatedBy: .equal, toItem: self.view, attribute: .width, multiplier: 1.0, constant: 0))
        self.view.addConstraint(NSLayoutConstraint.init(item: tableview, attribute: .centerX, relatedBy: .equal, toItem: self.view, attribute: .centerX, multiplier: 1.0, constant: 0))
        self.view.addConstraint(NSLayoutConstraint.init(item: tableview, attribute: .top, relatedBy: .equal, toItem: self.view, attribute: .top, multiplier: 1.0, constant: 0))
        
        bottomView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(bottomView)
        bottomView.backgroundColor = UIColor.init(red: 244/255.0, green: 247/255.0, blue: 250/255.0, alpha: 1.0)
        self.view.addConstraint(NSLayoutConstraint.init(item: bottomView, attribute: .bottom, relatedBy: .equal, toItem: self.view, attribute: .bottom, multiplier: 1.0, constant: 0))
        self.view.addConstraint(NSLayoutConstraint.init(item: bottomView, attribute: .width, relatedBy: .equal, toItem: self.view, attribute: .width, multiplier: 1.0, constant: 0))
        self.view.addConstraint(NSLayoutConstraint.init(item: bottomView, attribute: .centerX, relatedBy: .equal, toItem: self.view, attribute: .centerX, multiplier: 1.0, constant: 0))
        self.view.addConstraint(NSLayoutConstraint.init(item: bottomView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 50))
        
        lastQuestionBtn.translatesAutoresizingMaskIntoConstraints = false
        bottomView.addSubview(lastQuestionBtn)
        lastQuestionBtn.setBackgroundImage(UIImage.init(named: "上一题"), for: .normal)
        bottomView.addConstraint(NSLayoutConstraint.init(item: lastQuestionBtn, attribute: .leading, relatedBy: .equal, toItem: bottomView, attribute: .leading, multiplier: 1.0, constant: 15))
        bottomView.addConstraint(NSLayoutConstraint.init(item: lastQuestionBtn, attribute: .centerY, relatedBy: .equal, toItem: bottomView, attribute: .centerY, multiplier: 1.0, constant: 0))
        
        
        nextQuestionBtn.translatesAutoresizingMaskIntoConstraints = false
        bottomView.addSubview(nextQuestionBtn)
        nextQuestionBtn.setBackgroundImage(UIImage.init(named: "nextQuestion"), for: .normal)
        nextQuestionBtn.setTitle("下一题", for: .normal)
        nextQuestionBtn.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        bottomView.addConstraint(NSLayoutConstraint.init(item: nextQuestionBtn, attribute: .trailing, relatedBy: .equal, toItem: bottomView, attribute: .trailing, multiplier: 1.0, constant: -15))
        bottomView.addConstraint(NSLayoutConstraint.init(item: nextQuestionBtn, attribute: .centerY, relatedBy: .equal, toItem: bottomView, attribute: .centerY, multiplier: 1.0, constant: 0))
        
        lastQuestionBtn.addTarget(self, action: #selector(lastQuestionBtnTapped), for: .touchUpInside)
        nextQuestionBtn.addTarget(self, action: #selector(nextQuestionBtnTapped), for: .touchUpInside)
        lastQuestionBtn.isHidden = true
        
        
        sureBtn.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(sureBtn)
        sureBtn.backgroundColor = UIColor.init(red: 244/255.0, green: 247/255.0, blue: 250/255.0, alpha: 1.0)
        self.view.addConstraint(NSLayoutConstraint.init(item: sureBtn, attribute: .bottom, relatedBy: .equal, toItem: self.view, attribute: .bottom, multiplier: 1.0, constant: 0))
        self.view.addConstraint(NSLayoutConstraint.init(item: sureBtn, attribute: .width, relatedBy: .equal, toItem: self.view, attribute: .width, multiplier: 1.0, constant: 0))
        self.view.addConstraint(NSLayoutConstraint.init(item: sureBtn, attribute: .centerX, relatedBy: .equal, toItem: self.view, attribute: .centerX, multiplier: 1.0, constant: 0))
        self.view.addConstraint(NSLayoutConstraint.init(item: sureBtn, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 50))
        sureBtn.setBackgroundImage(UIImage.init(named: "topBackgroundIcon"), for: .normal)
        sureBtn.setTitle("提交试卷", for: .normal)
        sureBtn.addTarget(self, action: #selector(sureBtnTapped), for: .touchUpInside)
        sureBtn.isHidden = true
    }
    
    func lastQuestionBtnTapped() {
        questionIndex = questionIndex-1
        if questionIndex <= 0 {
            lastQuestionBtn.isHidden = true
        }
        requestQuestionItem(questionsid: self.headDataArr[questionIndex]["questionsid"].stringValue, isNextQuestionBtnTapped: false)
        (self.parent as! ExamingViewController).reloadHeadTitle(questionIndex:questionIndex)
    }
    
    func nextQuestionBtnTapped() {
        questionIndex = questionIndex+1
        lastQuestionBtn.isHidden = false
        if questionIndex >= headDataArr.count {
//            nextQuestionBtn.setTitle("确定", for: .normal)
//            self.dataDic.removeAll()
//            //            reloadHeadTitle()
//            MBProgressHUD.showError("已无更多题目", to: self.view)
//            self.tableview.reloadData()
//            return
            
            sureBtn.isHidden = false
            return
        }
        requestQuestionItem(questionsid: self.headDataArr[questionIndex]["questionsid"].stringValue, isNextQuestionBtnTapped: true)
        (self.parent as! ExamingViewController).reloadHeadTitle(questionIndex:questionIndex)
    }
    
    func sureBtnTapped() {
//        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
//        let examResultView = storyboard.instantiateViewController(withIdentifier: "ExamResultView")
//        self.navigationController?.pushViewController(examResultView, animated: true)
//        return;
        MBProgressHUD.showMessage("提交中", to: self.navigationController?.view)
        let urlString = "http://"+Ip_port2+"doctor_train/rest/taskExercisesResult/commitPaper.do"
        let parentInfo = (self.parent as! ExamingViewController).headInfo
        
        var params = JSON(["commit_questions":JSON.init(BRCommitDataManage.shared.allItemQuestions)]).dictionaryObject
        params?["token"] = UserInfo.instance().token
        params?["taskid"] = parentInfo["taskid"]
        params?["personid"] = parentInfo["bepersonid"]
        params?["exercisesid"] = parentInfo["exercisesid"]
        
        NetworkTool.sharedInstance.myPostRequest(urlString,params, method: HTTPMethod.post).responseJSON { (response) in
            MBProgressHUD.hide(for: self.navigationController?.view, animated: true)
            switch(response.result){
            case .failure(let error):
                print(error)
            case .success(let response):
                let json = JSON(response)
                if json["code"].stringValue == "1"{
                    let alert = UIAlertController.init(title: nil, message: "提交成功", preferredStyle: .alert)
                    self.present(alert, animated: true, completion: nil)
                    DispatchQueue.global().async {
                        Thread.sleep(forTimeInterval: 2.0)
                        DispatchQueue.main.async {
                            alert.dismiss(animated: true, completion: {
                                let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
                                let examResultView = storyboard.instantiateViewController(withIdentifier: "ExamResultView") as! ExamResultController
                                examResultView.dataSource = json["data"]
                                examResultView.listData = self.headDataArr
                                self.navigationController?.pushViewController(examResultView, animated: true)
                            })
                        }
                    }
                }else{
                    print("error")
                }
            }
        }
    }
    
    func requestQuestionItem(questionsid:String,isNextQuestionBtnTapped:Bool) {
        MBProgressHUD.showAdded(to: self.view, animated: true)
        let urlString = "http://"+Ip_port2+kQuerySkillquestionsitem
        NetworkTool.sharedInstance.myPostRequest(urlString, ["token":UserInfo.instance().token!,"questionsid":questionsid], method: HTTPMethod.post).responseJSON { (response) in
            MBProgressHUD.hide(for: self.view, animated: true)
            switch(response.result){
            case .failure(let error):
                print(error)
            case .success(let response):
                let json = JSON(response)
                if json["code"].stringValue == "1"{
//                    if isNextQuestionBtnTapped {
//                        if (BRCommitDataManage.shared.allItemQuestions != nil) {
//                            BRCommitDataManage.shared.allItemQuestions = try! BRCommitDataManage.shared.allItemQuestions.merged(with: json["data"])
//                        }else{
//                            BRCommitDataManage.shared.allItemQuestions = json["data"]
//                        }
//                    }
                    
                    if isNextQuestionBtnTapped {
                        BRCommitDataManage.shared.allItemQuestions += json["data"].arrayValue
                    }
                    
                    
//                        += json["data"].arrayValue
                    
//                    var aa = JSON([:])
//                    aa = json["data"]
//                    aa.dictionaryObject
//                    aa += json["data"]
                    
//                    BRCommitDataManage.shared.allItemQuestions.arrayValue += json["data"]
                    self.updateSubViewData(jsonData: json["data"].arrayValue)
                }else{
                    print("error")
                }
            }
        }
    }
    
    func updateSubViewData(jsonData:[JSON]) {
//        var addScoreArr = jsonData
//        for i in 0...addScoreArr.count-1 {
//            addScoreArr[i][""]
//        }
        if jsonData.count == 0 {
            self.dataDic.removeAll()
            self.tableview.reloadData()
            return
        }
        self.dataDic.removeAll()
        typeSortArr = [String]()
        for i in 0...jsonData.count-1 {
            let type = jsonData[i]["serialnumber"].stringValue
            if !typeSortArr.contains(type) {
                typeSortArr.append(type)
            }
        }
        var sortDic = [String:[JSON]]()
        for m in 0...typeSortArr.count-1 {
            let typeKey = typeSortArr[m]
            var dataArr = [JSON]()
            for n in 0...jsonData.count-1 {
                if typeKey == jsonData[n]["serialnumber"].stringValue {
                    dataArr.append(jsonData[n])
                }
            }
            sortDic[typeKey] = dataArr
        }
        self.dataDic = sortDic
        self.tableview.reloadData()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return dataDic.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let type = Array(dataDic.keys).sorted()[section]
        return (dataDic[type]?.count)!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SubScoreCell", for: indexPath) as! SubScoreCell
        cell.delegate = self
//        let type = Array(dataDic.keys).sorted()[indexPath.section]
        let type = typeSortArr[indexPath.section]
        let typeArr = dataDic[type]!
        
        cell.titleLabel.text = typeArr[indexPath.row]["title"].stringValue
        cell.scoreRule.text = typeArr[indexPath.row]["scorerule"].stringValue
//        cell.getscoreLabel.text = typeArr[indexPath.row]["getscore"].stringValue+"分"
        let scoreString = typeArr[indexPath.row]["getscore"].stringValue+"分"
        cell.getscoreBtn.setTitle(scoreString, for: .normal)
        return cell
    }
    
    func toMinusScore(_ sender: UIButton)
    {
        let currentCell = sender.superview?.superview as! SubScoreCell
        let indexPath = self.tableview.indexPath(for: currentCell)
        let type = Array(dataDic.keys).sorted()[(indexPath?.section)!]
        var typeArr = dataDic[type]!
        if typeArr[(indexPath?.row)!]["getscore"].intValue > 0 {
            typeArr[(indexPath?.row)!]["getscore"].intValue = typeArr[(indexPath?.row)!]["getscore"].intValue-1
        }
        dataDic[type] = typeArr
        
        self.tableview.reloadRows(at: [indexPath!], with: .automatic)
        for  info in BRCommitDataManage.shared.allItemQuestions {
            if info["serialnumber"] == typeArr[(indexPath?.row)!]["serialnumber"] && info["itemid"] == typeArr[(indexPath?.row)!]["itemid"]{
                let index = BRCommitDataManage.shared.allItemQuestions.index(of: info)
                BRCommitDataManage.shared.allItemQuestions[index!] = typeArr[(indexPath?.row)!]
            }
        }
    }
    func toAddScore(_ sender: UIButton)
    {
        let currentCell = sender.superview?.superview as! SubScoreCell
        let indexPath = self.tableview.indexPath(for: currentCell)
        let type = Array(dataDic.keys).sorted()[(indexPath?.section)!]
        var typeArr = dataDic[type]!
        if typeArr[(indexPath?.row)!]["getscore"].intValue < typeArr[(indexPath?.row)!]["score"].intValue {
            typeArr[(indexPath?.row)!]["getscore"].intValue = typeArr[(indexPath?.row)!]["getscore"].intValue+1
        }
        dataDic[type] = typeArr
        self.tableview.reloadRows(at: [indexPath!], with: .automatic)
        for  info in BRCommitDataManage.shared.allItemQuestions {
            if info["serialnumber"] == typeArr[(indexPath?.row)!]["serialnumber"] && info["itemid"] == typeArr[(indexPath?.row)!]["itemid"]{
                let index = BRCommitDataManage.shared.allItemQuestions.index(of: info)
                BRCommitDataManage.shared.allItemQuestions[index!] = typeArr[(indexPath?.row)!]
            }
        }
    }
    
    func toInputScore(_ sender: UIButton){
        let alertController = UIAlertController(title: "请输入分值", message: nil, preferredStyle: .alert)
        alertController.addTextField { (textField:UITextField) in
            textField.placeholder = "请输入分值"
            textField.keyboardType = .decimalPad
        }
        let cancelAction = UIAlertAction(title: "取消", style:.cancel, handler: nil)
        let okAction = UIAlertAction(title: "确定", style: .default) { (UIAlertAction) in
            let currentCell = sender.superview?.superview as! SubScoreCell
            let indexPath = self.tableview.indexPath(for: currentCell)
            let type = Array(self.dataDic.keys).sorted()[(indexPath?.section)!]
            var typeArr = self.dataDic[type]!
            let str = (alertController.textFields?[0].text)!.trimmingCharacters(in: .whitespaces)
            if let deduce = Float(str){
                if deduce <= typeArr[(indexPath?.row)!]["score"].floatValue{
                    typeArr[(indexPath?.row)!]["getscore"].floatValue = Float(String(format: "%.1f", deduce))!
                }
            }
            
            self.dataDic[type] = typeArr
            self.tableview.reloadRows(at: [indexPath!], with: .automatic)
            for  info in BRCommitDataManage.shared.allItemQuestions {
                if info["serialnumber"] == typeArr[(indexPath?.row)!]["serialnumber"] && info["itemid"] == typeArr[(indexPath?.row)!]["itemid"]{
                    let index = BRCommitDataManage.shared.allItemQuestions.index(of: info)
                    BRCommitDataManage.shared.allItemQuestions[index!] = typeArr[(indexPath?.row)!]
                }
            }
        }
        
        alertController.addAction(cancelAction)
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        view.tintColor = UIColor.white
        let operationLabel = UILabel()
        operationLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(operationLabel)
        operationLabel.backgroundColor = UIColor.init(red: 244/255.0, green: 247/255.0, blue: 250/255.0, alpha: 1.0)
        operationLabel.font = UIFont.systemFont(ofSize: 15.0)
        operationLabel.textColor = UIColor.init(red: 73/255.0, green: 144/255.0, blue: 226/255.0, alpha: 1.0)
        operationLabel.textAlignment = .center
        operationLabel.layer.cornerRadius = 33/2
        operationLabel.layer.masksToBounds = true
        
        let type = String(section+1)
        operationLabel.text = dataDic[type]?.first?["typename"].stringValue
        
        var viewWidth = getLabWidth(labelStr: (dataDic[type]?.first?["typename"].stringValue)!, font: 16, height: 33/2)
        if viewWidth < 40 {
            viewWidth = 40
        }
        view.addConstraint(NSLayoutConstraint.init(item: operationLabel, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1, constant: 0))
        view.addConstraint(NSLayoutConstraint.init(item: operationLabel, attribute: .centerY, relatedBy: .equal, toItem: view, attribute: .centerY, multiplier: 1, constant: 0))
        view.addConstraint(NSLayoutConstraint.init(item: operationLabel, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: viewWidth))
        view.addConstraint(NSLayoutConstraint.init(item: operationLabel, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 33))
    }
    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        tableView.deselectRow(at: indexPath, animated: true)
//        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
//        let computeScoreVC = storyboard.instantiateViewController(withIdentifier: "ComputeScoreView") as! ComputeScoreController
//        let type = Array(dataDic.keys)[indexPath.section]
//        let typeArr = dataDic[type]!
//        computeScoreVC.itemData = typeArr[indexPath.row]
//        self.navigationController?.pushViewController(computeScoreVC, animated: true)
//    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
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
