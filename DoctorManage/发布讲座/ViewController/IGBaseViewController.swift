//
//  IGBaseViewController.swift
//  IBlueCarShare
//
//  Created by chenhaifeng on 2018/3/5.
//  Copyright © 2018年 iOS. All rights reserved.
//

import UIKit
class IGBaseViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.setBackgroundImage(UIImage.init(named: "topBackgroundIcon"), for: .default)
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.white]
        
        self.setNavBackItem()
        self.navigationController?.navigationBar.isTranslucent = false
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
    
    override func motionEnded(_ motion: UIEventSubtype, with event: UIEvent?) {
        if motion == .motionShake {
        }
    }
    // 当前视图是否是根视图
    func isNavRoot() -> Bool {
        
        return self.navigationController?.viewControllers.first == self
    }
    
    func setNavBackItem(){
    //获取到导航控制器的子视图控制器的个数
        let count = self.navigationController?.viewControllers.count
        if  count! > 1 || isNavRoot(){
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
    
    func presentViewController(viewController:UIViewController, animated: Bool) {
        self.present(UINavigationController(rootViewController: viewController), animated: animated)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    

}
