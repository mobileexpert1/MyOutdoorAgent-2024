//  LicensePropertyDetailCell.swift
//  MyOutdoorAgent
//  Created by CS on 07/10/22.

import UIKit

// MARK: - UITableView DataSource
extension LicensePropertyDetailVC : UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = configureCell(tableView, indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

// MARK: - ConfigureCell
extension LicensePropertyDetailVC {
    private func configureCell(_ tableView : UITableView, _ indexPath : IndexPath) -> UITableViewCell {
        let dequeCell = tableView.dequeueReusableCell(withIdentifier: CustomCells.licenseDetailTVCell.name, for: indexPath)
        guard let cell = dequeCell as? LicenseDetailTVCell else { return UITableViewCell() }
        cell.delegate = self
        cell.reloadDelegate = self
        setViewAction(cell, indexPath)
        return cell
    }
    
    private func setViewAction(_ cell: LicenseDetailTVCell, _ indexPath: IndexPath) {
        // License Details
        if ((self.licenseDetailArr?.licenseDetails?.countyName) != nil) || ((self.licenseDetailArr?.licenseDetails?.stateName) != nil) {
            cell.locationLbl.text = (self.licenseDetailArr?.licenseDetails?.countyName)! + " County, " + (self.licenseDetailArr?.licenseDetails?.stateName)!
        }
        
        if ((self.licenseDetailArr?.licenseDetails?.firstName) != nil) || ((self.licenseDetailArr?.licenseDetails?.lastName) != nil) {
            cell.licenseHolderLbl.text = (self.licenseDetailArr?.licenseDetails?.firstName)! + " " + (self.licenseDetailArr?.licenseDetails?.lastName)!
        }
        
        if ((self.licenseDetailArr?.licenseDetails?.email) != nil) {
            cell.emailLbl.text = (self.licenseDetailArr?.licenseDetails?.email)!
        }
        
        if ((self.licenseDetailArr?.licenseDetails?.contactNumber) != nil) {
            cell.contactLbl.text = (self.licenseDetailArr?.licenseDetails?.phone)!.toPhoneNumber()
        }
        
        if ((self.licenseDetailArr?.licenseDetails?.groupName) != nil) {
            cell.clubNameLbl.text = (self.licenseDetailArr?.licenseDetails?.groupName)!
        }
        
        if ((self.licenseDetailArr?.licenseDetails?.productNo) != nil) {
            cell.propertyNumberLbl.text = (self.licenseDetailArr?.licenseDetails?.productNo)!
            cell.licenseDisplayNameLbl.text = (self.licenseDetailArr?.licenseDetails?.displayName)!
           
        }
        
        if ((self.licenseDetailArr?.licenseDetails?.licenseFee) != nil) {
            print("@@@@#####---- ",(self.licenseDetailArr?.licenseDetails?.licenseFee))
            let licenseFeeStr = self.licenseDetailArr?.licenseDetails?.licenseFee
            
            cell.propertyFeesLbl.text = "$" + formatIntToTwoDecimalPlaces(Double(licenseFeeStr ?? 0.0))
        }
        
        if ((self.licenseDetailArr?.licenseDetails?.acres) != nil) {
            cell.acresLbl.text = (self.licenseDetailArr?.licenseDetails?.acres)?.description
        }
        
        if ((self.licenseDetailArr?.licenseDetails?.contractStatus) != nil) {
            cell.licenseStatusLbl.text = (self.licenseDetailArr?.licenseDetails?.contractStatus)!
        }
        
        if ((self.licenseDetailArr?.licenseDetails?.paymentStatus) != nil) {
            cell.paymentStatusLbl.text = (self.licenseDetailArr?.licenseDetails?.paymentStatus)!
        }
        
        if (licenseDetailArr?.licenseDetails?.licenseStartDate != nil) && (licenseDetailArr?.licenseDetails?.licenseEndDate != nil) {
            cell.startDateLbl.text = cell.startDateLbl.text?.setDateFormat((licenseDetailArr?.licenseDetails?.licenseStartDate)!, "MMMM", "dd", ", yyyy")
            cell.endDateLbl.text = cell.endDateLbl.text?.setDateFormat((licenseDetailArr?.licenseDetails?.licenseEndDate)!, "MMMM", "dd", ", yyyy")
        }
        
        // Property Overview
        if ((self.licenseDetailArr?.licenseDetails?.displayDescription) != nil) {
            cell.noPropertyLbl.isHidden = true
            cell.propertyOverviewLbl.text = (self.licenseDetailArr?.licenseDetails?.displayDescription)!
        } else {
            cell.noPropertyLbl.isHidden = false
        }
        
        // Renew License
        if self.licenseDetailArr?.licenseDetails?.renewalStatus == 1 {
            cell.renewLicenseMainV.isHidden = false
            cell.renewLicenseTop.constant = 15
            
            UIDevice.current.userInterfaceIdiom == .phone
            ? (cell.renewLicenseHeight.constant = 140)
            : (cell.renewLicenseHeight.constant = 180)
            
            cell.renewDueDateLbl.text = "Payment Due Date: " + (cell.renewDueDateLbl.text?.setDate((licenseDetailArr?.renewalActivity?.paymentDueDate)!, "dd-MMMM-yyyy", "yyyy-MM-dd'T'HH:mm:ss"))!
            cell.renewDueDateLbl.blink()
            cell.renewLicenseBtn.actionBlock {   // "2022-12-18T00:00:00",
                var data = [String: Any]()
                data["publicKey"] = self.licenseDetailArr?.renewalActivity?.publicKey
                isComingFrom = "other"
                self.pushWithData(Storyboards.propertyView.name, Controllers.property.name, data)
            }
        } else {
            cell.renewLicenseMainV.isHidden = true
            cell.renewLicenseHeight.constant = 0
            cell.renewLicenseTop.constant = 0
        }
        
        // Property License Agreement
        cell.licenseAgreementV.actionBlock {
            self.myLicensesViewModelArr?.generateContractApi(self.view, (self.licenseDetailArr?.licenseDetails?.licenseContractID)!, completion: { responseModel in
                self.viewTransition(self.licensePdfPopUpView)
                let pdfNameStr = responseModel.message
                if ((pdfNameStr?.contains(" ")) != nil) {
                    self.showActiveWebView((Apis.licensePdfUrl) + pdfNameStr!.replacingOccurrences(of: " ", with: "%20"))
                } else {
                    self.showActiveWebView((Apis.licensePdfUrl) + responseModel.message!)
                }
            })
        }
        
        // Club Memberships Cards
        cell.clubMembershipV.actionBlock {
            self.myLicensesViewModelArr?.generateClubMembershipCardApi(self.view, (self.licenseDetailArr?.licenseDetails?.licenseContractID)!, completion: { responseModel in
                if self.licenseDetailArr?.licenseDetails?.productTypeID == 1 {
                    self.viewTransition(self.licensePdfPopUpView)
                    let pdfNameStr = responseModel.message
                    if ((pdfNameStr?.contains(" ")) != nil) {
                        self.showActiveWebView((Apis.licensePdfUrl) + pdfNameStr!.replacingOccurrences(of: " ", with: "%20"))
                    } else {
                        self.showActiveWebView((Apis.licensePdfUrl) + responseModel.message!)
                    }
                } else {
                    let okBtn = [ButtonText.ok.text]
                    UIAlertController.showAlert(AppAlerts.alert.title, message: AppErrors.noClubMembers.localizedDescription, buttons: okBtn, completion: nil)
                }
            })
        }
        
        // Invite Members
        if self.licenseDetailArr?.licenseDetails?.activityType != "Day Pass" {
            UIDevice.current.userInterfaceIdiom  == .phone
            ? (cell.memberHeight.constant = CGFloat(60 + Int(110*memberDetailArr!.count)))
            : (cell.memberHeight.constant = CGFloat(80 + Int(110*memberDetailArr!.count)))
            
            cell.memberTop.constant = 15
            cell.inviteMembersV.isHidden = false
            
            // Set Add Vehicle Button
            if (self.licenseDetailArr?.licenseDetails?.allowMemberActions == true) {
                cell.inviteMembersV.isHidden = false
            } else {
                cell.inviteMembersV.isHidden = true
            }
            
            if memberDetailArr?.count == 0 {
                cell.noMembersLbl.isHidden = false
            } else {
                cell.noMembersLbl.isHidden = true
                cell.membersTV.reloadData()
            }
        } else {
            cell.memberTop.constant = 0
            cell.memberHeight.constant = 0
            cell.inviteMembersV.isHidden = true
            cell.noMembersLbl.isHidden = true
        }
        
        // Set Add Member and Set invite member View
        if ((self.licenseDetailArr?.licenseDetails?.allowMemberActions) == true) && ((self.licenseDetailArr?.clientFeatures?.addClubMembers) == true) {
            cell.memberLbl.text = "Add Members"
        } else {
            cell.memberLbl.text = "Invite Members"
        }
        
        //        if ((self.licenseDetailArr?.licenseDetails?.allowMemberActions) == true) && ((self.licenseDetailArr?.clientFeatures?.addClubMembers) == true) {
        //            cell.memberLbl.text = "Invite Members"
        //        } else {
        //            cell.memberLbl.text = "Add Members"
        //        }
        
        // Add Member Action
        if cell.memberLbl.text == "Add Members" {
            addMemberPopV.phoneNumberTxtF.delegate = self
            addMemberPopV.zipCodeTxtF.delegate = self
            addMemberPopV.phoneNumberTxtF.maxLength = 10
            addMemberPopV.zipCodeTxtF.maxLength = 5
            
            cell.inviteMembersV.actionBlock {
                self.viewTransition(self.addMemberPopV)
                
                // -- Open State Drop down in Edit Account PopUp
                self.addMemberPopV.stateV.actionBlock {
                    self.resignMemberTxtF()
                    
                    DropDownHandler.shared.showDropDownWithItems(self.addMemberPopV.stateV, self.statesArr, self.addMemberPopV.stateImgV, "No State Available")
                    DropDownHandler.shared.itemPickedBlock = { (index, item) in
                        self.addMemberPopV.stateImgV.image = Images.downArrow.name
                        self.addMemberPopV.stateLbl.text = item
                    }
                    
                    DropDownHandler.shared.cancelActionBlock = {
                        self.addMemberPopV.stateImgV.image = Images.downArrow.name
                    }
                    
                    DropDownHandler.shared.willShowActionBlock = {
                        self.addMemberPopV.stateImgV.image = Images.upArrow.name
                        self.resignMemberTxtF()
                    }
                }
                
                // -- Save Changes Button
                self.addMemberPopV.saveChangesBtn.actionBlock {
                    self.myLicensesViewModelArr?.checkValidMemberTF(self.view, licenseContractID: (self.licenseDetailArr?.licenseDetails?.licenseContractID)!, firstName: self.addMemberPopV.firstNameTxtF.text!, lastName: self.addMemberPopV.lastNameTxtF.text!, email: self.addMemberPopV.emailTxtF.text!, phone: self.addMemberPopV.phoneNumberTxtF.text!, address: self.addMemberPopV.addressTxtF.text!, state: self.addMemberPopV.stateLbl.text!, city: self.addMemberPopV.cityTxtF.text!, zip: self.addMemberPopV.zipCodeTxtF.text!)
                }
                
                // -- Cancel Button
                self.addMemberPopV.cancelBtn.actionBlock {
                    self.removeView(self.addMemberPopV)
                    
                    let txtFieldArr = [self.addMemberPopV.firstNameTxtF, self.addMemberPopV.lastNameTxtF, self.addMemberPopV.emailTxtF, self.addMemberPopV.addressTxtF, self.addMemberPopV.phoneNumberTxtF, self.addMemberPopV.zipCodeTxtF, self.addMemberPopV.cityTxtF]
                    txtFieldArr.forEach { textFields in
                        textFields?.text = EMPTY_STR
                        self.addMemberPopV.stateLbl.text = CommonKeys.state.name
                    }
                }
                
            }
        }
        
        // Invite Member Action
        if cell.memberLbl.text == "Invite Members" {
            cell.inviteMembersV.actionBlock {
                self.viewTransition(self.inviteMemberPopV)
                
                // -- Add Member Button
                self.inviteMemberPopV.addMemberV.actionBlock {
                    let email = self.inviteMemberPopV.emailTxtF.text
                    
                    if ((email?.isEmpty) == true) && (self.memberArr.count == 0) {
                        UIAlertController.showAlert(AppAlerts.alert.title, message: AppErrors.enterEmail.localizedDescription, buttons: self.okBtn, completion: nil)
                    } else if ((email?.isEmailValid) == false) && (self.memberArr.count == 0) {
                        UIAlertController.showAlert(AppAlerts.alert.title, message: AppErrors.validEmail.localizedDescription, buttons: self.okBtn, completion: nil)
                    } else {
                        var memberEntriesArr = [String]()
                        if self.memberArr.count == 0 {
                            memberEntriesArr.append(email!)
                            let entriesStr = memberEntriesArr.joined(separator: ",")
                            self.myLicensesViewModelArr?.inviteMembersApi(self.view, (self.licenseDetailArr?.licenseDetails?.licenseContractID)!, entriesStr, completion: { responseModel in
                                print(responseModel)
                            })
                        } else {
                            for i in 0..<self.memberArr.count {
                                print("i", self.memberArr[i])
                                memberEntriesArr.append(self.memberArr[i])
                            }
                            let entriesStr = memberEntriesArr.joined(separator: ",")
                            
                            
                            self.myLicensesViewModelArr?.inviteMembersApi(self.view, (self.licenseDetailArr?.licenseDetails?.licenseContractID)!, entriesStr, completion: { responseModel in
                                print(responseModel)
                            })
                        }
                    }
                }
                
                // -- Cancel Button
                self.inviteMemberPopV.cancelV.actionBlock {
                    self.removeView(self.inviteMemberPopV)
                    self.inviteMemberPopV.emailTxtF.text = EMPTY_STR
                    self.memberArr.removeAll()
                    self.inviteMemberPopV.collectionV.reloadData()
                }
            }
        }
        
        // Add Vehicle Info
        if (self.licenseDetailArr?.licenseDetails?.motorizedAccess) == true && (self.licenseDetailArr?.licenseDetails?.productTypeID == 2) {
            UIDevice.current.userInterfaceIdiom  == .phone
            ? (cell.vehicleHeight.constant = CGFloat(60 + Int(100*vehicleDetailArr!.count)))
            : (cell.vehicleHeight.constant = CGFloat(80 + Int(100*vehicleDetailArr!.count)))

            cell.addVehicleTop.constant = 15
            cell.addVehiclesV.isHidden = false
            
            // Set Add Vehicle Button
            if (self.licenseDetailArr?.licenseDetails?.allowMemberActions == true) && (vehicleDetailArr!.count < 2) {
                cell.addVehiclesV.isHidden = false
            } else {
                cell.addVehiclesV.isHidden = true
            }
            
            if vehicleDetailArr?.count == 0 {
                cell.noVehiclesLbl.isHidden = false
            } else {
                cell.noVehiclesLbl.isHidden = true
                cell.vehiclesTV.reloadData()
            }
            
        } else {
            cell.vehicleHeight.constant = 0
            cell.addVehicleTop.constant = 0
            cell.addVehiclesV.isHidden = true
            cell.noVehiclesLbl.isHidden = true
        }
        
        cell.addVehiclesV.actionBlock {
            self.viewTransition(self.addVehicleInfoPopV)
            
            // -- Select Type
            self.addVehicleInfoPopV.vehicleStateV.actionBlock {
                self.resignTxtF()
                DropDownHandler.shared.showDropDownWithItems(self.addVehicleInfoPopV.vehicleStateV, self.statesArr, self.addVehicleInfoPopV.stateArrowImgV, "No State Available")
                DropDownHandler.shared.itemPickedBlock = { (index, item) in
                    self.addVehicleInfoPopV.stateArrowImgV.image = Images.downArrow.name
                    self.addVehicleInfoPopV.selectStateLbl.text = item
                }
                
                DropDownHandler.shared.cancelActionBlock = {
                    self.addVehicleInfoPopV.stateArrowImgV.image = Images.downArrow.name
                }
                
                DropDownHandler.shared.willShowActionBlock = {
                    self.addVehicleInfoPopV.stateArrowImgV.image = Images.upArrow.name
                    self.resignTxtF()
                }
            }
            
            // Save Changes
            self.addVehicleInfoPopV.saveChangesV.actionBlock {
                self.myLicensesViewModelArr?.addVehiclesTFValid(self.view, self.addVehicleInfoPopV.selectStateLbl.text!, (self.licenseDetailArr?.licenseDetails?.licenseContractID)!, self.addVehicleInfoPopV.vehicleMakeTxtF.text!, self.addVehicleInfoPopV.vehicleModelTxtF.text!, self.addVehicleInfoPopV.vehicleColorTxtF.text!, self.addVehicleInfoPopV.vehicleLicensePlateTxtF.text!)
            }
            
            // Cancel Vehicle Info
            self.addVehicleInfoPopV.cancelV.actionBlock {
                self.removeView(self.addVehicleInfoPopV)
                
                let txtFieldArr = [self.addVehicleInfoPopV.vehicleMakeTxtF, self.addVehicleInfoPopV.vehicleModelTxtF, self.addVehicleInfoPopV.vehicleColorTxtF, self.addVehicleInfoPopV.vehicleLicensePlateTxtF]
                txtFieldArr.forEach { textFields in
                    textFields?.text = EMPTY_STR
                    self.addVehicleInfoPopV.selectStateLbl.text = CommonKeys.selectState.name
                }
                
            }
        }
    }
    
    // -- To resign keyboard when drop down is selected
    private func resignTxtF() {
        let txtFieldArr = [self.addVehicleInfoPopV.vehicleMakeTxtF, self.addVehicleInfoPopV.vehicleModelTxtF, self.addVehicleInfoPopV.vehicleColorTxtF, self.addVehicleInfoPopV.vehicleLicensePlateTxtF]
        txtFieldArr.forEach { textFields in
            textFields?.resignFirstResponder()
        }
    }
    
    // -- To resign keyboard when drop down is selected
    func resignMemberTxtF() {
        let txtFieldArr = [self.addMemberPopV.firstNameTxtF, self.addMemberPopV.lastNameTxtF, self.addMemberPopV.emailTxtF, self.addMemberPopV.addressTxtF, self.addMemberPopV.phoneNumberTxtF, self.addMemberPopV.zipCodeTxtF, self.addMemberPopV.cityTxtF]
        txtFieldArr.forEach { textFields in
            textFields?.resignFirstResponder()
        }
    }
}

// MARK: - TextField Delegates
extension LicensePropertyDetailVC: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        // Verify all the conditions
        if let sdcTextField = textField as? TextFieldInset {
            return sdcTextField.verifyFields(shouldChangeCharactersIn: range, replacementString: string)
        }
        
        if let text = textField.text as NSString? {
            let txtAfterUpdate = text.replacingCharacters(in: range, with: string)
            if txtAfterUpdate.count == 1 {
                if txtAfterUpdate.last == "," {
                    return false
                }
            } else {
                if txtAfterUpdate.last == "," {
                    if !(String(txtAfterUpdate.dropLast()).isEmailValid) {
                        textField.resignFirstResponder()
                        UIAlertController.showAlert(AppAlerts.alert.title, message: AppErrors.validEmail.localizedDescription, buttons: okBtn, completion: nil)
                    } else {
                        memberArr.append(String(txtAfterUpdate.dropLast()))
                        textField.text = EMPTY_STR
                        inviteMemberPopV.collectionV.reloadData()
                        return false
                    }
                }
            }
        }
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let text = textField.text {
            if !text.isEmpty {
                if !text.isEmailValid {
                    textField.resignFirstResponder()
                    UIAlertController.showAlert(AppAlerts.alert.title, message: AppErrors.validEmail.localizedDescription, buttons: okBtn, completion: nil)
                } else {
                    memberArr.append(text)
                    textField.text = EMPTY_STR
                    inviteMemberPopV.collectionV.reloadData()
                }
            }
        }
        return true
    }
}

// MARK: - UICollectionView Delegates and Datasource
extension LicensePropertyDetailVC: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return memberArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = configureCell(collectionView, indexPath)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if UIDevice.current.userInterfaceIdiom == .pad {
            return CGSize(width: (memberArr[indexPath.row].size(withAttributes: [NSAttributedString.Key.font : UIFont(name: Fonts.nunitoSansRegular.name, size: 14)!]).width) + 75, height: 45)
        }
        
        return CGSize(width: (memberArr[indexPath.row].size(withAttributes: [NSAttributedString.Key.font : UIFont(name: Fonts.nunitoSansRegular.name, size: 12)!]).width) + 65, height: 35)
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

// MARK: - ConfigureCell
extension LicensePropertyDetailVC {
    func configureCell(_ collectionView : UICollectionView, _ indexPath : IndexPath) -> UICollectionViewCell {
        let dequeCell = collectionView.dequeueReusableCell(withReuseIdentifier: CustomCells.inviteMemberCVCell.name, for: indexPath)
        guard let cell = dequeCell as? InviteMemberCVCell else { return UICollectionViewCell() }
        cell.memberLbl.text = memberArr[indexPath.row]
        
        UIDevice.current.userInterfaceIdiom == .phone
        ? (cell.memberV.cornerRadius = 15)
        : (cell.memberV.cornerRadius = 20)
        
        cell.crossV.actionBlock {
            self.memberArr.remove(at: indexPath.row)
            collectionView.reloadData()
        }
        return cell
    }
}
