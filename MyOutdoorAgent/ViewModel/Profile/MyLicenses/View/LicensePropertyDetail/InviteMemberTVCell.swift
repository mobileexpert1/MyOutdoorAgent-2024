//  InviteMemberTVCell.swift
//  MyOutdoorAgent
//  Created by CS on 02/11/22.

import UIKit

class InviteMemberTVCell: UITableViewCell {

    // MARK: - Outlets
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var emailLbl: UILabel!
    @IBOutlet weak var phoneLbl: UILabel!
    @IBOutlet weak var memberV: UIView!
    @IBOutlet weak var invitedV: UIView!
    @IBOutlet weak var deleteBtn: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
