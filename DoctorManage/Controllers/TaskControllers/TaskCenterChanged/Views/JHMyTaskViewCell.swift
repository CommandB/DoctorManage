//
//  JHMyTaskViewCell.swift
//  DoctorManage
//
//  Created by chenhaifeng on 2018/8/10.
//  Copyright © 2018年 chenshengchang. All rights reserved.
//

import UIKit

class JHMyTaskViewCell: UITableViewCell {
    @IBOutlet weak var backGroundView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var retainTimeLabel: UILabel!
    
    @IBOutlet weak var beginTimeLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var endTimeLabel: UILabel!
    
    @IBOutlet weak var taskStateLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
