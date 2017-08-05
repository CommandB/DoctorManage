//
//  TaskPersonInfoCell.swift
//  DoctorManage
//
//  Created by 陈海峰 on 2017/7/1.
//  Copyright © 2017年 chenshengchang. All rights reserved.
//

import UIKit

class TaskPersonInfoCell: UITableViewCell {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var professionalLabel: UILabel!
    @IBOutlet weak var lateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
