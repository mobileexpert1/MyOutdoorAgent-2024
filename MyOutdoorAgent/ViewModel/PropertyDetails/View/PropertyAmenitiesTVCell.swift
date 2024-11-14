//  PropertyAmenitiesTVCell.swift
//  MyOutdoorAgent
//  Created by CS on 05/10/22.

import UIKit

class PropertyAmenitiesTVCell: UITableViewCell {

    @IBOutlet weak var amenityName: UILabel!
    @IBOutlet weak var amenityDescLbl: UILabel!
    @IBOutlet weak var amenitiesImgV: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
