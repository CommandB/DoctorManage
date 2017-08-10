//
//  ArrangeTaskController.swift
//  DoctorManage
//
//  Created by 陈海峰 on 2017/7/22.
//  Copyright © 2017年 chenshengchang. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire
class ArrangeTaskController: UIViewController,UITableViewDelegate,UITableViewDataSource,UITextViewDelegate,ZHDropDownMenuDelegate {
    @IBOutlet weak var tableView: UITableView!
//    @IBOutlet weak var typeTextField: UITextField!
    @IBOutlet weak var beginTextField: UITextField!
    @IBOutlet weak var endTextField: UITextField!
    @IBOutlet weak var addressTextField: UITextField!
    @IBOutlet weak var remarkTextView: UITextView!
    @IBOutlet weak var dropMenu: ZHDropDownMenu!
    
    let beginDatePicker = UIDatePicker()
    let endDatePicker = UIDatePicker()
    var beginDateFormatter = DateFormatter()
    var endDateFormatter = DateFormatter()
    var taskPicker = UIPickerView()
//    var receiveData:[JSON] = [JSON]()
    var receiveData = JSON([:])
    var trainTypeArr = ["理论培训","技能培训","小讲座","病例讨论","教学查房","面授","入科教育","自主训练"]
    var selectTrainTypeIndex = -1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(named: "topBack.png"), for: .default)
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.white]
        let image = UIImage(named: "返回")!.withRenderingMode(.alwaysOriginal)
        self.title = "任务安排"
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image:image, style: .done, target: self, action: #selector(dismissAction))
        let nib = UINib.init(nibName: "ArrangeTaskCell", bundle: nil)
        self.tableView.register(nib, forCellReuseIdentifier: "ArrangeTaskCell")
        self.tableView.tableFooterView = UIView()
        dropMenu.options = trainTypeArr //设置下拉列表项数据
        dropMenu.menuHeight = 240;//设置最大高度
        dropMenu.delegate = self //设置代理
//        trainTypeArr = ["理论培训","技能培训","小讲座","病例讨论","教学查房","面授","入科教育","自主训练"]
        setInputView()
        // Do any additional setup after loading the view.
    }

    func setInputView() {
        beginDatePicker.datePickerMode = .dateAndTime
        beginDatePicker.addTarget(self, action: #selector(beginDateChanged), for: .valueChanged)
        beginTextField.addTarget(self, action: #selector(beginDateChanged), for: .touchDown)
        beginDateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        endDatePicker.datePickerMode = .dateAndTime
        endDatePicker.addTarget(self, action: #selector(endDateChanged), for: .valueChanged)
        endTextField.addTarget(self, action: #selector(endDateChanged), for: .touchDown)
        endDateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        beginTextField.inputView = beginDatePicker
        endTextField.inputView = endDatePicker
    }
    
    func beginDateChanged() {
        endDatePicker.endEditing(false)
        beginTextField.text = beginDateFormatter.string(from: beginDatePicker.date)
    }
    
    func endDateChanged() {
        beginDatePicker.endEditing(true)
        endTextField.text = endDateFormatter.string(from: endDatePicker.date)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return receiveData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ArrangeTaskCell", for: indexPath) as! ArrangeTaskCell
        cell.nameLabel.text = receiveData[indexPath.row]["personname"].stringValue
        cell.sexlabel.text = receiveData[indexPath.row]["sexname"].stringValue
        cell.phoneLabel.text = receiveData[indexPath.row]["phoneno"].stringValue
        cell.seniorLabel.text = receiveData[indexPath.row]["gradename"].stringValue
        cell.majorLabel.text = receiveData[indexPath.row]["subjectname"].stringValue
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func dismissAction() {
        self.navigationController?.dismiss(animated: true, completion: nil)
        
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
        taskPicker.isHidden = true
    }
    
    @IBAction func sureAction(_ sender: UIButton) {
//        if typeTextField.text == "请选择任务类型" {
//            MBProgressHUD.showError("先选择任务类型", to: self.view)
//            return
//        }
        if selectTrainTypeIndex == -1 {
            MBProgressHUD.showError("先选择任务类型", to: self.view)
            return
        }
        if beginTextField.text == "" {
            MBProgressHUD.showError("先选择开始时间", to: self.view)
            return
        }
        if endTextField.text == "" {
            MBProgressHUD.showError("先选择结束时间", to: self.view)
            return
        }
        if addressTextField.text == "" {
            MBProgressHUD.showError("先输入地址", to: self.view)
            return
        }
        let str = remarkTextView.text.trimmingCharacters(in: .whitespaces)
        if str == "备注" || str == ""{
            MBProgressHUD.showError("先输入备注", to: self.view)
            return
        }
        MBProgressHUD.showMessage("安排中", to: self.navigationController?.view)
        var params = JSON(["student":receiveData]).dictionaryObject
        params?["fromapp"] = "1"
        params?["sourcetype"] = "3"
        params?["type"] = "1"
        params?["begintime"] = beginTextField.text!
        params?["enddate"] = endTextField.text!
//        params?["traintype"] = trainTypeArr.index(of: typeTextField.text!)
//        params?["taskname"] = typeTextField.text!+"申请安排"
        params?["traintype"] = String(selectTrainTypeIndex)
        params?["taskname"] = trainTypeArr[selectTrainTypeIndex]+"申请安排"
        params?["token"] = UserInfo.instance().token
        var sourceid:String!
        
        for info in receiveData.arrayValue {
            if sourceid != nil{
                sourceid = sourceid+","+info["wishlistid"].stringValue
            }else{
                sourceid = info["wishlistid"].stringValue
            }
        }
        params?["sourceid"] = sourceid
        
        let urlString = "http://"+Ip_port2+"doctor_train/rest/task/addTask.do"
        NetworkTool.sharedInstance.myPostRequest(urlString,params, method: HTTPMethod.post).responseJSON { (response) in
            MBProgressHUD.hideAllHUDs(for: self.navigationController?.view, animated: true)
            switch(response.result){
            case .failure(let error):
                print(error)
            case .success(let response):
                let json = JSON(response)
                if json["code"].stringValue == "1"{
                    BRAlertView.show(message: "安排成功", target: self, duration: 2.0)
                }else{
                    MBProgressHUD.showError("安排失败", to: self.view)
                    print("error")
                }
            }
        }
    }
    
    //MARK: - UITextViewDelegate
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.lengthOfBytes(using: .utf8) < 1 {
            textView.text = "备注"
            textView.textColor = .gray
        }
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == "备注" {
            textView.text = ""
            textView.textColor = .black
        }
    }
    
    //选择完后回调
    func dropDownMenu(_ menu: ZHDropDownMenu!, didChoose index: Int) {
        print("\(menu) choosed at index \(index)")
        selectTrainTypeIndex = index
    }
    
    //编辑完成后回调
    func dropDownMenu(_ menu: ZHDropDownMenu!, didInput text: String!) {
        print("\(menu) input text \(text)")
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
