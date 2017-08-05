//
//  BaseTableViewCell.swift
//  DoctorManage
//
//  Created by 陈海峰 on 2017/6/2.
//  Copyright © 2017年 chenshengchang. All rights reserved.
//

import UIKit

class BaseTableViewCell: UITableViewCell {

    @IBOutlet weak var backGroundView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var retainTimeLabel: UILabel!
    
    @IBOutlet weak var beginTimeLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    
    
    override func draw(_ rect: CGRect) {
//        backGroundView.backgroundColor = UIColor.white
//        self.contentView.backgroundColor = UIColor.init(colorLiteralRed: 0.88, green: 0.88, blue: 0.88, alpha: 1.0)
        titleLabel.font = UIFont.boldSystemFont(ofSize: 17)
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
