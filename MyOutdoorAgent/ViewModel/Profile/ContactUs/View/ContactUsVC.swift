//  ContactUsVC.swift
//  MyOutdoorAgent
//  Created by CS on 04/08/22.

import UIKit
import PKHUD

class ContactUsVC: UIViewController {
    
    // MARK: - Objects
    private var contactUsViewModel: ContactUsViewModel?
    
    // MARK: - Outlets
    @IBOutlet weak var customNavBar: CustomNavBar!
    @IBOutlet weak var submitBtn: UIView!
    @IBOutlet weak var nameTxtF: UITextFieldPadding!
    @IBOutlet weak var emailTxtF: UITextFieldPadding!
    @IBOutlet weak var descriptionTxtV: UITextView!
    
    @IBOutlet weak var txtEmail: UITextFieldPadding!
    
    @IBOutlet weak var selectAmenityImgV: UIImageView!
    
    @IBOutlet weak var discription_V: UIView!
    @IBOutlet weak var lblChoose: UILabel!
    
    @IBOutlet weak var viewdrop: UIView!
    @IBOutlet weak var btncheckbox: UIButton!
    var userProfileModel : UserProfileModelClass?
    var dropdownView: DropdownView!
    var seletedtext = ""
       var isChecked: Bool = false {
           didSet {
               if isChecked {
                   btncheckbox.setImage(UIImage(named: "sele"), for: .normal)
                   lblChoose.text = "RLU# or Permit Name"
                   self.txtEmail.placeholder = "Enter RLU# or Permit Name"
                   self.txtEmail.text = ""
                   selectAmenityImgV.isHidden = true
                   self.txtEmail.isUserInteractionEnabled = true
                 //  self.dropdownView.removeFromSuperview()
               } else {
                   btncheckbox.setImage(UIImage(named: "unsl"), for: .normal)
                   lblChoose.text = "Choose an option"
                   self.txtEmail.placeholder = "Select an option"
                   self.txtEmail.isUserInteractionEnabled = false
                   self.txtEmail.text = seletedtext
                   selectAmenityImgV.isHidden = false
               }
           }
       }
    // MARK: - ViewLifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        print ("usename--", LocalStore.shared.usename)
        print ("usename--", LocalStore.shared.userEmail)
        nameTxtF.text = LocalStore.shared.usename
        emailTxtF.text = LocalStore.shared.userEmail
        onViewLoad()
        isChecked = false
        
    }
    
    // MARK: - Functions
    private func onViewLoad() {
        setUI()
        actionBlock()
    }
    
    @IBAction func checkboxTapped(_ sender: Any) {
        isChecked.toggle()
    }
    
    
    private func setUI() {
        showNavigationBar(false)
        setcustomNav(customView: customNavBar, titleIsHidden: false, titleText: NavigationTitle.contactUs.name, navViewColor: Colors.grey.value, mainViewColor: Colors.grey.value, backImg: Images.back.name)
        contactUsViewModel = ContactUsViewModel(self)
    }
    
    private func actionBlock() {
        submitBtn.actionBlock {
            self.contactUsViewModel?.checkEmptyFields(self.view, self.nameTxtF.text!, self.emailTxtF.text!, self.descriptionTxtV.text!, self.txtEmail.text!)
        }
        
        selectAmenityImgV.actionBlock {
            self.showDropdown()
            
        }
    }
    
    func showDropdown() {
           let dropdownHeight: CGFloat = 180
        let topInset: CGFloat = 450
           let dropdownFrame = CGRect(x: 150, y: topInset, width: 220, height: dropdownHeight)
           dropdownView = DropdownView(frame: dropdownFrame)
           
           dropdownView.items = ["Account login", "Inquiring about a property", "Other"]
           dropdownView.didSelectItem = { [weak self] selectedItem in
               guard let self = self else { return }
               print("Selected item: \(selectedItem)")
               self.seletedtext = selectedItem
               DispatchQueue.main.async {
                   self.txtEmail.text = selectedItem
                  
               }
               self.dropdownView.removeFromSuperview()
           }
        dropdownView.backgroundColor = UIColor.white
        dropdownView.layer.borderWidth = 1.0
        dropdownView.layer.borderColor = UIColor.lightGray.cgColor
           self.view.addSubview(dropdownView)
        
       }
    
  
}
// MARK: - ContactUsViewModelDelegate
extension ContactUsVC: ContactUsViewModelDelegate {
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
}
