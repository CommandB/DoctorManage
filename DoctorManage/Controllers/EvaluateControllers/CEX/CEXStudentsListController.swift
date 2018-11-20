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

class CEXStudentsListController : UIViewController ,UICollectionViewDelegate,UICollectionViewDataSource,UIScrollViewDelegate{
    
    var students_collection:UICollectionView?
    
    var collectionDs = [JSON]()
    
    var parentView:BaseEvaluateController?

    @IBAction func btn_back_tui(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func btn_history_tui(_ sender: UIButton) {
        //dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        let layout = UICollectionViewFlowLayout.init()
        layout.itemSize = CGSize(width: kScreenW, height: 80)
        students_collection = UICollectionView(frame: CGRect.init(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height-64-49-45), collectionViewLayout: layout)
        students_collection?.delegate = self
        students_collection?.dataSource = self
        students_collection?.backgroundColor = .white
        let nib = UINib.init(nibName: "CEXStudentCollectionCell", bundle: nil)
        students_collection?.register(nib, forCellWithReuseIdentifier: "CEXStudentCollectionCell")
        self.view.addSubview(students_collection!)
        
        let header = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: #selector(refreshAction))
        header?.setTitle("", for: .idle)
        self.students_collection?.mj_header = header
        self.students_collection?.mj_header.beginRefreshing()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        students_collection?.dataSource = self
        students_collection?.delegate = self
        students_collection?.reloadData()
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return collectionDs.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CEXStudentCollectionCell", for: indexPath) as! CEXStudentCollectionCell
        
        let json = collectionDs[indexPath.item]
        cell.tag = indexPath.item
        
        let sex = json["sex"].stringValue == "1" ? "男":"女"
        cell.nameLabel.text = "\(json["personname"])(\(sex))"
        cell.dateLabel.text = "暂无数据 ~ 暂无数据"
        cell.scoreButton.addTarget(self, action: #selector(btn_score_tui), for: .touchUpInside)        
        
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
        let url = "http://"+Ip_port2+"doctor_train/rest/app/getMiniCexStudent.do"
        myPostRequest(url).responseJSON(completionHandler: {resp in
            self.students_collection?.mj_header.endRefreshing()
            switch resp.result{
            case .success(let responseJson):
                let json = JSON(responseJson)
                if json["code"].stringValue == "1"{
                    
                    self.collectionDs = json["data"].arrayValue
                    print(self.collectionDs)
                    self.students_collection?.reloadData()
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
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        parentView?.moreMenu.isHidden = true
    }
}
