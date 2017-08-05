//
//  AnswerDetailController.swift
//  DoctorManage
//
//  Created by 陈海峰 on 2017/6/22.
//  Copyright © 2017年 chenshengchang. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
class AnswerDetailController: UIViewController,UITableViewDelegate,UITableViewDataSource,InputTextControllerDelegate,UITextFieldDelegate {
    var inputTextController: InputTextController = InputTextController()
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var textField: UITextField!
    var tableView = UITableView()
    var dataSource = JSON([:])
    var replayListArr:[JSON] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "答疑"
        let image = UIImage(named: "返回")!.withRenderingMode(.alwaysOriginal)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image:image, style: .done, target: self, action: #selector(backAction))
        setSubviews()
        addObserver()
    }

    
    func setSubviews() {
        tableView.frame = CGRect.init(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height-64-49)
        tableView.delegate = self
        tableView.dataSource = self
        self.view.addSubview(tableView)
        tableView.tableFooterView = UIView()
        tableView.separatorStyle = .none
        let nib1 = UINib(nibName: "AnswerListCell", bundle: nil)
        tableView.register(nib1, forCellReuseIdentifier: "AnswerListCell")
        let nib2 = UINib(nibName: "ReplayInfoCell", bundle: nil)
        tableView.register(nib2, forCellReuseIdentifier: "ReplayInfoCell")
        tableView.register(UITableViewCell.classForCoder(), forCellReuseIdentifier: "tableviewCell")
        
        inputTextController = InputTextController()
        inputTextController.setup(vc: self, parentViewWidth: self.view.bounds.width)
        inputTextController.delegate = self
        textField.delegate = self
//        titleArr = ["如果你无法简单的表达你的想法,那说明你还不够了解他","如果你无法简单的表达你的想法,那说明你还不够了解他"]
        requestReplylist()
    }

    func requestReplylist() {
        MBProgressHUD.showAdded(to: self.view, animated: true)
        let urlString = "http://"+Ip_port2+"doctor_train/rest/difficult/queryDifficultAndAnswer.do"
        NetworkTool.sharedInstance.myPostRequest(urlString,["token":UserInfo.instance().token!,"difficultid":dataSource["difficultid"].stringValue], method: HTTPMethod.post).responseJSON { (response) in
            MBProgressHUD.hide(for: self.view, animated: true)
            switch(response.result){
            case .failure(let error):
                print(error)
            case .success(let response):
                let json = JSON(response)
                if json["code"].stringValue == "1"{
                    self.replayListArr = json["data"][0]["answers"].arrayValue
                    self.tableView.reloadData()
                }else{
                    print("error")
                }
            }
        }
    }

    // MARK: - Table view data source
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }
        return replayListArr.count+1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "AnswerListCell", for: indexPath) as! AnswerListCell
            cell.titleLabel.text = dataSource["title"].stringValue
            cell.timeLabel.text = dataSource["createtime"].stringValue
            cell.nameLabel.text = dataSource["personname"].stringValue
            return cell
        }else{
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "tableviewCell")
                cell?.textLabel?.text = "回复信息"
                cell?.selectionStyle = .none
                return cell!
            }else{
                let cell = tableView.dequeueReusableCell(withIdentifier: "ReplayInfoCell") as! ReplayInfoCell
                cell.titleLabel.text = replayListArr[indexPath.row-1]["answercontent"].stringValue
                cell.nameLabel.text = replayListArr[indexPath.row-1]["rolename"].stringValue+" "+replayListArr[indexPath.row-1]["creater"].stringValue
                cell.timeLabel.text = replayListArr[indexPath.row-1]["createtime"].stringValue
                return cell
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.view.endEditing(true)
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 15
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 100
        }else if indexPath.row == 0 {
            return 44
        }
        return replayListArr[indexPath.row-1]["answercontent"].stringValue.heightWithConstrainedWidth(width: self.view.frame.size.width-55, font: UIFont.systemFont(ofSize: 14))+60
    }

    public func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        inputTextController.removeObserver()
        inputTextController.addObserver()
        inputTextController.show()
        return false
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func requestReplyData(inputText:String,keyboardOrigin:CGFloat) {
        MBProgressHUD.showAdded(to: self.view, animated: true)
        let urlString = "http://"+Ip_port2+"doctor_train/rest/difficult/saveAnswer.do"
        NetworkTool.sharedInstance.myPostRequest(urlString,["token":UserInfo.instance().token!,"difficultid":dataSource["difficultid"].stringValue,"answercontent":inputText,"role":"2"], method: HTTPMethod.post).responseJSON { (response) in
            MBProgressHUD.hide(for: self.view, animated: true)
            switch(response.result){
            case .failure(let error):
                print(error)
            case .success(let response):
                let json = JSON(response)
                if json["code"].stringValue == "1"{
                    self.replayListArr = json["data"][0]["answers"].arrayValue
//                    self.tableView.frame = CGRect.init(x: 0, y: 0, width: self.view.frame.size.width, height: keyboardOrigin)
                    self.tableView.reloadData()
                    self.tableView.scrollToRow(at: IndexPath.init(row: self.replayListArr.count, section: 1), at: .top, animated: true)
                }else{
                    print("error")
                }
            }
        }
    }
    
    func onFinishInput(text: String){
        requestReplyData(inputText: text, keyboardOrigin: inputTextController.editTextContainerView.frame.origin.y)
        tableView.reloadData()
        inputTextController.removeObserver()
    }
    
    
    
    func deselectObject(){

    }
    
    func viewDidHide(){
        
    }
    
    func viewDidShow(){

    }
    
    func addObserver() {
        let defaultCenter = NotificationCenter.default
//        defaultCenter.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        defaultCenter.addObserver(self, selector: #selector(keyboardDidShow), name: NSNotification.Name.UIKeyboardDidShow, object: nil)
        defaultCenter.addObserver(self, selector: #selector(keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    //MARK: - keyboardNotification
    
    func keyboardDidShow(notification: NSNotification){
        guard let info: Dictionary = notification.userInfo else {
            return
        }
        guard let keyboardFrame: CGRect = (info[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
            return
        }
        
        self.tableView.frame = CGRect.init(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height-keyboardFrame.size.height-50)
        
        self.tableView.scrollToRow(at: IndexPath.init(row: self.tableView.numberOfRows(inSection: 1)-1, section: 1), at: .top, animated: false)
//        isShowKeyboard = true
//        updateLayoutConstant(value: -1 * keyboardFrame.size.height)
//        tvHeightConstraint?.constant = kEditTextContainerViewHeight
//        
//        UIView.animate(withDuration: duration) { () -> Void in
//            self.updateLayout(alpha: 1.0)
//        }
    }
    
    func keyboardWillHide(notification: NSNotification){
        self.tableView.frame = CGRect.init(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height-50)
        self.tableView.scrollToRow(at: IndexPath.init(row: self.tableView.numberOfRows(inSection: 1)-1, section: 1), at: .bottom, animated: false)
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
