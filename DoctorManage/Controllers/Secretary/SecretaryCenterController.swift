//
//  SecretaryCenter.swift
//  DoctorManage
//
//  Created by 黄玮晟 on 2018/7/31.
//  Copyright © 2018年 chenshengchang. All rights reserved.
//

import UIKit
import SwiftyJSON
class SecretaryCenterController : UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    
    @IBOutlet weak var office_view: UIView!
    
    @IBOutlet weak var notice_collection: UICollectionView!
    
    var currentOffice = JSON()
    var collectionDs = [JSON]()
    let boundary = CGFloat(9)
    let lineHeight = 16
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        office_view.backgroundColor = UIColor.white
        office_view.isHidden = true
        
        notice_collection.delegate = self
        notice_collection.dataSource = self
        //注册section Header
        notice_collection.register(HeaderReusableView.classForCoder(), forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "header")
        
        let header = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: #selector(refreshAction))
        let footer = MJRefreshAutoNormalFooter(refreshingTarget: self, refreshingAction: #selector(loadMoreAction))
        header?.setTitle("", for: .idle)
        footer?.setTitle("", for: .idle)
        self.notice_collection.mj_header = header
        self.notice_collection.mj_footer = footer
        self.notice_collection.mj_header.beginRefreshing()
        
        view.viewWithTag(100001)?.isHidden = true
        let currentOfficeLbl = view.viewWithTag(10001) as! UILabel
        let userOfficeList = JSON.init(UserInfo.instance().getOfficeInfo())
        
        //如果当前没有科室被选中 则使用默认科室
        if currentOffice.isEmpty {
            if userOfficeList.count > 0{
                currentOffice = userOfficeList[0]
            }
        }
        if currentOffice.isEmpty{
            currentOfficeLbl.text = "科室信息异常"
        }else{
            currentOfficeLbl.text = currentOffice["officename"].stringValue
        }
        
        var btn = view.viewWithTag(20001) as! UIButton
        btn.set(image: UIImage(named: "join_office"), title: "入科", titlePosition: .bottom, additionalSpacing: 10.0, state: .normal)
        btn.addTarget(self, action: #selector(btn_nav_tui), for: .touchUpInside)
        btn = view.viewWithTag(20002) as! UIButton
        btn.set(image: UIImage(named: "out_office"), title: "出科", titlePosition: .bottom, additionalSpacing: 10.0, state: .normal)
        btn.addTarget(self, action: #selector(btn_nav_tui), for: .touchUpInside)
        btn = view.viewWithTag(20003) as! UIButton
        btn.set(image: UIImage(named: "notice_office"), title: "公告", titlePosition: .bottom, additionalSpacing: 10.0, state: .normal)
        btn.addTarget(self, action: #selector(btn_nav_tui), for: .touchUpInside)
        btn = view.viewWithTag(20004) as! UIButton
        btn.set(image: UIImage(named: "office_person"), title: "科室人员", titlePosition: .bottom, additionalSpacing: 10.0, state: .normal)
        btn.addTarget(self, action: #selector(btn_nav_tui), for: .touchUpInside)
        btn = view.viewWithTag(20005) as! UIButton
        btn.set(image: UIImage(named: "office_plan"), title: "教学计划", titlePosition: .bottom, additionalSpacing: 10.0, state: .normal)
        btn.addTarget(self, action: #selector(btn_nav_tui), for: .touchUpInside)
        
    }
    
    
    @IBAction func btn_swichOffice_tui(_ sender: UIButton) {
        office_view.isHidden = false
        self.view.bringSubview(toFront: office_view)
        //背景
        view.viewWithTag(100001)?.isHidden = false
        
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return collectionDs.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = notice_collection.dequeueReusableCell(withReuseIdentifier: "c1", for: indexPath)
        
        cell.cornerRadius = 4
        cell.clipsToBounds = true
        //cell.backgroundColor = UIColor.red
        
        let data = collectionDs[indexPath.section]
        let title = data["title"].stringValue
        let msg = data["msg"].stringValue
        
        let lbl = cell.viewWithTag(10001) as! UILabel
        lbl.text = title
        lbl.numberOfLines = 0
        //title的行数
        let tn = title.getLineNumberForWidth(width: UIScreen.width.subtracting(80), cFont: UIFont.systemFont(ofSize: 13))
        lbl.text = "\(title)"
        lbl.frame.size = CGSize(width: lbl.frame.size.width, height: CGFloat(lineHeight*tn))
        
        //分割线
        let dividing = cell.viewWithTag(20001) as! UILabel
        var frame = CGRect()
        frame.origin = CGPoint(x: dividing.frame.origin.x, y: lbl.frame.height.adding(lbl.frame.origin.y))
        frame.size = dividing.frame.size
        dividing.frame = frame
        dividing.backgroundColor = UIColor.lightGray
        
        let contentLbl = cell.viewWithTag(30001) as! UILabel
        contentLbl.text = msg
        contentLbl.numberOfLines = 0
        //正文的行数
        let mn = msg.getLineNumberForWidth(width: UIScreen.width.subtracting(80), cFont: UIFont.systemFont(ofSize: 13))
        if mn>3{
            print()
        }
        contentLbl.text = "\(msg)"
        contentLbl.frame.size = CGSize(width: contentLbl.frame.size.width, height: CGFloat(lineHeight*mn))
        contentLbl.frame.origin = CGPoint(x: contentLbl.frame.origin.x, y: lbl.frame.height.adding(lbl.frame.origin.y).adding(1))
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let lblWidth = UIScreen.width.subtracting(40)
        let data = collectionDs[indexPath.section]
        let title = data["title"].stringValue
        let msg = data["msg"].stringValue
        //title的行数
        let tn = title.getLineNumberForWidth(width: lblWidth.subtracting(40), cFont: UIFont.systemFont(ofSize: 13))
        //正文的行数
        let mn = msg.getLineNumberForWidth(width: lblWidth.subtracting(40), cFont: UIFont.systemFont(ofSize: 13))
        let contentHeight = lineHeight * (tn+mn)
        return CGSize(width: lblWidth, height: CGFloat(contentHeight + 20))
        
    }
    
    //展示section
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        switch kind{
        case UICollectionElementKindSectionHeader:
            let header:HeaderReusableView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "header", for: indexPath as IndexPath) as! HeaderReusableView
            if collectionDs.count > 0{
                let data = collectionDs[indexPath.section]
                
                header.name!.text = "\t"+data["createloginname"].stringValue
                header.date!.text = "\(data["createtime"].stringValue.prefix(19))"
            }
            
            return header
        default:
            return HeaderReusableView()
        }
    }
    
    //分组的头部视图的尺寸，在这里控制分组头部视图的高度
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        
        return CGSize.init(width: UIScreen.width, height: CGFloat(35))
    }
    
    func loadData(){
        let url = "http://"+Ip_port2+"doctor_train/rest/app/queryOfficeNotice.do"
        myPostRequest(url,["officeid":currentOffice["officeid"].stringValue, "pageindex":collectionDs.count, "pagesize":20]).responseJSON(completionHandler: {resp in
            MBProgressHUD.hide(for: self.view, animated: true)
            self.notice_collection.mj_footer.endRefreshing()
            self.notice_collection.mj_header.endRefreshing()
            switch resp.result{
            case .success(let responseJson):
                let json = JSON(responseJson)
                if json["code"].stringValue == "1"{
                    
                    self.collectionDs += json["data"].arrayValue
                    if json["data"].arrayValue.count == 0{
                        self.notice_collection.mj_footer.endRefreshingWithNoMoreData()
                    }
                    self.notice_collection.reloadData()
                }else{
                    myAlert(self, message: "读取公告失败")
                }
            case .failure(let error):
                print(error)
            }
            
        })
    }
    
    func refreshAction() {
        collectionDs.removeAll()
        self.notice_collection.mj_footer.resetNoMoreData()
        loadData()
    }
    
    func loadMoreAction() {
        loadData()
    }
    
    func btn_nav_tui(sender : UIButton){
        switch sender.tag {
        case 20001:
            let vc = getViewToStoryboard("joinOfficeView") as! JoinOfficeController
            vc.office = currentOffice
            self.present(vc, animated: true, completion: nil)
            break
        case 20002:
            myAlert(self, message: "暂未开放")
            break
        case 20003:
            let vc = getViewToStoryboard("createNoticeView") as! CreateNoticeController
            vc.office = currentOffice
            self.present(vc, animated: true, completion: nil)
            break
        case 20004:
            let vc = OfficePeopleViewController()
            vc.office = currentOffice
            let nav = UINavigationController(rootViewController: vc)
            self.present(nav, animated: true, completion: nil)
            break
        case 20005:
            let vc = SmallLectureViewController()
            vc.office = currentOffice
            let nav = UINavigationController(rootViewController: vc)
            self.present(nav, animated: true, completion: nil)
            break
            
            
        default: break
            
        }
    }
    
}

class HeaderReusableView: UICollectionReusableView {
    var name:UILabel!
    var date:UILabel!
    override init(frame: CGRect) {
        super.init(frame: frame)
        //
        let width = UIScreen.width
        name = UILabel(frame: CGRect.init(x: 0, y: 5, width: width, height: 30))
        name.backgroundColor = UIColor.clear
        name.textAlignment = .left
        name.font = UIFont.systemFont(ofSize: 13)
        name.textColor = UIColor.darkGray
        
        date = UILabel(frame: CGRect.init(x: 0, y: 5, width: width, height: 30))
        date.backgroundColor = UIColor.clear
        date.textAlignment = .center
        date.font = UIFont.systemFont(ofSize: 13)
        date.textColor = UIColor.darkGray
        
        self.addSubview(name!)
        self.addSubview(date!)
        //self.backgroundColor = UIColor.white
        
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
