//
//  SubScoreCell.swift
//  jisoshi5
//
//  Created by chenhaifeng  on 2017/6/16.
//  Copyright © 2017年 chenhaifeng . All rights reserved.
//

import UIKit
protocol SubScoreCellDelegate: class {
    func toMinusScore(_ sender: UIButton)
    func toAddScore(_ sender: UIButton)
}

class SubScoreCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var scoreRule: UILabel!
    @IBOutlet weak var minusBtn: UIButton!
    @IBOutlet weak var addBtn: UIButton!
    @IBOutlet weak var getscoreLabel: UILabel!
    weak var delegate: SubScoreCellDelegate?

    @IBAction func minusBtnTapped(_ sender: UIButton) {
        delegate?.toMinusScore(sender)
    }
    
    @IBAction func addBtnTapped(_ sender: UIButton) {
        delegate?.toAddScore(sender)
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
