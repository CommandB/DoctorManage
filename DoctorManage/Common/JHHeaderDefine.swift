//
//  JHHeaderDefine.swift
//  DoctorManage
//
//  Created by chenhaifeng on 2018/8/14.
//  Copyright © 2018年 chenshengchang. All rights reserved.
//

//MARK: 屏幕尺寸
let kScreenWidth = UIScreen.main.bounds.size.width
let kScreenHeight = UIScreen.main.bounds.size.height
let kStatusBarHeight = UIApplication.shared.statusBarFrame.size.height

//MARK: 常用字体
func S_font(n:CGFloat) -> UIFont {
    return  UIFont.systemFont(ofSize: n)
}
//MARK: 图片
func S_image(n:String) -> UIImage? {
    return  UIImage(named: n)
}
//MARK: 常用颜色
func RGBCOLOR(r:CGFloat,_ g:CGFloat,_ b:CGFloat) -> UIColor
{
    return UIColor(red: (r)/255.0, green: (g)/255.0, blue: (b)/255.0, alpha: 1.0)
}

func RGBACOLOR(r:CGFloat,_ g:CGFloat,_ b:CGFloat,_ a:CGFloat) -> UIColor
{
    return UIColor(red: (r)/255.0, green: (g)/255.0, blue: (b)/255.0, alpha: a)
}

func HEXCOLOR(hex:NSInteger) -> UIColor
{
     return UIColor(red: ((CGFloat)((hex & 0xFF0000) >> 16)) / 255.0, green: ((CGFloat)((hex & 0xFF00) >> 8)) / 255.0, blue: ((CGFloat)(hex & 0xFF)) / 255.0, alpha: 1)
}

func HEXACOLOR(hex:NSInteger,a:CGFloat) -> UIColor
{
    return UIColor(red: ((CGFloat)((hex & 0xFF0000) >> 16)) / 255.0, green: ((CGFloat)((hex & 0xFF00) >> 8)) / 255.0, blue: ((CGFloat)(hex & 0xFF)) / 255.0, alpha: a)
}

