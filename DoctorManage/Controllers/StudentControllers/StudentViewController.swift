//
//  StudentViewController.swift
//  DoctorManage
//
//  Created by 陈海峰 on 2017/6/2.
//  Copyright © 2017年 chenshengchang. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire
class StudentViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UIScrollViewDelegate  {
    @IBOutlet weak var collectionView: UICollectionView!
    var dataSource:[JSON] = [JSON]()
    var lastPath = IndexPath.init(item: 0, section: 0)

    // 子标题
    func createSubTitleArr(_ num:Int) -> [String] {
        if num == 2 {
            return ["心愿单", "任务申报"]
        }
        return ["学员任务", "大纲进度","个人信息"]
    }
    
    // 子控制器
    func createControllers(_ num:Int,dataSource:JSON) -> [UIViewController] {
        var cons:[UIViewController] = [UIViewController]()
//        for i in 0..<num {
//            if i == 0 {
//                let subController = WishlistViewController()
//                if num == 2{
//                    subController.studentType = .AllType
//                }else{
//                    subController.studentType = .SingleType
//                }
//                subController.infoDic = dataSource
//                cons.append(subController)
//            }else if i == 1{
//                if num == 2{
//                    let subController = ReportViewController()
//                    cons.append(subController)
//                }else{
//                    let subController = StudentTaskViewController()
//                    subController.infoDic = dataSource
//                    subController.studentType = .AllType
//                    cons.append(subController)
//                }
//            }else if i == 2{
//                let subController = TaketurnsController()
//                subController.infoDic = dataSource
//                if num == 2{
//                    subController.studentType = .AllType
//                }else{
//                    subController.studentType = .SingleType
//                }
//                cons.append(subController)
//            }else{
//                let subController = PersonalInfoController()
//                subController.infoDic = dataSource
//                if num == 2{
//                    subController.studentType = .AllType
//                }else{
//                    subController.studentType = .SingleType
//                }
//                cons.append(subController)
//            }
//        }
        
        
        for i in 0..<num {
            if i == 0 {
                if num == 2{
                    let subController = WishlistViewController()
                    subController.infoDic = dataSource
                    cons.append(subController)
                }else{
                    let subController = StudentTaskViewController()
                    subController.infoDic = dataSource
                    cons.append(subController)
                }
            }else if i == 1{
                if num == 2{
                    let subController = ReportViewController()
                    cons.append(subController)
                }else{
                    let subController = TaketurnsController()
                    subController.infoDic = dataSource
                    cons.append(subController)
                }
            }else{
                let subController = PersonalInfoController()
                subController.infoDic = dataSource
                cons.append(subController)
            }
        }
        
        return cons
    }
    
    /// 菜单分类控制器
    func createlxfMenuVc(_ num:Int,dataSource:JSON) -> LXFMenuPageController {
        let pageVc = LXFMenuPageController(controllers: self.createControllers(num, dataSource: dataSource), titles: self.createSubTitleArr(num), inParentController: self)
        pageVc.delegate = self
        
        self.view.addSubview(pageVc.view)
        return pageVc
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.setBackgroundImage(UIImage.init(named: "topBackgroundIcon"), for: .default)
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.white]
        self.title = "我的学员"
        let nib = UINib(nibName: "PhotoCollectionCell", bundle: nil)
        self.collectionView.register(nib, forCellWithReuseIdentifier: "PhotoCollectionCell")
        collectionView.delegate = self
        collectionView.dataSource = self
        if let view = self.view.viewWithTag(1000) {
            view.removeFromSuperview()
        }
        let lxfMenuVc = self.createlxfMenuVc(2, dataSource: JSON(""))
        lxfMenuVc.view.frame = CGRect(x: 0, y: collectionView.frame.size.height, width: self.view.frame.size.width, height: self.view.bounds.size.height-collectionView.frame.size.height)
        self.view.addSubview(lxfMenuVc.view)
        lxfMenuVc.view.tag = 1000
        requestData()
        collectionView.selectItem(at: IndexPath.init(row: 0, section: 0), animated: false, scrollPosition: .left)
        collectionView.delegate?.collectionView!(collectionView, didSelectItemAt: IndexPath.init(row: 0, section: 0))
//        setRightButton()
    }
    
    func setRightButton() {
        let rightButton = UIButton(frame: CGRect(x: 0, y: 0, width: 60, height: 40))
        rightButton.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        rightButton.titleLabel?.textAlignment = .right
        rightButton.setTitle("发布讲座", for: .normal)
        rightButton.titleLabel?.sizeToFit()
        rightButton.addTarget(self, action: #selector(publishLectureAction), for: .touchUpInside)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: rightButton)
    }
    
    func publishLectureAction() {
        self.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(PublishLectureController(), animated: true)
        self.hidesBottomBarWhenPushed = false
    }
    
    func requestData() {
        let urlString = "http://"+Ip_port2+kQueryMyStudentsURL
        NetworkTool.sharedInstance.myPostRequest(urlString,["token":UserInfo.instance().token!], method: HTTPMethod.post).responseJSON { (response) in
            switch(response.result){
            case .failure(let error):
                print(error)
            case .success(let response):
                let json = JSON(response)
                if json["code"].stringValue == "1"{
                    self.dataSource = json["data"].arrayValue
                    BRPersonInfoData.shared.totalPersonInfo = json["data"].arrayValue
                    self.collectionView.reloadData()
                }else{
                    print("error")
                }
            }
        }
    }
    
    //collectionViewDelegate
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource.count+1
    }
    
    /**
     - returns: 绘制collectionView的cell
     */
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCollectionCell", for: indexPath as IndexPath) as! PhotoCollectionCell
        if indexPath.item == 0 {
            cell.nameLabel.text =  "全部"
            cell.photoImage.image = UIImage.init(named: "全部")
        }else{
            cell.nameLabel.text = dataSource[indexPath.row-1]["personname"].stringValue
            if let photourl = URL.init(string: dataSource[indexPath.row-1]["photourl"].stringValue)  {
                cell.photoImage.sd_setImage(with: photourl, placeholderImage: UIImage.init(named: "个人中心"))
            }else{
                cell.photoImage.image = UIImage.init(named: "个人中心")
            }
        }
        if collectionView.contentSize.width > self.view.bounds.size.width {
            if cell.frame.origin.x < self.view.frame.size.width && cell.frame.origin.x+cell.bounds.size.width>self.view.frame.size.width {
                cell.moreView.isHidden = false
            }else{
                cell.moreView.isHidden = true
            }
        }
        if lastPath.row == indexPath.row {
            cell.backgroundview.backgroundColor = UIColor.init(red: 245/255.0, green: 248/255.0, blue: 252/255.0, alpha: 1.0)
            cell.triangleView.isHidden = false
        }else{
            cell.backgroundview.backgroundColor = UIColor.clear
            cell.triangleView.isHidden = true
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            if let view = self.view.viewWithTag(1000) {
                view.removeFromSuperview()
            }
            let lxfMenuVc = self.createlxfMenuVc(2, dataSource: JSON(""))
            //            lxfMenuVc.tipBtnFontSize = 12
            lxfMenuVc.view.frame = CGRect(x: 0, y: collectionView.frame.size.height, width: self.view.frame.size.width, height: self.view.bounds.size.height-collectionView.frame.size.height)
            self.view.addSubview(lxfMenuVc.view)
            lxfMenuVc.view.tag = 1000
            
        }else{
            if let view = self.view.viewWithTag(1000) {
                view.removeFromSuperview()
            }
            let lxfMenuVc = self.createlxfMenuVc(3, dataSource: dataSource[indexPath.item-1])
            //            lxfMenuVc.tipBtnFontSize = 12
            lxfMenuVc.view.frame = CGRect(x: 0, y: collectionView.frame.size.height, width: self.view.frame.size.width, height: self.view.bounds.size.height-collectionView.frame.size.height)
            self.view.addSubview(lxfMenuVc.view)
            lxfMenuVc.view.tag = 1000
            
        }
        
        let newRow = indexPath.row
        let oldRow = lastPath.row 
        if newRow != oldRow {
            let newCell = collectionView.cellForItem(at: indexPath) as! PhotoCollectionCell
            newCell.backgroundview.backgroundColor = UIColor.init(red: 245/255.0, green: 248/255.0, blue: 252/255.0, alpha: 1.0)
            newCell.triangleView.isHidden = false
            if let oldCell = collectionView.cellForItem(at: lastPath) {
                (oldCell as! PhotoCollectionCell).backgroundview.backgroundColor = UIColor.clear
                (oldCell as! PhotoCollectionCell).triangleView.isHidden = true
            }
        }
        lastPath = indexPath
        collectionView.reloadData()
    }

    func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
//        if scrollView.contentOffset.x > 0 {
//            for cell in collectionView.visibleCells {
//                (cell as! PhotoCollectionCell).moreView.isHidden = true
//            }
//            collectionView.reloadData()
//        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
//        for cell in collectionView.visibleCells {
//            (cell as! PhotoCollectionCell).moreView.isHidden = true
//        }
    }
    
    /// 隐藏状态栏
    override var prefersStatusBarHidden: Bool {
        return false
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

// MARK:- LXFMenuPageControllerDelegate
extension StudentViewController: LXFMenuPageControllerDelegate {
    func lxf_MenuPageCurrentSubController(index: NSInteger, menuPageController: LXFMenuPageController) {
        print("第\(index)个子控制器")
    }
}
