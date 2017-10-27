//
//  BRPersonInfoData.swift
//  DoctorManage
//
//  Created by 陈海峰 on 2017/8/5.
//  Copyright © 2017年 chenshengchang. All rights reserved.
//

import UIKit
import SwiftyJSON
class BRPersonInfoData: NSObject {
    static let shared:BRPersonInfoData = BRPersonInfoData()
    var totalPersonInfo = [JSON]()
    var index = 0
    
}
