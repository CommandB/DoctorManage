//
//  LoginViewController.swift
//  DoctorManage
//
//  Created by 陈海峰 on 2017/6/4.
//  Copyright © 2017年 chenshengchang. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController,SelectBaseViewDelegate,UIPickerViewDelegate,UIPickerViewDataSource,UIAlertViewDelegate {
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var selectBaseBtn: UIButton!
    @IBOutlet weak var basePickerView: UIPickerView!
    @IBOutlet weak var logoImageView: UIImageView!
    var dataSource:[NSDictionary] = [NSDictionary]()
    var basename = ""
    var baseportalurl = ""
    var ipPort = "www.jiuhuatech.com"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let loginInfo = UserDefaults.standard.dictionary(forKey: "loginInfo") {
            userNameTextField.text = loginInfo["loginid"] as? String
            passwordTextField.text = loginInfo["password"] as? String
            basename = loginInfo["basename"] as! String
            baseportalurl = loginInfo["baseportalurl"] as! String
            selectBaseBtn.setTitle(basename, for: .normal)
            ipPort = loginInfo["ipUrl"] as! String
//            basePickerView.selectRow(<#T##row: Int##Int#>, inComponent: 0, animated: false)
        }
    }
    
    @IBAction func loginBtnTapped(_ sender: Any) {
        if userNameTextField.text?.lengthOfBytes(using: .utf8) == 0 {
            BRAlertView.show(message: "请输入账号", target: self)
            return
        }
        if passwordTextField.text?.lengthOfBytes(using: .utf8) == 0 {
            BRAlertView.show(message: "请输入密码", target: self)
            return
        }
        if selectBaseBtn.titleLabel?.text == "请选择基地" || selectBaseBtn.titleLabel?.text == "选择基地"{
            BRAlertView.show(message: "请先选择基地", target: self)
            return
        }
        if !iSReachable() {
            MBProgressHUD.showError("请检查网络", to: self.view)
            return
        }
        MBProgressHUD.showAdded(to: self.view, animated: true)
        let params = ["myshop_forapp_key":"987654321",
                      "loginid":userNameTextField.text!,
                      "password": passwordTextField.text!.sha1(),"baseportalurl":baseportalurl] as [String : Any]
        NetworkTool.login(params: params as! [String : String] , success: { (response) in
            MBProgressHUD.hide(for: self.view, animated: true)
            if !iSRequestSuccess(data: response as! [String : String]){
                MBProgressHUD.showError(response["msg"] as! String, to: self.view)
                return
            }
            Ip_port2 = self.ipPort+"/"
            UserInfo.instance().save(response)
            self.saveLoginIngo(loginInfo: ["loginid":self.userNameTextField.text!,"password": self.passwordTextField.text!])
            //请求App相对固定的数据和配置
            AppStableDataModel().getStableData()
            
            NetworkTool.getUserOffice(params :["token":UserInfo.instance().token], success : { resp in
                if resp["code"].string == "1"{
                    //g_userOffice = resp["data"].arrayValue
                    UserInfo.instance().saveOfficeInfo(try! resp["data"].rawData());
                    
                    //缓存app配置信息
                    let appConfig = resp["appconfig"].arrayValue
                    for config in appConfig{
                        let name = config["name"].stringValue
                        let val = config["value"].stringValue
                        if  name == AppConfiguration.teacherCreateNoticeText.rawValue{
                            UserDefaults.standard.set(val, forKey: AppConfiguration.teacherCreateNotice.rawValue)
                        }else if name == AppConfiguration.signInTakePhotoText.rawValue{
                            UserDefaults.standard.set(val, forKey: AppConfiguration.signInTakePhoto.rawValue)
                        }
                    }
                    
                    //解析角色信息并缓存
//                    let role = json["role"].arrayValue
//                    var roleDic = [String:Bool]()
//                    if role.count > 0{
//                        let r = role[0]
//                        for item in r{
//                            if "0" == item.1{
//                                roleDic[item.0] = false
//                            }else{
//                                roleDic[item.0] = true
//                            }
//                        }
//                    }
//                    UserDefaults.standard.set(roleDic, forKey: LoginInfo.role.rawValue)
                    
                    //缓存web模块 (这里存不了json数组 所以存string 后面自己转一下)
                    UserDefaults.standard.set(resp["webmodule"].description, forKey: AppConfiguration.webModule.rawValue)
                    
                    //缓存科室列表
                     UserDefaults.standard.set(resp["data"].description, forKey: AppConfiguration.officeList.rawValue)
                    
                    
                }
            }){error in
                MBProgressHUD.hide(for: self.view, animated: true)
                UserInfo.instance().logout()
                MBProgressHUD.showError("登录失败", to: self.view)
            }
            
            //登录成功跳转到主页面
            let mainTabbar = MainTabbarController()
            self.present(mainTabbar, animated: true, completion: nil)
            MBProgressHUD.showSuccess("登录成功")
            let defaultCenter = NotificationCenter.default
            defaultCenter.post(name: NSNotification.Name(rawValue: kLoginSuccessNotification), object: nil, userInfo: nil)
            self.checkNewVersion()
        }) { (error) in
            MBProgressHUD.hide(for: self.view, animated: true)
            UserInfo.instance().logout()
            MBProgressHUD.showError("登录失败", to: self.view)
            
        }
        
    }
    
    func saveLoginIngo(loginInfo:[String:String]) {
        var dic = loginInfo
        dic["basename"] = basename
        dic["baseportalurl"] = baseportalurl
        dic["ipUrl"] = ipPort
        UserDefaults.standard.set(dic, forKey: "loginInfo")
    }
    @IBAction func selectBaseAction(_ sender: Any) {
        selectBaseBtn.isEnabled = false
        self.view.endEditing(true)
        if !iSReachable() {
            MBProgressHUD.showError("请检查网络", to: self.view)
            selectBaseBtn.isEnabled = true
            return
        }
        let params = ["token":"1567544911593472200","fromteacher":"1"]
        NetworkTool.sharedInstance.requestBase(params: params, success: { (response) in
            //            let customView = SelectBaseView.init(frame: (self.view.frame))
            //            customView.delegate = self
            //            customView.dataSource = response["data"] as! [NSDictionary]
            //            customView.reloadConstrains()
            //            self.view.addSubview(customView)
            //            self.basePickerView.isHidden = false
            self.basePickerView.isHidden = false
            self.dataSource = response["data"] as! [NSDictionary]
            self.basePickerView.reloadAllComponents()
            self.selectBaseBtn.isEnabled = true
        })
        { (error) in
            self.selectBaseBtn.isEnabled = true
        }
    }
    
    func didSelectBase(text:String){
        selectBaseBtn.setTitle(text, for: .normal)
    }
    
    @IBAction func forgetPasswordAction(_ sender: UIButton) {
        MBProgressHUD.showError("请联系科教处", to: self.view)
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
        
        self.basePickerView.isHidden = true
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return dataSource.count+1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if row == 0 {
            return "选择基地"
        }
        return dataSource[row-1].stringValue(forKey: "name")
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if row > 0 {
            basename = dataSource[row-1].stringValue(forKey: "name")
            baseportalurl = dataSource[row-1].stringValue(forKey: "portalurl")
            ipPort = dataSource[row-1].stringValue(forKey: "url")
            self.selectBaseBtn.setTitle(basename, for: .normal)
//            UserDefaults.standard.set(portalurl, forKey: "portalurl")
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func checkNewVersion() {
        Task().checkUpdateForAppID { (thisVersion, version) in
            let alertView = UIAlertView(title: "最新版本(\(version))已发布", message: "", delegate: self, cancelButtonTitle: nil, otherButtonTitles: "立刻更新")
            alertView.show()
        }
    }
    
    func alertView(_ alertView: UIAlertView, clickedButtonAt buttonIndex: Int){
        let AppID = "1289216466"
        if let URL = URL(string: "https://itunes.apple.com/us/app/id\(AppID)?ls=1&mt=8") {
            UIApplication.shared.openURL(URL)
        }
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
