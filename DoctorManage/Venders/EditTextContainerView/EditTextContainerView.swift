//
//  EditTextContainerView.swift
//  ESJ
//
//  Created by APBIL2006036 on 2016/01/20.
//  Copyright © 2016年 satoro. All rights reserved.
//

import Foundation
import UIKit
import SwiftOnoneSupport
let kEditTextContainerViewHeight: CGFloat = 50

protocol EditTextContainerViewDelegate: class {
//    func editTextFontSetTapped(inputText: String)
    func editTextDoneTapped(inputText: String)
}

class EditTextContainerView: UIView, XibInitializable {
    weak var delegate: EditTextContainerViewDelegate?
    
    @IBOutlet weak var rightButton: UIButton!

    @IBOutlet weak var textContainerView: UIView!
    
    @IBOutlet weak var textView: UITextView!
    
    let kBackGroundColor = UIColor.rgb(r: 248, g: 248, b: 248, alpha: 1.0)
    let maxTextLength = 512
    
    override func awakeFromNib() {
        textContainerView.backgroundColor = kBackGroundColor
        rightButton.setTitle("发布", for: .normal)
        translatesAutoresizingMaskIntoConstraints = false
        textView.delegate = self
    }
    
    @IBAction func tapRightButton(_ sender: AnyObject) {
        delegate?.editTextDoneTapped(inputText: textView.text)
    }
    
//    func discardedText(_ textView: UITextView) -> String? {
//        if textView.text.characters.count > maxTextLength {
//            let startIndex = textView.text.startIndex
//            let lastIndex = textView.text.index(startIndex, offsetBy: maxTextLength)
//            return textView.text.substring(with: startIndex..<lastIndex)
//        } else {
//            return nil
//        }
//    }

}

extension EditTextContainerView: UITextViewDelegate {
    
//    func textViewDidChange(_ textView: UITextView) {
//        if textView.markedTextRange != nil {
//            return
//        }
//
//        if let discardedText = discardedText(textView) {
//            textView.text = discardedText
//        }
//    }
    
}
