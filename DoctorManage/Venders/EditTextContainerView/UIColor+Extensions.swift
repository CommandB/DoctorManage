//
//  File.swift
//  DesignAndPrint
//
//  Created by satoro on 6/14/16.
//  Copyright © 2016 Brother Industries, LTD. All rights reserved.
//

import Foundation
import UIKit
/// 左辺と右辺がUIColorの場合の演算子==をオーバーライド
func == (left: UIColor, right: UIColor) -> Bool {
    return left.isEqualColor(color: right)
}

// switchの条件がUIColorの場合の演算子をオーバーライド
func ~= (left: UIColor, right: UIColor) -> Bool {
    return left.isEqualColor(color: right)
}

extension UIColor {
    func isEqualColor(color: UIColor) -> Bool {
        var r1: CGFloat = 1.0, g1: CGFloat = 1.0, b1: CGFloat = 1.0, a1: CGFloat = 1.0
        self.getRed(&r1, green: &g1, blue: &b1, alpha: &a1)
        
        var r2: CGFloat = 1.0, g2: CGFloat = 1.0, b2: CGFloat = 1.0, a2: CGFloat = 1.0
        color.getRed(&r2, green: &g2, blue: &b2, alpha: &a2)
        
        let ret1 = isEqualUnderFourDecimalPlaces(num1: r1, num2: r2)
        let ret2 = isEqualUnderFourDecimalPlaces(num1: g1, num2: g2)
        let ret3 = isEqualUnderFourDecimalPlaces(num1: b1, num2: b2)
        let ret4 = isEqualUnderFourDecimalPlaces(num1: a1, num2: a2)
        
        return ret1 && ret2 && ret3 && ret4
    }
    
    private func isEqualUnderFourDecimalPlaces(num1: CGFloat, num2: CGFloat) -> Bool {
        //
        // UIColor.rgb()でRGB値を0-255指定でUIColorをインスタンス化しているので
        // RGB値の分解能は1/255 = 0.0039...-> 0.004 となる。
        // つまり、それ未満の誤差は無視しても問題ない。-> 小数点5桁以下は切り捨てる。
        //
        let iNum1 = Int(num1 * 10000)
        let iNum2 = Int(num2 * 10000)
        
        return iNum1 == iNum2
    }
    
    /**
     rgb変換の拡張関数
     
     - parameter r: red
     - parameter g: green
     - parameter b: blue
     - parameter alpha: alpha値
     - returns: RGB値から算出したUIColorの値
     */
    class func rgb(r: Int, g: Int, b: Int, alpha: CGFloat) -> UIColor{
        return UIColor(red: CGFloat(r) / 255.0, green: CGFloat(g) / 255.0, blue: CGFloat(b) / 255.0, alpha: alpha)
    }
    
    /**
     rgb変換の拡張関数(α値なし)
     
     - parameter r: red
     - parameter g: green
     - parameter b: blue
     - returns: RGB値から算出したUIColorの値
     */
    class func rgb(r: Int, g: Int, b: Int) -> UIColor{
        return rgb(r: r, g: g, b: b, alpha: 1.0)
    }
}
