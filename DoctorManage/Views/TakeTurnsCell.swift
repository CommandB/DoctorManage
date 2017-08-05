//
//  TakeTurnsCell.swift
//  DoctorManage
//
//  Created by 陈海峰 on 2017/6/8.
//  Copyright © 2017年 chenshengchang. All rights reserved.
//

import UIKit

class TakeTurnsCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    @IBOutlet weak var titleNum: UILabel!
    @IBOutlet weak var detailNum: UILabel!
    @IBOutlet weak var ratioNum: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
