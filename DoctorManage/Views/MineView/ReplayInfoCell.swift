//
//  ReplayInfoCell.swift
//  DoctorManage
//
//  Created by 陈海峰 on 2017/6/22.
//  Copyright © 2017年 chenshengchang. All rights reserved.
//

import UIKit

class ReplayInfoCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
