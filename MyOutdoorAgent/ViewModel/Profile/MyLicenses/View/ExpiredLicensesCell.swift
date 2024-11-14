//  ExpiredLicensesCell.swift
//  MyOutdoorAgent
//  Created by CS on 07/09/22.

import UIKit

class ExpiredLicensesCell {
    func setView(_ cell : SearchCollVCell, _ expiredLicensesArr : [ExpiredLicensesModelClass], _ indexPath : IndexPath) {
        cell.titleLbl.text = expiredLicensesArr[indexPath.row].displayName
        cell.descLbl.text = (expiredLicensesArr[indexPath.row].countyName)! + ", " + (expiredLicensesArr[indexPath.row].stateName)!
        cell.acreLbl.text = Int((expiredLicensesArr[indexPath.row].acres)!).description
        
        // -- Set Top image
        expiredLicensesArr[indexPath.row].productTypeID == 1
        ? (cell.topHeaderV.image = Images.r_expired_rlu.name)
        : (cell.topHeaderV.image = Images.r_expired_permit.name)
        
        // -- Set Image
        if expiredLicensesArr[indexPath.row].imageFilename == nil {
            cell.mainImgV.image = Images.logoImg.name
        } else {
            var str = (Apis.rluImageUrl) + expiredLicensesArr[indexPath.row].imageFilename!
            if let dotRange = str.range(of: "?") {
                str.removeSubrange(dotRange.lowerBound..<str.endIndex)
                
                str.contains(" ")
                ? cell.mainImgV.setNetworkImage(cell.mainImgV, str.replacingOccurrences(of: " ", with: "%20"))
                : cell.mainImgV.setNetworkImage(cell.mainImgV, str)
                
            } else {
                str.contains(" ")
                ? cell.mainImgV.setNetworkImage(cell.mainImgV, str.replacingOccurrences(of: " ", with: "%20"))
                : cell.mainImgV.setNetworkImage(cell.mainImgV, str)
            }
        }
        
        // -- Set Date
        let startDate = (cell.licenseLbl.text?.setDateFormat((expiredLicensesArr[indexPath.row].licenseStartDate!), "MMMM", "dd", ", yyyy"))!
        let endDate = ((cell.licenseLbl.text?.setDateFormat((expiredLicensesArr[indexPath.row].licenseEndDate!), "MMMM", "dd", ", yyyy"))!)
        cell.licenseLbl.text = (startDate + " to " + endDate)
        
        // -- Set Header Image
        if expiredLicensesArr[indexPath.row].productTypeID == 1 {
            UIDevice.current.userInterfaceIdiom == .pad
            ? (cell.topImgWidth.constant = 145)
            : (cell.topImgWidth.constant = 80)
        } else {
            UIDevice.current.userInterfaceIdiom == .pad
            ? (cell.topImgWidth.constant = 175)
            : (cell.topImgWidth.constant = 102)
        }
        
        // -- Set Button
        setBtnView(cell)
        
        // -- Set Height according to text
        if UIDevice.current.userInterfaceIdiom == .phone {
            switch UIDevice.current.orientation {
            case .landscapeLeft, .landscapeRight:
                cell.dateHeight.constant = 15
            default: break
               // cell.dateHeight.constant = 25
            }
        } else {
            cell.dateHeight.constant = 15
        }
    }
    
    private func setBtnView(_ cell : SearchCollVCell) {
        cell.mainBtn.text = ButtonText.expired.text
        cell.mainBtn.textColor = .white
        cell.mainBtnView.isUserInteractionEnabled = false
        cell.mainBtnView.borderColor = .darkGray
    }
}
