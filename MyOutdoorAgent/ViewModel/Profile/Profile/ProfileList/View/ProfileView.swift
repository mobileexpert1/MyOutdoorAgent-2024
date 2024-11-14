//  ProfileView.swift
//  MyOutdoorAgent
//  Created by CS on 29/08/22.

import UIKit

class ProfileView: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var profileTopViewHeight: NSLayoutConstraint!
    @IBOutlet weak var profileBgV: UIImageView!
    @IBOutlet weak var profileUserNameLbl: UILabel!
    @IBOutlet weak var profileImgV: UIImageView!
    @IBOutlet weak var myAccountV: UIView!
    @IBOutlet weak var myLicensesV: UIView!
    @IBOutlet weak var helpV: UIView!
    @IBOutlet weak var preApprovalV: UIView!
    @IBOutlet weak var contactUsV: UIView!
    @IBOutlet weak var privacyPolicyV: UIView!
    @IBOutlet weak var profileBgVinScrollV: UIImageView!
    @IBOutlet weak var profileImgVinScrollV: UIImageView!
    @IBOutlet weak var profileUserNameinScrollV: UILabel!
    @IBOutlet weak var profileTopViewInScrollVHeight: NSLayoutConstraint!
    @IBOutlet weak var mainProfileVInScrollV: UIView!
    @IBOutlet weak var mainProfileV: UIView!
    @IBOutlet weak var profileScrollV: UIScrollView!
    
    @IBOutlet weak var deleteAccount: UIView!
    // MARK: - ViewLifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        onViewLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        onViewAppear()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    // MARK: - ViewDidLayoutSubviews
    override func viewDidLayoutSubviews() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.profileBgVinScrollV.roundCorners(corners: [.bottomLeft, .bottomRight], radius: 20)
            self.profileBgV.roundCorners(corners: [.bottomLeft, .bottomRight], radius: 20)
            self.setUI()
        }
    }
    
    // MARK: - Set Status Bar Style
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .lightContent
    }
    
    // MARK: - Functions
    private func onViewLoad() {
        LocalStore.shared.isScreenHandler = false
        showNavigationBar(false)
    }
    
    private func onViewAppear() {
        profileScrollV.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
       
        setUIinScrollV()
        setUIinMainV()
        setActions()
        
        if LocalStore.shared.isScreenHandler {
            LocalStore.shared.isScreenHandler = false
            self.tabBarController?.selectedIndex = 1
        }
    }
    
    private func setUI() {
        if UIDevice.current.userInterfaceIdiom == .pad {
            self.mainProfileVInScrollV.isHidden = true
            profileTopViewInScrollVHeight.constant = 0
            profileTopViewHeight.constant = 320
        } else {
            if let orientation = self.view.window?.windowScene?.interfaceOrientation {
                if orientation == .landscapeLeft || orientation == .landscapeRight {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                        self.mainProfileVInScrollV.isHidden = false
                        self.profileTopViewInScrollVHeight.constant = 210
                        self.profileTopViewHeight.constant = 0
                    }
                } else {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                        self.mainProfileVInScrollV.isHidden = true
                        self.profileTopViewInScrollVHeight.constant = 0
                        self.profileTopViewHeight.constant = 290
                    }
                }
            }
        }
    }
    
    private func setUIinScrollV() {
        profileUserNameinScrollV.text = LocalStore.shared.name
        
        UIDevice.current.userInterfaceIdiom == .phone
        ? (profileImgVinScrollV.cornerRadius = 55)
        : (profileImgVinScrollV.cornerRadius = 65)
    }
    
    private func setUIinMainV() {
        profileUserNameLbl.text = LocalStore.shared.name
        UIDevice.current.userInterfaceIdiom == .phone
        ? (profileImgV.cornerRadius = 55)
        : (profileImgV.cornerRadius = 65)
    }
    
    private func setActions() {
        // My Account
        myAccountV.actionBlock {
            LocalStore.shared.isScreenHandler = false
            self.pushOnly(Storyboards.myAccountView.name, Controllers.myAccount.name, true)
        }
        
        // My Licenses
        myLicensesV.actionBlock {
            self.pushOnly(Storyboards.myLicencesView.name, Controllers.myLicenses.name, true)
        }
        
        // Pre-Approval
        preApprovalV.actionBlock {
            self.pushOnly(Storyboards.preApprovalReqView.name, Controllers.preApprovalReq.name, true)
        }
        
        // Help
        helpV.actionBlock {
            self.pushOnly(Storyboards.helpView.name, Controllers.help.name, true)
        }
        
        // Contact Us
        contactUsV.actionBlock {
            self.pushOnly(Storyboards.contactUsView.name, Controllers.contactUs.name, true)
        }
        
        // Privacy Policy
        privacyPolicyV.actionBlock {
            self.pushOnly(Storyboards.privacyPolicyView.name, Controllers.privacyPolicyVC.name, true)
        } 
        
        deleteAccount.actionBlock {
            self.showAlert()
        }
    }
    
    var deleteAction: UIAlertAction?
    @objc func switchChanged(_ sender: UISwitch) {
           // Enable/disable the Delete button based on the switch state
           deleteAction?.isEnabled = sender.isOn
       }
    @objc func alertControllerBackgroundTapped() {
            self.dismiss(animated: true, completion: nil)
        }
    
    private func showAlert() {
        let alertController = UIAlertController(title: "Delete Account", message: "\n\n\n\n", preferredStyle: .alert)
              
              // Create a custom UIView for the checkbox and label
              let customView = UIView(frame: CGRect(x: 0, y: 0, width: 250, height: 70))
              
              let checkbox = UISwitch(frame: CGRect(x: 10, y: 10, width: 0, height: 0))
              checkbox.addTarget(self, action: #selector(self.switchChanged(_:)), for: .valueChanged)
              
              let label = UILabel(frame: CGRect(x: 70, y: 10, width: 200, height: 50))
              label.text = "I Confirm"
              label.numberOfLines = 2
              
              customView.addSubview(checkbox)
              customView.addSubview(label)
              
              alertController.view.addSubview(customView)
              
              // Add the Delete button
              let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { _ in
                  // Handle the account deletion logic here
                  print("Account deleted")
              }
              deleteAction.isEnabled = false // Disable the Delete button initially
              alertController.addAction(deleteAction)
              
              // Add the Cancel button
              let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
              alertController.addAction(cancelAction)
              
              // Present the alert controller
              self.present(alertController, animated: true, completion: {
                  alertController.view.superview?.isUserInteractionEnabled = true
                  alertController.view.superview?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.alertControllerBackgroundTapped)))
              })
              
              // Store the delete action to enable/disable it later
              self.deleteAction = deleteAction
          }

    
}

// MARK: - ViewWillTransitiond
extension ProfileView {
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        guard tabBarController?.selectedIndex == 3 else { return }
        profileScrollV.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
        setViewSize()
    }
    
    private func setViewSize() {
        if UIDevice.current.userInterfaceIdiom == .pad {
            self.mainProfileVInScrollV.isHidden = true
            profileTopViewInScrollVHeight.constant = 0
            profileTopViewHeight.constant = 320
        } else {
            if (UIDevice.current.orientation == .landscapeLeft) || (UIDevice.current.orientation == .landscapeRight) {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                    self.mainProfileVInScrollV.isHidden = false
                    self.profileTopViewInScrollVHeight.constant = 210
                    self.profileTopViewHeight.constant = 0
                }
            } else {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                    self.mainProfileVInScrollV.isHidden = true
                    self.profileTopViewInScrollVHeight.constant = 0
                    self.profileTopViewHeight.constant = 290
                }
            }
        }
    }
}
