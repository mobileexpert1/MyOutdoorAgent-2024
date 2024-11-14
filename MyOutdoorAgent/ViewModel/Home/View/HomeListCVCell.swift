//  HomeListCVCell.swift
//  MyOutdoorAgent
//  Created by CS on 09/08/22.

import UIKit

class HomeListCVCell: UICollectionViewCell {
    
    // MARK: - Outlets
    @IBOutlet weak var viewDetailsV: UIView!
    @IBOutlet weak var displayNameLbl: UILabel!
    @IBOutlet weak var locationLbl: UILabel!
    @IBOutlet weak var regionImgV: UIImageView!
    @IBOutlet weak var regionNameHeight: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
