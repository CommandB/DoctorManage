//
//  AppDelegate.swift
//  DoctorManage
//
//  Created by 陈海峰 on 2017/6/2.
//  Copyright © 2017年 chenshengchang. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    let appKey = "f7a22a8c139ace77b2eb22a9"
    let channel = "Publish channel"
    let isProduction = false

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        if UserInfo.instance().token != nil {
            //更新ipPort
            if let loginInfo = UserDefaults.standard.dictionary(forKey: "loginInfo") {
                Ip_port2 = loginInfo["ipUrl"] as? String ?? ""
            }
            let tabbarController = MainTabbarController()
            self.window?.rootViewController = tabbarController
        }else{
            let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
            let loginViewController = storyboard.instantiateViewController(withIdentifier: "loginView") as! LoginViewController
            self.window?.rootViewController = loginViewController
        }
        self.window?.backgroundColor = UIColor.white
        setApperance()
        
        //JPush notification
        let entity = JPUSHRegisterEntity()
        entity.types = Int(JPAuthorizationOptions.alert.rawValue | JPAuthorizationOptions.sound.rawValue | JPAuthorizationOptions.badge.rawValue)
        
        
        JPUSHService.register(forRemoteNotificationConfig: entity, delegate: self)
        JPUSHService.setup(withOption: launchOptions, appKey: appKey, channel: channel, apsForProduction: isProduction)
        return true
    }
    
    func setApperance() {
        UINavigationBar.appearance().tintColor = UIColor.white
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

}

//MARK:-极光推送 AppDelegate扩展
extension AppDelegate:UNUserNotificationCenterDelegate,JPUSHRegisterDelegate
{
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        
        JPUSHService.registerDeviceToken(deviceToken)
        //设置tags,后台可以根据这个来推送（本处用的是UserId）
        if let userkey = UserInfo.instance().userkey {
            JPUSHService.setTags(["userkey"], aliasInbackground: userkey)
        }
        print("deviceToken:\(deviceToken)")
        let defaultCenter = NotificationCenter.default
        defaultCenter.addObserver(self, selector: #selector(networkDidReceiveMessage), name: NSNotification.Name(rawValue: kLoginSuccessNotification), object: nil)
        
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("did Fail To Register For Remote Notifications With Error:\(error)")
    }
    /**
     收到静默推送的回调
     
     @param application  UIApplication 实例
     @param userInfo 推送时指定的参数
     @param completionHandler 完成回调
     */
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        
        JPUSHService.handleRemoteNotification(userInfo)
        print("iOS7及以上系统，收到通知:\(userInfo)")
        completionHandler(UIBackgroundFetchResult.newData)
    }
    
    //    func application(_ application: UIApplication, didReceive notification: UILocalNotification) {
    //        JPUSHService.showLocalNotification(atFront: notification, identifierKey: nil)
    //    }
    //
    @available(iOS 10.0, *)
    func jpushNotificationCenter(_ center: UNUserNotificationCenter!, willPresent notification: UNNotification!, withCompletionHandler completionHandler: ((Int) -> Void)!) {
        
        let userInfo = notification.request.content.userInfo
        
        //        let request = notification.request; // 收到推送的请求
        //        let content = request.content; // 收到推送的消息内容
        //
        //        let badge = content.badge;  // 推送消息的角标
        //        let body = content.body;    // 推送消息体
        //        let sound = content.sound;  // 推送消息的声音
        //        let subtitle = content.subtitle;  // 推送消息的副标题
        //        let title = content.title;  // 推送消息的标题
        
        if (notification.request.trigger?.isKind(of: UNPushNotificationTrigger.self))!{
            print("iOS10 前台收到远程通知:\(userInfo)")
            JPUSHService.handleRemoteNotification(userInfo)
        }else {
            // 判断为本地通知
            print("iOS10 前台收到本地通知:\(userInfo)")
        }
        completionHandler(Int(UNAuthorizationOptions.alert.rawValue | UNAuthorizationOptions.sound.rawValue | UNAuthorizationOptions.badge.rawValue))// 需要执行这个方法，选择是否提醒用户，有badge、sound、alert三种类型可以选择设置
    }
    
    @available(iOS 10.0, *)
    func jpushNotificationCenter(_ center: UNUserNotificationCenter!, didReceive response: UNNotificationResponse!, withCompletionHandler completionHandler: (() -> Void)!) {
        let userInfo = response.notification.request.content.userInfo
        
        if (response.notification.request.trigger?.isKind(of: UNPushNotificationTrigger.self))!{
            print("iOS10 收到远程通知:\(userInfo)")
            JPUSHService.handleRemoteNotification(userInfo)
        }
        completionHandler()
    }
    
    func networkDidReceiveMessage() {
        JPUSHService.setTags(nil, aliasInbackground: UserInfo.instance().userkey)
    }
}


