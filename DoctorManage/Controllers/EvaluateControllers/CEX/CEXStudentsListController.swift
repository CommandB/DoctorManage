//
//  CEXStudentsListController.swift
//  DoctorManage
//
//  Created by 黄玮晟 on 2018/9/18.
//  Copyright © 2018年 chenshengchang. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON

class CEXStudentsListController : UIViewController ,UICollectionViewDelegate,UICollectionViewDataSource{
    
    @IBOutlet weak var students_collection: UICollectionView!
    var collectionDs = [JSON]()
    
    
    @IBAction func btn_back_tui(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func btn_history_tui(_ sender: UIButton) {
        //dismiss(animated: true, completion: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        students_collection.dataSource = self
        students_collection.delegate = self
        students_collection.reloadData()
        
        self.students_collection.mj_header = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: #selector(refreshAction))
        self.students_collection.mj_header.beginRefreshing()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return collectionDs.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let json = collectionDs[indexPath.item]
        let cell = students_collection.dequeueReusableCell(withReuseIdentifier: "c1", for: indexPath)
        cell.tag = indexPath.item
        
        let sex = json["sex"].stringValue == "1" ? "男":"女"
        var lbl = cell.viewWithTag(10002) as! UILabel
        lbl.text = "\(json["personname"])(\(sex))"
        lbl = cell.viewWithTag(20001) as! UILabel
        lbl.text = "暂无数据 ~ 暂无数据"
        let btn =  cell.viewWithTag(10003) as! UIButton
        btn.addTarget(self, action: #selector(btn_score_tui), for: .touchUpInside)
        
        
        return cell
    }
    
    func btn_score_tui(sender :UIButton){
        let vc = getViewToStoryboard("cexCheckView") as! CEXCheckController
        let index = (sender.superview?.superview?.tag)!
        let json = collectionDs[index]
        vc.studentId = json["personid"].intValue
        vc.studentName = json["personname"].stringValue
        //print(sender.superview?.superview?.tag)
        present(vc, animated: true, completion: nil)
    }
    
    func loadData(){
        MBProgressHUD.showAdded(to: self.view, animated: true)
        let url = "http://"+Ip_port2+"doctor_train/rest/app/getMiniCexStudent.do"
        myPostRequest(url).responseJSON(completionHandler: {resp in
            MBProgressHUD.hide(for: self.view, animated: true)
            self.students_collection.mj_header.endRefreshing()
            switch resp.result{
            case .success(let responseJson):
                let json = JSON(responseJson)
                if json["code"].stringValue == "1"{
                    
                    self.collectionDs = json["data"].arrayValue
                    print(self.collectionDs)
                    self.students_collection.reloadData()
                }else{
                    
                }
            case .failure(let error):
                print(error)
            }
            
        })
    }
    
    func refreshAction() {
        collectionDs.removeAll()
        loadData()
    }
    
}
