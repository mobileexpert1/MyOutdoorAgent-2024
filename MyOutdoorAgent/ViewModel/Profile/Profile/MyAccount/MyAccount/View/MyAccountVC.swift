//  MyAccountVC.swift
//  MyOutdoorAgent
//  Created by CS on 08/08/22.

import UIKit
import FirebaseAuth
import GoogleSignIn
import PKHUD

class MyAccountVC: AbstractView {
    
    // MARK: - Objects
    private var myAccountViewModel: MyAccountViewModel?
    private var accountSettingsViewModel: AccountSettingsViewModel?
    var savedSearchesViewModel: SavedSearchesViewModel?
    
    // MARK: - Variables
    var savedSearchesArr = [SavedSearchesModelClass]()
    var getAllStatesArr = [GetAllStatesModelClass]()
    var cardDict = [Int:[String]]()
    var searchId = [Int]()
    var cards = [String]()
    var statesArr = [String]()
    var secureCurrentPassword : Bool!
    var secureNewPassword : Bool!
    var secureConfirmPassword : Bool!
    
    // MARK: - Computed Variables
    private lazy var accountSettingsView: AccountSettingsVC = {
        var viewController = UIStoryboard(name: Storyboards.accountSettingsView.name, bundle: Bundle.main).instantiateViewController(withIdentifier: Controllers.accountSettings.name) as! AccountSettingsVC
        self.add(asChildViewController: viewController, containerV)
        return viewController
    }()
    
    lazy var savedSearchesView: SavedSearchesVC = {
        var viewController = UIStoryboard(name: Storyboards.savedSearchesView.name, bundle: Bundle.main).instantiateViewController(withIdentifier: Controllers.savedSearchesVC.name) as! SavedSearchesVC
        self.add(asChildViewController: viewController, containerV)
        return viewController
    }()
    
    // MARK: - Outlets
    @IBOutlet weak var containerV: UIView!
    @IBOutlet weak var customView: CustomNavBar!
    @IBOutlet weak var logOutV: UIView!
    @IBOutlet weak var accountSettingsBtn: UIButton!
    @IBOutlet weak var savedSearchesBtn: UIButton!
    @IBOutlet var editAccountPopUpV: EditAccountPopUp!
    @IBOutlet var changePassPopUpV: ChangePasswordPopUp!
    @IBOutlet weak var scrollV: UIScrollView!
    
    // MARK: - ViewLifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        onViewLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        onViewAppear()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        setSavedSearchesApi()
    }
    
    // MARK: - Functions
    private func onViewLoad() {
        setUI()
        actionBlock()
        accountSettingsAction()
        savedSearchesAction()
        setDelegates()
    }
    
    private func onViewAppear() {
        scrollV.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
        setViewOnAppear()
        setValueLocally()
        hideUnhideHandler()
    }
    
    private func setUI() {
        showNavigationBar(false)
        setcustomNav(customView: customView, titleIsHidden: false, titleText: NavigationTitle.profile.name, navViewColor: Colors.grey.value, mainViewColor: Colors.grey.value, backImg: Images.back.name)
        editAccountPopUpV.mobileNoTxtF.maxLength = 10
        editAccountPopUpV.zipCodeTxtF.maxLength = 5
    }
    
    private func setDelegates() {
        myAccountViewModel = MyAccountViewModel(self)
        accountSettingsViewModel = AccountSettingsViewModel(self)
        savedSearchesViewModel = SavedSearchesViewModel(self)
    }
    
    private func setViewOnAppear() {
        self.accountSettingsView.switchEnable.isOn = LocalStore.shared.getNotifications
        accountSettingsView.switchEnable.addTarget(self, action: #selector(toggleSwitch(_:)), for: .valueChanged)
        remove(asChildViewController: savedSearchesView)
        add(asChildViewController: accountSettingsView, containerV)
        MyAccountButtonUI().setAccountSettingsBtnUI(self.accountSettingsBtn, self.savedSearchesBtn)
        setViewUserProfileApi()
        setSavedSearchesApi()
        getAllStatesApi()
    }
    
    private func getAllStatesApi() {
        self.myAccountViewModel?.getAllStatesApi(self.view, completion: { responseModel in
            self.getAllStatesArr = responseModel
            
            self.statesArr.removeAll()
            for i in 0..<self.getAllStatesArr.count {
                self.statesArr.append(self.getAllStatesArr[i].stateName!)
            }
            
        })
    }
    
    private func setViewUserProfileApi() {
        accountSettingsViewModel?.setViewUserProfileApi(self.view, completion: { responseModel in
            LocalStore.shared.isUserProfileComplete = ((responseModel.isUserProfileComplete) != nil)
            LocalStore.shared.userProfileId = (responseModel.userProfileID)!
            LocalStore.shared.userAccountId = (responseModel.userAccountID)!
            LocalStore.shared.authenticationType = (responseModel.authenticationType)!
            LocalStore.shared.usename = (responseModel.firstName ?? "Name") + " " + (responseModel.lastName ?? EMPTY_STR)
            LocalStore.shared.userEmail = responseModel.email ?? ""
            
            self.accountSettingsView.nameTxtF.text = (responseModel.firstName ?? "Name") + " " + (responseModel.lastName ?? EMPTY_STR)
            self.accountSettingsView.emailTxtF.text = responseModel.email
            
            if (responseModel.firstName) != nil {
                LocalStore.shared.fisrtName = responseModel.firstName!
            }
            
            if (responseModel.lastName) != nil {
                LocalStore.shared.lastName = responseModel.lastName!
            }

            if (responseModel.streetAddress) != nil {
                self.accountSettingsView.clubNameTxtF.text = responseModel.groupName
            }
            
            if (responseModel.phone) != nil {
                let phone = (responseModel.phone)!.toPhoneNumber()
                self.accountSettingsView.mobileNoTxtF.text = phone
            }
            
            if (responseModel.streetAddress) != nil {
                self.accountSettingsView.addressTxtF.text = (responseModel.streetAddress)! + ", " + (responseModel.city)! + ", " + (responseModel.st)!
                LocalStore.shared.streetAdd = responseModel.streetAddress!
            }
            
          //  if (responseModel.groupName) != nil {
                LocalStore.shared.clubname = self.accountSettingsView.clubNameTxtF.text!
          //  }
            
            if (responseModel.st) != nil {
                LocalStore.shared.state = responseModel.st!
            }
            
            if (responseModel.city) != nil {
                LocalStore.shared.city = responseModel.city!
            }
            
            if (responseModel.zip) != nil {
                LocalStore.shared.zipcode = responseModel.zip!
            }
            
            if String.isNilOrEmpty((responseModel.lastName)) == true {
                LocalStore.shared.lastName = responseModel.lastName ?? ""
            }
            
            LocalStore.shared.name = self.accountSettingsView.nameTxtF.text!
            LocalStore.shared.address = self.accountSettingsView.addressTxtF.text!
            LocalStore.shared.email = self.accountSettingsView.emailTxtF.text!
            LocalStore.shared.streetAddress = self.accountSettingsView.addressTxtF.text!
            LocalStore.shared.mobileNo = self.accountSettingsView.mobileNoTxtF.text!
            
            HUD.hide()
        })
    }
    
    private func setSavedSearchesApi() {
        self.savedSearchesViewModel?.savedSearchesApi(self.view, savedSearchesView.tableV, completion: { responseModel in
            self.savedSearchesArr = responseModel
        })
        
        var indexArr = [Int]()
        for i in 0..<self.savedSearchesArr.count {
            if (self.savedSearchesArr[i].RegionName?.count == 0)
                && (self.savedSearchesArr[i].PropertyName?.count == 0)
                && (self.savedSearchesArr[i].StateName?.count == 0)
                && (self.savedSearchesArr[i].Amenities?.count == 0)
                && (self.savedSearchesArr[i].SearchName == nil)
            {
                indexArr.append(i)
            }
        }
        
        self.savedSearchesArr.remove(at: indexArr)
        
        self.savedSearchesView.tableV.delegate = self
        self.savedSearchesView.tableV.dataSource = self
        self.savedSearchesView.tableV.reloadData()
        
        setCards()
        self.savedSearchesView.tableV.reloadData()
    }
    
    private func setValueLocally() {
        if LocalStore.shared.fisrtName != EMPTY_STR {
            editAccountPopUpV.firstNameTxtF.text = LocalStore.shared.fisrtName
        }
        if LocalStore.shared.lastName != EMPTY_STR {
            editAccountPopUpV.lastNameTxtF.text = LocalStore.shared.lastName
        }
        if LocalStore.shared.email != EMPTY_STR {
            editAccountPopUpV.emailTxtF.text = LocalStore.shared.email
        }
        if LocalStore.shared.streetAddress != EMPTY_STR {
            editAccountPopUpV.addressTxtF.text =  LocalStore.shared.streetAdd
        }
        if LocalStore.shared.city != EMPTY_STR {
            editAccountPopUpV.cityTxtF.text = LocalStore.shared.city
        }
        if LocalStore.shared.state != EMPTY_STR {
            editAccountPopUpV.stateLbl.text = LocalStore.shared.state
        }
        if LocalStore.shared.mobileNo != EMPTY_STR {
            editAccountPopUpV.mobileNoTxtF.text = LocalStore.shared.mobileNo
        }
        if LocalStore.shared.zipcode != EMPTY_STR {
            editAccountPopUpV.zipCodeTxtF.text = LocalStore.shared.zipcode
        }
        if (LocalStore.shared.clubname != EMPTY_STR) {
            editAccountPopUpV.clubNameTxtF.text = LocalStore.shared.clubname
        }
    }
    
    private func actionBlock() {
        // -- Log out
        logOutV.actionBlock {
            self.myAccountViewModel?.logOutAlert(self.view)
        }
    }
    
    // MARK: - Objc Function
    @objc func toggleSwitch(_ sender: UISwitch) {
        self.accountSettingsView.switchEnable.isOn
        ? (LocalStore.shared.getNotifications = true)
        : (LocalStore.shared.getNotifications = false)
        
        self.accountSettingsViewModel?.manageNotificationsApi(self.view, LocalStore.shared.getNotifications, completion: { responseModel in
        })
    }
}

// MARK: - MyAccountViewModelDelegate
extension MyAccountVC: MyAccountViewModelDelegate {
    func editProfileSuccessCalled(_ success: String) {
        HUD.flash(.label(success), delay: 0.5)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.removeView(self.editAccountPopUpV)
            self.setViewUserProfileApi()
        }
    }
    
    func editProfileErrorCalled(_ error: String) {
        HUD.flash(.labeledError(title: EMPTY_STR, subtitle: error), delay: 1.0)
    }
    
    func logOutSuccessCalled() {
        DispatchQueue.main.async {
            HUD.hide()
            
            // Sign out from Google
            GIDSignIn.sharedInstance.signOut()
            
            // Sign out from Firebase
            do {
                try Auth.auth().signOut()
                // Update screen after user successfully signed out
                self.emptyLocalStore()
                self.goToLoginPage()
            } catch let error as NSError {
                print ("Error signing out from Firebase: %@", error)
            }
        }
    }
    
    func emptyLocalStore() {
        LocalStore.shared.isSocialHandler = EMPTY_STR
        LocalStore.shared.userId = EMPTY_STR
        LocalStore.shared.userProfileId = 0
        LocalStore.shared.userAccountId = 0
        LocalStore.shared.email = EMPTY_STR
        LocalStore.shared.name = EMPTY_STR
        LocalStore.shared.fisrtName = EMPTY_STR
        LocalStore.shared.lastName = EMPTY_STR
        LocalStore.shared.streetAddress = EMPTY_STR
        LocalStore.shared.city = EMPTY_STR
        LocalStore.shared.streetAdd = EMPTY_STR
        LocalStore.shared.state = CommonKeys.state.name
        LocalStore.shared.zipcode = EMPTY_STR
        LocalStore.shared.mobileNo = EMPTY_STR
        LocalStore.shared.address = EMPTY_STR
        LocalStore.shared.clubname = EMPTY_STR
        LocalStore.shared.rluSearchName = EMPTY_STR
        LocalStore.shared.countySearchName = EMPTY_STR
        LocalStore.shared.regionSearchName = EMPTY_STR
        LocalStore.shared.propertySearchName = EMPTY_STR
        LocalStore.shared.freeTextSearchName = EMPTY_STR
        LocalStore.shared.navigationScreen = EMPTY_STR
    }
    
    func logOutErrorCalled(_ error: String) {
        HUD.flash(.labeledError(title: EMPTY_STR, subtitle: error), delay: 1.0)
    }
    
    func changePassSuccessCalled(_ success: String) {
        HUD.flash(.label(success), delay: 0.5)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.removeView(self.changePassPopUpV)
        }
    }
    
    func changePassErrorCalled(_ error: String) {
        HUD.flash(.labeledError(title: EMPTY_STR, subtitle: error), delay: 1.0)
    }
}

// MARK: - Account Settings
extension MyAccountVC {
    private func accountSettingsAction() {
        // -- Account Settings
        accountSettingsBtn.actionBlock { [self] in
            scrollV.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
            self.remove(asChildViewController: self.savedSearchesView)
            self.add(asChildViewController: self.accountSettingsView, self.containerV)
            MyAccountButtonUI().setAccountSettingsBtnUI(self.accountSettingsBtn, self.savedSearchesBtn)
            self.setViewUserProfileApi()
        }
        
        // -- Account Settings Edit Button
        accountSettingsView.editBtn.actionBlock {
            self.viewTransition(self.editAccountPopUpV)
            self.setValueLocally()
            self.editAccountAction()
        }
        
        // -- Change Password Button
        accountSettingsView.changePassV.actionBlock {
            self.viewTransition(self.changePassPopUpV)
            self.changePasswordAction()
        }
    }
    
    private func editAccountAction() {
        // -- Save Button in Edit Account PopUp
        self.editAccountPopUpV.saveView.actionBlock {
            let firstName = self.editAccountPopUpV.firstNameTxtF.text!
            let lastName = self.editAccountPopUpV.lastNameTxtF.text!
            let streetAddress = self.editAccountPopUpV.addressTxtF.text!
            let city = self.editAccountPopUpV.cityTxtF.text!
            let state = self.editAccountPopUpV.stateLbl.text!
            let zip = self.editAccountPopUpV.zipCodeTxtF.text!
            let phone = self.editAccountPopUpV.mobileNoTxtF.text!
            let clubname = self.editAccountPopUpV.clubNameTxtF.text!
            
            let phoneStr = String(phone.filter { !" ()-".contains($0) })
            self.myAccountViewModel?.checkValidationsProfile(self.view, firstName, lastName, streetAddress, city, state, zip, phoneStr, clubname)
        }
        
        // -- Cancel Button in Edit Account PopUp
        self.editAccountPopUpV.cancelView.actionBlock {
            self.removeView(self.editAccountPopUpV)
        }
        
        // -- Open State Drop down in Edit Account PopUp
        self.editAccountPopUpV.stateView.actionBlock {
            resignTxtF()
            
            DropDownHandler.shared.showDropDownWithItems(self.editAccountPopUpV.stateView, self.statesArr, self.editAccountPopUpV.arrowImgV, "No State Available")
            DropDownHandler.shared.itemPickedBlock = { (index, item) in
                self.editAccountPopUpV.arrowImgV.image = Images.downArrow.name
                self.editAccountPopUpV.stateLbl.text = item
            }
            
            DropDownHandler.shared.cancelActionBlock = {
                self.editAccountPopUpV.arrowImgV.image = Images.downArrow.name
            }
            
            DropDownHandler.shared.willShowActionBlock = {
                self.editAccountPopUpV.arrowImgV.image = Images.upArrow.name
                resignTxtF()
            }
        }
        
        // -- To resign keyboard when drop down is selected
        func resignTxtF() {
            let txtFieldArr = [self.editAccountPopUpV.firstNameTxtF, self.editAccountPopUpV.lastNameTxtF, self.editAccountPopUpV.emailTxtF, self.editAccountPopUpV.addressTxtF, self.editAccountPopUpV.cityTxtF,  self.editAccountPopUpV.mobileNoTxtF, self.editAccountPopUpV.zipCodeTxtF, self.editAccountPopUpV.clubNameTxtF]
            txtFieldArr.forEach { textFields in
                textFields?.resignFirstResponder()
            }
        }
    }
    
    private func changePasswordAction() {
        // -- Hide and Unhide Current Password Action
        self.changePassPopUpV.currentPassHideBtn.actionBlock {
            self.secureCurrentPassword == true
            ? self.hideUnhideCurrentPass(false, Images.unhide.name, false)
            : self.hideUnhideCurrentPass(true, Images.hide.name, true)
        }
        
        // -- Hide and Unhide New Password Action
        self.changePassPopUpV.newPassHideBtn.actionBlock {
            self.secureNewPassword == true
            ? self.hideUnhideNewPass(false, Images.unhide.name, false)
            : self.hideUnhideNewPass(true, Images.hide.name, true)
        }
        
        // -- Hide and Unhide Confirm Password Action
        self.changePassPopUpV.confirmPassHideBtn.actionBlock {
            self.secureConfirmPassword == true
            ? self.hideUnhideConfirmPass(false, Images.unhide.name, false)
            : self.hideUnhideConfirmPass(true, Images.hide.name, true)
        }
   
        // -- Save Button in Change Password PopUp
        self.changePassPopUpV.resetPassV.actionBlock {
            let currentPass = self.changePassPopUpV.currentPassTxtF.text!
            let newPass = self.changePassPopUpV.newPassTxtF.text!
            let confirmPass = self.changePassPopUpV.confirmNewPassTxtF.text!
            self.myAccountViewModel?.changePassValid(self.view, currentPass, newPass, confirmPass)
        }
        
        // -- Cancel Button in Change Password PopUp
        self.changePassPopUpV.cancelV.actionBlock {
            self.removeView(self.changePassPopUpV)
        }
    }
    
    private func hideUnhideHandler() {
        self.changePassPopUpV.currentPassTxtF.isSecureTextEntry = true
        self.changePassPopUpV.newPassTxtF.isSecureTextEntry = true
        self.changePassPopUpV.confirmNewPassTxtF.isSecureTextEntry = true
        secureCurrentPassword = true
        secureNewPassword = true
        secureConfirmPassword = true
        self.changePassPopUpV.currentPassHideBtn.image = Images.hide.name
        self.changePassPopUpV.newPassHideBtn.image = Images.hide.name
        self.changePassPopUpV.confirmPassHideBtn.image = Images.hide.name
    }
    
    private func hideUnhideCurrentPass(_ secureText: Bool, _ image: UIImage, _ securePassword: Bool) {
        self.changePassPopUpV.currentPassTxtF.isSecureTextEntry = secureText
        self.changePassPopUpV.currentPassHideBtn.image = image
        self.secureCurrentPassword = securePassword
    }
    
    private func hideUnhideNewPass(_ secureText: Bool, _ image: UIImage, _ securePassword: Bool) {
        self.changePassPopUpV.newPassTxtF.isSecureTextEntry = secureText
        self.changePassPopUpV.newPassHideBtn.image = image
        self.secureNewPassword = securePassword
    }
    
    private func hideUnhideConfirmPass(_ secureText: Bool, _ image: UIImage, _ securePassword: Bool) {
        self.changePassPopUpV.confirmNewPassTxtF.isSecureTextEntry = secureText
        self.changePassPopUpV.confirmPassHideBtn.image = image
        self.secureConfirmPassword = securePassword
    }
}

// MARK: - AccountSettingsViewModelDelegate
extension MyAccountVC: AccountSettingsViewModelDelegate {
    func viewProfileSuccessCalled() {
        print("success")
    }
    
    func viewProfileErrorCalled(_ error: String) {
        HUD.flash(.labeledError(title: EMPTY_STR, subtitle: error), delay: 1.0)
    }
    
    func notificationsSuccessCalled() {
        HUD.hide()
        self.accountSettingsView.switchEnable.isOn = LocalStore.shared.getNotifications
    }
    func notificationsErrorCalled(_ error: String) {
        HUD.flash(.labeledError(title: EMPTY_STR, subtitle: error), delay: 1.0)
    }
}

// MARK: - Saved Searches
extension MyAccountVC {
    private func savedSearchesAction() {
        // -- Saved Searches
        savedSearchesBtn.actionBlock {
            self.scrollV.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
            self.remove(asChildViewController: self.accountSettingsView)
            self.add(asChildViewController: self.savedSearchesView, self.containerV)
            MyAccountButtonUI().setSavedSearchesBtnUI(self.accountSettingsBtn, self.savedSearchesBtn)
            self.setSavedSearchesApi()
        }
    }
}

// MARK: - SavedSearchesViewModelDelegate
extension MyAccountVC: SavedSearchesViewModelDelegate {
    func savedSearchSuccessCalled(_ tableView: UITableView) {
        HUD.hide()
    }
    func savedSearchErrorCalled(_ error: String) {
        HUD.flash(.labeledError(title: EMPTY_STR, subtitle: error), delay: 1.0)
    }
    func deleteSearchSuccessCalled(_ success: String, _ userSearchID: Int, _ index: IndexPath) {
        DispatchQueue.main.async {
            self.setSavedSearchesApi()
            HUD.flash(.label(success), delay: 1.0)
        }
    }
    func deleteSearchErrorCalled(_ error: String) {
        HUD.flash(.labeledError(title: EMPTY_STR, subtitle: error), delay: 1.0)
    }
}

// MARK: - UITextFields Delegates
extension MyAccountVC: UITextFieldDelegate {
    //vish
//    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
//        // Verify all the conditions
//        if let sdcTextField = textField as? TextFieldInset {
//            return sdcTextField.verifyFields(shouldChangeCharactersIn: range, replacementString: string)
//        }
//        return true
//    }
}
