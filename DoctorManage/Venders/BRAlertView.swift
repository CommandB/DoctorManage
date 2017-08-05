//
//  BRAlertView.swift
//  Menu_Settings
//
//  Created by debug on 16/6/1.
//  Copyright © 2016年 debug. All rights reserved.
//

import UIKit

class BRAlertView{
    
    class func showPrint(message:String ,target:UIViewController){
        let alert = UIAlertController.init(title: nil, message: message, preferredStyle: UIAlertControllerStyle.alert)
        target.present(alert, animated: true, completion: nil)
    }
    
    class func show(message:String ,target:UIViewController){
        let alert = UIAlertController.init(title: nil, message: message, preferredStyle: UIAlertControllerStyle.alert)
        target.present(alert, animated: true, completion: nil)
        DispatchQueue.global().async {
            Thread.sleep(forTimeInterval: 1)
            DispatchQueue.main.async {
                alert.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    class func show(message:String ,target:UIViewController? ,duration:TimeInterval){
        let alert = UIAlertController.init(title: nil, message: message, preferredStyle: UIAlertControllerStyle.alert)
        target?.present(alert, animated: true, completion: nil)
        DispatchQueue.global().async {
            Thread.sleep(forTimeInterval: duration)
            DispatchQueue.main.async {
                alert.dismiss(animated: true, completion: { 
                    target?.dismiss(animated: true, completion: nil)
                })
            }
        }
    }
    
    class func showOKAlert(message:String ,target:UIViewController?){
        let alert = UIAlertController.init(title: nil, message: message, preferredStyle: UIAlertControllerStyle.alert)
        let okAction = UIAlertAction.init(title: NSLocalizedString("OK", comment: ""), style: UIAlertActionStyle.cancel, handler: nil)
        alert.addAction(okAction)
        target?.present(alert, animated: true, completion: nil)
    }
    
    class func showOkCancelAlert(message:String ,target:UIViewController? ,code:((UIAlertAction) ->())?){
        let alert = UIAlertController.init(title: nil, message: message, preferredStyle: UIAlertControllerStyle.alert)
        let okaction = UIAlertAction.init(title: NSLocalizedString("OK", comment: ""), style: .default, handler:{
            code
        }())
        let cancel = UIAlertAction.init(title: NSLocalizedString("cancel", comment: ""), style: UIAlertActionStyle.cancel, handler: nil)
        alert.addAction(okaction)
        alert.addAction(cancel)
        target?.present(alert, animated: true, completion: nil)
    }
    
    
    private class func showTextFieldAlert(title:String?,
                                          item:[String],
                                          ifRed:Bool,
                                          cods:[((UIAlertAction) ->())?]) -> UIAlertController
    {
        let textFieldAlert = UIAlertController(title:title,
                                               message: nil,
                                               preferredStyle: .alert)
        textFieldAlert.addTextField { (nameField:UITextField!) -> Void in
            nameField.placeholder = NSLocalizedString("enter the file name", comment: "")
        }
        var itemCount = 0
        for str in item{
            let action = UIAlertAction.init(title: str,
                                            style: UIAlertActionStyle.default,
                                            handler:
                {
                    cods[itemCount]
                }())
            textFieldAlert.addAction(action)
            itemCount += 1
            if ifRed
            {
                action.setValue(UIColor.red, forKey: "titleTextColor")
            }
        }
        return textFieldAlert
    }
    
    

    class func showFromFirstView(message:String){
        guard var view = UIApplication.shared.keyWindow?.rootViewController else { return }
        while view.presentedViewController != nil {
            view = view.presentedViewController!
        }
        self.showOKAlert(message: message, target: view)
    }
    
}
