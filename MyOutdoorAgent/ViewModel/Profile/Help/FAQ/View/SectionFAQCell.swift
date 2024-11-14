//  SectionFAQCell.swift
//  MyOutdoorAgent
//  Created by CS on 17/08/22.

import UIKit

class SectionFAQCell: UITableViewCell {

    // MARK: - Outlets
    @IBOutlet weak var sectionLbl: UILabel!
    @IBOutlet weak var sectionArrowImgV: UIImageView!
    @IBOutlet weak var sectionV: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
}
