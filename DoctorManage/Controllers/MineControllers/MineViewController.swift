//
//  MineViewController.swift
//  DoctorManage
//
//  Created by 陈海峰 on 2017/6/2.
//  Copyright © 2017年 chenshengchang. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
class MineViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,InfoHeadCellDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    var tableView = UITableView()
    var infoData:JSON = JSON("")
    var onlineQuestionData:[JSON] = []
    let imagePicker = UIImagePickerController()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.setBackgroundImage(UIImage.init(named: "topBackgroundIcon"), for: .default)
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.white]
        self.title = "我的"
        let image = UIImage(named: "设置")!.withRenderingMode(.alwaysOriginal)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image:image, style: .done, target: self, action: #selector(setAction))
        tableView.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        self.extendedLayoutIncludesOpaqueBars = true
        self.view.addSubview(tableView)
        let nib1 = UINib(nibName: "InfoHeadCell", bundle: nil)
        self.tableView.register(nib1, forCellReuseIdentifier: "InfoHeadCell")
        let nib2 = UINib(nibName: "MineEvaluateCell", bundle: nil)
        self.tableView.register(nib2, forCellReuseIdentifier: "MineEvaluateCell")
        let nib3 = UINib(nibName: "LearnResourceCell", bundle: nil)
        self.tableView.register(nib3, forCellReuseIdentifier: "LearnResourceCell")
        let nib4 = UINib(nibName: "OnlineHeadCell", bundle: nil)
        self.tableView.register(nib4, forCellReuseIdentifier: "OnlineHeadCell")
        let nib5 = UINib(nibName: "OnlineContentCell", bundle: nil)
        self.tableView.register(nib5, forCellReuseIdentifier: "OnlineContentCell")
        let nib6 = UINib(nibName: "WebModuleCell", bundle: nil)
        self.tableView.register(nib6, forCellReuseIdentifier: "WebModuleCell")
        self.tableView.register(UITableViewCell.classForCoder(), forCellReuseIdentifier: "tableViewCell")
        requestMyInfo()
        requestOnlineQuestions()
        self.tableView.mj_header = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: #selector(refreshAction))
    }
    
    func refreshAction() {
        requestMyInfo()
        requestOnlineQuestions()
    }
    
    func requestMyInfo() {
        MBProgressHUD.showAdded(to: self.navigationController?.view, animated: true)
        let urlString = "http://"+Ip_port2+kMyInfoURL
        NetworkTool.sharedInstance.myPostRequest(urlString, ["token":UserInfo.instance().token], method: HTTPMethod.post).responseJSON { (response) in
            self.tableView.mj_header.endRefreshing()
            MBProgressHUD.hideAllHUDs(for: self.navigationController?.view, animated: true)
            switch(response.result){
            case .failure(let error):
                print(error)
            case .success(let response):
                let json = JSON(response)
                if json["code"].stringValue == "1"{
                    self.infoData = json["data"]
                    self.tableView.reloadData()
                }else{
                    print("error")
                }
            }
        }
        
    }
    
    func requestOnlineQuestions() {
        let urlString = "http://"+Ip_port2+kOnlineQuestionURL
        NetworkTool.sharedInstance.myPostRequest(urlString, ["pageindex":"0","pagesize": "10","token":UserInfo.instance().token], method: HTTPMethod.post).responseJSON { (response) in
            self.tableView.mj_header.endRefreshing()
            switch(response.result){
            case .failure(let error):
                print(error)
            case .success(let response):
                let json = JSON(response)
                if json["code"].stringValue == "1"{
                    self.onlineQuestionData = json["data"].arrayValue
                    self.tableView.reloadData()
                }else{
                    print("error")
                }
            }
        }
    }
    
    // MARK: - Table view data source
    func numberOfSections(in tableView: UITableView) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section < 4 {
            return 1
        }else if onlineQuestionData.count < 4{
            return onlineQuestionData.count+1
        }
        return 5
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "InfoHeadCell", for: indexPath) as! InfoHeadCell
            if let photourl = URL.init(string: infoData["photourl"].stringValue) {
                cell.photoBtn.sd_setBackgroundImage(with: photourl, for: .normal, placeholderImage: UIImage.init(named: "个人中心"))
            }else{
                cell.photoBtn.setBackgroundImage(UIImage.init(named: "个人中心"), for: .normal)
            }
            cell.personName.text = infoData["personname"].stringValue
            cell.phoneNum.text = infoData["phoneno"].stringValue
            cell.officeName.text = infoData["officename"].stringValue
            cell.jobNum.text = infoData["jobnum"].stringValue
            cell.highestDegree.text = infoData["highestdegree"].stringValue
            cell.delegate = self
            return cell
        }else if indexPath.section == 1{
            let cell = tableView.dequeueReusableCell(withIdentifier: "WebModuleCell", for: indexPath) as! WebModuleCell
            
            
            let webModule = UserDefaults.standard.string(forKey: AppConfiguration.webModule.rawValue)
            if webModule != nil{
                let json = JSON.init(parseJSON: webModule!).arrayValue
                var index = 1
                for item in json{
                    let btn = cell.viewWithTag(30000+index) as! UIButton
                    btn.set(image: UIImage(named: "扫一扫-白"), title: item["modulename"].stringValue, titlePosition: .bottom, additionalSpacing: 10.0, state: .normal)
                    btn.addTarget(self, action: #selector(openWebView), for: .touchUpInside)
                    index += 1
                    btn.isHidden = false
                }
            }
            return cell
        }else if indexPath.section == 2{
            let cell = tableView.dequeueReusableCell(withIdentifier: "MineEvaluateCell", for: indexPath) as! MineEvaluateCell
            if infoData["evaluation_count"].stringValue != ""{
                let evaluation_count = infoData["evaluation_count"].stringValue
                let valuateStr = NSMutableAttributedString(string: evaluation_count)
                valuateStr.addAttribute(NSForegroundColorAttributeName, value: UIColor.init(red: 249/255.0, green: 80/255.0, blue: 80/255.0, alpha: 1.0),
                                        range: NSMakeRange(0, valuateStr.length))
                let appendStr1 = NSMutableAttributedString(string: "人评价")
                valuateStr.append(appendStr1)
                cell.valuateLabel.attributedText = valuateStr
            }
            if infoData["evaluation_okratename"].stringValue != "" {
                let evaluation_okrate = infoData["evaluation_okratename"].stringValue.removingPercentEncoding
                let favoRatioStr = NSMutableAttributedString(string: "好评率")
                let appendStr2 = NSMutableAttributedString(string: evaluation_okrate!)
                appendStr2.addAttribute(NSForegroundColorAttributeName, value: UIColor.init(red: 249/255.0, green: 80/255.0, blue: 80/255.0, alpha: 1.0),
                                        range: NSMakeRange(0, appendStr2.length))
                favoRatioStr.append(appendStr2)
                cell.favoRatioLabel.attributedText = favoRatioStr
            }
            
            return cell
        }else if indexPath.section == 3{
            let cell = tableView.dequeueReusableCell(withIdentifier: "LearnResourceCell", for: indexPath) as! LearnResourceCell
            if infoData["teachingcount"].stringValue != ""{
                let teachingcount = infoData["teachingcount"].stringValue
                let teachingcountStr = NSMutableAttributedString(string: teachingcount)
                let resourceStr = NSMutableAttributedString(string: "共有资源个")
                teachingcountStr.addAttribute(NSForegroundColorAttributeName, value: UIColor.init(red: 249/255.0, green: 80/255.0, blue: 80/255.0, alpha: 1.0),range: NSMakeRange(0, teachingcountStr.length))
                resourceStr.insert(teachingcountStr, at: 4)
                cell.contentLabel.attributedText = resourceStr
            }
            cell.titleLabel.text = "学习资源"
            return cell
            
        }else{
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "OnlineHeadCell", for: indexPath) as! OnlineHeadCell
                return cell
            }else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "OnlineContentCell", for: indexPath) as! OnlineContentCell
                cell.roomLabel.text = onlineQuestionData[indexPath.row-1]["studenttype"].stringValue
                cell.contentLabel.text = String(indexPath.row)+". "+onlineQuestionData[indexPath.row-1]["title"].stringValue
                return cell
            }
//            var cell = tableView.dequeueReusableCell(withIdentifier: "tableViewCell", for: indexPath)
//            cell.selectionStyle = .none
//            addSeeMoreView(cell: &cell)
//            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 140
        }else if indexPath.section == 1{
            return 115
        }else if indexPath.section == 2 || indexPath.section == 3{
            return 80
        }else if indexPath.row == 0 {
            return 40
        }else{
            return 60
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 5
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.section == 2 {
            let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
            let mineEvaluateVC = storyboard.instantiateViewController(withIdentifier: "MineEvaluateView")
            self.present(mineEvaluateVC, animated: true, completion: nil)
        }
        else if indexPath.section == 3 {
            let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
            let mineResourceVC = storyboard.instantiateViewController(withIdentifier: "MineResourceView")
            self.present(mineResourceVC, animated: true, completion: nil)
        }else if indexPath.section == 4{
            if indexPath.row > 0 && indexPath.row < 4{
                let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
                let answerDetailVC = storyboard.instantiateViewController(withIdentifier: "answerDetailView") as! AnswerDetailController
                answerDetailVC.dataSource = onlineQuestionData[indexPath.row-1]
                self.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(answerDetailVC, animated: true)
                self.hidesBottomBarWhenPushed = false
            }else{
                self.hidesBottomBarWhenPushed = true
                let answerListVC = AnswerListController()
                answerListVC.questionListArr = self.onlineQuestionData
                self.navigationController?.pushViewController(answerListVC, animated: true)
                self.hidesBottomBarWhenPushed = false
            }
        }
    }
    
    func addSeeMoreView(cell:inout UITableViewCell) {
        let seeMoreLabel = UILabel()
        cell.addSubview(seeMoreLabel)
        seeMoreLabel.translatesAutoresizingMaskIntoConstraints = false
        cell.addConstraint(NSLayoutConstraint.init(item: seeMoreLabel, attribute: .centerX, relatedBy: .equal, toItem: cell, attribute: .centerX, multiplier: 1.0, constant: 0))
        cell.addConstraint(NSLayoutConstraint.init(item: seeMoreLabel, attribute: .centerY, relatedBy: .equal, toItem: cell, attribute: .centerY, multiplier: 1.0, constant: -5))
        cell.addConstraint(NSLayoutConstraint.init(item: seeMoreLabel, attribute: .width, relatedBy: .equal, toItem: cell, attribute: .width, multiplier: 1.0, constant: 0))
        cell.addConstraint(NSLayoutConstraint.init(item: seeMoreLabel, attribute: .height, relatedBy: .equal, toItem: cell, attribute: .height, multiplier: 1.0, constant: 0))
        seeMoreLabel.text = "查看更多"
        seeMoreLabel.font = UIFont.systemFont(ofSize: 15)
        seeMoreLabel.textAlignment = .center
        seeMoreLabel.backgroundColor = UIColor.init(red: 245/255.0, green: 248/255.0, blue: 251, alpha: 1.0)
        seeMoreLabel.textColor = UIColor.init(red: 73/255.0, green: 144/255.0, blue: 226/255.0, alpha: 1.0)
    }
    
    func setAction(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let settingView = storyboard.instantiateViewController(withIdentifier: "SettingView")
        self.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(settingView, animated: true)
        self.hidesBottomBarWhenPushed = false
    }
    
    func photoBtnTapped(photoBtn: UIButton){
        let userIconAlert = UIAlertController(title: nil, message: "请选择操作", preferredStyle: .actionSheet)
        let selectPhotoAction = UIAlertAction.init(title: "从相册选择", style: .default, handler:{
            (alert: UIAlertAction!) -> Void in
                let imagePicker = UIImagePickerController()
                imagePicker.delegate = self
                //允许编辑
                imagePicker.allowsEditing = true
                imagePicker.sourceType = .photoLibrary
                self.present(imagePicker, animated: true, completion: nil)
        })
        let chooseCameraAction = UIAlertAction.init(title: "拍照", style: .default, handler:{
            (alert: UIAlertAction!) -> Void in
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.allowsEditing = true
            imagePicker.sourceType = .camera
            self.present(imagePicker, animated: true, completion: nil)
        })
        let canelAction = UIAlertAction(title: "取消", style: .cancel,handler: nil)
        userIconAlert.addAction(selectPhotoAction)
        userIconAlert.addAction(chooseCameraAction)
        userIconAlert.addAction(canelAction)
        self.present(userIconAlert, animated: true, completion: nil)
    }

    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            MBProgressHUD.showAdded(to: self.navigationController?.view, animated: true)
            let urlString = "http://"+Ip_port2+"doctor_train/rest/person/updateMyPhoto.do"
        NetworkTool.sharedInstance.uploadImage(urlString, images: ["image":image], parameters: ["token":UserInfo.instance().token], completionHandler: { (dataResponse) in
            MBProgressHUD.hide(for: self.navigationController?.view, animated: true)
            switch dataResponse.result{
            case .success:
                self.requestMyInfo()
            case .failure:
                MBProgressHUD.hide(for: self.navigationController?.view)
                MBProgressHUD.showSuccess("更改失败")
            }
        })
        } else{
            print("Something went wrong")
        }
        picker.dismiss(animated: true, completion: nil)
    }

    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController){
        picker.dismiss(animated: true, completion: nil)
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func openWebView(sender: UIButton){
        let webModule = UserDefaults.standard.string(forKey: AppConfiguration.webModule.rawValue)
        let json = JSON.init(parseJSON: webModule!).arrayValue
        let index = sender.tag - 30001
        var url = json[index]["moduleurl"].stringValue
        url = "http://"+Ip_port2 + url + "?token=" + UserInfo.instance().token
        let vc = getViewToStoryboard("webView") as! WebViewController
        vc.webUrl = url
        vc.viewTitlte = json[index]["modulename"].stringValue
        present(vc, animated: true, completion: nil)
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
