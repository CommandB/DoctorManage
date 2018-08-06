//
//  SecretaryCenter.swift
//  DoctorManage
//
//  Created by 黄玮晟 on 2018/7/31.
//  Copyright © 2018年 chenshengchang. All rights reserved.
//

import UIKit
import SwiftyJSON
class SecretaryCenterController : UIViewController{
    
    @IBOutlet weak var office_view: UIView!
    var currentOffice = JSON()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        office_view.backgroundColor = UIColor.white
        office_view.isHidden = true

        view.viewWithTag(100001)?.isHidden = true
        let currentOfficeLbl = view.viewWithTag(10001) as! UILabel
        //如果当前没有科室被选中 则使用默认科室
        if currentOffice.isEmpty {
            if g_userOffice.count > 0{
                currentOffice = g_userOffice[0]
            }
        }
        if currentOffice.isEmpty{
            currentOfficeLbl.text = "科室信息异常"
        }else{
            currentOfficeLbl.text = currentOffice["officename"].stringValue
        }
        
        for i in 1...4 {
            let btn = view.viewWithTag(20000+i) as! UIButton
            btn.addTarget(self, action: #selector(btn_nav_tui), for: .touchUpInside)
            switch i {
            case 1:
                btn.set(image: UIImage(named: "join_office"), title: "入科", titlePosition: .bottom, additionalSpacing: 10.0, state: .normal)
                break
            case 2:
                btn.set(image: UIImage(named: "out_office"), title: "出科", titlePosition: .bottom, additionalSpacing: 10.0, state: .normal)
                break
            case 3:
                btn.set(image: UIImage(named: "office_person"), title: "科室人员", titlePosition: .bottom, additionalSpacing: 10.0, state: .normal)
                break
            case 4:
                btn.set(image: UIImage(named: "office_plan"), title: "教学计划", titlePosition: .bottom, additionalSpacing: 10.0, state: .normal)
                break
            default: break
                
            }

        }

        
        NetworkTool.getUserOffice(params :["token":UserInfo.instance().token], success : { resp in
            if resp["code"].string == "1"{
                g_userOffice = resp["data"].arrayValue

                UserInfo.instance().saveOfficeInfo(try! resp["data"].rawData());
            }
        }){error in
            MBProgressHUD.hide(for: self.view, animated: true)
            UserInfo.instance().logout()
            MBProgressHUD.showError("登录失败", to: self.view)
        }
    }
    
    
    @IBAction func btn_swichOffice_tui(_ sender: UIButton) {
        office_view.isHidden = false
        //背景
        view.viewWithTag(100001)?.isHidden = false
        
    }
    
    func btn_nav_tui(sender : UIButton){
        switch sender.tag {
        case 20001:
            let vc = getViewToStoryboard("joinOfficeView") as! JoinOfficeController
            vc.office = currentOffice
            self.present(vc, animated: true, completion: nil)
            break
        case 20003:
            let vc = OfficePeopleViewController()
            vc.office = currentOffice
            let nav = UINavigationController(rootViewController: vc)
            self.present(nav, animated: true, completion: nil)
            break
        case 20004:
            let vc = SmallLectureViewController()
            vc.office = currentOffice
            let nav = UINavigationController(rootViewController: SmallLectureViewController())
            self.present(nav, animated: true, completion: nil)
            break
            
            
        default: break
            
        }
    }
    
}
