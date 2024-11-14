//  PropertyViewCell.swift
//  MyOutdoorAgent
//  Created by CS on 04/10/22.

import UIKit
import MapKit
import CoreLocation
import PKHUD
import WebKit
import FSCalendar

// MARK: - UITableView DataSource
extension PropertyVC : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == self.licenseMemberV.memberTV {
            if membersArr?.count != nil {
                licenseMemberV.memberTVHeight.constant = CGFloat(5 + Int(60*membersArr!.count))
                return membersArr!.count
            }
        }
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == self.licenseMemberV.memberTV {
            let cell = configureMemberCell(tableView, indexPath)
            return cell
        } else {
            let cell = configureCell(tableView, indexPath)
            return cell
        }
    }
}

// MARK: - UITableView Delegates
extension PropertyVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if tableView == self.propertyTableV {
            if UIDevice.current.userInterfaceIdiom == .phone {
                if (UIDevice.current.orientation == .landscapeLeft) || (UIDevice.current.orientation == .landscapeRight) {
                    return 220
                } else {
                    return 220
                }
            }
            return 300
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = configureHeaderCell(tableView)
        return view
    }
}

// MARK: - ConfigureHeaderView
extension PropertyVC {
    private func configureHeaderCell(_ tableView : UITableView) -> UIView {
        let dequeCell = tableView.dequeueReusableCell(withIdentifier: CustomCells.propertyHeaderTVCell.name)
        guard let view = dequeCell as? PropertyHeaderTVCell else { return UIView() }
        setHeaderViewAction(view, tableView)
        return view
    }
    
    private func setHeaderViewAction(_ view: PropertyHeaderTVCell, _ tableView : UITableView) {
        if UIDevice.current.userInterfaceIdiom == .phone {
            if (UIDevice.current.orientation == .landscapeLeft) || (UIDevice.current.orientation == .landscapeRight) {
                view.topHeaderImgHeight.constant = 120
            } else {
                view.topHeaderImgHeight.constant = 180
            }
        } else {
            view.topHeaderImgHeight.constant = 250
        }
        
        // -- Set Day Pass
        if activityDetailArr?.activityDetail?.activityType == "Day Pass" {
            view.dayPassV.isHidden = false
        } else {
            view.dayPassV.isHidden = true
        }
        
        // -- Set Available Date
        if activityDetailArr?.activityDetailPageChecks?.showComingSoonButton == true {
            view.availableView.isHidden = false
            if (activityDetailArr?.activityDetail?.saleStartDateTime) != nil {
                view.availableLbl.text =
                "Available on: " + (view.availableLbl.text?.setDateFormat((activityDetailArr?.activityDetail?.saleStartDateTime)!, "MMMM", "dd", ", yyyy HH:mm a"))! + " " + ((activityDetailArr?.activityDetail?.timeZone)!)
                print(view.availableLbl.text)
                view.availableView.backgroundColor = UIColor(red: 28/255, green: 172/255, blue: 252/255, alpha: 1.0)
            }
        } else {
            view.availableView.isHidden = true
        }
        
        // Button Property
        if (activityDetailArr?.activityDetailPageChecks?.showComingSoonButton == true) {
            view.selectBtnText.text = "Coming Soon"
            view.selectView.backgroundColor = UIColor(red: 217/255, green: 45/255, blue: 59/255, alpha: 1.0)
        }
        
        if ((activityDetailArr?.activityDetailPageChecks?.isPreApprovalRequested) == true &&
            activityDetailArr?.activityDetailPageChecks?.preApprovalStatus == "Requested") {
            view.selectBtnText.text = "Cancel Request"
            view.selectView.backgroundColor = Colors.bgGreenColor.value
        }
        
        if (activityDetailArr?.activityDetailPageChecks?.showPreApprovalRequestButton) == true {
            view.selectBtnText.text = "Request Pre-Approval"
            view.selectView.backgroundColor = Colors.bgGreenColor.value
        }
        
        if (activityDetailArr?.activityDetailPageChecks?.showRenewButton) == true {
            view.selectBtnText.text = "Renew License"
            view.selectView.backgroundColor = Colors.bgGreenColor.value
        }
        
        if (activityDetailArr?.activityDetailPageChecks?.showAlreadyPurchasedButton) == true {
            view.selectBtnText.text = "Already Purchased"
            view.selectView.backgroundColor = UIColor(red: 117/255, green: 165/255, blue: 45/255, alpha: 1)
        }
        
        if (activityDetailArr?.activityDetailPageChecks?.showSoldOutButton) == true {
            view.selectBtnText.text = "Sold Out"
            view.selectView.backgroundColor = UIColor(red: 217/255, green: 45/255, blue: 59/255, alpha: 1.0)
        }
        
        if (((activityDetailArr?.activityDetailPageChecks?.showLicenseNowButton) == true &&
             activityDetailArr?.activityDetail?.activityType != "Day Pass")) || ((activityDetailArr?.activityDetailPageChecks?.preApprovalStatus == "Accepted")){
            view.selectBtnText.text = "Select"
            view.selectView.backgroundColor = Colors.bgGreenColor.value
            
            view.selectView.actionBlock {
                if view.selectBtnText.text == "Select" {
                    print("LocalStore.shared.userId------",LocalStore.shared.userId)
                    if LocalStore.shared.userId == EMPTY_STR {
                        self.loginAlert()
                    } else {
                        self.paymentPdf()
                    }
                }
            }
        } else if (activityDetailArr?.activityDetail?.activityType == "Day Pass") {
            view.selectBtnText.text = "Select"
            view.selectView.backgroundColor = Colors.bgGreenColor.value
            
            view.selectView.actionBlock {
                if LocalStore.shared.userId == EMPTY_STR {
                    self.loginAlert()
                } else {
                    self.setDayPassPopUp()
                }
            }
        } else {
            view.selectView.actionBlock {
                if LocalStore.shared.userId == EMPTY_STR {
                    self.loginAlert()
                } else {
                    if view.selectBtnText.text == "Cancel Request" {
                        let btns = [ButtonText.yes.text, ButtonText.no.text]
                        UIAlertController.showAlert(AppAlerts.cancelReq.title, message: AppAlerts.cancelRequest.title + " " + (self.activityDetailArr?.activityDetail?.displayName)! + " ?", buttons: btns) { alert, index in
                            if index == 0 {
                                ApiStore.shared.cancelPreApprovalReqApi(self.view, cancelReqId: (self.activityDetailArr?.activityDetailPageChecks?.preApprRequestID)!) { responseModel in
                                    print(responseModel)
                                    if responseModel.statusCode == 200 {
                                        DispatchQueue.main.async {
                                            HUD.hide()
                                            view.selectBtnText.text = "Request Pre-Approval"
                                        }
                                    } else {
                                        HUD.flash(.labeledError(title: EMPTY_STR, subtitle: responseModel.message!), delay: 1.0)
                                    }
                                }
                            }
                        }
                    } else if view.selectBtnText.text == "Request Pre-Approval" {
                        self.viewTransition(self.preApprovalPopUpView)
                        self.preApprovalPopUpView.textV.text = LocalStore.shared.name + " " + "is requesting Pre-Approval"
                        
                        // Submit
                        self.preApprovalPopUpView.submitV.actionBlock {
                            // Submit Api
                            self.propertyViewModelArr?.submitPreApprovalReqApi(self.view, LocalStore.shared.userAccountId, (self.activityDetailArr?.activityDetail?.licenseActivityID)!, requestComment: self.preApprovalPopUpView.textV.text!, (self.activityDetailArr?.activityDetail?.productID)!, completion: { reponseModel in
                                view.selectBtnText.text = "Cancel Request"
                            })
                        }
                        
                        // Cancel
                        self.preApprovalPopUpView.cancelV.actionBlock {
                            self.removeView(self.preApprovalPopUpView)
                        }
                    } else if view.selectBtnText.text == "Renew License" {
                        /*
                         Show PDF screen only if ClientSite = 'moa'
                         Show 2nd & 3rd screen (Members & PDF) if ClientSite = 'custom', DeerHarvestInfo= false & ActivityType='Renewal'
                         Show all 3 screens if ClientSite = 'custom', DeerHarvestInfo= true & ActivityType='Renewal'
                         */
                        if self.activityDetailArr?.clientDetails?.clientSite == "moa" {
                            self.paymentPdf()
                        } else if (self.activityDetailArr?.clientDetails?.clientSite == "custom") && (self.activityDetailArr?.clientDetails?.deerHarvestInfo == false) && (self.activityDetailArr?.activityDetail?.activityType == "Renewal") {
                            self.viewTransition(self.licenseMemberV)
                            self.setRenewMemberV()
                        } else if (self.activityDetailArr?.clientDetails?.clientSite == "custom") && (self.activityDetailArr?.clientDetails?.deerHarvestInfo == true) && (self.activityDetailArr?.activityDetail?.activityType == "Renewal") {
                            self.viewTransition(self.licenseRenewalPopUpV)
                            
                            self.licenseRenewalPopUpV.saveAndContinueBtn.actionBlock {
                                if self.licenseRenewalPopUpV.buckTxtF.text!.isEmpty || self.licenseRenewalPopUpV.doeTxtF.text!.isEmpty || self.licenseRenewalPopUpV.turkeyTxtF.text!.isEmpty || self.licenseRenewalPopUpV.hogTxtF.text!.isEmpty {
                                    let btn = [ButtonText.ok.text]
                                    UIAlertController.showAlert(AppAlerts.alert.title, message: AppErrors.allFieldsReq.localizedDescription, buttons: btn, completion: nil)
                                } else {
                                    self.propertyViewModelArr?.addHarvestingApi(self.view, 2021, self.licenseRenewalPopUpV.buckTxtF.text!, self.licenseRenewalPopUpV.doeTxtF.text!, self.licenseRenewalPopUpV.turkeyTxtF.text!, self.licenseRenewalPopUpV.hogTxtF.text!, (self.activityDetailArr?.activityDetail?.productID)!, completion: { responseModel in
                                        print(responseModel)
                                        
                                        DispatchQueue.main.async {
                                            self.removeView(self.licenseRenewalPopUpV)
                                            self.viewTransition(self.licenseMemberV)
                                            self.setRenewMemberV()
                                        }
                                        
                                    })
                                }
                            }
                            
                            self.licenseRenewalPopUpV.cancelBtn.actionBlock {
                                self.removeView(self.licenseRenewalPopUpV)
                                self.setLicenseRenewV()
                            }
                        }
                    }
                }
            }
        }
    }
    
    private func setLicenseRenewV() {
        let txtFieldArr = [self.licenseRenewalPopUpV.buckTxtF, self.licenseRenewalPopUpV.doeTxtF, self.licenseRenewalPopUpV.turkeyTxtF, self.licenseRenewalPopUpV.hogTxtF]
        txtFieldArr.forEach { textFields in
            textFields?.text = EMPTY_STR
        }
    }
    
    private func setRenewMemberV() {
        if (self.activityDetailArr?.members != nil) {
            self.licenseMemberV.memberDetailV.isHidden = false
            self.licenseMemberV.memberTV.register(UINib(nibName: CustomCells.renewalMemberTVCell.name, bundle: nil), forCellReuseIdentifier: CustomCells.renewalMemberTVCell.name)
            self.licenseMemberV.memberTV.delegate = self
            self.licenseMemberV.memberTV.dataSource = self
            self.licenseMemberV.memberTV.reloadData()
            self.propertyTableV.reloadData()
        } else {
            self.licenseMemberV.memberDetailV.isHidden = true
        }
        
        self.licenseMemberV.saveBtn.actionBlock {
            self.paymentPdf()
        }
        
        self.licenseMemberV.cancelBtn.actionBlock {
            self.removeView(self.licenseMemberV)
            self.removeView(self.licenseRenewalPopUpV)
            self.setLicenseRenewV()
        }
    }
    
    func paymentPdf() {
        if self.activityDetailArr?.activityDetailPageChecks?.isUserProfileComplete == true {
            // Show PDf View then after accept and pay, hit payment token api
            if self.activityDetailArr?.clientDetails?.clientSite != "moa" {
                self.viewTransition(self.paymentPdfPopUpView)
                self.propertyViewModelArr?.generateLicenseContractApi(self.view, (self.activityDetailArr?.activityDetail?.licenseActivityID)!, completion: { responseModel in
                    self.viewTransition(self.paymentPdfPopUpView)
                    let pdfNameStr = responseModel.message
                    if ((pdfNameStr?.contains(" ")) != nil) {
                        self.showActiveWebView((Apis.licensePdfUrl) + pdfNameStr!.replacingOccurrences(of: " ", with: "%20"))
                    } else {
                        self.showActiveWebView((Apis.licensePdfUrl) + responseModel.message!)
                    }
                })
            } else {
                // -- Open Pdf
                self.viewTransition(self.paymentPdfPopUpView)
                
                if (self.activityDetailArr?.activityDetail?.agreementName) != nil {
                    let agreementNameStr = self.activityDetailArr?.activityDetail?.agreementName!
                    if agreementNameStr!.contains(" ") {
                        self.showActiveWebView(Apis.pdfUrl + "Assets/Agreements/" + agreementNameStr!.replacingOccurrences(of: " ", with: "%20"))
                    } else {
                        self.showActiveWebView(Apis.pdfUrl + "Assets/Agreements/" + (self.activityDetailArr?.activityDetail?.agreementName!)!)
                    }
                } else {
                    self.showActiveWebView(Apis.pdfUrl + "Assets/Agreements/" + (self.activityDetailArr?.activityDetail?.agreementName ?? ""))
                }
            }
        } else {
            let okBtn = [ButtonText.ok.text]
            UIAlertController.showAlert(AppAlerts.editProfile.title, message: AppErrors.editProfile.localizedDescription, buttons: okBtn, completion: nil)
        }
    }
    
    func showActiveWebView(_ agreementName: String) {
        webView = WKWebView(frame: self.paymentPdfPopUpView.pdfView.bounds, configuration: WKWebViewConfiguration())
        webView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        webView.uiDelegate = self
        webView.navigationDelegate = self
        paymentPdfPopUpView.pdfView.addSubview(self.webView)
        webView.allowsBackForwardNavigationGestures = true
        let myURL = URL(string: agreementName)
        let myRequest = URLRequest(url: myURL!)
        webView.load(myRequest)
        
        // Accpet And Pay Button
        self.paymentPdfPopUpView.acceptAndPayView.actionBlock {
            // Payment Api hit returnUrl: "https://demov2.myoutdooragent.com/property?id=lsa_ps4r2pks"
            self.propertyViewModelArr?.getPaymentTokenApi(self.view,
                                                          requestType: MOA,
                                                          rluNo: ((self.activityDetailArr?.activityDetail?.displayName ?? EMPTY_STR) + ""),
                                                          fundAccountKey: "acct_1GaRZZLWZ7bSejfX",
                                                          clientInvoiceId: (self.activityDetailArr?.activityDetail?.licenseActivityID ?? 0),
                                                          userAccountId: LocalStore.shared.userAccountId,
                                                          email: LocalStore.shared.email,
                                                          licenseFee: Float((self.activityDetailArr?.activityDetail?.licenseFee ?? 0)),
                                                          paidBy: LocalStore.shared.name,
                                                          cancelUrl: "https://demov2.myoutdooragent.com/property?id="+((self.activityDetailArr?.activityDetail?.publicKey)!)+"&PaymentStatus=fail",
                                                          errorUrl: "https://demov2.myoutdooragent.com/property?id="+((self.activityDetailArr?.activityDetail?.publicKey)!)+"&Error=fail",
                                                          productTypeId: (self.activityDetailArr?.activityDetail?.productTypeID ?? 0),
                                                          returnUrl: "https://demov2.myoutdooragent.com/property?id="+((self.activityDetailArr?.activityDetail?.publicKey)!),
                                                          productID: (self.activityDetailArr?.activityDetail?.productID ?? 0), invoiceTypeID: 0,
                                                          completion: { responseModel in
                print("responseModel.message",responseModel.message)
                if responseModel.message == AppErrors.paymentError.localizedDescription {
                    HUD.hide()
                    let okBtn = [ButtonText.ok.text]
                    UIAlertController.showAlert(AppAlerts.alert.title, message: AppErrors.paymentError.localizedDescription, buttons: okBtn) { alert, index in
                        if index == 0 {
                            self.removeView(self.paymentPdfPopUpView)
                        }
                    }
                } else {
                    let data1 = self.dataFromLastVC as! [String:Any]
                    let publicKey = data1["publicKey"] as? String
                    let preSaleToken = data1["preSaleToken"] as? String
                    
                    var data = [String: Any]()
                    data["token"] = responseModel.model?.response?.paymentToken
                    data["publicKey"] = publicKey
                    data["preSaleToken"] = preSaleToken
                    self.pushWithData(Storyboards.paymentView.name, Controllers.paymentVC.name, data)
                }
            })
        }
//        {
//            // Payment Api hitcancelUrl: "https://demov2.myoutdooragent.com/property?id=lsa_ps4r2pks&PaymentStatus=fail"
//            self.propertyViewModelArr?.getPaymentTokenApi(self.view,
//                                                          requestType: MOA,
//                                                          rluNo: ((self.activityDetailArr?.activityDetail?.displayName ?? EMPTY_STR) + ""),
//                                                          fundAccountKey: "acct_1GaRZZLWZ7bSejfX",
//                                                          clientInvoiceId: (self.activityDetailArr?.activityDetail?.licenseActivityID ?? 0),
//                                                          userAccountId: LocalStore.shared.userAccountId,
//                                                          email: LocalStore.shared.email,
//                                                          licenseFee: Float((self.activityDetailArr?.activityDetail?.licenseFee ?? 0)),
//                                                          paidBy: LocalStore.shared.name,
//                                                          cancelUrl: "https://myoutdooragent.com/#/app/property?id="+((self.activityDetailArr?.activityDetail?.publicKey)!)+"&PaymentStatus=fail",
//                                                          errorUrl: "https://myoutdooragent.com/#/app/property?id="+((self.activityDetailArr?.activityDetail?.publicKey)!)+"&Error=fail",
//                                                          productTypeId: (self.activityDetailArr?.activityDetail?.productTypeID ?? 0),
//                                                          returnUrl: "https://myoutdooragent.com/",
//                                                          productID: (self.activityDetailArr?.activityDetail?.productID ?? 0), invoiceTypeID: 0,
//                                                          completion: { responseModel in
//                print("responseModel.message",responseModel.message)
//                if responseModel.message == AppErrors.paymentError.localizedDescription {
//                    HUD.hide()
//                    let okBtn = [ButtonText.ok.text]
//                    UIAlertController.showAlert(AppAlerts.alert.title, message: AppErrors.paymentError.localizedDescription, buttons: okBtn) { alert, index in
//                        if index == 0 {
//                            self.removeView(self.paymentPdfPopUpView)
//                        }
//                    }
//                } else {
//                    let data1 = self.dataFromLastVC as! [String:Any]
//                    let publicKey = data1["publicKey"] as? String
//                    let preSaleToken = data1["preSaleToken"] as? String
//                    
//                    var data = [String: Any]()
//                    data["token"] = responseModel.model?.response?.paymentToken
//                    data["publicKey"] = publicKey
//                    data["preSaleToken"] = preSaleToken
//                    self.pushWithData(Storyboards.paymentView.name, Controllers.paymentVC.name, data)
//                }
//            })
//        }
        // Cross Button
        self.paymentPdfPopUpView.crossBtn.actionBlock {
            self.removeView(self.paymentPdfPopUpView)
            self.removeView(self.licenseMemberV)
            self.removeView(self.licenseRenewalPopUpV)
            self.setLicenseRenewV()
        }
    }
}

// MARK: - ConfigureCell
extension PropertyVC {
    private func configureCell(_ tableView : UITableView, _ indexPath : IndexPath) -> UITableViewCell {
        let dequeCell = tableView.dequeueReusableCell(withIdentifier: CustomCells.propertyTVCell.name, for: indexPath)
        guard let cell = dequeCell as? PropertyTVCell else { return UITableViewCell() }
        setViewAction(cell, indexPath)
        return cell
    }
    
    private func configureMemberCell(_ tableView : UITableView, _ indexPath : IndexPath) -> UITableViewCell {
        let dequeCell = tableView.dequeueReusableCell(withIdentifier: CustomCells.renewalMemberTVCell.name, for: indexPath)
        guard let cell = dequeCell as? RenewalMemberTVCell else { return UITableViewCell() }
        setMemberViewAction(cell, indexPath)
        return cell
    }
    
    private func setMemberViewAction(_ cell: RenewalMemberTVCell, _ indexPath: IndexPath) {
        //        if (membersArr?[indexPath.row].firstName != nil) || (membersArr?[indexPath.row].lastName != nil) {
        //            cell.nameLbl.text = (membersArr?[indexPath.row].firstName!)! + " " + (membersArr?[indexPath.row].lastName!)!
        //        }
        //        if (membersArr?[indexPath.row].email != nil) {
        //            cell.emailLbl.text = membersArr?[indexPath.row].email!
        //        }
        //        if (membersArr?[indexPath.row].phone != nil) {
        //            cell.phoneLbl.text = membersArr?[indexPath.row].phone?.toPhoneNumber()
        //        }
    }
    
    private func setViewAction(_ cell: PropertyTVCell, _ indexPath: IndexPath) {
        // Set MapView View
        //        HUD.show(.progress, onView: UIApplication.visibleViewController.view)
        //       // cell.mapView.delegate = self
        //        cell.mapView.settings.compassButton = true
        //        cell.mapView.settings.allowScrollGesturesDuringRotateOrZoom = true
        //        cell.mapView.settings.rotateGestures = true
        //        cell.mapView.settings.scrollGestures = true
        //        cell.mapView.settings.zoomGestures = true
        //        cell.mapView.setMinZoom(3, maxZoom: 16)
        //
        //        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
        //            self.propertyCell.setClusterMap()
        //        }
        
        // Set Address and price
        cell.propertyAddressLbl.text = activityDetailArr?.activityDetail?.displayName
        print("activityDetailArr?.activityDetail?.licenseFee------------->>>>>",activityDetailArr?.activityDetail?.licenseFee)
        if (activityDetailArr?.activityDetail?.licenseFee != nil) {
            let licenseFeeStr = activityDetailArr?.activityDetail?.licenseFee
            //   cell.propertyPriceLbl.text = "$" + String(format: "%.2f", licenseFeeStr!)
            cell.propertyPriceLbl.text = "$" + formatIntToTwoDecimalPlaces(Double(licenseFeeStr ?? 0.0))
        }
        
        // Property Details
        if (activityDetailArr?.activityDetail?.countyName != nil) && (activityDetailArr?.activityDetail?.state != nil) {
            cell.detailAddressLbl.text = ((activityDetailArr?.activityDetail?.countyName)!) + " County, "  + ((activityDetailArr?.activityDetail?.state)!)
        }
        cell.propertyId.text = activityDetailArr?.activityDetail?.productNo
        if activityDetailArr?.activityDetail?.licenseFee != nil {
            let licenseFeeStr = activityDetailArr?.activityDetail?.licenseFee
            //  cell.priceLbl.text = "$" + String(format: "%.2f", licenseFeeStr!)
                cell.priceLbl.text = "$" + formatIntToTwoDecimalPlaces(Double(licenseFeeStr ?? 0.0))
        }
        
        if (activityDetailArr?.activityDetail?.acres != nil) {
            let acresStr = activityDetailArr?.activityDetail?.acres
            cell.AcresLbl.text = String(format: "%.2f", acresStr!)
        }
        
        if (activityDetailArr?.activityDetail?.licenseStartDate != nil) && (activityDetailArr?.activityDetail?.licenseEndDate != nil) {
            cell.licenseStartDateLbl.text = cell.licenseStartDateLbl.text?.setDateFormat((activityDetailArr?.activityDetail?.licenseStartDate)!, "MMMM", "dd", ", yyyy")
            cell.licenseEndDateLbl.text = cell.licenseEndDateLbl.text?.setDateFormat((activityDetailArr?.activityDetail?.licenseEndDate)!, "MMMM", "dd", ", yyyy")
        }
        
        // Description
        if (activityDetailArr?.activityDetail?.displayDescription) == nil {
            cell.noDescLbl.isHidden = false
        } else {
            cell.noDescLbl.isHidden = true
            cell.descriptionLbl.text = activityDetailArr?.activityDetail?.displayDescription
        }
        func requestTemporary() {
            var entriesArr : [UITextField]!
            entriesArr = [self.reqTempAccessPopV.firstnameTxtF, self.reqTempAccessPopV.secondnameTxtF,
                          self.reqTempAccessPopV.thirdnameTxtF, self.reqTempAccessPopV.forthnameTxtF,
                          self.reqTempAccessPopV.fifthnameTxtF]
            
            var entries = [String]()
            for field in entriesArr where !field.text!.isEmpty {
                entries.append(field.text!)
            }
            let entriesStr = entries.joined(separator: ",")
            
            self.propertyViewModelArr?.rightOfEntryFormApi(self.view, (self.activityDetailArr?.activityDetail?.productID)!, self.reqTempAccessPopV.selectDateTxtF.text!, entriesStr, completion: { responseModel in
                print(responseModel)
                
                
            })
        }
        // Request Temproray Access View
        cell.requestTempAccessV.actionBlock {
            if LocalStore.shared.userId == EMPTY_STR {
                self.loginAlert()
            } else {
                self.viewTransition(self.reqTempAccessPopV)
                
                self.reqTempAccessPopV.selectDateTxtF.setDatePicker()
                
                // Submit Button
                self.reqTempAccessPopV.submitView.actionBlock {
                    if self.reqTempAccessPopV.selectDateTxtF.text?.isEmpty == true {
                        let okBtn = [ButtonText.ok.text]
                        UIAlertController.showAlert(AppAlerts.alert.title, message: AppErrors.selectDate.localizedDescription, buttons: okBtn, completion: nil)
                    }
                    
                    //    textField.text.isEmpty
                    
                    else {
                        if self.reqTempAccessPopV.firstnameTxtF.text?.isEmpty == true  {
                            if self.reqTempAccessPopV.secondnameTxtF.text?.isEmpty == true {
                                if self.reqTempAccessPopV.forthnameTxtF.text?.isEmpty == true {
                                    if self.reqTempAccessPopV.thirdnameTxtF.text?.isEmpty == true {
                                        if self.reqTempAccessPopV.fifthnameTxtF.text?.isEmpty == true {
                                            
                                            let okBtn = [ButtonText.ok.text]
                                            UIAlertController.showAlert(AppAlerts.alert.title, message: "Enter at least one name", buttons: okBtn, completion: nil)
                                            
                                        }
                                    }
                                }
                            }
                        }
                        
                        else {
                            requestTemporary()
                        }
                        
                    }
                }
                
                // Cancel Button
                self.reqTempAccessPopV.cancelView.actionBlock {
                    self.removeView(self.reqTempAccessPopV)
                    self.reqTempAccessPopV.selectDateTxtF.text = EMPTY_STR
                    var entriesArr : [UITextField]!
                    entriesArr = [self.reqTempAccessPopV.firstnameTxtF, self.reqTempAccessPopV.secondnameTxtF,
                                  self.reqTempAccessPopV.thirdnameTxtF, self.reqTempAccessPopV.forthnameTxtF,
                                  self.reqTempAccessPopV.fifthnameTxtF]
                    for field in entriesArr where !field.text!.isEmpty {
                        field.text = EMPTY_STR
                    }
                }
            }
        }
        
        cell.descriptionLbl.addInterlineSpacing(spacingValue: 2.5)
        
        // -- Contact The Property Agent
        if (activityDetailArr?.activityDetail?.phone) != nil {
            let phone = (activityDetailArr?.activityDetail?.phone)!.toPhoneNumber()
            cell.contactLbl.text = phone
            cell.contactLbl.actionBlock {
                self.callNumber(phoneNumber: (self.activityDetailArr?.activityDetail?.phone)!)
            }
        } else {
            cell.contactLbl.text = "----"
        }
        
        // -- Leave us message Button
        cell.leaveMsgBtn.actionBlock {
            if LocalStore.shared.userId == EMPTY_STR {
                self.loginAlert()
            } else {
                self.viewTransition(self.messagePopUpView)
                
                // -- Submit Button
                self.messagePopUpView.submitBtn.actionBlock {
                    
                    if self.messagePopUpView.msgTxtV.text != "" {
                        self.propertyViewModelArr?.sendMessageApi(self.view, (self.activityDetailArr?.activityDetail?.productID)!, self.messagePopUpView.msgTxtV.text!, completion: { responseModel in
                            
                            UIAlertController.showAlert(AppAlerts.success.title, message: (AppAlerts.messageSuccess.title), buttons: self.btn) { alert, index in
                                if index == 0 {
                                    
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                                        self.removeView(self.messagePopUpView)
                                        self.messagePopUpView.msgTxtV.text = EMPTY_STR
                                    }
                                    
                                }
                            }
                            
                        })
                    } else {
                        UIAlertController.showAlert(AppAlerts.alert.title, message: (AppErrors.enterMessage.localizedDescription), buttons: self.btn) { alert, index in
                            if index == 0 {
                            }
                        }
                    }
                    
                }
                // -- Cancel Button
                self.messagePopUpView.cancelBtn.actionBlock {
                    self.removeView(self.messagePopUpView)
                }
            }
        }
    }
}

// MARK: - WKNavigationDelegate
extension PropertyVC : WKNavigationDelegate {
    internal func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        self.paymentPdfPopUpView.activityIndicatorV.startAnimating()
    }
    
    internal func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        self.paymentPdfPopUpView.activityIndicatorV.stopAnimating()
        self.paymentPdfPopUpView.activityIndicatorV.hidesWhenStopped = true
    }
    
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        self.paymentPdfPopUpView.activityIndicatorV.startAnimating()
    }
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        let btns = [ButtonText.ok.text]
        UIAlertController.showAlert(AppAlerts.alert.title, message: AppErrors.internetIssue.localizedDescription, buttons: btns) { alert, index in
            if index == 0 {
                self.removeView(self.paymentPdfPopUpView)
            }
        }
    }
}

// MARK: - DayPass Availability
extension PropertyVC {
    
    // Date to String
    func stringFromDate1(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.locale = NSLocale(localeIdentifier: "en_EN") as Locale
        return dateFormatter.string(from: date)
    }
    
    func setDayPassPopUp() {
        // Clear dates
        var tempDateArr = [Date]()
        self.selectedDates.forEach { date in
            tempDateArr.append(dateFromString(dateStr: date))
        }
        tempDateArr.forEach { date in
            self.dayPassFunctionalityPopUpV.calendarV.deselect(date)
        }
        tempDateArr.removeAll()
        self.selectedDates.removeAll()
        
        self.dayPassFunctionalityPopUpV.title.text = String(1)
        self.numberOfSelectedDays = 1
        self.viewTransition(self.dayPassFunctionalityPopUpV)
        
        // Set Calendar
        self.dayPassFunctionalityPopUpV.calendarV.delegate = self
        self.dayPassFunctionalityPopUpV.calendarV.dataSource = self
        self.dayPassFunctionalityPopUpV.calendarV.allowsMultipleSelection = true
        self.dayPassFunctionalityPopUpV.calendarV.today = nil
        self.dayPassFunctionalityPopUpV.calendarV.select(Date())
        self.selectedDates.append(self.stringFromDate(date: Date()))
        
        // -- Set Minus Button
        self.dayPassFunctionalityPopUpV.minusBtn.actionBlock {
            if Int(self.dayPassFunctionalityPopUpV.title.text!)! > 1 {
                
                self.numberOfSelectedDays -= 1
                self.dayPassFunctionalityPopUpV.title.text = String(self.numberOfSelectedDays)
                
                if let maxDate = self.selectedDates.max() {
                    self.selectedDates.remove(at: self.selectedDates.firstIndex(of: maxDate)!)
                    self.dayPassFunctionalityPopUpV.calendarV.deselect(self.dateFromString(dateStr: maxDate))
                }
            }
        }
        
        // -- Set Plus Button
        self.dayPassFunctionalityPopUpV.plusBtn.actionBlock {
            if Int(self.dayPassFunctionalityPopUpV.title.text!)! >= 0 {
                if self.selectedDates.count != 0 {
                    if let maxDate = self.selectedDates.max() {
                        self.numberOfSelectedDays += 1
                        self.dayPassFunctionalityPopUpV.title.text = String(self.numberOfSelectedDays)
                        
                        let modifiedDate = Calendar.current.date(byAdding: .day, value: 1, to: self.dateFromString(dateStr: maxDate))!
                        self.currentSelectedDate = modifiedDate
                        self.dayPassFunctionalityPopUpV.calendarV.select(self.currentSelectedDate)
                        
                        let dateString = self.stringFromDate(date: self.currentSelectedDate)
                        self.selectedDates.append(dateString)
                    }
                } else {
                    self.numberOfSelectedDays += 1
                    self.dayPassFunctionalityPopUpV.title.text = String(self.numberOfSelectedDays)
                    self.currentSelectedDate = Date()
                    self.dayPassFunctionalityPopUpV.calendarV.select(self.currentSelectedDate)
                    
                    let dateString = self.stringFromDate(date: self.currentSelectedDate)
                    self.selectedDates.append(dateString)
                }
            }
        }
        
        // -- Availability Button
        self.dayPassFunctionalityPopUpV.checkAvailabilityBtn.actionBlock {
            if self.dayPassFunctionalityPopUpV.title.text == String(0) {
                UIAlertController.showAlert(AppAlerts.alert.title, message: "Please select any date first", buttons: ["Ok"], completion: nil)
            } else {
                if let minDate = self.selectedDates.min() {
                    self.propertyViewModelArr?.dayPassAvailabilityApi(self.view, (self.activityDetailArr?.activityDetail?.licenseActivityID)!, minDate, Int(self.dayPassFunctionalityPopUpV.title.text!)!, completion: { responseModel in
                        print(responseModel)
                    })
                }
            }
        }
        
        // -- Cancel Button
        self.dayPassFunctionalityPopUpV.cancelBtn.actionBlock {
            self.removeView(self.dayPassFunctionalityPopUpV)
        }
    }
}

// MARK: - FSCalendar Delegate and Datasource
extension PropertyVC: FSCalendarDelegate, FSCalendarDataSource, FSCalendarDelegateAppearance {
    
    func minimumDate(for calendar: FSCalendar) -> Date {
        return Date()
    }
    
    //    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, titleDefaultColorFor date: Date) -> UIColor? {
    //        let dateString = self.dateFormatter.string(from: date as Date)
    //        print(dateString)
    //        print(date)
    //        print("====-=")
    //        //Remove timeStamp from date
    //        if date.compare(Date()) == .orderedSame {
    //            return .black
    //        } else if date.compare(Date()) == .orderedAscending {
    //            return .lightGray
    //        } else if date.compare(Date()) == .orderedDescending {
    //            return .black
    //        } else {
    //            return .black
    //        }
    //    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        let dateString = self.dateFormatter.string(from: date as Date)
        if selectedDates.count != 0 {
            let lastDate = dateFromString(dateStr: self.selectedDates.last!)
            let oneDayAfterLastDate = Calendar.current.date(byAdding: .day, value: 1, to: lastDate)!
            if date <= oneDayAfterLastDate {
                let dateString = self.dateFormatter.string(from: date as Date)
                if Int(self.dayPassFunctionalityPopUpV.title.text!)! >= 0 {
                    self.numberOfSelectedDays += 1
                    self.dayPassFunctionalityPopUpV.title.text = String(self.numberOfSelectedDays)
                }
                self.selectedDates.append(dateString)
            } else {
                self.dayPassFunctionalityPopUpV.calendarV.deselect(date)
            }
        } else {
            self.numberOfSelectedDays += 1
            self.dayPassFunctionalityPopUpV.title.text = String(self.numberOfSelectedDays)
            self.currentSelectedDate = self.dateFromString(dateStr: dateString)
            self.dayPassFunctionalityPopUpV.calendarV.select(self.currentSelectedDate)
            
            let dateString = self.stringFromDate(date: self.currentSelectedDate)
            self.selectedDates.append(dateString)
        }
    }
    
    func calendar(_ calendar: FSCalendar, didDeselect date: Date, at monthPosition: FSCalendarMonthPosition) {
        if selectedDates.count != 0 {
            if selectedDates.last == stringFromDate(date: Date()) {
                self.dayPassFunctionalityPopUpV.calendarV.deselect(Date())
                self.numberOfSelectedDays = 0
                self.dayPassFunctionalityPopUpV.title.text = String(self.numberOfSelectedDays)
                self.selectedDates.removeAll()
            } else if selectedDates.count == 1 {
                self.dayPassFunctionalityPopUpV.calendarV.deselect(self.dateFromString(dateStr: selectedDates[0]))
                self.numberOfSelectedDays = 0
                self.dayPassFunctionalityPopUpV.title.text = String(self.numberOfSelectedDays)
                self.selectedDates.removeAll()
            } else {
                let lastDate = dateFromString(dateStr: self.selectedDates.last!)
                if date == lastDate {
                    let dateString = self.dateFormatter.string(from: date as Date)
                    if Int(self.dayPassFunctionalityPopUpV.title.text!)! > 1 {
                        self.numberOfSelectedDays -= 1
                        self.dayPassFunctionalityPopUpV.title.text = String(self.numberOfSelectedDays)
                        let convertDate = self.dateFromString(dateStr: dateString)
                        self.currentSelectedDate = convertDate
                    }
                    self.selectedDates.remove(at: self.selectedDates.firstIndex(of: dateString)!)
                } else {
                    self.dayPassFunctionalityPopUpV.calendarV.select(date)
                }
            }
        }
    }
    
    //    func utcToLocal(dateStr: String) -> String? {
    //        let dateFormatter = DateFormatter()
    //        dateFormatter.dateFormat = "yyyy-MM-dd"
    //        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
    //
    //        if let date = dateFormatter.date(from: dateStr) {
    //            dateFormatter.timeZone = TimeZone.current
    //            dateFormatter.dateFormat = "yyyy-MM-dd"
    //            return dateFormatter.string(from: date)
    //        }
    //        return nil
    //    }
    
    // String to date
    func dateFromString(dateStr: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.locale = Locale(identifier: "en_EN")
        return dateFormatter.date(from: dateStr)!
    }
    
    // Date to String
    func stringFromDate(date:Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.locale = Locale(identifier: "en_EN")
        return dateFormatter.string(from: date as Date)
    }
    
    func formatIntToTwoDecimalPlaces(_ doubleNumber: Double) -> String {
        let roundedNumber = round(doubleNumber * 100) / 100.0 // Round to two decimal places
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        return formatter.string(for: roundedNumber) ?? ""
    }
}
