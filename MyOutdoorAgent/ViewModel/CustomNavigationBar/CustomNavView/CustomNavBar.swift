//  CustomNavBar.swift
//  MyOutdoorAgent
//  Created by CS on 04/08/22.

import UIKit

class CustomNavBar: UIView {
    
    //MARK: - Variables
    var contentView: UIView?
    
    // MARK: - Outlets
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var navView: UIView!
    @IBOutlet weak var backBtn: UIImageView!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        guard let view = loadViewFromNib() else { return }
        view.frame = self.bounds
        self.addSubview(view)
        contentView = view
    }
    
    private func loadViewFromNib() -> UIView? {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: CustomView.customNavBar.name, bundle: bundle)
        return nib.instantiate(withOwner: self, options: nil).first as? UIView
    }
}
