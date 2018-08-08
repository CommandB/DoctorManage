//
//  ResetPasswordController.swift
//  DoctorManage
//
//  Created by 陈海峰 on 2017/6/21.
//  Copyright © 2017年 chenshengchang. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire
class ResetPasswordController: JHBaseViewController {
    @IBOutlet weak var inputTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.extendedLayoutIncludesOpaqueBars = true
        self.title = "设置"
    }
    
    @IBAction func resetAction(_ sender: Any) {
        if inputTextField.text?.count == 0 || inputTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines).lengthOfBytes(using: .utf8) == 0{
            BRAlertView.show(message: "请输入新密码", target: self)
            return
        }
        inputTextField.resignFirstResponder()
        MBProgressHUD.showAdded(to: self.view, animated: true)
        let urlString = "http://"+Ip_port2+"doctor_portal/rest/login/modify_mine.do"
        NetworkTool.sharedInstance.myPostRequest(urlString,["token":UserInfo.instance().token!,"password":inputTextField.text?.sha1() ?? ""], method: HTTPMethod.post).responseJSON { (response) in
            MBProgressHUD.hide(for: self.view, animated: true)
            switch(response.result){
            case .failure(let error):
                print(error)
            case .success(let response):
                let json = JSON(response)
                if json["code"].stringValue == "1"{
                    let alert = UIAlertController.init(title: nil, message: "重置成功", preferredStyle: .alert)
                    self.present(alert, animated: true, completion: nil)
                    DispatchQueue.global().async {
                        Thread.sleep(forTimeInterval: 2.0)
                        DispatchQueue.main.async {
                            alert.dismiss(animated: true, completion: {
                                UserInfo.instance().logout()
                                UserDefaults.standard.removeObject(forKey: "portalurl")
                                UserDefaults.standard.removeObject(forKey: "loginInfo")
                                let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
                                let loginViewController = storyboard.instantiateViewController(withIdentifier: "loginView") as! LoginViewController
                                self.present(loginViewController, animated: true, completion: nil)
                            })
                        }
                    }

                }else{
                    print("error")
                }
            }
        }
    }
    
    @IBAction func logOutAction(_ sender: Any) {
        UserInfo.instance().logout()
        UserDefaults.standard.removeObject(forKey: "portalurl")
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        let loginViewController = storyboard.instantiateViewController(withIdentifier: "loginView") as! LoginViewController
        self.present(loginViewController, animated: true, completion: nil)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
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
