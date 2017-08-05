//
//  InputTextController.swift
//  DesignAndPrint
//
//  Created by APBIL2006036 on 2016/06/22.
//  Copyright © 2016年 Brother Industries, LTD. All rights reserved.
//

import Foundation
import UIKit
import SwiftOnoneSupport

protocol InputTextControllerDelegate: class {
    func onFinishInput(text: String)
    func viewDidShow()
    func viewDidHide()
}

class InputTextController: NSObject, EditTextContainerViewDelegate {
    weak var parentViewController: UIViewController!
    
    private var isShowKeyboard: Bool = false
    private var needsCheckCloseKeyboard: Bool = true
    weak var delegate: InputTextControllerDelegate?
    private let duration: TimeInterval = 0.25
    
    let editTextContainerView: EditTextContainerView = EditTextContainerView.instantiateXib()
    var tvBottomConstrant: NSLayoutConstraint?
    var tvHeightConstraint: NSLayoutConstraint?
    
    // 回転中かどうか
    // 回転によってキーボードが閉じられるかどうかを取得したい
    // この値はEditLabelViewController によって変更される
    var isRotating: Bool = false
    
    func addObserver() {
        let defaultCenter = NotificationCenter.default
        defaultCenter.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        defaultCenter.addObserver(self, selector: #selector(keyboardDidShow), name: NSNotification.Name.UIKeyboardDidShow, object: nil)
        defaultCenter.addObserver(self, selector: #selector(keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    func removeObserver() {
        let defaultCenter = NotificationCenter.default
        defaultCenter.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        defaultCenter.removeObserver(self, name: NSNotification.Name.UIKeyboardDidShow, object: nil)
        defaultCenter.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    func setup(vc: UIViewController, parentViewWidth: CGFloat) {
        parentViewController = vc
        editTextContainerView.delegate = self
        tvBottomConstrant = NSLayoutConstraint(item: editTextContainerView, attribute: .bottom, relatedBy: .equal, toItem: vc.bottomLayoutGuide, attribute: .top, multiplier: 1.0, constant: 0)
        let leftConstrant = NSLayoutConstraint(item: editTextContainerView, attribute: .left, relatedBy: .equal, toItem: vc.view, attribute: .left, multiplier: 1.0, constant: 0)
        let rightConstrant = NSLayoutConstraint(item: editTextContainerView, attribute: .right, relatedBy: .equal, toItem: vc.view, attribute: .right, multiplier: 1.0, constant: 0)
        tvHeightConstraint = NSLayoutConstraint(item: editTextContainerView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1.0, constant: kEditTextContainerViewHeight)
        let widthConstraint = NSLayoutConstraint(item: editTextContainerView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .width, multiplier: 1.0, constant: parentViewWidth)
        editTextContainerView.addConstraints([tvHeightConstraint!, widthConstraint])
        editTextContainerView.alpha = 0
        vc.view.addSubview(editTextContainerView)
        vc.view.addConstraints([tvBottomConstrant!, leftConstrant, rightConstrant])
        vc.view.layoutIfNeeded()
    }
    
    func show() {
        editTextContainerView.textView.becomeFirstResponder()
    }
    
    func close(){
        close(needsCheck: true)
    }
    
    func close(needsCheck: Bool) {
        guard isShown() else { return }
        needsCheckCloseKeyboard = needsCheck
        if !needsCheckCloseKeyboard {
//            self.delegate?.viewDidHide()
        }
        editTextContainerView.endEditing(true)
        
    }
    
    func editTextDoneTapped(inputText: String) {
        if inputText.characters.count == 0 || inputText.trimmingCharacters(in: .whitespacesAndNewlines).lengthOfBytes(using: .utf8) == 0{
            return
        }
        close(needsCheck: false)
        finishTextInput(text: inputText)
    }

    private func finishTextInput(text: String) {
        needsCheckCloseKeyboard = false
        delegate?.onFinishInput(text: text)
        needsCheckCloseKeyboard = true
        editTextContainerView.textView.text = nil
    }
    
    func isShown() -> Bool {
        return isShowKeyboard
    }
    
    func getInputText() -> String {
        return editTextContainerView.textView.text
//        if let discardedText = editTextContainerView.discardedText(editTextContainerView.textView) {
//            return discardedText
//        } else {
//            return editTextContainerView.textView.text
//        }
    }
    
    //MARK: - keyboardNotification
    
    func keyboardWillShow(notification: NSNotification){
        guard let info: Dictionary = notification.userInfo else {
            return
        }
        guard let keyboardFrame: CGRect = (info[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
            return
        }
        isShowKeyboard = true
        updateLayoutConstant(value: -1 * keyboardFrame.size.height)
        tvHeightConstraint?.constant = kEditTextContainerViewHeight
        
        UIView.animate(withDuration: duration) { () -> Void in
            self.updateLayout(alpha: 1.0)
        }
    }
    
    func keyboardDidShow(notification: NSNotification){
//        if let textView = editTextContainerView.textView {
//            let start = textView.beginningOfDocument
//            let end = textView.endOfDocument
//            let selectRange = textView.textRange(from: start, to: end)
//            textView.selectedTextRange = selectRange
//        }
        delegate?.viewDidShow()
    }
    
    func keyboardWillHide(notification: NSNotification){
        if checkTappedHideKeyboardButton() {
//            finishTextInput(text: getInputText())
        }
        
        updateLayoutConstant(value: 0)
        isShowKeyboard = false
        
        UIView.animate(withDuration: duration, animations: { 
            () -> Void in
            self.updateLayout(alpha: 0)
        }, completion: {
            (_) -> Void in
            self.delegate?.viewDidHide()
        }
        )
        needsCheckCloseKeyboard = true
    }

    private func updateLayoutConstant(value: CGFloat) {
        tvBottomConstrant?.constant = value
    }
    
    private func updateLayout(alpha: CGFloat){
        self.editTextContainerView.layoutIfNeeded()
        self.editTextContainerView.alpha = alpha
    }
    
    /**
     編集画面の横画面でキーボードの右下のボタンをタップしてキーボードを閉じたかどうかを返す
     そのボタンは横画面表示のときのみ表示されるので、判定は以下の条件で行う
     * 横画面
     * キーボードが閉じる前に、Doneボタンをタップしていないか
     * 画面回転中ではないか(画面回転によってもキーボードはOSによって非表示→表示となる)
     
     - warning: iPhoneのみ有効
     - returns: true: キーボードの右下をタップして閉じられる  false: それ以外
     */
    private func checkTappedHideKeyboardButton() -> Bool {
        return needsCheckCloseKeyboard && !isRotating
    }
}
