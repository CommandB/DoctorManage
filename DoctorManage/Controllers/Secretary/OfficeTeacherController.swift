//
//  OfficeTeacherController.swift
//  DoctorManage
//
//  Created by 黄玮晟 on 2018/7/31.
//  Copyright © 2018年 chenshengchang. All rights reserved.
//

import UIKit
import SwiftyJSON

class OfficeTeacherController : UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    let cellUpperDistance = 35
    let studentLabelheight = 20
    
    @IBOutlet weak var teacher_collection: UICollectionView!
    var office = JSON()
    var collectionDs = [JSON]()
    var selectedPerson = [String:JSON]()
    //被选中的学生
    var selectedStudents = [String:JSON]()
    
    //返回
    @IBAction func btn_back_tui(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    //入科登记
    @IBAction func btn_joinOffice_tui(_ sender: UIButton) {
        if selectedPerson.count == 0 {
            myAlert(self, message: "请选择带教老师!")
            return
        }
        if selectedStudents.count == 0{
            myAlert(self, message: "请选择带教老师!")
            return
        }
        
        let teacher = selectedPerson.values.first
        
        var stus = [Dictionary<String, String>]()
        for s in selectedStudents{
            var json = Dictionary<String, String>()
            json["studentid"] = s.value["personid"].stringValue
            json["roundokpeopleresultid"] = s.value["roundokpeopleresultid"].stringValue
            stus.append(json)
        }
        
        MBProgressHUD.showAdded(to: self.view, animated: true)
        let url = "http://"+Ip_port2+"doctor_train/rest/app/studentJoinOffice.do"
        myPostRequest(url,["teacherid":teacher!["personid"].stringValue, "studentlist":stus]).responseJSON(completionHandler: {resp in
            MBProgressHUD.hide(for: self.view, animated: true)
            switch resp.result{
            case .success(let responseJson):
                let json = JSON(responseJson)
                if json["code"].stringValue == "1"{
                    
                    myAlert(self, message: "入科成功")
                    //初始化数据,防止重复提交
                    self.selectedStudents = [String:JSON]()
                    self.selectedPerson = [String:JSON]()
                    //重新加载列表
                    self.loadTeacherInfo()
                }else{
                    myAlert(self, message: "入科失败")
                }
            case .failure(let error):
                
                print(error)
            }
            
        })
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        teacher_collection.dataSource = self
        teacher_collection.delegate = self
        teacher_collection.reloadData()
        
        loadTeacherInfo()
    }
    
    func loadTeacherInfo(){
        MBProgressHUD.showAdded(to: self.view, animated: true)
        let url = "http://"+Ip_port2+"doctor_train/rest/app/getOfficeTeachers.do"
        myPostRequest(url,["officeid":office["officeid"].stringValue]).responseJSON(completionHandler: {resp in
            MBProgressHUD.hide(for: self.view, animated: true)
            switch resp.result{
            case .success(let responseJson):
                let json = JSON(responseJson)
                if json["code"].stringValue == "1"{
                    
                    self.collectionDs = json["data"].arrayValue
                    //print(self.collectionDs)
                    self.teacher_collection.reloadData()
                }else{
                    
                }
            case .failure(let error):
                
                print(error)
            }
            
        })
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return collectionDs.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "c1", for: indexPath)
        
        //防止重影
        for v in cell.subviews[0].subviews{
            if v.tag <= 10000{
                v.removeFromSuperview()
            }
        }
        
        let data = collectionDs[indexPath.item]
        let btn = cell.viewWithTag(10001) as! UIButton
        btn.clipsToBounds = true
        btn.cornerRadius = btn.frame.width / 2
        if selectedPerson[data["personid"].stringValue] != nil {
            btn.backgroundColor = UIColor.init(hex: "5EA3F3")
        }else{
            btn.backgroundColor = UIColor.groupTableViewBackground
        }
        let lbl = cell.viewWithTag(10002) as! UILabel
        lbl.text = "\(data["personname"])(\(data["jobnum"]))"
        
        let studentList = data["studentlist"].arrayValue
        var index = 0
        for stu in studentList{
            
            if index == 0{
                let lf = lbl.frame
                let line = UILabel(frame: CGRect.init(x: lf.origin.x, y: lf.origin.y.adding(lf.height).adding(5), width: lf.width, height: 1))
                line.backgroundColor = UIColor.lightGray
                cell.subviews[0].addSubview(line)
            }
            
            let y = studentLabelheight * index + cellUpperDistance
            let stuLbl = UILabel(frame: lbl.frame)
            stuLbl.font = UIFont.boldSystemFont(ofSize: 13)
            stuLbl.textColor = UIColor.lightGray
            stuLbl.text = "\(stu["personname"])   \(stu["starttime"]) ~ \(stu["endtime"])"
            stuLbl.frame.origin = CGPoint(x: Int.init(stuLbl.frame.origin.x), y: y)
            cell.subviews[0].addSubview(stuLbl)
            
            index += 1
        }
        
        return cell
    }
    
    
    //计算cell大小
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let data = collectionDs[indexPath.item]
        let studentList = data["studentlist"].arrayValue
        if studentList.count == 0 {
            return CGSize(width: collectionView.frame.width, height: 35)
        }else{
            let height = studentLabelheight * studentList.count + cellUpperDistance
            return CGSize(width: collectionView.frame.width, height: CGFloat.init(height))
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectItem(collectionView, indexPath: indexPath)
    }
    
    func selectItem(_ collectionView: UICollectionView, indexPath: IndexPath) {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "c1", for: indexPath)
        let data = collectionDs[indexPath.item]
        let btn = cell.viewWithTag(10001) as! UIButton
        let personid = data["personid"].stringValue
        //判断是否已被选中
        if selectedPerson[personid] == nil{
            selectedPerson = [personid:data]
            btn.backgroundColor = UIColor(hex: "5EA3F3")
        }else{
            selectedPerson.removeValue(forKey: personid)
            btn.backgroundColor = UIColor.groupTableViewBackground
        }
        collectionView.reloadData()
    }
    
}
