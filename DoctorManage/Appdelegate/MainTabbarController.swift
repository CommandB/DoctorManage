//
//  MainTabbarController.swift
//  DoctorManage
//
//  Created by 陈海峰 on 2017/6/2.
//  Copyright © 2017年 chenshengchang. All rights reserved.
//

import UIKit

class MainTabbarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        creatTabbarController()
    }
    func creatTabbarController() {
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
//        let taskCenterVC = storyboard.instantiateViewController(withIdentifier: "taskCenterView")
        let taskCenterVC = UINavigationController(rootViewController: TaskCenterViewController())
        
        let studentVC = storyboard.instantiateViewController(withIdentifier: "studentView")
        let studentNav = UINavigationController(rootViewController: studentVC)
        
        let evaluateNav = UINavigationController(rootViewController: BaseEvaluateController())
        let mineNav = UINavigationController(rootViewController: MineViewController())
        
        let secretaryVC = storyboard.instantiateViewController(withIdentifier: "secretaryCenterView")
        
        taskCenterVC.title = "任务中心"
        secretaryVC.title = "科室"
        studentNav.title = "学员"
        evaluateNav.title = "考评"
        mineNav.title = "我的"

        self.viewControllers = [taskCenterVC, secretaryVC, studentNav, evaluateNav, mineNav]
        
        let image1 = UIImage(cgImage: (UIImage.init(named: "任务中心-灰色")?.cgImage)!, scale: 2.8, orientation: .up)
        let selectedImage1 = UIImage(cgImage: (UIImage.init(named: "任务中心")?.cgImage)!, scale: 2.8, orientation: .up)
        taskCenterVC.tabBarItem.image = image1.withRenderingMode(.alwaysOriginal)
        taskCenterVC.tabBarItem.selectedImage = selectedImage1.withRenderingMode(.alwaysOriginal)
        
        let image5 = UIImage(cgImage: (UIImage.init(named: "学员-灰色")?.cgImage)!, scale: 2.8, orientation: .up)
        let selectedImage5 = UIImage(cgImage: (UIImage.init(named: "科室")?.cgImage)!, scale: 2.8, orientation: .up)
        secretaryVC.tabBarItem.image = image5.withRenderingMode(.alwaysOriginal)
        secretaryVC.tabBarItem.selectedImage = selectedImage5.withRenderingMode(.alwaysOriginal)
        
        let image2 = UIImage(cgImage: (UIImage.init(named: "学员-灰色")?.cgImage)!, scale: 2.8, orientation: .up)
        let selectedImage2 = UIImage(cgImage: (UIImage.init(named: "学员")?.cgImage)!, scale: 2.8, orientation: .up)
        studentNav.tabBarItem.image = image2.withRenderingMode(.alwaysOriginal)
        studentNav.tabBarItem.selectedImage = selectedImage2.withRenderingMode(.alwaysOriginal)
        
        let image3 = UIImage(cgImage: (UIImage.init(named: "考评-灰色")?.cgImage)!, scale: 2.8, orientation: .up)
        let selectedImage3 = UIImage(cgImage: (UIImage.init(named: "考评")?.cgImage)!, scale: 2.8, orientation: .up)
        evaluateNav.tabBarItem.image = image3.withRenderingMode(.alwaysOriginal)
        evaluateNav.tabBarItem.selectedImage = selectedImage3.withRenderingMode(.alwaysOriginal)
        
        let image4 = UIImage(cgImage: (UIImage.init(named: "个人中心-灰色")?.cgImage)!, scale: 2.8, orientation: .up)
        let selectedImage4 = UIImage(cgImage: (UIImage.init(named: "个人中心")?.cgImage)!, scale: 2.8, orientation: .up)
        mineNav.tabBarItem.image = image4.withRenderingMode(.alwaysOriginal)
        mineNav.tabBarItem.selectedImage = selectedImage4.withRenderingMode(.alwaysOriginal)
        
        self.tabBar.isOpaque = true
        UITabBar.appearance().backgroundColor = UIColor.white
        UITabBar.appearance().isTranslucent = false
        self.tabBar.tintColor = UIColor.black
        self.selectedIndex = 0
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
