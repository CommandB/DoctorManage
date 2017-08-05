//
//  BaseEvaluateController.swift
//  DoctorManage
//
//  Created by 陈海峰 on 2017/7/2.
//  Copyright © 2017年 chenshengchang. All rights reserved.
//

import UIKit

class BaseEvaluateController: UITableViewController,MoreMenuClickDelegate {
    var moreMenu = MoreMenuView()
    
    /// 子标题
    lazy var subTitleArr:[String] = {
        return ["待考任务", "待评任务"]
    }()
    
    /// 子控制器
    var controllers:[UIViewController] = {
        var cons:[UIViewController] = [UIViewController]()
        cons.append(WaitExamViewController())
        cons.append(WaitEvaluateController())
        return cons
    }()
    
    
    /// 菜单分类控制器
    lazy var lxfMenuVc: EvaluateMenuController = {
        let pageVc = EvaluateMenuController(controllers: self.controllers, titles: self.subTitleArr, inParentController: self)
        pageVc.delegate = self
        self.view.addSubview(pageVc.view)
        return pageVc
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.setBackgroundImage(UIImage.init(named: "topBackgroundIcon"), for: .default)
//        self.extendedLayoutIncludesOpaqueBars = true
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.white]
//        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage.init(named: "Menu"), style: .done, target: self, action: #selector(rightItemTapped))
        self.title = "考评"
        tableView.tableFooterView = UIView()
        self.tableView.backgroundColor = UIColor(red: 245/255.0, green: 248/255.0, blue: 251/255.0, alpha: 1.0)
        lxfMenuVc.tipBtnFontSize = 15
        lxfMenuVc.view.frame = CGRect.init(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
        self.view.addSubview(lxfMenuVc.view)
        setMoreMenu()
    }

    func setMoreMenu() {
        moreMenu.frame = CGRect.init(x: self.view.frame.size.width-110, y: 0, width: 100, height: 100)
        moreMenu.tag = 1000
        moreMenu.m_delegate = self
        self.view.addSubview(moreMenu)
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
    
    func handleGesture() {
        moreMenu.isHidden = true
    }
    func rightItemTapped() {
        if moreMenu.isHidden == true {
            moreMenu.isHidden = false
        }else{
            moreMenu.isHidden = true
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        moreMenu.isHidden = true
    }
    
    /// 隐藏状态栏
    override var prefersStatusBarHidden: Bool {
        return false
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

// MARK:- LXFMenuPageControllerDelegate
extension BaseEvaluateController: EvaluateMenuControllerDelegate {
    func lxf_MenuPageCurrentSubController(index: NSInteger, menuPageController: EvaluateMenuController) {
        print("第\(index)个子控制器")
    }
}
