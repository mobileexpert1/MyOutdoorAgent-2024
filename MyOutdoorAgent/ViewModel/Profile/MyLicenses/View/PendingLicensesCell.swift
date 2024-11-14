//  PendingLicensesCell.swift
//  MyOutdoorAgent
//  Created by CS on 07/09/22.

import UIKit

extension SearchCollVCell {
    func setView(_ cell : SearchCollVCell, _ pendingLicensesArr : [ActiveMemeberPendindCombimeModelClass], _ indexPath : IndexPath) {
        cell.titleLbl.text = pendingLicensesArr[indexPath.row].displayName
        cell.descLbl.text = (pendingLicensesArr[indexPath.row].countyName ?? "") + ", " + (pendingLicensesArr[indexPath.row].stateName ?? "")
        cell.acreLbl.text = Int((pendingLicensesArr[indexPath.row].acres)!).description
        //cell.topHeaderV.image = Images.r_pending_rlu.name
        // -- Set Top image
        pendingLicensesArr[indexPath.row].productTypeID == 1
        ? (cell.topHeaderV.image = Images.r_pending_rlu.name)
        : (cell.topHeaderV.image = Images.r_pending_permit.name)
        
        // -- Set Image
        if pendingLicensesArr[indexPath.row].imageFilename == nil {
            cell.mainImgV.image = Images.logoImg.name
        } else {
            var str = (Apis.rluImageUrl) + pendingLicensesArr[indexPath.row].imageFilename!
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
        let startDate = (cell.licenseLbl.text?.setDateFormat((pendingLicensesArr[indexPath.row].licenseStartDate!), "MMMM", "dd", ", yyyy"))!
        let endDate = ((cell.licenseLbl.text?.setDateFormat((pendingLicensesArr[indexPath.row].licenseEndDate!), "MMMM", "dd", ", yyyy"))!)
        cell.licenseLbl.text = (startDate + " to " + endDate)
        
        // -- Set Header Image
        if pendingLicensesArr[indexPath.row].productTypeID == 1 {
            UIDevice.current.userInterfaceIdiom == .pad
            ? (cell.topImgWidth.constant = 145)
            : (cell.topImgWidth.constant = 85)
        } else {
            UIDevice.current.userInterfaceIdiom == .pad
            ? (cell.topImgWidth.constant = 175)
            : (cell.topImgWidth.constant = 102)
        }
        
        // -- Set Button
        cell.mainBtn.text = ButtonText.viewDetails.text
        cell.mainBtn.textColor = .white
        cell.mainBtnView.borderColor = Colors.green.value
        
        cell.mainBtnView.actionBlock {  // -- View Details Button
            // Open License Agreement
            // -- Open Pdf
            let agreementNameStr = pendingLicensesArr[indexPath.row].agreementName
            if ((agreementNameStr?.contains(" ")) != nil) {
                self.delegate?.returnPendingViewCompletion((Apis.pdfUrl) + (agreementNameStr?.replacingOccurrences(of: " ", with: "%20") ?? ""), pendingLicensesArr[indexPath.row].licenseContractID!, LocalStore.shared.userAccountId)
            } else {
                self.delegate?.returnPendingViewCompletion((Apis.pdfUrl) + (pendingLicensesArr[indexPath.row].agreementName ?? ""), pendingLicensesArr[indexPath.row].licenseContractID!, LocalStore.shared.userAccountId)
            }
        }
        // -- Set Height according to text
        if UIDevice.current.userInterfaceIdiom == .phone {
            switch UIDevice.current.orientation {
            case .landscapeLeft, .landscapeRight:
                cell.dateHeight.constant = 15
            default: break
           //     cell.dateHeight.constant = 25
            }
        } else {
            cell.dateHeight.constant = 15
        }
    }
}
