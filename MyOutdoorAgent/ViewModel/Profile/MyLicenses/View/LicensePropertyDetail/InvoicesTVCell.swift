//  InvoicesTVCell.swift
//  MyOutdoorAgent
//  Created by CS on 14/12/22.

import UIKit

class InvoicesTVCell: UITableViewCell {

    // MARK: - Outlets
    @IBOutlet weak var invoiceTypeLbl: UILabel!
    @IBOutlet weak var amountLbl: UILabel!
    @IBOutlet weak var payView: UIView!
    @IBOutlet weak var payLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
