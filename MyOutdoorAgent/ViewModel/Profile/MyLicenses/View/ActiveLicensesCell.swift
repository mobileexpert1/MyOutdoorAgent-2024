//  ActiveLicensesCell.swift
//  MyOutdoorAgent
//  Created by CS on 07/09/22.

import UIKit

extension SearchCollVCell {
    func setViews(_ cell : SearchCollVCell, _ activeLicensesArr : [ActiveMemeberPendindCombimeModelClass], _ indexPath : IndexPath) {
        cell.titleLbl.text = activeLicensesArr[indexPath.row].displayName
        cell.descLbl.text = (activeLicensesArr[indexPath.row].countyName ?? "") + ", " + (activeLicensesArr[indexPath.row].stateName ?? "")
        cell.acreLbl.text = Int((activeLicensesArr[indexPath.row].acres)!).description
//        if activeLicensesArr[indexPath.row].contractStatus == "Active" {
//            cell.topHeaderV.image = Images.g_active_rlu.name
//        } else  {
//            cell.topHeaderV.image = Images.g_future_rlu.name
//        }
        // -- Set Top image
        // -- If contract status is active then show pending or active licenses else show future licenses-
        if activeLicensesArr[indexPath.row].contractStatus == CommonKeys.active.name {
            // -- If licenseStatus is pending then show pending licenses else show active licenses
            if activeLicensesArr[indexPath.row].licenseStatus == CommonKeys.pending.name {
                activeLicensesArr[indexPath.row].productTypeID == 1
                ? (cell.topHeaderV.image = Images.g_pending_rlu.name)
                : (cell.topHeaderV.image = Images.g_pending_permit.name)
            } else {
                activeLicensesArr[indexPath.row].productTypeID == 1
                ? (cell.topHeaderV.image = Images.g_active_rlu.name)
                : (cell.topHeaderV.image = Images.g_active_permit.name)
            }
        } else {
            if activeLicensesArr[indexPath.row].licenseStatus == CommonKeys.pending.name {
                activeLicensesArr[indexPath.row].productTypeID == 1
                ? (cell.topHeaderV.image = Images.g_pending_rlu.name)
                : (cell.topHeaderV.image = Images.g_pending_permit.name)
            } else {
                activeLicensesArr[indexPath.row].productTypeID == 1
                ? (cell.topHeaderV.image = Images.g_future_rlu.name)
                : (cell.topHeaderV.image = Images.g_future_permit.name)
            }
        }
        
        // -- Set Image
        if activeLicensesArr[indexPath.row].imageFilename == nil {
            cell.mainImgV.image = Images.logoImg.name
        } else {
            var str = (Apis.rluImageUrl) + activeLicensesArr[indexPath.row].imageFilename!
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
        if  cell.mainImgV.image == UIImage(named: "") {
            cell.mainImgV.image = Images.logoImg.name
        }
        // -- Set Date
        let startDate = (cell.licenseLbl.text?.setDateFormat((activeLicensesArr[indexPath.row].licenseStartDate!), "MMMM", "dd", ", yyyy"))!
        let endDate = ((cell.licenseLbl.text?.setDateFormat((activeLicensesArr[indexPath.row].licenseEndDate!), "MMMM", "dd", ", yyyy"))!)
        cell.licenseLbl.text = (startDate + " to " + endDate)
        
        // -- Set Button
        // -- If license status is pending
        if activeLicensesArr[indexPath.row].licenseStatus == CommonKeys.pending.name {
            // -- If license status is either renewal or mail-in-check then show accept button else processing
            if (activeLicensesArr[indexPath.row].activityType == CommonKeys.renewal.name) && (activeLicensesArr[indexPath.row].paymentType == CommonKeys.mailInCheck.name) {
                setViewProperty(cell, ButtonText.accept.text, Colors.green.value, Colors.green.value)
                cell.mainBtnView.actionBlock {  // -- Accept Button
                    // -- Open Pdf
                    let agreementNameStr = activeLicensesArr[indexPath.row].agreementName!
                    if agreementNameStr.contains(" ") {
                        self.delegate?.returnActiveViewCompletion((Apis.pdfUrl) + agreementNameStr.replacingOccurrences(of: " ", with: "%20"), activeLicensesArr[indexPath.row].licenseContractID!)
                    } else {
                        self.delegate?.returnActiveViewCompletion((Apis.pdfUrl) + activeLicensesArr[indexPath.row].agreementName!, activeLicensesArr[indexPath.row].licenseContractID!)
                    }
                }
            } else {
               // setViewProperty(cell, ButtonText.processing.text, .darkGray, .darkGray, false)
                setViewProperty(cell, ButtonText.processing.text, .darkGray, .darkGray, true)
            }
        } else {
            setViewProperty(cell, ButtonText.viewDetails.text, Colors.green.value, Colors.green.value)
            cell.mainBtnView.actionBlock {  // Licenses Details
                var data = [String: Any]()
                data["publicKey"] = activeLicensesArr[indexPath.row].publicKey
                UIApplication.visibleViewController.pushWithData(Storyboards.licensePropertyDetailView.name, Controllers.licensePropertyDetailVC.name, data)
            }
        }
        
        // -- Set Header Image
        setImageView(cell, activeLicensesArr, indexPath)
        
        // -- Set Height according to text
//        if UIDevice.current.userInterfaceIdiom == .phone {
//            switch UIDevice.current.orientation {
//            case .landscapeLeft, .landscapeRight:
//                cell.dateHeight.constant = 15
//            default:
//                cell.dateHeight.constant = 25
//            }
//        } else {
//            cell.dateHeight.constant = 15
//        }
    }
    
    func setViewProperty(_ cell : SearchCollVCell, _ lblText: String, _ lblColor: UIColor, _ viewColor: UIColor, _ enabled: Bool = true) {
        cell.mainBtn.text = lblText
        cell.mainBtn.textColor = .white
        cell.mainBtnView.borderColor = viewColor
        cell.mainBtnView.isUserInteractionEnabled = enabled
    }
    
    func setImageView(_ cell: SearchCollVCell, _ activeLicensesArr : [ActiveMemeberPendindCombimeModelClass], _ indexPath : IndexPath) {
        if activeLicensesArr[indexPath.row].contractStatus == CommonKeys.active.name {
            // -- If licenseStatus is pending then show pending licenses else show active licenses
            if activeLicensesArr[indexPath.row].licenseStatus == CommonKeys.pending.name {
                if activeLicensesArr[indexPath.row].productTypeID == 1 {   // g_pending_rlu
                    UIDevice.current.userInterfaceIdiom == .pad
                    ? (cell.topImgWidth.constant = 142)
                    : (cell.topImgWidth.constant = 83)
                } else {                                                   // g_pending_permit
                    UIDevice.current.userInterfaceIdiom == .pad
                    ? (cell.topImgWidth.constant = 168)
                    : (cell.topImgWidth.constant = 98)
                }
            } else {
                if activeLicensesArr[indexPath.row].productTypeID == 1 {   // g_active_rlu
                    UIDevice.current.userInterfaceIdiom == .pad
                    ? (cell.topImgWidth.constant = 142)
                    : (cell.topImgWidth.constant = 85)
                } else {                                                   // g_active_permit
                    UIDevice.current.userInterfaceIdiom == .pad
                    ? (cell.topImgWidth.constant = 165)
                    : (cell.topImgWidth.constant = 97)
                }
            }
        } else {
            if activeLicensesArr[indexPath.row].licenseStatus == CommonKeys.pending.name {
                if activeLicensesArr[indexPath.row].productTypeID == 1 {    // g_pending_rlu
                    UIDevice.current.userInterfaceIdiom == .pad
                    ? (cell.topImgWidth.constant = 142)
                    : (cell.topImgWidth.constant = 83)
                } else {                                                    // g_pending_permit
                    UIDevice.current.userInterfaceIdiom == .pad
                    ? (cell.topImgWidth.constant = 168)
                    : (cell.topImgWidth.constant = 98)
                }
            } else {
                if activeLicensesArr[indexPath.row].productTypeID == 1 {    // g_future_rlu
                    UIDevice.current.userInterfaceIdiom == .pad
                    ? (cell.topImgWidth.constant = 142)
                    : (cell.topImgWidth.constant = 85)
                } else {                                                    // g_future_permit
                    UIDevice.current.userInterfaceIdiom == .pad
                    ? (cell.topImgWidth.constant = 168)
                    : (cell.topImgWidth.constant = 97)
                }
            }
        }
    }
}
