//  ListYourPropertyVC.swift
//  MyOutdoorAgent
//  Created by CS on 05/08/22.

import UIKit
import PKHUD
import DropDown

class ListYourPropertyVC: UIViewController {
    
    // MARK: - Objects
    private var listYourPropertyViewModel: ListYourPropertyViewModel?
    
    // MARK: - Variables
    var getAllStatesArr = [GetAllStatesModelClass]()
    var statesArr = [String]()
    
    // MARK: - Outlets
    @IBOutlet weak var customNavBar: CustomNavBar!
    @IBOutlet weak var firstNameTxtF: UITextFieldPadding!
    @IBOutlet weak var lastNameTxtF: UITextFieldPadding!
    @IBOutlet weak var emailTxtF: UITextFieldPadding!
    @IBOutlet weak var phoneTxtF: TextFieldInset!
    @IBOutlet weak var stateLbl: UILabel!
    @IBOutlet weak var submitBtn: UIView!
    @IBOutlet weak var selectStateV: UIView!
    @IBOutlet weak var stateArrowImgV: UIImageView!
    @IBOutlet weak var addressTxtF: UITextFieldPadding!
    @IBOutlet weak var zipTxtF: TextFieldInset!
    @IBOutlet weak var cityTxtF: UITextFieldPadding!
    @IBOutlet weak var landOwnerLbl: UILabel!
    @IBOutlet weak var landOwnerView: UIView!
    @IBOutlet weak var landOwnerArrowImgV: UIImageView!
    @IBOutlet weak var changePlanLbl: UILabel!
    @IBOutlet weak var subscriptionTypeV: UITextFieldPadding!
    
    // MARK: - ViewLifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        onViewLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        onViewAppear()
    }
    
    // MARK: - Functions
    private func onViewLoad() {
        setUI()
        actionBlock()
    }
    
    private func onViewAppear() {
        getAllStatesApi()
    }
    
    private func setUI() {
        showNavigationBar(false)
        setcustomNav(customView: customNavBar, titleIsHidden: false, titleText: NavigationTitle.listYourProperty.name, navViewColor: Colors.grey.value, mainViewColor: Colors.grey.value, backImg: Images.back.name)
        listYourPropertyViewModel = ListYourPropertyViewModel(self)
        phoneTxtF.maxLength = 10
        zipTxtF.maxLength = 5
    }
    
    private func actionBlock() {
        // -- Submit Button
        submitBtn.actionBlock {
            self.listYourPropertyViewModel?.checkEmptyFields(self.view, self.landOwnerLbl.text!, self.firstNameTxtF.text!, self.lastNameTxtF.text!, self.phoneTxtF.text!, self.emailTxtF.text!, self.addressTxtF.text!, self.cityTxtF.text!, self.stateLbl.text!, self.zipTxtF.text!, "Basic")
        }
        
        // -- Select State
        selectStateV.actionBlock {
            self.resignTxtF()
            DropDownHandler.shared.showDropDownWithItems(self.selectStateV, self.statesArr, self.stateArrowImgV, "No State Found")
            DropDownHandler.shared.itemPickedBlock = { (index, item) in
                self.stateArrowImgV.image = Images.downArrow.name
                self.stateLbl.text = item
            }
            
            DropDownHandler.shared.cancelActionBlock = {
                self.stateArrowImgV.image = Images.downArrow.name
            }
        }
        
        // -- Landowner Type
        landOwnerView.actionBlock {
            self.resignTxtF()
            let selectTypeArr = [CommonKeys.individual.name, CommonKeys.business.name]
            DropDownHandler.shared.showDropDownWithItems(self.landOwnerView, selectTypeArr, self.landOwnerArrowImgV, "No Data Found")
            DropDownHandler.shared.itemPickedBlock = { (index, item) in
                self.landOwnerArrowImgV.image = Images.downArrow.name
                self.landOwnerLbl.text = item
            }
            
            DropDownHandler.shared.cancelActionBlock = {
                self.landOwnerArrowImgV.image = Images.downArrow.name
            }
        }
        
        // -- Change Plan
        changePlanLbl.actionBlock {
            self.popOnly()
        }
    }
    
    // -- To resign keyboard when drop down is selected
    private func resignTxtF() {
        let txtFieldArr = [self.firstNameTxtF, self.lastNameTxtF, self.phoneTxtF, self.emailTxtF, self.addressTxtF, self.cityTxtF, self.zipTxtF]
        txtFieldArr.forEach { textFields in
            textFields?.resignFirstResponder()
        }
    }
    
    // MARK: - Web Service
    private func getAllStatesApi() {
        self.listYourPropertyViewModel?.getAllStatesApi(self.view, completion: { responseModel in
            self.getAllStatesArr = responseModel
            
            self.statesArr.removeAll()
            for i in 0..<self.getAllStatesArr.count {
                self.statesArr.append(self.getAllStatesArr[i].stateName!)
            }
            
        })
    }
}

// MARK: - ListYourPropertyViewModelDelegate
extension ListYourPropertyVC: ListYourPropertyViewModelDelegate {
    func successCalled(_ success: String) {
        DispatchQueue.main.async {
            HUD.hide()
            let okBtn = [ButtonText.ok.text]
            UIAlertController.showAlert(EMPTY_STR, message: success, buttons: okBtn) { alert, index in
                if index == 0 {
                    self.popOnly()
                }
            }
        }
    }
    func errorCalled(_ error: String) {
        HUD.flash(.labeledError(title: EMPTY_STR, subtitle: error), delay: 1.0)
    }
    func getStatesSuccessCalled() {
        HUD.hide()
    }
    func getStatesErrorCalled(_ error: String) {
        HUD.flash(.labeledError(title: EMPTY_STR, subtitle: error), delay: 1.0)
    }
}

// MARK: - UITextFields Delegates
extension ListYourPropertyVC: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // Verify all the conditions
        if let sdcTextField = textField as? TextFieldInset {
            return sdcTextField.verifyFields(shouldChangeCharactersIn: range, replacementString: string)
        }
        return true
    }
}
