//
//  ExamingViewController.swift
//  jisoshi5
//
//  Created by chenhaifeng  on 2017/6/16.
//  Copyright © 2017年 chenhaifeng . All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
class ExamingViewController: UIViewController,UIScrollViewDelegate {
    @IBOutlet weak var bottomLine: UILabel!
    @IBOutlet weak var scrollview: UIScrollView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    var tableview = UITableView()
    var headInfo:NSDictionary  = NSDictionary()
    var dataSource:[JSON] = []
    var scoreVC = ExamingSubScoController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "考试中"
        let image = UIImage(named: "返回")!.withRenderingMode(.alwaysOriginal)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image:image, style: .done, target: self, action: #selector(backAction))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "考题列表", style: .done, target: self, action: #selector(displayExamList))
        setSubviews()
        requestExamInfo()
    }
    
    func requestExamInfo(){
        let urlString = "http://"+Ip_port2+kSkillQuestionURl
        NetworkTool.sharedInstance.myPostRequest(urlString, ["token":UserInfo.instance().token!,"exercisesid":headInfo["exercisesid"]!], method: HTTPMethod.post).responseJSON { (response) in
            switch(response.result){
            case .failure(let error):
                print(error)
            case .success(let response):
                let json = JSON(response)
                if json["code"].stringValue == "1"{
                    self.dataSource = json["data"].arrayValue
                    //                    self.tableview.reloadData()
                    if self.dataSource.count > 0{
                        self.scoreVC.headDataArr = self.dataSource
                        self.reloadHeadTitle(questionIndex: 0)
                        self.scoreVC.requestQuestionItem(questionsid: self.dataSource[0]["questionsid"].stringValue, isNextQuestionBtnTapped: true)
                        self.scoreVC.nextQuestionBtn.isHidden = false
                    }else{
                        self.scoreVC.nextQuestionBtn.isHidden = true
                    }
                }else{
                    print("error")
                }
            }
        }
    }
    
    
    func setSubviews() {
        scrollview.contentSize = CGSize(width: self.view.bounds.size.width*2, height: 0)
        self.automaticallyAdjustsScrollViewInsets = false
        scoreVC = ExamingSubScoController()
        scoreVC.view.frame = CGRect(x: 0, y: 0, width: scrollview.frame.size.width, height: scrollview.bounds.size.height)
        let scriptVC = ExamingSubScrController()
        scriptVC.view.frame = CGRect(x: self.view.bounds.size.width, y: 0, width: scrollview.bounds.size.width, height: scrollview.bounds.size.height)
        scrollview.delegate = self
        self.addChildViewController(scoreVC)
        self.addChildViewController(scriptVC)
        scrollview.addSubview(scoreVC.view)
        scrollview.addSubview(scriptVC.view)
        scrollview.isDirectionalLockEnabled = true
    }
    
    @IBAction func didTapBtn(_ sender: Any) {
        bottomLine.center = CGPoint.init(x: (sender as! UIButton).center.x, y:  bottomLine.center.y)
        scrollview.contentOffset = CGPoint.init(x: CGFloat((sender as! UIButton).tag-1000) * self.view.bounds.size.width, y: 0)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let btn = self.view.viewWithTag(1000+Int(scrollview.contentOffset.x/self.view.bounds.size.width))
        bottomLine.center = CGPoint.init(x: (btn as! UIButton).center.x, y:  bottomLine.center.y)
        
    }
    
    func reloadHeadTitle(questionIndex:Int) {
        titleLabel.text = dataSource[questionIndex]["indexname"].stringValue+dataSource[questionIndex]["title"].stringValue
//        scoreLabel.text = questionsscore
        scoreLabel.text = "总分"+dataSource[questionIndex]["questionsscore"].stringValue
    }
    
    @IBAction func confirmAction(_ sender: Any) {
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        let examResultView = storyboard.instantiateViewController(withIdentifier: "ExamResultView")
        self.navigationController?.pushViewController(examResultView, animated: true)
    }
    
    func displayExamList() {
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        let questionListView = storyboard.instantiateViewController(withIdentifier: "questionListView") as! QuestionListController
        questionListView.listData = dataSource
        self.navigationController?.pushViewController(questionListView, animated: true)
    }
    func backAction(_ sender: Any) {
        myConfirm(self, message:"是否退出考试?" ,
                  okHandler:{action in
                    
                    self.navigationController?.popViewController(animated: true)
                    
        } , cancelHandler:{action in
            
        })
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
