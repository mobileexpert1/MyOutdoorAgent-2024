//  HomeTopView.swift
//  MyOutdoorAgent
//  Created by CS on 05/11/22.

import UIKit

class HomeTopView: UIView {
    
    //MARK: - Variables
    var contentView: UIView?
    
    // MARK: - Outlets
    @IBOutlet weak var userNameLbl: UILabel!
    @IBOutlet weak var userProfileImg: UIImageView!
    @IBOutlet weak var searchTxtV: UIView!
    @IBOutlet weak var searchTxtF: UITextField!
    @IBOutlet weak var selectAmenityV: UIView!
    @IBOutlet weak var selectAmenityImgV: UIImageView!
    @IBOutlet weak var searchMainView: UIView!
    @IBOutlet weak var searchView: UIView!
    @IBOutlet weak var cornerView: UIView!
    @IBOutlet weak var selectAmenityLbl: UILabel!
    @IBOutlet weak var userNameTop: NSLayoutConstraint!
    @IBOutlet weak var homeTopVHeight: NSLayoutConstraint!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        guard let view = loadViewFromNib() else { return }
        view.frame = self.bounds
        self.addSubview(view)
        contentView = view
    }
    
    private func loadViewFromNib() -> UIView? {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: CustomView.homeTopView.name, bundle: bundle)
        return nib.instantiate(withOwner: self, options: nil).first as? UIView
    }
}
