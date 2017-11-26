//
//  subEvaTrainCell.swift
//  DoctorManage
//
//  Created by 陈海峰 on 2017/6/15.
//  Copyright © 2017年 chenshengchang. All rights reserved.
//
import UIKit
import SwiftyJSON
extension UIView {
    
    @IBInspectable var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
        }
    }
    
    @IBInspectable var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
    
    @IBInspectable var borderColor: UIColor? {
        get {
            return UIColor(cgColor: layer.borderColor!)
        }
        set {
            layer.borderColor = newValue?.cgColor
        }
    }
}

class subEvaTrainCell: UITableViewCell {
    @IBOutlet weak var personName: UILabel!
    @IBOutlet weak var goodRadio: UILabel!
    
    var itemData = [JSON]()
    func setObject(object:[JSON]) {
        itemData = object
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if itemData.count == 0 {
            return
        }
        var h_x:CGFloat = 0
        var h_y:CGFloat = 40
        let l_x:CGFloat = 15
        let length:CGFloat = (self.frame.size.width-60)/3
        for i in 0...itemData.count-1 {
            let titleLabel = UILabel()
            titleLabel.frame = CGRect.init(x: 15+h_x, y: h_y, width: length, height: 30)
            titleLabel.text = itemData[i]["shorttitle"].stringValue+itemData[i]["okrate"].stringValue
            titleLabel.backgroundColor = UIColor.init(red: 244/255.0, green: 247/255.0, blue: 250/255.0, alpha: 1.0)
            titleLabel.font = UIFont.systemFont(ofSize: 12.0)
            titleLabel.textAlignment = .center
            if 15+h_x+length+l_x > self.frame.size.width {
                h_x = 0
                h_y = h_y + titleLabel.frame.size.height + 15
                titleLabel.frame = CGRect.init(x: 15+h_x, y: h_y, width: length, height: 30)
            }
            h_x = titleLabel.frame.size.width + titleLabel.frame.origin.x
            titleLabel.layer.masksToBounds = true
            titleLabel.layer.cornerRadius = titleLabel.frame.height/2
            titleLabel.layer.borderWidth = 1.0
            titleLabel.layer.borderColor = UIColor.init(red: 199/255.0, green: 211/255.0, blue: 224/255.0, alpha: 1.0).cgColor
            self.addSubview(titleLabel)
            self.personName.text = itemData[i]["evaluationrolename"].stringValue
        }
//        "roleid" : 1,
//        "maxvalue" : 140,
//        "okrate" : 0.385714,
//        "shorttitle" : "讲课水平",
//        "numbervalue" : 54,
//        "evaluationrolename" : "学生"
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
