//
//  QuestionSelectCell.swift
//  jiaoshi4
//
//  Created by chenhaifeng  on 2017/6/13.
//  Copyright © 2017年 chenhaifeng . All rights reserved.
//

import UIKit

class QuestionSelectCell: UITableViewCell {

    @IBOutlet weak var optionLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()        
        optionLabel.layer.cornerRadius = optionLabel.bounds.size.height/2
        optionLabel.layer.masksToBounds = true
        
        // Initialization code
    }

//    required init?(coder aDecoder: NSCoder) {
//        self = super.init(coder: aDecoder)
//        if self {
//            self.backgroundColor = UIColor.red
//        }
//        return self
//    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
}
