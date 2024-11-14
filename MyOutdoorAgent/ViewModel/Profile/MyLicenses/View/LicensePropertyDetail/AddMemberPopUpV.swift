//  AddMemberPopUpV.swift
//  MyOutdoorAgent
//  Created by CS on 03/11/22.

import UIKit

class AddMemberPopUpV: UIView {
    @IBOutlet weak var firstNameTxtF: TextFieldInset!
    @IBOutlet weak var lastNameTxtF: TextFieldInset!
    @IBOutlet weak var emailTxtF: TextFieldInset!
    @IBOutlet weak var addressTxtF: TextFieldInset!
    @IBOutlet weak var phoneNumberTxtF: TextFieldInset!
    @IBOutlet weak var zipCodeTxtF: TextFieldInset!
    @IBOutlet weak var cityTxtF: TextFieldInset!
    @IBOutlet weak var stateV: UIView!
    @IBOutlet weak var stateLbl: UILabel!
    @IBOutlet weak var stateImgV: UIImageView!
    @IBOutlet weak var saveChangesBtn: UIView!
    @IBOutlet weak var cancelBtn: UIView!
    @IBOutlet weak var memberVTop: NSLayoutConstraint!
    @IBOutlet weak var memberVBottom: NSLayoutConstraint!
}
