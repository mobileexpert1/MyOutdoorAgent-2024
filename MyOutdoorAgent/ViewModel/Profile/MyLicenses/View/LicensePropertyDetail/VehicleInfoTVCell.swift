//  VehicleInfoTVCell.swift
//  MyOutdoorAgent
//  Created by CS on 13/10/22.

import UIKit

class VehicleInfoTVCell: UITableViewCell {

    // MARK: - Outlets
    @IBOutlet weak var deleteBtn: UIImageView!
    @IBOutlet weak var makeLbl: UILabel!
    @IBOutlet weak var modelLbl: UILabel!
    @IBOutlet weak var colorLbl: UILabel!
    @IBOutlet weak var licensePlateLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
