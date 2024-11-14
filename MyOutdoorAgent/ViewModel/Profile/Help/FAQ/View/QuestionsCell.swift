//  QuestionsCell.swift
//  MyOutdoorAgent
//  Created by CS on 17/08/22.

import UIKit

class QuestionsCell: UITableViewCell {

    // MARK: - Outlets
    @IBOutlet weak var quesView: UIView!
    @IBOutlet weak var quesLbl: UILabel!
    @IBOutlet weak var quesArrowImgV: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
}
