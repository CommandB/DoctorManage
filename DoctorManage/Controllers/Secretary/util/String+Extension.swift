//
//  Date+Extension.swift
//  DoctorManage
//
//  Created by 陈海峰 on 2018/7/28.
//  Copyright © 2018年 chenshengchang. All rights reserved.
//

import UIKit
enum DateType {
    case dateTypeYear
    case dateTypeMonth
    case dateTypeDay
}

extension String {
    //根据时间字符串截取年月日
    func getDateNum(type:DateType) -> String{
        let nextformatter = DateFormatter()
        nextformatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        guard let date = nextformatter.date(from: self) else {return "--"}
        nextformatter.dateFormat = "yyyy"
        let year = nextformatter.string(from: date)
        
        nextformatter.dateFormat = "MM"
        let month = nextformatter.string(from: date)

        nextformatter.dateFormat = "dd"
        let day = nextformatter.string(from: date)
        
        switch type {
        case .dateTypeYear:
            return year
        case .dateTypeMonth:
            return month
        case .dateTypeDay:
            return day
        }
    }
    
    //根据时间字符串截取精确到分钟字符串
    func extractHourStrFromDateStr() -> String {
        let nextformatter = DateFormatter()
        nextformatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        guard let date = nextformatter.date(from: self) else {return "--"}
        let newDateFormatter = DateFormatter()
        newDateFormatter.dateFormat = "HH:mm"
        let hourString = newDateFormatter.string(from: date)
        return hourString
    }
    
}
