//  AccountSettingsVC.swift
//  MyOutdoorAgent
//  Created by CS on 08/08/22.

import UIKit
import PKHUD

class AccountSettingsVC: UIViewController {
    
    // MARK: - Variables
    var imagePicker = UIImagePickerController()
    var imgStr = String()
    
    // MARK: - Outlets
    @IBOutlet weak var btnDelete: UIButton!
    @IBOutlet weak var profileImgV: UIImageView!
    @IBOutlet weak var editBtn: UIImageView!
    @IBOutlet weak var switchEnable: UISwitch!
    @IBOutlet weak var nameTxtF: UITextFieldPadding!
    @IBOutlet weak var emailTxtF: UITextFieldPadding!
    @IBOutlet weak var mobileNoTxtF: UITextFieldPadding!
    @IBOutlet weak var addressTxtF: UITextFieldPadding!
    @IBOutlet weak var clubNameTxtF: UITextFieldPadding!
    @IBOutlet weak var cameraV: UIView!
    @IBOutlet weak var cameraBtn: UIButton!
    @IBOutlet weak var changePassV: UIView!
    
    // MARK: - ViewLifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        onViewLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        onViewAppear()
    }
    
    // MARK: - Functions
    private func onViewLoad() {
        setDelegates()
    }
    
    private func onViewAppear() {
        setUI()
    }
    
    private func setDelegates() {
        imagePicker.delegate = self
    }
    
    private func setUI() {
        switchEnable.isOn = LocalStore.shared.getNotifications
        UIDevice.current.userInterfaceIdiom == .phone
        ? setView(0.65, 0.65, 40, 18)
        : setView(1.0, 1.0, 60, 22)
    }
    
    private func setView(_ scaleX: CGFloat, _ y: CGFloat, _ profileImgCornerRadius: CGFloat, _ cameraVCornerRadius: CGFloat) {
        switchEnable.transform = CGAffineTransform(scaleX: scaleX, y: y)
        self.profileImgV.cornerRadius = profileImgCornerRadius
        self.cameraV.cornerRadius = cameraVCornerRadius
    }
    
    // MARK: - Action Block
    // -- Camera Button
    @IBAction func cameraBtnClick(_ sender: UIButton) {
        showUploadImgAlert(sender)
    }
    
    @IBAction func btnDeleteAction(_ sender: Any) {
        guard let vc = self.storyboard?.instantiateViewController(identifier: "CustomDeleteView") as? CustomDeleteView else { return }
        vc.modalPresentationStyle = .overCurrentContext
        self.navigationController?.present(vc, animated: false)
    }
}
