//
//  CustomDeleteView.swift
//  MyOutdoorAgent
//
//  Created by PRITISH on 09/08/24.
//

import UIKit
import PKHUD

class CustomDeleteView: UIViewController, HomeViewModelDelegate {
  
    @IBOutlet weak var lblDetails: UILabel!
    @IBOutlet weak var imgVwCheckBox: UIImageView!
    @IBOutlet weak var viewCheckBox: UIView!
    @IBOutlet weak var btnDelete: UIButton!
    @IBOutlet weak var btnCancel: UIButton!
    @IBOutlet weak var contentView: UIView!
    var homeViewModelArr: HomeViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
        delegate()
    }
    
    func setUpUI() {
        self.lblDetails.attributedText = createAttributedText()
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        self.contentView.layer.cornerRadius = 10
        self.contentView.layer.masksToBounds = true
        self.contentView.clipsToBounds = true
        self.btnCancel.layer.cornerRadius = 5
        self.btnCancel.layer.masksToBounds = true
        self.btnCancel.clipsToBounds = true
        self.btnDelete.layer.cornerRadius = 5
        self.btnDelete.layer.masksToBounds = true
        self.btnDelete.clipsToBounds = true
        btnCancel.backgroundColor = UIColor(named: "DeleteBG")?.withAlphaComponent(0.2)
        imgVwCheckBox.image = UIImage(named: "uncheck")
        btnCancel.isEnabled = false
    }
    
    func delegate() {
        homeViewModelArr = HomeViewModel(self)
        homeViewModelArr?.delegate = self
    }
    
    @IBAction func btnDelet(_ sender: Any) {
        self.dismiss(animated: false)
    }
    
    @IBAction func btnCancel(_ sender: Any) {
        self.homeViewModelArr?.deleteAccountApi(self.view, completion: { responseModel in
               print(responseModel)
           })
    }
    
    @IBAction func btnCheckBox(_ sender: Any) {
        if imgVwCheckBox.image == UIImage(named: "uncheck") {
            imgVwCheckBox.image = UIImage(named: "checked-box")
        } else {
            imgVwCheckBox.image = UIImage(named: "uncheck")
        }
        if imgVwCheckBox.image == UIImage(named: "uncheck") {
            btnCancel.isEnabled = false
            btnCancel.backgroundColor = UIColor(named: "DeleteBG")?.withAlphaComponent(0.2)
        } else {
            btnCancel.backgroundColor = UIColor(named: "DeleteBG")?.withAlphaComponent(1.0)
            btnCancel.isEnabled = true
        }
    }
    
    func createAttributedText() -> NSAttributedString {
        let string = self.lblDetails.text
        let attributedString = NSMutableAttributedString(string: string!)

        // Set the color for the word "sample"
        let range = (string! as NSString).range(of: self.lblDetails.text!)
        attributedString.addAttribute(.foregroundColor, value: UIColor.darkGray.withAlphaComponent(0.9), range: range)

        return attributedString
    }
    
}


