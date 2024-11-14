//  AnswersCell.swift
//  MyOutdoorAgent
//  Created by CS on 17/08/22.

import UIKit

class AnswersCell: UITableViewCell {

    // MARK: - Outlets
    @IBOutlet weak var ansView: UIView!
    @IBOutlet weak var ansLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
}
