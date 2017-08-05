//
//  ResetPasswordController.swift
//  DoctorManage
//
//  Created by 陈海峰 on 2017/6/21.
//  Copyright © 2017年 chenshengchang. All rights reserved.
//

import UIKit

class ResetPasswordController: UIViewController {
    @IBOutlet weak var inputTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.setBackgroundImage(UIImage.init(named: "topBackgroundIcon"), for: .default)
        self.extendedLayoutIncludesOpaqueBars = true
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.white]
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.title = "设置"
        
        let image = UIImage(named: "返回")!.withRenderingMode(.alwaysOriginal)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image:image, style: .done, target: self, action: #selector(backAction))
    }
    
    func backAction() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func resetAction(_ sender: Any) {
        if inputTextField.text?.characters.count == 0 || inputTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines).lengthOfBytes(using: .utf8) == 0{
            BRAlertView.show(message: "请输入新密码", target: self)
            return
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
