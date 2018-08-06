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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        office_view.backgroundColor = UIColor.white
        office_view.isHidden = true
        
        notice_collection.delegate = self
        notice_collection.dataSource = self
        //注册section Header
        notice_collection.register(HeaderReusableView.classForCoder(), forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "header")
        
        self.notice_collection.mj_header = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: #selector(refreshAction))
        self.notice_collection.mj_footer = MJRefreshAutoNormalFooter(refreshingTarget: self, refreshingAction: #selector(loadMoreAction))
        self.notice_collection.mj_header.beginRefreshing()
        
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
        
//        loadData()
    }
    
    
    @IBAction func btn_swichOffice_tui(_ sender: UIButton) {
        office_view.isHidden = false
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
        let data = collectionDs[indexPath.section]
        let title = data["title"].stringValue
        let msg = data["msg"].stringValue
        
        var lbl = cell.viewWithTag(10001) as! UILabel
        lbl.text = title
        lbl.numberOfLines = 0
        //title的行数
        let tn = title.getLineNumberForUILabel(lbl)
        lbl.text = " \(title)"
        lbl.frame.size = CGSize(width: lbl.frame.size.width, height: CGFloat(20*tn))
        
        //分割线
        let dividing = cell.viewWithTag(20001) as! UILabel
        var frame = CGRect()
        frame.origin = CGPoint(x: dividing.frame.origin.x, y: lbl.frame.height.adding(lbl.frame.origin.y))
        frame.size = dividing.frame.size
        dividing.frame = frame
        
        lbl = cell.viewWithTag(30001) as! UILabel
        lbl.text = msg
        lbl.numberOfLines = 0
        //正文的行数
        let mn = msg.getLineNumberForUILabel(lbl)
        lbl.text = " \(msg)"
        lbl.frame.size = CGSize(width: lbl.frame.size.width, height: CGFloat(20*mn))
        lbl.frame.origin = CGPoint(x: lbl.frame.origin.x, y: dividing.frame.origin.y.adding(1))
        
//        let lineWidth = lbl.frame.width - boundary
        
        
        
        
        //51 -
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        
        let data = collectionDs[indexPath.section]
        let title = data["title"].stringValue
        let msg = data["msg"].stringValue
        //title的行数
        let tn = title.getLineNumberForWidth(width: 300, cFont: UIFont.systemFont(ofSize: 13))
        //正文的行数
        let mn = msg.getLineNumberForWidth(width: 300, cFont: UIFont.systemFont(ofSize: 13))
        let contentHeight = 20*(tn+mn)
        return CGSize(width: UIScreen.width, height: CGFloat(contentHeight + 20))
        
    }
    
    //展示section
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        switch kind{
        case UICollectionElementKindSectionHeader:
            let header:HeaderReusableView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "header", for: indexPath as IndexPath) as! HeaderReusableView
            
            let data = collectionDs[indexPath.section]
            
            header.name!.text = "  "+data["createloginname"].stringValue
            header.date!.text = "\(data["createtime"].stringValue.prefix(18))"
            
            return header
        default:
            return HeaderReusableView()
        }
    }
    
    //分组的头部视图的尺寸，在这里控制分组头部视图的高度
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        
        return CGSize.init(width: UIScreen.width, height: CGFloat(20))
    }
    
    func loadData(){
        let url = "http://"+Ip_port2+"doctor_train/rest/app/queryOfficeNotice.do"
        myPostRequest(url,["officeid":currentOffice["officeid"].stringValue, "pageindex":collectionDs.count, "pagesize":20]).responseJSON(completionHandler: {resp in
            MBProgressHUD.hide(for: self.view, animated: true)
            switch resp.result{
            case .success(let responseJson):
                let json = JSON(responseJson)
                if json["code"].stringValue == "1"{
                    
                    self.collectionDs += json["data"].arrayValue
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
            let nav = UINavigationController(rootViewController: SmallLectureViewController())
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
        let width = UIScreen.width - 40
        name = UILabel(frame: CGRect.init(x: 0, y: 0, width: width, height: 20))
        name.backgroundColor = UIColor.clear
        name.textAlignment = .left
        name.font = UIFont.boldSystemFont(ofSize: 13)
        name.textColor = UIColor.darkGray
        
        date = UILabel(frame: CGRect.init(x: 0, y: 0, width: width, height: 20))
        date.backgroundColor = UIColor.clear
        date.textAlignment = .center
        date.font = UIFont.boldSystemFont(ofSize: 13)
        date.textColor = UIColor.darkGray
        
        self.addSubview(name!)
        self.addSubview(date!)
        //self.backgroundColor = UIColor.white
        
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
