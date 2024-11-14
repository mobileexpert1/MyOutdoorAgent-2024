//  FilterView.swift
//  MyOutdoorAgent
//  Created by CS on 28/09/22.

import UIKit

class FilterView: UIView {
    
    // MARK: - Outlets
    @IBOutlet weak var permitsImgV: UIImageView!
    @IBOutlet weak var rulImgV: UIImageView!
    @IBOutlet weak var selectCountyV: UIView!
    @IBOutlet weak var countyArrowV: UIImageView!
    @IBOutlet weak var selectCountyLbl: UILabel!
    @IBOutlet weak var selectStateV: UIView!
    @IBOutlet weak var selectStateArrowV: UIImageView!
    @IBOutlet weak var selectStateLbl: UILabel!
    @IBOutlet weak var crossBtn: UIImageView!
    @IBOutlet weak var reloadBtn: UIImageView!
    @IBOutlet weak var minAcresTxtF: UITextFieldPadding!
    @IBOutlet weak var maxAcresTxtF: UITextFieldPadding!
    @IBOutlet weak var minPriceTxtF: UITextFieldPadding!
    @IBOutlet weak var maxPriceTxtF: UITextFieldPadding!
    @IBOutlet weak var saveSearchV: UIView!
    @IBOutlet weak var searchV: UIView!
    @IBOutlet weak var filterVTopHeight: NSLayoutConstraint!
    @IBOutlet weak var filterVBottomHeight: NSLayoutConstraint!
    @IBOutlet weak var crossBtnTopHeight: NSLayoutConstraint!
    @IBOutlet weak var crossBtnTrailingHeight: NSLayoutConstraint!
    @IBOutlet weak var activitiesCVHeight: NSLayoutConstraint!
    @IBOutlet weak var amenitiesCVHeight: NSLayoutConstraint!
    @IBOutlet weak var filterScrollV: UIScrollView!
}
