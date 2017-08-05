//
//  EvaluateBaseCell.swift
//  jisoshi5
//
//  Created by chenhaifeng  on 2017/6/16.
//  Copyright © 2017年 chenhaifeng . All rights reserved.
//

import UIKit

class EvaluateBaseCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var personLabel: UILabel!
    @IBOutlet weak var accessView: UIImageView!

    @IBOutlet weak var waitTypeLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
