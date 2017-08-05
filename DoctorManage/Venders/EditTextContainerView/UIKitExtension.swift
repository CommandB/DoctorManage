//
//  ViewExtension.swift
//  ESJ
//
//  Created by APBIL2006036 on 2015/12/17.
//  Copyright © 2015年 satoro. All rights reserved.
//

import Foundation
import UIKit

protocol StoryboardInitializable {
}

extension StoryboardInitializable where Self: UIViewController {
    
    static func instantiateStoryboard() -> Self {
        let type = Mirror(reflecting: self).subjectType
        let name = String(describing: type).components(separatedBy: ".")[0] // クラス名を取得
        let storyboard = UIStoryboard(name: name, bundle: nil)
        let viewController = storyboard.instantiateInitialViewController() as! Self
        return viewController
    }
}

protocol XibInitializable {
}

extension XibInitializable where Self: UIView {
    
    static func instantiateXib() -> Self {
        let type = Mirror(reflecting: self).subjectType
        let name = String(describing: type).components(separatedBy: ".")[0] // クラス名を取得
        let nib = UINib(nibName: name, bundle: nil)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! Self
        return view
    }
}
