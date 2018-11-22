//
//  UINavigationController + Extension.swift
//  YouJia
//
//  Created by 51pgzs on 2017/5/31.
//  Copyright © 2017年 51pgzs. All rights reserved.
//

import Foundation
import UIKit

extension UINavigationController: UIGestureRecognizerDelegate {
    
    
    open override func viewDidLoad() {
//        self.navigationBar.titleTextAttributes = [NSAttributedStringKey.font:UIFont.systemFont(ofSize: 18),NSAttributedStringKey.foregroundColor: UIColor.title]
//        self.navigationBar.setBackgroundImage(UIImage(), for: .default)
//        self.navigationBar.shadowImage = UIImage()
//        self.navigationBar.isTranslucent = true
//        setPanBack()
        
      
    }
    
    func setPanBack() {
        let target = self.interactivePopGestureRecognizer?.delegate
        let handleTransition = NSSelectorFromString("handleNavigationTransition:")
        let pan = UIPanGestureRecognizer(target: target, action: handleTransition)
        pan.delegate = self
        view.addGestureRecognizer(pan)
        self.interactivePopGestureRecognizer?.isEnabled = false
    }
    
//    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
//        if childViewControllers.count == 1 {
//            return false
//        }
//        return true
//    }
//
//    func pushViewController(_ viewController: UIViewController, animated: Bool, HideBottomBar: Bool) {
//        viewController.hidesBottomBarWhenPushed = HideBottomBar
//        self.pushViewController(viewController, animated: animated)
//
//    }
    
}

