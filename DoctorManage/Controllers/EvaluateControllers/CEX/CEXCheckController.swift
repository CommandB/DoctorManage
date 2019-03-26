//
//  CEXcheckController.swift
//  DoctorManage
//
//  Created by 黄玮晟 on 2018/9/19.
//  Copyright © 2018年 chenshengchang. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON

class CEXCheckController : UIViewController{
    
    var studentId = 0
    var studentName = ""
    var viewArray = [UIView]()
    var submitData = [String:Any]()
    var displayViewIndex = 0
    
    @IBOutlet weak var btn_prev: UIButton!
    
    @IBOutlet weak var btn_next: UIButton!
    
    @IBOutlet weak var view1: UIView!
    
    @IBOutlet weak var view2: UIView!
    
    @IBOutlet weak var view3: UIView!
    
    @IBOutlet weak var view4: UIView!
    
    @IBOutlet weak var view5: UIView!
    
    @IBOutlet weak var view6: UIView!
    
    @IBOutlet weak var view7: UIView!
    
    @IBOutlet weak var view8: UIView!
    
    @IBOutlet weak var view9: UIView!
    
    override func viewWillAppear(_ animated: Bool) {
        
        let lbl_title = view.viewWithTag(11001) as! UILabel
        lbl_title.text = studentName + " " + lbl_title.text!
        
        viewArray=[view1,view2,view3,view4,view5,view6,view7,view8,view9]
//        view2.isHidden = true
//        view3.isHidden = true
//        view4.isHidden = true
        
        btn_prev.isUserInteractionEnabled = false   //初始化时禁用 上一项按钮
        
        submitData["inquiryscore"] = 9 // 问诊技巧得分
        submitData["checkscore"] = 9   // 体格检查得分
        submitData["czjnscore"] = 9   // 操作技能得分
        submitData["lcpdscore"] = 9   // 临床判断得分
        submitData["jkxjscore"] = 9   // 健康宣教得分
        submitData["zzxnscore"] = 9   // 组织效能得分
        submitData["rwghscore"] = 9   // 人文关怀得分
        
        submitData["teacherassess"] = 9    // 老师评价满意度
        submitData["studentassess"] = 9    // 学生评价满意度
        submitData["sickassess"] = 9   // 病人评价满意度
        
    }
    
    @IBAction func btn_back_tui(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    //上一项
    @IBAction func btn_prev_tui(_ sender: UIButton) {
        //隐藏当前view
        viewArray[displayViewIndex].isHidden = true
        displayViewIndex -= 1
        //隐藏总分
        var lbl = (view.viewWithTag(50001) as! UILabel)
        lbl.isHidden = false
        lbl = (view.viewWithTag(50002) as! UILabel)
        lbl.isHidden = false
        //显示上一个view
        viewArray[displayViewIndex].isHidden = false
        if displayViewIndex == 0 {
            sender.isUserInteractionEnabled = false
        }
        btn_next.isUserInteractionEnabled = true
        btn_next.setTitle("下一项", for: .normal)
    }
    
    //下一项
    @IBAction func btn_next_tui(_ sender: UIButton) {
        if displayViewIndex == viewArray.count - 1{
            submit()
        }else{
            //隐藏当前view
            viewArray[displayViewIndex].isHidden = true
            displayViewIndex += 1
            //显示上一个view
            viewArray[displayViewIndex].isHidden = false
            if displayViewIndex == 0 {
                sender.isUserInteractionEnabled = false
            }else if displayViewIndex == viewArray.count - 1{
                //计算总分
                var sum = 0
                sum += (submitData["inquiryscore"] as! Int)
                sum += (submitData["checkscore"] as! Int)
                sum += (submitData["czjnscore"] as! Int)
                sum += (submitData["lcpdscore"] as! Int)
                sum += (submitData["jkxjscore"] as! Int)
                sum += (submitData["zzxnscore"] as! Int)
                sum += (submitData["rwghscore"] as! Int)
                sum += (submitData["teacherassess"] as! Int)
                sum += (submitData["studentassess"] as! Int)
                sum += (submitData["sickassess"] as! Int)
                var lbl = (view.viewWithTag(50001) as! UILabel)
                lbl.isHidden = false
                lbl = (view.viewWithTag(50002) as! UILabel)
                lbl.text = sum.description
                lbl.isHidden = false
                
                sender.setTitle("提交", for: .normal)
            }
            btn_prev.isUserInteractionEnabled = true
        }
    }
    
    
    @IBAction func slider_valueChange(_ sender: UISlider) {
        
        let val = lroundf(sender.value)
        switch sender.tag {
        case 11111:
            setScore(view: view1, key: "inquiryscore", score: val)
            break
        case 22222:
            setScore(view: view2, key: "checkscore", score: val)
            break
        case 33333:
            setScore(view: view3, key: "czjnscore", score: val)
            break
        case 44444:
            setScore(view: view4, key: "lcpdscore", score: val)
            break
        case 55555:
            setScore(view: view5, key: "jkxjscore", score: val)
            break
        case 66666:
            setScore(view: view6, key: "zzxnscore", score: val)
            break
        case 77777:
            setScore(view: view7, key: "rwghscore", score: val)
            break
        case 88888:
            let lbl = view8.viewWithTag(10001) as! UILabel
            lbl.text = "得 \(val)/9分"
            submitData["teacherassess"] = val
            break
        case 99999:
            let lbl = view8.viewWithTag(20001) as! UILabel
            lbl.text = "得 \(val)/9分"
            submitData["studentassess"] = val
            break
        case 100000:
            let lbl = view8.viewWithTag(30001) as! UILabel
            lbl.text = "得 \(val)/9分"
            submitData["sickassess"] = val
            break
        default:
            break
        }
        
    }
    
    @IBAction func slider_exit(_ sender: UISlider) {
        let val = lroundf(sender.value)
        sender.value = Float(val)
    }
    
    func submit() {
        
        submitData["studentid"] = studentId
        // 病人名称
        submitData["sickname"] = (view.viewWithTag(10001) as! UITextField).text!
        // 病人年龄
        submitData["sickage"] = (view.viewWithTag(10002) as! UITextField).text!
        // 病历号
        submitData["sickno"] = (view.viewWithTag(20001) as! UITextField).text!
        // 新/旧病人
        let seg = view.viewWithTag(20002) as! UISegmentedControl
        submitData["sicktype"] = seg.titleForSegment(at: seg.selectedSegmentIndex)
        // 主要症状
        submitData["diagnosis"] = (view.viewWithTag(30001) as! UITextField).text!
        // 处置操作
        submitData["operation"] = (view.viewWithTag(40001) as! UITextField).text!
        
        if (submitData["sickname"] as! String) == ""{
            myAlert(self, message: "请输入病人姓名!")
            return
        }
        if (submitData["sickage"] as! String) == ""{
            myAlert(self, message: "请输入病人年龄!")
            return
        }
        if (submitData["sickno"] as! String) == ""{
            myAlert(self, message: "请输入病历号!")
            return
        }
        if (submitData["diagnosis"] as! String) == ""{
            myAlert(self, message: "请输入主要症状!")
            return
        }
        if (submitData["operation"] as! String) == ""{
            myAlert(self, message: "请输入处置操作!")
            return
        }
        
        
        // 值得肯定的地方
        submitData["fine"] = (view9.viewWithTag(10001) as! UITextView).text!
        // 有待加强的地方
        submitData["bad"] = (view9.viewWithTag(20001) as! UITextView).text!
        // 今后发展的建议
        submitData["suggest"] = (view9.viewWithTag(30001) as! UITextView).text!
        // 评分地址
        submitData["address"] = "门诊"
        
        print(submitData)
        
        MBProgressHUD.showAdded(to: self.view, animated: true)
        let url = "http://"+Ip_port2+"doctor_train/rest/app/subMiniCEX.do"
        myPostRequest(url,submitData).responseJSON(completionHandler: {resp in
            MBProgressHUD.hide(for: self.view, animated: true)
            
            switch resp.result{
            case .success(let responseJson):
                let json = JSON(responseJson)
                print(json)
                if json["code"].stringValue == "1"{
                    let alert = UIAlertController.init(title: nil, message: "提交成功", preferredStyle: .alert)
                    self.present(alert, animated: true, completion: nil)
                    DispatchQueue.global().async {
                        Thread.sleep(forTimeInterval: 2.0)
                        DispatchQueue.main.async {
                            alert.dismiss(animated: true, completion: {
                                self.dismiss(animated: false, completion: nil)
                            })
                        }
                    }
                }else{
                    myAlert(self, message: json["msg"].stringValue)
                }
            case .failure(let error):
                myAlert(self, message: "提交失败!")
                print(error)
            }
            
        })
        
    }
    
    func setScore(view :UIView, key :String , score:Int){
        var tuple = parseScoreLevel(score: score)
        var lbl = view.viewWithTag(10001) as! UILabel
        lbl.text = "\(score)/9分"
        lbl = view.viewWithTag(20001) as! UILabel
        lbl.text = tuple.0
        lbl.textColor = tuple.1
        submitData[key] = score
    }
    
    func parseScoreLevel(score : Int) -> (String,UIColor){
        
        if score <= 4{
            return ("有待加强",UIColor.red)
        }else if score <= 6{
            return ("合乎标准",UIColor.orange)
        }else{
            return ("优秀",UIColor.green)
        }
    }
    
}
