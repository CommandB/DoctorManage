//
//  DeduceScoreCell.swift
//  DoctorManage
//
//  Created by 陈海峰 on 2017/6/17.
//  Copyright © 2017年 chenshengchang. All rights reserved.
//

import UIKit
protocol DeduceScoreCellDelegate: class {
    func deduceScoreBtnDidTapped()
}
class DeduceScoreCell: UITableViewCell {
    @IBOutlet weak var deduceBtn: UIButton!
    @IBOutlet weak var scoreruleLabel: UILabel!
    @IBOutlet weak var deducedLabel: UILabel!
    weak var delegate: DeduceScoreCellDelegate?
    @IBAction func deduceBtntapped(_ sender: Any) {
        self.delegate?.deduceScoreBtnDidTapped()
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        deduceBtn.layer.cornerRadius = deduceBtn.bounds.size.height/2
        deduceBtn.layer.masksToBounds = true
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
