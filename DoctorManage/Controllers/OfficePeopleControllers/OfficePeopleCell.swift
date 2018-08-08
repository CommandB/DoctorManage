//
//  OfficePeopleCell.swift
//  DoctorManage
//
//  Created by 陈海峰 on 2018/8/6.
//  Copyright © 2018年 chenshengchang. All rights reserved.
//

import UIKit
import SwiftyJSON
class OfficePeopleCell: UITableViewCell {
    var titleLabel = UILabel()
    
    func setUpUI() {
        self.selectionStyle = .none
        titleLabel.frame = CGRect.init(x: 20, y: 10, width: 80, height: 40)
        self.addSubview(titleLabel)
    }
    
    func bindData(_ itemDic:JSON) {
        titleLabel.text = itemDic["rolename"].stringValue
        let itemDataList = itemDic["my_data_list"].arrayValue
        if itemDataList.count == 0 {
            return
        }
        for subview in self.subviews {
            if subview is UILabel && subview != titleLabel{
                subview.removeFromSuperview()
            }
        }
        var h_x:CGFloat = 120
        var h_y:CGFloat = 10
        let l_x:CGFloat = 10
        let length:CGFloat = (self.frame.size.width-170)/4
        let height:CGFloat = 40
        
        for i in 0...itemDataList.count-1 {
            let nameLabel = UILabel()
            nameLabel.frame = CGRect.init(x: h_x, y: h_y, width: length, height: height)
            nameLabel.text = itemDataList[i]["personname"].stringValue
            nameLabel.backgroundColor = UIColor.init(red: 76/255.0, green: 163/255.0, blue: 253/255.0, alpha: 1.0)
            nameLabel.font = UIFont.systemFont(ofSize: 15.0)
            nameLabel.textAlignment = .center
            if h_x+length+20 > self.frame.size.width {
                h_x = 120
                h_y = h_y + height + 10
                nameLabel.frame = CGRect.init(x: h_x, y: h_y, width: length, height: height)
            }
            h_x = 120+(length+l_x)*CGFloat(i%4+1)
//            titleLabel.layer.masksToBounds = true
//            titleLabel.layer.cornerRadius = titleLabel.frame.height/2
//            titleLabel.layer.borderWidth = 1.0
//            titleLabel.layer.borderColor = UIColor.init(red: 199/255.0, green: 211/255.0, blue: 224/255.0, alpha: 1.0).cgColor
            self.addSubview(nameLabel)
        }
    }
    
    required init?(coder aDecoder:NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(style:UITableViewCellStyle, reuseIdentifier:String?) {
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setUpUI()
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
