//
//  BaseEvaluateController.swift
//  DoctorManage
//
//  Created by 陈海峰 on 2017/7/2.
//  Copyright © 2017年 chenshengchang. All rights reserved.
//

import UIKit

class BaseEvaluateController: UIViewController,UIScrollViewDelegate,MoreMenuClickDelegate {
    var moreMenu = MoreMenuView()

    var topView = EvaluateTopSelectView()
    var scrollView = UIScrollView()
    var taskType = 1000
    
    var firstVC = WaitExamViewController()
    var secondVC = WaitEvaluateController()
    var thirdVC = CEXStudentsListController()
    var fourthVC = UIViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.setBackgroundImage(UIImage.init(named: "topBackgroundIcon"), for: .default)
//        self.extendedLayoutIncludesOpaqueBars = true
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.white]
        let image = UIImage(named: "Menu")!.withRenderingMode(.alwaysOriginal)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: image, style: .done, target: self, action: #selector(rightItemTapped))
        self.title = "考评"
        
        addChildeView()
        setupConStrains()
        setMoreMenu()
    }
    
    func addChildeView() {
        self.view.addSubview(topView)
        self.view.addSubview(scrollView)
    }
    
    func setupConStrains() {
        topView.mas_makeConstraints { (make) in
            make?.height.equalTo()(45)
            make?.top.offset()(0)
            make?.left.right().offset()(0)
        }
        topView.buttonClickCallBack = { (tag) in
            self.changeViewWithTag(type: tag)
        }
        scrollView.mas_makeConstraints { (make) in
            make?.top.equalTo()(topView.mas_bottom)
            make?.left.right().offset()(0)
            make?.bottom.offset()(0)
        }
        scrollView.isPagingEnabled = true
        scrollView.bounces = false
        scrollView.contentSize = CGSize(width: kScreenW*4, height: kScreenH-64-45-49)
        scrollView.delegate = self
        
        firstVC.view.frame = CGRect.init(x: 0, y: 0, width: kScreenW, height: kScreenH-64-45-49)
        secondVC.view.frame = CGRect.init(x: kScreenW, y: 0, width: kScreenW, height: kScreenH-64-45-49)
        thirdVC.view.frame = CGRect.init(x: kScreenW*2, y: 0, width: kScreenW, height: kScreenH-64-45-49)
        fourthVC.view.frame = CGRect.init(x: kScreenW*3, y: 0, width: kScreenW, height: kScreenH-64-45-49)
        
        self.addChildViewController(firstVC)
        self.addChildViewController(secondVC)
        self.addChildViewController(thirdVC)
        self.addChildViewController(fourthVC)
        self.scrollView.addSubview(firstVC.view)
        self.scrollView.addSubview(secondVC.view)
        self.scrollView.addSubview(thirdVC.view)
        self.scrollView.addSubview(fourthVC.view)
        
        firstVC.parentView = self
        secondVC.parentView = self
        thirdVC.parentView = self
    }
    
    func changeViewWithTag(type:NSInteger) {
        self.scrollView.contentOffset = CGPoint.init(x: kScreenW*CGFloat(type-1000), y:self.scrollView.contentOffset.y)
        moreMenu.isHidden = true
        if type == self.taskType {
            return
        }
        self.taskType = type
        self.refreshOrderList()
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let index = NSInteger(scrollView.contentOffset.x/kScreenW)
        self.topView.endScrollViewWithIndex(index:index)
        if 1000+index == self.taskType {
            return
        }
        self.taskType = 1000+index
        self.refreshOrderList()
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        moreMenu.isHidden = true
    }
    
    func refreshOrderList() {
        switch taskType {
        case 1000:
            self.firstVC.tableview.mj_header.beginRefreshing();
            break
        case 1001:
            self.secondVC.tableview.mj_header.beginRefreshing();
            break
        case 1002:
            self.thirdVC.students_collection?.mj_header.beginRefreshing()
            break
        case 1003:
            
            break
        default:
            break
        }
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        UIView.animate(withDuration: 0.5) {
            self.moreMenu.isHidden = true;
        }
    }
    
    func setMoreMenu() {
        moreMenu.frame = CGRect.init(x: self.view.frame.size.width-110, y: 64, width: 100, height: 100)
        moreMenu.tag = 1000
        moreMenu.m_delegate = self
        self.navigationController?.view.addSubview(moreMenu)
        moreMenu.isHidden = true
    }

    //MARK:moreMenuDelegate
    func moreMenu(with menuView: MoreMenuView!, with index: Int) {
        switch index {
        case 100:
            moreMenu.isHidden = true
            let historyExamVC = HistoryExamController()
            let nav = UINavigationController(rootViewController: historyExamVC)
            self.present(nav, animated: true, completion: nil)
        case 101:
            moreMenu.isHidden = true
            let historyEvaluateVC = HistoryEvaluateController()
            let nav = UINavigationController(rootViewController: historyEvaluateVC)
            self.present(nav, animated: true, completion: nil)
        default:break
        }
    }

    func rightItemTapped() {
        if moreMenu.isHidden == true {
            moreMenu.isHidden = false
        }else{
            moreMenu.isHidden = true
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        moreMenu.isHidden = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
