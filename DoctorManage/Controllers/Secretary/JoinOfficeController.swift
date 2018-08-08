//
//  JoinOfficeController.swift
//  DoctorManage
//
//  Created by 黄玮晟 on 2018/7/31.
//  Copyright © 2018年 chenshengchang. All rights reserved.
//

import UIKit
import SwiftyJSON

class JoinOfficeController : UIViewController , UICollectionViewDelegate , UICollectionViewDataSource{
    
    
    @IBOutlet weak var students_collection: UICollectionView!
    var office = JSON()
    var collectionDs = [JSON]()
    var selectedPerson = [String:JSON]()
    
    @IBAction func btn_back_tui(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func btn_chooseTeacher_tui(_ sender: UIButton) {
        let vc = getViewToStoryboard("officeTeacherView") as! OfficeTeacherController
        vc.office = office
        vc.selectedStudents = selectedPerson
        if selectedPerson.count == 0 {
            myAlert(self, message: "请选择入科学生!")
            return
        }
        self.present(vc, animated: true, completion: nil)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        students_collection.dataSource = self
        students_collection.delegate = self
        students_collection.reloadData()
        
        selectedPerson = [String:JSON]()
        
        MBProgressHUD.showAdded(to: self.view, animated: true)
        let url = "http://"+Ip_port2+"doctor_train/rest/app/queryJoinOfficePerson.do"
        myPostRequest(url,["officeid":office["officeid"].stringValue]).responseJSON(completionHandler: {resp in
            MBProgressHUD.hide(for: self.view, animated: true)
            switch resp.result{
            case .success(let responseJson):
                let json = JSON(responseJson)
                if json["code"].stringValue == "1"{
                    
                    self.collectionDs = json["data"].arrayValue
                    //print(self.collectionDs)
                    self.students_collection.reloadData()
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
        let cell = students_collection.dequeueReusableCell(withReuseIdentifier: "c1", for: indexPath)
        let data = collectionDs[indexPath.item]
        let btn = cell.viewWithTag(10001) as! UIButton
        btn.clipsToBounds = true
        btn.cornerRadius = btn.frame.width / 2
        if selectedPerson[data["personid"].stringValue] != nil {
            btn.backgroundColor = UIColor.init(hex: "5EA3F3")
        }else{
            btn.backgroundColor = UIColor.groupTableViewBackground
        }
        
        var lbl = cell.viewWithTag(10002) as! UILabel
        lbl.text = "\(data["personname"].stringValue)(\(data["jobnum"].stringValue))"
        lbl = cell.viewWithTag(20002) as! UILabel
        lbl.text = "轮转周期 \(data["starttime"].stringValue.prefix(10)) ~ \(data["endtime"].stringValue.prefix(10))"
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectItem(collectionView, indexPath: indexPath)
    }
    
    func selectItem(_ collectionView: UICollectionView, indexPath: IndexPath) {
        let cell = students_collection.dequeueReusableCell(withReuseIdentifier: "c1", for: indexPath)
        let data = collectionDs[indexPath.item]
        let btn = cell.viewWithTag(10001) as! UIButton
        let personid = data["personid"].stringValue
        //判断是否已被选中
        if selectedPerson[personid] == nil{
            selectedPerson[personid] = data
            btn.backgroundColor = UIColor(hex: "5EA3F3")
        }else{
            selectedPerson.removeValue(forKey: personid)
            btn.backgroundColor = UIColor.groupTableViewBackground
        }
        collectionView.reloadItems(at: [indexPath])
    }
    
}
