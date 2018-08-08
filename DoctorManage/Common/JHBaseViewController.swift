//
//  IGCommonViewController.swift
//  DoctorManage
//
//  Created by 陈海峰 on 2018/8/6.
//  Copyright © 2018年 chenshengchang. All rights reserved.
//

import UIKit

class JHBaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(named: "topBack.png"), for: .default)
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.white]
        self.setNavBackItem(false)
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.hidesBottomBarWhenPushed = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if self.isNavRoot(){
            self.hidesBottomBarWhenPushed = false
        } else {
            self.hidesBottomBarWhenPushed = true
        }
    }
    
    // 当前视图是否是根视图
    func isNavRoot() -> Bool {
        
        return self.navigationController?.viewControllers.first == self
    }
    
    func setNavBackItem(_ containBack:Bool){
        //获取到导航控制器的子视图控制器的个数
        let count = self.navigationController?.viewControllers.count
        if  count! > 1 || containBack == true{
            let leftBtn = UIButton.init(frame: CGRect.init(x: 0, y: 0, width: 40, height: 40))
            let image = UIImage(named: "返回")!.withRenderingMode(.alwaysOriginal)
            leftBtn.setImage(image, for: .normal)
            leftBtn.addTarget(self, action: #selector(backToSuperView), for: .touchUpInside)
            let leftButtonItem = UIBarButtonItem.init(customView: leftBtn)
            self.navigationItem.leftBarButtonItem = leftButtonItem
            
        }
    }
    
    @objc func backToSuperView() {
        if (self.navigationController?.viewControllers.first == self) {
            self.dismiss(animated: true, completion: nil)
        } else {
            if ((self.presentedViewController) != nil) {
                self.dismiss(animated: true, completion: nil)
            } else {
                self.navigationController?.popViewController(animated: true)
            }
        }
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
