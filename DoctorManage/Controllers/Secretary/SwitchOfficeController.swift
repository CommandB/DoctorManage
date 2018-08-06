//
//  SwitchOfficeController.swift
//  DoctorManage
//
//  Created by 黄玮晟 on 2018/7/31.
//  Copyright © 2018年 chenshengchang. All rights reserved.
//

import UIKit
import SwiftyJSON

class SwitchOfficeController : UIViewController , UICollectionViewDataSource,UICollectionViewDelegate{
    
    var parentView : SecretaryCenterController? = nil
    var collectionDs = [JSON]()
    var selectedOffice = JSON()
    
    @IBOutlet weak var office_collection: UICollectionView!
    
    override func viewWillAppear(_ animated: Bool) {
        parentView = parent as? SecretaryCenterController
        office_collection.dataSource = self
        office_collection.delegate = self
//        let tData = JSON.init(UserInfo.instance().getOfficeInfo()).arr
        collectionDs = JSON.init(UserInfo.instance().getOfficeInfo()).arrayValue
        office_collection.reloadData()
        
    }
    
    @IBAction func btn_cancel_tui(_ sender: UIButton) {
        //self.dismiss(animated: true, completion: nil)
        parentView?.office_view.isHidden = true
        parentView?.view.viewWithTag(100001)?.isHidden = true
        office_collection.reloadData()
    }
    
    @IBAction func btn_sure_tui(_ sender: UIButton) {
        parentView?.office_view.isHidden = true
        parentView?.view.viewWithTag(100001)?.isHidden = true
        parentView?.currentOffice = selectedOffice
        (parentView?.view.viewWithTag(10001) as? UILabel)?.text = selectedOffice["officename"].stringValue
        parentView?.refreshAction()
        office_collection.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return collectionDs.count
//        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = office_collection.dequeueReusableCell(withReuseIdentifier: "c1", for: indexPath)
        cell.backgroundColor = UIColor.white
        let data = collectionDs[indexPath.item]
        let lbl = cell.viewWithTag(10001) as! UILabel
        lbl.text = data["officename"].stringValue
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
        cell?.backgroundColor = UIColor.groupTableViewBackground
        selectedOffice = collectionDs[indexPath.item]
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
        cell?.backgroundColor = UIColor.clear
    }
    
    func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    
}
