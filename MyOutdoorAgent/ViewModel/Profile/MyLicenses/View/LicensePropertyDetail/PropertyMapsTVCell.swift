//  PropertyMapsTVCell.swift
//  MyOutdoorAgent
//  Created by CS on 07/10/22.

import UIKit

protocol PropertyMapsTVCellDelegate : AnyObject {
    func returnPdfViewCompletion(_ agreementName: String)
}

class PropertyMapsTVCell: UITableViewCell {

    // MARK: - Objects
    weak var delegate : PropertyMapsTVCellDelegate?
    
    @IBOutlet weak var mapNameLbl: UILabel!
    @IBOutlet weak var mapView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setCellProps(_ mapsArr : [String], indexPath : Int) {
        let pdfNameStr = mapsArr[indexPath]
        if pdfNameStr.contains(" ") {
            self.delegate?.returnPdfViewCompletion((Apis.mapUrl) + pdfNameStr.replacingOccurrences(of: " ", with: "%20"))
        } else {
            self.delegate?.returnPdfViewCompletion((Apis.mapUrl) + mapsArr[indexPath])
        }
    }
}
